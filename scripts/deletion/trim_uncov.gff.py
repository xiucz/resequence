import sys
with open(sys.argv[1]) as f:
        for line in f:
                row = line.strip().split("\t")
                if line[0] == "#":continue
                print "%s\t%s\t%s" %("\t".join(row[3:6]),"\t".join(row[10:12]),"\t".join(row[6:10]))
