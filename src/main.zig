const gpio = @import("hal/gpio.zig");
const sio = @import("hal/sio.zig");
const reset = @import("hal/reset.zig");
const regs = @import("regs.zig");

pub fn main() noreturn {
    reset.deassert_reset_of(.IO_BANK0);
    reset.deassert_reset_of(.PADS_BANK0);

    regs.PADS_BANK0.GPIO25.modify(.{ .ISO = 0 });
    regs.PADS_BANK0.GPIO25.modify(.{ .IE = 0 });
    // Enable non secure access for GPIO pins
    regs.ACCESSCTRL.GPIO_NSMASK0.write_raw(0xFFFFFFFF);

    gpio.set_dir(.P25, .Output);
    gpio.set_function(.P25, .F5);

    sio.set_output_enable(.GPIO25);

    while (true) {
        sio.clear_output(.GPIO25);
        busy_wait(1_000_000);
        sio.set_output(.GPIO25);
        busy_wait(1_000_000);
    }
}

fn busy_wait(n: usize) void {
    var i: usize = 0;
    while (i < n) : (i += 1) {
        asm volatile ("NOP");
    }
}
