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
**Since it's poor R2 qualaity in most SNPs, we go for imputation using PLINK/1.9


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


- next step is check vcf file chromosome suffix, since it may have 5 instead of chr5, in order to lift to hg38, need to change the chr surfix 
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
# reject file need end with .vcf

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


---

### Next step is phasing using SHAPEIT4 

```
module load shapeit/4.2  
module load tabix/1.9  
module load bcftools/1.9b
```

- Reference panal for phasing is reference from 1000 genome project 
```
files_refpanel="/DCEG/Branches/LTG/Prokunina/1000GP_data/TERT-CLPTM1L_project/data_WGS30x_onGRCh38/imputing/performance_refPanel"


# look like this 

pos chr cM

20583 5 0

25453 5 0.038077

26366 5 0.038103

```

- Since reference is 5 instead of chr5, need to rename again
```
chr_name_mapping_chr5-5.txt


# uding for loop in the lifted vcf.gz folder

 for i in *.gz; do ff=`echo $i | sed 's/temp_\|\.vcf\.gz//g'`; bcftools annotate --rename-chrs ../chr_name_mapping_chr5_to_5.txt ${i} -Oz -o ../chr5_renamed_to_5_liftedto_hg38_vcf/${ff}.tmp.vcf.gz ; done

# go to output folder,rename and index the vcf file


for i in *.gz ; do ff=`echo $i | sed 's/.rename.lifted.tmp.vcf.gz//g'`;
mv ${i} ${ff}.rename_to_5.lifted_38.vcf.gz;
tabix -p vcf ${ff}.rename_to_5.lifted_38.vcf.gz;
done

```

- once done the phasing part:
```
shapeit4.2 \  
--input myFile_rename.lifted.vcf.gz \  
--map $files_refpanel/chr5.b38.gmap.gz \  
--region 5 \  
--output myFile_rename.lifted.phased4.vcf.gz \  
--log myFile_rename.lifted.log \  
--thread 12

```

- the output vcf file now look like:

![[Screenshot 2023-05-16 at 11.19.48 AM.png]]

- the info of this is is also in other notes:
- ### Some info about how to interpert vcf file

