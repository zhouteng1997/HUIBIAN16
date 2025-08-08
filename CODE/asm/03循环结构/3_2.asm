;乘法，拆分计算机乘法的实现原理
;=====================

assume cs:code,ds:data

data segment
xxx db 0ffh
yyy db 0ffh
zzz dw ?
data ends

code segment
start:
	mov ax,seg data
	mov ds,ax
	
	mov al, xxx
	xor ah,ah
	mov bl, yyy
	xor bh,bh
	;循环8次
	mov cx,8
	xor dx,dx ;累加器
next0:
	shr bl,1
	jnc next1 ;如果不是1，跳到next1， 进行下一次循环，下一次循环前，需要将al左移一位
	add dx,ax ;是1就加起来
next1:
	shl	ax,1
	loop next0

	mov zzz,dx   ;保存值
	
	mov ax,4c00h
	int 21h
code ends
end start

；			1111 1111	al
；			1111 1111	bl  这里只有8位，所以循环8次
；			
；			11111111
;		   11111111
；		  11111111
；		 11111111
；
；
；
；
；
；