#!/usr/bin/perl

use 5.006;
use strict;
use warnings;

my (@samples,$gts,$by_sam,@csq);
my $vcf_file=shift;
open my $vcf_fh,'<',$vcf_file or die "Cannot open file:$vcf_file $!\n";
open my $snv_fh,'>',$vcf_file.".cnv.out" or die "Cannot write file:$!";

while(<$vcf_fh>){
        chomp;
        if (/^#/){
                next unless /ID=EFF/;
                my ($vep_f)=$_=~/ 'Effect \((.+)\)'\s*\">/;
                $vep_f=~s/^\s+//;
                $vep_f=~s/\[.+\]//;
                $vep_f=~s/\s+$//;
                @csq=(split /\s*\|\s*/,$vep_f)[0,1..10];
                print $snv_fh (join("\t",('#Chr','Start','End','Type','RD','P-value','Func_site',@csq[0,5,8])),"\n");
                next;
                }

        my ($chr,$pos,$info)=(split /\t/)[0,1,7];
        my ($end)=$info=~/END=([^;]+);/;
        my ($type)=$info=~/SVTYPE=([^;]+);/;
        my ($rd)=$info=~/natorRD=([^;]+);/;
        my ($p1)=$info=~/natorP1=([^;]+);/;
        my ($vep)=$info=~/EFF=([^;]+)/;
        my @vep=split /,/,$vep;
        for (@vep){
                s/(\|)/$1 /g;
                s/\[.*\]//g;
                }

        for(@vep){
                my ($site_fun,$detail)=($_=~/^(\w+)\((.+)\)/);
                my @csq=(split /\|/,$detail)[0,1..10];
                # $csq[-1]=0 if $csq[-1] eq ' ';

                print $snv_fh join("\t",($chr,$pos,$end,$type,$rd,$p1,
                                $site_fun,@csq[0,5,8])),"\n";
                }
}
