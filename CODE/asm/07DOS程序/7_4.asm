;创建并写入文件，修改文件，关闭文件
;=====================

assume cs:code,ds:data

data segment
address db '666.txt',0h
txt db '666.txt111111',0h
data ends

code segment
start:
	mov ax,data
	mov ds,ax
	
	mov dx,offset address
	;创建文件
	xor cx,cx
	mov ah,3ch
	int 21h
	jc createerror
	;写入文件
	mov dx,offset txt
	mov bx,ax
	mov cx,10
	mov ah,40h
	int 21h
	jc writeerror
	;关闭文件
	mov ah,3eh
	int 21h
createerror:
	jmp last
writeerror:
	jmp last
last:
	mov ax,4c00h
	int 21h
	
code ends
end start