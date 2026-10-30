# NAME

Text::VisualWidth::PP - trimming text by the number of the columns of terminals and mobile phones.

# SYNOPSIS

    use utf8;
    use Text::VisualWidth::PP;

    Text::VisualWidth::PP::width("あいうえおaiu"); # => 13
    Text::VisualWidth::PP::trim("あいうえおaiu", 7); # => "あいう"

    # with exporter
    use Text::VisualWidth::PP qw(vwidth vtrim);
    vwidth("あいうえおaiu"); # => 13
    vtrim("あいうえおaiu", 7); # => "あいう"

# DESCRIPTION

This module provides functions to treat half-width and full-width characters and display correct size of text in one line on terminals and mobile phones. You can know the visual width of any text and truncate text by the visual width. Now this module support flagged UTF-8 and tested only with Japanese.

This module is pure perl version of [Text::VisualWidth](https://metacpan.org/pod/Text%3A%3AVisualWidth). This is bit slow, but it's not require compiler.

# Ambiguous Characters

This module treats ambiguous characters are half width by default.

And you can specify the behavior by the `$Text::VisualWidth::PP::EastAsian` flag expressly.

Note: If `$Unicode::EastAsianWidth::EastAsian` is true when this module is loaded, this module set `$Text::VisualWidth::PP::EastAsian` as true for backward compatibility.  [Unicode::EastAsianWidth](https://metacpan.org/pod/Unicode%3A%3AEastAsianWidth) itself is not used any more.

If you want to detect the ambw parameter from users' environment, please look [Unicode::EastAsianWidth::Detect](https://metacpan.org/pod/Unicode%3A%3AEastAsianWidth%3A%3ADetect).

# Unicode Version

The width classes come from the `East_Asian_Width` property of perl
itself, so they follow the Unicode version of the perl in use (see
[perluniprops](https://metacpan.org/pod/perluniprops)), as the other properties used by this module do.
Characters added to Unicode after that version are treated as
neutral, that is, half width.

Earlier versions used the table of [Unicode::EastAsianWidth](https://metacpan.org/pod/Unicode%3A%3AEastAsianWidth),
which is fixed at Unicode 12.0 and gave no width to the characters
added since.

# AUTHOR

Tokuhiro Matsuno &lt;tokuhirom AAJKLFJEF GMAIL COM>

# SEE ALSO

[Text::VisualWidth](https://metacpan.org/pod/Text%3A%3AVisualWidth)

# LICENSE

Copyright (C) Tokuhiro Matsuno

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.
