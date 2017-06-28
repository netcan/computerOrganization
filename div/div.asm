 main:
 	in r0, 00h ;输入2个顶点小数，高四位r1(A): 0.xxxx,低四位r0(X): 0.yyyy
 	mov r1, r0
 	shr r1 ;右移一位，最高位符号位
 	mov r3, 78h;
 	and r1, r3 ;得到r1(A)
 	mov r3, 0fh
 	and r0, r3
 	shl r0 ; 左移3位
 	shl r0
 	shl r0
 	mov r2, 04h; 计数用r2(C), r3(Q)
 
 div:
 	sub r1, r0 ;(A)-(X)->A
 	jnc overflow ;A >= 0
 	mov r3, 0 ; 0->Q, r3(Q)
 	shl r1 ;A <<= 1
 	shl r3 ; Q <<= 1
 	dec r2 ; (C)-1->C
 	add r1, r0 ; (A)+(X)->(A)
 judge:
 	st r2, 79h; store r2(C)
	mov r2, 80h; 
 	test r1, r2 ; A < 0?
 	jz subtraction; A >= 0
 	shl r1 ;A <<= 1
 	shl r3 ; Q <<= 1
	add r1, r0; (A)+(X)->A
 	jmp loop
 
 subtraction:	
 	shl r1 ;A <<= 1
 	mov r2, 10h ;
 	or r3, r2 ; Q_n = 1
 	shl r3 ;Q <<= 1
	sub r1, r0; (A)-(X)->A
 
 loop: 
	ld r2, 79h;
 	dec r2;(C)-1->C
 	jz result
 	jmp judge;
 
 result:
	mov r2, 80h;
 	test r1, r2 ; A < 0?
 	jnz handleResult
 	mov r2, 10h ; 
 	or r3, r2 ; Q_n = 1
 
 handleResult: 
 	; r3(Q)商，r1(A)余数
 	shr r1
 	shr r1
 	shr r1
 	or r3, r1
 	out 00h, r3
 	jmp 00h;
 overflow:
 	mov r3, ffh
 	out 00h, r3
 	jmp 00h;
