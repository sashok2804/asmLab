.386
.model flat, stdcall
option casemap:none

includelib C:\masm32\lib\msvcrt.lib
includelib C:\masm32\lib\kernel32.lib

printf proto c :ptr byte, :vararg
exit proto c :dword

.data
    msgMinElement db "The smallest element in the array is: %d", 13, 10, 0
    arr DWORD 1, 333, 2, 3, 4, 5, 6, 6987  ; Зашитый массив
    arraySize DWORD 8        ; Размер массива — 8 элементов
    minElement DWORD ?

.code
start proc
    ; Инициализация минимального элемента (первый элемент массива)
    mov eax, arr           ; Берем первый элемент массива
    mov minElement, eax    ; Устанавливаем его как минимальный

    ; Начинаем цикл с 1-го элемента
    mov ecx, arraySize     ; Количество элементов в массиве
    mov ebx, 1             ; Индекс 1, так как arr[0] уже используется как minElement

find_min_loop:
    cmp ebx, ecx           ; Проверяем, дошли ли до конца массива
    jge find_min_done      ; Если дошли до конца, завершаем цикл

    ; Сравниваем текущий элемент с минимальным
    mov eax, arr[ebx*4]    ; Загружаем arr[ebx]
    cmp eax, minElement    ; Сравниваем с текущим минимумом
    jge skip               ; Если больше или равно, пропускаем
    mov minElement, eax    ; Обновляем минимум

skip:
    inc ebx                ; Переход к следующему элементу
    jmp find_min_loop      ; Возврат в цикл

find_min_done:
    ; Вывод наименьшего элемента
    push minElement        ; Подготовка наименьшего элемента
    push offset msgMinElement
    call printf
    add esp, 8             ; Очищаем стек

    ; Завершение программы
    push 0
    call exit

start endp
end start
