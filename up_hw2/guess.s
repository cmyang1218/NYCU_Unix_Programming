
./guess:     file format elf64-x86-64


Disassembly of section .note.gnu.build-id:

00000000004001c8 <.note.gnu.build-id>:
  4001c8:	04 00                	add    al,0x0
  4001ca:	00 00                	add    BYTE PTR [rax],al
  4001cc:	14 00                	adc    al,0x0
  4001ce:	00 00                	add    BYTE PTR [rax],al
  4001d0:	03 00                	add    eax,DWORD PTR [rax]
  4001d2:	00 00                	add    BYTE PTR [rax],al
  4001d4:	47                   	rex.RXB
  4001d5:	4e 55                	rex.WRX push rbp
  4001d7:	00 fc                	add    ah,bh
  4001d9:	db b1 ff 31 d7 6d    	(bad)  [rcx+0x6dd731ff]
  4001df:	93                   	xchg   ebx,eax
  4001e0:	48 53                	rex.W push rbx
  4001e2:	8f                   	(bad)  
  4001e3:	0b 16                	or     edx,DWORD PTR [rsi]
  4001e5:	e3 3c                	jrcxz  400223 <cmpans-0xddd>
  4001e7:	e8 5a 6a 2c 21       	call   216c6c46 <_end+0x212c2c36>

Disassembly of section .text:

0000000000401000 <cmpans>:
  401000:	f3 0f 1e fa          	endbr64 
  401004:	55                   	push   rbp
  401005:	48 89 e5             	mov    rbp,rsp
  401008:	48 89 7d e8          	mov    QWORD PTR [rbp-0x18],rdi
  40100c:	48 89 75 e0          	mov    QWORD PTR [rbp-0x20],rsi
  401010:	c7 45 fc 00 00 00 00 	mov    DWORD PTR [rbp-0x4],0x0
  401017:	eb 2f                	jmp    401048 <cmpans+0x48>
  401019:	8b 45 fc             	mov    eax,DWORD PTR [rbp-0x4]
  40101c:	48 63 d0             	movsxd rdx,eax
  40101f:	48 8b 45 e8          	mov    rax,QWORD PTR [rbp-0x18]
  401023:	48 01 d0             	add    rax,rdx
  401026:	0f b6 10             	movzx  edx,BYTE PTR [rax]
  401029:	8b 45 fc             	mov    eax,DWORD PTR [rbp-0x4]
  40102c:	48 63 c8             	movsxd rcx,eax
  40102f:	48 8b 45 e0          	mov    rax,QWORD PTR [rbp-0x20]
  401033:	48 01 c8             	add    rax,rcx
  401036:	0f b6 00             	movzx  eax,BYTE PTR [rax]
  401039:	38 c2                	cmp    dl,al
  40103b:	74 07                	je     401044 <cmpans+0x44>
  40103d:	b8 ff ff ff ff       	mov    eax,0xffffffff
  401042:	eb 45                	jmp    401089 <cmpans+0x89>
  401044:	83 45 fc 01          	add    DWORD PTR [rbp-0x4],0x1
  401048:	8b 45 fc             	mov    eax,DWORD PTR [rbp-0x4]
  40104b:	48 63 d0             	movsxd rdx,eax
  40104e:	48 8b 45 e0          	mov    rax,QWORD PTR [rbp-0x20]
  401052:	48 01 d0             	add    rax,rdx
  401055:	0f b6 00             	movzx  eax,BYTE PTR [rax]
  401058:	84 c0                	test   al,al
  40105a:	74 28                	je     401084 <cmpans+0x84>
  40105c:	8b 45 fc             	mov    eax,DWORD PTR [rbp-0x4]
  40105f:	48 63 d0             	movsxd rdx,eax
  401062:	48 8b 45 e8          	mov    rax,QWORD PTR [rbp-0x18]
  401066:	48 01 d0             	add    rax,rdx
  401069:	0f b6 00             	movzx  eax,BYTE PTR [rax]
  40106c:	3c 30                	cmp    al,0x30
  40106e:	74 14                	je     401084 <cmpans+0x84>
  401070:	8b 45 fc             	mov    eax,DWORD PTR [rbp-0x4]
  401073:	48 63 d0             	movsxd rdx,eax
  401076:	48 8b 45 e8          	mov    rax,QWORD PTR [rbp-0x18]
  40107a:	48 01 d0             	add    rax,rdx
  40107d:	0f b6 00             	movzx  eax,BYTE PTR [rax]
  401080:	3c 0a                	cmp    al,0xa
  401082:	75 95                	jne    401019 <cmpans+0x19>
  401084:	b8 00 00 00 00       	mov    eax,0x0
  401089:	5d                   	pop    rbp
  40108a:	c3                   	ret    

