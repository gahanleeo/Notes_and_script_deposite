
folder link: 
[Arima_HiChIP_project](file:/Users/leec20/Desktop/HiCHIP_project/wet_protocol)

---
**Kit:
	MiSeq Reagent Kit v3 BOX1 (600-cycle) # ref 15043895, -20C
		HT1 buffer and huge plastic box
	Miseq Reagent Kit V3 BOX2 (flow-cell) in 4C
		flowcell and PR2 bottle, put in 4C before preparing clening flowcell


**My -20 and -80 box location**
	-20 is in G-a-1 rack
	-80 is in X-A-3 rack 

---

### flowcell prepation notes

The example excel file is located in the folder:
	[illumina_tample](file://Users/leec20/Desktop/HiCHIP_project/wet_protocol/illumina_tample.csv)
	[example_of_lib_to_4uM_for_flowcell_from_Mai](file://Users/leec20/Desktop/HiCHIP_project/wet_protocol/example_of_lib_to_4uM_for_flowcell.xlsx)
	[how to dilute multiple sample into 4nM with 5ul?](https://knowledge.illumina.com/library-preparation/general/library-preparation-general-reference_material-list/000001252)


- ### Sample Multiplexing Overview

	Sample multiplexing, also known as multiplex sequencing, allows large numbers of libraries to be pooled and sequenced simultaneously during a single run on Illumina instruments. Sample multiplexing is useful when targeting specific genomic regions or working with smaller genomes. Pooling samples exponentially increases the number of samples analyzed in a single run, without drastically increasing cost or time.
	
	With multiplex sequencing, individual "barcode" sequences are added to each DNA fragment during next-generation sequencing (NGS) library preparation so that each read can be identified and sorted before the final data analysis. These barcodes, or index adapters, can follow one of two major indexing strategies depending on your library prep kit and application.

- For sample run, combined all lib into one tube, total is 4uM, use `nM post PCR` from KAPA quant in KAPA_quant_QC_set2_1206 excel file to calcuate conc to 6 sample in total 4uM 

 - Mai has phx reagent for spike in

- Index sequence/ID from DNA swift bioscience
- index sequence is same as **TruSeq DNA PCR-free lib** when selecting locoal run manager
	[index_seq](file:/Users/leec20/Desktop/HiCHIP_project/wet_protocol/16-0968_Manual-for-Accel-NGS-2S-Plus-Single-Index_160707.pdf)
		Smaples:
		T24_1: I2, A002, CGATGT(A)
		T24_2: I4, A004 ,TGACCA(A)
		T24_3: I23, A023, GAGTGG(A)
		RT4_1: I5, A005, ACAGTG(A)
		RT4_2: I6, A006, GCCAAT(A)
		RT4_3: I22, A022, CGTACG(T)
		PDC_1: I21, A021, GTTTCG(G)


- flowcell kit is located -20C and 4C -> ask Mai first! it's in her lab's -30C 

- New guide to everything Miseq needed 2023:
	[Miseq 101](https://illumina.pagetiger.com/bowiayv/1)

- [The Miseq System guide](https://support.illumina.com/content/dam/illumina-support/documents/documentation/system_documentation/miseq/miseq-system-guide-for-local-run-manager-15027617-05.pdf) for how to put your prepated library into mechine (2019)

---
**Preparing flowcell library 
-  illumnina flow cell guide protocol:
	[guide](file://Users/leec20/Desktop/HiCHIP_project/wet_protocol/miseq-denature-dilute-libraries-guide-15039740-10.pdf)
	denature 10min

---

**MAPS pipeline** for determining the quality

https://github.com/HuMingLab/MAPS/tree/master/Arima_Genomics

[my installation protocol](file:/Users/leec20/Desktop/HiCHIP_project/MAPS/MAPS_installation_and_running_20211014.docx)

---
As for 0321, try to follow protocol in github:

Clone the MAPS from github
`git clone https://github.com/HuMingLab/MAPS.git`
Create conda environment with python 
`conda create -n MAPS_env python=3.10`
Activate the conda environment
`conda activate MAPS_env`

Once activate the conda environment, start install tools
`mamba install -c bioconda deeptools`
`mamba install pandas`
`mamba install  pysam` *
`mamba install -c conda-forge -c bioconda pybedtools` *
`mamba  install -c bioconda macs2`
`mamba install R=4.2`

`$ R` then in R, install package
`install.packages("argparse")`
`install.packages("VGAM")`
`install.packages("data.table")`

- As for other tools, it's already in Biowulf:
	bedtools
	samtools
	HTSLIB
	bcftools
	bwa
`ml samtools bedtools bwa`

- Once installed, move the `Arima-MAPS_v2.0.sh`  from `MAPS/Arima_Genomics/` directory to `MAPS/bin/`
- It need **absolute pathway** for output for the command will have error!!!
- for file name **abcd_**_R1.fastq.gz, the `-I`  inupt in command should  **abcd** 


```
sh /data/leec20/HiChIP_Miseq_0320/MAPS/bin/Arima-MAPS_v2.0.sh -C 1 -p broad -I /data/leec20/HiChIP_Miseq_0320/test_file/Arima-MAPS-test -O /data/leec20/HiChIP_Miseq_0320/test_file/output -o hg38 -b /fdb/igenomes/Homo_sapiens/UCSC/hg38/Sequence/BWAIndex/genome.fa -t 6 -f 1

```

---
### Going to Novaseq
- "Arima generally recommends ==2x150bp read length== on the HiSeqâ or NovaSeqTM instruments to optimize for sequencing throughput and Arima-HiChIP data alignment quality"
- Probably 300 cycle => 2x150bp read length 
- (0.5 - 2 million raw read-pairs) 
- **(50 – 500 million raw read-pairs) deep**

- Kristine has created a TEAM chat room which has a list of files for reference
	[files_inckuded_manfiest..etc](file:/Users/leec20/Desktop/HiCHIP_project/wet_protocol/)
	


- Question to Mai:
- Will `assay name TruSeq DNA PCR-Free` affect my result in illumina upload csv?
- what conc to Novaseq? 2-20nM from CGR
- how much % phx spike in 
- i7 - single index i5/i7 dual index 
---

- measuring lib size using Bioanalyzer
https://www.agilent.com/cs/library/usermanuals/Public/G2938-90321_SensitivityDNA_KG_EN.pdf
