const regs = @import("../regs.zig");

const Peripheral = enum { IO_BANK0, PADS_BANK0 };

pub fn deassert_reset_of(perif: Peripheral) void {
    switch (perif) {
        .IO_BANK0 => regs.RESETS.RESET.modify(.{ .IO_BANK0 = 0 }),
        .PADS_BANK0 => regs.RESETS.RESET.modify(.{ .PADS_BANK0 = 0 }),
    }
}

pub fn assert_reset_of(perif: Peripheral) void {
    switch (perif) {
        .IO_BANK0 => regs.RESETS.RESET.modify(.{ .IO_BANK0 = 1 }),
        .PADS_BANK0 => regs.RESETS.RESET.modify(.{ .PADS_BANK0 = 1 }),
    }
}
