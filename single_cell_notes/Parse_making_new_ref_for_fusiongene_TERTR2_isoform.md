- How to add sequence in the reference genome? like add GFP or virus sequence
	https://support.parsebiosciences.com/hc/en-us/articles/4403865746196-Adding-Custom-Sequences
	10X cell Ranger also has this tips:
	https://support.10xgenomics.com/single-cell-gene-expression/software/pipelines/latest/using/tutorial_mr


- Finding TERT isofrom minus beta (without exon 7-8) sequence in single cell data,
- add these isofrom cDNA sequence from ensembl to genome, using this parse [support](https://support.parsebiosciences.com/hc/en-us/articles/4403865746196-Adding-Custom-Sequences) to create a new gene to look at.
- old dataset of RT4
---

- Downloaded TERT-201 exon6-9 with /without 78 fasta files
- 


```
echo -e "EGFP\tcustom\tgene\t1\t4813\t.\t+\t.\tgene_id \"id_EGFP\"; gene_name \"EGFP\"; gene_biotype \"protein_coding\";"  

echo -e "EGFP\tcustom\texon\t1\t4813\t.\t+\t.\tgene_id \"id_EGFP\"; gene_name \"EGFP\"; gene_biotype \"protein_coding\";"

---
# for TERT_fake gene, this is according to TERT-201

echo -e "TERT_201_all_EXON_69\tcustom\tgene\t1\t452\t.\t-\t.\tgene_id \"id_TERT_201_all_EXON_69\"; gene_name \"TERT_201_all_EXON_69\"; gene_biotype \"protein_coding\";" 

echo -e "TERT_201_all_EXON_69\tcustom\texon\t1\t452\t.\t-\t.\tgene_id \"id_TERT_201_all_EXON_69\"; gene_name \"TERT_201_all_EXON_69\"; gene_biotype \"protein_coding\";"

======

echo -e "TERT_201_NO_EXON_78\tcustom\tgene\t1\t270\t.\t-\t.\tgene_id \"id_TERT_201_NO_EXON_78\"; gene_name \"TERT_201_NO_EXON_78\"; gene_biotype \"protein_coding\";" 

echo -e "TERT_201_NO_EXON_78\tcustom\texon\t1\t270\t.\t-\t.\tgene_id \"id_TERT_201_NO_EXON_78\"; gene_name \"TERT_201_NO_EXON_78\"; gene_biotype \"protein_coding\";"

=========


echo -e "FGFR3_TACC3_fusion_probe\tcustom\tgene\t1\t207\t.\t+\t.\tgene_id \"id_FGFR3_TACC3_fusion_probe\"; gene_name \"TFGFR3_TACC3_fusion_probe\"; gene_biotype \"protein_coding\";" 


echo -e "FGFR3_TACC3_fusion_probe\tcustom\texon\t1\t207\t.\t+\t.\tgene_id \"id_FGFR3_TACC3_fusion_probe\"; gene_name \"FGFR3_TACC3_fusion_probe\"; gene_biotype \"protein_coding\";"



```



```
tail -n +2 tttttt | tr -cd '[:alnum:][:blank:]' | wc -c
```


---

### Vlnplot cell expression for fusion probe 

![[Pasted image 20230411141103.png]]


- TERT-203 exon 7 is (ENSE00003576607: 1268633 - 1268520), which is same location in TERT-201's exon 9 (ENSE00003621337: 1268633 - 1268520) 






---
## Pasrse+PacBio scRNA-seq

- The method used is from : 
https://genomebiology.biomedcentral.com/articles/10.1186/s13059-021-02505-w#Sec12

### Preprocessing of LR-Split-seq data 

---

## GSE deposite

https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSM5169183



Raw PacBio reads were processed into circular consensus reads using the ccs software from the SMRT analysis software suite (parameters: --skip-polish --min-length = 10 --min-passes = 3 --min-rq = 0.9 --min-snr = 2.5) (https://github.com/PacificBiosciences/ccs). The Split-seq adapters were identified and removed using Lima (v2.0.0) (parameters: --ccs --min-score 0 --min-end-score 0 --min-signal-increase 0 --min-score-lead 0) (https://github.com/pacificbiosciences/barcoding/). Reads were then processed with IsoSeq3’s Refine (v3.4.0) to yield full-length non-chimeric reads (https://github.com/PacificBiosciences/IsoSeq). As around half of our reads are primed using random hexamer priming, polyA tails were not required nor removed for this step.

#maybeCGR_have_done_above


Reads were then demultiplexed for their Split-seq barcodes using a custom script (https://github.com/fairliereese/LR-splitpipe) by first detecting the spacer sequences between barcodes and using these as start and end points for the barcodes. Barcodes were corrected to those that were within an edit distance of 3 of the predetermined list of barcodes used for each round of barcoding.The resultant reads were then filtered on which combinations of barcodes were also seen in the Illumina single-cell/nucleus RNA-seq data, which yielded 567 of the 568 cells that passed QC in the Illumina data. The reads were then trimmed of their barcodes to facilitate mapping, and cell identity barcodes were recorded. 

The reads were mapped using Minimap2 (v2.17-r94) (-ax splice:hq -uf --MD) and the mm10 reference mouse genome, corrected for long-read sequencing artifacts with TranscriptClean ( --canonOnly --primaryOnly). We then used TALON (development branch on GitHub) (--cb) to annotate each read to its transcript or origin using the GENCODE vM21 reference. We filtered for reproducible novel NIC and NNC transcript models for those that were seen in 4 or more sub-cells. Custom LR-Split-seq demultiplexer can be found at (https://www.github.com/fairliereese/LR-splitpipe)



- Trying on Biowulf
	`conda env parse_v104`
	`pip install pip install pandarallel`
	`pip3 install biopython`
	
	
	To excute script:
	`python LR-splitpipe/demultiplex.py`

```


```



------
- 10x use [MARS-seq](https://www.illumina.com/science/sequencing-method-explorer/kits-and-arrays/mars-seq.html) unlike Parse use Split-seq
- [SMART-seq2](https://www.illumina.com/science/sequencing-method-explorer/kits-and-arrays/smart-seq2.html), illumnia
- SMRT-seq2 also can be load into Seurat ..

---
## Nice tutorial about iso-seq 

https://ucdavis-bioinformatics-training.github.io/2020-september-isoseq/liz/bioconda/2-bioconda

**name**: YourSeq  
**location**: chr21:35227100-35227392 (-)  
**score**: 1000.0  
**score**: matches = 293  
mismatches = 0  
repeat matches = 0  
# inserts in query = 0  
# inserts in target = 0  
--------------  
chr21:35227100-35227392


---
## slice bam file in region ex:
  
samtools view MCF7_cDNA_align_genome19_sorted.bam 12:113322231-113501496 -b > OAS1_slice/oas1_mcf7_cDNA_genome.bam

  
## samtools view slice multiple region

[https://www.biostars.org/p/49306/](https://www.biostars.org/p/49306/)
  

### 

samtools view -h MCF7_cDAN_alignNCBIRNA.sorted.bam | fgrep -w -f id.txt| samtools view -bS -o t1.bam


## Minimap2 ex:

### samtools sort can accept sam file as input….###

minimap2 -a -t 20 reference.mmi query.fasta | samtools sort -o output.bam

minimap2 genome.fa - | samtools sort -O BAM -@24 -o alignment.bam -