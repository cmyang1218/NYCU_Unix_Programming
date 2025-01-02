#define _GNU_SOURCE
#include <elf.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdarg.h>
#include <stdbool.h>
#include <unistd.h>
#include <dlfcn.h>
#include <fcntl.h>
#include <assert.h>
#include <errno.h>
#include <netdb.h>
#include <sys/mman.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <arpa/inet.h>

#define BUF_SIZE 1024
#define READ_BUF_SIZE 131072

long base_min = 0, base_max = 0;
long got_min = 0, got_max = 0;

bool check_open_config(char* config, const char* pathname){
    FILE* fp = fopen(config, "r");
    if(fp == NULL){
        perror("open_config/fopen()");
        exit(EXIT_FAILURE);
    }
    char *buf = NULL;
    size_t sz = 0;
    bool record = false, blacklist = false;
    const char *begin = "BEGIN open-blacklist", *end = "END open-blacklist";
    while((sz = getline(&buf, &sz, fp)) != -1){
        buf[sz-1] = '\0';
        if(strncmp(buf, begin, strlen(begin)) == 0){
            record = true;
        }else if(strncmp(buf, end, strlen(end)) == 0){
            record = false;
            break;
        }else if(record && strncmp(buf, pathname, strlen(pathname)) == 0){
            blacklist = true;
            break;
        }
    }
    fclose(fp);
    return blacklist;
}

int (*hijack_open_ptr)(const char *pathname, int flags, ...) = NULL;
int hijack_open(const char *pathname, int flags, ...){
    mode_t mode = 0;
    if(flags == O_CREAT || flags == O_TMPFILE){
        va_list val;
        va_start(val, flags);
        mode = va_arg(val, mode_t);
    }
    int env_fd = atoi(getenv("LOGGER_FD"));
    char* config = getenv("SANDBOX_CONFIG");
    struct stat st;
    lstat(pathname, &st);
    char correct_path[BUF_SIZE];
    memset(correct_path, 0x00, BUF_SIZE);
    if(S_ISLNK(st.st_mode)){
        readlink(pathname, correct_path, BUF_SIZE);
    }else{
        strcpy(correct_path, pathname);
    }
    bool blacklist = check_open_config(config, correct_path);
    if(blacklist){
        errno = EACCES;
        dprintf(env_fd, "[logger] open(\"%s\", %d, %u) = -1\n", correct_path, flags, mode);
        return -1;
    }
    int fd = open(pathname, flags, mode);
    dprintf(env_fd, "[logger] open(\"%s\", %d, %u) = %d\n", correct_path, flags, mode, fd);
    return fd;
}

bool check_read_config(char* config, const char* filter){
    FILE* filter_fp = fopen(filter, "r");
    if(filter_fp == NULL){
        perror("read_config/filter/fopen()");
        exit(EXIT_FAILURE);
    }
    char read_buf[READ_BUF_SIZE];
    memset(read_buf, 0x00, sizeof(read_buf));
    fread(read_buf, sizeof(char), READ_BUF_SIZE, filter_fp);
    fclose(filter_fp);
    
    FILE* fp = fopen(config, "r");
    if(fp == NULL){
        perror("read_config/fopen()");
        exit(EXIT_FAILURE);
    }
    char *buf = NULL;
    size_t sz = 0;
    bool record = false, blacklist = false;
    const char *begin = "BEGIN read-blacklist", *end = "END read-blacklist";
    while((sz = getline(&buf, &sz, fp)) != -1){
        buf[sz-1] = '\0';
        if(strncmp(buf, begin, strlen(begin)) == 0){
            record = true;
        }else if(strncmp(buf, end, strlen(end)) == 0){
            record = false;
            break;
        }else if(record && strstr(read_buf, buf) != NULL){
            blacklist = true;
            break;
        }
    }
    fclose(fp);
    return blacklist;
}

