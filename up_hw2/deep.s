
./deep:     file format elf64-x86-64


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
  4001d7:	00 d9                	add    cl,bl
  4001d9:	9e                   	sahf   
  4001da:	16                   	(bad)  
  4001db:	73 d6                	jae    4001b3 <callee-0xe4d>
  4001dd:	99                   	cdq    
  4001de:	4b 17                	rex.WXB (bad) 
  4001e0:	d8 62 8b             	fsub   DWORD PTR [rdx-0x75]
  4001e3:	d1 e3                	shl    ebx,1
  4001e5:	de a6 87 59 d2 5f    	fisub  WORD PTR [rsi+0x5fd25987]
  4001eb:	4a                   	rex.WX

Disassembly of section .text:

0000000000401000 <callee>:
  401000:	f3 0f 1e fa          	endbr64 
  401004:	55                   	push   rbp
  401005:	48 89 e5             	mov    rbp,rsp
  401008:	48 83 ec 10          	sub    rsp,0x10
  40100c:	48 b8 74 68 69 73 20 	movabs rax,0x2073692073696874
  401013:	69 73 20 
  401016:	48 ba 63 61 6c 6c 65 	movabs rdx,0xa65656c6c6163
  40101d:	65 0a 00 
  401020:	48 89 45 f0          	mov    QWORD PTR [rbp-0x10],rax
  401024:	48 89 55 f8          	mov    QWORD PTR [rbp-0x8],rdx
  401028:	48 8d 45 f0          	lea    rax,[rbp-0x10]
  40102c:	ba 0f 00 00 00       	mov    edx,0xf
  401031:	48 89 c6             	mov    rsi,rax
  401034:	bf 01 00 00 00       	mov    edi,0x1
  401039:	e8 20 01 00 00       	call   40115e <write>
  40103e:	90                   	nop
  40103f:	c9                   	leave  
  401040:	c3                   	ret    

0000000000401041 <callee2>:
  401041:	f3 0f 1e fa          	endbr64 
  401045:	55                   	push   rbp
  401046:	48 89 e5             	mov    rbp,rsp
  401049:	c7 45 f3 31 32 33 34 	mov    DWORD PTR [rbp-0xd],0x34333231
  401050:	c6 45 f7 00          	mov    BYTE PTR [rbp-0x9],0x0
  401054:	c7 45 fc 00 00 00 00 	mov    DWORD PTR [rbp-0x4],0x0
  40105b:	c7 45 f8 00 00 00 00 	mov    DWORD PTR [rbp-0x8],0x0
  401062:	eb 17                	jmp    40107b <callee2+0x3a>
  401064:	8b 45 f8             	mov    eax,DWORD PTR [rbp-0x8]
  401067:	48 98                	cdqe   
  401069:	0f b6 44 05 f3       	movzx  eax,BYTE PTR [rbp+rax*1-0xd]
  40106e:	0f be c0             	movsx  eax,al
  401071:	83 e8 30             	sub    eax,0x30
  401074:	01 45 fc             	add    DWORD PTR [rbp-0x4],eax
  401077:	83 45 f8 01          	add    DWORD PTR [rbp-0x8],0x1
  40107b:	83 7d f8 03          	cmp    DWORD PTR [rbp-0x8],0x3
  40107f:	7e e3                	jle    401064 <callee2+0x23>
  401081:	8b 45 fc             	mov    eax,DWORD PTR [rbp-0x4]
  401084:	5d                   	pop    rbp
  401085:	c3                   	ret    

0000000000401086 <caller>:
  401086:	f3 0f 1e fa          	endbr64 
  40108a:	55                   	push   rbp
  40108b:	48 89 e5             	mov    rbp,rsp
  40108e:	48 83 ec 10          	sub    rsp,0x10
  401092:	b8 00 00 00 00       	mov    eax,0x0
  401097:	e8 64 ff ff ff       	call   401000 <callee>
  40109c:	b8 00 00 00 00       	mov    eax,0x0
  4010a1:	e8 9b ff ff ff       	call   401041 <callee2>
  4010a6:	89 45 fc             	mov    DWORD PTR [rbp-0x4],eax
  4010a9:	8b 45 fc             	mov    eax,DWORD PTR [rbp-0x4]
  4010ac:	83 c0 0a             	add    eax,0xa
  4010af:	c9                   	leave  
  4010b0:	c3                   	ret    

