

- vcftools:
	conda installed
	[documents](https://vcftools.github.io/man_latest.html)
		--SNP or --SNPs can enter rsID to search
		--positions filename ->  Include a set of sites on the basis of a list of positions in a file. Each line of the input file should contain a (tab-separated) chromosome and position. The file can have comment lines that start with a "#", they will be ignored.

https://www.biostars.org/p/212524/

https://bioinformatics.stackexchange.com/questions/3477/how-to-subset-samples-from-a-vcf-file

- Need `--recode` so that it will genertate output...
```
vcftools --vcf chr5.vcf --chr chr5 --from-bp 1253803 --to-bp 1253803 --out 123.txt --recode
```

- Can use list of SNP in txt: (pos.txt, tab-sep)
	chr5 1253803 
	chr5 1272383


```
vcftools --vcf chr5.vcf --positions  pos.txt  --out SNPs_only --recode
```

prefetch --cart ../sample_info/prj257781532.krt --ngc ../ngc_files/prj_25778_D29108.ngc -X 9999999999999

----


subset sample using `bcftools` : 
https://bioinformatics.stackexchange.com/questions/3477/how-to-subset-samples-from-a-vcf-file


### Now is checking sample info to match phenotype

```
paste <(bcftools view SNPs_only.recode.vcf |awk -F"\t" 'BEGIN {print "CHR\tPOS\tID\tREF\tALT"} !/^#/ {print $1"\t"$2"\t"$3"\t"$4"\t"$5}') <(bcftools query -f '[\t%SAMPLE=%GT]\n' SNPs_only.recode.vcf | awk 'BEGIN {print "nHet"} {print gsub(/0\|1|1\|0|0\/1|1\/0/, "")}') <(bcftools query -f '[\t%SAMPLE=%GT]\n' SNPs_only.recode.vcf | awk 'BEGIN {print "nHomAlt"} {print gsub(/1\|1|1\/1/, "")}') <(bcftools query -f '[\t%SAMPLE=%GT]\n' SNPs_only.recode.vcf | awk 'BEGIN {print "nHomRef"} {print gsub(/0\|0|0\/0/, "")}')

```


### Some info about how to interpert vcf file


- [0|0 or 0/0 meaning in genortpe](https://www.biostars.org/p/86321/)
	- The `GT` (genotype) field encodes allele values separated by either of / or |. The allele values are 0 for the reference allele (what is in the REF field), 1 for the first allele listed in ALT, 2 for the second allele list in ALT and so on. For diploid calls examples could be `0/1`, `1|0`, or `1/2`, etc. / indicates an _unphased_ genotype, and | indicates a _phased_ genotype. For phased genotypes, the allele to the left of the bar is haplotype 1, and the allele to the right of the bar is haplotype 2.
	- For example: Ref is AA.
	- 1|1 ==> the sample in the this SNPs is TT where the ref genome in this location is AA. 
	- 0|0 ==> the A SNPs is AA same as ref genome.
	- 1|0 or 0|1 ==> TA or AT in this location
	- phased data `|` seperates the chromoese from father (Patneral) and chromsome from mother (Matneral)
	- Phasing is the process of inferring haplotypes from genotype data. Efficient algorithms and associated software for accurate phasing in pedigrees are needed, especially for populations lacking reference panels of sequenced individuals.
	
	- A **haplotype** refers to **a set of DNA variants along a single chromosome that tend to be inherited together**.



## Subsetting genotype from vcf files to get T_R2/R4 target snp for selecting donor we want 

- Oscar's tips for going through vcf files: 

![[forChiaHan_tips.txt]]

#### [R_scrip](file://Users/leec20/Desktop/scripts/R_scripts/vcfR.R) for vcf analysis using vcfR
- key function in extract GT
```
extract.gt(
  vcf.file.set,
  element = "GT",
  mask = FALSE,
  as.numeric = FALSE,
  return.alleles = TRUE,
  IDtoRowNames = TRUE,
  extract = TRUE,
  convertNA = TRUE
)
```

- extract haplotype
```
vcf_haplotype <- extract.haps(
  vcf.file.set, mask = FALSE, unphased_as_NA = TRUE, verbose = TRUE)
```

