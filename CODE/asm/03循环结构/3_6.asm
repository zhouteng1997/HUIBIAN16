;数据正负分组，只保留最前面的5个正数和负数
;=====================

max_c=5

assume cs:code,ds:data

data segment
array db 10,20,-10,-20,-99,-24,-65,66,89,-33,-44,0
zsarray db max_c dup(?)
fsarray db max_c dup(?)
data ends

code segment
start:
	mov ax,data
	mov ds,ax
	mov bx,offset array ;bx作为数组地址
	
	xor si,si
	xor di,di

	mov cx,20 ;最大循环次数
	dec bx
next0:
	inc bx ;每次循环，地址+1
	mov al,[bx]
	cmp al,0
	jg zsnext
	jl fsnext
	jz last
	
zsnext:
	cmp si,max_c
	jae qbnetx
	mov zsarray[si],al
	inc si
	loop next0

fsnext:
	cmp di,max_c
	jae qbnetx
	mov fsarray[di],al
	inc di
	loop next0
	
qbnetx:
	mov ax,si
	add ax,di
	cmp ax,max_c*2
	jz last
	loop next0
	
last:
	mov ax,4c00h
	int 21h
code ends
end start