- [0|0 or 0/0 meaning in genortpe](https://www.biostars.org/p/86321/)
	- The `GT` (genotype) field encodes allele values separated by either of / or |. The allele values are 0 for the reference allele (what is in the REF field), 1 for the first allele listed in ALT, 2 for the second allele list in ALT and so on. For diploid calls examples could be `0/1`, `1|0`, or `1/2`, etc. / indicates an _unphased_ genotype, and | indicates a _phased_ genotype. For phased genotypes, the allele to the left of the bar is haplotype 1, and the allele to the right of the bar is haplotype 2.
	- For example: Ref is AA.
	- 1|1 ==> the sample in the this SNPs is TT where the ref genome in this location is AA. 
	- 0|0 ==> the A SNPs is AA same as ref genome.
	- 1|0 or 0|1 ==> TA or AT in this location
	- phased data `|` seperates the chromoese from father (Patneral) and chromsome from mother (Matneral)
	- Phasing is the process of inferring haplotypes from genotype data. Efficient algorithms and associated software for accurate phasing in pedigrees are needed, especially for populations lacking reference panels of sequenced individuals.
	
	- A **haplotype** refers to **a set of DNA variants along a single chromosome that tend to be inherited together**.

----


### The next step is generating Haps/Sample files
```
# load module
module load bcftools/1.9b  
module load tabix/1.9  

# 
bcftools convert \  
--hapsample \  
--vcf-ids myFile_rename.lifted.phased4.vcf.gz \  
-o myFile_rename.lifted.phased4


# my code, use 2>&1 to output log when running the script

 for i in *.gz ; do  ff=`echo $i | sed 's/.vcf.gz//g'` ; bcftools convert --hapsample --vcf-ids ${i}  -o from_vcf_to_HapSample/${ff} >> hapsample.log 2>&1 ; done

```


### finally, we do imputation using IMPUTE2/2.3.2

```
module load impute2/2.3.2

files_refpanel="/DCEG/Branches/LTG/Prokunina/1000GP_data/TERT-CLPTM1L_project/data_WGS30x_onGRCh38/imputing"


impute2 \  
-use_prephased_g \  
-m $files_refpanel/performance_refPanel/chr5.b38.gmap.gz \  
-h $files_refpanel/panel_1KGP_SNV_INDEL_SV_HapsTRs_phased_panel_hg38.sort.hap.gz \  
-l $files_refpanel/panel_1KGP_SNV_INDEL_SV_HapsTRs_phased_panel_hg38.sort.legend.gz \  
-known_haps_g myFile_rename.lifted.phased4.hap.gz \  
# the chromosome region to impute
-int 1.1e6 1.5e6 \  
-Ne 20000 \  
-o myFile_rename.lifted.phased4.impute \  
-buffer 250 \  
-phase 

```

----
### Once it's imputed, chagne format to the vcf files (From Haps/Samples to VCF)

- the file of *.hap* look like this:
	- row start with `---` means that this SNP is imputed
	- row start wiht `5 5:xxx..` means this SNPs have already genotyped
	![[Screenshot 2023-05-17 at 10.43.38 AM.png]]
	- this part of script is bascilly modify the format


```
module load bcftools/1.9b  
module load tabix/1.9

#########################################################
#### use sed to modify "---" to "5" and "chr5" to "5" ###
#########################################################


sed -i 's/---/5/g' myFile_rename.lifted.phased4.impute_haps  
sed -i 's/chr5/5/g' myFile_rename.lifted.phased4.impute_haps


awk '{$1=$2}1' myFile_rename.lifted.phased4.impute_haps > myFile_rename.lifted.phased4.impute.format_haps

#############################################################
#############################################################
##`{$1=$2}1`: This is the `awk` script enclosed in curly braces. 
##
##$1=$2`: This statement assigns the value of the second field (`$2`) to the ##first field (`$1`).
##`1`: This is a common `awk` idiom that evaluates to true, causing `awk` to ##print the modified record.
##
##the `awk` command takes the input file, modifies each record by replacing the first field with the value of the second field, and then writes the modified records to the output file.
#############################################################
#############################################################

## merge sample ID to new format of hap data

bcftools convert\
  --vcf-ids\
  --hapsample2vcf myFile_rename.lifted.phased4.impute.format_haps,myFile_rename.lifted.phased4.sample -o myFile_rename.lifted.phased4.impute.format_haps.vcf

## anntation

  bcftools annotate\  
  --set-id +'%CHROM\:%POS\:%REF\:%ALT' myFile_rename.lifted.phased4.impute.format_haps.vcf >  myFile_rename.lifted.phased4.impute.formatID_haps.vcf

## gzip and indexed vcf

  bgzip -c myFile_rename.lifted.phased4.impute.formatID_haps.vcf > myFile_rename.lifted.phased4.impute.formatID_haps.vcf.gz  
  tabix -p vcf myFile_rename.lifted.phased4.impute.formatID_haps.vcf.gz  

```

### Extract SNPs of interest from imputed vcf files

```
# make txt file with chr snp_location, save as tab-seperate
nano list_of_positions.txt

5       1275400 [rs1579570119] 

5       1276752  [rs887215650] 
5       1276758  [rs56345976]
5       1277462  [rs33961405]
5       1279675  [rs10069690]
5       1279913  [rs2242652]

5       1285859  [rs7705526]
5       1286401  [rs2736100]
5       1287079  [rs2853677]
5       1295234  [rs2853669]
5       1295957  [rs7712562]
5       1296371  [rs2735940]
lift
						SNP.pick_hg38 = c"chr5:1276752:G:A",  
                                         "chr5:1276758:G:A",  
                                         "chr5:1277462:G:A",  
                                         "chr5:1279675:C:T",  
                                         "chr5:1279913:G:A",  
  
                                         "chr5:1285859:A:C",  
                                         "chr5:1286401:A:C",  
                                         "chr5:1287079:G:A",  
  
                                         "chr5:1295234:A:G",  
                                         "chr5:1295957:A:G",  
                                         "chr5:1296371:A:G")


