org 100h

.data
string_a db "a = ", "$"
string_b db 10, 13, "b = ", "$"
string_operation db 10, 13, "Operation? (+, -, *, /): ", "$"
string_result db 10, 13, "Result: ", "$"
string_error db 10, 13, "Wrong input", 33, " Try again.", 10, 13, "$"
string_zero db 10, 13, "b cannot be equal to zero", 32, " Try again.", 10, 13, "$"
string_key db 10, 13, 10, 13, "Press any key to exit. ", "$"
remainder_of_division dw ?
b dw ?

.code
; printing out string_a
mov ah, 9
lea dx, string_a
int 21h

; getting input of two-digit a
mov ah, 1  ; first digit
int 21h
sub al, 48
mov bl, 10
mul bl
xor ah, ah
mov bx, ax

mov ah, 1  ; second digit
int 21h
sub al, 48
xor ah, ah

add bx, ax  ; a is located in bx

jmp input_b  ; jumping over zero string, because there is no selected operation yet

zero:
    mov ah, 9
    lea dx, string_zero
    int 21h

input_b:
    ; getting input of two-digit b
    mov ah, 9
    lea dx, string_b
    int 21h

    mov ah, 1  ; first digit
    int 21h
    sub al, 48
    mov cl, 10
    mul cl
    xor ah, ah
    mov cx, ax

    mov ah, 1  ; second digit
    int 21h
    sub al, 48
    xor ah, ah
    add cx, ax

    mov b, cx  ; b is located in cx

    jmp operation  ; jumping over error string

wrong_input:
    mov ah, 9
    lea dx, string_error
    int 21h

operation:
    mov ah, 9
    lea dx, string_operation
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
    jmp output  ; jumping over to output

minus:
    sub bx, cx
    jmp output  ; jumping over to output

multiply:
    mov ax, bx
    mul cx
    mov bx, ax
    jmp output  ; jumping over to output

divide:
    cmp cx, 0
    jz zero
    mov ax, bx
    xor dx, dx
    div cx
    mov remainder_of_division, dx
    mov bx, ax
    ; no jump because output goes next anyways

output:
    mov ah, 9
    lea dx, string_result
    int 21h

    cmp bx, 0
    jge not_minus

    mov ah, 2
    mov dx, 45
    int 21h
    neg bx

not_minus:
    ; printing out four-digit number
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

    ; printing out . and remainder of the division
    mov dx, 46
    mov ah, 2
    int 21h
    xor ax, ax

    mov ax, remainder_of_division
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

    mov ah, 9
    lea dx, string_key
    int 21h
    mov ah, 0
    int 16h

ret

