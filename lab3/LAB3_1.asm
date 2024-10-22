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
    msgSelect db "Enter the cell number (1-20):", 13, 0
    msgInvalid db "Invalid cell number!", 13, 0
    tpi db "%d", 0          ; Шаблон для ввода
    tpc db "Cell %d contains: %c%c", 0 ; Шаблон для вывода содержимого ячейки

    ; Инициализация ячеек памяти
    cellData db "AB", "CD", "EF", "GH", "IJ", "KL", "MN", "OP", "QR", "ST"
    db "UV", "WX", "YZ", "12", "34", "56", "78", "90", "!!", "??"

    
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
    cmp eax, 20
    jg invalid_input         ; Если больше 20, ошибка

    ; Вычисляем смещение для выбранной ячейки
    dec eax                  ; Преобразуем номер в индекс массива (0-based)
    mov ebx, 2               ; Каждая ячейка содержит 2 символа
    imul eax, ebx            ; Смещение = номер ячейки * 2
    mov cellOffset, eax      ; Сохраняем смещение

    ; Выводим содержимое выбранной ячейки
    mov esi, offset cellData  ; Загружаем базовый адрес cellData
    add esi, cellOffset       ; Прибавляем смещение для выбранной ячейки

    mov al, [esi]             ; Читаем первый символ из ячейки
    mov dl, [esi+1]           ; Читаем второй символ из ячейки

    ; Печатаем два символа отдельно
    push edx                  ; Подготовка второго символа
    push eax                  ; Подготовка первого символа
    push cellNumber
    push offset tpc
    call printf
    add esp, 16               ; Освобождаем стек (4 параметра по 4 байта)

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
    