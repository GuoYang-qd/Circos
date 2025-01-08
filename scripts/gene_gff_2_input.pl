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

my %freq;
open GENE, "< $genes " or die $!;
while (<GENE>) {
        chomp;
        next if (/^#/);
        my @b = split/\s+/,$_;
        my $i1 = int($b[1]/$window);
        my $i2 = int($b[2]/$window);
        if ($i1 == $i2) {
                $freq{$b[0]}{$i1}++;
        } elsif ($i1 < $i2) {
                $freq{$b[0]}{$i1}++;
        }
}
close GENE;

foreach my $k (sort { $freq{$a} cmp $freq{$b} } keys %freq) {
        my $end = int($genome_s{$k}/$window);
        for(my $i=0;$i<$end;$i++) {
                my $f_start = $i*$window+1;
                my $f_end = ($i+1)*$window;
                if (!($freq{$k}{$i})) {$freq{$k}{$i} = 0;}
                print "$k\t$f_start\t$f_end\t$freq{$k}{$i}\n";
        }
        my $start = $end*$window+1;
        if (!($freq{$k}{$end})) {$freq{$k}{$end} = 0;}
        print "$k\t$start\t$genome_s{$k}\t$freq{$k}{$end}\n";
}