#!/usr/bin/perl
use warnings;
use strict;
use utf8;

use List::Util qw(any);

sub lex_file {
    my ($filename) = @_;

    my @KEYWORDS = map {qr/$_/i} qw(and array asm begin break case
    const constructor continue destructor div do downto else end
    false file for function goto if implementation in inline
    interface label mod nil not object of on operator or packed
    procedure program record repeat set shl shr string then to
    true type unit until uses var while with xor
    
    as attribute class cardinal constref dispose except exit exports finalization
    finally inherited initialization is library new on out property
    raise self threadvar try);

    my @PATTERNS = (
        {string => qr/\'[^\']*\'/},
        {comment => qr/\{[^\$][^}]+\}/},
        {directive => qr/\{\$[^}]+\}/},
        {blank => qr/[\s\n]+/},
        {name => qr/[\w\d][\w\d_]*/}, 
        {spec_char => qr/(:=|\(|\)|\.|\;|\-|\+|\/|\*|\=|\]|\[|,|:|\^|\$)/},
        {integer => qr/\d+(?![\.\w])/},
        {real => qr/\d+\.\d+/}
    );

    open(my $file_in, "<:utf8", $filename) or die "Can't open $filename! $!";
    my $text = do { undef $/; <$file_in> };
    close $file_in;

    my @result = [];
    my $rel_pos = 0;

    ALL_SEARCH:
    while ($text) {
        foreach my $keyword (@KEYWORDS) {
            if ($text =~ "^$keyword") {
                push @result, {
                    body => $&,
                    type => "keyword",
                    start => $rel_pos
                };
                $text = substr $text, length($&);
                $rel_pos += length($&);
                next ALL_SEARCH;
            }
        }

        foreach my $pattern (@PATTERNS) {
            my $type = (keys %$pattern)[0];

            if ($text =~ "^$pattern->{$type}") {
                if (not any { $_ eq "$type" } ("blank", "comment")) {
                    push @result, {
                        body => $&,
                        type => $type,
                        start => $- + $rel_pos
                    };
                }
                $text = substr $text, length($&);
                $rel_pos += length($&);
                next ALL_SEARCH;
            }
        }

        my $die_str = substr $text, 0, 5;
        die "Unknown pattern: $die_str...";
    }
    shift @result;

    open(my $file_out, ">:utf8", $filename.".perl.txt");

    foreach my $item (@result) {
        my %item = %{$item};
        print $file_out "$item{body} - $item{type} at $item{start}\n";
    }

    return 1;
}

if ($ARGV[1]) {
    lex_file($ARGV[1])
}

1;
