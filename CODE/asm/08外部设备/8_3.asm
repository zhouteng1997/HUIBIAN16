;直接写显存

assume cs:code,ds:data

data segment

data ends


code segment
start:

	; 设置文本模式
    mov ax,0003h
    int 10h

	mov ax,0b800h
	mov es,ax
	mov di,0
	mov byte ptr es:[di],'A'
	mov byte ptr es:[di+1],07h
	mov byte ptr es:[di+2],'B'
	mov byte ptr es:[di+3],07h
	
	; 添加等待按键
    mov ah,01h      ; 等待按键
    int 21h
	
	mov ax,4c00h
	int 21h
code ends
end start
