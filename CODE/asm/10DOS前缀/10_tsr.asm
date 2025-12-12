;TSR程序（内存驻留程序）- 在屏幕右上角显示时钟
;=====================

assume cs:code,ds:code

code segment
count_val=18      ;间隔滴答声（18个时钟滴答约为1秒）
dpage=0           ;显示页号（0表示第0页）
row=0             ;显示时钟的行号（第0行）
column=70         ;显示时钟的开始列（屏幕右侧）
color=07h         ;显示时钟的属性值（灰底黑字）

;数据定义区
count dw count_val  ;滴答计数
hhhh db '  :','$'   ;时（预留2字符+冒号）
mmmm db '  :','$'   ;分（预留2字符+冒号）
ssss db '  $','$'   ;秒（预留2字符）
buff_len=8         ;显示信息长度"HH:MM:SS"
cursor dw ?         ;保存原光标位置
OLD1CH DD ?         ;原1Ch中断向量（4字节）

;---------------------------------------------------
;新的1Ch中断处理程序（时钟中断）
new1ch:
    pushf                   ; 保存标志寄存器
    push ax
    push ds
    
    push cs
    pop ds                  ; DS指向代码段
    
    ; 保护关键代码段
    cli                     ; 关中断
    
    dec count               ; 计数减1
    jnz exit_new1ch         ; 不为0则直接退出
    
    ; 计数为0，需要更新时间显示
    mov count, count_val    ; 重置计数
    
    sti                     ; 开中断（允许显示过程中的中断）
    
    ; 保存所有用到的寄存器
    push es
    push bx
    push cx
    push dx
    push si
    push bp
    
    push ds
    pop es                  ; ES也指向代码段
    
    call get_time           ; 获取当前时间
    
    ; 读取当前光标位置
    mov ah, 03h             ; 功能号：读取光标位置
    mov bh, dpage
    int 10h                 ; DH=行，DL=列
    mov cursor, dx          ; 保存原光标位置
    
    ; 显示时钟字符串
    mov ah, 13h             ; 显示字符串功能
    mov al, 0               ; 写入模式
    mov bh, dpage           ; 显示页号
    mov bl, color           ; 属性
    mov cx, buff_len        ; 字符串长度
    mov dh, row             ; 行号
    mov dl, column          ; 列号
    mov bp, offset hhhh     ; ES:BP指向字符串
    int 10h
    
    ; 恢复光标位置
    mov ah, 02h             ; 设置光标位置
    mov bh, dpage
    mov dx, cursor
    int 10h
    
    ; 恢复寄存器
    pop bp
    pop si
    pop dx
    pop cx
    pop bx
    pop es
    
exit_new1ch:
    pop ds
    pop ax
    popf                    ; 恢复标志寄存器
    
    ; 跳转到原来的1Ch中断处理程序
    jmp dword ptr cs:old1ch

;---------------------------------------------------
;获取当前时间并格式化显示字符串
get_time proc
    mov ah, 02h             ; 读取实时时钟时间
    int 1ah                 ; CH=时，CL=分，DH=秒（BCD格式）
    
    ; 处理小时
    mov al, ch
    call bcd_to_ascii
    mov [hhhh], ah
    mov [hhhh+1], al
    
    ; 处理分钟
    mov al, cl
    call bcd_to_ascii
    mov [mmmm], ah
    mov [mmmm+1], al
    
    ; 处理秒钟
    mov al, dh
    call bcd_to_ascii
    mov [ssss], ah
    mov [ssss+1], al
    
    ret
get_time endp

;---------------------------------------------------
;BCD码转ASCII码
;输入：AL=BCD码
;输出：AH=十位ASCII，AL=个位ASCII
bcd_to_ascii proc
    mov ah, al
    and al, 0Fh             ; 取低4位（个位）
    shr ah, 1               ; 取高4位（十位）
	shr ah, 1
	shr ah, 1
	shr ah, 1
    or ax, 3030h            ; 转换为ASCII
    ret
bcd_to_ascii endp

;---------------------------------------------------
;初始化部分（TSR安装代码）
start:
    push cs
    pop ds                  ; DS指向代码段
    
    ; 获取原来的1Ch中断向量
    mov ax, 351ch           ; 功能35h，中断1Ch
    int 21h                 ; ES:BX = 原中断向量
    mov word ptr old1ch, bx
    mov word ptr old1ch+2, es
    
    ; 设置新的1Ch中断向量
    mov dx, offset new1ch
    mov ax, 251ch           ; 功能25h，中断1Ch
    int 21h
    
    ; 显示安装成功信息
    mov dx, offset msg_installed
    mov ah, 09h
    int 21h
    
    ; 计算并驻留内存
    mov dx, offset start    ; 程序起始地址
    add dx, 15              ; 向上取整
    mov cl, 4
    shr dx, cl              ; 转换为段落数
    add dx, 10h             ; 额外保留空间
    
    mov ax, 3100h           ; 功能31h，返回码00h
    int 21h                 ; 终止并驻留
    
msg_installed db 'Clock TSR installed successfully!', 0Dh, 0Ah, '$'

code ends
end start