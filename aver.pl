#!/usr/bin/perl
use warnings;
use strict;
use utf8;

sub process_log {
    my ($filename, $lang) = @_;
    open(my $file_in, "<:utf8", $filename) or die "Error while opening file $filename";

    my $num = 0;
    my @reals = [];
    my @users = [];

    while(<$file_in>) {
        if (/(?<=real )\d.\d+/) {
            $num++;
            push @reals, $&;
        } elsif (/(?<=user )\d.\d+/) {
            push @users, $&;
        }
    }

    close $file_in;

    shift @reals; shift @users;

    open(my $file_out, ">:utf8", "averlog$lang.txt") or die "Error while opening file.";

    print $file_out "$lang:\n";

    my $aver_real = 0;
    foreach my $i (@reals) {
        $aver_real += $i;
    }
    print $file_out "Average real time is ".$aver_real/$num."\n";
    my $users_real = 0;

    foreach my $i (@users) {
        $users_real += $i;
    }
    print $file_out "Average user time is ".$users_real/$num."\n";
    print $file_out "Their sum is ".($aver_real/$num+$users_real/$num)."\n";
}

sub main {
    process_log("perl/perlog.txt", "Perl");
    process_log("python/pylog.txt", "Python");
    return 1;
}

main();
