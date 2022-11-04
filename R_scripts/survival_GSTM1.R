library(ggplot2)
library(ggpubr)
library(dplyr)
library(survminer)
##
# Plot for GSTM1 vs survuval
#
# read file
require("survival")
gen = read.delim('GSTM1_del_geno_vs_exp.txt')
# remove NA in genotype
gen = gen[rowSums(is.na(gen[,1:10])) == 0, ]
gen$gender_code = as.factor(gen$gender_code)

## test survival plot 

fit <- survfit(Surv(os_time, os) ~ GSTM1_byfreq , data = gen)
ggsurvplot(fit, data = gen)

##  plot

fit <- survfit(Surv(os_time, status) ~ sex, data = gen)
ggsurvplot(fit, data = gen)

