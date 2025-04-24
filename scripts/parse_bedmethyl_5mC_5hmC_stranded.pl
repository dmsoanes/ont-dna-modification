#!/usr/bin/perl

# Perl script to parse bedMethyl files producing two tab-delimited files containing %5mC / %5hmC at each CpG. Each site is seperated by strand.
# Usage: perl parse_bedmethyl_5mC_5hmC.pl <input.bed> 

$num_args=$#ARGV+1;
if ($num_args !=1) {
	print "\nUSAGE: parse_bedmethyl_5mC_5hmC_stranded.pl <input.bed>\n";
	exit;
}
$input = "$ARGV[0]";
open (INPUT,$input);
$outhm = substr($input,0,-4)."_hmC_out.txt";
$outm = substr($input,0,-4)."_mC_out.txt";
open (OUTPUThm, ">$outhm");
open (OUTPUTm, ">$outm");

print OUTPUThm "Chromosome\tStart\tEnd\tStrand\tModification\tValid_Coverage\tPer_hydroxymethylation\n";
print OUTPUTm "Chromosome\tStart\tEnd\tStrand\tModification\tValid_Coverage\tPer_methylation\n";
while ($text=<INPUT>){
	chomp($text);
	@list=split(/\t/,$text);
	($Chromosome, $Start, $End, $mod, $col5, $strand, $col7, $col8, $col9, $col10)=@list;
	@list_col10=split(/ /,$col10);
	($cov,$per)=@list_col10;
	if ($mod eq "h"){
		print OUTPUThm "$Chromosome\t$Start\t$End\t$strand\t$mod\t$cov\t$per\n";
	}
	else {
		print OUTPUTm "$Chromosome\t$Start\t$End\t$strand\t$mod\t$cov\t$per\n";
	}
}

close (INPUT);
close (OUTPUT);
