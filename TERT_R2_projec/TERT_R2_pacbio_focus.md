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
- [newer version after Oscar select](file:/Users/leec20/Desktop/scripts/Linux_scripts/making_bam_by_eachid_T2.sh)
- [after genotyping, to merge read id copy number with SNP result](file://Users/leec20/Desktop/TR2_cellline_snps/combine_straglr_tsv_res_to_igvtool_SNPs_genotyped.R)

---
## since the bam files have too many reads (~10000)
- using samtools -s to subsampling to 50% or 30% read
```
samtools view -b -s 0.025 0011-4385-8_bc1008_M13F--bc1061_M13R.bam > half.bam
```
`-s 0.5 is 50%`

----
- **Methods**

In order to investigate the potential association between two target SNP genotypes and copy number in PacBio target PCR data, we utilized the straglr tool to calculate the TERT repeat 2 repeat size for each individual sample.

We then established a set of 10 bins, ranging from sizes 20 to 70, as TERT Repeat2 is predominantly found within this range. Within these bin sizes, we extracted approximately 10 reads per bin for each sample, which were subsequently utilized to genotype the target SNPs. Upon completion, we aggregated all the data and linked the read IDs to the genotype with repeat size. 

Overall, this approach enabled us to effectively capture the potential relationship between the target SNP genotypes and copy number in the PacBio target PCR data.