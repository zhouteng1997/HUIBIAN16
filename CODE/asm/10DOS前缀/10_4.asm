;程序名 
;新增23h中断处理程序，按ctrl+c不中止程序运行
;=====================

assume cs:code
;常量定义
cr=0dh
lf=0ah
escape=1bh
code segment

new23h:
	iret

start:
	push cs
	pop cs
	mov dx,offset new23h
	mov ax,2523h	;这个功能号可以直接修改ctrl+c
	int 21h
	
cont:
	mov ah,8
	int 21h
	cmp al,escape
	jz short xit
	
	mov dl,al
	mov ah,2
	int 21
	
	cmp dl,cr
	jnz cont
	
	mov ah,2
	int 21h
	mov dl,lf
	mov ah,2
	int 21h
	jmp cont
	
xit:
	mov ax,4c00h
	int 21h

	
code ends
end start