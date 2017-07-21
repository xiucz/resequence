#!/usr/bin/perl

use strict;
use warnings;

my $file=shift;
my $lim=shift;
my $cov_lim=shift;
open my $fh,'<',$file  or die "Cannot open file  $file :$! \n";
open my $w_fh,'>',$file.'.fas' or die "Cannot write file : $! \n ";
open my $wf_fh,'>',$file.'.filtered.fas' or die "Cannot write file : $! \n ";
my @aux = undef;
my ($n,$score,$t_base,$f_n,$f_score,$ft_base,$n_n,$n_score,$n_base);
while (my ($name, $seq) = readfq(\*$fh, \@aux)) {
        my $slen= 0;
        ++$n;
        my $seqf;
        $seq=~s/\s//g;
        $slen += length($seq);
        my($cov)=(split /_/,$name)[5];
        $t_base+=$slen;
        $score+=$slen*$cov;
}
close($fh);
my $avf_score=sprintf "%.2f",$score/$t_base;
$cov_lim=$cov_lim?$cov_lim:int(0.1*$avf_score+0.5);
open $fh,  '<',  $file  or die "Cannot open file  $file :$! \n";
@aux = undef;
while (my ($name, $seq) = readfq(\*$fh, \@aux) ) {
        my $slen= 0;
        my $seqf;
        $seq=~s/\s//g;
        $slen += length($seq);
        my($cov)=(split /_/,$name)[5];
        my $id=$name;
        $id=~s/_ID_\d+$//;
        for (my $i=0;$i<$slen;$i+=70){
                        $seqf.= substr($seq,$i ,70)."\n";
                }
        if($slen < $lim or $cov < $cov_lim){
                # $n_n,$n_score,$n_base   
                $n_n++;
                $n_base+=$slen;
                $n_score+=$slen*$cov;
                print $wf_fh  join("\n",'>'.$id,$seqf);
                }else{
                     $ft_base+=$slen;
                     $f_score+=$slen*$cov;
                     $f_n++;
                     print $w_fh  join("\n",  '>'.$id,$seqf);
                }
}
my $avs_score=sprintf "%.2f",$f_score/$ft_base;
my $avn_score=sprintf "%.2f",$n_score/$n_base;

print "\t$file Coverage limit is $cov_lim.\n\tLength limit is $lim.\n";
print "\t$file contains $n scaffolds,Total bases is $t_base, Average coverage is $avf_score.\n";
print "\t$file contains $f_n scaffolds,Total bases is $ft_base, Average coverage is $avs_score.\n";
print "\t$file filters $n_n scaffolds,Filtered Length is ",(sprintf "%.2f",$n_base/$n_n),", Average coverage is $avn_score.\n";
sub readfq {
        my ($fh, $aux) = @_;
        @$aux = [undef, 0] if (!@$aux);
        return if ($aux->[1]);
        if (!defined($aux->[0])) {
                while (<$fh>) {
                        chomp;
                        if (substr($_, 0, 1) eq '>' || substr($_, 0, 1) eq '@') {
                                $aux->[0] = $_;
                                last;
                        }
                }
                if (!defined($aux->[0])) {
                        $aux->[1] = 1;
                        return;
                }
        }
        my $name = /^.(.+)$/? $1 : '';
        my $seq = '';
        my $c;
        $aux->[0] = undef;
        while (<$fh>) {
                chomp;
                $c = substr($_, 0, 1);
                last if ($c eq '>' || $c eq '@' || $c eq '+');
                $seq .= $_;
        }
        $aux->[0] = $_;
        $aux->[1] = 1 if (!defined($aux->[0]));
        return ($name, $seq) if ($c ne '+');
        my $qual = '';
        while (<$fh>) {
                chomp;
                $qual .= $_;
                if (length($qual) >= length($seq)) {
                        $aux->[0] = undef;
                        return ($name, $seq, $qual);
                }
        }
        $aux->[1] = 1;
        return ($name, $seq);
}
