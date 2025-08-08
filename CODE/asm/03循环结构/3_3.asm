;16进制转10进制，输出ASCII码
;=====================

assume cs:code,ds:data

data segment
xxx dw 0ffffh
message db 10 dup(30h),0dh,0ah,24h
data ends

code segment
start:
	mov ax,seg data
	mov ds,ax
	
	mov si,offset message  ;message的地址
	add si,9  ;message db 10 dup[?]的最后一位地址
	
	mov ax, xxx
	xor dx,dx

	mov bx, 10 ;将数据转化为10进制 虽然被除数是16位，但结果也是16位，所以用32位除法
	
	;这里如果被修改，可能会死循环
next0:
	div bx ;bx是16位，32位的除法是  （dx：ax）/16位
	add dl,30h ;dx保留余数,余数一定小于10,转ASCII码
	mov [si],dl ;dx保留余数
	dec si
	xor dx,dx  ;清空dx，ax已经是除法的商了，不需要操作
	and ax,0ffffh
	jnz next0		;jnz=jne  jz=je 	不是0就一直除
	


	mov dx,offset message
	mov ah,9
	int 21h
	
	mov ax,4c00h
	int 21h
code ends
end start

