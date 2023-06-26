
### compare to Michigan imputation server:
https://imputationserver.sph.umich.edu/index.html#!pages/home
https://github.com/genepi/imputationserver


Upload the vcg.gz of `5_renamed_to_chr_lifted_hg38_vcf` 

Notes:
- only 3 job at once
- Parameter selection
	Genotype Imputation (Minimac4)
	1000 phased 30X hg38
	array build hg38
	rsq filter off
	Eagle V2.4
	Pop: All
	Quality Control & Imputation
	select Generate Meta file

### API of M imputation server
https://imputationbot.readthedocs.io/en/latest/


```
./imputationbot qc --refpanel 1000g-phase3-deep --population all  --meta yes --build hg38  --file /Volumes/Prokunina/TCGA_data/All_TCGA_SNP.birdseedFiles/projects/chr5_tert_clp/files_of_vcf/5_renamed_to_chr_lifted_hg38_vcf/set_TCGA_LUAD.rename.lifted.vcf.gz


```
---
### Since some vcf file have error like chunk stuff

- use data paration on document to see if we can get that running
- LUAD PED/MAP files as start 
- folder location: /DCEG/Branches/LTG/Prokunina/TCGA_data/All_TCGA_SNP.birdseedFiles/projects/chr5_tert_clp/Michigan_impute_tools_check


```

module load plink2/1.90b5

module load tabix/1.9

module load bcftools/1.9b
```


## command according to document

### Convert ped/map to bed

```
plink --file <input-file> --make-bed --out <output-file>
```

### Create a frequency file

```
plink --freq --bfile <input> --out <freq-file>
```

### Execute script

```
perl HRC-1000G-check-bim.pl -b LUAD.bim -f LUAD.frq -r 1000GP_Phase3_combined.legend -g
sh Run-plink.sh

# probably try Sanger one to see



```

- The output will have xxx.vcf file,

- and  from hg19, lift to hg38,
```

module load plink2/1.90b5  
module load bcftools/1.9b  
module load jdk/15  
module load picard/2.21.1  
module load tabix/1.9


#liftover from hg19 to hg38  
# reject file need end with .vcf

picard LiftoverVcf \  
I=myFile_rename.vcf.gz \  
O=myFile_rename.lifted.vcf \  
CHAIN=liftoverFiles/hg19ToHg38.over.chain.gz \  
REJECT=liftoverFiles/rejected_variants.vcf \  
R=liftoverFiles/chr5.fa.gz \  
RECOVER_SWAPPED_REF_ALT=true

bgzip -c myFile_rename.lifted.vcf > myFile_rename.lifted.vcf.gz

tabix -p vcf myFile_rename.lifted.vcf.gz

```


### Other way ot filter bad calling

- What are chunks in MServer? ==> 20MB, 20,000,000bp
- `Mind` and `geno` in plink
- https://www.cog-genomics.org/plink/1.9/filter
 ![[Screenshot 2023-05-25 at 1.45.04 PM.png]]

**Remove sample with bad SNP calling (<50%) for MServer to impute**  

```
module: plink2/1.90b5

# vcf is unphased and aleardy lifted to 38

plink --vcf yourFile.vcf.gz --mind 0.5 --recode vcf-iid --out howeverYouWantToNameIt

bgzip -c howeverYouWantToNameIt.vcf > howeverYouWantToNameIt.vcf.gz

# rename to chr5 as MServer need "chr"

bcftools annotate --rename-chrs ../files_of_vcf/chr_name_mapping_5-chr5.txt set2_luad.vcf.gz -Oz -o set2_luad_chr5.vcf.gz

tabix -p vcf set2_luad_chr5.vcf.gz


```

```

plink --vcf yourFile.vcf.gz --geno 0.1 --recode vcf-iid --out howeverYouWantToNameIt
# geno 0.1 means include only SNPs with a 90% genotyping rate (10% missing)

```