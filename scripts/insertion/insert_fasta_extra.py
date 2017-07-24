#-*- coding:UTF-8 -*-
import sys,re

if len(sys.argv) != 3:
        print "#"*50,"\n\n\npython fasta_extra.py fasta list >new.fasta\n\n\n","#"*50

def fastad(file):
        d = {}
        with open(file) as f:
                for line in f:
                        if line[0] == ">":
                                name = re.search('>([\d_]+)', line).group(1)
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
                        targetID = re.search('ID=([\d_]+);', line).group(1)
                        product = re.search(';product=(.*)', line).group(1)
                        if targetID == "": continue
                        if targetID in fad:
                                seq = fad[targetID]
                                print ">%s %s\n%s" %(targetID, product, seq) ,
