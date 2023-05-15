##  The Goal for the TCGA is to get genotype of 12 SNPs result in all cancer by imputation/or actual genotype and link the genotype result with mutation signature/TERT-length in data.  

- /DCEG/TCGA/Chanock need request access

cat 

birdseed.GWAS_Chr5_rs10069690_signal.probes

birdseed.GWAS_Chr5_rs10069690_signal.probes_X2

birdseed.GWAS_Chr5_rs10069690_signal.probes_X3


final_SNP_GWAS_cancer_xxx

- Script used:
```
file_birdseed="/DCEG/Branches/LTG/Prokunina/TCGA_data/All_TCGA_SNP.birdseedFiles"

for j in $(cat $file_birdseed/projects/chr5_tert_clp/birdseed.GWAS_Chr5_rs10069690_signal.probes); do\

 for k in $(ls $file_birdseed/files_*/*/*.birdseed.data.txt); do\

 if grep -q $j $k; then echo $k > SNP_Chr5_rs10069690.txt;\

 grep $j $k >> SNP_Chr5_rs10069690.txt; \

 tr '\n' ' ' < SNP_Chr5_rs10069690.txt >> final_SNP_GWAS_Chr5_rs10069690_signal.txt; \

 echo " " >> final_SNP_GWAS_Chr5_rs10069690_signal.txt; \

 rm SNP_Chr5_rs10069690.txt; fi; done; done

-bash-4.1$

```

- `grep -q "pattern" text.txt`  -> search the "pattern" in the whole text file

----
# get all the cancer type 

```
for file in "../../files_"*"_Nov2015"; do
    cancer_type=$(echo $file | sed 's/.*files_\([A-Z]*\)_Nov2015/\1/')
    echo $cancer_type
done

```

---
## There's swarm in CCAD, sunswarm

Load the sunswarm module and look at the help message:
```
module load sunswarm && sunswarm -h
```

Create a file with a shell command on each line:
```
for i in $(seq 1 5); do echo "echo $i" >> swarm.cmd; done
```

Submit the swarm command file:
```
sunswarm -f swarm.cmd
```

---

### the script and Markdown of 1st step for PLINK input is located:

[GWAS_analysis_folder](file:/Users/leec20/Desktop/scripts/R_scripts/GWAS_oscar_related_for_making_PLINK_input)






---
to merge 2 data frame by matching first 6 columns

```
# the simple version:
awk 'BEGIN{FS=OFS=" "}{key=$1 FS $2 FS $3 FS $4 FS $5 FS $6; if(key in data){for(i=7; i<=NF; i++){data[key] = data[key] FS $i}} else {data[key]=$0 }}END{for(key in data) print data[key]}' file1.txt file2.txt > output.txt

# detailed explain

awk 'BEGIN{FS=OFS="\t"}{
  key=$1 FS $2 FS $3 FS $4 FS $5 FS $6;   # create the key from the first 6 columns
  if(key in data){                        # if the key already exists in the associative array
    for(i=7; i<=NF; i++){                 # loop through all fields starting from 7th column
      data[key] = data[key] FS $i         # append each field to the existing value
    }
  } else {                                # if the key doesn't exist in the associative array
    data[key]=$0                          # store the entire line as the value for that key
  }
}
END{                                      # after processing all input files
  for(key in data) print data[key]        # loop through the data array and print the concatenated values
}' file1.txt file2.txt > output.txt

```

```
# merge all data 

# sort file 

ls -1 set_TCGA_slice*.ped | sort -t _ -k 4 -n

#-   The `ls` command lists all files in the current directory matching the #pattern `set_TCGA_slice*.ped`.
#-   The `-1` option tells `ls` to output each file on a separate line.
#-   The pipe (`|`) sends the output of `ls` to the `sort` command.
#-   The `-t _` option tells `sort` to use the underscore character (`_`) as the #field separator.
#-   The `-k 4` option tells `sort` to sort based on the fourth field, which is #the number in the filename.
#-   The `-n` option tells `sort` to sort the values numerically.

# add the list of sorted output in the end of script:


printf "awk 'BEGIN{FS=OFS=\" \"}{key=\$1 FS \$2 FS \$3 FS \$4 FS \$5 FS \$6; if(key in data){for(i=7; i<=NF; i++){data[key] = data[key] FS \$i}} else {data[key]=\$0 }}END{for(key in data) print data[key]}' $(ls *.ped | sort -t_ -k4 -n | tr '\n' ' ')" >> output.txt


```

---
### some data have missing SNP in last round, to remove NA can use
`f[is.na(f)] <- " "`

---
### Check our 12 target SNPs are in the .map output file

rs56345976
rs33961405
rs10069690
rs2242652
rs7705526
rs2736100
rs2853677
rs2853669
rs7712562
rs2735940
rs2447853
rs401681
 
 
- check 12 SNPs in map file, know which snps we have
- other finding Proxy
- Finding proxy, LD-link. select ERU group. MAKE SURE is hg19
- downlaod txt and name "proxy_rsID_hg19.txt"

---

**Just some simple test**


