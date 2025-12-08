;调用10号中断，使用屏幕绘制

assume cs:code,ds:data

data segment

data ends


code segment
start:
	mov ah,09h
	mov al,'A'
	mov bh,0
	mov bl,07h
	mov cx,1
	int 10h
	
	mov ax,4c00h
	int 21h
code ends
end start
