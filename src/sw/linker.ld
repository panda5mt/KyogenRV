OUTPUT_ARCH( "riscv" )

MEMORY
{
    rom : ORIGIN = 0x00000000, LENGTH = 0x5000
    ram : ORIGIN = 0x00005000, LENGTH = 0x5000
}

ENTRY(_start)

SECTIONS
{
    .text : { *(.text*) } > rom
    .rodata : { *(.rodata*) } > rom
    .bss : { *(.bss*) } > ram
    .data : { *(.data*) } > ram
}