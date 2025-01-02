
./loop1:     file format elf64-x86-64


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
  40019f:	00 29                	add    BYTE PTR [rcx],ch
  4001a1:	8c ee                	mov    esi,gs
  4001a3:	e2 e7                	loop   40018c <_start-0xe74>
  4001a5:	64 5c                	fs pop rsp
  4001a7:	00 f1                	add    cl,dh
  4001a9:	d2 59 79             	rcr    BYTE PTR [rcx+0x79],cl
  4001ac:	0c d7                	or     al,0xd7
  4001ae:	98                   	cwde   
  4001af:	7e 60                	jle    400211 <_start-0xdef>
  4001b1:	06                   	(bad)  
  4001b2:	e1 e6                	loope  40019a <_start-0xe66>

Disassembly of section .text:

0000000000401000 <_start>:
  401000:	f3 0f 1e fa          	endbr64 
  401004:	55                   	push   rbp
  401005:	48 89 e5             	mov    rbp,rsp
  401008:	48 83 ec 10          	sub    rsp,0x10
  40100c:	c7 45 fc 00 00 00 00 	mov    DWORD PTR [rbp-0x4],0x0
  401013:	66 c7 45 f9 30 0a    	mov    WORD PTR [rbp-0x7],0xa30
  401019:	c6 45 fb 00          	mov    BYTE PTR [rbp-0x5],0x0
  40101d:	c7 45 fc 00 00 00 00 	mov    DWORD PTR [rbp-0x4],0x0
  401024:	eb 08                	jmp    40102e <_start+0x2e>
  401026:	83 45 fc 01          	add    DWORD PTR [rbp-0x4],0x1
  40102a:	83 45 fc 01          	add    DWORD PTR [rbp-0x4],0x1
  40102e:	83 7d fc 02          	cmp    DWORD PTR [rbp-0x4],0x2
  401032:	7e f2                	jle    401026 <_start+0x26>
  401034:	0f b6 45 f9          	movzx  eax,BYTE PTR [rbp-0x7]
  401038:	89 c2                	mov    edx,eax
  40103a:	8b 45 fc             	mov    eax,DWORD PTR [rbp-0x4]
  40103d:	01 d0                	add    eax,edx
  40103f:	88 45 f9             	mov    BYTE PTR [rbp-0x7],al
  401042:	48 8d 45 f9          	lea    rax,[rbp-0x7]
  401046:	ba 02 00 00 00       	mov    edx,0x2
  40104b:	48 89 c6             	mov    rsi,rax
  40104e:	bf 01 00 00 00       	mov    edi,0x1
  401053:	e8 0a 00 00 00       	call   401062 <write>
  401058:	bf 00 00 00 00       	mov    edi,0x0
  40105d:	e8 10 00 00 00       	call   401072 <exit>

0000000000401062 <write>:
  401062:	b8 01 00 00 00       	mov    eax,0x1
  401067:	0f 05                	syscall 
  401069:	c3                   	ret    

000000000040106a <read>:
  40106a:	b8 00 00 00 00       	mov    eax,0x0
  40106f:	0f 05                	syscall 
  401071:	c3                   	ret    

0000000000401072 <exit>:
  401072:	b8 3c 00 00 00       	mov    eax,0x3c
  401077:	0f 05                	syscall 

Disassembly of section .eh_frame_hdr:

0000000000402000 <__GNU_EH_FRAME_HDR>:
  402000:	01 1b                	add    DWORD PTR [rbx],ebx
  402002:	03 3b                	add    edi,DWORD PTR [rbx]
  402004:	14 00                	adc    al,0x0
  402006:	00 00                	add    BYTE PTR [rax],al
  402008:	01 00                	add    DWORD PTR [rax],eax
  40200a:	00 00                	add    BYTE PTR [rax],al
  40200c:	00 f0                	add    al,dh
  40200e:	ff                   	(bad)  
  40200f:	ff 30                	push   QWORD PTR [rax]
  402011:	00 00                	add    BYTE PTR [rax],al
	...

Disassembly of section .eh_frame:

0000000000402018 <__bss_start-0x1fe8>:
  402018:	14 00                	adc    al,0x0
  40201a:	00 00                	add    BYTE PTR [rax],al
  40201c:	00 00                	add    BYTE PTR [rax],al
  40201e:	00 00                	add    BYTE PTR [rax],al
  402020:	01 7a 52             	add    DWORD PTR [rdx+0x52],edi
  402023:	00 01                	add    BYTE PTR [rcx],al
  402025:	78 10                	js     402037 <__GNU_EH_FRAME_HDR+0x37>
  402027:	01 1b                	add    DWORD PTR [rbx],ebx
  402029:	0c 07                	or     al,0x7
  40202b:	08 90 01 00 00 18    	or     BYTE PTR [rax+0x18000001],dl
  402031:	00 00                	add    BYTE PTR [rax],al
  402033:	00 1c 00             	add    BYTE PTR [rax+rax*1],bl
  402036:	00 00                	add    BYTE PTR [rax],al
  402038:	c8 ef ff ff          	enter  0xffef,0xff
  40203c:	62                   	(bad)  
  40203d:	00 00                	add    BYTE PTR [rax],al
  40203f:	00 00                	add    BYTE PTR [rax],al
  402041:	45 0e                	rex.RB (bad) 
  402043:	10 86 02 43 0d 06    	adc    BYTE PTR [rsi+0x60d4302],al
  402049:	00 00                	add    BYTE PTR [rax],al
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
