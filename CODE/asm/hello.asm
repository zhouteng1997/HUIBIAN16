;程序名  hello.asm
;显示一个字符串
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
code ends
end start