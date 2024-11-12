.global _start

.section .data
input_string: .asciz "Este es un ejemplo de una cadena con vocales y consonantes."

.section .bss
    .lcomm vowel_count, 8    // Espacio para almacenar el contador de vocales (64 bits)
    .lcomm consonant_count, 8 // Espacio para almacenar el contador de consonantes (64 bits)

.section .text
_start:
    // Inicializar contadores en 64 bits (x1 para vocales, x2 para consonantes)
    mov x1, 0   // Vocales
    mov x2, 0   // Consonantes

    // Cargar la dirección de la cadena de entrada en x0
    ldr x0, =input_string

count_loop:
    ldrb w3, [x0], #1           // Cargar siguiente carácter (byte) y avanzar el puntero
    cmp w3, #0                  // Comprobar si es el fin de la cadena (nulo)
    beq done                     // Si es nulo, terminar

    // Verificar si es una vocal
    cmp w3, #'a'
    beq increment_vowel
    cmp w3, #'e'
    beq increment_vowel
    cmp w3, #'i'
    beq increment_vowel
    cmp w3, #'o'
    beq increment_vowel
    cmp w3, #'u'
    beq increment_vowel
    cmp w3, #'A'
    beq increment_vowel
    cmp w3, #'E'
    beq increment_vowel
    cmp w3, #'I'
    beq increment_vowel
    cmp w3, #'O'
    beq increment_vowel
    cmp w3, #'U'
    beq increment_vowel

    // Si no es vocal, verificar si es consonante
    cmp w3, #'a'                 // Si es 'a', ya se verificó
    bge check_consonant
    cmp w3, #'A'                 // Si es 'A', ya se verificó
    bge check_consonant

increment_vowel:
    add x1, x1, #1               // Incrementar contador de vocales (x1)
    b count_loop

check_consonant:
    cmp w3, #'Z'
    bge non_alphabet_char
    cmp w3, #'z'
    bge non_alphabet_char
    // Si es una consonante (letra que no es vocal), incrementar el contador de consonantes
    add x2, x2, #1               // Incrementar contador de consonantes (x2)
    b count_loop

non_alphabet_char:
    b count_loop                  // Si no es letra, continuar con el siguiente carácter

done:
    // Cargar las direcciones de memoria para almacenar los resultados
    ldr x3, =vowel_count         // Cargar dirección de memoria de vowel_count
    str x1, [x3]                 // Guardar el contador de vocales en la memoria

    ldr x3, =consonant_count     // Cargar dirección de memoria de consonant_count
    str x2, [x3]                 // Guardar el contador de consonantes en la memoria

    // Salir del programa
    mov x8, 93                   // Syscall para salir
    mov x0, 0                    // Código de salida
    svc 0                         // Llamar al sistema (exit)
