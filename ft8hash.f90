! ft8hash.f90 -- FT8/FT4 callsign hash, as in WSJT-X lib/77bit/packjt77.f90 (ihashcall)
! Build:  gfortran -O2 -fwrapv -o ft8hash ft8hash.f90
! Usage:  ./ft8hash CALLSIGN BITS      (BITS = 10, 12 or 22)
!
! SPDX-License-Identifier: BSD-3-Clause
! Copyright (c) 2026 Jeff Wandling

program ft8hash
  implicit none
  character(len=13) :: callsign
  character(len=8)  :: arg
  integer :: m, ios

  if (command_argument_count() /= 2) then
     write(*,'(a)') 'usage: ft8hash CALLSIGN BITS   (BITS = 10, 12 or 22)'
     stop 1
  end if
  call get_command_argument(1, callsign)
  call get_command_argument(2, arg)
  read(arg, *, iostat=ios) m
  if (ios /= 0 .or. m < 1 .or. m > 63) then
     write(*,'(a)') 'BITS must be an integer 1..63'
     stop 1
  end if

  write(*,'(i0)') ihashcall(upcase(callsign), m)

contains

  integer function ihashcall(c0, m)
    character(len=13), intent(in) :: c0
    integer, intent(in) :: m
    integer(kind=8) :: n8
    character(len=13) :: c1
    character(len=38), parameter :: c = ' 0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ/'
    integer :: i, j

    c1 = c0
    if (c1(1:1) == '<') c1 = c1(2:)
    i = index(c1, '>')
    if (i > 0) c1(i:) = '         '
    n8 = 0
    do i = 1, 11
       j = index(c, c1(i:i)) - 1
       n8 = 38*n8 + j
    end do
    ihashcall = int(ishft(47055833459_8*n8, m-64))
  end function ihashcall

  function upcase(s) result(u)
    character(len=*), intent(in) :: s
    character(len=len(s)) :: u
    integer :: k
    u = s
    do k = 1, len(s)
       if (s(k:k) >= 'a' .and. s(k:k) <= 'z') u(k:k) = achar(iachar(s(k:k)) - 32)
    end do
  end function upcase

end program ft8hash
