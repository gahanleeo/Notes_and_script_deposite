- to do
	- straglr
	- genotyping 2 SNPs: rs56345976, rs33961405
	- per id


- script I need:
	- get bam id and seq to make fasta


```
for i in *.bam
do
ff=`echo $i | sed 's/.bam//'`
samtools view ${i} | awk '{print ">"$1 "\t" $10}' |sort | uniq | tr '\t' '\n' > ../fasta_files/${ff}_fasta.txt
done
```

-  [making bam by read id for genotyping](file:/Users/leec20/Desktop/straglr_scoring_tool_for_long_read/TERT_repeat_region_projects/making_bam_by_each_readid.sh)

- [after genotyping, to merge read id copy number with SNP result](file://Users/leec20/Desktop/TR2_cellline_snps/combine_straglr_tsv_res_to_igvtool_SNPs_genotyped.R)

---
## since the bam files have too many reads (~10000)
- using samtools -s to subsampling to 50% or 30% read
```
samtools view -b -s 0.025 0011-4385-8_bc1008_M13F--bc1061_M13R.bam > half.bam
```
`-s 0.5 is 50%`