ssize_t (*hijack_read_ptr)(int fd, void *buf, size_t count) = NULL;
ssize_t hijack_read(int fd, void* buf, size_t count){
    int env_fd = atoi(getenv("LOGGER_FD"));
    char* config = getenv("SANDBOX_CONFIG");
    pid_t pid = getpid();
    char fdlink[BUF_SIZE], linkfile[BUF_SIZE], filter[BUF_SIZE*2];
    memset(fdlink, 0x00, sizeof(fdlink));
    memset(linkfile, 0x00, sizeof(linkfile));
    sprintf(fdlink, "/proc/self/fd/%d", fd);
    readlink(fdlink, linkfile, sizeof(linkfile));
    for(int i = 0; i < strlen(linkfile); ++i){
        if(linkfile[i] == '/' || linkfile[i] == '.') 
            linkfile[i] = '_';
    }
    sprintf(filter, "filter-%s.log", linkfile);

    FILE* filter_fp = fopen(filter, "a");
    char tmp_buf[READ_BUF_SIZE];
    memset(tmp_buf, 0x00, sizeof(tmp_buf));
    ssize_t rd_sz = read(fd, tmp_buf, count);
    fwrite(tmp_buf, sizeof(char), rd_sz, filter_fp);
    fclose(filter_fp);

    char logfile[BUF_SIZE];
    memset(logfile, 0x00, sizeof(logfile));
    sprintf(logfile, "%d-%d-read.log", pid, fd);
    FILE* log_fp = fopen(logfile, "a");

    bool blacklist = check_read_config(config, filter);
    if(blacklist){
        errno = EIO;
        dprintf(env_fd, "[logger] read(%d, %p, %ld) = -1\n", fd, buf, count);
        close(fd);
        return -1;
    }
    memcpy(buf, tmp_buf, rd_sz);
    fwrite(buf, sizeof(char), rd_sz, log_fp);
    dprintf(env_fd, "[logger] read(%d, %p, %ld) = %ld\n", fd, buf, count, rd_sz);
    fclose(log_fp);
    return rd_sz;
}

ssize_t (*hijack_write_ptr)(int fd, const void* buf, size_t count) = NULL;
ssize_t hijack_write(int fd, const void* buf, size_t count){
    int env_fd = atoi(getenv("LOGGER_FD"));
    pid_t pid = getpid();
    char logfile[BUF_SIZE];
    memset(logfile, 0x00, sizeof(logfile));
    sprintf(logfile, "%d-%d-write.log", pid, fd);
    FILE* log_fp = fopen(logfile, "a");
    ssize_t wr_sz = write(fd, buf, count);
    fwrite(buf, sizeof(char), wr_sz, log_fp);
    dprintf(env_fd, "[logger] write(%d, %p, %ld) = %ld\n", fd, buf, count, wr_sz);
    fclose(log_fp);
    return wr_sz;
}

bool check_getaddrinfo_config(char* config, const char* hostname){
    FILE* fp = fopen(config, "r");
    if(fp == NULL){
        perror("getaddrinfo_config/fopen()");
        exit(EXIT_FAILURE);
    }
    char *buf = NULL;
    size_t sz = 0;
    bool record = false, blacklist = false;
    const char *begin = "BEGIN getaddrinfo-blacklist", *end = "END getaddrinfo-blacklist";
    while((sz = getline(&buf, &sz, fp)) != -1){
        buf[sz-1] = '\0';
        if(strncmp(buf, begin, strlen(begin)) == 0){
            record = true;
        }else if(strncmp(buf, end, strlen(end)) == 0){
            record = false;
            break;
        }else if(record && strncmp(buf, hostname, strlen(hostname)) == 0){
            blacklist = true;
            break;
        }
    }
    fclose(fp);
    return blacklist;
}

int (*hijack_getaddrinfo_ptr)(const char *node, const char *service, const struct addrinfo *hints, struct addrinfo **res) = NULL;
int hijack_getaddrinfo(const char *node, const char *service, const struct addrinfo *hints, struct addrinfo **res){
    int env_fd = atoi(getenv("LOGGER_FD"));
    char* config = getenv("SANDBOX_CONFIG");
    bool blacklist = check_getaddrinfo_config(config, node);
    if(blacklist){
        errno = EAI_NONAME;
        dprintf(env_fd, "[logger] getaddrinfo(\"%s\", \"%s\", %p, %p) = %d\n", node, service, hints, res, errno);
        return errno;
    }
    int ret = getaddrinfo(node, service, hints, res);
    dprintf(env_fd, "[logger] getaddrinfo(\"%s\", \"%s\", %p, %p) = %d\n", node, service, hints, res, ret);
    return ret;
}

