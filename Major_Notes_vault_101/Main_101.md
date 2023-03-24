

### Link to other folder/valut/projects

[[DCEG_bioinfrmatics_course_notes]]

[[Arima_HiChIP project and how to flowcell Miseq]]

[straglr_material_method_draft](file:///Users/leec20/Desktop/markdown_for_straglr_steps)

[Nethandel bams and SNPs scoring](file:///Users/leec20/Desktop/neandertal_bams)

[Animal TERT CLP sequence for TRF folder location](file:////Users/leec20/Desktop/Animals_TERT_CLP)
	[[Animal TERT and CLP fasta for TERT_CLP project]]

[[AWS S3 bucket]]

[TERT_R2_Project](file://Users/leec20/Desktop/straglr_scoring_tool_for_long_read/TERT_repeat_region_projects)

[[MISO TERT and m6A]]

[[dbGAP GTEx and links also CBioProtoal]]

- ---

- MISO gff3 file reoraganize ==> still going
- hump socring: chr5:1,275,210-1,277,496


---

- GTEX bam files accessiable? > first > brain tissue from GTEX.  [[dbGAP GTEx and links also CBioProtoal]]

---

- https://www.biorxiv.org/content/10.1101/2023.01.12.523790v1
---

 methylation calls and (phased) VCFs with variant calls to "/data/KolmogorovLab/CARD/NABEC_asm_v2/vcf_methyl". Methylation calls (one for each phase) are in bed format described here: [https://github.com/epi2me-labs/modbam2bed](https://gcc02.safelinks.protection.outlook.com/?url=https%3A%2F%2Fgithub.com%2Fepi2me-labs%2Fmodbam2bed&data=05%7C01%7Cchiahan.lee%40nih.gov%7Ce06ddb8c9a0a47c3750d08daf99a853c%7C14b77578977342d58507251ca2dc2b06%7C0%7C0%7C638096739296241859%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C3000%7C%7C%7C&sdata=8mdvxhLOOFnzQoWWsGj%2BZDWyASEFSanzSNrUxwGV770%3D&reserved=0 "Original URL:
https://github.com/epi2me-labs/modbam2bed
Click to follow link."). The phases for VCFs and BEDs should correspond to each other. They may be different compared to assemblies though (e.g. HP1 and HP2 may switch). These are against grch38.

---

## install R quickly
https://www.r-bloggers.com/2017/07/quick-way-of-installing-all-your-old-r-libraries-on-a-new-device/

platform       x86_64-apple-darwin17.0     
arch           x86_64                      
os             darwin17.0                  
system         x86_64, darwin17.0          
status                                     
major          4                           
minor          1.2                         
year           2021                        
month          11                          
day            01                          
svn rev        81115                       
language       R                           
version.string R version 4.1.2 (2021-11-01)
nickname       Bird Hippie   

----
## Aks ChatGPT section:

- [Main link](https://chat.openai.com/chat)
---

**When text transfer between linux and PC, sometimes will have "^M" in the end text
how to deal with this?**

suse.com/support/kb/doc/?id=000018317#:~:text=To%20enter%20the%20%5EM%20character,M%20at%20the%20same%20time

- to show ^M in the text: 
```
cat -v textfile
```
- to remove 
```
sed -e "s/\r//g" file > newfile
```