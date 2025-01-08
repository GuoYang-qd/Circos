#!/usr/bin/perl

use strict;

die qq(
        Usage: perl $0 genome_size.txt gene.gff window
) unless (@ARGV==3);

my $genome_size = shift;
my $genes = shift;
my $window = shift;

open GS,"< $genome_size" or die $!;
my %genome_s;
while (<GS>) {
        chomp;
        my @a = split/\s+/,$_;
        $genome_s{$a[0]} = $a[1];
}
close GS;

my %pos;
open GENE, "< $genes " or die $!;
while (<GENE>) {
        chomp;
        next if (/^#/);
        my @b = split/\s+/,$_;
        for (my $i=$b[1];$i<$b[2]+1;$i++) {
                $pos{$b[0]}{$i} = 1;
        }
}
close GENE;

my ($freq,$end);
foreach my $k (sort { $a cmp $b } keys %genome_s) {
        for (my $j=1;$j<$genome_s{$k}+1;$j=$j+$window) {
                my $s = 0;
                for (my $l = $j;$l<$j+$window;$l++) {
                        if (exists $pos{$k}{$l}) {
                                $s++;
                        }
                }
                if ($genome_s{$k}-$j+1>=$window) {
                        $freq = $s/$window;
                        $end = $j+$window-1;
                        print "$k\t$j\t$end\t$freq\n";
                } else {
                        my $n = $genome_s{$k}-$j+1;
                        $freq = $s/$n;
                        $end = $j+$n-1;
                        print "$k\t$j\t$end\t$freq\n";
                }
        }
}