00000000004010b1 <moddata>:
  4010b1:	f3 0f 1e fa          	endbr64 
  4010b5:	55                   	push   rbp
  4010b6:	48 89 e5             	mov    rbp,rsp
  4010b9:	48 83 ec 10          	sub    rsp,0x10
  4010bd:	c7 45 f6 75 6e 69 78 	mov    DWORD PTR [rbp-0xa],0x78696e75
  4010c4:	66 c7 45 fa 0a 00    	mov    WORD PTR [rbp-0x6],0xa
  4010ca:	ba 0c 00 00 00       	mov    edx,0xc
  4010cf:	48 8d 05 2a 2f 00 00 	lea    rax,[rip+0x2f2a]        # 404000 <hellostr>
  4010d6:	48 89 c6             	mov    rsi,rax
  4010d9:	bf 01 00 00 00       	mov    edi,0x1
  4010de:	e8 7b 00 00 00       	call   40115e <write>
  4010e3:	c7 45 fc 00 00 00 00 	mov    DWORD PTR [rbp-0x4],0x0
  4010ea:	eb 21                	jmp    40110d <moddata+0x5c>
  4010ec:	8b 45 fc             	mov    eax,DWORD PTR [rbp-0x4]
  4010ef:	8d 48 06             	lea    ecx,[rax+0x6]
  4010f2:	8b 45 fc             	mov    eax,DWORD PTR [rbp-0x4]
  4010f5:	48 98                	cdqe   
  4010f7:	0f b6 54 05 f6       	movzx  edx,BYTE PTR [rbp+rax*1-0xa]
  4010fc:	48 63 c1             	movsxd rax,ecx
  4010ff:	48 8d 0d fa 2e 00 00 	lea    rcx,[rip+0x2efa]        # 404000 <hellostr>
  401106:	88 14 08             	mov    BYTE PTR [rax+rcx*1],dl
  401109:	83 45 fc 01          	add    DWORD PTR [rbp-0x4],0x1
  40110d:	8b 45 fc             	mov    eax,DWORD PTR [rbp-0x4]
  401110:	83 f8 05             	cmp    eax,0x5
  401113:	76 d7                	jbe    4010ec <moddata+0x3b>
  401115:	ba 0b 00 00 00       	mov    edx,0xb
  40111a:	48 8d 05 df 2e 00 00 	lea    rax,[rip+0x2edf]        # 404000 <hellostr>
  401121:	48 89 c6             	mov    rsi,rax
  401124:	bf 01 00 00 00       	mov    edi,0x1
  401129:	e8 30 00 00 00       	call   40115e <write>
  40112e:	90                   	nop
  40112f:	c9                   	leave  
  401130:	c3                   	ret    

0000000000401131 <_start>:
  401131:	f3 0f 1e fa          	endbr64 
  401135:	55                   	push   rbp
  401136:	48 89 e5             	mov    rbp,rsp
  401139:	48 83 ec 10          	sub    rsp,0x10
  40113d:	b8 00 00 00 00       	mov    eax,0x0
  401142:	e8 3f ff ff ff       	call   401086 <caller>
  401147:	89 45 fc             	mov    DWORD PTR [rbp-0x4],eax
  40114a:	b8 00 00 00 00       	mov    eax,0x0
  40114f:	e8 5d ff ff ff       	call   4010b1 <moddata>
  401154:	8b 45 fc             	mov    eax,DWORD PTR [rbp-0x4]
  401157:	89 c7                	mov    edi,eax
  401159:	e8 10 00 00 00       	call   40116e <exit>

000000000040115e <write>:
  40115e:	b8 01 00 00 00       	mov    eax,0x1
  401163:	0f 05                	syscall 
  401165:	c3                   	ret    

0000000000401166 <read>:
  401166:	b8 00 00 00 00       	mov    eax,0x0
  40116b:	0f 05                	syscall 
  40116d:	c3                   	ret    

000000000040116e <exit>:
  40116e:	b8 3c 00 00 00       	mov    eax,0x3c
  401173:	0f 05                	syscall 

Disassembly of section .eh_frame_hdr:

