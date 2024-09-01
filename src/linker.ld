
MEMORY {
    FLASH : ORIGIN = 0x10000000, LENGTH = 2048K
    RAM : ORIGIN = 0x20000000, LENGTH = 512K
    /*
     * RAM banks 8 and 9 use a direct mapping. They can be used to have
     * memory areas dedicated for some specific job, improving predictability
     * of access times.
     * Example: Separate stacks for core0 and core1.
     */
    SRAM4 : ORIGIN = 0x20080000, LENGTH = 4K
    SRAM5 : ORIGIN = 0x20081000, LENGTH = 4K
}

EXTERN(vectors);
EXTERN(__reset);
ENTRY(__reset)
SECTIONS {

  /DISCARD/ : {
      *(.ARM.exidx)
      *(.ARM.exidx.*)
      *(.ARM.extab.*)
  }

  .vector_table ORIGIN(FLASH) : {
        __vector_table = .;
        KEEP(*(.text.vectors))
  } > FLASH

  .text : {
        __text_start = .;
        __start = .;
        *(.text*)
        __text_end = .;
  } > FLASH

  .rodata : {
      __rodata_start = .;
      *(.rodata*)
      __rodata_end = .;
  } > FLASH
  
  .data : {
      __data_start = .;
      *(.data*)
      __data_end = .;
  } > RAM
  
  . = ALIGN(4);

  .bss : {
      __bss_start = .;
      *(.bss*)
      __bss_end = .;
  } > RAM
  
  .stack : {
      __stack_end = .;
      __stack_start = ORIGIN(RAM) + LENGTH(RAM) - 4;
  } > RAM
}

SECTIONS {
    /* ### Boot ROM info
     *
     * Goes after .vector_table, to keep it in the first 4K of flash
     * where the Boot ROM (and picotool) can find it
     */
    .start_block : ALIGN(4)
    {
        __start_block_addr = .;
        KEEP(*(.start_block));
    } > FLASH

} INSERT AFTER .vector_table

SECTIONS {
    /* ### Picotool 'Binary Info' Entries
     *
     * Picotool looks through this block (as we have pointers to it in our
     * header) to find interesting information.
     */
    .bi_entries : ALIGN(4)
    {
        /* We put this in the header */
        __bi_entries_start = .;
        /* Here are the entries */
        KEEP(*(.bi_entries));
        /* Keep this block a nice round size */
        . = ALIGN(4);
        /* We put this in the header */
        __bi_entries_end = .;
    } > FLASH
} INSERT AFTER .text;
