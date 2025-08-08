;数字比较排序，只使用两个寄存器
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
next0:
	mov al,[si]
	cmp al,[si+1]  
	jae next1	
	xchg al,[si+1] 
	mov [si],al
next1:
	mov al,[si]
	cmp al,[si+2]  
	jae next2
	xchg al,[si+2] 
	mov [si+2],al
next2:
	mov al,[si+1]
	cmp al,[si+2]  
	jae next3	
	xchg al,[si+2] 
	mov [si+1],al
next3:	
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