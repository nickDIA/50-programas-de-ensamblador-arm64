// Instituto Tecnologico de Tijuana
// Depto de Sistemas y Computacion
// Ing. Sistemas computacionales
// Autor: Ibarra Acedo Dominick 
// Repositorio: https://github.com/nickDIA/50-programas-de-ensamblador-arm64

/*
  using System;

class Program
{
    static void Main()
    {
        Console.WriteLine("Conversión de decimal a binario");

        // Solicitar al usuario un número decimal
        Console.Write("Ingresa un número decimal entero: ");
        string input = Console.ReadLine();

        // Validar la entrada
        if (int.TryParse(input, out int numeroDecimal) && numeroDecimal >= 0)
        {
            string numeroBinario = ConvertirDecimalABinario(numeroDecimal);
            Console.WriteLine($"El número decimal {numeroDecimal} en binario es: {numeroBinario}");
        }
        else
        {
            Console.WriteLine("Entrada no válida. Por favor, ingresa un número decimal entero positivo.");
        }
    }

    static string ConvertirDecimalABinario(int numeroDecimal)
    {
        if (numeroDecimal == 0)
        {
            return "0"; // Caso especial: 0 en binario es "0"
        }

        string binario = "";
        while (numeroDecimal > 0)
        {
            binario = (numeroDecimal % 2) + binario; // Obtener el bit menos significativo
            numeroDecimal /= 2; // Dividir el número decimal entre 2
        }

        return binario;
    }
}

*/

// Programa para convertir decimal a binario
.data
    buffer:     .skip 64        // Buffer para almacenar resultado binario
    msg_input:  .asciz "Ingrese un número decimal: "
    msg_output: .asciz "Número en binario: "
    newline:    .asciz "\n"

.text
.global _start

// Función principal de conversión decimal a binario
// x0: número decimal a convertir
// x1: dirección del buffer para resultado
decimal_to_binary:
    stp x29, x30, [sp, #-16]!   // Guardar registros
    mov x29, sp
    
    mov x2, #0                  // Contador de bits
    mov x3, x1                  // Copiar dirección del buffer
    
convert_loop:
    // Obtener bit menos significativo
    and x4, x0, #1             // x4 = número & 1
    
    // Convertir bit a ASCII ('0' o '1')
    add w4, w4, #48            // Convertir a ASCII
    
    // Guardar en buffer
    strb w4, [x3, x2]          // buffer[contador] = bit
    
    // Desplazar número a la derecha
    lsr x0, x0, #1             // número = número >> 1
    
    // Incrementar contador
    add x2, x2, #1             // contador++
    
    // Continuar si el número no es 0
    cbnz x0, convert_loop
    
    // Invertir los bits en el buffer (están en orden inverso)
reverse:
    mov x4, #0                  // índice inicio
    sub x5, x2, #1             // índice final
    
reverse_loop:
    cmp x4, x5                  // Comparar índices
    b.ge reverse_done           // Si inicio >= final, terminar
    
    // Intercambiar caracteres
    ldrb w6, [x3, x4]          // temp1 = buffer[inicio]
    ldrb w7, [x3, x5]          // temp2 = buffer[final]
    strb w7, [x3, x4]          // buffer[inicio] = temp2
    strb w6, [x3, x5]          // buffer[final] = temp1
    
    // Actualizar índices
    add x4, x4, #1             // inicio++
    sub x5, x5, #1             // final--
    b reverse_loop
    
reverse_done:
    // Agregar terminador nulo
    strb wzr, [x3, x2]
    
    mov x0, x2                  // Retornar longitud del resultado
    ldp x29, x30, [sp], #16     // Restaurar registros
    ret

_start:
    // Solicitar número (aquí podrías agregar código para input real)
    mov x0, #123                // Número de ejemplo a convertir
    
    // Preparar conversión
    adr x1, buffer              // Cargar dirección del buffer
    bl decimal_to_binary        // Llamar a función de conversión
    
    // Imprimir resultado
    mov x8, #64                 // syscall write
    mov x0, #1                  // stdout
    adr x1, msg_output          // mensaje "Número en binario: "
    mov x2, #19                 // longitud del mensaje
    svc #0
    
    mov x8, #64                 // syscall write
    mov x0, #1                  // stdout
    adr x1, buffer             // resultado binario
    mov x2, x0                 // longitud del resultado
    svc #0
    
    // Imprimir nueva línea
    mov x8, #64                 // syscall write
    mov x0, #1                  // stdout
    adr x1, newline            // nueva línea
    mov x2, #1                 // longitud
    svc #0
    
    // Salir del programa
    mov x8, #93                 // syscall exit
    mov x0, #0                  // código de salida
    svc #0
