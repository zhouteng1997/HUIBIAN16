;数字比较排序，仅支持三个数字
;=====================

assume cs:code,ds:data

data segment
list db 88h,0ffh,99h ;定义了三个数
data ends

code segment
start:
	mov ax,data
	mov ds,ax
	
	mov si,offset list
	mov al,[si]
	mov bl,[si+1]
	mov cl,[si+2]
next0:			;第一次比较
	cmp al,bl   ;88h-ffh 寄存器内容 ZF=0,CF=1借位,SF=1最高位是1,OF=0	
	jae next1	;无符号大于跳转(思维逻辑)     寄存器ZF=0时就跳转（计算机逻辑）   ZF!=0无法跳转
	xchg al,bl 	;小于互换   (需要执行) al=ffh,al=88h
next1:
	cmp al,cl   ;比较之后，寄存器内容 ZF!=0不为0,CF=0不进位,SF=0没有溢出	
	jae next2	;无符号大于跳转(思维逻辑)     寄存器ZF=0时就跳转（计算机逻辑）
	xchg al,cl 	;小于互换
next2:
	cmp bl,cl   ;比较之后，寄存器内容 ZF!=0不为0,CF=0不进位,SF=0没有溢出	
	jae next3	;无符号大于跳转(思维逻辑)     寄存器ZF=0时就跳转（计算机逻辑）
	xchg bl,cl 	;小于互换
next3:
	mov [si],al
	mov [si+1],bl
	mov [si+2],cl
	
	mov ax,4c00h
	int 21h
code ends
end start


;以下示例仅为个人实验认知，不保证其准确性

;88h-ffh
;88h 1000 1000
;ffh 1111 1111  补码  0000 0001
;	1	0	00 1000
;+	0	0	00 0001
;	1	0	00 1001=89h			ZF=0,因为结果不是0，SF=1，结果最高位是1, 这个运算没有进位，但因为是减法，需要取反 CF=1
;	最	次
;	高	高
;	进	进
;	位	位
;	0	0	OF=最高进位 XOR 次高进位=0 (一样是0，不一样是1)




;88h-87h
;88h 1000 1000
;87h 1000 0111  补码  0111 1001
;	1	0	00 1000
;+	0	1	11 1001
;1	0	0	00 0001=1h			ZF=0,因为结果不是0，SF=0，结果最高位是0,  这个运算有进位，但因为是减法，需要取反 CF=0
;	最	次
;	高	高
;	进	进
;	位	位
;	1	1	OF=最高进位 XOR 次高进位=0 (一样是0，不一样是1)