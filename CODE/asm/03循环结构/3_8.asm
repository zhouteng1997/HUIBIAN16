;字符串包含
;=====================

assume cs:code,ds:data

data segment
string1 db "AAAABBBBCCCCABCDDDD",0
string1_size dw $-string1-1
string2 db "ABCD",0
result db 0
data ends

code segment
start:
	mov ax,data
	mov ds,ax
	
	mov cx,string1_size
	
	xor si,si
	xor di,di
	
next0:			;这次先写外圈循环
	mov bx,si

next2:
	cmp string2[di],0 ;如果第二个字符比对到了0，说明完全匹配
	jz last
	
	mov al,string1[bx]
	cmp al,string2[di]
	jnz next1			;不相等，进去下个循环
	inc bx
	inc di
	jmp next2			;相等比较下一个字符


next1:
	inc si
	xor di,di
	loop next0

	mov si,0ffffh	;没有匹配到
last:
	mov ax,si
	mov result,al
	mov ax,4c00h
	int 21h
code ends
end start

;结果是0c ,12   AAAABBBBCCCCABCDDDD   第13位是ABCD，下标是12=0c



