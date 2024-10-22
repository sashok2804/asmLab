.386
.model flat, stdcall
option casemap:none

includelib C:\masm32\lib\msvcrt.lib
includelib C:\masm32\lib\kernel32.lib

printf proto c :ptr byte, :vararg
exit proto c :dword

.data
    msgMaxElement db "The largest element in the array is: %d", 13, 10, 0
    arr DWORD 1, 333, 2, 3, 4, 5, 6, 6987  ; Зашитый массив
    arraySize DWORD 8        ; Размер массива — 8 элементов
    maxElement DWORD ?

.code
start proc
    ; Инициализация максимального элемента (первый элемент массива)
    mov eax, arr           ; Берем первый элемент массива
    mov maxElement, eax    ; Устанавливаем его как максимальный

    ; Начинаем цикл с 1-го элемента
    mov ecx, arraySize     ; Количество элементов в массиве
    mov ebx, 1             ; Индекс 1, так как arr[0] уже используется как maxElement

find_max_loop:
    cmp ebx, ecx           ; Проверяем, дошли ли до конца массива
    jge find_max_done      ; Если дошли до конца, завершаем цикл

    ; Сравниваем текущий элемент с максимальным
    mov eax, arr[ebx*4]    ; Загружаем arr[ebx]
    cmp eax, maxElement    ; Сравниваем с текущим максимумом
    jle skip               ; Если меньше или равно, пропускаем
    mov maxElement, eax    ; Обновляем максимум

skip:
    inc ebx                ; Переход к следующему элементу
    jmp find_max_loop      ; Возврат в цикл

find_max_done:
    ; Вывод наибольшего элемента
    push maxElement        ; Подготовка наибольшего элемента
    push offset msgMaxElement
    call printf
    add esp, 8             ; Очищаем стек

    ; Завершение программы
    push 0
    call exit

start endp
end start
