org 100h

.data
stra db "a", 32, "=", 32, "$"
strb db 10, 13, "b", 32, "=", 32, "$"
stro db 10, 13, "Operation?", 32, "(+,", 32, "-,", 32, "*,", 32, "/):", 32, "$"
strr db 10, 13, "Result:", 32, "$"
stre db 10, 13, "Wrong", 32, "input!", 32, "Try", 32, "again.", 10, 13, "$"
strz db 10, 13, "b", 32, "cannot", 32, "be", 32, "equal", 32, "to", 32, "zero!", 32, "Try", 32, "again.", 10, 13, "$"
strk db 10, 13, 10, 13, "Press", 32, "any", 32, "key", 32, "to", 32, "exit.$"
ostatak dw ?
b dw ?

.code
; unos a
mov ah, 9
lea dx, stra
int 21h

mov ah, 1
int 21h
sub al, 48
mov bl, 10
mul bl
xor ah, ah
mov bx, ax

mov ah, 1
int 21h
sub al, 48
xor ah, ah
add bx, ax
; bx = a
jmp input_b

zero:
mov ah, 9
lea dx, strz
int 21h

input_b:
; unos b
mov ah, 9
lea dx, strb
int 21h

mov ah, 1
int 21h
sub al, 48
mov cl, 10
mul cl
xor ah, ah
mov cx, ax

mov ah, 1
int 21h
sub al, 48
xor ah, ah
add cx, ax
mov b, cx
; cx = b
jmp operation

wrong_input:
mov ah, 9
lea dx, stre
int 21h

operation:
mov ah, 9
lea dx, stro
int 21h

mov ah, 1
int 21h

cmp al, "+"
jz plus
cmp al, "-"
jz minus
cmp al, "*"
jz multiply
cmp al, "/"
jz divide
jmp wrong_input

plus:
add bx, cx
jmp output

minus:
sub bx, cx
jmp output

multiply:
mov ax, bx
mul cx
mov bx, ax
jmp output

divide:
cmp cx, 0
jz zero
mov ax, bx
xor dx, dx
div cx
mov ostatak, dx
mov bx, ax

output:
mov ah, 9
lea dx, strr
int 21h

cmp bx, 0
jge not_minus

mov ah, 2
mov dx, 45
int 21h
neg bx

not_minus:
mov ax, bx
mov bx, 1000
xor dx, dx
div bx
mov cx, dx
add ax, 48
mov dx, ax
mov ah, 2
int 21h
xor ax, ax

mov ax, cx
mov bx, 100
xor dx, dx
div bx
mov cx, dx
add ax, 48
mov dx, ax
mov ah, 2
int 21h
xor ax, ax

mov ax, cx
mov bx, 10
xor dx, dx
div bx
mov cx, dx
add ax, 48
mov dx, ax
mov ah, 2
int 21h
xor ax, ax

add cx, 48
mov dx, cx
mov ah, 2
int 21h

; ostatak
mov dx, 46
mov ah, 2
int 21h
xor ax, ax

mov ax, ostatak
mov bx, 10
mul bx
xor bx, bx
mov bx, b
xor dx, dx
div bx
mov cx, dx
mov dx, ax
add dx, 48
mov ah, 2
int 21h

mov ax, cx
mov bx, 10
mul bx
xor bx, bx
mov bx, b
xor dx, dx
div bx
mov dx, ax
add dx, 48
mov ah, 2
int 21h

; finish
mov ah, 9
lea dx, strk
int 21h
mov ah, 0
int 16h

ret