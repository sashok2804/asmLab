.386
.model flat, stdcall
option casemap:none

includelib C:\masm32\lib\msvcrt.lib
includelib C:\masm32\lib\kernel32.lib

printf proto c :ptr byte, :vararg
scanf proto c :ptr byte, :vararg
exit proto c :dword

.data
    ; Сообщения и шаблоны для ввода/вывода
    msgSelect db "Enter the cell number (1-10):", 10, 0
    msgInvalid db "Invalid cell number!", 10, 0
    tpi db "%d", 0          ; Шаблон для ввода
    tpc db "Cell %d contains: %c%c%c%c", 0 ; Шаблон для вывода содержимого ячейки

    ; Инициализация ячеек памяти (каждая ячейка по 4 символа)
    cellData db "ABCD", "EFGH", "IJKL", "MNOP", "QRST", "UVWX", "YZ12", "3456", "7890", "!!??"

    ; Переменные для ввода и вывода
    cellNumber dd 0           ; Номер выбранной ячейки
    cellOffset dd 0           ; Смещение до выбранной ячейки

.code
start proc
    ; Запрашиваем у пользователя номер ячейки
    push offset msgSelect
    call printf
    add esp, 4

    push offset cellNumber
    push offset tpi
    call scanf
    add esp, 8

    ; Проверка валидности введенного номера
    mov eax, cellNumber
    cmp eax, 1
    jl invalid_input         ; Если меньше 1, ошибка
    cmp eax, 10
    jg invalid_input         ; Если больше 10, ошибка

    ; Вычисляем смещение для выбранной ячейки
    dec eax                  ; Преобразуем номер в индекс массива (0-based)
    mov ebx, 4               ; Каждая ячейка содержит 4 символа
    imul eax, ebx            ; Смещение = номер ячейки * 4
    mov cellOffset, eax      ; Сохраняем смещение

    ; Выводим содержимое выбранной ячейки
    mov esi, offset cellData  ; Загружаем базовый адрес cellData
    add esi, cellOffset       ; Прибавляем смещение для выбранной ячейки

    mov al, [esi]             ; Читаем первый символ из ячейки
    mov bl, [esi+1]           ; Читаем второй символ из ячейки
    mov cl, [esi+2]           ; Читаем третий символ из ячейки
    mov dl, [esi+3]           ; Читаем четвертый символ из ячейки

    ; Печатаем четыре символа
    push edx                  ; Подготовка четвертого символа
    push ecx                  ; Подготовка третьего символа
    push ebx                  ; Подготовка второго символа
    push eax                  ; Подготовка первого символа
    push cellNumber
    push offset tpc
    call printf
    add esp, 20               ; Освобождаем стек (5 параметров по 4 байта)

    ; Завершение программы
    push 0
    call exit

invalid_input:
    ; Сообщение об ошибке при неверном номере ячейки
    push offset msgInvalid
    call printf
    add esp, 4

    ; Завершение программы
    push 0
    call exit

start endp
end start
