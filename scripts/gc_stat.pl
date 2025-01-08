#!/usr/bin/perl -w

use strict;

my $fasta = shift;
my $windl = shift;

open IN,$fasta;
$/=">";<IN>;$/="\n";
while(<IN>){
        /^(\S+)/ || next;
        my $id = $1;
        $/=">";
        chomp(my $seql = <IN>);
        $/="\n";
        $seql =~ s/\s+//g;
        my $len = length($seql);
        my ($s, $e) = (1, $windl);
        until($len < $windl){
                my $sub_seq = substr($seql,0,$windl);
                substr($seql,0,$windl) = "";
                gc_cacul($sub_seq,$id,$s,$e);#sub1.2
                $s = $e + 1;
                $e += $windl;
                $len -= $windl;
        }
}
close IN;

sub gc_cacul
{
  $_ = shift;
  my ($id,$s,$e) = @_;
  my $gc = (s/[GC]//ig);
  my $at = (s/[AT]//ig);
  my $toal = $gc + $at;
  $toal || return(0);
  $gc = $gc/$toal*100;
  printf("%s\t%d\t%d\t%.4f\n",$id,$s,$e,$gc);
}
