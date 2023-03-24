
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
