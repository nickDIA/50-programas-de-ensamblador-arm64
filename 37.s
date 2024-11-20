// Instituto Tecnologico de Tijuana
// Depto de Sistemas y Computacion
// Ing. Sistemas computacionales
// Autor: Ibarra Acedo Dominick 
// Repositorio: https://github.com/nickDIA/50-programas-de-ensamblador-arm64

/*
  using System;

class Pila
{
    private int[] pila;
    private int tope;
    private int capacidad;

    public Pila(int capacidad)
    {
        this.capacidad = capacidad;
        this.pila = new int[capacidad];
        this.tope = -1; // La pila está vacía
    }

    // Verifica si la pila está vacía
    public bool EstaVacia()
    {
        return tope == -1;
    }

    // Verifica si la pila está llena
    public bool EstaLlena()
    {
        return tope == capacidad - 1;
    }

    // Apilar un elemento
    public void Apilar(int valor)
    {
        if (EstaLlena())
        {
            Console.WriteLine("La pila está llena. No se puede apilar.");
        }
        else
        {
            tope++;
            pila[tope] = valor;
            Console.WriteLine($"Elemento {valor} apilado.");
        }
    }

    // Desapilar un elemento
    public int Desapilar()
    {
        if (EstaVacia())
        {
            Console.WriteLine("La pila está vacía. No se puede desapilar.");
            return -1;
        }
        else
        {
            int valor = pila[tope];
            tope--;
            Console.WriteLine($"Elemento {valor} desapilado.");
            return valor;
        }
    }

    // Ver el elemento en el tope de la pila
    public int Tope()
    {
        if (EstaVacia())
        {
            Console.WriteLine("La pila está vacía.");
            return -1;
        }
        else
        {
            return pila[tope];
        }
    }

    // Mostrar todos los elementos de la pila
    public void Mostrar()
    {
        if (EstaVacia())
        {
            Console.WriteLine("La pila está vacía.");
        }
        else
        {
            Console.Write("Elementos en la pila: ");
            for (int i = 0; i <= tope; i++)
            {
                Console.Write(pila[i] + " ");
            }
            Console.WriteLine();
        }
    }
}

class Program
{
    static void Main()
    {
        // Crear una pila con capacidad de 5 elementos
        Pila pila = new Pila(5);

        // Apilar elementos
        pila.Apilar(10);
        pila.Apilar(20);
        pila.Apilar(30);

        // Mostrar la pila
        pila.Mostrar();

        // Desapilar un elemento
        pila.Desapilar();

        // Mostrar la pila después de desapilar
        pila.Mostrar();

        // Ver el elemento en el tope de la pila
        Console.WriteLine("El elemento en el tope de la pila es: " + pila.Tope());

        // Apilar más elementos
        pila.Apilar(40);
        pila.Apilar(50);
        pila.Apilar(60); // Esto debería dar un error porque la pila está llena

        // Mostrar la pila
        pila.Mostrar();
    }
}

*/

// Programa que implementa una pila usando un arreglo
// Registros usados:
// x0: dirección base de la pila
// x1: tope de la pila (índice del último elemento)
// x2: capacidad máxima de la pila
// x3: valor a insertar/extraer
// x4: dirección temporal
// x5: valor temporal

.data
    .align 3                         // Alinear a 8 bytes
    stack_array: .skip 80           // Espacio para 10 elementos (8 bytes cada uno)
    stack_size = 10                 // Tamaño máximo de la pila
    stack_top: .quad -1             // Índice del tope de la pila (-1 = vacía)
    
    // Códigos de error
    STACK_OK = 0
    STACK_OVERFLOW = 1
    STACK_UNDERFLOW = 2

.text
.global _start

// Subrutina para push
push:
    // Guardar dirección de retorno
    str x30, [sp, #-16]!
    
    // Verificar si la pila está llena
    ldr x1, [x19]                   // Cargar tope actual
    cmp x1, x2                      // Comparar con capacidad máxima - 1
    bge push_overflow
    
    // Incrementar tope
    add x1, x1, #1
    str x1, [x19]                   // Actualizar tope
    
    // Calcular dirección donde guardar el elemento
    lsl x4, x1, #3                  // Multiplicar índice por 8
    add x4, x0, x4                  // Añadir a dirección base
    str x3, [x4]                    // Guardar valor
    
    mov x0, #STACK_OK               // Retornar éxito
    b push_end

push_overflow:
    mov x0, #STACK_OVERFLOW         // Retornar error
    
push_end:
    ldr x30, [sp], #16             // Restaurar dirección de retorno
    ret

// Subrutina para pop
pop:
    // Guardar dirección de retorno
    str x30, [sp, #-16]!
    
    // Verificar si la pila está vacía
    ldr x1, [x19]                   // Cargar tope actual
    cmp x1, #-1
    ble pop_underflow
    
    // Calcular dirección del elemento a extraer
    lsl x4, x1, #3                  // Multiplicar índice por 8
    add x4, x0, x4                  // Añadir a dirección base
    ldr x3, [x4]                    // Obtener valor
    
    // Decrementar tope
    sub x1, x1, #1
    str x1, [x19]                   // Actualizar tope
    
    mov x0, #STACK_OK               // Retornar éxito
    b pop_end

pop_underflow:
    mov x0, #STACK_UNDERFLOW        // Retornar error
    mov x3, #0                      // Valor nulo en caso de error
    
pop_end:
    ldr x30, [sp], #16             // Restaurar dirección de retorno
    ret

// Subrutina para verificar si la pila está vacía
is_empty:
    ldr x1, [x19]                   // Cargar tope
    cmp x1, #-1                     // Comparar con -1
    cset x0, eq                     // x0 = 1 si está vacía, 0 si no
    ret

// Subrutina para verificar si la pila está llena
is_full:
    ldr x1, [x19]                   // Cargar tope
    cmp x1, x2                      // Comparar con capacidad máxima - 1
    cset x0, ge                     // x0 = 1 si está llena, 0 si no
    ret

_start:
    // Inicializar registros base
    adrp x0, stack_array
    add x0, x0, :lo12:stack_array   // Dirección base del array
    adrp x19, stack_top
    add x19, x19, :lo12:stack_top   // Dirección del tope
    mov x2, stack_size              // Capacidad máxima
    sub x2, x2, #1                  // Ajustar para índice base 0
    
    // Ejemplo de uso:
    // Push 42
    mov x3, #42
    bl push
    
    // Push 73
    mov x3, #73
    bl push
    
    // Pop
    bl pop
    // x3 contiene 73
    
    // Pop
    bl pop
    // x3 contiene 42
    
fin:
    mov x8, #93                     // Syscall exit
    mov x0, #0                      // Código de retorno
    svc #0
