use strict;
use warnings;
use utf8;
use Test::More;

use Text::VisualWidth::PP 'vwidth';

# Characters added after Unicode 12.0, the version of the table in
# Unicode::EastAsianWidth, have their width from the Unicode version
# of the perl in use.

plan skip_all => 'perl 5.32 or later has Unicode 13.0' if $^V lt v5.32;

is(vwidth("\N{U+32FF}") => 2, '\N{SQUARE ERA NAME REIWA} (Unicode 12.1)');
is(vwidth("\N{U+1FAAA}") => 2, '\N{IDENTIFICATION CARD} (Unicode 13.0)');
is(vwidth("\N{U+1F6D7}") => 2, '\N{ELEVATOR} (Unicode 13.0)');
is(vwidth("a\N{U+1FAAA}b") => 4, 'mixed with ASCII');

done_testing;
