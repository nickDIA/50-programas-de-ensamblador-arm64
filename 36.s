// Programa para encontrar el segundo elemento más grande en un arreglo
// Registros usados:
// x0: dirección base del arreglo
// x1: longitud del arreglo
// x2: máximo valor encontrado
// x3: segundo máximo valor encontrado
// x4: valor actual siendo comparado
// x5: contador
// x6: dirección temporal

.data
    .align 3                     // Alinear a 8 bytes
    array: .quad 15, 8, 23, 12, 9, 20, 11, 16, 7, 22
    longitud = (. - array) / 8   // Calcular longitud (elementos de 8 bytes)
    no_encontrado = 0x8000000000000000  // Valor centinela (número más pequeño posible)

.text
.global _start

_start:
    // Cargar dirección base del arreglo
    adrp x0, array
    add x0, x0, :lo12:array
    
    // Inicializar registros
    mov x1, longitud                    // Longitud del arreglo
    mov x2, no_encontrado               // Inicializar máximo
    mov x3, no_encontrado               // Inicializar segundo máximo
    
    // Verificar si hay al menos 2 elementos
    cmp x1, #2
    blt array_muy_pequeno
    
    // Cargar primer elemento
    ldr x2, [x0]                        // Primer máximo
    ldr x3, [x0, #8]                    // Segundo máximo provisional
    
    // Ordenar los dos primeros elementos
    cmp x2, x3
    bge continuar_busqueda
    // Si x3 > x2, intercambiar
    mov x4, x2
    mov x2, x3
    mov x3, x4

continuar_busqueda:
    // Inicializar para recorrer el resto del array
    mov x5, #2                          // Comenzar desde el tercer elemento
    add x6, x0, #16                     // Actualizar puntero al array

buscar_segundo:
    // Verificar si hemos terminado
    cmp x5, x1
    bge fin
    
    // Cargar siguiente elemento
    ldr x4, [x6], #8
    
    // Comparar con el máximo actual
    cmp x4, x2
    bgt nuevo_maximo
    
    // Comparar con el segundo máximo
    cmp x4, x3
    bgt nuevo_segundo
    
continuar:
    add x5, x5, #1                      // Incrementar contador
    b buscar_segundo

nuevo_maximo:
    // Actualizar máximos
    mov x3, x2                          // Antiguo máximo pasa a ser segundo
    mov x2, x4                          // Nuevo máximo
    b continuar

nuevo_segundo:
    // Actualizar solo segundo máximo
    mov x3, x4
    b continuar

array_muy_pequeno:
    // Manejar caso de array con menos de 2 elementos
    mov x3, no_encontrado
    b fin

fin:
    // x3 contiene el segundo elemento más grande
    mov x8, #93                         // Syscall exit
    mov x0, x3                          // Mover resultado a x0 para retorno
    svc #0
