#!/usr/bin/perl

use 5.006;
use strict;
use warnings;

my @files=@ARGV;
# my @files=<*.scafSeq>;
my (%data);
for my $file(@files){
        open my $fh,'<',$file or die "Cannot open file:$!";
        local $/="\n>";
        my @leng;
        while(<$fh>){
                chomp;
                $_='>'.$_ unless $.==1;
                $_=~s/\n$//;

                $data{$file}{num}++;
                my ($id,$seq)=split /\n/,$_,2;
                $seq=~s/\s//g;
                $seq=uc $seq;
                my $len=length $seq;
                $data{$file}{base}+=$len;
                # $data{$file}{$id}=$len;
                push @leng,($len);
                for my $i(0..$len-1){
                        my $base=substr $seq,$i,1;
                        if($base eq 'A'){
                                        $data{$file}{A}++;
                                }elsif($base eq 'T'){
                                        $data{$file}{T}++;
                                }elsif($base eq 'C'){
                                        $data{$file}{C}++;
                                }elsif($base eq 'G'){
                                        $data{$file}{G}++;
                                }elsif($base eq 'N'){
                                        $data{$file}{N}++;
                                }else{
                                        print $file,"\t",$id," contain non-ACGTN\n";
                                        }
                        }
        }
        close($fh);
        @leng=sort {$b<=>$a} @leng;
        $data{$file}{max}=$leng[0];

        my $total_calc=0;
        my $total=$data{$file}{base};
        $data{$file}{avg}=sprintf "%d",$total/$data{$file}{num};
        $data{$file}{GC}=sprintf "%.2f",100*($data{$file}{G}+$data{$file}{C})/($data{$file}{G}+
                                                                $data{$file}{C}+$data{$file}{A}+$data{$file}{T});
    my $n=exists $data{$file}{N} ?$data{$file}{N}:0;
        $data{$file}{N}=sprintf "%.4f",100*$n/$total;
        for my $long(@leng){
                $total_calc += $long;
                                if($total_calc >= 0.25*$data{$file}{base} ){
                        $data{$file}{N25}=$long unless $data{$file}{N25};
                        }
                if($total_calc >= 0.5*$data{$file}{base} ){
                        $data{$file}{N50}=$long unless $data{$file}{N50};
                        }
                if($total_calc >= 0.75*$data{$file}{base} ){
                        $data{$file}{N75}=$long unless $data{$file}{N75};
                        }
                }
}
open my $w_fh,'>','assembly.stat' or die "Cannot write file:$!";
my $head=join "\t",("Sample Name",'Scaffold Number','Total Base','N25(bp)','N50(bp)',
                        'N75(bp)','Scaffold average length','Max scaffold length','GC(%)','N(%)');
print $w_fh $head,"\n";
for my $file (@files){
        print $w_fh join "\t",($file,$data{$file}{num},$data{$file}{base},$data{$file}{N25},$data{$file}{N50},$data{$file}{N75},
                                $data{$file}{avg},$data{$file}{max},$data{$file}{GC},$data{$file}{N});
        print $w_fh "\n";
        }
