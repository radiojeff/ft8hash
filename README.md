<!--
   SPDX-License-Identifier: BSD-3-Clause
   Copyright (c) 2026 Jeff Wandling
-->

# Hashes and CRCs: Digital Fingerprints

Sample to show FT8-Hash Collisions

## The short version

A hash is a small number that stands in for a large piece of data, and CRCs are the kind that make sure what arrived is what was sent.

[Reasoning why this is a problem for FT-8](./CAUSE.md)

## Details

To understand a bit better what this means, consider what hashing means.

It's a term in computer programming and computer science that reduces to a
fixed length a value that represents a unique value for any input offered.

You can think of it as a check-sum, or CRC (because a check-sum, CRC is literally a hash value of the input)


### What is a hash?

A **hash** is a fingerprint for data. You feed in anything (a word, a photo, a whole movie) and a fixed recipe turns it into a short number. The same input always gives the same number, and changing even one letter gives a completely different number. Because the number is small, a computer can compare two fingerprints in an instant instead of comparing the whole files, which might be huge.

### CRCs: catching accidents

A **CRC** (cyclic redundancy check) is a fingerprint made for catching accidents. When data travels over a wire, through the air, or sits on a disk for years, it can get corrupted: static on a radio channel, a scratch on a disc, a flaky cable.

The sender computes a CRC and attaches it to the message, and the receiver recomputes it from what arrived. If the two numbers don't match, something got garbled along the way, and the receiver asks for a resend or throws the data out.

It works like the check digit on a credit card or a barcode, only much stronger.

A CRC is very good at catching random damage. It can't stop a person who deliberately alters the data, because they can just recompute the fingerprint to match.

### Cryptographic hashes: stopping tampering

For that there are **cryptographic hashes**, which are built so that no one can feasibly forge a matching fingerprint. These protect software updates, banking and websites. When your phone installs an update, it checks a cryptographic fingerprint first to make sure the update really came from the manufacturer and wasn't tampered with.

### Where you'll find them

Hashing is everywhere, mostly invisibly:

- **Every network message:** each packet crossing your home Wi-Fi or the internet carries a CRC, checked millions of times a second.
- **Files:** zip files, photos and disk drives use CRCs to notice when stored data has decayed.
- **Search and lookup:** phone contacts and website logins use hashes to find things instantly instead of searching one by one.
- **Passwords:** well-run websites store a hash of your password, not the password itself, so a stolen database doesn't reveal it directly.
- **Aircraft and spacecraft:** flight software loaded onto an airplane is checked against its fingerprint before it can run, and critical sensor data carries CRCs so a corrupted reading is caught rather than acted on.
- **Ham radio:** FT8, a popular digital mode, attaches a CRC to every short message so a receiving station can tell a clean decode from noise that happened to look like a message.


# Build

On most Linux/Unix shells --

It's a single file Fortran program.  The `makefile` is provided

You might need the package `gfortran`

`# apt install gfortran`


Otherwise, just run make:

```
$ make
```


# Running

A helper shell script is there.

It's preloaded with some callsigns known to have hash-collisions.

```
$ bash doit.sh
```

If you want to just try out a specific call sign:

```
$ ./ft8hash CALLSIGN BIT_LENGTH
```

Where `BIT_LENGTH` is 10, 12 or 22 bits


```
$ ./ft8hash W7BRS 10
$ ./ft8hash W7BRS 12
$ ./ft8hash W7BRS 22 
```

Etc.

Inspect results and compare with your own reasoning.

# Theory and Details


FT8 (in the 77-bit message format, WSJT-X 2.0 and later) uses a multiplicative hash on a base-38 packing of the callsign. It’s ihashcall in lib/77bit/packjt77.f90 in the WSJT-X source, and it works like this:

- Strip any < > brackets, then left-justify the callsign and pad it with spaces to 11 characters.
- Treat it as an 11-digit base-38 number over the alphabet ' 0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ/', where space is 0. Then n = 38*n + index(c) for each character. The maximum, 38¹¹ ≈ 2.4×10¹⁷, fits in 63 bits.
0 Multiply by the constant 47055833459, wrapping at 64 bits.
- Keep the top m bits by shifting right by 64 − m.

The 22-bit hash goes in the 28-bit callsign slots of standard messages, the 12-bit one in type-4 nonstandard-callsign messages, and the 10-bit one in DXpedition (Fox/Hound) messages. All three are the same function with a different m


In WSJT-X the signal processing and protocol code (encoders, decoders, LDPC, message packing) lives in lib/ and is mostly modern Fortran (.f90), with a few C files mixed in. The GUI and application layer is C++ with Qt. The Fortran comes from Joe Taylor’s earlier WSJT programs, which were written in Fortran from the start.

For C reference instead, Kārlis Goba’s ft8_lib (kgoba/ft8_lib on GitHub) is a standalone C implementation of FT8/FT4 encoding and decoding. It includes the same callsign hash and is easier to read than the Fortran.
