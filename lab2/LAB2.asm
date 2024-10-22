.386
.model flat, stdcall
option casemap:none

includelib C:\masm32\lib\msvcrt.lib
includelib C:\masm32\lib\kernel32.lib

printf proto c :ptr byte, :vararg
scanf proto c :ptr byte, :vararg
exit proto c :dword

.data
    varA dd 0              ; переменная A
    varB dd 0              ; переменная B
    varK dd 0              ; переменная K

    msgA db "Enter A:", 13, 0   ; сообщение для ввода A
    msgB db "Enter B:", 13, 0   ; сообщение для ввода B
    msgK db "Enter K:", 13, 0   ; сообщение для ввода K

    tpi db "%d", 0          ; шаблон для ввода
    tpt db "S = %d", 10, 0  ; шаблон для вывода

.code
start:
    ; Вводим A
    push offset msgA
    call printf
    add esp, 4

    push offset varA
    push offset tpi
    call scanf
    add esp, 8

    ; Вводим B
    push offset msgB
    call printf
    add esp, 4

    push offset varB
    push offset tpi
    call scanf
    add esp, 8

    ; Вводим K
    push offset msgK
    call printf
    add esp, 4

    push offset varK
    push offset tpi
    call scanf
    add esp, 8

    ; Вычисляем s = a * b / 2 - k + a / 2 - b

    ; Загружаем a в eax
    mov eax, varA           ; EAX = a
    mov ebx, varB           ; EBX = b

    ; Умножаем a на b
    imul eax, ebx           ; EAX = a * b

    ; Делим результат на 2
    shr eax, 1              ; EAX = a * b / 2

    ; Вычитаем k
    sub eax, varK           ; EAX = a * b / 2 - k

    ; Добавляем a / 2
    mov ebx, varA           ; EBX = a
    shr ebx, 1              ; EBX = a / 2
    add eax, ebx            ; EAX = a * b / 2 - k + a / 2

    ; Вычитаем b
    sub eax, varB           ; EAX = a * b / 2 - k + a / 2 - b

    ; Выводим результат
    push eax                ; значение результата
    push offset tpt         ; строка шаблона вывода
    call printf
    add esp, 8

    ; Завершаем программу
    push 0
    call exit

end start
