;字符串16进制转2进制

;=====================

assume cs:code,ds:data

data segment
message db 'aFF25ec0'
messagesize dw $-message
newmessage db 40 dup(0),0dh,0ah,24h
data ends

code segment
start:
	mov ax,data
	mov ds,ax
	mov cx,messagesize
	mov si,0
	mov di,0
fun:
	mov al,message[si]
	call change
	inc si
	loop fun

	mov dx,offset newmessage
	mov ah,9
	int 21h
	
	mov ax,4c00h
	int 21h


change proc near
	pushf
	;判断是不是字母
zm:
	call iszm
	jc zmfun
sz:
	call issz
	jc szfun
yes:
	popf
	ret
change endp


zmfun:  ;字母处理方法  61-a=57
	or al,20h
	sub al,57h
	call jzzh
	jmp yes
szfun: ;数字处理方法  30-0=30
	sub al,30h
	call jzzh
	jmp yes



iszm proc near  ;是不是字母
	cmp al,'A'
	jb no
	cmp al,'z'
	ja no
	stc
	ret
iszm endp


issz proc near  ;是不是数字
	cmp al,'0'
	jb no
	cmp al,'9'
	ja no
	stc
	ret
issz endp


jzzh proc near ;进制转换  8086不支持shl al,5  可以用 shl al,cx实现
	shl al,1     
	shl al,1  
	shl al,1  
	shl al,1  
	shl al,1  	
	mov bl, 0
	adc bl, 30h
	mov newmessage[di],bl
	inc di
	shl al,1
	mov bl, 0
	adc bl, 30h
	mov newmessage[di],bl
	inc di
	shl al,1
	mov bl, 0
	adc bl, 30h
	mov newmessage[di],bl
	inc di
	shl al,1
	mov bl, 0
	adc bl, 30h
	mov newmessage[di],bl
	inc di
	ret
jzzh endp

no:
	clc 
	ret



	
code ends
end start