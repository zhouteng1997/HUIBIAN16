;实现一个16X+Y
;定义两个段，一个代码段，一个数据段
assume cs:code, ds:data

data segment
X dw 1000H
Y dw 2000H
Z dd ?
data ends 

code segment  
start:
	;段赋值
	mov ax,data
	mov ds,ax
	;乘法 16X   会自动清空dx
	mov ax,X
	mov bx,16
	mul bx
	
	;16X+Y
	add ax,Y
	adc dx,0
	
	;保存结果
	mov word ptr Z,ax
	mov word ptr Z+2,dx
	
	;结束程序
	mov ax,4c00h
	int 21h

code ends  
end start
