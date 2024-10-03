### Parse single cell using PacBio long read seq

#### 1st lima
```
#reuqire cpu24,mem=20g
for i in *.bam
do
ff=`echo $i | sed 's/.bam//g' `
lima ${i} ../parse_kinnex_primer.fasta ${ff}_limmed.bam --ccs --min-score 0 --min-end-score 0 --min-signal-increase 0 --min-score-lead 0
done

# the output file is called xxx_limmed.bam

```
#### 2nd refine
```
# refine to concate the reads
# -c 40 --mem=80g

for i in *bam
do
ff=`echo $i | sed 's/\.bam//g' `
isoseq refine ${i} -j 40 ../parse_kinnex_primer.fasta ./${ff}_REFINED.bam
echo fin one
done
```
#### 3rd convert BAM to fastqs
```
# the PacBio has tool call "pbtk"
#https://github.com/pacificbiosciences/pbtk/
# --cpu=32,mem=70g

bam2fastq -j 32 -o lib1_Merge_ALLSMRT ./BC01_merge_limmed_REFINED.bam ./BC02_merge_limmed_REFINED.bam
bam2fastq -j 32 -o lib2_Merge_ALLSMRT ./BC03_merge_limmed_REFINED.bam ./BC04_merge_limmed_REFINED.bam

```

#### Run LR-split pipe

```

source myconda
conda activate parse_v130

# run LR-split pipeline first step of demulitplex
python LR-splitpipe/LR-splitpipe/demultiplex.py all -f /data/leec20/parse_single_cell/Long_read_pacbio_with_parse_test/pacbio_unaligned_bams/fastqs_removed_kinnex_primer_by_limma/lib2.pacbio.fastq.gz -o ./Split_LR_out/Split_pi_lib2 -k  WT_mega -c v2 -t 36 --delete_input --chunksize 10**5

```
