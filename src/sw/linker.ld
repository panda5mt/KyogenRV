OUTPUT_ARCH( "riscv" )

MEMORY
{
    rom : ORIGIN = 0x00000000, LENGTH = 0x4800
    ram : ORIGIN = 0x00004800, LENGTH = 0x4800
}

ENTRY(_start)

SECTIONS
{
    .text : { *(.text*) } > rom
    .rodata : { *(.rodata*) } > rom
    .bss : { *(.bss*) } > ram
    .data : { *(.data*) } > ram
}