```
library(dplyr)

setwd('/Volumes/Prokunina/TCGA_data/All_TCGA_SNP.birdseedFiles/projects/chr5_tert_clp/files_of_regions/')

map <- read.table('set_TCGA_LUAD.map')

chr5_snp_12 <- c('rs56345976',
'rs33961405',
'rs10069690',
'rs2242652',
'rs7705526',
'rs2736100',
'rs2853677',
'rs2853669',
'rs7712562',
'rs2735940',
'rs2447853',
'rs401681') 

mpls <- list.files('.',pattern = '.map')

which(map$V2 %in% chr5_snp_12)

map$V2[3547]

# rs401681, rs2736100

ff <- c()

for (i in mpls){

  f <- read.table(i,header = F)
  tar <- f$V2
  for (y in 1:length(tar)){
    if(tar[y] %in% chr5_snp_12){
      ff <- append(ff,paste(i,'got it',tar[y]))
      
    }
  }
}


```

**result: rs401681 and rs2736100 are in these map files**

download rest of proxy snps in txt fromat using LD-proxy under hg19 EUR selection

==rs56345976==
===rs33961405===
===rs10069690===
==rs2242652==
==rs7705526==
==rs2853677==
==rs2853669==
==rs7712562==
==rs2735940==
==rs2447853==

====
what we had 

rs401681
rs2736100

---
**Next goal is to search which is proxy SNPs has best R2 presented in the AffID_SNPs_genortped file**

- find best R2 SNPs 
- Final output column is TCGA-ID/ two known SNP genotyped/rsID_proxy_proxy_SNP .... 

https://regulomedb.org/regulome-search

---
**Since it's poor R2 qualaity in most SNPs, we go for impoutation using PLINK/1.9


now we have plink2...
https://www.cog-genomics.org/plink/2.0/input


load ped map file using `--pedmap ` function

- module requirement:
```

module load plink2/1.90b5

module load tabix/1.9

module load bcftools/1.9b
```
- steps 
```
### --make-bed creates a PLINK 1 binary fileset
### --file myFile is the filename without .ped/map, for this example "--file sample"

> plink \  
--file myFile \  
--keep-allele-order \  
--make-bed \  
--out myFile

### now it will generate .bed/.bim/.fam binary files, use this for vcf generating

> plink \  
--bfile myFile \  
--recode vcf-iid \  
--keep-allele-order \  
--out myFile

> bgzip -c myFile.vcf > myFile.vcf.gz  
> tabix -p vcf myFile.vcf.gz

```


- next step is check vcf file chromosome suffix, since it may have 5 instead of chr5
- create txt file for bcftool to do the job
```
nano chr_name_mapping_5-chr5.txt
# in that txt, create with tab sep 
5     chr5
# once done, save txt 
```

- after txt was created, module load rest of tools 
```
module load plink2/1.90b5  
module load bcftools/1.9b  
module load jdk/15  
module load picard/2.21.1  
module load tabix/1.9

```

-   now create a loop to loop all the vcf files 
```
# rename chr to match FASTA file for liftover and reference panel for Phasing and Imputing  
bcftools annotate --rename-chrs chr_name_mapping_5-chr5.txt myFile.vcf.gz -Oz -o tmp_renameCHR.vcf.gz  

mv tmp_renameCHR.vcf.gz myFile.rename.vcf.gz  

# reindex the file
tabix -p vcf myFile.rename.vcf.gz

```


```
for i in temp_set_TCGA_* ; do ff=`echo $i | sed 's/temp_\|\.vcf\.gz//g'` ; echo $ff ; done
```

- Since we are in hg38, also need to liftover from 19 to 38
```
## liftover from hg19 to hg38  
picard LiftoverVcf \  
I=myFile_rename.vcf.gz \  
O=myFile_rename.lifted.vcf \  
CHAIN=liftoverFiles/hg19ToHg38.over.chain.gz \  
REJECT=liftoverFiles/rejected_variants.vcf \  
R=liftoverFiles/chr5.fa.gz \  
RECOVER_SWAPPED_REF_ALT=true

bgzip -c myFile_rename.lifted.vcf > myFile_rename.lifted.vcf.gz

tabix -p vcf myFile_rename.lifted.vcf.gz

```
- more advanced:
```

for i in *.gz
do

  ff=`echo $i | sed 's/.vcf.gz//g'`
  cancer=`echo $i | sed 's/set_\|\.rename.vcf.gz//g'`
  picard LiftoverVcf\
  I=${i}\
  O=${ff}.lifted.vcf\
  CHAIN=../liftoverFiles/hg19ToHg38.over.chain.gz\
  
  # reject file need to be end with ".vcf" 
  REJECT=../liftoverFiles/rejected_${cancer}_variants.vcf\
  R=../liftoverFiles/chr5.fa.gz\
  RECOVER_SWAPPED_REF_ALT=true

  bgzip -c ${ff}.lifted.vcf > ${ff}.lifted.vcf.gz

  tabix -p vcf ${ff}.lifted.vcf.gz
  echo "done one cacner"
done

```

- Next step is imputation?

- TOOLS
	- [SHAPEIT](https://odelaneau.github.io/shapeit5/) <- preimputation?
	- [BEAGLE](https://faculty.washington.edu/browning/beagle/beagle_5.4_18Mar22.pdf)
	- [IMPUTE2](https://mathgen.stats.ox.ac.uk/impute/impute_v2.html)
	- The OK tutoriol I found: https://github.com/MareesAT/GWA_tutorial/
	- 


---
/DCEG/Branches/LTG/Prokunina/TCGA_data/All_TCGA_SNP.birdseedFiles/projects/chr5_tert_clp/files_of_vcf/chr5_renamed_liftedto_hg38_vcf
