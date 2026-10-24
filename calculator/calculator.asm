section .data
    msg db "-----------------------------------", 10, 0
    msg1 db "Hi! This is Michelle Tercero and we are here to help you perform operations for 3 signed two-digit numbers (-99 to 99).", 10, 0
    msg2 db "==== SIMPLE CALCULATOR by Michelle Tercero ====", 10, 0
    msg_menu db "[0] Exit", 10, "[1] Add", 10, "[2] Subtract", 10, "[3] Multiply", 10, "[4] Divide", 10, "Enter choice: ", 0

    msg_add db "==== ADDITION ====", 10, 0
    msg_sub db "==== SUBTRACTION ====", 10, 0
    msg_mul db "==== MULTIPLICATION ====", 10, 0
    msg_div db "==== DIVISION ====", 10, 0

    prompt1 db "Enter the first number (-99 to 99): ", 0
    prompt2 db "Enter the second number (-99 to 99): ", 0
    prompt3 db "Enter the third number (-99 to 99): ", 0

    msg_sum db "Sum: %d", 10, 0
    msg_diff db "Difference: %d", 10, 0
    msg_prod db "Product: %d", 10, 0
    msg_quo db "Quotient: %d", 10, 0
    msg_rem db "Remainder: %d", 10, 0

    msg_invalid_input db "Input should only be between -99 to 99. Please enter again a valid input.", 10, 0
    msg_error_div0 db "You cannot divide by 0. Please enter a valid divisor again.", 10, 0

    msgline db 10, 0
    thank_you db 10, "Thank you!", 10, 0

    fmt_in db "%d", 0

section .bss
    num1 resd 1
    num2 resd 1
    num3 resd 1
    choice resd 1
    result resd 1
    quotient resd 1
    remainder resd 1

section .text
    extern _printf, _scanf
    global _main

_main:
    ; Display welcome
    push msg
    call _printf
    add esp, 4

    push msg1
    call _printf
    add esp, 4

.menu:
    push msg2
    call _printf
    add esp, 4

    push msg_menu
    call _printf
    add esp, 4

    push choice
    push fmt_in
    call _scanf
    add esp, 8

    mov eax, [choice]
    cmp eax, 0
    je .exit
    cmp eax, 1
    je .add
    cmp eax, 2
    je .subtract
    cmp eax, 3
    je .multiply
    cmp eax, 4
    je .divide
    jmp .menu

; ================================
; ======== ADDITION ==============
; ================================
.add:
    push msg_add
    call _printf
    add esp, 4
    call get_three_numbers

    mov eax, [num1]
    add eax, [num2]
    add eax, [num3]
    mov [result], eax

    push dword [result]
    push msg_sum
    call _printf
    add esp, 8
    jmp .menu

; ================================
; ======== SUBTRACTION ===========
; ================================
.subtract:
    push msg_sub
    call _printf
    add esp, 4
    call get_three_numbers

    mov eax, [num1]
    sub eax, [num2]
    sub eax, [num3]
    mov [result], eax

    push dword [result]
    push msg_diff
    call _printf
    add esp, 8
    jmp .menu

; ================================
; ======== MULTIPLICATION ========
; ================================
.multiply:
    push msg_mul
    call _printf
    add esp, 4
    call get_three_numbers

    mov eax, [num1]
    imul eax, [num2]
    imul eax, [num3]
    mov [result], eax

    push dword [result]
    push msg_prod
    call _printf
    add esp, 8
    jmp .menu

; ================================
; ========== DIVISION ============
; ================================
.divide:
    push msg_div
    call _printf
    add esp, 4

    ; ===== First Number =====
.first_input:
    push prompt1
    call _printf
    add esp, 4
    push num1
    push fmt_in
    call _scanf
    add esp, 8
    mov eax, [num1]
    cmp eax, -99
    jl .error_first
    cmp eax, 99
    jg .error_first
    jmp .second_input

.error_first:
    push msg_invalid_input
    call _printf
    add esp, 4
    jmp .first_input

    ; ===== Second Number =====
.second_input:
    push prompt2
    call _printf
    add esp, 4
    push num2
    push fmt_in
    call _scanf
    add esp, 8

    mov eax, [num2]
    cmp eax, -99
    jl .error_second
    cmp eax, 99
    jg .error_second
    cmp eax, 0
    je .error_div0

    jmp .do_first_div

.error_second:
    push msg_invalid_input
    call _printf
    add esp, 4
    jmp .second_input

.error_div0:
    push msg_error_div0
    call _printf
    add esp, 4
    jmp .second_input

.do_first_div:
    mov eax, [num1]
    mov ebx, [num2]
    cdq
    idiv ebx
    mov [quotient], eax
    mov [remainder], edx

    push dword [quotient]
    push msg_quo
    call _printf
    add esp, 8
    push dword [remainder]
    push msg_rem
    call _printf
    add esp, 8

    ; ===== Third Number =====
.third_input:
    push prompt3
    call _printf
    add esp, 4
    push num3
    push fmt_in
    call _scanf
    add esp, 8
    mov eax, [num3]
    cmp eax, -99
    jl .error_third
    cmp eax, 99
    jg .error_third
    cmp eax, 0
    je .error_div0b
    jmp .do_second_div

.error_third:
    push msg_invalid_input
    call _printf
    add esp, 4
    jmp .third_input

.error_div0b:
    push msg_error_div0
    call _printf
    add esp, 4
    jmp .third_input

.do_second_div:
    mov eax, [quotient]
    mov ebx, [num3]
    cdq
    idiv ebx
    mov [quotient], eax
    mov [remainder], edx

    push dword [quotient]
    push msg_quo
    call _printf
    add esp, 8
    push dword [remainder]
    push msg_rem
    call _printf
    add esp, 8

    jmp .menu

; ================================
; ========== EXIT ================
; ================================
.exit:
    push thank_you
    call _printf
    add esp, 4
    ret

; ================================
; ===== Helper function ==========
; ================================
get_three_numbers:
    ; First input
.first:
    push prompt1
    call _printf
    add esp, 4
    push num1
    push fmt_in
    call _scanf
    add esp, 8
    mov eax, [num1]
    cmp eax, -99
    jl .err_first
    cmp eax, 99
    jg .err_first
    jmp .second

.err_first:
    push msg_invalid_input
    call _printf
    add esp, 4
    jmp .first

.second:
    push prompt2
    call _printf
    add esp, 4
    push num2
    push fmt_in
    call _scanf
    add esp, 8
    mov eax, [num2]
    cmp eax, -99
    jl .err_second
    cmp eax, 99
    jg .err_second
    jmp .third

.err_second:
    push msg_invalid_input
    call _printf
    add esp, 4
    jmp .second

.third:
    push prompt3
    call _printf
    add esp, 4
    push num3
    push fmt_in
    call _scanf
    add esp, 8
    mov eax, [num3]
    cmp eax, -99
    jl .err_third
    cmp eax, 99
    jg .err_third
    ret

.err_third:
    push msg_invalid_input
    call _printf
    add esp, 4
    jmp .third
