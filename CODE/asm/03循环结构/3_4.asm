;大写转小写
;=====================

assume cs:code,ds:data

data segment
message db "My Name Is Zt,1997 02 10",0dh,0ah,0h,24h
data ends

code segment
start:
	mov ax,seg data
	mov ds,ax
	mov bx,offset message  ;message的地址
	mov cx,100  ;最多100个字符
next0:
	mov al,[bx]
	cmp al,0
	jz next2	;是0直接结束
	cmp al,'A'
	jb next1	;小于41h
	cmp al,'a'
	ja next1 	;大于61h  
	or al,00100000B
	mov [bx],al
	

next1:
	inc bx
	loop next0

next2:
	mov dx,offset message
	mov ah,9
	int 21h
	
	mov ax,4c00h
	int 21h
code ends
end start

