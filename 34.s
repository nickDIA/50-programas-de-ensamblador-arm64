// Programa para invertir los elementos de un arreglo
// Registros usados:
// x0: dirección base del arreglo
// x1: índice inicio
// x2: índice fin
// x3: valor temporal para intercambio
// x4: valor temporal para intercambio
// x5: dirección temporal inicio
// x6: dirección temporal fin

.data
    // Ejemplo de arreglo
    .align 3                     // Alinear a 8 bytes
    array: .quad 1, 2, 3, 4, 5, 6, 7, 8, 9, 10
    longitud = (. - array) / 8   // Calcular longitud (cada elemento es de 8 bytes)

.text
.global _start

_start:
    // Cargar dirección base del arreglo
    adrp x0, array              // Cargar página del arreglo
    add x0, x0, :lo12:array     // Añadir offset dentro de la página
    
    // Inicializar índices
    mov x1, #0                  // índice inicio = 0
    mov x2, longitud - 1        // índice fin = longitud - 1

invertir_array:
    // Verificar si hemos terminado
    cmp x1, x2                  // Comparar índices
    bge fin                     // Si inicio >= fin, terminamos
    
    // Calcular direcciones de elementos a intercambiar
    mov x5, x0                  // Copiar dirección base
    mov x6, x0                  // Copiar dirección base
    
    // Multiplicar índices por 8 (tamaño de quad word)
    lsl x3, x1, #3             // x3 = inicio * 8
    lsl x4, x2, #3             // x4 = fin * 8
    
    // Sumar offsets a direcciones base
    add x5, x5, x3             // Dirección elemento inicio
    add x6, x6, x4             // Dirección elemento fin
    
    // Cargar valores
    ldr x3, [x5]               // Cargar valor inicio
    ldr x4, [x6]               // Cargar valor fin
    
    // Intercambiar valores
    str x4, [x5]               // Guardar valor fin en posición inicio
    str x3, [x6]               // Guardar valor inicio en posición fin
    
    // Actualizar índices
    add x1, x1, #1             // Incrementar índice inicio
    sub x2, x2, #1             // Decrementar índice fin
    
    b invertir_array           // Siguiente iteración

fin:
    // Finalizar programa
    mov x8, #93                // Syscall exit
    mov x0, #0                 // Código de retorno 0
    svc #0
