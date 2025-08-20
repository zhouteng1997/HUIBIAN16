;子程序将数字剔除

;=====================

assume cs:code,ds:data

data segment
message db 'HELLO 10086 welcome 123 to AsM.',0dh,0ah,24h
message_size dw $-message
data ends

code segment
start:
	mov ax,data
	mov ds,ax
	
	mov cx,message_size
	mov si,0
	mov di,0
	
deldigit1:
	mov al,message[si]
	call deldigit
	inc si
	loop deldigit1

	mov dx,offset message
	mov ah,9
	int 21h
	
	mov ax,4c00h
	int 21h


deldigit proc near  ;只保留非数字
	pushf
	cmp al,'9'
	ja last
	cmp al,'0'
	jb last
	jmp lastend	
last:
	mov message[di],al
	inc di
lastend:
	popf
	ret
deldigit endp

	
code ends
end start