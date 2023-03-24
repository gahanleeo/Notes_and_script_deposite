
### TERT Ensembl link
https://useast.ensembl.org/Homo_sapiens/Gene/Summary?g=ENSG00000164362;r=5:1253147-1295068

- Export data (gff3) from link:
 [Link](https://useast.ensembl.org/Homo_sapiens/Export/Output/Gene?db=core;flank3_display=0;flank5_display=0;g=ENSG00000164362;output=gff3;r=5:1253147-1295068;strand=feature;param=gene;param=transcript;param=exon;param=cds;_format=Text)

- from Exon6 to Exon 9
- [Exons id and region]( https://useast.ensembl.org/Homo_sapiens/Transcript/Exons?db=core;g=ENSG00000164362;r=5:1253167-1295068;t=ENST00000310581)

#### Making fake tert  <---

- the fake gff3, called: tert_modified_exon_6_to_9_ver4.gff3
```
##gff-version 3
##sequence-region chr5 1 181538259
chr5	Ensembl	gene	1268520	1278796	.	-	.	ID=TERT_fake;Name=TERT_fake
chr5	Ensembl	mRNA	1268520	1278796	.	-	.	ID=TERT_incl_exon78;Parent=TERT_fake
chr5	Ensembl	mRNA	1268520	1278796	.	-	.	ID=TERT_NO_78;Parent=TERT_fake
chr5	Ensembl	exon	1278641	1278796	.	-	.	ID=TERT_Exon6;Parent=TERT_incl_exon78
chr5	Ensembl	exon	1272185	1272280	.	-	.	ID=TERT_Exon7;Parent=TERT_incl_exon78
chr5	Ensembl	exon	1271119	1271204	.	-	.	ID=TERT_Exon8;Parent=TERT_incl_exon78
chr5	Ensembl	exon	1268520	1268633	.	-	.	ID=TERT_Exon9;Parent=TERT_incl_exon78
chr5	Ensembl	exon	1278641	1278796	.	-	.	ID=TERT_NO_78_Exon6;Parent=TERT_NO_78
chr5	Ensembl	exon	1268520	1268633	.	-	.	ID=TERT_NO_78_Exon9;Parent=TERT_NO_78
```

- MISO setting files: # setting file for miso analysis
	-using 10 read to test since 20 reads is hard to find anything

```

[data]

filter_results = True

min_event_reads = 10

  

[cluster]

cluster_command = qsub

  

[sampler]

burn_in = 500

lag = 10

num_iters = 5000

num_processors = 4

```

---

- ## tert link with m6A

- Finding potential Enhancer region using this seq 

- Forward:
- ATGGGCAACCGGCGCAGCTGTGGCTATAGAAAGAGCAAACATTCAGGAGCAAGCTCAAGTGAG

reverse: 
- GGACCACGCCTCACTCCCTGCATAA

Tool: mosdepth to get read coverage of this two sites 
	https://github.com/brentp/mosdepth
	https://hpc.nih.gov/apps/mosdepth.html

Comm:
```
mosdepth --by capture.bed sample-output sample.exome.bam
```

File: TCGA-BLCA RNA-Seq bam files (hg38)

[Result](file:/Users/leec20/Desktop/MISO_Oscar_TCGA/mosdepth_for_TCGA_EBOX/TCGA_BLCA_all_ebox_score.csv)

---
## There's paper with gff file attached:

[folder location](file://Users/leec20/Desktop/MISO_Oscar_TCGA/paper_exmple)

#### for QC 

- Taraget TCGA ID: (in hg38, not hg19 from paper)
	TCGA-A3-3378-01
	TCGA-2G-AAL7-01
	TCGA-AR-A251-01
	
	TCGA-ZJ-AAXN-01
	TCGA-HN-A2NL-01
	TCGA-91-A4BC-01
	
	TCGA-HU-8604-01
	TCGA-V5-A7RE-01
	TCGA-OL-A5D7-01

- **Downloading** using TCGA API:
[[TCGA bam file slicing using API]]

```
token=$(<gdc-user-token.2022-03-09T17_15_08.189Z.txt)
```

```
curl --header "X-Auth-Token: $token" "https://api.gdc.cancer.gov/slicing/view/46cb6e52-d406-4827-b243-44fa8463653c?region=chr5:10000-4840000" --output ./TCGA-OL-A5D7-01A.chr5.bam
```


---

**Since the bams files may have different read-length, using samtools to define read-len

```

for i in *.bam
do
ff=`echo $i | sed 's/.chr5.bam//'`
echo "start ${i}"
len=`samtools view ${i} | awk '{print length($10)}' | sort | uniq`
miso --run ../index_69/ ${i} --settings-filename ../miso_setting.txt --read-len ${len} --output-dir ../OUT_ver4_QC_tcga/${ff} 

done


```

- the output similiar with paper sup fig6

![[Screenshot 2023-03-02 at 12.05.13 PM.png|500]]

- MISO score from our gff file
![[Screenshot 2023-03-02 at 12.06.48 PM.png|400]]

- Shamiplot from these hg38 bams

![[Screenshot 2023-03-02 at 12.15.23 PM.png]]

---
plotting MISO 
- setting file:
	the Y-asix can be adjust according to FPKM
	for read coverage, use samtools
	`samtools flagstat example.bam | awk 'NR==1{print $1}'`
	`samtools view -c -F 4 GTEX-WFG7-1326-SM-4LMK1.test.bam`
	
	
```
[data]
# directory where BAM files are
bam_prefix = /data/leec20/MISO/bam_QC_TCGA
# directory where MISO output is
miso_prefix = /data/leec20/MISO/OUT_ver4_QC_tcga

bam_files = [
    "TCGA-2G-AAL7-01A.chr5.bam",
    "TCGA-A3-3378-01A.chr5.bam",
    "TCGA-AR-A251-01A.chr5.bam"]

miso_files = [
    "TCGA-2G-AAL7-01A",
    "TCGA-A3-3378-01A",
    "TCGA-AR-A251-01A"]

[plotting]
# Dimensions of figure to be plotted (in inches)
fig_width = 7
fig_height = 5
# Factor to scale down introns and exons by
intron_scale = 30
exon_scale = 4
# Whether to use a log scale or not when plotting
logged = True
font_size = 6

# Max y-axis
ymax = 8

# Whether to plot posterior distributions inferred by MISO
show_posteriors = True

# Whether to show posterior distributions as bar summaries
bar_posteriors = False

# Whether to plot the number of reads in each junction
number_junctions = True

resolution = .5
posterior_bins = 40
gene_posterior_ratio = 5

# List of colors for read denisites of each sample
colors = [
    "#CC0011",
    "#CC0011",
    "#FF8800"]

# Number of mapped reads in each sample
# (Used to normalize the read density for RPKM calculation)
coverages = [107077,236516,274905]

# Bar color for Bayes factor distribution
# plots (--plot-bf-dist)
# Paint them blue
bar_color = "b"

# Bayes factors thresholds to use for --plot-bf-dist
bf_thresholds = [0, 1, 2, 5, 10, 20]

```

- plot command
	
```
# command need:

# TERT_fake is from gnen ID in gff3 file 
# index location
# setting text file show above
# output

sashimi_plot --plot-event "TERT_fake" /data/leec20/MISO/index_69/ sashimi_plot_settings.txt --output-dir ./testplot
```


read covarage probably need to consider

- check sample with output

- read cov >15 
- --
- Pair end is trouble..
```
java -Xmx4g -XX:ParallelGCThreads=5 -jar $PICARDJARPATH/picard.jar SortSam -I  ../GTEx_chr5_sel/Thyroid_GTEX-11GSP-0126-SM-5A5KU_chr5.bam -O ./sort.bam --SORT_ORDER coordinate

```

```
java -Xmx4g -XX:ParallelGCThreads=5 -jar $PICARDJARPATH/picard.jar CollectInsertSizeMetrics -I sort.bam -O ./ok.txt -H ./test.hist
```

