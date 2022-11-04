Sys.setenv(PATH = paste(Sys.getenv("PATH"), "/Users/leec20/Desktop/primer3/src", sep = ":"))
Sys.setenv(PATH = paste(Sys.getenv("PATH"), "/usr/local/ncbi/blast/bin", sep = ':'))

library(TAPseq)
library(GenomicRanges)
library(BiocParallel)

# gene annotations for chromosome 11 genomic region
data("chr11_genes")

# convert to GRangesList containing annotated exons per gene. for the sake of time we only use
# a small subset of the chr11 genes. use the full set for a more realistic example
target_genes <- split(chr11_genes, f = chr11_genes$gene_name)
target_genes <- target_genes[18:27]

# K562 Drop-seq read data (this is just a small example file within the R package)
dropseq_bam <- system.file("extdata", "chr11_k562_dropseq.bam", package = "TAPseq")

# register backend for parallelization
register(MulticoreParam(workers = 5))

# infer polyA sites from Drop-seq data
polyA_sites <- inferPolyASites(target_genes, bam = dropseq_bam, polyA_downstream = 50,
                               wdsize = 100, min_cvrg = 1, parallel = TRUE)


# truncate transcripts at inferred polyA sites
truncated_txs <- truncateTxsPolyA(target_genes, polyA_sites = polyA_sites, parallel = TRUE)

###?????????

library(BSgenome)

# human genome BSgenome object (needs to be istalled from Bioconductor)
hg38 <- getBSgenome("hg38")

# get sequence for all truncated transcripts
txs_seqs <- getTxsSeq(truncated_txs, genome = hg38)

# create TAPseq IO for outer forward primers from truncated transcript sequences
outer_primers <- TAPseqInput(txs_seqs, target_annot = truncated_txs,
                             product_size_range = c(350, 500), primer_num_return = 5)

# design 5 outer primers for each target gene
outer_primers <- designPrimers(outer_primers)

# get primers and pcr products for specific genes
tapseq_primers(outer_primers$HBE1)
pcr_products(outer_primers$HBE1)

# these can also be accessed for all genes
tapseq_primers(outer_primers)
pcr_products(outer_primers)

##BLAST
# chromosome 11 sequence
chr11_genome <- DNAStringSet(getSeq(hg38, "chr11"))
names(chr11_genome) <- "chr11"

# create blast database
blastdb <- file.path(tempdir(), "blastdb")
createBLASTDb(genome = chr11_genome, annot = unlist(target_genes), blastdb = blastdb)
# now we can blast our outer primers against the create database
outer_primers <- blastPrimers(outer_primers, blastdb = blastdb, max_mismatch = 0,
                              min_aligned = 0.75)
# the primers now contain the number of estimated off-targets
tapseq_primers(outer_primers$IFITM1)


