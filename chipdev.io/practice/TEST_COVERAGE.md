# Testbench coverage guide

Every local testbench is self-checking. Each comparison prints a line containing the
case name, actual value, and expected value. A mismatch calls `$fatal`; `Qxx PASS` is
printed only after every check completes. All tests also generate `dump.vcd`.

Q27 is absent because the source collection has no Q27 problem or interface.

| Questions | Main cases covered |
|---|---|
| Q01 | Both inputs, every address, data changes |
| Q02 | Reset, increasing/mixed streams, duplicates, unsigned maximum values |
| Q03 | Zero, rounding boundary, saturation boundary, maximum input |
| Q04 | Reset value, full Gray sequence, terminal hold |
| Q05 | Zero/ones, alternating and asymmetric patterns, bit-by-bit walking tests |
| Q06 | No edge, rising/falling edges, consecutive toggles, reset while high |
| Q07–Q08 | Reset, complete words, bit order, load/shift behavior, extra shifts |
| Q09 | Reset, initial Fibonacci terms, longer recurrence, wrap by output width |
| Q10 | Zero/ones, walking ones, patterns, randomized vectors |
| Q11 | Zero/max/patterns and the first 256 binary-to-Gray round trips |
| Q12 | All-zero special result, all bit positions, max and patterned inputs |
| Q13 | Zero, every one-hot position, multi-hot and all-one inputs |
| Q14 | Idle/start/latched run, stop priority, simultaneous controls, wrap, reset |
| Q15 | Partial matches, exact 1010, overlapping matches, mismatch and reset |
| Q16–Q17 | Reset plus long MSB-first streams checked by independent modulo models |
| Q18 | All-zero/all-one, symmetric and asymmetric patterns |
| Q19 | Init capture, init changes ignored, minimum five bits, overlap, reset |
| Q20 | Reset and 24 cycles of divide-by-2/4/6 phase and duty behavior |
| Q21 | Zero behavior, every classification, counter wrap, reset |
| Q22 | Exhaustive eight full-adder input combinations |
| Q23 | Exhaustive 4-bit A/B combinations for all six ALU outputs |
| Q24 | Carry boundaries, alternating patterns and randomized additions |
| Q25 | Unwritten read, first/last address, read/write error, NOP, reset clearing |
| Q26 | Empty, fill levels, full overwrite/drop-oldest, idle hold, reset |
| Q28 | Two consecutive vectors, ordinary and maximum-value dot products |
| Q29 | Minimum, boundaries, middle, near-maximum and maximum thermometer output |
| Q30 | Exhaustive 256 input codes, both thermometer polarities, uniform invalid |
| Q31 | Unwritten/distinct reads, NOP, all collision forms, address 31, reset |
| Q32 | FIFO underflow/overflow, full simultaneous push/pop, empty push/pop, order |
| Q33 | Rotation, no-request pointer hold, sparse and persistent requests |
| Q34 | Capture, backpressure stability, consume/replace, drain, full throughput |
| Q35 | APB setup/access phases, reads/writes, byte strobes, bad/misaligned address |
| Q36 | Multiple source events, destination count and one-cycle pulse width |
| Q37 | Independent clocks, ordering, full/empty synchronization, blocked write |
| Q38 | Both ports, independent writes, same-address collision and write suppression |
| Q39 | Asynchronous select changes, runt-phase detection, reset-low behavior |
| Q40 | LSB order, backpressure, `out_last`, final-cycle ready, zero-bubble refill |
| Q41 | LSB/MSB order, programmable length, enable stalls, busy start, zero length |
| Q42 | Chunk order, stalls, `out_last`, zero-bubble word replacement |
| Q43 | Two occupied slots, stalls, ordering, bubble-free pending-word promotion |
| Q44 | Header/payload/checksum, zero payload, stalls, packet-to-packet refill |
| Q45 | Arbitration rotation, non-interleaving, stalls, source ID and fairness |

## Scope and limitations

- These are deterministic simulation tests intended for fast interview practice; they
  are not a proof that every possible implementation state is correct.
- Small combinational spaces are exhaustive where practical (Q22, Q23, Q30). Wider
  datapaths use boundary, patterned, or randomized samples.
- CDC tests (Q36–Q37) validate behavior at the clocks and event rates in the testbench.
  They cannot model analog metastability or replace CDC structural analysis.
- The glitch-free clock test (Q39) detects short simulated phases for several selection
  timings; implementation-specific clock-gating signoff still requires dedicated tools.
