import sys
with open(sys.argv[1]) as f:
        for line in f:
                row = line.strip().split("\t")
                if line[0] == "#":continue
                print "%s\t%s\t%s" %(row[0],"\t".join(row[3:]),"\t".join(row[1:3]))