############################
############################
#### my script 
############################
############################

# save and module load tools

module load bcftools/1.9b  
module load plink2/2.00a3LM  
module load tabix/1.9


### format each output chunk from the impute step  

for i in *impute.formatID_haps.vcf.gz; do
  
### create a temporal file with the SNPs IDs based on a file with their positions  

ff=`echo $i | sed 's/.vcf.gz//g'`

bcftools view -R list_of_positions.txt ${i} | grep -v "^#" | cut -f 1,3 > ../subset_targetSNPs/${ff}.snp_ids.txt

## filter the set of SNPs  
  
  plink2 --vcf ${i} --extract ../subset_targetSNPs/${ff}.snp_ids.txt --mind 0 --recode vcf-iid --out ../subset_targetSNPs/${ff}.11SNP

  bgzip -c ../subset_targetSNPs/${ff}.11SNP.vcf > ../subset_targetSNPs/${ff}.11SNP.vcf.gz  
  
  tabix -p vcf ../subset_targetSNPs/${ff}.11SNP.vcf.gz
  
  rm ../subset_targetSNPs/${ff}.snp_ids.txt

done

#### for loop in final ####

for i in *.vcf.gz; do ff=`echo $i | sed 's/.vcf.gz//g'`; bcftools view -R list_of_positions.txt ${i} | grep -v "^#" | cut -f 1,3 > ../subset_targetSNPs/${ff}.snp_ids.txt;  plink2 --vcf ${i} --extract ../subset_targetSNPs/${ff}.snp_ids.txt --mind 0  --recode vcf-iid --out ../subset_targetSNPs/${ff}.11SNP;  bgzip -c ../subset_targetSNPs/${ff}.11SNP.vcf > ../subset_targetSNPs/${ff}.11SNP.vcf.gz; tabix -p vcf  ../subset_targetSNPs/${ff}.11SNP.vcf.gz ; rm ../subset_targetSNPs/${ff}.snp_ids.txt ; rm ../subset_targetSNPs/${ff}.11SNP.vcf ;done


```





```

####################
### Oscar's ####
####################

