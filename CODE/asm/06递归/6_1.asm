;阶乘1*2*3*4*5*6*7*8*9

assume cs:code

code segment
start:
	mov cx,9
	mov ax,1
	call cffun  ;执行结束后结果为8980
	mov ax,4c00h
	int 21h
	
	
cffun proc near
	cmp cx,ax ;如果到1了就结束，给ax赋值为1
	je done

	push cx ;不是1就存进去
	dec cx
	
	call cffun		;递归实现，先循环执行上面，再循环执行下面
	
	pop	cx ;存进去的值取出来
	mul cx
	ret
cffun endp

done:
	mov ax,cx
	ret
	

	

code ends
end start
