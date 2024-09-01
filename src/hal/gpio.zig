const regs = @import("../regs.zig");

pub const IODir = enum {
    Input,
    Output,
};

pub const Function = enum {
    F0,
    F1,
    F2,
    F3,
    F4,
    F5,
    F6,
    F7,
    F8,
    F9,
    NULL,
};

pub const GPIO = enum {
    P0,
    P1,
    P2,
    P3,
    P4,
    P5,
    P6,
    P7,
    P8,
    P9,
    P10,
    P11,
    P12,
    P13,
    P14,
    P15,
    P16,
    P17,
    P18,
    P19,
    P20,
    P21,
    P22,
    P23,
    P24,
    P25,
    P26,
    P27,
    P28,
    P29,
};

fn GPIOCtrl(comptime gpio: GPIO) type {
    const ctrl_reg = switch (gpio) {
        GPIO.P0 => regs.IO_BANK0.GPIO1_CTRL,
        GPIO.P1 => regs.IO_BANK0.GPIO1_CTRL,
        GPIO.P2 => regs.IO_BANK0.GPIO2_CTRL,
        GPIO.P3 => regs.IO_BANK0.GPIO3_CTRL,
        GPIO.P4 => regs.IO_BANK0.GPIO4_CTRL,
        GPIO.P5 => regs.IO_BANK0.GPIO5_CTRL,
        GPIO.P6 => regs.IO_BANK0.GPIO6_CTRL,
        GPIO.P7 => regs.IO_BANK0.GPIO7_CTRL,
        GPIO.P8 => regs.IO_BANK0.GPIO8_CTRL,
        GPIO.P9 => regs.IO_BANK0.GPIO9_CTRL,
        GPIO.P10 => regs.IO_BANK0.GPIO10_CTRL,
        GPIO.P11 => regs.IO_BANK0.GPIO11_CTRL,
        GPIO.P12 => regs.IO_BANK0.GPIO12_CTRL,
        GPIO.P13 => regs.IO_BANK0.GPIO13_CTRL,
        GPIO.P14 => regs.IO_BANK0.GPIO14_CTRL,
        GPIO.P15 => regs.IO_BANK0.GPIO15_CTRL,
        GPIO.P16 => regs.IO_BANK0.GPIO16_CTRL,
        GPIO.P17 => regs.IO_BANK0.GPIO17_CTRL,
        GPIO.P18 => regs.IO_BANK0.GPIO18_CTRL,
        GPIO.P19 => regs.IO_BANK0.GPIO19_CTRL,
        GPIO.P20 => regs.IO_BANK0.GPIO20_CTRL,
        GPIO.P21 => regs.IO_BANK0.GPIO21_CTRL,
        GPIO.P22 => regs.IO_BANK0.GPIO22_CTRL,
        GPIO.P23 => regs.IO_BANK0.GPIO23_CTRL,
        GPIO.P24 => regs.IO_BANK0.GPIO24_CTRL,
        GPIO.P25 => regs.IO_BANK0.GPIO25_CTRL,
        GPIO.P26 => regs.IO_BANK0.GPIO26_CTRL,
        GPIO.P27 => regs.IO_BANK0.GPIO27_CTRL,
        GPIO.P28 => regs.IO_BANK0.GPIO28_CTRL,
        GPIO.P29 => regs.IO_BANK0.GPIO29_CTRL,
    };
    return struct {
        reg: @TypeOf(ctrl_reg),

        const Self = @This();

        fn init() Self {
            return Self{ .reg = ctrl_reg };
        }
    };
}

pub fn set_dir(comptime pin: GPIO, dir: IODir) void {
    const gpio_ctrl = GPIOCtrl(pin).init();
    const ctrl_reg = gpio_ctrl.reg;
    switch (dir) {
        IODir.Input => ctrl_reg.modify(.{ .OEOVER = 0x02 }),
        IODir.Output => ctrl_reg.modify(.{ .OEOVER = 0x03 }),
    }
}

pub fn set_iso(comptime pin: GPIO, iso: bool) void {
    const gpio_ctrl = GPIOCtrl(pin).init();
    const ctrl_reg = gpio_ctrl.reg;
    if (iso) {
        ctrl_reg.modify(.{ .ISO = 1});
    } else {
        ctrl_reg.modify(.{ .ISO = 0});

    }
}

pub fn set_function(comptime pin: GPIO, function: Function) void {
    const gpio_ctrl = GPIOCtrl(pin).init();
    const ctrl_reg = gpio_ctrl.reg;
    switch (function) {
        Function.F0 => ctrl_reg.modify(.{ .FUNCSEL = 0x00 }),
        Function.F1 => ctrl_reg.modify(.{ .FUNCSEL = 0x01 }),
        Function.F2 => ctrl_reg.modify(.{ .FUNCSEL = 0x02 }),
        Function.F3 => ctrl_reg.modify(.{ .FUNCSEL = 0x03 }),
        Function.F4 => ctrl_reg.modify(.{ .FUNCSEL = 0x04 }),
        Function.F5 => ctrl_reg.modify(.{ .FUNCSEL = 0x05 }),
        Function.F6 => ctrl_reg.modify(.{ .FUNCSEL = 0x06 }),
        Function.F7 => ctrl_reg.modify(.{ .FUNCSEL = 0x07 }),
        Function.F8 => ctrl_reg.modify(.{ .FUNCSEL = 0x08 }),
        Function.F9 => ctrl_reg.modify(.{ .FUNCSEL = 0x09 }),
        Function.NULL => ctrl_reg.modify(.{ .FUNCSEL = 0x1F }),
    }
}
