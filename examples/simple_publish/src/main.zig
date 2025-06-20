const std = @import("std");
const amqp = @import("amqp");

var rx_memory: [4096]u8 = undefined;
var tx_memory: [4096]u8 = undefined;

pub fn main() !void {
    var conn = amqp.init(rx_memory[0..], tx_memory[0..]);
    const addr = try std.net.Address.parseIp4("127.0.0.1", 5672);
    try conn.connect(addr);

    var ch = try conn.channel();
    _ = try ch.queueDeclare("simple_publish", .{}, null);

    for (0..4) |_| {
        try ch.basicPublish("", "simple_publish", "AAAABBBB", .{});
    }
    std.debug.print("done\n", .{});
}
