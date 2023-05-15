

- Nethdatl genotpying SNPs done ==> add chimp and otehr primates from UCSC browser 
	-ex: https://genome.ucsc.edu/cgi-bin/hgTracks?db=hg19&lastVirtModeType=default&lastVirtModeExtraState=&virtModeType=default&virtMode=0&nonVirtPosition=&position=chr5%3A1279757%2D1279823&hgsid=1543946845_3M5tHk1T5OU9p4YghQFNq3UiAAxR

- https://hgdownload.soe.ucsc.edu/hubs/VGP/

- VGP project alos list in ensembl, can blast:  http://projects.ensembl.org/vgp/

- Othter spiece long read link: https://genomeark.github.io/
	- the files of primates are in T-drive: smb://gigantor.nci.nih.gov/ifs/DCEG/Branches/LTG/Prokunina/1000GP_data/TERT-CLPTM1L_project/otherSpecies/other_species_fasta
	- since it's fasta files, maybe use conversed TERT region to aling/find the TERT gene region 



### how to seperate huge genome fasta by ">" 
https://www.biostars.org/p/291713/


**Make blast custom database

```
makeblastdb -in input_file.fasta -dbtype nucl -out output_database_name
```

### parsing through BALST output 
- Since we know the range from output, can use `blastdbcmd` for geting sequence

```
blastdbcmd -db T2T_Grollia_blast_db/T2T_gro_database -dbtype nucl -entry "haplotype1-0000008" -range 100-200 -out ttt
```

The `-range` is range `-entry` is subject sequence id  
`-db T2T_Grollia_blast_db/T2T_gro_database ` is Groilla T2T fasta database I created.
	noted that the name need to go down in the folder 



---
input:
/data/leec20/Animal_Blast/human_TERT

ref:
/data/leec20/Animal_Blast/chimp_T2T_blast_db/chimp_T2T_db