bool check_connect_config(char* config, const char* host_ip, uint16_t host_port){
    FILE* fp = fopen(config, "r");
    if(fp == NULL){
        perror("connect_config/fopen()");
        exit(EXIT_FAILURE);
    }
    char *buf = NULL;
    size_t sz = 0;
    bool record = false, blacklist = false;
    const char *begin = "BEGIN connect-blacklist", *end = "END connect-blacklist";
    while((sz = getline(&buf, &sz, fp)) != -1){
        buf[sz-1] = '\0';
        if(strncmp(buf, begin, strlen(begin)) == 0){
            record = true;
        }else if(strncmp(buf, end, strlen(end)) == 0){
            record = false;
            break;
        }else if(record){
            char* token = strchr(buf, ':');
            char blacklist_domain[BUF_SIZE];
            memset(blacklist_domain, 0x00, sizeof(blacklist_domain));
            strncpy(blacklist_domain, buf, token-buf);
            char blacklist_port[BUF_SIZE];
            memset(blacklist_port, 0x00, sizeof(blacklist_port));
            strcpy(blacklist_port, token + 1);
            struct hostent *host = gethostbyname(blacklist_domain);
            struct in_addr **ip_list = (struct in_addr **)host->h_addr_list;
            
            if(host->h_addrtype == AF_INET){
                for(int i = 0; ip_list[i] != NULL; ++i){
                    char blacklist_ip[INET_ADDRSTRLEN];
                    inet_ntop(AF_INET, ip_list[i], blacklist_ip, INET_ADDRSTRLEN);
                    if(atoi(blacklist_port) == host_port && strcmp(blacklist_ip, host_ip) == 0){
                        blacklist = true;
                        record = false;
                        break;
                    }
                }
            }

        }
    }
    fclose(fp);
    return blacklist;
}

int (*hijack_connect_ptr)(int sockfd, const struct sockaddr *addr, socklen_t addrlen) = NULL;
int hijack_connect(int sockfd, const struct sockaddr *addr, socklen_t addrlen){
    int env_fd = atoi(getenv("LOGGER_FD"));
    char* config = getenv("SANDBOX_CONFIG");
    struct sockaddr_in *host_addr = (struct sockaddr_in *)addr;
    char host_ip[INET_ADDRSTRLEN];
    inet_ntop(AF_INET, &host_addr->sin_addr, host_ip, sizeof(host_ip));
    uint16_t host_port = ntohs(host_addr->sin_port);
    bool blacklist = check_connect_config(config, host_ip, host_port);
    if(blacklist){
        errno = ECONNREFUSED;
        dprintf(env_fd, "[logger] connect(%d, \"%s\", %u) = -1\n", sockfd, host_ip, addrlen);
        return -1;
    }
    int ret = connect(sockfd, addr, addrlen);
    dprintf(env_fd, "[logger] connect(%d, \"%s\", %u) = %d\n", sockfd, host_ip, addrlen, ret);
    return ret;
}

int (*hijack_system_ptr)(const char* command) = NULL;
int hijack_system(const char* command){
    int env_fd = atoi(getenv("LOGGER_FD"));
    dprintf(env_fd, "[logger] system(\"%s\")\n", command);
    int ret = system(command);
    return ret;
}

void get_base(char* exec){
    char buf[16384], *str = buf, *line, *saveptr;
    int fd = open("/proc/self/maps", O_RDONLY);
    if(fd < 0){
        perror("base/open()");
        exit(EXIT_FAILURE);
    } 
    ssize_t rd_sz = read(fd, buf, sizeof(buf)-1);
    if(rd_sz < 0){
        perror("base/read()");
        exit(EXIT_FAILURE);
    }   
    buf[rd_sz] = 0;
    close(fd);
    while((line = strtok_r(str, "\n\r", &saveptr)) != NULL){
        str = NULL;
        if(strstr(line, " r--p ") == NULL){
            continue;
        }
        if(strstr(line, exec) != NULL){
            if(sscanf(line, "%lx-%lx ", &base_min, &base_max) != 2){
                perror("base/sscanf()");
                exit(EXIT_FAILURE);
            }
        }
        if(base_min != 0 && base_max != 0){
            // printf("[info] base_min: %p, base_max: %p\n", (void *)base_min, (void *)base_max);
            return;
        }
    }
}

