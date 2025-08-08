;找第一个A,找1024个字，找不到就在0000：03FE处填写0FFFFH
;=====================

startseg=1000H
startadd=0000H
count=1024
zm='A'
endseg=0000H
endadd=03FEH

assume cs:code

code segment
start:
	mov ax,startseg
	mov ds,ax
	mov bx,startadd 
	mov cx,count 
	
	mov al,[bx]
	cmp al,zm
	jz next2	;成功
	inc cx
next0:
	inc bx
	mov al,[bx]
	cmp al,zm
	jz next2	;成功
	loop next0
	
	mov bx,0FFFFH
	
next2:
	mov ax,endseg
	mov ds,ax
	mov si,endadd
	mov [si],bx
	
	mov ax,4c00h
	int 21h
code ends
end star



