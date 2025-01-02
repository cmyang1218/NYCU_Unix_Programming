#include <elf.h>
#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <string.h>
#include <unistd.h>
#include <assert.h>
#include <fcntl.h>
#include <sys/user.h>
#include <sys/wait.h>
#include <sys/types.h>
#include <sys/ptrace.h>
#include <sys/signal.h>
#include <arpa/inet.h>
#include <capstone/capstone.h>

Elf64_Ehdr elf_header;
void disassembly(cs_insn* insn, int num) {
    for(size_t i = 0; i < num; ++i) {
        printf("      %lx:", insn[i].address);
        for(size_t j = 0; j < 10; ++j) {
            if(j < insn[i].size)
                printf(" %02x", insn[i].bytes[j]);
            else 
                printf("   ");
        }
        printf("%s\t\t%s\n", insn[i].mnemonic, insn[i].op_str);
    }
    if(num < 5) {
        printf("** the address is out of the range of the text section.\n");
    }
    return;
}

bool step_check_breakpoint(pid_t child) {
    struct user_regs_struct data;
    ptrace(PTRACE_GETREGS, child, NULL, &data);
    long ret = ptrace(PTRACE_PEEKTEXT, child, (void *)data.rip, NULL);
    if((uint8_t)ret == 0xcc) {
        printf("** hit a breakpoint at %p\n", (void *)data.rip);
    }
    return ((uint8_t)ret == 0xcc);
}

bool step(pid_t child, int status, bool isbp, unsigned char *code) {
    struct user_regs_struct data;
    ptrace(PTRACE_GETREGS, child, NULL, &data);
    int offset = data.rip - elf_header.e_entry;
    long orig_text = *((long *)(code+offset));
    //! remove breakpoint
    long ret;
    if(isbp) {
        ret = ptrace(PTRACE_PEEKTEXT, child, (void *)data.rip, NULL);
        ptrace(PTRACE_POKETEXT, child, (void *)data.rip, orig_text);
    }
    ptrace(PTRACE_SINGLESTEP, child, NULL, NULL);
    if(waitpid(child, &status, 0) < 0) {
        perror("waitpid()");
        exit(EXIT_FAILURE);
    }
    //! restore breakpoint
    if(isbp) {
        ptrace(PTRACE_POKETEXT, child, (void *)data.rip, ret);
    }
    bool check = step_check_breakpoint(child);
    if(WIFEXITED(status)) {
        printf("** the target program terminated.\n");
        exit(EXIT_SUCCESS);
    }
    return check;
}

bool cont_check_breakpoint(pid_t child, int status) {
    struct user_regs_struct data;
    ptrace(PTRACE_GETREGS, child, NULL, &data);
    if(WIFSTOPPED(status)) {
        printf("** hit a breakpoint at %p\n", (void *)data.rip-1);
    }
    return WIFSTOPPED(status);
}

bool cont(pid_t child, int status, bool isbp, unsigned char *code) {
    struct user_regs_struct data;
    ptrace(PTRACE_GETREGS, child, NULL, &data);
    int offset = data.rip - elf_header.e_entry;
    long orig_text = *((long *)(code+offset));
    //! remove breakpoint, restore breakpoint
    if(isbp) {
        long ret = ptrace(PTRACE_PEEKTEXT, child, data.rip, NULL);
        ptrace(PTRACE_POKETEXT, child, data.rip, orig_text);
        ptrace(PTRACE_SINGLESTEP, child, NULL, NULL);
        if(waitpid(child, &status, 0) < 0) {
            perror("waitpid()");
            exit(EXIT_FAILURE);  
        }   
        ptrace(PTRACE_POKETEXT, child, data.rip, ret);
    }
    ptrace(PTRACE_CONT, child, NULL, NULL);
    if(waitpid(child, &status, 0) < 0) {
        perror("waitpid()");
        exit(EXIT_FAILURE);  
    }
    bool check = cont_check_breakpoint(child, status);
    if(WIFEXITED(status)) {
        printf("** the target program terminated.\n");
        exit(EXIT_SUCCESS);
    }
    return check;
}
bool breakpoint(pid_t child, uint32_t *addr) {
    bool check = false;
    struct user_regs_struct data;
    long ret = ptrace(PTRACE_PEEKTEXT, child, addr, NULL);
    ptrace(PTRACE_POKETEXT, child, addr, (ret & 0xffffffffffffff00) | 0xcc);
    ptrace(PTRACE_GETREGS, child, addr, &data);
    if((void *)data.rip == (void *)addr) {  
        check = true;
    }
    printf("** set a breakpoint at %p\n", (void *)addr);
    return check;
}

