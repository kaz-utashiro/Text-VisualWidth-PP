use strict;
use warnings;
use utf8;
use Test::More;
use Unicode::UCD ();

use Text::VisualWidth::PP 'vwidth';

# The width classes come from the East_Asian_Width property of perl,
# so the characters added in each Unicode version have their width
# on the perls that know that version.

my $unicode = Unicode::UCD::UnicodeVersion();
my($major, $minor) = split /\./, $unicode;

for my $case (
    [ "\N{U+32FF}",  '12.1', 'SQUARE ERA NAME REIWA' ],
    [ "\N{U+1F6D7}", '13.0', 'ELEVATOR' ],
    [ "\N{U+1FAAA}", '14.0', 'IDENTIFICATION CARD' ],
) {
    my($char, $since, $name) = @$case;
    my($need_major, $need_minor) = split /\./, $since;
    SKIP: {
	skip "$name needs Unicode $since, perl has $unicode", 2
	    if $major < $need_major
	    or $major == $need_major && $minor < $need_minor;
	is(vwidth($char), 2, "$name (Unicode $since)");
	is(vwidth("a${char}b"), 4, "$name between ASCII");
    }
}

done_testing;
