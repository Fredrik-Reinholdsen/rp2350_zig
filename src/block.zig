//! Support for the RP235x Boot ROM's "Block" structures
//!
//! Blocks contain pointers, to form Block Loops.
//!
//! The `IMAGE_DEF` Block (here the `ImageDef` type) tells the ROM how to boot a
//! firmware image. The `PARTITION_TABLE` Block (here the `PartitionTable` type)
//! tells the ROM how to divide the flash space up into partitions.

// These all have a 1 byte size
const std = @import("std");

/// An item ID for encoding a Vector Table address
pub const ITEM_1BS_VECTOR_TABLE: u8 = 0x03;

/// An item ID for encoding a Rolling Window Delta
pub const ITEM_1BS_ROLLING_WINDOW_DELTA: u8 = 0x05;

/// An item ID for encoding a Signature
pub const ITEM_1BS_SIGNATURE: u8 = 0x09;

/// An item ID for encoding a Salt
pub const ITEM_1BS_SALT: u8 = 0x0c;

/// An item ID for encoding an Image Type
pub const ITEM_1BS_IMAGE_TYPE: u8 = 0x42;

/// An item ID for encoding the image's Entry Point
pub const ITEM_1BS_ENTRY_POINT: u8 = 0x44;

/// An item ID for encoding the definition of a Hash
pub const ITEM_2BS_HASH_DEF: u8 = 0x47;

/// An item ID for encoding a Version
pub const ITEM_1BS_VERSION: u8 = 0x48;

/// An item ID for encoding a Hash
pub const ITEM_1BS_HASH_VALUE: u8 = 0x4b;

// These all have a 2-byte size

/// An item ID for encoding a Load Map
pub const ITEM_2BS_LOAD_MAP: u8 = 0x06;

/// An item ID for encoding a Partition Table
pub const ITEM_2BS_PARTITION_TABLE: u8 = 0x0a;

/// An item ID for encoding a placeholder entry that is ignored
///
/// Allows a Block to not be empty.
pub const ITEM_2BS_IGNORED: u8 = 0xfe;

/// An item ID for encoding the special last item in a Block
///
/// It records how long the Block is.
pub const ITEM_2BS_LAST: u8 = 0xff;

// Options for ITEM_1BS_IMAGE_TYPE

/// A [`ITEM_1BS_IMAGE_TYPE`] value bitmask to mark an image as invalid
pub const IMAGE_TYPE_INVALID: u16 = 0x0000;

/// A [`ITEM_1BS_IMAGE_TYPE`] value bitmask to mark an image as an executable
pub const IMAGE_TYPE_EXE: u16 = 0x0001;

/// A [`ITEM_1BS_IMAGE_TYPE`] value bitmask to mark an image as data
pub const IMAGE_TYPE_DATA: u16 = 0x0002;

/// A [`ITEM_1BS_IMAGE_TYPE`] value bitmask to mark the CPU security mode as unspecified
pub const IMAGE_TYPE_EXE_TYPE_SECURITY_UNSPECIFIED: u16 = 0x0000;

/// A [`ITEM_1BS_IMAGE_TYPE`] value bitmask to mark the CPU security mode as Non Secure
pub const IMAGE_TYPE_EXE_TYPE_SECURITY_NS: u16 = 0x0010;

/// A [`ITEM_1BS_IMAGE_TYPE`] value bitmask to mark the CPU security mode as Non Secure
pub const IMAGE_TYPE_EXE_TYPE_SECURITY_S: u16 = 0x0020;

/// A [`ITEM_1BS_IMAGE_TYPE`] value bitmask to mark the CPU type as Arm
pub const IMAGE_TYPE_EXE_CPU_ARM: u16 = 0x0000;

/// A [`ITEM_1BS_IMAGE_TYPE`] value bitmask to mark the CPU type as RISC-V
pub const IMAGE_TYPE_EXE_CPU_RISCV: u16 = 0x0100;

/// A [`ITEM_1BS_IMAGE_TYPE`] value bitmask to mark the CPU as an RP2040
pub const IMAGE_TYPE_EXE_CHIP_RP2040: u16 = 0x0000;

/// A [`ITEM_1BS_IMAGE_TYPE`] value bitmask to mark the CPU as an RP2350
pub const IMAGE_TYPE_EXE_CHIP_RP2350: u16 = 0x1000;

/// A [`ITEM_1BS_IMAGE_TYPE`] value bitmask to mark the image as Try Before You Buy.
///
/// This means the image must be marked as 'Bought' with the ROM before the
/// watchdog times out the trial period, otherwise it is erased and the previous
/// image will be booted.
pub const IMAGE_TYPE_TBYB: u16 = 0x8000;

/// This is the magic Block Start value.
///
/// The Pico-SDK calls it `PICOBIN_BLOCK_MARKER_START`
const BLOCK_MARKER_START: u32 = 0xffffded3;

/// This is the magic Block END value.
///
/// The Pico-SDK calls it `PICOBIN_BLOCK_MARKER_END`
const BLOCK_MARKER_END: u32 = 0xab123579;

