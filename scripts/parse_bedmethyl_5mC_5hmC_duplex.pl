#!/usr/bin/perl

# Perl script to parse hemi-methylation bedMethyl files producing a tab-delimited file containing % modification for each base modification pattern at each CpG position
# Usage: perl parse_bedmethyl_5mC_5hmC_duplex.pl <input.bed> 

$num_args=$#ARGV+1;
if ($num_args !=1) {
	print "\nUSAGE: perl parse_bedmethyl_5mC_5hmC_duplex.pl <input.bed>\n";
	exit;
}
$input = "$ARGV[0]";
open (INPUT,$input);
$out = substr($input,0,-4)."_out.txt";
open (OUTPUT, ">$out");


print OUTPUT "Chromosome\tStart\tEnd\tModification\tValid_Coverage\tPer_methylation\n";
while ($text=<INPUT>){
	chomp($text);
	@list=split(/\t/,$text);
	($Chromosome, $Start, $End, $mod, $col5, $col6, $col7, $col8, $col9, $col10)=@list;
	@list_col10=split(/ /,$col10);
	($cov,$per)=@list_col10;
	print OUTPUT "$Chromosome\t$Start\t$End\t$mod\t$cov\t$per\n";
}

close (INPUT);
close (OUTPUT);
