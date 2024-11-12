// Programa para rotar elementos de un arreglo
// Registros usados:
// x0: dirección base del arreglo
// x1: longitud del arreglo
// x2: cantidad de posiciones a rotar
// x3-x4: índices para reversión
// x5-x6: valores temporales para intercambio
// x7: dirección temporal
// x8: dirección temporal

.data
    .align 3                     // Alinear a 8 bytes
    array: .quad 1, 2, 3, 4, 5, 6, 7, 8, 9, 10
    longitud = (. - array) / 8   // Calcular longitud (elementos de 8 bytes)
    rotaciones = 3               // Número de posiciones a rotar (positivo=izquierda, negativo=derecha)

.text
.global _start

_start:
    // Cargar dirección base del arreglo
    adrp x0, array
    add x0, x0, :lo12:array
    
    // Inicializar registros
    mov x1, longitud            // Longitud del arreglo
    mov x2, rotaciones         // Cantidad de rotaciones

    // Normalizar rotaciones si son negativas o mayores que la longitud
    cmp x2, #0
    bge normalizar_positivo
    
    // Si es negativo, convertir a rotación equivalente a la izquierda
    add x2, x2, x1
    
normalizar_positivo:
    // Asegurar que rotaciones < longitud
    sdiv x3, x2, x1
    msub x2, x3, x1, x2    // x2 = x2 % longitud

    // Si rotaciones es 0, terminar
    cbz x2, fin

rotar_izquierda:
    // Paso 1: Revertir primeros k elementos
    mov x3, #0              // índice inicio
    sub x4, x2, #1          // índice fin
    bl revertir_subarray
    
    // Paso 2: Revertir elementos restantes
    mov x3, x2              // índice inicio
    sub x4, x1, #1          // índice fin
    bl revertir_subarray
    
    // Paso 3: Revertir todo el array
    mov x3, #0              // índice inicio
    sub x4, x1, #1          // índice fin
    bl revertir_subarray
    b fin

// Subrutina para revertir un subarray entre los índices x3 y x4
revertir_subarray:
    // Guardar dirección de retorno
    str x30, [sp, #-16]!
    
revertir_loop:
    // Verificar si hemos terminado
    cmp x3, x4
    bge revertir_fin
    
    // Calcular direcciones
    mov x7, x0
    mov x8, x0
    lsl x5, x3, #3         // x5 = inicio * 8
    lsl x6, x4, #3         // x6 = fin * 8
    add x7, x7, x5         // Dirección elemento inicio
    add x8, x8, x6         // Dirección elemento fin
    
    // Intercambiar elementos
    ldr x5, [x7]           // Cargar elemento inicio
    ldr x6, [x8]           // Cargar elemento fin
    str x6, [x7]           // Guardar fin en inicio
    str x5, [x8]           // Guardar inicio en fin
    
    // Actualizar índices
    add x3, x3, #1
    sub x4, x4, #1
    
    b revertir_loop

revertir_fin:
    // Restaurar dirección de retorno
    ldr x30, [sp], #16
    ret

fin:
    mov x8, #93            // Syscall exit
    mov x0, #0             // Código de retorno
    svc #0
