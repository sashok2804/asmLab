.386
.model flat, stdcall
option casemap:none

; Подключаем библиотеки для стандартных функций
includelib C:\masm32\lib\msvcrt.lib
includelib C:\masm32\lib\kernel32.lib

printf proto c :ptr byte, :vararg
scanf proto c :ptr byte, :vararg
exit proto c :dword

.data
    ; Объявляем переменные для хранения значений A, B, D и результата
    varA dd 0
    varB dd 0
    varD dd 0
    varX dd 0

    ; Сообщения для пользователя
    msgA db "Enter A:", 13, 0  ; Сообщение "Введите A"
    msgB db "Enter B:", 13, 0  ; Сообщение "Введите B"
    msgD db "Enter D:", 13, 0  ; Сообщение "Введите D"
    tpi db "%d", 0                 ; Формат для ввода числа
    tpt db "Result X = %d", 0  ; Формат для вывода результата

.code
start proc
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

    ; Вводим D
    push offset msgD
    call printf
    add esp, 4

    push offset varD
    push offset tpi
    call scanf
    add esp, 8

    ; Выполняем вычисление X = (A + B) * (B - 1) / (D + 8)
    mov eax, varB           ; EAX = B
    sub eax, 1              ; EAX = B - 1
    mov ebx, varA           ; EBX = A
    add ebx, varB           ; EBX = A + B
    imul eax, ebx           ; EAX = (A + B) * (B - 1)
    mov ecx, varD           ; ECX = D
    add ecx, 8              ; ECX = D + 8
    cdq                     ; Расширение EAX на EDX:EAX для деления
    idiv ecx                ; EAX = (A + B) * (B - 1) / (D + 8)

    ; Сохраняем результат
    mov varX, eax

    ; Выводим результат
    push eax                ; Кладем результат на стек
    push offset tpt         ; Кладем строку для вывода на стек
    call printf             ; Вызываем printf для вывода
    add esp, 8              ; Очищаем стек

    ; Завершаем программу
    push 0
    call exit

start endp
end start
