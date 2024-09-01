const block = @import("block.zig");

// The interrupt vector
// The first 16 words are defined in the ARM Cortex-M spec.
// The Cortex-M33 cores on RP235x have 52 interrupts,
// of which only 47 are wired to external interrupt
comptime {
    asm (
        \\.section .text.vectors
        \\.globl _start
        \\_start:
        \\ .long __stack_start
        \\ .long reset
        \\ .long nm_interrupt
        \\ .long hard_fault
        \\ .long rsvd4
        \\ .long rsvd5
        \\ .long rsvd6
        \\ .long rsvd7
        \\ .long rsvd8
        \\ .long rsvd9
        \\ .long rsvd10
        \\ .long sv_call
        \\ .long rsvd12
        \\ .long rsvd13
        \\ .long pend_sv
        \\ .long sys_tick
        \\ .long irq0
        \\ .long irq1
        \\ .long irq2
        \\ .long irq3
        \\ .long irq4
        \\ .long irq5
        \\ .long irq6
        \\ .long irq7
        \\ .long irq8
        \\ .long irq9
        \\ .long irq10
        \\ .long irq11
        \\ .long irq12
        \\ .long irq13
        \\ .long irq14
        \\ .long irq15
        \\ .long irq16
        \\ .long irq17
        \\ .long irq18
        \\ .long irq19
        \\ .long irq20
        \\ .long irq21
        \\ .long irq22
        \\ .long irq23
        \\ .long irq24
        \\ .long irq25
        \\ .long irq26
        \\ .long irq27
        \\ .long irq28
        \\ .long irq29
        \\ .long irq30
        \\ .long irq31
        \\ .long irq32
        \\ .long irq33
        \\ .long irq34
        \\ .long irq35
        \\ .long irq36
        \\ .long irq37
        \\ .long irq38
        \\ .long irq39
        \\ .long irq40
        \\ .long irq41
        \\ .long irq42
        \\ .long irq43
        \\ .long irq44
        \\ .long irq45
        \\ .long irq46
        \\ .long irq47
        \\ .long irq48
        \\ .long irq49
        \\ .long irq50
        \\ .long irq51
    );
}

extern var __bss_start: u8;
extern var __bss_end: u8;

// Define the bootrom as a simple 1 block secure executable
// for ARM and export and link to the start_block section
// Bootrom needs to be in the the first 4k of the flash
const _start_block = block.imageDefArchExe(block.Security.secure, block.Architecture.arm);
comptime {
    @export(_start_block, .{ .name = "start_block", .section = ".start_block" });
}

export fn reset() noreturn {

    // Write 0s to the bss region on reset
    const bss_len = @intFromPtr(&__bss_end) - @intFromPtr(&__bss_start);
    const s: [*]align(1) volatile u8 = @ptrCast(&__bss_start);
    for (0..bss_len) |offset| {
        s[offset] = 0;
    }
    // call the main routine
    @import("main.zig").main();
}

// default interrupt handler
fn default_handler() noreturn {
    while (true) {}
}

// interrupt handlers
export fn nm_interrupt() noreturn {
    default_handler();
}

export fn hard_fault() noreturn {
    default_handler();
}

export fn rsvd4() noreturn {
    default_handler();
}

export fn rsvd5() noreturn {
    default_handler();
}

export fn rsvd6() noreturn {
    default_handler();
}

export fn rsvd7() noreturn {
    default_handler();
}

export fn rsvd8() noreturn {
    default_handler();
}

export fn rsvd9() noreturn {
    default_handler();
}

export fn rsvd10() noreturn {
    default_handler();
}

export fn sv_call() noreturn {
    default_handler();
}

export fn rsvd12() noreturn {
    default_handler();
}

export fn rsvd13() noreturn {
    default_handler();
}

export fn pend_sv() noreturn {
    default_handler();
}

export fn sys_tick() noreturn {
    default_handler();
}

export fn irq0() noreturn {
    default_handler();
}

export fn irq1() noreturn {
    default_handler();
}

export fn irq2() noreturn {
    default_handler();
}

export fn irq3() noreturn {
    default_handler();
}

export fn irq4() noreturn {
    default_handler();
}

export fn irq5() noreturn {
    default_handler();
}

export fn irq6() noreturn {
    default_handler();
}

export fn irq7() noreturn {
    default_handler();
}

export fn irq8() noreturn {
    default_handler();
}

export fn irq9() noreturn {
    default_handler();
}

export fn irq10() noreturn {
    default_handler();
}

export fn irq11() noreturn {
    default_handler();
}

export fn irq12() noreturn {
    default_handler();
}

export fn irq13() noreturn {
    default_handler();
}

export fn irq14() noreturn {
    default_handler();
}

export fn irq15() noreturn {
    default_handler();
}

export fn irq16() noreturn {
    default_handler();
}

export fn irq17() noreturn {
    default_handler();
}

export fn irq18() noreturn {
    default_handler();
}

export fn irq19() noreturn {
    default_handler();
}

export fn irq20() noreturn {
    default_handler();
}

export fn irq21() noreturn {
    default_handler();
}

export fn irq22() noreturn {
    default_handler();
}

export fn irq23() noreturn {
    default_handler();
}

export fn irq24() noreturn {
    default_handler();
}

export fn irq25() noreturn {
    default_handler();
}

export fn irq26() noreturn {
    default_handler();
}

export fn irq27() noreturn {
    default_handler();
}

export fn irq28() noreturn {
    default_handler();
}

export fn irq29() noreturn {
    default_handler();
}

export fn irq30() noreturn {
    default_handler();
}

export fn irq31() noreturn {
    default_handler();
}

export fn irq32() noreturn {
    default_handler();
}

export fn irq33() noreturn {
    default_handler();
}

export fn irq34() noreturn {
    default_handler();
}

export fn irq35() noreturn {
    default_handler();
}

export fn irq36() noreturn {
    default_handler();
}

export fn irq37() noreturn {
    default_handler();
}

export fn irq38() noreturn {
    default_handler();
}

export fn irq39() noreturn {
    default_handler();
}

export fn irq40() noreturn {
    default_handler();
}

export fn irq41() noreturn {
    default_handler();
}

export fn irq42() noreturn {
    default_handler();
}

export fn irq43() noreturn {
    default_handler();
}

export fn irq44() noreturn {
    default_handler();
}

export fn irq45() noreturn {
    default_handler();
}

export fn irq46() noreturn {
    default_handler();
}

export fn irq47() noreturn {
    default_handler();
}

export fn irq48() noreturn {
    default_handler();
}

export fn irq49() noreturn {
    default_handler();
}

export fn irq50() noreturn {
    default_handler();
}

export fn irq51() noreturn {
    default_handler();
}
