
./hello:     file format elf64-x86-64


Disassembly of section .note.gnu.build-id:

0000000000400190 <.note.gnu.build-id>:
  400190:	04 00                	add    al,0x0
  400192:	00 00                	add    BYTE PTR [rax],al
  400194:	14 00                	adc    al,0x0
  400196:	00 00                	add    BYTE PTR [rax],al
  400198:	03 00                	add    eax,DWORD PTR [rax]
  40019a:	00 00                	add    BYTE PTR [rax],al
  40019c:	47                   	rex.RXB
  40019d:	4e 55                	rex.WRX push rbp
  40019f:	00 75 ca             	add    BYTE PTR [rbp-0x36],dh
  4001a2:	6e                   	outs   dx,BYTE PTR ds:[rsi]
  4001a3:	78 ff                	js     4001a4 <_start-0xe5c>
  4001a5:	4d 3d 4b 7d 56 93    	rex.WRB cmp rax,0xffffffff93567d4b
  4001ab:	c2 be bf             	ret    0xbfbe
  4001ae:	5a                   	pop    rdx
  4001af:	4c 74 f7             	rex.WR je 4001a9 <_start-0xe57>
  4001b2:	12 d6                	adc    dl,dh

Disassembly of section .text:

0000000000401000 <_start>:
  401000:	f3 0f 1e fa          	endbr64 
  401004:	55                   	push   rbp
  401005:	48 89 e5             	mov    rbp,rsp
  401008:	ba 0e 00 00 00       	mov    edx,0xe
  40100d:	48 8d 05 ec 0f 00 00 	lea    rax,[rip+0xfec]        # 402000 <hello>
  401014:	48 89 c6             	mov    rsi,rax
  401017:	bf 01 00 00 00       	mov    edi,0x1
  40101c:	e8 0a 00 00 00       	call   40102b <write>
  401021:	bf 00 00 00 00       	mov    edi,0x0
  401026:	e8 10 00 00 00       	call   40103b <exit>

000000000040102b <write>:
  40102b:	b8 01 00 00 00       	mov    eax,0x1
  401030:	0f 05                	syscall 
  401032:	c3                   	ret    

0000000000401033 <read>:
  401033:	b8 00 00 00 00       	mov    eax,0x0
  401038:	0f 05                	syscall 
  40103a:	c3                   	ret    

000000000040103b <exit>:
  40103b:	b8 3c 00 00 00       	mov    eax,0x3c
  401040:	0f 05                	syscall 

Disassembly of section .rodata:

0000000000402000 <hello>:
  402000:	68 65 6c 6c 6f       	push   0x6f6c6c65
  402005:	20 77 6f             	and    BYTE PTR [rdi+0x6f],dh
  402008:	72 6c                	jb     402076 <__GNU_EH_FRAME_HDR+0x66>
  40200a:	64 21 0a             	and    DWORD PTR fs:[rdx],ecx
	...

Disassembly of section .eh_frame_hdr:

0000000000402010 <__GNU_EH_FRAME_HDR>:
  402010:	01 1b                	add    DWORD PTR [rbx],ebx
  402012:	03 3b                	add    edi,DWORD PTR [rbx]
  402014:	14 00                	adc    al,0x0
  402016:	00 00                	add    BYTE PTR [rax],al
  402018:	01 00                	add    DWORD PTR [rax],eax
  40201a:	00 00                	add    BYTE PTR [rax],al
  40201c:	f0 ef                	lock out dx,eax
  40201e:	ff                   	(bad)  
  40201f:	ff 30                	push   QWORD PTR [rax]
  402021:	00 00                	add    BYTE PTR [rax],al
	...

Disassembly of section .eh_frame:

0000000000402028 <__bss_start-0x1fd8>:
  402028:	14 00                	adc    al,0x0
  40202a:	00 00                	add    BYTE PTR [rax],al
  40202c:	00 00                	add    BYTE PTR [rax],al
  40202e:	00 00                	add    BYTE PTR [rax],al
  402030:	01 7a 52             	add    DWORD PTR [rdx+0x52],edi
  402033:	00 01                	add    BYTE PTR [rcx],al
  402035:	78 10                	js     402047 <__GNU_EH_FRAME_HDR+0x37>
  402037:	01 1b                	add    DWORD PTR [rbx],ebx
  402039:	0c 07                	or     al,0x7
  40203b:	08 90 01 00 00 18    	or     BYTE PTR [rax+0x18000001],dl
  402041:	00 00                	add    BYTE PTR [rax],al
  402043:	00 1c 00             	add    BYTE PTR [rax+rax*1],bl
  402046:	00 00                	add    BYTE PTR [rax],al
  402048:	b8 ef ff ff 2b       	mov    eax,0x2bffffef
  40204d:	00 00                	add    BYTE PTR [rax],al
  40204f:	00 00                	add    BYTE PTR [rax],al
  402051:	45 0e                	rex.RB (bad) 
  402053:	10 86 02 43 0d 06    	adc    BYTE PTR [rsi+0x60d4302],al
  402059:	00 00                	add    BYTE PTR [rax],al
	...

Disassembly of section .comment:

0000000000000000 <.comment>:
   0:	47                   	rex.RXB
   1:	43                   	rex.XB
   2:	43 3a 20             	rex.XB cmp spl,BYTE PTR [r8]
   5:	28 55 62             	sub    BYTE PTR [rbp+0x62],dl
   8:	75 6e                	jne    78 <_start-0x400f88>
   a:	74 75                	je     81 <_start-0x400f7f>
   c:	20 31                	and    BYTE PTR [rcx],dh
   e:	31 2e                	xor    DWORD PTR [rsi],ebp
  10:	33 2e                	xor    ebp,DWORD PTR [rsi]
  12:	30 2d 31 75 62 75    	xor    BYTE PTR [rip+0x75627531],ch        # 75627549 <__bss_start+0x75223549>
  18:	6e                   	outs   dx,BYTE PTR ds:[rsi]
  19:	74 75                	je     90 <_start-0x400f70>
  1b:	31 7e 32             	xor    DWORD PTR [rsi+0x32],edi
  1e:	32 2e                	xor    ch,BYTE PTR [rsi]
  20:	30 34 29             	xor    BYTE PTR [rcx+rbp*1],dh
  23:	20 31                	and    BYTE PTR [rcx],dh
  25:	31 2e                	xor    DWORD PTR [rsi],ebp
  27:	33 2e                	xor    ebp,DWORD PTR [rsi]
  29:	30 00                	xor    BYTE PTR [rax],al
