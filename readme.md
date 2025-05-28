```bash
as --gstabs -o malloc.o malloc.s
ld -o malloc malloc-o
```

```gdb
(gdb) break _start         # Definir ponto de interrupção no início
(gdb) run                  # Iniciar execução
(gdb) stepi                # Executar uma instrução
(gdb) info registers       # Visualizar valores dos registradores
(gdb) x/s &message         # Examinar a string na memória
```