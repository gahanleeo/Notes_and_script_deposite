
## 01/24

- Bascilly help Oscar doing genotyping of new list of SNPs  in bunch of sample
- just finished genotyping of pacbio 1000 genome sample and gave to Oscar to phasing it. Also updated the genotpe of Pacbio cell line sample in the master folder  

- Done genotyping of Nethdatl sample,  currently add genotype of chimp and otehr primates from UCSC browser to the table.

- For analysis TERT isofomrs, I generated new gtf file which just fosucs on 2 isofrom with or without exon 7-8, and reanalysis agagin to see if we can gereate result  

- loner TERT repeat, the increase bladder caner; vice versa

-----------


## 01/31


- Got the GTEX sample information and phased SNP around 950 sample:
	sample information: 
	[Donor sample info age sex...](file:/Users/leec20/Desktop/dbGAP_GTEX/sample_info/sample_ifno_donor_detailed/phs000424.v9.pht002742.v9.p2.c1.GTEx_Subject_Phenotypes.GRU.xlsx)
	[Donor sample processing detail](file:/Users/leec20/Desktop/dbGAP_GTEX/sample_info/sample_ifno_donor_detailed/phs000424.v9.pht002743.v9.p2.c1.GTEx_Sample_Attributes.GRU.xlsx)


- Found long-read fasta files sequnence of Primates desposite : GenomeArk

- For TERT isoform analysis, After try a lot of seting, I got MISO running and I'll discuss with Oscar about the output.



