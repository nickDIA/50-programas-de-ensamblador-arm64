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