int anchor(pid_t child, struct user_regs_struct *regs, long *mem, long *mem_addr, long *mem_size) {
    char map[32];
    sprintf(map, "/proc/%d/maps", child);

    int fd, sz, cnt = 0, memcnt = 0;
    char buf[BUFSIZ], *s = buf, *line;
    long addr_min, addr_max;
    if((fd = open(map, O_RDONLY)) < 0) {
        perror("anchor/open()");
        exit(EXIT_FAILURE);
    }
    if((sz = read(fd, buf, sizeof(buf)-1)) < 0) {
        perror("anchor/read()");
        exit(EXIT_FAILURE);
    }
    buf[sz] = 0;
    while((line = strtok(s, "\n\r")) != NULL) {
        s = NULL;
        if(strstr(line, " rw-p ") != NULL || strstr(line, " rwxp ") != NULL) {
            if(sscanf(line, "%lx-%lx ", &addr_min, &addr_max) != 2) {
                perror("anchor/sscanf()");
                exit(EXIT_FAILURE);
            }
        }else {
            continue;
        }
        long addrlen = addr_max - addr_min;
        mem_addr[memcnt] = addr_min;
        mem_size[memcnt] = addrlen;
        for(int i = 0; i < addrlen; i += sizeof(long)) {
            long ret = ptrace(PTRACE_PEEKTEXT, child, addr_min + i, NULL);
            memcpy(mem+cnt, &ret, sizeof(long));
            cnt++;
        }
        memcnt++;
    }
    ptrace(PTRACE_GETREGS, child, NULL, regs);
    printf("** dropped an anchor\n");
    return memcnt;
}

bool check_anchor_breakpoint(pid_t child) {
    struct user_regs_struct data;
    ptrace(PTRACE_GETREGS, child, NULL, &data);
    long ret = ptrace(PTRACE_PEEKTEXT, child, (void *)data.rip, NULL);
    return ((uint8_t)ret == 0xcc);
}

bool timetravel(pid_t child, struct user_regs_struct *regs, long *mem, long *memaddr, long *mem_size, int memcnt) {
    int cnt = 0;
    for(int i = 0; i < memcnt; ++i) {
        for(int j = 0; j < mem_size[i]; j += sizeof(long)) {
            ptrace(PTRACE_POKETEXT, child, memaddr[i] + j, mem[cnt]);
            cnt++;
        }
    }
    ptrace(PTRACE_SETREGS, child, NULL, regs);
    printf("** go back to the anchor point\n");
    return check_anchor_breakpoint(child);
}