0000000000402000 <__GNU_EH_FRAME_HDR>:
  402000:	01 1b                	add    DWORD PTR [rbx],ebx
  402002:	03 3b                	add    edi,DWORD PTR [rbx]
  402004:	34 00                	xor    al,0x0
  402006:	00 00                	add    BYTE PTR [rax],al
  402008:	05 00 00 00 00       	add    eax,0x0
  40200d:	f0 ff                	lock (bad) 
  40200f:	ff 50 00             	call   QWORD PTR [rax+0x0]
  402012:	00 00                	add    BYTE PTR [rax],al
  402014:	41                   	rex.B
  402015:	f0 ff                	lock (bad) 
  402017:	ff 70 00             	push   QWORD PTR [rax+0x0]
  40201a:	00 00                	add    BYTE PTR [rax],al
  40201c:	86 f0                	xchg   al,dh
  40201e:	ff                   	(bad)  
  40201f:	ff 90 00 00 00 b1    	call   QWORD PTR [rax-0x4f000000]
  402025:	f0 ff                	lock (bad) 
  402027:	ff b0 00 00 00 31    	push   QWORD PTR [rax+0x31000000]
  40202d:	f1                   	int1   
  40202e:	ff                   	(bad)  
  40202f:	ff d0                	call   rax
  402031:	00 00                	add    BYTE PTR [rax],al
	...

Disassembly of section .eh_frame:

0000000000402038 <.eh_frame>:
  402038:	14 00                	adc    al,0x0
  40203a:	00 00                	add    BYTE PTR [rax],al
  40203c:	00 00                	add    BYTE PTR [rax],al
  40203e:	00 00                	add    BYTE PTR [rax],al
  402040:	01 7a 52             	add    DWORD PTR [rdx+0x52],edi
  402043:	00 01                	add    BYTE PTR [rcx],al
  402045:	78 10                	js     402057 <__GNU_EH_FRAME_HDR+0x57>
  402047:	01 1b                	add    DWORD PTR [rbx],ebx
  402049:	0c 07                	or     al,0x7
  40204b:	08 90 01 00 00 1c    	or     BYTE PTR [rax+0x1c000001],dl
  402051:	00 00                	add    BYTE PTR [rax],al
  402053:	00 1c 00             	add    BYTE PTR [rax+rax*1],bl
  402056:	00 00                	add    BYTE PTR [rax],al
  402058:	a8 ef                	test   al,0xef
  40205a:	ff                   	(bad)  
  40205b:	ff 41 00             	inc    DWORD PTR [rcx+0x0]
  40205e:	00 00                	add    BYTE PTR [rax],al
  402060:	00 45 0e             	add    BYTE PTR [rbp+0xe],al
  402063:	10 86 02 43 0d 06    	adc    BYTE PTR [rsi+0x60d4302],al
  402069:	78 0c                	js     402077 <__GNU_EH_FRAME_HDR+0x77>
  40206b:	07                   	(bad)  
  40206c:	08 00                	or     BYTE PTR [rax],al
  40206e:	00 00                	add    BYTE PTR [rax],al
  402070:	1c 00                	sbb    al,0x0
  402072:	00 00                	add    BYTE PTR [rax],al
  402074:	3c 00                	cmp    al,0x0
  402076:	00 00                	add    BYTE PTR [rax],al
  402078:	c9                   	leave  
  402079:	ef                   	out    dx,eax
  40207a:	ff                   	(bad)  
  40207b:	ff 45 00             	inc    DWORD PTR [rbp+0x0]
  40207e:	00 00                	add    BYTE PTR [rax],al
  402080:	00 45 0e             	add    BYTE PTR [rbp+0xe],al
  402083:	10 86 02 43 0d 06    	adc    BYTE PTR [rsi+0x60d4302],al
  402089:	7c 0c                	jl     402097 <__GNU_EH_FRAME_HDR+0x97>
  40208b:	07                   	(bad)  
  40208c:	08 00                	or     BYTE PTR [rax],al
  40208e:	00 00                	add    BYTE PTR [rax],al
  402090:	1c 00                	sbb    al,0x0
  402092:	00 00                	add    BYTE PTR [rax],al
  402094:	5c                   	pop    rsp
  402095:	00 00                	add    BYTE PTR [rax],al
  402097:	00 ee                	add    dh,ch
  402099:	ef                   	out    dx,eax
  40209a:	ff                   	(bad)  
  40209b:	ff 2b                	jmp    FWORD PTR [rbx]
  40209d:	00 00                	add    BYTE PTR [rax],al
  40209f:	00 00                	add    BYTE PTR [rax],al
  4020a1:	45 0e                	rex.RB (bad) 
  4020a3:	10 86 02 43 0d 06    	adc    BYTE PTR [rsi+0x60d4302],al
  4020a9:	62                   	(bad)  
  4020aa:	0c 07                	or     al,0x7
  4020ac:	08 00                	or     BYTE PTR [rax],al
  4020ae:	00 00                	add    BYTE PTR [rax],al
  4020b0:	1c 00                	sbb    al,0x0
  4020b2:	00 00                	add    BYTE PTR [rax],al
  4020b4:	7c 00                	jl     4020b6 <__GNU_EH_FRAME_HDR+0xb6>
  4020b6:	00 00                	add    BYTE PTR [rax],al
  4020b8:	f9                   	stc    
  4020b9:	ef                   	out    dx,eax
  4020ba:	ff                   	(bad)  
  4020bb:	ff 80 00 00 00 00    	inc    DWORD PTR [rax+0x0]
  4020c1:	45 0e                	rex.RB (bad) 
  4020c3:	10 86 02 43 0d 06    	adc    BYTE PTR [rsi+0x60d4302],al
  4020c9:	02 77 0c             	add    dh,BYTE PTR [rdi+0xc]
  4020cc:	07                   	(bad)  
  4020cd:	08 00                	or     BYTE PTR [rax],al
  4020cf:	00 18                	add    BYTE PTR [rax],bl
  4020d1:	00 00                	add    BYTE PTR [rax],al
  4020d3:	00 9c 00 00 00 59 f0 	add    BYTE PTR [rax+rax*1-0xfa70000],bl
  4020da:	ff                   	(bad)  
  4020db:	ff 2d 00 00 00 00    	jmp    FWORD PTR [rip+0x0]        # 4020e1 <__GNU_EH_FRAME_HDR+0xe1>
  4020e1:	45 0e                	rex.RB (bad) 
  4020e3:	10 86 02 43 0d 06    	adc    BYTE PTR [rsi+0x60d4302],al
  4020e9:	00 00                	add    BYTE PTR [rax],al
	...

