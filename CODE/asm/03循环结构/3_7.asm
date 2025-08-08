;冒泡排序，从小到大
;=====================

assume cs:code,ds:data

data segment
array db 0FFh,20h,99h,0a0h,9h,24h,65h,66h,89h,33h,44h,0h	 
;string_len equ $ - array - 1 ;这个是动态的，运行程序时才会确定，$表示当前地址
array_size equ $- array - 1  ; MASM/TASM 支持  默认最后的0h是结束符，所以-1
data ends

code segment
start:
	mov ax,data
	mov ds,ax
	mov cx,array_size
	mov bx,0
	mov si,1
	
next3:					;next是一个大循环
	mov al,array[bx]
	
	
next0:					;next0是一个小循环
	cmp si,array_size
	jae next2
	cmp al,array[si]
	jb next1
	xchg al,array[si]	;交换内容
	mov array[bx],al	;交换内容
next1: 
	inc si
	jmp next0			;next0结束


next2:
	inc bx
	lea si,[bx+1]
	;mov si,bx
	;inc si
	loop next3			;next结束
	

	mov ax,4c00h
	int 21h
code ends
end start