int main(int argc, char *argv[]) {
    if(argc < 2) {
        fprintf(stderr, "usage: ./sdb [program]\n");
        exit(EXIT_FAILURE);
    }
    setvbuf(stdin, NULL, _IONBF, 0);
    setvbuf(stdout, NULL, _IONBF, 0);
    setvbuf(stderr, NULL, _IONBF, 0);
    pid_t child;
    if((child = fork()) < 0) {
        perror("fork()");
        exit(EXIT_FAILURE);
    }
    if(child == 0) {
        if(ptrace(PTRACE_TRACEME, 0, 0, 0) < 0) {
            perror("ptrace()");
            exit(EXIT_FAILURE);
        }
        execvp(argv[1], argv+1);
        perror("execvp()");
        exit(EXIT_FAILURE);
    }else {
        FILE* fp = fopen(argv[1], "rb");
        if(fp == NULL) {
            fprintf(stderr, "Failed to open file %s\n", argv[1]);
            exit(EXIT_FAILURE);
        }

        fread(&elf_header, sizeof(Elf64_Ehdr), 1, fp);
        Elf64_Addr entry = elf_header.e_entry;
        printf("** program '%s' loaded. entry point %p\n", argv[1], (void *)entry);
        
        fseek(fp, elf_header.e_shoff, SEEK_SET);
        Elf64_Shdr *section_headers = (Elf64_Shdr *)calloc(elf_header.e_shnum, sizeof(Elf64_Shdr));
        fread(section_headers, sizeof(Elf64_Shdr), elf_header.e_shnum, fp);
        
        Elf64_Shdr strtab = section_headers[elf_header.e_shstrndx];
        char *section_names = (char *)calloc(strtab.sh_size, sizeof(char));
        fseek(fp, strtab.sh_offset, SEEK_SET);
        fread(section_names, strtab.sh_size, 1, fp);

        Elf64_Shdr *text;
        for(int i = 0; i < elf_header.e_shnum; ++i) {
            const char* name = section_names + section_headers[i].sh_name;
            if(strcmp(name, ".text") == 0) {
                text = &section_headers[i];
                break;
            }
        }
        unsigned char* code = (unsigned char *)calloc(text->sh_size, sizeof(unsigned char));
        fseek(fp, text->sh_offset, SEEK_SET);
        fread(code, text->sh_size, 1, fp);
        csh handle;
        cs_insn *insn;
        if(cs_open(CS_ARCH_X86, CS_MODE_64, &handle) != CS_ERR_OK) {
            fprintf(stderr, "Failed to initialize capestone\n");
            exit(EXIT_FAILURE);
        }
        int global_offset = elf_header.e_entry-text->sh_addr;
        size_t count = cs_disasm(handle, code+global_offset, text->sh_size-global_offset, elf_header.e_entry, 5, &insn);
        if(count > 0) {
            disassembly(insn, count);
            cs_free(insn, count);
        }else {
            fprintf(stderr, "Failed to disassembly code\n");
        }
    
        int status; 
        if(waitpid(child, &status, 0) < 0) {
            perror("waitpid()");
            exit(EXIT_FAILURE);
        }
        assert(WIFSTOPPED(status));
        ptrace(PTRACE_SETOPTIONS, child, 0, PTRACE_O_EXITKILL);
        char* buf = (char *)calloc(BUFSIZ, sizeof(char));
        struct user_regs_struct regs, saved_regs = {0};
        bool isbp = false;
        long *saved_mem = (long *)calloc(BUFSIZ*32, sizeof(long));
        long *saved_mem_addr = (long *)calloc(1024, sizeof(long));
        long *saved_mem_size = (long *)calloc(1024, sizeof(long));
        int memblocks = 0;
        while(true) {
            printf("(sdb) ");
            scanf("%s", buf);
            if(strcmp(buf, "si") == 0) {
                isbp = step(child, status, isbp, code+global_offset);
                ptrace(PTRACE_GETREGS, child, NULL, &regs);
                int offset = regs.rip - elf_header.e_entry;
                count = cs_disasm(handle, code+global_offset+offset, text->sh_size-global_offset-offset, regs.rip, 5, &insn);
                disassembly(insn, count);
                cs_free(insn, count);
            }else if(strcmp(buf, "cont") == 0) {
                isbp = cont(child, status, isbp, code+global_offset);
                ptrace(PTRACE_GETREGS, child, NULL, &regs);
                regs.rip -= 1;
                int offset = regs.rip - elf_header.e_entry;
                count = cs_disasm(handle, code+global_offset+offset, text->sh_size-global_offset-offset, regs.rip, 5, &insn);
                disassembly(insn, count);
                cs_free(insn, count);
                ptrace(PTRACE_SETREGS, child, NULL, &regs);
            }else if(strcmp(buf, "break") == 0) {
                uint32_t* addr;
                scanf("%p", &addr);
                isbp = breakpoint(child, addr);
            }else if(strcmp(buf, "anchor") == 0) {
                memblocks = anchor(child, &saved_regs, saved_mem, saved_mem_addr, saved_mem_size);
            }else if(strcmp(buf, "timetravel") == 0) {
                isbp = timetravel(child, &saved_regs, saved_mem, saved_mem_addr, saved_mem_size, memblocks);
                int offset = saved_regs.rip - elf_header.e_entry;
                count = cs_disasm(handle, code+global_offset+offset, text->sh_size-offset, saved_regs.rip, 5, &insn);
                disassembly(insn, count);
                cs_free(insn, count);
            }else if(strcmp(buf, "exit") == 0) {
                break;
            }
        }
        cs_close(&handle);
        free(buf);
        free(saved_mem);
        free(saved_mem_addr);
        free(saved_mem_size);
    }
 
    return 0;
}