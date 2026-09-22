/*
 * Q44 — Variable-Length Packet Byte Serializer
 *
 * Accept a packet descriptor and serialize it into output bytes using ready/valid handshaking.
 * MAX_PAYLOAD_BYTES defaults to 4.
 * - Input handshake captures header, payload_length, and payload.
 * - Output sequence is:
 *     1) preamble 8'hA5
 *     2) header[15:8]
 *     3) header[7:0]
 *     4) payload bytes payload[7:0], payload[15:8], ... up to payload_length bytes
 *     5) one checksum byte
 * - The checksum is the bitwise XOR of the two header bytes and all transmitted payload bytes.
 *   The preamble is not included.
 * - payload_length ranges from 0 through MAX_PAYLOAD_BYTES and must be captured with the packet.
 * - Assert out_last only with the checksum byte.
 * - Advance only on out_valid && out_ready. Hold out_byte and out_last stable during backpressure.
 * - Deassert in_ready while a packet is active. A new packet may be accepted on the same edge that
 *   transfers the current checksum byte, allowing packet-to-packet operation without an invalid bubble.
 */
module packet_byte_serializer #(
  parameter int MAX_PAYLOAD_BYTES = 4,
  parameter int LENGTH_WIDTH = $clog2(MAX_PAYLOAD_BYTES + 1)
) (
  input  logic                               clk,
  input  logic                               resetn,
  input  logic                               in_valid,
  output logic                               in_ready,
  input  logic [15:0]                        header,
  input  logic [LENGTH_WIDTH-1:0]            payload_length,
  input  logic [MAX_PAYLOAD_BYTES*8-1:0]     payload,
  output logic                               out_valid,
  input  logic                               out_ready,
  output logic [7:0]                         out_byte,
  output logic                               out_last
);

  // TODO: Implement your design here.

endmodule

