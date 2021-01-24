OUTPUT_ARCH( "riscv" )

MEMORY
{
    rom : ORIGIN = 0x00000000, LENGTH = 0x4000
    ram : ORIGIN = 0x00004000, LENGTH = 0x4000
}

ENTRY(_start)

SECTIONS
{
    .text : { *(.text*) } > rom
    .rodata : { *(.rodata*) } > rom
    .bss : { *(.bss*) } > ram
    .data : { *(.data*) } > ram
}