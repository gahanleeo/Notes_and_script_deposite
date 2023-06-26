
**dbGAP/GTEX_download through sratool**
### sratoolkit in Biowulf:
[https://hpc.nih.gov/apps/sratoolkit.html](https://hpc.nih.gov/apps/sratoolkit.html)
### need a key:
[https://trace.ncbi.nlm.nih.gov/Traces/sra/sra.cgi?view=toolkit_doc&f=dbgap_use](https://trace.ncbi.nlm.nih.gov/Traces/sra/sra.cgi?view=toolkit_doc&f=dbgap_use)
### using sam-dump and samtools to convert to bam file
### sam-dump:
[https://trace.ncbi.nlm.nih.gov/Traces/sra/sra.cgi?view=toolkit_doc&f=sam-dump](https://trace.ncbi.nlm.nih.gov/Traces/sra/sra.cgi?view=toolkit_doc&f=sam-dump)

### convert command:
```
sam-dump SRR390728 | samtools view -bS - > SRR390728.bam
```

---

## MORE EASIER WAY

[https://www.ncbi.nlm.nih.gov/books/NBK570248/](https://www.ncbi.nlm.nih.gov/books/NBK570248/)

  
#### Steps of how to download from .krt file (probably more easy…)

#### download .krt from SRARun selector

#### prefetch
#### de-crypt

![[Specific steps and commands.png]]

  
---


Prefetch error and how to solve:

[id exists while registering manager within virtual file system module …]

[https://github.com/ncbi/sra-tools/issues/488](https://github.com/ncbi/sra-tools/issues/488)

about the column “Embargo date”


[https://academic.oup.com/nar/article/42/D1/D975/1061961](https://academic.oup.com/nar/article/42/D1/D975/1061961)


Each data file distributed through the dbGaP has an embargo release date. The data access policy requires that the results obtained from analyzing the dbGaP data are not published before the embargo release date. To access the Authorized Access system, non-NIH users must have an NIH eRA Commons account with a PI role.

## update 01132023:

Since like the file is kind of update
- first need `prefetch` : (may not meed decode)
- need this excat orientation .... not sure why 
```
prefetch --ngc my_ngc_file   -o /data/$USER/mydir --cart cart.krt
```

- for SRR download use:
```
prefetch --ngc ../ngc_files/prj_34069_D29108.ngc SRR5588931 
```

- then run `fasterq-dump` on that folder 
```
fasterq-dump SRR1095865/
```

---
- GTEx RNA-seq files downlaod
- testing: SRR8218866
- 