Disassembly of section .data:

0000000000404000 <hellostr>:
  404000:	68 65 6c 6c 6f       	push   0x6f6c6c65
  404005:	20 77 6f             	and    BYTE PTR [rdi+0x6f],dh
  404008:	72 6c                	jb     404076 <_end+0x66>
  40400a:	64 0a 00             	or     al,BYTE PTR fs:[rax]

Disassembly of section .comment:

0000000000000000 <.comment>:
   0:	47                   	rex.RXB
   1:	43                   	rex.XB
   2:	43 3a 20             	rex.XB cmp spl,BYTE PTR [r8]
   5:	28 55 62             	sub    BYTE PTR [rbp+0x62],dl
   8:	75 6e                	jne    78 <callee-0x400f88>
   a:	74 75                	je     81 <callee-0x400f7f>
   c:	20 31                	and    BYTE PTR [rcx],dh
   e:	31 2e                	xor    DWORD PTR [rsi],ebp
  10:	33 2e                	xor    ebp,DWORD PTR [rsi]
  12:	30 2d 31 75 62 75    	xor    BYTE PTR [rip+0x75627531],ch        # 75627549 <_end+0x75223539>
  18:	6e                   	outs   dx,BYTE PTR ds:[rsi]
  19:	74 75                	je     90 <callee-0x400f70>
  1b:	31 7e 32             	xor    DWORD PTR [rsi+0x32],edi
  1e:	32 2e                	xor    ch,BYTE PTR [rsi]
  20:	30 34 29             	xor    BYTE PTR [rcx+rbp*1],dh
  23:	20 31                	and    BYTE PTR [rcx],dh
  25:	31 2e                	xor    DWORD PTR [rsi],ebp
  27:	33 2e                	xor    ebp,DWORD PTR [rsi]
  29:	30 00                	xor    BYTE PTR [rax],al
