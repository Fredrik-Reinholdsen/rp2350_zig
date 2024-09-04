# Zig RP2350
A basic proof of concept project, running Blinky application written in Zig, running bare-metal on a RP2350 microcontroller.

![Blinky](/images/pico2_zig.gif "GIF")

This repo does not use the pico-sdk at all (except for flashing), and uses only
Zig, a linker script and some assembly.

## RP2350

The RP2350, by Raspberry Pi, is similar to its older brother, RP2040, being pin compatible, and with many of the peripherals being basically the same. There are some major differences under the surface though, including more PIO peripherals (oh them sweet PIO peripherals), how booting works, and many additional security features. Furthermore the RP2350 also has a total of 4 separate cores, one pair of ARM Cortex M-33 cores, and one pair of Hazard 3 RISCV cores, but only the ARM pair or the RISCV pair can run at a time.

One further difference is that the ARM cores are using the ARMv8 instruction set, instead of ARMv7 and has a total of 52 interrupts, compared to 32 of the RP2040.

## Requirements
- Zig 0.13.0
- Pi Pico 2

To build the project simply run `zig build` and away you go.

## BootROM
The RP2350 must have one or a series of boot blocks/partition table in the first 4K of the flash. This allows the RP2350 to have multiple bootable images, and can run both secure and non-secure applications, where non-secure applications can be restricted from accessing peripherals. In this project I have only implemented the simplest boot configuration, a single **block** with the correct magic header and footer tags to run secure applications with full access to the peripherals.

## Register Access
I used my fork of [svd4zig](https://github.com/Fredrik-Reinholdsen/svd4zig) to generate the peripheral access code from the RP2350 SVD file. This allows for safe register access and feels very **ziggy* and ergonomic to use.

## Very Basic HAL
This project features a **very** basic HAL for basic interactions with the GPIO pins, and SIO peripherals.

## Entrypoint
**runtime.zig** contains the vector table in assembly and initializes and exports the boot block, interrupt handler functions and the entry point.