### format each output chunk from the impute step  
for f in $files_location/*impute.formatID_haps.vcf.gz; do

  filename=$(basename "${f%???????}")

  ## create a temporal file with the SNPs IDs based on a file with their positions  
  bcftools view \  
  -R $files_location/list_of_positions.txt $f | grep -v "^#" | cut -f 1,3 > $files_location/"$filename".snp_ids.txt

  ## filter the set of SNPs  
  plink2 \  
  --vcf $f \  
  --extract $files_location/"$filename".snp_ids.txt \  
  --mind 0 \  
  --recode vcf-iid \  
  --out $files_location/"$filename".11SNP

  bgzip -c $files_location/"$filename".11SNP.vcf > $files_location/"$filename".11SNP.vcf.gz  
  tabix -p vcf $files_location/"$filename".11SNP.vcf.gz

  rm $files_location/"$filename".snp_ids.txt

done



```

---
### Pile up our own phased results and ploting KVlaue

- **Compare our phased result with Michigan impuation**
- [The R script location](file:/Users/leec20/Desktop/scripts/R_scripts/GWAS_oscar_related_for_making_PLINK_input/TERT_12SNPs_imputed_result_comparison_and_piling.R)



- Since it's still a lot of things to compare with Michigan stuff, we focus on our results for now
- make data frame for all the cancer


 TCGA_ID | cancer_type | 12 phased SNPs columns ex: phased_rsID_chromosme"
 -------------|----------- | -------
 TCGA-01A.. | BLCA | A\|G






----
----
---
---


##### Side notes:
- where's the gmap (gnentic map file) come from? 
	https://alkesgroup.broadinstitute.org/Eagle/Eagle_manual.html <- hg38 version can downloaded from Eagle software
	
	https://mathgen.stats.ox.ac.uk/impute/1000GP_Phase3.html <- the 1000 GP phase 3 about gmap,hap,legend files used for IMPUTE2 



- where's .hap and .lengend.gz come from?


- ` filename=$(basename "${f%???????}")`

	1. `${f%???????}`: This is a parameter expansion pattern that operates on the value of the variable `f`.
    -   `%???????` removes the last 7 characters from the value of `f`.
    -   The number of question marks (`?`) represents the number of characters to remove. In this case, 7 characters are removed.
    -   This pattern effectively removes the last 7 characters from the value of `f`.
    
	1.  `basename`: This is a command that strips the directory path from a file name, returning only the base name of the file.
    

The overall command takes the value of the variable `f`, removes the last 7 characters from it using parameter expansion, and then passes the modified value to the `basename` command. The `basename` command extracts the base name from the modified value and outputs it. 



### MISC
```
library(dplyr)
library(vcfR)
setwd('/Volumes/Prokunina/TCGA_data/All_TCGA_SNP.birdseedFiles/projects/chr5_tert_clp/files_of_vcf/')




df <- read.vcfR('Michigan_imputation_Server_result/BLCA_plink.10SNP.vcf.gz')
df.GT <- extract.gt(
  df,
  element = "GT",
  mask = FALSE,
  as.numeric = FALSE,
  return.alleles = TRUE,
  IDtoRowNames = TRUE,
  extract = TRUE,
  convertNA = TRUE
)

mich.blca <- as.data.frame(t(df.GT))

vf <- read.vcfR('phased_chr5_renamed_to_5_liftedto_hg38_imputed_result/subset_targetSNPs/set_TCGA_BLCA.rename_to_5.lifted_38.phased4.impute.formatID_haps.11SNP.vcf.gz')

vf.GT <- extract.gt(
  vf,
  element = "GT",
  mask = FALSE,
  as.numeric = FALSE,
  return.alleles = TRUE,
  IDtoRowNames = TRUE,
  extract = TRUE,
  convertNA = TRUE
)
os.blca <- as.data.frame(t(vf.GT))


os.sub <- os.blca[which(os.blca$TCGA_ID %in% c('TCGA-CU-A3KJ','TCGA-FD-A3SQ','TCGA-DK-A2HX','TCGA-BT-A2LA')),]
mich.sub <- mich.blca[which(mich.blca$TCGA_ID %in% c('TCGA-CU-A3KJ','TCGA-FD-A3SQ','TCGA-DK-A2HX','TCGA-BT-A2LA')),]

```

---
```
for i in *dose.vcf.gz ; do ff=`echo $i | sed 's/.vcf.gz//g'`

bcftools view -R list_of_positions.txt ${i} | grep -v "^#" | cut -f 1,3  > 12SNPs_with_rs2736098/${ff}.snp_ids.txt

plink2 --vcf ${i} --extract 12SNPs_with_rs2736098/${ff}.snp_ids.txt --mind 0 --recode vcf-iid --out 12SNPs_with_rs2736098/${ff}.12SNP

bgzip -c 12SNPs_with_rs2736098/${ff}.12SNP.vcf > 12SNPs_with_rs2736098/${ff}.12SNP.vcf.gz && rm 12SNPs_with_rs2736098/${ff}.12SNP.vcf

tabix -p vcf 12SNPs_with_rs2736098/${ff}.12SNP.vcf.gz

rm 12SNPs_with_rs2736098/${ff}.snp_ids.txt ; done
```