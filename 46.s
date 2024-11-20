// Instituto Tecnologico de Tijuana
// Depto de Sistemas y Computacion
// Ing. Sistemas computacionales
// Autor: Ibarra Acedo Dominick 
// Repositorio: https://github.com/nickDIA/50-programas-de-ensamblador-arm64

/* 
using System;

class PrefijoComun
{
    static void Main()
    {
        // Solicitar al usuario que ingrese las cadenas
        Console.WriteLine("Ingresa el número de cadenas:");
        int n = Convert.ToInt32(Console.ReadLine());

        string[] cadenas = new string[n];
        Console.WriteLine("Ingresa las cadenas:");

        // Leer las cadenas
        for (int i = 0; i < n; i++)
        {
            cadenas[i] = Console.ReadLine();
        }

        // Encontrar el prefijo común más largo
        string prefijoComun = EncontrarPrefijoComun(cadenas);

        // Imprimir el resultado
        Console.WriteLine("El prefijo común más largo es: " + prefijoComun);
    }

    static string EncontrarPrefijoComun(string[] cadenas)
    {
        if (cadenas.Length == 0) return "";

        // Empezar con el primer string como prefijo común
        string prefijo = cadenas[0];

        // Comparar el prefijo con cada cadena en el arreglo
        foreach (string cadena in cadenas)
        {
            int longitud = Math.Min(prefijo.Length, cadena.Length);
            int i = 0;

            // Encontrar la parte común
            while (i < longitud && prefijo[i] == cadena[i])
            {
                i++;
            }

            // Reducir el prefijo al común encontrado
            prefijo = prefijo.Substring(0, i);

            // Si en algún momento el prefijo se convierte en vacío, terminamos
            if (prefijo == "")
                return "";
        }

        return prefijo;
    }
}

*/

// Encontrar el prefijo común más largo en cadenas
.global _start
.section .text

_start:
    // Direcciones de las cadenas
    adr x19, string1
    adr x20, string2
    mov x21, #0          // Contador de caracteres coincidentes
    
compare_loop:
    ldrb w22, [x19, x21] // Cargar byte de primera cadena
    ldrb w23, [x20, x21] // Cargar byte de segunda cadena
    
    // Verificar fin de cadena
    cbz w22, end_compare
    cbz w23, end_compare
    
    // Comparar caracteres
    cmp w22, w23
    bne end_compare
    
    // Incrementar contador y continuar
    add x21, x21, #1
    b compare_loop
    
end_compare:
    // x21 contiene la longitud del prefijo común

exit:
    mov x0, #0
    mov x8, #93
    svc #0

.section .data
string1:
    .asciz "prefix123"
string2:
    .asciz "prefix456"
