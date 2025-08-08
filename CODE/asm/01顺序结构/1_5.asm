;实现一个数字转字母
;定义两个段，一个代码段，一个数据段
assume cs:code, ds:data

data segment
value db 07 ;取第7个
ASCll db ?,0dh,0ah,24h ;这个就是将数字转化为字符显示
table db 'abcdefghijklmnopqrstuvwxyz'  ;这个就是我定义的表结构
data ends 

code segment  
start:
	;段赋值
	mov ax,data
	mov ds,ax
	
	mov bl,value ;变址不能用ax，只能用bx
	dec bl	;自减
	xor bh,bh
	mov al,table[bx]
	mov ASCll,al
	
	mov dx,offset ASCll
	mov ah,9
	int 21h
	
	;结束程序
	mov ax,4c00h
	int 21h

code ends  
end start
