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
	;16X
	mov ax,X
	mov cl,4  ;shl、shr指令只能使用cl寄存器，使用其他寄存器或者立即数会报错，8086+之后可以使用立即数
	shl ax,cl ;左移四位
	mov dx,X ;高位会写入dx
	mov cl,12
	shr dx,cl ;右移十二位
	
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
