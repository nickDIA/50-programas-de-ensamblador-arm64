// Programa para sumar elementos de un arreglo
// Registros usados:
// x0: dirección base del arreglo
// x1: longitud del arreglo
// x2: suma total
// x3-x6: valores temporales para desenrollado de bucle
// x7: contador de elementos restantes

.data
    .align 3                     // Alinear a 8 bytes
    array: .quad 1, 2, 3, 4, 5, 6, 7, 8, 9, 10
    longitud = (. - array) / 8   // Calcular longitud (elementos de 8 bytes)

.text
.global _start

_start:
    // Cargar dirección base del arreglo
    adrp x0, array
    add x0, x0, :lo12:array
    
    // Inicializar registros
    mov x1, longitud        // Cargar longitud total
    mov x2, #0              // Inicializar suma en 0
    mov x7, x1              // Copiar longitud para contador

    // Verificar si hay suficientes elementos para desenrollar
    cmp x7, #4
    blt suma_simple         // Si hay menos de 4 elementos, usar bucle simple

suma_desenrollada:
    // Verificar si quedan al menos 4 elementos
    cmp x7, #4
    blt suma_restantes
    
    // Cargar 4 elementos a la vez
    ldp x3, x4, [x0], #16  // Cargar dos elementos
    ldp x5, x6, [x0], #16  // Cargar dos elementos más
    
    // Sumar los 4 elementos
    add x2, x2, x3         // Sumar primer elemento
    add x2, x2, x4         // Sumar segundo elemento
    add x2, x2, x5         // Sumar tercer elemento
    add x2, x2, x6         // Sumar cuarto elemento
    
    sub x7, x7, #4         // Actualizar contador
    b suma_desenrollada    // Siguiente grupo de 4

suma_restantes:
    // Procesar elementos restantes uno por uno
    cbz x7, fin            // Si no quedan elementos, terminar
    
suma_simple:
    ldr x3, [x0], #8       // Cargar un elemento
    add x2, x2, x3         // Sumar al total
    sub x7, x7, #1         // Decrementar contador
    cbnz x7, suma_simple   // Si quedan elementos, continuar

fin:
    // x2 contiene la suma total
    mov x8, #93            // Syscall exit
    mov x0, x2             // Mover resultado a x0 para retorno
    svc #0
