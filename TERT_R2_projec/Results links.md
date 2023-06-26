### link of TERT target SNPs with GTEX id

[result_link](file:/Users/leec20/Desktop/dbGAP_GTEX_and_other_dataset/GTEX_v9/subset_snps_output)

## link of dbGAP NABEC Brain sample 

- [manifest folder](file:/Users/leec20/Desktop/dbGAP_GTEX_and_other_dataset/NABEC_brain_dataset)
- [patient_info](file:/Users/leec20/Desktop/dbGAP_GTEX_and_other_dataset/NABEC_brain_dataset/ALL_text_data/phs001300/phs001300.v3.pht006722.v2.p1.c1.NABEC_Subject_Phenotypes.GRU_RACE_AGE.txt)
-  [SRR_manifest](file:/Users/leec20/Desktop/dbGAP_GTEX_and_other_dataset/NABEC_brain_dataset/NABEC_SRA_manifest.xlsx) has some tissue/sex info


---

ID column B , C 

filter donor column P with bam file, remove duplicate bsed on AJ

reshape2 

row name is ID,  body part as column 

- Goal is to combine id with SNP, tissue, age, sex , cause of death, race
----
- Get RNA bam files from NABEC we aleardy know in dbGAP
- NABEC find donor information


SH-04-08
SH-04-21
SH-05-10
SH-06-05
SH-06-25
SH-06-66
SH-07-28
SH-07-37
SH-07-46
SH-07-63
SH-08-04
SH-92-05
SH-92-14
SH-98-23

/data/leec20/blat_test/human_tert_gene
/data/leec20/blat_test/blat_res
/data/leec20/mGorGor1.dip.2022_T2T.fas
-minIdentity=100


---

samtools view ${i} chr5:1211692-1371119 -b > out.bam