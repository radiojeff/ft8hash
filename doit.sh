#!/bin/bash
# SPDX-License-Identifier: BSD-3-Clause
# Copyright (c) 2026 Jeff Wandling


echo callsign: E51SGC
echo expected 10-bit hash: 793
./ft8hash E51SGC 10
echo expected 12-bit hash: 3174
./ft8hash E51SGC 12
echo expected 22-bit hash: 3251174
./ft8hash E51SGC 22

echo callsign: 6W/IK2HKT
echo expected 10-bit hash: 793
./ft8hash 6W/IK2HKT 10
echo expected 12-bit hash: 3172
./ft8hash 6W/IK2HKT 12
echo expected 22-bit hash: 3248691
./ft8hash 6W/IK2HKT 22


