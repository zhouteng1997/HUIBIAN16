;1、写一个程序在屏幕上依次循环显示10个数字符号，每行显示13个。最初所显示的两行如下所示
;0 1 2 3 4 5 6 7 8 9 0 1 2
;3 4 5 6 7 8 9 0 1 2 3 4 5
;2、写一个程序实现上一题的功能，但在按回车键时，结束程序。
;3、0ah缓存区的输入输出
;=====================

assume cs:code,ds:data

data segment

message db 20        ; [0] 缓冲区最大长度(包括回车)
        db ?        ; [1] 实际输入长度(由DOS填充)
        db 20 dup(0) ; [2-21] 实际存储空间
        db 0dh, 0ah,24h      ; 额外添加的终止符(可选)
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
	
huiche: 
	mov ah,1
	int 21h
	cmp al,0dh
	je last1
	jmp huiche 
	
last1:

	mov dx,offset message	;缓冲输入
	mov ah,0ah
	int 21h
	
	call huanghan
	
	
	mov bl, message[1] ;去除回车
	add bl,2
	xor bh,bh
	mov message[bx],0
	
	mov dx,offset message	;缓冲输入
	add dx,2
	mov ah,9  ;字符串输出
	int 21h

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
	call huanghan
	ret
printrow endp 


huanghan proc near
	mov dl,0dh
    mov ah,2
	int 21h
	mov dl,0ah
    mov ah,2
	int 21h
	ret
huanghan endp
	
	
code ends
end start