void rewrite_got_table(){
    int fd = open("/proc/self/exe", O_RDONLY);
    if(fd < 0){
        perror("rewrite/open()");
        exit(EXIT_FAILURE);
    }
    char exec_path[BUF_SIZE];
    memset(exec_path, 0x00, BUF_SIZE);
    ssize_t rdlink_sz = readlink("/proc/self/exe", exec_path, sizeof(exec_path));
    if(rdlink_sz < 0){
        perror("rewrite/readlink()");
        exit(EXIT_FAILURE);
    }
    close(fd);
    // printf("[info] executable path: %s\n", exec_path);
    
    void *handle = dlopen("./sandbox.so", RTLD_LAZY);
    if(handle == NULL){
        perror("rewrite/dlopen()");
        exit(EXIT_FAILURE);
    }

    fd = open(exec_path, O_RDONLY);
    if(fd < 0){
        perror("rewrite/link/open()");
        exit(EXIT_FAILURE);
    }
    /* read elf header */
    Elf64_Ehdr elf_hdr;
    ssize_t rd_sz = read(fd, &elf_hdr, sizeof(Elf64_Ehdr));
    assert(rd_sz == sizeof(Elf64_Shdr));
    /* read section headers */
    Elf64_Shdr* section_hdrs = (Elf64_Shdr *)calloc(elf_hdr.e_shnum, sizeof(Elf64_Shdr));
    off_t offset = lseek(fd, elf_hdr.e_shoff, SEEK_SET);
    assert(offset == elf_hdr.e_shoff);
    rd_sz = read(fd, section_hdrs, elf_hdr.e_shentsize * elf_hdr.e_shnum); 
    assert(rd_sz == elf_hdr.e_shentsize * elf_hdr.e_shnum);
    /* read strtab header */
    Elf64_Shdr* strtab_hdr = &section_hdrs[elf_hdr.e_shstrndx];
    if(strtab_hdr == NULL){
        fprintf(stderr, "No string table in section headers");
        exit(EXIT_FAILURE);
    }
    char *strtab = (char *)malloc(strtab_hdr->sh_size);
    if(strtab == NULL){
        perror("rewrite/malloc()");
        exit(EXIT_FAILURE);
    }
    offset = lseek(fd, strtab_hdr->sh_offset, SEEK_SET);
    assert(offset == strtab_hdr->sh_offset);
    rd_sz = read(fd, strtab, strtab_hdr->sh_size);
    assert(rd_sz == strtab_hdr->sh_size);
    /* read got table and relocation table in section headers */
    Elf64_Shdr* got_hdr = NULL;
    Elf64_Shdr* rela_hdr = NULL;
    for(int i = 0; i < elf_hdr.e_shnum; ++i){
        char* name = &strtab[section_hdrs[i].sh_name];
        if(section_hdrs[i].sh_type == SHT_PROGBITS && section_hdrs[i].sh_flags == (SHF_ALLOC | SHF_WRITE) && strcmp(name, ".got") == 0){
            got_hdr = &section_hdrs[i];
        }
        if(section_hdrs[i].sh_type == SHT_RELA && section_hdrs[i].sh_flags == (SHF_ALLOC | SHF_INFO_LINK) && strcmp(name, ".rela.plt") == 0){
            rela_hdr = &section_hdrs[i];
        }
    }
    if(got_hdr == NULL){
        fprintf(stderr, "Cannot find got table in section headers\n");
        exit(EXIT_FAILURE);
    }else{
        got_min = got_hdr->sh_addr;
        got_max = got_min + got_hdr->sh_size;
        // printf("[info] got table address: %p\n", (void *)got_hdr->sh_addr);
        // printf("[info] got table size: %lx\n", got_hdr->sh_size);
    }
    if(rela_hdr == NULL){
        fprintf(stderr, "Cannot find rela table in section headers\n");
        exit(EXIT_FAILURE);
    }else{
        // printf("[info] rela table address: %p\n", (void *)rela_hdr->sh_addr);
        // printf("[info] rela table size: %lx\n", rela_hdr->sh_size);
    }

    /* mprotect write access */
    get_base(exec_path);
    long pagesize = sysconf(_SC_PAGESIZE);
    long pagenum = ((got_max - got_min) / pagesize) + 1;
    long page_start = (base_min + got_min) & ~(pagesize-1);
    if(mprotect((void *)page_start, pagenum * pagesize, PROT_READ | PROT_WRITE) < 0){
        perror("rewrite/mprotect()");
        exit(EXIT_FAILURE);
    }
    Elf64_Rela* rela_tab = (Elf64_Rela *)malloc(rela_hdr->sh_size);
    offset = lseek(fd, rela_hdr->sh_addr, SEEK_SET);
    assert(offset == rela_hdr->sh_addr);
    rd_sz = read(fd, rela_tab, rela_hdr->sh_size);
    assert(rd_sz == rela_hdr->sh_size);

    Elf64_Shdr* dynsym_hdr = &section_hdrs[rela_hdr->sh_link];
    Elf64_Sym* symtab = (Elf64_Sym *)malloc(dynsym_hdr->sh_size);
    offset = lseek(fd, dynsym_hdr->sh_addr, SEEK_SET);
    assert(offset == dynsym_hdr->sh_addr);
    rd_sz = read(fd, symtab, dynsym_hdr->sh_size);
    assert(rd_sz == dynsym_hdr->sh_size);

    Elf64_Shdr* dynstr_hdr = &section_hdrs[dynsym_hdr->sh_link];
    char* sym_strtab = (char *)malloc(dynstr_hdr->sh_size);
    offset = lseek(fd, dynstr_hdr->sh_addr, SEEK_SET);
    assert(offset == dynstr_hdr->sh_addr);
    rd_sz = read(fd, sym_strtab, dynstr_hdr->sh_size);
    assert(rd_sz == dynstr_hdr->sh_size);

    for(int i = 0; i < (rela_hdr->sh_size / rela_hdr->sh_entsize); ++i){
        // printf("%lx | %s\n", rela_tab[i].r_offset, sym_strtab + symtab[ELF64_R_SYM(rela_tab[i].r_info)].st_name);
        char* func_name = sym_strtab + symtab[ELF64_R_SYM(rela_tab[i].r_info)].st_name;
        long* func_ptr = (long *)(base_min + rela_tab[i].r_offset);
        if(strcmp("open", func_name) == 0){
            hijack_open_ptr = dlsym(handle, "hijack_open");
            *func_ptr = (long)hijack_open_ptr;
        }else if(strcmp("read", func_name) == 0){
            hijack_read_ptr = dlsym(handle, "hijack_read");
            *func_ptr = (long)hijack_read_ptr;
        }else if(strcmp("write", func_name) == 0){
            hijack_write_ptr = dlsym(handle, "hijack_write");
            *func_ptr = (long)hijack_write_ptr;
        }else if(strcmp("getaddrinfo", func_name) == 0){
            hijack_getaddrinfo_ptr = dlsym(handle, "hijack_getaddrinfo");
            *func_ptr = (long)hijack_getaddrinfo_ptr;
        }else if(strcmp("connect", func_name) == 0){
            hijack_connect_ptr = dlsym(handle, "hijack_connect");
            *func_ptr = (long)hijack_connect_ptr;
        }else if(strcmp("system", func_name) == 0){
            hijack_system_ptr = dlsym(handle, "hijack_system");
            *func_ptr = (long)hijack_system_ptr;
        }
        
    }
    dlclose(handle);
    close(fd);
    return;
}   

int (*__libc_start_main_original)(int *(main)(int, char **, char **), int argc, char** ubp_av, void (*init)(void), void (*fini)(void), void (*rtld_fini)(void), void (* stack_end)) = NULL;
int __libc_start_main(int *(main)(int, char **, char **), int argc, char** ubp_av, void (*init)(void), void (*fini)(void), void (*rtld_fini)(void), void (* stack_end)){
    // printf("[info] __libc_start_main injected\n");
    void *handle = dlopen("libc.so.6", RTLD_LAZY);
    if(handle == NULL){
        perror("main/dlopen()");
        exit(EXIT_FAILURE);
    }
    __libc_start_main_original = dlsym(handle, "__libc_start_main");
    if(__libc_start_main_original == NULL){
        perror("main/dlsym()");
        exit(EXIT_FAILURE);
    }
    rewrite_got_table();
    int ret = __libc_start_main_original(main, argc, ubp_av, init, fini, rtld_fini, stack_end);    
    _Exit(ret);
}