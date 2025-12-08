;程序名  hello.asm
;显示一个字符串
;=====================

assume cs:code,ds:data,ss:stack
stack segment
	dw 256 dup(?)
stack ends

data segment
message db 'hello welcome to asm.',0dh,0ah,24h
data ends

code segment
main proc far		;far,使用ret时会修改cs+ip
start:
	push ds			;保存现有ds
	xor ax,ax
	push ax			;写入0000
	
	mov ax,data
	mov ds,ax
	mov dx,offset message
	mov ah,9
	int 21h
	
	ret				;修改cs+ip为 ds+0000   ds:0000为psp段，硬编码为cd 20，所以会执行int 20结束程序
code ends
end start