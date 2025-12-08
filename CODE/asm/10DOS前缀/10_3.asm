;程序名 
;在屏幕上显示用户所按字符，直到用户按esc为止
;=====================

assume cs:code
;常量定义
cr=0dh
lf=0ah
escape=1bh
code segment
start:

	push cs
	pop cs
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