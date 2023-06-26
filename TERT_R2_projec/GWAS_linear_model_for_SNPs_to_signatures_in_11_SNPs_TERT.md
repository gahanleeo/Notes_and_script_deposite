
## sigatures/clinical information in T-drvie:


- **Clinical info**
	/Volumes/Prokunina/TCGA_data/TCGA_masterFiles/TCGA_withCancerType_ClinicalData.txt

- **Mutation Sig**
/Volumes/Prokunina/TCGA_data/TCGA_masterFiles/TCGA_withCancerType_MutSignature_OnlyTumor.txt

- **TelomereLength**
/Volumes/Prokunina/TCGA_data/TCGA_masterFiles/TCGA_withCancerType_TelomereLength_OnlyTumor.txt

- **Telomere Score**
/Volumes/Prokunina/TCGA_data/TCGA_masterFiles/TCGA_withCancerType_TLSscore_OnlyTumor.txt

- **TERT_TPM in Tumor**
/Volumes/Prokunina/TCGA_data/TCGA_masterFiles/set.TCGA_GeneExpression.Profile_OnlyTumor_TERT.txt

---

### Nice Tutorial:
https://rstudio-pubs-static.s3.amazonaws.com/349118_7519a1b4bb614cf8bdf18e1698033c2a.html#maf

https://www.biostars.org/p/9https://www.biostars.org/p/9523994/#9524005523994/#9524005

### Steps:

- [script here](file:)


1. Merge all info to TCGA 12 SNPs genotype data
	- data location: [csv file](file:/Volumes/Prokunina/TCGA_data/All_TCGA_SNP.birdseedFiles/projects/chr5_tert_clp/files_of_vcf/phased_chr5_renamed_to_5_liftedto_hg38_imputed_result/All_TCGA.lifted_38.phased4.impute.formatID_haps.11SNP.csv)
	- set correct variable: Age -> factore, Sex -> factor, etc


2. SNPs recode and MAF calculate
	- Reference allele, Alternative allele
		ex: AA=0 AG/GA=1 GG=2 (factor) 
	- MAF, Minor allele frequency "The reference and the alternative. Calculating MAF is essentially counting the presence of the alleles in a population and representing it as a percentage. Each individual can have 0, 1 or 2 times the alternative allele."

3. Scripts in R
	`lm(x~SNP + age + sex)`
	
	`lm(x~SNP)`



![[Screenshot 2023-05-31 at 3.22.25 PM.png]]

- **Explain of summary(lm()) result**
	- Since we are interested in eQTLs our main interest lies in the second line of “Coefficients”. What is stated as “Estimate” is the slope of the linear regression, which in eQTL terms is called “effect size” or already mentioned “beta”.
	-  The common way to identify eQTLs is by their _p-value_. The _p-value_ given here as _(Pr(>|t|))_ will later be referred to as raw _p-value_.


https://feliperego.github.io/blog/2015/10/23/Interpreting-Model-Output-In-R

- example output from Oscar
[example](file:/Volumes/Prokunina/TCGA_data/Data_for_TERT.CLPTM1L_project/resultsLM_SBS_05182023.xlsx)

---
#### MISC
- facing NAN,NA when lm()
https://statisticsglobe.com/r-error-in-lm-fit-na-nan-inf
