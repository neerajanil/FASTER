const std = @import("std");

pub fn build(b: *std.Build) !void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const faster_lib = b.addLibrary(.{
        .name = "faster",
        .linkage = .static,
        .root_module = b.createModule(.{
            .target = target,
            .optimize = optimize,
        }),
    });
    faster_lib.addCSourceFiles(.{ .files = (try iterateFiles(b, "cc/src")).items });
    const include_dirs = [_][]const u8{"cc/src/"};
    for (include_dirs) |include_dir| {
        faster_lib.addIncludePath(b.path(include_dir));
    }
    faster_lib.linkLibC();
    faster_lib.linkLibCpp();
    faster_lib.linkSystemLibrary("uuid");
    faster_lib.linkSystemLibrary("tbb");
    faster_lib.installHeadersDirectory(b.path("cc/src/"), "", .{});

    b.installArtifact(faster_lib);
}

fn iterateFiles(b: *std.Build, path: []const u8) !std.ArrayList([]const u8) {
    var files = try std.ArrayList([]const u8).initCapacity(b.allocator, 100);
    var root_dir: std.fs.Dir = undefined;
    if (b.build_root.path) |p| {
        root_dir = try std.fs.openDirAbsolute(p, .{});
    } else {
        root_dir = std.fs.cwd();
    }

    var dir = try root_dir.openDir(path, .{ .iterate = true });
    var walker = try dir.walk(b.allocator);
    defer walker.deinit();
    var out: [256]u8 = undefined;
    const exclude_files: []const []const u8 = &.{"file_windows.cc"};
    const allowed_exts: []const []const u8 = &.{ ".c", ".cpp", ".cxx", ".c++", ".cc" };
    while (try walker.next()) |entry| {
        const ext = std.fs.path.extension(entry.basename);
        const include_file = for (allowed_exts) |e| {
            if (std.mem.eql(u8, ext, e))
                break true;
        } else false;
        if (include_file) {
            const exclude_file = for (exclude_files) |e| {
                if (std.mem.eql(u8, entry.basename, e))
                    break true;
            } else false;
            if (!exclude_file) {
                const file = try std.fmt.bufPrint(&out, ("{s}/{s}"), .{ path, entry.path });
                try files.append(b.allocator, b.dupe(file));
            }
        }
    }
    return files;
}
