.386
.model flat, stdcall
option casemap:none

includelib C:\masm32\lib\msvcrt.lib
includelib C:\masm32\lib\kernel32.lib

printf proto c :ptr byte, :vararg
exit proto c :dword

.data
    msgResult db "The sum of numbers from 1 to 10 is: %d", 13, 0
    sum DWORD 0

.code
start proc
    ; Вводим значения для формулы арифметической прогрессии
    mov eax, 10           ; n = 10
    mov ebx, 1            ; a1 = 1
    add ebx, eax          ; a1 + an = 1 + 10
    imul eax, ebx         ; n * (a1 + an)
    shr eax, 1            ; Делим на 2

    ; Сохраняем результат в переменную
    mov sum, eax

    ; Выводим результат
    push sum
    push offset msgResult
    call printf
    add esp, 8

    ; Завершение программы
    push 0
    call exit
start endp
end start
