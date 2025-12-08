;直接写显存

assume cs:code,ds:data

data segment

data ends


code segment
start:

	; 设置文本模式
     call clear_screen;

	; 添加等待按键
    mov ah,01h      ; 等待按键
    int 21h
	
	mov ax,4c00h
	int 21h

clear_screen PROC
    mov ax, 0600h   ; AH=06h（滚动），AL=00h（全窗）
    mov bh, 07h     ; 属性（正常）
    mov cx, 0000h   ; CH=0,CL=0（左上角）
    mov dx, 184Fh   ; DH=24,DL=79（右下角）
    int 10h
    ret
clear_screen ENDP
	
	
code ends
end start