pub const Architecture = enum { arm, riscv };

pub const Security = enum { unspecified, secure, non_secure };

const Permission = enum(u32) {
    // Can be read in Secure Mode
    //
    // Corresponds to `PERMISSION_S_R_BITS` in the Pico SDK
    secure_read = 1 << 26,
    // Can be written in Secure Mode
    //
    // Corresponds to `PERMISSION_S_W_BITS` in the Pico SDK
    secure_write = 1 << 27,
    // Can be read in Non-Secure Mode
    //
    // Corresponds to `PERMISSION_NS_R_BITS` in the Pico SDK
    non_secure_read = 1 << 28,
    // Can be written in Non-Secure Mode
    //
    // Corresponds to `PERMISSION_NS_W_BITS` in the Pico SDK
    non_secure_write = 1 << 29,
    // Can be read in Non-Secure Bootloader mode
    //
    // Corresponds to `PERMISSION_NSBOOT_R_BITS` in the Pico SDK
    boot_read = 1 << 30,
    // Can be written in Non-Secure Bootloader mode
    //
    // Corresponds to `PERMISSION_NSBOOT_W_BITS` in the Pico SDK
    boot_write = 1 << 31,
};

const PartitionedFlag = enum(u32) {
    not_bootable_arm = 1 << 9,
    not_bootable_riscv = 1 << 10,
    uf2_download_ab_non_bootable_owner_affinity = 1 << 11,
    uf2_download_no_reboot = 1 << 13,
    accepts_default_family_rp2040 = 1 << 14,
    accepts_default_family_absolute = 1 << 15,
    accepts_default_family_data = 1 << 16,
    accepts_default_family_rp2350_arm_s = 1 << 17,
    accepts_default_family_rp2350_riscv = 1 << 18,
    accepts_default_family_rp2350_arm_ns = 1 << 19,
};

const UnPartitionedFlag = enum(u32) {
    uf2_download_no_reboot = 1 << 13,
    accepts_default_family_rp2040 = 1 << 14,
    accepts_default_family_absolute = 1 << 15,
    accepts_default_family_data = 1 << 16,
    accepts_default_family_rp2350_arm_s = 1 << 17,
    accepts_default_family_rp2350_riscv = 1 << 18,
    accepts_default_family_rp2350_arm_ns = 1 << 19,
};

fn itemImageTypeExe(security: Security, arch: Architecture) u32 {
    var value = IMAGE_TYPE_EXE | IMAGE_TYPE_EXE_CHIP_RP2350;

    switch (arch) {
        .arm => {
            value |= IMAGE_TYPE_EXE_CPU_ARM;
        },
        .riscv => {
            value |= IMAGE_TYPE_EXE_CPU_RISCV;
        },
    }

    switch (security) {
        .unspecified => {
            value |= IMAGE_TYPE_EXE_TYPE_SECURITY_UNSPECIFIED;
        },
        .secure => {
            value |= IMAGE_TYPE_EXE_TYPE_SECURITY_S;
        },
        .non_secure => {
            value |= IMAGE_TYPE_EXE_TYPE_SECURITY_NS;
        },
    }

    return itemGeneric1bs(value, 1, ITEM_1BS_IMAGE_TYPE);
}

fn itemGeneric1bs(value: u16, length: u8, command: u8) u32 {
    return ((@as(u32, @intCast(value))) << 16) | ((@as(u32, @intCast(length))) << 8) | (@as(u32, @intCast(command)));
}

// Make an item containing a tag, 2 byte length and one extra byte.
//
// The `command` arg should contain `2BS`
fn itemGeneric2bs(value: u8, length: u16, command: u8) u32 {
    return ((@as(u32, @intCast(value))) << 24) | ((@as(u32, @intCast(length))) << 8) | (@as(u32, @intCast(command)));
}

pub const Block linksection(".start_block") = extern struct {
    marker_start: u32,
    items: [1]u32,
    length: u32,
    offset: *const u32,
    marker_end: u32,

    // Initialize  and empty block of length 0
    pub fn init(item: u32) Block {
        return Block{
            .marker_start = BLOCK_MARKER_START,
            .items = [1]u32{item},
            .offset = undefined,
            .length = itemGeneric2bs(0, 1, ITEM_2BS_LAST),
            .marker_end = BLOCK_MARKER_END,
        };
    }
};

pub fn imageDefArchExe(security: Security, arch: Architecture) Block {
    return Block.init(itemImageTypeExe(security, arch));
}

pub fn imageDefSecure() type {
    if (std.Target.Cpu.Arch.isARM()) {
        return imageDefArchExe(Security.secure, Architecture.arm);
    } else {
        return imageDefArchExe(Security.secure, Architecture.riscv);
    }
}

pub fn imageDefNonSecure() type {
    if (std.Target.Cpu.Arch.isARM()) {
        return imageDefArchExe(Security.non_secure, Architecture.arm);
    } else {
        return imageDefArchExe(Security.non_secure, Architecture.riscv);
    }
}
