#chromosome length
karyotype_deal.pl genome.fa
#gene distribution
awk '$3=="mRNA"' gene.gff | awk '{print $1"\t"$4"\t"$5"\t"$9}' | sort -k 1,1 -k 2n |grep -v "scaffold" > gene_chrom.txt
perl gene_gff_2_input.pl genome_sizes.txt gene_chrom.txt 2000000 > genes_stat.txt
#TE and trf distribution
awk -F "\t" '{print $1"\t"$4"\t"$5"\t"$9}' repeat.gff | awk -F ";" '{print $1}' | grep -v "scaffold" > TE_chrom.txt
perl TE_gff_2_input.pl genome_sizes.txt TE_chrom.txt 2000000 > TE_stat.txt
awk -F "\t" '{print $1"\t"$4"\t"$5"\t"$9}' trf.gff | awk -F ";" '{print $1}' | grep -v "scaffold" > trf_chrom.txt
perl TE_gff_2_input.pl genome_sizes.txt trf_chrom.txt 2000000 > trf_stat.txt
#GC content
perl gc_stat.pl insc.clean.hic.chr17.fa 2000000 | grep -v "scaffold" > gc_stat.txt