000000000040108b <_start>:
  40108b:	f3 0f 1e fa          	endbr64 
  40108f:	55                   	push   rbp
  401090:	48 89 e5             	mov    rbp,rsp
  401093:	48 83 ec 10          	sub    rsp,0x10
  401097:	ba 12 00 00 00       	mov    edx,0x12
  40109c:	48 8d 05 5d 0f 00 00 	lea    rax,[rip+0xf5d]        # 402000 <prompt>
  4010a3:	48 89 c6             	mov    rsi,rax
  4010a6:	bf 01 00 00 00       	mov    edi,0x1
  4010ab:	e8 78 00 00 00       	call   401128 <write>
  4010b0:	ba 10 00 00 00       	mov    edx,0x10
  4010b5:	48 8d 05 44 2f 00 00 	lea    rax,[rip+0x2f44]        # 404000 <buf>
  4010bc:	48 89 c6             	mov    rsi,rax
  4010bf:	bf 00 00 00 00       	mov    edi,0x0
  4010c4:	e8 67 00 00 00       	call   401130 <read>
  4010c9:	48 89 45 f8          	mov    QWORD PTR [rbp-0x8],rax
  4010cd:	48 8d 05 3e 0f 00 00 	lea    rax,[rip+0xf3e]        # 402012 <answer>
  4010d4:	48 89 c6             	mov    rsi,rax
  4010d7:	48 8d 05 22 2f 00 00 	lea    rax,[rip+0x2f22]        # 404000 <buf>
  4010de:	48 89 c7             	mov    rdi,rax
  4010e1:	e8 1a ff ff ff       	call   401000 <cmpans>
  4010e6:	85 c0                	test   eax,eax
  4010e8:	75 1b                	jne    401105 <_start+0x7a>
  4010ea:	ba 06 00 00 00       	mov    edx,0x6
  4010ef:	48 8d 05 1f 0f 00 00 	lea    rax,[rip+0xf1f]        # 402015 <ok>
  4010f6:	48 89 c6             	mov    rsi,rax
  4010f9:	bf 01 00 00 00       	mov    edi,0x1
  4010fe:	e8 25 00 00 00       	call   401128 <write>
  401103:	eb 19                	jmp    40111e <_start+0x93>
  401105:	ba 0b 00 00 00       	mov    edx,0xb
  40110a:	48 8d 05 0f 0f 00 00 	lea    rax,[rip+0xf0f]        # 402020 <fail>
  401111:	48 89 c6             	mov    rsi,rax
  401114:	bf 01 00 00 00       	mov    edi,0x1
  401119:	e8 0a 00 00 00       	call   401128 <write>
  40111e:	bf 00 00 00 00       	mov    edi,0x0
  401123:	e8 10 00 00 00       	call   401138 <exit>

0000000000401128 <write>:
  401128:	b8 01 00 00 00       	mov    eax,0x1
  40112d:	0f 05                	syscall 
  40112f:	c3                   	ret    

0000000000401130 <read>:
  401130:	b8 00 00 00 00       	mov    eax,0x0
  401135:	0f 05                	syscall 
  401137:	c3                   	ret    

0000000000401138 <exit>:
  401138:	b8 3c 00 00 00       	mov    eax,0x3c
  40113d:	0f 05                	syscall 

Disassembly of section .rodata:

0000000000402000 <prompt>:
  402000:	67 75 65             	addr32 jne 402068 <__GNU_EH_FRAME_HDR+0x3c>
  402003:	73 73                	jae    402078 <__GNU_EH_FRAME_HDR+0x4c>
  402005:	20 61 20             	and    BYTE PTR [rcx+0x20],ah
  402008:	6e                   	outs   dx,BYTE PTR ds:[rsi]
  402009:	75 6d                	jne    402078 <__GNU_EH_FRAME_HDR+0x4c>
  40200b:	62 65                	(bad)  
  40200d:	72 20                	jb     40202f <__GNU_EH_FRAME_HDR+0x3>
  40200f:	3e 20 00             	ds and BYTE PTR [rax],al

0000000000402012 <answer>:
  402012:	34 32                	xor    al,0x32
	...

0000000000402015 <ok>:
  402015:	0a 79 65             	or     bh,BYTE PTR [rcx+0x65]
  402018:	73 0a                	jae    402024 <fail+0x4>
  40201a:	00 00                	add    BYTE PTR [rax],al
  40201c:	00 00                	add    BYTE PTR [rax],al
	...

0000000000402020 <fail>:
  402020:	0a 6e 6f             	or     ch,BYTE PTR [rsi+0x6f]
  402023:	20 6e 6f             	and    BYTE PTR [rsi+0x6f],ch
  402026:	20 6e 6f             	and    BYTE PTR [rsi+0x6f],ch
  402029:	0a 00                	or     al,BYTE PTR [rax]

