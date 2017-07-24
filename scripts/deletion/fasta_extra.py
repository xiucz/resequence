#-*- coding:UTF-8 -*-
import sys,re

if len(sys.argv) != 3:
        print "#"*50,"\n\n\npython fasta_extra.py fasta list >new.fasta\n\n\n","#"*50

def fastad(file):
        d = {}
        with open(file) as f:
                for line in f:
                        if line[0] == ">":
                                name = re.search('>([\w|\.]+)', line).group(1)
                                d[name] = ""
                        else:
                                d[name] += line
        return d
if __name__ == "__main__":

        FastaDB , TargetList = sys.argv[1:3]
        fad = fastad(FastaDB)

        with open(TargetList) as f:
                for line in f:
                        if line[0] == "#":continue
                        row = line.strip().split("\t")
                        if row[4] != "CDS":continue
                        targetID = re.search(';Dbxref=Genbank:([\w|\.]+),', line).group(1)
                        product = re.search(';product=(.*);protein_id', line).group(1)
                        if targetID in fad:
                                seq = fad[targetID]
                                print ">%s %s\n%s" %(targetID, product, seq) ,
