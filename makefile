# SPDX-License-Identifier: BSD-3-Clause
# Copyright (c) 2026 Jeff Wandling
#
# from command line shell, just run make.
#
# $ make

it:
	gfortran -O2 -fwrapv -o ft8hash ft8hash.f90

clean:
	rm -f ft8hash

