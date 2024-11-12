// Una eternidad en debugear
.global _start

.section .data
    number: .quad 0x12345678      // Número de ejemplo: 0x12345678 (en binario: 00010010001101000101011001111000)

.section .text
_start:
    // Cargar el número en el registro x0
    ldr x0, =number               // Cargar la dirección de 'number'
    ldr x0, [x0]                  // Cargar el valor en x0 (0x12345678)

    // Inicializar contador de bits activados en x1
    mov x1, #0                    // x1 = 0 (contador de bits activados)

count_bits:
    // Comprobar si el número es 0
    cbz x0, done                  // Si x0 == 0, salta a 'done'

    // Comprobar si el bit más bajo está activado
    and x2, x0, #1                // x2 = x0 & 1 (comprobar el bit más bajo)
    add x1, x1, x2                // Si el bit está activado, incrementar el contador

    // Desplazar a la derecha para procesar el siguiente bit
    lsr x0, x0, #1                // x0 = x0 >> 1 (desplazar a la derecha el número)

    // Volver al bucle para comprobar el siguiente bit
    b count_bits                  // Repetir el ciclo

done:
    // En este punto, x1 contiene el número de bits activados (Hamming weight)

    // Finalizar el programa
    mov x8, 93                    // Syscall para salir
    mov x0, 0                     // Código de salida
    svc 0                          // Llamar al sistema (exit)