- Done add genotype of chimp and otehr primates from UCSC browser to the genotyping of Nethdatl sample table. 
	[result](file://Users/leec20/Desktop/neandertal_bams/TERT_region/updated_snps_neth_0120.csv))





- invasion assay ask

- TERT_R4  3 snps : 
GGA
AGG
AGA
AAA

- TERT_R4 relate to m6A stable RNA 
	- relate to smoke not clear
	- METTL3/METTL14 => writers for metylation
	- knockdonw METTL3 revert the m6A-m6A luc result (to Null-Null site)
	- E-BOX (Enhancer Box) TERT_R4 repeat contains one consensus E-box sequence CANNTG

---

## 02/07

- GTEX project,   combined some donor infromation with genotype result.
	- TRISCHD - Interval between actual death, presumed death, or cross clamp application and the start of the GTEx Procedure (Unit is Minutes).



- NABEC dataset
	-  Downloading and processing RNA-seq bam files that we aleardy know genotype in NABEC
	- NABEC find donor information



---

## 02/14

- For GTEx project
	- downloaded gene TPM and transcripts TPM from GTEx, and trying to combined the files to the manifest file
	
	- They also have each TPM for each TERT isoform, trying to merge all columns to this file



- For NABEC dataset, right now I've made the folder included 14 RNA-seq bam files and README file in T-drvie dbGAP folder.

- Help Oscar if needed

- The long-read primatess fastqs files



---
On-going

- For HiChIP, I've discussed with Mai, and she has a 2 or 3 flowcell kits v3 that I can use for testing my library
	 25M reads per kit . Just one flowcell can run all my 6 library. 
	Currently looking miseq protocol and I Mai and Menal said she'll guide me when i am ready to go to miseq

- Writing material and method of TERT_R2 paper
- 
- Downlaod some sample GTEx tissue sample  to see if is duable

---

- Generate new column of high low indicated the high or low compare mean TPM
- TERT_R4 hotspot for gene fusion breakpoint
- breast cancer,glbolima
---

## 02/22

- For my part of TERT project is focus on GTEx dataset since the dataset have RNA-seq expression of different tissue part and Genotyping of each donor.

- Trying to download other tissues of same donor to see the TERT-expression from dbGAP SRA data

- Based on GTEx TPM plot, first try to download top 4 expression tissue, Tisetis, samll intestine,  Brain Caude , and colon  
- 
https://www.gtexportal.org/home/gene/TERT

- some of them need to download through AWS, trying to follow the online protocol and also mail the SRA team to see if they have instructions
- Cbioprotol?

---

- Cbioprotoal result:
[link](https://www.cbioportal.org/)

- Excel: 
-T-drive: 
[database_TCGA.BLCA_TeILenght_02212023](file:/Volumes/Prokunina/TCGA_data/Data_for_TERT.CLPTM1L_project/database_TCGA.BLCA_TelLenght_02212023.csv)

- **Gtoups selection
	- in "derived_TR2" column
	T2: Long vs short (Long/Long + Long/short vs short/short) 
	
	- in "derived_TR4" column
	T4: **Any** Long vs no long (L/L+M/L+S/L vs M/M + S/M + S/S)


---

## 03/07

For TERT project,

- when I checked again our dpGAP access, I found that we can also donwload TCGA data not only just BLCA,  download the sample which included in that TERT paper to and use my miso setting to check if the MISO result is colse to the paper that published 
- Can also generated this plot using MISO tool for visual


- Oscar selected list of bam files for me to downlad, aroiund 30 samples,  just finished and I try do MISO analysis those  sample, I check 10 reads, only output 16 result, so  use 5 reads as threadhold



**plot all alpha all beta tissue
- 
- alpha -> full length, has 7 8 
- beta -> not include 7 8, SKIP EXONs
- 
- **check the genotype file of these paper tcga files, maybe ICGC? , or have phased vcf ?

- thyoid cancer DCEG dataset
- Glio brain cancer
- **HiChIP stuff


---
### 03/13

- regarding TCGA files, Oscar showed me how the file is located and what script he used. right now just modified script and submitted job on CCAD and will discuss with Oscar the nex step about how to organize the data.

- For HiChIP, discussed with Mai last week, and will do MiSeq this week. reading protocols of how to prepare sample for Miseq 


- chromatin open
- Genotyping
- Bladder somatic mutation

---

### 03/22

- For HiChIP project, I done Miseq of our library wih help of Mai, I tried ran the MAPS pipeline to calculate my library compliexty. 

- For TERT project, currently trying to extract the reads from bam files and genotype in order to phased these 2 SNPs. Since it has too many reads per bam files, around 10000 reads, so Oscar told me the way which randemly subset the reads based on HIsplot of the read size distribution. 

ODDs ratio

- Excel file of Pacbio plates
- Novaseq from CGR
---

### 03/29

- besides parse pipeline and helping Oscar doing SNPs genotype, currenly start genotyping TERT region SNPs in thyroid cancer dataset.


- For HiChIp,
- pipeline did give us some loop calling, but since its shadow seqing it did not provide good resoslutoin of hichip. I'll ask look for how many conc needed for Novaseq and how to submit 



- also got the fastq files and sampe sheet with Kates help, currently run the parse pipeline to generate output file for Seruat.


-cost
novaseq 
- in TCGA dataset,
- TERT exp and activaty
mutation signature, TERT 

----

**04/05**

For TERT project,
- Currently working on genotype new sets of reads selected from Oscar, hope with this new bin method we can catch all the genotype. Also working on throid cancer dataset for additional  SNP genotype, Oscar gave me 12 snps, somehow I only genotype half of them

- For Parse, 
- looking into the potential way for detecting TERT isoform sequence in the single cell data, I found that they have protocol to add custom gene sequence in the reference genome and do analysis again. also for fusion seq

- but TRET maybe 


- Discussed with Wushang about Novaseq cost and currently looking how deep are need for HiChIP

- TCGA datasets


- Tim tomorrow flowcell meeting
- ---

### 04/11 meeting

- TERT project, gave all the genotype result to Oscar, we will have discuss about TCGA dataset tomorrow.

- For CCLE cell line, downloaded 4 cell lines and uploaded to T-drive in the same folder, we now have HCT116, H1299, SK-N-As, Raji cell line. 
- still trying to find other cell line to see of there are different names in CCLE dataset or other dash in between cell names.

-  I got the TERT TPM (log2 based (value +1))of all 9 cell line from CCLE. 
- parse trying to get custom sequence working, tried about did not show up in final output,

---

### 04/20

-  Oscar taught and show me the script of next step of anaylzing TCGA gneoyped data, I am currently organized these scripts and will run through all the cancer type.

- for Burkitt Lymphoma cell, currently downloaded some cell line bam files I  found in GDC CCLE dataset, and will upload to T-drive


- PARSE !?

moving parts to get

New meta-analyisis, mapBC, 

- NCI 7-bridages, dog bladder cancer,circles plot
---

Are you comfortable with ...

dbGAP stuff 

---
### 05/01

- Bascilly been working on TCGA gneoyped data , had to try few times and modifiy some part,  right now is running all the cancer data, will discuss with Oscar once done.
- writing README of Burke's lumopha cell 

Lung cancer
sig 5, 13,

methods may differ

- vatern progrqm, add new 26 SNPs, total around 35 new signals

- A549 Raji
---

### 0509

- for TCGA project, the second part of analysis is mostly done, we have generated map and ped   PLINK like otuput files for each cancer.

- discussed with Oscar for next step, since we focus on 12 SNPs around TERT region, we first check whether these SNPs are present in the map file, and we found 2 of the SNPs are in present in the map file. 

rs401681, rs2736100 are EXIST  

- For other SNPs which are not in the present, currently we are trying to find the proxy SNPs of these snps using LD-proxy tool to find the best R2 proxy SNP exist in the map file. 

--


- Mai is back to office, I'll meet with her this week to show about my resut and how which flow cell I needed for Novaseq.  

- Menal mentined a flowcell called NovaSeq 6000 SP, double check read depth we need. 




T4 G allele -> long T4 -> help immortalized -> more cf event (more DNA loss gain function)


mutation signature 5

T4

go for imputation 

website good for pilot screen.

proteinomic germline data

---

TCGA_BLCA now have around 115 case have WGS bam files, can dowload slice around chr5 region. do some double check vcf file

---

