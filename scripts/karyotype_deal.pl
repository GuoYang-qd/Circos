#!/usr/bin/perl

use strict;

my $fasta = shift;
my $get_size = "faSize -detailed $fasta | grep -v \"unplaced\" > genome_sizes.txt";
system($get_size);

open IN,"< genome_sizes.txt ";
open OUT, "> karyotype.txt ";
my $t = 0;
while(<IN>){
        chomp;
        my ($id,$len) = split/\s+/,$_;
        my $c = $t%25+1;
        $t++;
        print OUT "chr\t-\t$id\t$t\t0\t$len\tchr$c\n";
}
close IN;
close OUT;
