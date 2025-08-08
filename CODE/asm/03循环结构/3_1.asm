;乘法 用加法的方式实现
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
	mov cl, yyy
	xor ch,ch
	
	xor dx,dx ;累加器
next0:
	add dl,al
	adc dh,0
	loop next0

	mov zzz,dx   ;保存值
	
	mov ax,4c00h
	int 21h
code ends
end start