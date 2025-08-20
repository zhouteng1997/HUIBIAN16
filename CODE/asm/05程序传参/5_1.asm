;子程序将al的大写转小写
;=====================

assume cs:code,ds:data

data segment
message db 'HELLO welcome to AsM.',0dh,0ah,24h
message_size dw $-message-1
data ends

code segment
start:
	mov ax,data
	mov ds,ax
	
	mov cx,message_size
	mov bx,0
	
uptolow1:
	mov al,message[bx]
	call uptolow
	mov message[bx],al
	inc bx
	loop uptolow1

	mov dx,offset message
	mov ah,9
	int 21h
	
	mov ax,4c00h
	int 21h


uptolow proc near
	pushf
	cmp al,'Z'
	ja last
	cmp al,'A'
	jb last
	add al,20h
last:
	popf
	ret
uptolow endp

	
code ends
end start