MEMORY {
    FLASH(rx) : ORIGIN = 0x08000000, LENGTH = 128K
    SRAM(rwx) : ORIGIN = 0x20000000, LENGTH = 20K
}

SECTIONS {
    . = ORIGIN(FLASH);
    .text : {
        LONG(ORIGIN(SRAM) + LENGTH(SRAM));
        KEEP(*(.vectors))
        KEEP(*(.vectors*))
        KEEP(*(.text))
        . = ALIGN(4);
        *(.text*)
        . = ALIGN(4);
        KEEP(*(.rodata))
        *(.rodata*)
        . = ALIGN(4);

        /* Static data constructors */
        . = ALIGN(4);
        __preinit_array_start = .;
        KEEP (*(.preinit_array*))
        __preinit_array_end = .;

        . = ALIGN(4);
        __init_array_start = .;
        KEEP (*(SORT(.init_array.*)))
        KEEP (*(.init_array*))
        __init_array_end = .;
        __end__ = .;

    } >FLASH

    .ARM.exidx : {
        __exidx_start = .;
        *(.ARM.exidx* .gnu.linkonce.armexidx.*)
        __exidx_end = .;
    } >FLASH

    __stacktop = ORIGIN(SRAM) + LENGTH(SRAM);
    __data_load = LOADADDR(.data);
    . = ORIGIN(SRAM);

    .bss : {
        __bss_start = .;
        __bss_start__ = __bss_start;
        *(.bss)
        *(.bss*)
        *(COMMON)
        __bss_end = .;
        __bss_end__ = __bss_end;
    } >SRAM

    .data ALIGN(4) : {
        __data_start = .;
        *(.data)
        *(.data*)
        . = ALIGN(4);
        __data_end = .;
    } >SRAM AT > FLASH

    . = ALIGN(4);

    /*.debug : {
        *(.debug*)
    } > SRAM*/

    . = ALIGN(4);
    __heap_start = .;
    end = __heap_start;
}
