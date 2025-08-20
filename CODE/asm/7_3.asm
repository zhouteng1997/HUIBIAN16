;实现一个用户输入段地址+基址，读取内存数据的操作
;=====================
;内存地址1234:5678的值为7B

assume cs:code,ds:data

data segment
address dw 0000,0000h ;保存输入的段和基址
input db 8 dup(30h),24h
message1 db 'Please input segment:',24h
message2 db 'Please input address:',24h
tg db 08h
hc db 0dh
kg db 20h
data ends

code segment
start:
	mov ax,data
	mov ds,ax

	call newline
	call newline
	;提示用户需输入段址，dx用作传参
	mov dx,offset message1
	mov di,offset input
	call waitinput ;等待输入
	mov dx,di
	call newline
	call showmessage;显示输入的内容，主要判断是否保存成功
	
	call newline
	;提示用户需输入基址，dx用作传参
	mov dx,offset message2
	mov di,offset input
	add di,4
	call waitinput ;等待输入
	mov dx,offset input
	call newline
	call showmessage;显示输入的内容，主要判断是否保存成功
	
	call inputtoaddress
	
	call newline
	;需要先取基址
	mov bx,address[2]
	mov ds,address
	mov ax,[bx]
	call wordzs
	
	
	mov ax,4c00h
	int 21h

;显示文字
showmessage proc near  ;此方法会修改ah，所以需要保存现场
	push ax
	mov ah,9
	int 21h
	pop ax
	ret
showmessage endp

;显示单个字符 ,入参是al，显示al
showword proc near  ;此方法会修改ah，所以需要保存现场
	push ax
	push dx
	mov dl,al
	mov ah,2
	int 21h
	pop dx
	pop ax
	ret
showword endp


;等待输入，会返回一个正确的al，在0-f之间, 入参是dx，展示需要显示的文字,di是保存位置
waitinput proc near  ;此方法会修改al，所以需要保存现场
	push sp
	push bp
	push ax
	mov bp,sp
	
restart:
	call showmessage
	;call newline
	mov sp,bp
	mov cx,5
	sub sp,2 ;在栈中申请一块内存，用于保存用户输入的结果
next:
	mov ah,7 ;不显示的输入***********************************特别重要****************************
	int 21h
	mov [bp-2],al ;保存用户输入123
	jmp judge
fail:
	jmp next	;失败单个重新输入
error:
	call newline
	jmp restart ;错误全部重新输入
success:
	push ax
	call showword
	loop next

	;保存正确输入的值
	pop ax
	pop ax
	mov [di+3],al
	pop ax
	mov [di+2],al
	pop ax
	mov [di+1],al
	pop ax
	mov [di],al
	
	mov sp,bp ;不管内部参数，强制平栈
	pop ax
	pop bp
	pop sp
	ret
waitinput endp

;检验输入的字符是否符合，并小写字符大写话，规范格式
judge:
	cmp al,tg
	je failtg		;退格
	cmp al,hc
	je successhc	;回车
	cmp al,'0' 
	jb fail			;小于0
	cmp al,'9' 
	jbe success16		;小于等于9
	cmp al,'A' 
	jb fail			;小于A
	cmp al,'F' 
	jbe successlow		;小于等于F
	cmp al,'a' 
	jb fail			;小于a
	cmp al,'f' 
	jbe success16	;小于等于f
	ja fail	   		;大于z
successlow:
	and al,20h 
	jmp success16
failtg:
	cmp cx,5
	jz fail
	call tgproc
	pop ax
	add cx,01h
	jmp fail
successhc:
	cmp cx,1 
	jz success
	jnz error
success16:
	cmp cx,1 
	jz error
	jnz success
	
newline proc near
	push dx
	push ax
	mov ah,02h
	mov dl,0dh
	int 21h
	mov dl,0ah
	int 21h
	pop ax
	pop dx
	ret
newline endp

tgproc proc near
	push dx
	push ax
	;退格
	mov ah,02h
	mov dl,tg
	int 21h
	;输出空格
	mov ah,02h
	mov dl,kg
	int 21h
	;再退格
	mov ah,02h
	mov dl,tg
	int 21h
	pop ax
	pop dx
	ret
tgproc endp

;输入内容转地址
inputtoaddress proc near
	push cx
	mov si,offset input
	mov di,offset address
	
	mov cl,4
	
	mov al,[si]
	call zmzh
	mov dl,al
	shl dl,cl
	mov al,[si+1]
	call zmzh
	or dl,al
	mov [di+1],dl
	
	
	mov al,[si+2]
	call zmzh
	mov dl,al
	shl dl,cl
	mov al,[si+3]
	call zmzh
	or dl,al
	mov [di+0],dl
	
	
	mov al,[si+4]
	call zmzh
	mov dl,al
	shl dl,cl
	mov al,[si+5]
	call zmzh
	or dl,al
	mov [di+3],dl
	
	mov al,[si+6]
	call zmzh
	mov dl,al
	shl dl,cl
	mov al,[si+7]
	call zmzh
	or dl,al
	mov [di+2],dl

	pop cx
	ret
inputtoaddress endp




;字母数字转化为16进制
zmzh proc near
	cmp al,'9'
	jbe j30
	sub al,27h
j30:
	sub al,30h
	ret
zmzh endp


;16进制展示 入参al
wordzs proc near
	mov dl,al
	and al,0f0h
	mov cl,4
	shr al,cl
	cmp al,9
	ja j37
	add al,30h
	jmp wordzslast
j37:
	add al,37h
wordzslast:	
	call showword

	and dl,0fh
	mov al,dl
	cmp al,9
	ja j371
	add al,30h
	jmp wordzslast1
j371:
	add al,37h
wordzslast1:
	call showword
	
	ret
wordzs endp


	

	
code ends
end start