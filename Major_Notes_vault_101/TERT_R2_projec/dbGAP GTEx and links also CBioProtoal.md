
#### links of dbGAP location:
- https://dbgap.ncbi.nlm.nih.gov/aa/wga.cgi?page=list_wishlists
	"25778 Expression analysis of genes identified by GWAS"  <- located GTEx bams 
- https://dbgap.ncbi.nlm.nih.gov/aa/wga.cgi?page=request_details_pi&arid=551314&filter=arid
	NABEC: North American Brain Expression Consortium

#### links to the all GTEX SRA manifest excel files:
- [GTEX_SRA_manifest](file:/Users/leec20/Desktop/dbGAP_GTEX_and_other_dataset/GTEX_v9/GTEx_TPM_merged_SNPs.xlsx)
- [GTEX_geno_pheno_type_manifest](file://Users/leec20/Desktop/dbGAP_GTEX/GTEX_v9/geno_pheno_GTEXdbgap_manifest.xlsx)

---
# GTEx RNA-seq, remove duplicates, pipeline 
- https://github.com/broadinstitute/gtex-pipeline/blob/master/TOPMed_RNAseq_pipeline.md
```
STAR --runMode alignReads \
    --runThreadN 8\
    --genomeDir ${star_index} \
    --twopassMode Basic \
    --outFilterMultimapNmax 20 \
    --alignSJoverhangMin 8 \
    --alignSJDBoverhangMin 1 \
    --outFilterMismatchNmax 999 \
    --outFilterMismatchNoverLmax 0.1 \
    --alignIntronMin 20 \
    --alignIntronMax 1000000 \
    --alignMatesGapMax 1000000 \
    --outFilterType BySJout \
    --outFilterScoreMinOverLread 0.33 \
    --outFilterMatchNminOverLread 0.33 \
    --limitSjdbInsertNsj 1200000 \
    --readFilesIn ${fastq1} ${fastq2} \
    --readFilesCommand zcat \
    --outFileNamePrefix ${sample_id} \
    --outSAMstrandField intronMotif \
    --outFilterIntronMotifs None \
    --alignSoftClipAtReferenceEnds Yes \
    --quantMode TranscriptomeSAM GeneCounts \
    --outSAMtype BAM Unsorted \
    --outSAMunmapped Within \
    --genomeLoad NoSharedMemory \
    --chimSegmentMin 15 \
    --chimJunctionOverhangMin 15 \
    --chimOutType Junctions WithinBAM SoftClip \
    --chimMainSegmentMultNmax 1 \
    --outSAMattributes NH HI AS nM NM ch \
    --outSAMattrRGline ID:rg1 SM:sm1
```
- Align fastqs downloaded from SRA to hg38 according to the parameter provieded in GTEx github. 
- the BAM files were renamed according to the corresponding donor ID and indexed using Samtools.

---

# Genotpye of all GTEX sample and donor information:

-   file downloaded: [phased_snps_hg38_vcf_file](file://Users/leec20/Desktop/dbGAP_GTEX/phg001796.v1.GTEx_v9_WGS_phased)
-  GTEX file name: phg001796.v1.GTEx_v9_WGS_phased.genotype-calls-vcf.c1.GRU.tar
- sample information: 
	[Donor sample info age sex...](file:/Users/leec20/Desktop/dbGAP_GTEX_and_other_dataset/GTEX_v9/sample_info/sample_ifno_donor_detailed/phs000424.v9.pht002742.v9.p2.c1.GTEx_Subject_Phenotypes.GRU.xlsx)
	[Donor sample processing detail](file:/Users/leec20/Desktop/dbGAP_GTEX_and_other_dataset/GTEX_v9/sample_info/sample_ifno_donor_detailed/phs000424.v9.pht002743.v9.p2.c1.GTEx_Sample_Attributes.GRU.xlsx)
	- The column code explain: https://www.ncbi.nlm.nih.gov/projects/gap/cgi-bin/dataset.cgi?study_id=phs000424.v8.p2&pht=2742

- https://www.nature.com/articles/s41467-017-02772-x#Sec8  - Sample Ischemic time
TRISCHD - Interval between actual death, presumed death, or cross clamp application and the start of the GTEx Procedure (Unit is Minutes).

---

- [combined SNPs with donor info and tissue](file://Users/leec20/Desktop/dbGAP_GTEX_and_other_dataset/GTEX_v9/set1_cb_SNPs_with_donor_info.txt)

---

### TERT_TPM from GTEX

- the file is gct format
- skip 2 header, and get the header:
`cat xxx.tpm.txt | awk 'FNR >2 {print $0}' | head -n1`

`cat GTEx_Analysis_2017-06-05_v8_RSEMv1.3.0_transcript_tpm.gct | awk 'FNR >2 {print $1 "\t" $2}'| head | grep "ENSG00000000003"`

ENSG00000000457
- The other way is using `awk`, the `~` means partialy match
```
cat tttt | awk '$2 ~ /ENSG00000000457/'
```

tisuue_bam
tissue_tert_isofom
tussue_tert_TPM

### GTEX cram files to bam files
```
samtools view -bh -T ref.fa -o sample.bam sample.cram
```




## TERT T2/T4 long vs short  in CbioProtoal 

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
### Make Susimi plot for GTEx tissue bam files I downloaded in same donor

- per tissue
- per donor

