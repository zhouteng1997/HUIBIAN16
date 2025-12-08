;读取时钟
;=====================

assume cs:code,ds:data

;这些是全部变量
CMOS_PORT EQU 70H	;CMOS端口地址
CMOS_REGA EQU 0AH	;状态寄存器A地址
UPDATE_F EQU 80H	;更新标志位10000000B
CMOS_SEC EQU 00H	;秒单元地址
CMOS_MIN EQU 02H	;分单元地址
CMOS_HOUR EQU 04H	;时单元地址

;数据段
data segment
SECOND DB ?			;秒
MINUTE DB ?			;分
HOUR DB ?			;时
data ends

;代码段
code segment
start:
	mov ax,data
	mov ds,ax
	
uip:
	mov al,CMOS_REGA
	out CMOS_PORT,al	;把al输出到70端口
	jmp $+2				;为了消耗时钟，确保外部芯片能够响应，现代X86不用考虑，因为是同步的
	in al,CMOS_PORT+1	;把71端口读取到al
	test al,UPDATE_F	;比较更新标志位，结果为0时进行下一步
	jnz uip
	
	mov al,CMOS_SEC
	out CMOS_PORT,al
	jmp $+2
	in al,CMOS_PORT+1	;读秒
	mov SECOND,al
	
	mov al,CMOS_MIN
	out CMOS_PORT,al
	jmp $+2
	in al,CMOS_PORT+1	;读分
	mov MINUTE,al
	
	mov al,CMOS_HOUR
	out CMOS_PORT,al
	jmp $+2
	in al,CMOS_PORT+1	;读时
	mov HOUR,al
	
	
	

	mov ax,4c00h
	int 21h
	
code ends
end start