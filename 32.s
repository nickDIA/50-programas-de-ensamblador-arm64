// Programa para calcular la potencia x^n usando exponenciación rápida
// Registros usados:
// x0: base (x)
// x1: exponente (n)
// x2: resultado
// x3: base temporal
// x4: máscara para verificar bits

.global _start
.text

_start:
    // Ejemplo: calcular 2^10
    mov x0, #2          // Base (x)
    mov x1, #10         // Exponente (n)
    
    // Comprobar casos especiales
    cmp x1, #0          // Verificar si exponente es 0
    beq exponente_cero
    cmp x1, #1          // Verificar si exponente es 1
    beq exponente_uno
    
    // Inicializar
    mov x2, #1          // Resultado = 1
    mov x3, x0          // Base temporal = x
    mov x4, x1          // Copiar exponente para examinar bits

calcular_potencia:
    // Verificar si llegamos al final
    cmp x4, #0
    beq fin
    
    // Verificar el bit menos significativo
    tst x4, #1
    beq no_multiplicar
    
    // Si el bit es 1, multiplicar resultado por base temporal
    mul x2, x2, x3
    
no_multiplicar:
    // Cuadrar la base temporal
    mul x3, x3, x3
    
    // Desplazar exponente a la derecha
    lsr x4, x4, #1
    
    b calcular_potencia

exponente_cero:
    mov x2, #1          // Si exponente es 0, resultado es 1
    b fin

exponente_uno:
    mov x2, x0          // Si exponente es 1, resultado es la base
    b fin

fin:
    // x2 contiene el resultado de x^n
    mov x8, #93         // Syscall exit
    mov x0, x2          // Mover resultado a x0 para retorno
    svc #0              // Llamada al sistema
