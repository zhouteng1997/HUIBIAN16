;程序名  hello.asm
;显示一个字符串
;=====================

assume cs:code,ds:code	; 这只是告诉汇编器假设，并非实际设置
code segment
buffer db 128 dup(?)
start:
	cld
	mov si,80h	;这里DS默认是PSP段，80h是PSP中的命令行参数长度位置
	;从DS:SI读取，即从PSP:80h读取，从si加载一个byte到al，并自动更新源指针（SI/ESI/RSI）的指令。 
	;DF = 0（用 cld 指令清除），则指针增加 SI=SI+1。DF = 1（用 std 指令设置），则指针减少 SI=SI-1。
	lodsb		
	mov cl,al 	;cl=al=PSP:80h=实际参数长度
	xor ch,ch	;cx=实际参数长度
	push cs		
	pop es		;es=cs
	
	mov di,offset buffer	;es:di为buffer地址
	push cx		;进入rep操作会变更值，有多少个参数执行多少次循环
	;将ds:si的数据复制到es:di  es:di为buffer地址，所以直接复制到了buffer
	;rep循环执行指令，次数为ecx，cx，cl。   movsb 将si复制到di，且DF = 0（用 cld 指令清除），则指针增加。DF = 1（用 std 指令设置），则指针减少。
	rep movsb	
	pop cx		;现在cx还是为参数个数
	
	push es
	pop ds		;ds=es
	mov si,offset buffer	;ds:si为buffer地址
	mov ah,2	;这是字符输出功能，需要与21号中断一起
	jcxz over
next:
	lodsb		;获取ds：si,并si=si+1
	mov dl,al	;21号中断，2号功能会输出dl的值
	int 21h		;21号中断，2号功能，字符输出
	loop next	;cx=cx-1
over:
	mov ax,4c00h
	int 21h		;结束
code ends
end start