
Genome-Wide Association Studies

- genetic variation
	SNP
	insertion
	Del
	Structural variation -> duplication etc


- Feasibility of id genetic variants ![[Screenshot 2023-06-05 at 1.05.08 PM.png]]

- How to perform genetic association test?
	OR: Odds ratio. if OR =1 , no difference between case and control
	OR > 1, ex: 1.7 people have this allele have more chance (1.7 times) in disease group
![[Screenshot 2023-06-05 at 1.05.21 PM.png]]
-  Need to take into consider of how disease freq, allele freq, sample size etc
- GRR score (Genotype )
![[Screenshot 2023-06-05 at 1.05.42 PM.png]]
- Genotyping
	- Illumnina, microarray, 2006 (older version)
	- QPCR based genotyping 



- After Genotyping, do QC, need to consider people populatoin
	- 1000 GP
	- tool : GRAF (genetic relationship and fingerprinting), ex: using 10000 snps to do analysis
	- Hardy-Weinberg equilibrium
		- A list of assumption
		- p-value cutoff 
	- Heterozygosity and missingness 

![[Screenshot 2023-06-05 at 1.06.05 PM.png]]



![[Screenshot 2023-06-05 at 1.07.04 PM.png]]


- Can we increase SNP coverage
	-  LD: D' and R squard value (R2)
	![[Screenshot 2023-06-05 at 1.15.16 PM.png]]

	- Imputation, using REF panel to guess missing info
	![[Screenshot 2023-06-05 at 1.16.13 PM.png]]

- Final is Association study
	- lm(), ex: 0 means normal, 1 means cancer. Fitting line is trying to  fitting all dots   
	- best fitting compare to worst fitting 
	- ![[Screenshot 2023-06-05 at 1.17.59 PM.png]]


- lm() 
	![[Screenshot 2023-06-05 at 1.23.18 PM.png]]
- Need to adjust lm() 
	- p-value is not powerful enough, generate false positive (type I error)
	
	![[Screenshot 2023-06-05 at 1.24.51 PM.png]]
	
	- so need to add adjustment, create threadhold
	- perform QQ and Manhattan plot, BC
	- 
	![[Screenshot 2023-06-05 at 1.28.23 PM.png]]

- What GWAS peak? 
- sometime the highest SNP is not the one, need to consider R2 over 0.8, which is high LD
- so need to do Conditional lm()
![[Screenshot 2023-06-05 at 1.30.55 PM.png]]

- 
- The overall stragy
- ![[Screenshot 2023-06-05 at 1.32.47 PM.png]]
![[Screenshot 2023-06-05 at 1.33.29 PM.png]]



---

what's "beta" value is good in GWAS analysis?   The "beta" value in GWAS analysis is a measure of the effect size of a particular genetic variant on a trait. The ideal value for beta varies depending on the trait being studied, the population being studied, and the statistical methods used to analyze the data. In general, a beta value between 0.1 and 0.4 is considered to be good for GWAS analysis.

high "beta" value means in GWAS? In GWAS, a high beta value indicates that a particular genetic variant is strongly associated with a trait or disease.


---

# QTL analysis 

Quantitive Trait Locus

- GWAS is QTL mapping
- statquest linear regression: https://www.youtube.com/watch?v=PaFPbb66DxQ
- 

![[Screenshot 2023-06-12 at 12.54.52 PM.png]]![[Screenshot 2023-06-12 at 1.13.29 PM.png]]![[Screenshot 2023-06-12 at 1.16.54 PM.png]]
![[Screenshot 2023-06-12 at 1.19.23 PM.png]]
- Dosage use for convert GT to 0,1,2 

- The Steps of doing eQTL
![[Screenshot 2023-06-12 at 1.21.25 PM.png]]

- After that, doing vlnplot or box plot to see 
- ![[Screenshot 2023-06-12 at 1.22.21 PM.png]]
![[Screenshot 2023-06-12 at 1.25.20 PM.png]]
- QC, PCA, batch effect etc...
- add covariables, gender,sex,age ...
- adjust false positive, ex: p-adj 

- 
- ![[Screenshot 2023-06-12 at 1.27.51 PM.png]]

- Colocalization
- loc
- ![[Screenshot 2023-06-12 at 1.31.45 PM.png]]