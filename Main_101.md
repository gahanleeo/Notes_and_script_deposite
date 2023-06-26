

### Link to other folder/valut/projects

[[DCEG_bioinfrmatics_course_notes]]

[[Arima_HiChIP project and how to flowcell Miseq]]

[straglr_material_method_draft](file:///Users/leec20/Desktop/markdown_for_straglr_steps)

[Nethandel bams and SNPs scoring](file:///Users/leec20/Desktop/neandertal_bams)

[Animal TERT CLP sequence for TRF folder location](file:////Users/leec20/Desktop/Animals_TERT_CLP)
	[[Animal TERT and CLP fasta for TERT_CLP project]]

[[AWS S3 bucket]]

[TERT_R2_Project](file://Users/leec20/Desktop/straglr_scoring_tool_for_long_read/TERT_repeat_region_projects)

[[MISO TERT and m6A]]

[[dbGAP GTEx and links also CBioProtoal]]

- ---

- MISO gff3 file reoraganize ==> still going
- hump socring: chr5:1,275,210-1,277,496


---

- GTEX bam files accessiable? > first > brain tissue from GTEX.  [[dbGAP GTEx and links also CBioProtoal]]

---

- https://www.biorxiv.org/content/10.1101/2023.01.12.523790v1
---

 methylation calls and (phased) VCFs with variant calls to "/data/KolmogorovLab/CARD/NABEC_asm_v2/vcf_methyl". Methylation calls (one for each phase) are in bed format described here: [https://github.com/epi2me-labs/modbam2bed](https://gcc02.safelinks.protection.outlook.com/?url=https%3A%2F%2Fgithub.com%2Fepi2me-labs%2Fmodbam2bed&data=05%7C01%7Cchiahan.lee%40nih.gov%7Ce06ddb8c9a0a47c3750d08daf99a853c%7C14b77578977342d58507251ca2dc2b06%7C0%7C0%7C638096739296241859%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C3000%7C%7C%7C&sdata=8mdvxhLOOFnzQoWWsGj%2BZDWyASEFSanzSNrUxwGV770%3D&reserved=0 "Original URL:
https://github.com/epi2me-labs/modbam2bed
Click to follow link."). The phases for VCFs and BEDs should correspond to each other. They may be different compared to assemblies though (e.g. HP1 and HP2 may switch). These are against grch38.

---

## install R quickly
https://www.r-bloggers.com/2017/07/quick-way-of-installing-all-your-old-r-libraries-on-a-new-device/

platform       x86_64-apple-darwin17.0     
arch           x86_64                      
os             darwin17.0                  
system         x86_64, darwin17.0          
status                                     
major          4                           
minor          1.2                         
year           2021                        
month          11                          
day            01                          
svn rev        81115                       
language       R                           
version.string R version 4.1.2 (2021-11-01)
nickname       Bird Hippie   

----
## Aks ChatGPT section:

- [Main link](https://chat.openai.com/chat)
---

**When text transfer between linux and PC, sometimes will have "^M" in the end text
how to deal with this?**

suse.com/support/kb/doc/?id=000018317#:~:text=To%20enter%20the%20%5EM%20character,M%20at%20the%20same%20time

- to show ^M in the text: 
```
cat -v textfile
```
- to remove 
```
sed -e "s/\r//g" file > newfile
```

---
-[ the Biowulf user job dashbaord for checking job running](https://auth.nih.gov/CertAuthV3/forms/mfa/Signin_AuthApp.aspx?TYPE=33554433&REALMOID=06-a79b1fbe-ad62-4a76-9a18-ff7aea9ff3ed&GUID=&SMAUTHREASON=0&METHOD=GET&SMAGENTNAME=-SM-11Ey3xXHozFUjVUa8ZRRFmE7UrTuF35n7wjMbqaoNyqme%2f428bGHwvvcp3cU%2bcNI&TARGET=-SM-https%3a%2f%2fhpcnihapps%2ecit%2enih%2egov%2fauth%2fdashboard%2f)

---

**- in Rstudio, how to add "#" all at once in multiple line**

To add "#" all at once in multiple lines in RStudio, you can use the following steps:

1.  Select the lines of code that you want to comment out with the "#" symbol.
2.  Press the "Ctrl" key and the "Shift" key together.
3.  Press the key "C" to comment out the selected lines with the "#" symbol.

Alternatively, you can also use the keyboard shortcut "Ctrl + Shift + C" to comment out the selected lines with the "#" symbol. This shortcut works regardless of whether the cursor is at the beginning or end of the lines you want to comment out.

---
### Polygenic risk score (PRS)

- Trans-assiciations drive regulatory networks
- Polygenic risk score provdes ..
- Standard appoach has low power
- PRS is bettter
- tool called ARCHIE https://github.com/diptavo/ARCHIE
- cis-eqtl vs trans-eqtl
	
	In the context of GWAS (Genome-wide association studies), eQTL (Expression quantitative trait loci) analysis is a technique that links genetic variation with gene expression levels. This can help identify regions of the genome that influence the expression of specific genes.
	
	Cis-eQTLs and trans-eQTLs refer to the location of the genetic variation in relation to the gene whose expression it affects. 
	
	- A cis-eQTL is a genetic variation that influences gene expression levels within the same chromosome region, typically within 1 megabase of the gene's location. 
	- A trans-eQTL is a genetic variation that affects gene expression levels located further away from the gene's location, on different chromosomes.
	
	Cis-eQTLs are more common and easier to detect than trans-eQTLs because they have a stronger effect on gene expression. In contrast, trans-eQTLs have weaker effects on gene expression, which makes them harder to identify. However, trans-eQTLs are still important because they can provide insights into the regulatory networks that control gene expression. 
	
	Overall, both cis-eQTL and trans-eQTL analyses can be used to identify genetic variants that contribute to complex traits and diseases and help us understand the mechanisms underlying their development.

- proteomic mediation of gene risk of cancers.
- ARIC dataset, 8886 EUR, 2871 AFR

- Major of PRS and ARCHIE is to get useful info from trans-eQTL and give you a geneset
- trans-eQTL more tissue/cell specific
---
### R script in open.table()
	use `fill=T` if there are unequal columns in dataset

**replace NA or empty string with 0**
	`ped <- replace(ped, is.na(ped) | ped == "", 0)`

---
## nice plot 
![[Screenshot 2023-05-09 at 4.28.14 PM.png]]


### DCEG seminar

**GrafPop: A Novel Approach Able to Quickly and Robustly Infer Genetic**
	- PCA scoring have limitiatoin in GWAS study
	- The GRAF-pop algorithm is more cool
	- recently upgraded in a seprated software GrafPop using ~100,000 SNPs selected for ancestry inference
	- updated called GrafPop 
	- https://github.com/ncbi/graf
	- GD score is more accurate 

---
Olivia Lee, B.S

---
![[Screenshot 2023-06-13 at 11.03.32 AM.png]]
- RNA mining
- recent release ARCGS4
- API in pythoon package
- ![[Screenshot 2023-06-13 at 11.19.03 AM.png]]![[Screenshot 2023-06-13 at 11.25.08 AM.png]]
generanger
targetranger
https://generanger.maayanlab.cloud/gene/A2M?database=ARCHS4
https://targetranger.maayanlab.cloud/
![[Screenshot 2023-06-13 at 11.35.52 AM.png]]


BRCA BLCA


  "TCGA-ACC"  "TCGA-CESC" "TCGA-CHOL" "TCGA-COAD" "TCGA-DLBC" "TCGA-ESCA" "TCGA-GBM"  "TCGA-HNSC" "TCGA-KICH"
 "TCGA-KIRC" "TCGA-KIRP"
 
---

`TCGA-EA-A3HQ-10A_wxs_hg38.bam': No such file or directory

mv: cannot stat `TCGA-C5-A1MP-10A_wxs_hg38.bam': No such file or directory

mv: cannot stat `TCGA-FU-A3TX-10A_wxs_hg38.bam': No such file or directory