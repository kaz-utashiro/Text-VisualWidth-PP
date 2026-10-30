package Text::VisualWidth::PP;
use strict;
use warnings;
use 5.008005;
use parent qw(Exporter);
our $VERSION = '0.08';
our @EXPORT_OK = qw(vwidth vtrim);

# for backward compatibility, see the POD
our $EastAsian = do { no warnings 'once'; $Unicode::EastAsianWidth::EastAsian };

# Each width class as a user-defined property body.  The
# East_Asian_Width property of perl (5.8.5 and later) follows the
# Unicode version of the perl in use, as the other properties used
# here do.
sub EAW {
    my $class = shift;
    "+utf8::East_Asian_Width=$class\n";
}

if ($^V lt v5.32) {
    no strict 'refs';
    *{"utf8::Is_Emoji_Modifier"} = sub { "1F3FB\t1F3FF\n" };
};

sub Spacing {
    $_[0] . <<END
-utf8::Nonspacing_Mark
-utf8::Enclosing_Mark
-utf8::Default_Ignorable_Code_Point
-utf8::Is_Emoji_Modifier
END
}

sub InVWPP1Fullwidth() {
    Spacing
    EAW('Fullwidth') . EAW('Wide') . EAW('Ambiguous')
}
sub InVWPP0Fullwidth() {
    Spacing
    EAW('Fullwidth') . EAW('Wide')
}
sub InVWPP1Halfwidth() {
    Spacing
    EAW('Halfwidth') . EAW('Narrow') . EAW('Neutral')
}
sub InVWPP0Halfwidth() {
    Spacing
    EAW('Halfwidth') . EAW('Narrow') . EAW('Neutral') . EAW('Ambiguous')
}

sub vwidth { width(@_) }
sub vtrim  {  trim(@_) }

# E_Modifier not following E_Base has full-width visual representation
my $EM = $^V ge v5.28 ? '(?>(?<!\p{Line_Break=E_Base})\p{Line_Break=E_Modifier})'
                      : '(?!)' ;
$EM = qr/$EM/; # to avoid error on v5.24

sub width {
    my $str = shift;

    my $ret = 0;
    if ($EastAsian) {
        while ($str =~ /((?:$EM|(?<!\N{U+200D})\p{InVWPP1Fullwidth})+)
                       |((?:    (?<!\N{U+200D})\p{InVWPP1Halfwidth})+)/xg) {
            $ret += $1 ? length($1) * 2 : length($2)
        }
    } else {
        while ($str =~ /((?:$EM|(?<!\N{U+200D})\p{InVWPP0Fullwidth})+)
                       |((?:    (?<!\N{U+200D})\p{InVWPP0Halfwidth})+)/xg) {
            $ret += $1 ? length($1) * 2 : length($2)
        }
    }
    $ret;
}

sub trim {
    my ($str, $limit) = @_;

    my $cnt = 0;
    my $ret = '';
    my $fullwidth = $EastAsian ? qr/\p{InVWPP1Fullwidth}/ : qr/\p{InVWPP0Fullwidth}/;
    while ($str =~ /\G(\X)/g) {
        my $ch = $1;
        my $w = do {
            if ($ch =~ /\A$fullwidth\z/) {
                2;
            } elsif (length($ch) == 1) {
                1;
            } else {
                width($ch);
            }
        };
        if ($cnt+$w <= $limit) {
            $ret .= $ch;
            $cnt += $w;
        } else {
            last;
        }
    }
    $ret;
}

1;
__END__

=for stopwords ambw

=encoding utf8

=head1 NAME

Text::VisualWidth::PP - trimming text by the number of the columns of terminals and mobile phones.

=head1 SYNOPSIS

    use utf8;
    use Text::VisualWidth::PP;

    Text::VisualWidth::PP::width("あいうえおaiu"); # => 13
    Text::VisualWidth::PP::trim("あいうえおaiu", 7); # => "あいう"

    # with exporter
    use Text::VisualWidth::PP qw(vwidth vtrim);
    vwidth("あいうえおaiu"); # => 13
    vtrim("あいうえおaiu", 7); # => "あいう"

=head1 DESCRIPTION

This module provides functions to treat half-width and full-width characters and display correct size of text in one line on terminals and mobile phones. You can know the visual width of any text and truncate text by the visual width. Now this module support flagged UTF-8 and tested only with Japanese.

This module is pure perl version of L<Text::VisualWidth>. This is bit slow, but it's not require compiler.

=head1 Ambiguous Characters

This module treats ambiguous characters are half width by default.

And you can specify the behavior by the C<$Text::VisualWidth::PP::EastAsian> flag expressly.

Note: If C<$Unicode::EastAsianWidth::EastAsian> is true when this module is loaded, this module set C<$Text::VisualWidth::PP::EastAsian> as true for backward compatibility.  L<Unicode::EastAsianWidth> itself is not used any more.


If you want to detect the ambw parameter from users' environment, please look L<Unicode::EastAsianWidth::Detect>.

=head1 Unicode Version

The width classes come from the C<East_Asian_Width> property of perl
itself, so they follow the Unicode version of the perl in use (see
L<perluniprops>), as the other properties used by this module do.
Characters added to Unicode after that version are treated as
neutral, that is, half width.

Earlier versions used the table of L<Unicode::EastAsianWidth>,
which is fixed at Unicode 12.0 and gave no width to the characters
added since.

=head1 AUTHOR

Tokuhiro Matsuno E<lt>tokuhirom AAJKLFJEF GMAIL COME<gt>

=head1 SEE ALSO

L<Text::VisualWidth>

=head1 LICENSE

Copyright (C) Tokuhiro Matsuno

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
