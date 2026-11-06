<!--
   SPDX-License-Identifier: BSD-3-Clause
   Copyright (c) 2026 Jeff Wandling
-->

# FT8 Hash Collisions on Receive

The problem comes from the fact that a hash only names a station, it doesn't carry the callsign. Your receiver has to work out which station a hash belongs to, and when two stations share a hash it can pick the wrong one without any warning.

## How FT8 uses hashes on receive

1. A message's callsign fields are tight. Standard calls fit in 28 bits, but compound or nonstandard calls (`PJ4/K1ABC`, `KH1/KH7Z`) don't. So some message types carry the full call for one station and only a 12- or 22-bit hash for the other.
2. Each time WSJT-X decodes a full callsign, it computes the 10-, 12- and 22-bit hashes and stores them in a lookup table for the session.
3. When a later message arrives carrying only a hash, the decoder looks it up. If it finds a match, it shows the callsign in brackets (`<PJ4/K1ABC>`). If not, it shows `<...>`.

## Where it breaks

If two stations heard in the same session hash to the same value, the table can't tell them apart. The 10- and 12-bit tables are indexed directly by the hash, so whichever station was heard last overwrites the earlier one. A later hashed message then gets labeled with the wrong callsign. Your screen shows a report or an RR73 coming from a station that never sent it. That can confuse the QSO sequence, start auto-sequencing on the wrong exchange, or put a bad entry in your log.

Your own call is a special case. Messages addressed to you are recognized partly by your call's hash. If another station's hash matches yours, a message meant for them can look like it's meant for you.

## Why the CRC doesn't help

The message really did arrive intact, so the CRC passes. The error is in interpreting the bits, not in receiving them. Nothing in the protocol can detect a collision.

## How likely it is

This is the birthday problem. The chance of at least one collision among *n* stations is about 1 − e^(−n²/2N), where N = 2^bits:

| Stations in session | 10-bit | 12-bit | 22-bit |
|---|---|---|---|
| 20 | ~17% | ~5% | ≈0 |
| 50 | ~70% | ~26% | ≈0.03% |
| 100 | ≈100% | ~70% | ~0.1% |

A busy 20 m session easily decodes 100+ stations, so 12-bit collisions are routine. That's tolerable only because 12-bit hashes appear in the less common nonstandard-call messages, and the operator usually has context to sort it out. The 22-bit hash is effectively safe at band-level populations. The 10-bit hash, used in Fox/Hound DXpedition mode, would collide constantly in general use. In that mode a Hound only checks whether the hash matches the one Fox it's working, so a collision rarely matters.
