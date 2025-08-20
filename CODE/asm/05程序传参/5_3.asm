;16位子程序实现32位数字的加法

;=====================

assume cs:code,ds:data

data segment
one dd 12345678h
onedb equ word ptr one ; onedb 是 one 的第一个字节
two dd 12335679h
twodb equ word ptr two ; twodb 是 two 的第一个字节
three dd ?
data ends

code segment
start:
	mov ax,data
	mov ds,ax
	

	push word ptr one[2]   ;1234
	push word ptr one[0]	;5678
	push word ptr two[2]	;1233
	push word ptr two[0]	;5679
	call add32
	
	mov ax,4c00h
	int 21h


add32 proc near

	pushf
	push bp
	mov bp,sp
	
	mov dx,word ptr [bp+12]	;1234
	mov ax,word ptr [bp+10]	;5678
	add ax,word ptr [bp+6]	;5679
	adc dx,word ptr [bp+8] ;1233

	mov word ptr three[2],dx
	mov word ptr three,ax
	
	pop bp
	popf
	
	ret 8
add32 endp

	
code ends
end start


;bp   0
;pushf 2
;call 4
;two[0] 6
;two[2] 8
;one[0] 10
;one[2] 12
