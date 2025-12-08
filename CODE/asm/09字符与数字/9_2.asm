;判断字符是否属于字符串,只实现逻辑，没有进行代码编译与调试
;=====================

assume cs:code,ds:data

data segment
message db 'hello welcome to asm.',0dh,0ah,24h
data ends

code segment
start:
	mov ax,data
	mov ds,ax
	
	mov dx,offset message
	mov ah,9
	int 21h
	
	mov ax,4c00h
	int 21h

;DS:SI为字符串地址，AL为字符代码
strchr proc
	push bx 
	push si
	cld
	mov bl,al
	test si,1	;地址是否为偶数
	jz strchr1	;是偶数
	lodsb		;取第一个字节 =  mov al,[si]  +    ( inc si 或 dec si) 根据df位决定
	cmp al,bl
	jz strchr3	;比对成功了
	and al,al	;是不是结束符号0
	jz strchr2	;结束
strchr1:
	lodsw		;取一个字
	cmp al,bl	;比较低字节
	jz strchr4	;zf=1,cf=0
	and al,al	;是不是结束符号0
	jz strchr2	;结束
	cmp ah,bl	;比较高字节
	jz strchr3	;+1再结束
	and ah，ah	
	jnz strchr1	;不是结束，进入循环
strchr2:
	stc
	jmp short strchr5
strchr3:
	inc si
strchr4:
	lea ax,[si-2]
strchr5:	
	pop si
	pop bx
	ret
strchr endp
	
	
code ends
end start