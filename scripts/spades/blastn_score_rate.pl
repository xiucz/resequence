#!/usr/bin/perl

use 5.006;
use strict;
use warnings;

my (%data,%hash,%species,$total);
my $len=0;
my $bln_out=shift;
open my $bln_fh,'<',$bln_out or die "Cannot open file:$bln_out $!\n";
open my $w_fh,'>',$bln_out.'.species.xls'or die "Cannot write file:$!\n";
while(<$bln_fh>){
        chomp;
        next if /^Contig_ID/;
        my ($contig,$score,$length,$species)=(split /\t/)[0,5,6,13];
        $species=~s/^\s*//;
        $species=~s/\s*$//;
        $species=~s/\.\s*/./;
#$species=~s/\s+/_/g;
        $data{$species}{score}+=$score if $length >$len;
        $hash{$species}{number}++ unless exists $hash{$species}{$contig};
        $total++ unless exists $species{$contig};
        $species{$contig}=undef;
        $hash{$species}{$contig}=undef;
        # print "$contig,$score,$length,$species\n" if $. <10;
}
# exit;
for my $species(sort {$data{$b}{score} <=> $data{$a}{score}} keys %data){
        print $w_fh $species,"\t",$data{$species}{score},"\t",$hash{$species}{number},"\t",$total,"\n";

}
