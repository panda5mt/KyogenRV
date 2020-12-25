MEMORY
{
    rom : ORIGIN = 0x00000000, LENGTH = 0x2000
    ram : ORIGIN = 0x00004000, LENGTH = 0x1000
}

ENTRY(start)

SECTIONS
{
    .text : {*(.text*)} > rom
    .rodata : {*(.rodata*)} > rom
    .bss : {*(.bss*)} > ram
}