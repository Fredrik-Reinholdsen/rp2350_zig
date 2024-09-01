const builtin = @import("builtin");
const std = @import("std");
const ElfHeader = std.elf.Header;

//const uf2 = @import("build/uf2.zig");
//const UF2 = uf2.UF2;

const FILE_DELIM = switch (builtin.os.tag) {
    .windows => "\\",
    else => "/", // Are we sure about that?
};

pub fn build(b: *std.Build) void {
    const output_name = "rp2350_zig";
    const elf_name = output_name ++ ".elf";

    // Set the target to thumbv8m-none-eabi
    const target_query = std.zig.CrossTarget{
        .os_tag = .freestanding,
        .cpu_arch = .thumb,
        .cpu_model = .{
            .explicit = &std.Target.arm.cpu.cortex_m33,
        },
        .abi = .eabi,
    };

    const target = b.resolveTargetQuery(target_query);

    const optimize = std.builtin.OptimizeMode.ReleaseSmall;

    const app = b.addObject(.{
        .name = "app",
        .root_source_file = b.path("src/runtime.zig"),
        .optimize = optimize,
        .target = target,
    });

    const block = b.addObject(.{
        .name = "block",
        .root_source_file = b.path("src/block.zig"),
        .optimize = optimize,
        .target = target,
    });

    const elf = b.addExecutable(.{
        .name = elf_name,
        .optimize = optimize,
        .target = target,
    });

    // Use the custom linker script to build a baremetal program
    elf.setLinkerScriptPath(b.path("src/linker.ld"));
    elf.addObject(block);
    elf.addObject(app);
    b.installArtifact(elf);
    const compile_step = b.step("compile", "Compiles RP2350 ELF file");
    compile_step.dependOn(&elf.step);
}

//const GenerateUF2Step = struct {
//    step: Step,
//    elf_file_source: std.build.FileSource,
//    uf2_filename: []const u8,
//    builder: *std.build.Builder,
//
//    pub fn init(
//        builder: *std.build.Builder,
//        name: []const u8,
//        elf_file_source: std.build.FileSource,
//        uf2_filename: []const u8,
//    ) GenerateUF2Step {
//        return .{
//            .step = Step.init(.custom, name, builder.allocator, generate_uf2),
//            .elf_file_source = elf_file_source,
//            .uf2_filename = uf2_filename,
//            .builder = builder,
//        };
//    }
//
//    fn generate_uf2(step: *Step) !void {
//        const self = @fieldParentPtr(GenerateUF2Step, "step", step);
//        const elf_filename = self.elf_file_source.getPath(self.builder);
//
//        const elf_file = try std.fs.cwd().openFile(
//            elf_filename,
//            .{
//                .read = true,
//            },
//        );
//        defer elf_file.close();
//        const uf2_file = try std.fs.cwd().createFile(
//            self.uf2_filename,
//            .{
//                .truncate = true,
//            },
//        );
//        defer uf2_file.close();
//
//        const reader = elf_file.reader();
//        const writer = uf2_file.writer();
//
//        var uf2_writer = UF2.init(&self.builder.allocator, 0x10000000, .{ .family_id = 0xe48bff56 });
//        defer uf2_writer.deinit();
//
//        const elf_header = try ElfHeader.read(elf_file);
//        var prog_header_it = elf_header.program_header_iterator(elf_file);
//        while (try prog_header_it.next()) |header| {
//            if (header.p_filesz == 0) continue;
//            const file_offset = header.p_offset;
//            const section_size = header.p_filesz;
//            const target_address = header.p_paddr;
//
//            try elf_file.seekTo(file_offset);
//            var read_len: usize = 0;
//            while (read_len < section_size) {
//                var buf: [256]u8 = undefined;
//                const bytes = try reader.readAll(buf[0..]);
//                const chunk_len = if (read_len + bytes > section_size) section_size - read_len else bytes;
//                try uf2_writer.addData(buf[0..chunk_len], @intCast(u32, target_address + read_len));
//                read_len += bytes;
//            }
//        }
//
//        try uf2_writer.write(&writer);
//    }
//};
