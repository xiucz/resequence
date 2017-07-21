import sys,glob,re

files=glob.glob("*.anno.sv.vcf")


def info(file):
    f=open(file)
    fname = file.split(".vcf")[0].split(".")[0]
    name = file.split(".vcf")[0]
    w=open("%s.xls" %(name),'w')
    w.write("#CHROM\tStart\tEnd\tREF\tALT\tSVLEN\tSV_TYPE\tMINTIPQ\tFunc_site\tEffect_Impact\tFunctional_Class\tCodon_Change\tAmino_Acid_Change\tGene_Name\tTranscript_ID\tGenotype_Number\n")
    for line in f:
        row=line.strip().split("\t")
        if line[0]=="#":continue
        CHROM = row[0]
        start = row[1]
        end = re.findall('END=(\d+)', row[7])
        end1 = "".join(end)
        ref = row[3]
        alt = row[4]
        svlen = re.findall('SVLEN=(\d+)', row[7])
        svlen1 = "".join(svlen)
        svtype = re.findall('SVTYPE=(\w+);', row[7])
        svtype1 = "".join(svtype)
        mintipq = re.search('MINTIPQ=(\d+)', row[7]).group(1)
        if row[6] == "LowSupp": continue
        format=row[7].split("EFF=")[1].split(",")
#        if svtype1 == "COMPLEX": continue
        for i in range(len(format)):
            if i < 10:
                func_site = format[i].split("|")[0].split("(")[0]
                effect_impact = format[i].split("|")[0].split("(")[1]
                functional_class = format[i].split("|")[1]
                codon_change = format[i].split("|")[2]
                aa_change = format[i].split("|")[3]
#            aa_length = format[i].split("|")[4]
                gene_name = format[i].split("|")[5]
#            transcript_bioType = format[i].split("|")[6]
#            gene_coding = format[i].split("|")[7]
                transcript_id = format[i].split("|")[8]
#            exon_rank = format[i].split("|")[9]
                genotype_number = format[i].split("|")[10].split(")")[0]
                w.write(CHROM+"\t"+start+"\t"+end1+"\t"+ref+"\t"+alt+"\t"+svlen1+"\t"+svtype1+"\t "+mintipq+"\t"+func_site+"\t"+effect_impact+"\t"+functional_class+"\t"+codon_change+"\t"+aa_change+"\t"+gene_name+"\t"+transcript_id+"\t"+genotype_number+"\n")
    w.close()
    f.close()
