;1、写一个程序在屏幕上依次循环显示10个数字符号，每行显示13个。最初所显示的两行如下所示
;0 1 2 3 4 5 6 7 8 9 0 1 2
;3 4 5 6 7 8 9 0 1 2 3 4 5
;=====================

assume cs:code,ds:data

data segment
message db 10 dup(0),0dh,0ah,24h
data ends

code segment
start:
	mov ax,data
	mov ds,ax
	
	xor si,si
	
	mov cx,13
	call printrow
	mov cx,13
	call printrow
	mov ax,4c00h
	int 21h


printrow proc near
next:
	cmp si,10
	jb next1
	xor si,si
next1:
	xor dx,dx
	mov dx,si
	add dl,30h
    mov ah,2
	int 21h
	inc si
	loop next
last:
	mov dl,0dh
    mov ah,2
	int 21h
	mov dl,0ah
    mov ah,2
	int 21h
	ret
printrow endp


	
	
	
code ends
end start