Disassembly of section .eh_frame_hdr:

000000000040202c <__GNU_EH_FRAME_HDR>:
  40202c:	01 1b                	add    DWORD PTR [rbx],ebx
  40202e:	03 3b                	add    edi,DWORD PTR [rbx]
  402030:	18 00                	sbb    BYTE PTR [rax],al
  402032:	00 00                	add    BYTE PTR [rax],al
  402034:	02 00                	add    al,BYTE PTR [rax]
  402036:	00 00                	add    BYTE PTR [rax],al
  402038:	d4                   	(bad)  
  402039:	ef                   	out    dx,eax
  40203a:	ff                   	(bad)  
  40203b:	ff 34 00             	push   QWORD PTR [rax+rax*1]
  40203e:	00 00                	add    BYTE PTR [rax],al
  402040:	5f                   	pop    rdi
  402041:	f0 ff                	lock (bad) 
  402043:	ff 54 00 00          	call   QWORD PTR [rax+rax*1+0x0]
	...

Disassembly of section .eh_frame:

0000000000402048 <.eh_frame>:
  402048:	14 00                	adc    al,0x0
  40204a:	00 00                	add    BYTE PTR [rax],al
  40204c:	00 00                	add    BYTE PTR [rax],al
  40204e:	00 00                	add    BYTE PTR [rax],al
  402050:	01 7a 52             	add    DWORD PTR [rdx+0x52],edi
  402053:	00 01                	add    BYTE PTR [rcx],al
  402055:	78 10                	js     402067 <__GNU_EH_FRAME_HDR+0x3b>
  402057:	01 1b                	add    DWORD PTR [rbx],ebx
  402059:	0c 07                	or     al,0x7
  40205b:	08 90 01 00 00 1c    	or     BYTE PTR [rax+0x1c000001],dl
  402061:	00 00                	add    BYTE PTR [rax],al
  402063:	00 1c 00             	add    BYTE PTR [rax+rax*1],bl
  402066:	00 00                	add    BYTE PTR [rax],al
  402068:	98                   	cwde   
  402069:	ef                   	out    dx,eax
  40206a:	ff                   	(bad)  
  40206b:	ff 8b 00 00 00 00    	dec    DWORD PTR [rbx+0x0]
  402071:	45 0e                	rex.RB (bad) 
  402073:	10 86 02 43 0d 06    	adc    BYTE PTR [rsi+0x60d4302],al
  402079:	02 82 0c 07 08 00    	add    al,BYTE PTR [rdx+0x8070c]
  40207f:	00 18                	add    BYTE PTR [rax],bl
  402081:	00 00                	add    BYTE PTR [rax],al
  402083:	00 3c 00             	add    BYTE PTR [rax+rax*1],bh
  402086:	00 00                	add    BYTE PTR [rax],al
  402088:	03 f0                	add    esi,eax
  40208a:	ff                   	(bad)  
  40208b:	ff 9d 00 00 00 00    	call   FWORD PTR [rbp+0x0]
  402091:	45 0e                	rex.RB (bad) 
  402093:	10 86 02 43 0d 06    	adc    BYTE PTR [rsi+0x60d4302],al
  402099:	00 00                	add    BYTE PTR [rax],al
	...

Disassembly of section .bss:

0000000000404000 <buf>:
	...

Disassembly of section .comment:

0000000000000000 <.comment>:
   0:	47                   	rex.RXB
   1:	43                   	rex.XB
   2:	43 3a 20             	rex.XB cmp spl,BYTE PTR [r8]
   5:	28 55 62             	sub    BYTE PTR [rbp+0x62],dl
   8:	75 6e                	jne    78 <cmpans-0x400f88>
   a:	74 75                	je     81 <cmpans-0x400f7f>
   c:	20 31                	and    BYTE PTR [rcx],dh
   e:	31 2e                	xor    DWORD PTR [rsi],ebp
  10:	33 2e                	xor    ebp,DWORD PTR [rsi]
  12:	30 2d 31 75 62 75    	xor    BYTE PTR [rip+0x75627531],ch        # 75627549 <_end+0x75223539>
  18:	6e                   	outs   dx,BYTE PTR ds:[rsi]
  19:	74 75                	je     90 <cmpans-0x400f70>
  1b:	31 7e 32             	xor    DWORD PTR [rsi+0x32],edi
  1e:	32 2e                	xor    ch,BYTE PTR [rsi]
  20:	30 34 29             	xor    BYTE PTR [rcx+rbp*1],dh
  23:	20 31                	and    BYTE PTR [rcx],dh
  25:	31 2e                	xor    DWORD PTR [rsi],ebp
  27:	33 2e                	xor    ebp,DWORD PTR [rsi]
  29:	30 00                	xor    BYTE PTR [rax],al
