;实现数值转ASCll码

;定义两个段，一个代码段，一个数据段
assume cs:code, ds:data

data segment
BCD db 87H
ASCll db 2 DUP(?),0dh,0ah,24h
data ends 

code segment  
start:
	;段赋值
	mov ax,data
	mov ds,ax
	
	;BCD取低位
	mov al,BCD
	and al,0fH
	add	al,30h
	mov ASCll+1,al
	
	;BCD取高位
	mov al,BCD
	mov cl,4
	shr al,cl
	add	al,30h
	mov ASCll,al
	
	mov dx,offset ASCll
	mov ah,9
	int 21h
	
	;结束程序
	mov ax,4c00h
	int 21h

code ends  
end start
