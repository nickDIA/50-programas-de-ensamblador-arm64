// Instituto Tecnologico de Tijuana
// Depto de Sistemas y Computacion
// Ing. Sistemas computacionales
// Autor: Ibarra Acedo Dominick 
// Repositorio: https://github.com/nickDIA/50-programas-de-ensamblador-arm64

/*
  using System;

class Cola
{
    private int[] cola;
    private int frente;
    private int fin;
    private int capacidad;
    private int tamaño;

    public Cola(int capacidad)
    {
        this.capacidad = capacidad;
        this.cola = new int[capacidad];
        this.frente = 0;
        this.fin = -1;
        this.tamaño = 0;
    }

    // Verifica si la cola está vacía
    public bool EstaVacia()
    {
        return tamaño == 0;
    }

    // Verifica si la cola está llena
    public bool EstaLlena()
    {
        return tamaño == capacidad;
    }

    // Encolar un elemento
    public void Encolar(int valor)
    {
        if (EstaLlena())
        {
            Console.WriteLine("La cola está llena. No se puede encolar.");
        }
        else
        {
            fin = (fin + 1) % capacidad; // Usamos módulo para la rotación circular
            cola[fin] = valor;
            tamaño++;
            Console.WriteLine($"Elemento {valor} encolado.");
        }
    }

    // Desencolar un elemento
    public int Desencolar()
    {
        if (EstaVacia())
        {
            Console.WriteLine("La cola está vacía. No se puede desencolar.");
            return -1;
        }
        else
        {
            int valor = cola[frente];
            frente = (frente + 1) % capacidad; // Usamos módulo para la rotación circular
            tamaño--;
            Console.WriteLine($"Elemento {valor} desencolado.");
            return valor;
        }
    }

    // Ver el primer elemento (frente)
    public int Frente()
    {
        if (EstaVacia())
        {
            Console.WriteLine("La cola está vacía.");
            return -1;
        }
        else
        {
            return cola[frente];
        }
    }

    // Mostrar todos los elementos de la cola
    public void Mostrar()
    {
        if (EstaVacia())
        {
            Console.WriteLine("La cola está vacía.");
        }
        else
        {
            Console.Write("Elementos en la cola: ");
            for (int i = 0; i < tamaño; i++)
            {
                Console.Write(cola[(frente + i) % capacidad] + " ");
            }
            Console.WriteLine();
        }
    }
}

class Program
{
    static void Main()
    {
        // Crear una cola con capacidad de 5 elementos
        Cola cola = new Cola(5);

        // Encolar elementos
        cola.Encolar(10);
        cola.Encolar(20);
        cola.Encolar(30);

        // Mostrar la cola
        cola.Mostrar();

        // Desencolar un elemento
        cola.Desencolar();

        // Mostrar la cola después de desencolar
        cola.Mostrar();

        // Ver el primer elemento
        Console.WriteLine("El primer elemento de la cola es: " + cola.Frente());

        // Encolar más elementos
        cola.Encolar(40);
        cola.Encolar(50);
        cola.Encolar(60); // Esto debería dar un error porque la cola está llena

        // Mostrar la cola
        cola.Mostrar();
    }
}

*/

// Implementación de Cola usando un arreglo en ARM64 Assembly
.data
    array:      .skip 400        // Espacio para 100 elementos (4 bytes cada uno)
    front:      .word 0          // Índice del frente de la cola
    rear:       .word 0          // Índice del final de la cola
    size:       .word 100        // Tamaño máximo de la cola
    count:      .word 0          // Cantidad actual de elementos
    
.text
.global _start

// Función para agregar elemento a la cola (enqueue)
enqueue:
    // x0 contiene el valor a insertar
    stp x29, x30, [sp, #-16]!   // Guardar registros
    
    // Verificar si la cola está llena
    adr x1, count
    ldr w2, [x1]                // Cargar count actual
    adr x3, size
    ldr w4, [x3]                // Cargar tamaño máximo
    cmp w2, w4                  // Comparar count con size
    b.ge queue_full             // Si count >= size, cola llena
    
    // Obtener posición para insertar
    adr x1, rear
    ldr w2, [x1]                // Cargar rear actual
    adr x3, array
    str w0, [x3, w2, SXTW #2]   // Guardar valor en array[rear]
    
    // Actualizar rear
    add w2, w2, #1              // rear++
    adr x3, size
    ldr w4, [x3]
    sdiv w2, w2, w4             // rear = rear % size
    str w2, [x1]                // Guardar nuevo rear
    
    // Incrementar count
    adr x1, count
    ldr w2, [x1]
    add w2, w2, #1
    str w2, [x1]
    
    mov w0, #1                  // Retornar éxito
    b enqueue_end
    
queue_full:
    mov w0, #0                  // Retornar fallo

enqueue_end:
    ldp x29, x30, [sp], #16     // Restaurar registros
    ret

// Función para quitar elemento de la cola (dequeue)
dequeue:
    stp x29, x30, [sp, #-16]!   // Guardar registros
    
    // Verificar si la cola está vacía
    adr x1, count
    ldr w2, [x1]
    cbz w2, queue_empty         // Si count == 0, cola vacía
    
    // Obtener elemento del frente
    adr x1, front
    ldr w2, [x1]                // Cargar front actual
    adr x3, array
    ldr w0, [x3, w2, SXTW #2]   // Cargar valor de array[front]
    
    // Actualizar front
    add w2, w2, #1              // front++
    adr x3, size
    ldr w4, [x3]
    sdiv w2, w2, w4             // front = front % size
    str w2, [x1]                // Guardar nuevo front
    
    // Decrementar count
    adr x1, count
    ldr w2, [x1]
    sub w2, w2, #1
    str w2, [x1]
    
    b dequeue_end
    
queue_empty:
    mov w0, #-1                 // Retornar error si cola vacía

dequeue_end:
    ldp x29, x30, [sp], #16     // Restaurar registros
    ret

// Función para verificar si la cola está vacía
is_empty:
    adr x0, count
    ldr w0, [x0]
    cmp w0, #0
    cset w0, eq                 // w0 = 1 si está vacía, 0 si no
    ret

// Función para verificar si la cola está llena
is_full:
    adr x0, count
    ldr w0, [x0]
    adr x1, size
    ldr w1, [x1]
    cmp w0, w1
    cset w0, eq                 // w0 = 1 si está llena, 0 si no
    ret

_start:
    // Aquí puedes agregar código de prueba
    // Por ejemplo:
    mov w0, #42                 // Agregar 42 a la cola
    bl enqueue
    bl dequeue                  // Quitar elemento de la cola
    
    // Salir del programa
    mov x8, #93                 // Número de sistema para exit
    mov x0, #0                  // Código de salida
    svc #0                      // Llamada al sistema
