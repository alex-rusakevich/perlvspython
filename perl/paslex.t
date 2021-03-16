#!/usr/bin/perl
use warnings;
use strict;
use utf8;

use Test::More tests => 4;

require_ok '/mnt/d/Development/perl/paslex.pl';

sub read_all {
    my ($filename) = @_;
    open(my $file_in, "<:utf8", $filename) or die "Can't open $filename! $!";
    my $text = do { undef $/; <$file_in> };
    close $file_in;
    return $text;
}

map { ok(
    do {
        print "Testing $_...\n";
        lex_file($_);
        read_all($_.".txt") eq read_all($_.".ref.txt"); 
    }, "Tested $_")
} qw{prog1.pas prog2.pas prog3.pas};
