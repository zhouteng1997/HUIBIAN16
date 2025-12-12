assume cs:code,ds:data

count=30

score struc
    sno dw 0          ;学号
    sname db 8 dup(?) ;姓名
    syw db 0          ;语文成绩
    ssx db 0          ;数学成绩
    syy db 0          ;英语成绩
score ends

item struc
    snos dw 0        ;学号
    szf dw 0         ;总分
item ends

data segment
    buffer score<>        ;存放原始成绩缓冲区
    stable item count dup(<>) ;预留总分表
    fname1 db 'score.dat',0
    fname2 db 'score.sum',0
data ends

code segment
start:
    mov ax,data
    mov ds,ax
    
    ;打开文件score.dat
    mov dx,offset fname1
    mov ax,3d00h    ;只读方式打开
    int 21h
    jc error_exit    ;添加错误处理
    
    mov bx,ax        ;文件句柄放入bx
    mov di,count
    mov si,offset stable
    
read_loop:
    ;读取一条记录
    mov dx,offset buffer
    mov cx,type score
    mov ah,3fh
    int 21h
    jc read_error    ;读取错误处理
    
    ;计算总分
    mov al,buffer.syw      ;语文成绩
    xor ah,ah
    add al,buffer.ssx      ;加数学成绩
    adc ah,0
    add al,buffer.syy      ;加英语成绩
    adc ah,0
    
    ;保存到stable
    mov [si].szf,ax        ;修正：使用szf而不是sum
    mov ax,buffer.sno      ;修正：使用sno而不是no
    mov [si].snos,ax       ;修正：使用snos而不是nos
    
    add si,type item
    dec di
    jnz read_loop
    
read_done:
    ;关闭输入文件
    mov ah,3eh
    int 21h
    
    ;创建输出文件
    mov dx,offset fname2
    mov cx,0
    mov ah,3ch
    int 21h
    jc create_error
    
    mov bx,ax
    
    ;写入总分表
    mov dx,offset stable
    mov cx,(type item)*count
    mov ah,40h
    int 21h
    
    ;关闭输出文件
    mov ah,3eh      ;修正：去掉多余的h
    int 21h
    
exit:
    mov ax,4c00h
    int 21h

read_error:
    mov ah,3eh      ;关闭文件
    int 21h
    jmp exit

create_error:
    ;输出文件创建失败，直接退出
    jmp exit

error_exit:
    ;打开文件失败，直接退出
    jmp exit
    
code ends
end start