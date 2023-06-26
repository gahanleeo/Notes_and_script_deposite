- BTEP, some question about single cell
https://bioinformatics.ccr.cancer.gov/btep/questions/

- Deal with dead cell using mito filter out
- ![[Screenshot 2023-03-23 at 2.16.23 PM.png|500]]


---
## Batch effect correction

https://www.10xgenomics.com/resources/analysis-guides/introduction-batch-effect-correction

- 2 major tools:
	Harmony
	SeuratV3,[integration dataset part](https://satijalab.org/seurat/articles/integration_introduction.html#identify-conserved-cell-type-markers-1)
	

	
	![[Screenshot 2023-03-23 at 3.23.37 PM.png|500]]

**UMAP variable selection, what variable is best?**
	number of PCs also affect, 1 cell type around 30pc;  2 or more cell type 50pcs
	
	
	

**RNA Velocity in single cell data**

![[Screenshot 2023-03-23 at 4.04.25 PM.png|500]]

- [cellRank](https://cellrank.readthedocs.io/en/stable/)



![[Screenshot 2023-03-23 at 4.13.34 PM.png|500]]


---

### 2023 Seurat lab workshop

PIP-seq, DIY of 10x in your lab

data-sketching, goal is to compress dataset to reduce computing time

![[Screenshot 2023-04-07 at 10.13.01 AM.png]]

- without clustering to do differentaiol expression, useful for cell hard to cluster
![[Screenshot 2023-04-07 at 10.18.11 AM.png]]

- mito mut use to trace cell and learn colonal trace
- ![[Screenshot 2023-04-07 at 10.21.25 AM.png]]


- V2GP for GWAS analysis conect GWAS to pertub-seq
![[Screenshot 2023-04-07 at 10.22.58 AM.png]]

- MPRA with single cell 
![[Screenshot 2023-04-07 at 10.32.43 AM.png]]

- ChIP-seq with multi
![[Screenshot 2023-04-07 at 10.38.41 AM.png]]

- plot reference 
- SCpubr <- for single cell
