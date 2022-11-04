library(ggplot2)
library(ggpubr)
library(dplyr)
# load the file 
setwd('~/Desktop/MIBC_pati_GSTM1/')
f1 = read.delim('MIBC_pat_for_plot.txt')
f1 = f1[,-c(2,5)]

# make a copy
f2 = f1
# remove NA? change group to factor 
f2$cstage  = as.factor(f2$cstage)
f2$bca_subtype = as.factor(f2$bca_subtype)

## plot, use anova
compare_means(GSTM1_SCAN.UPC ~ bca_subtype , data = f2,method = "anova")

# Default method = "kruskal.test" for multiple groups, change to anova
ggboxplot(f2, x = "bca_subtype", y = "GSTM1_SCAN.UPC",
          color = "bca_subtype", palette = "jco",add = "jitter")+
  stat_compare_means(method = "anova")

###
###
##plot pair wise
compare_means(GSTM1_SCAN.UPC ~ bca_subtype , data = f2)
# Visualize: Specify the comparisons you want
levels(f2$bca_subtype)
# "Basal","Claudin Low","Infiltrated Luminal","Luminal"

my_comparisons <- list( c("Basal", "Claudin Low"), c("Basal", "Infiltrated Luminal"), c("Basal", "Luminal"),
                        c("Claudin Low","Infiltrated Luminal"),c("Luminal","Infiltrated Luminal"),c("Claudin Low",'Luminal'))
p= ggboxplot(f2, x = "bca_subtype", y = "GSTM1_SCAN.UPC",
          color = "bca_subtype",ggtheme = theme_gray() ,add = "jitter") +
  stat_compare_means(comparisons = my_comparisons)+ # Add pairwise comparisons p-value
  stat_compare_means(label.y = 5,method = 'anova') +  # Add global p-value
  theme(legend.position = "none")   # remove legend on the right side of plot

p

pdf('output/cancer_subtype_vs_GSTM1.pdf')
plot(p)
dev.off()
###
###
###
# "Basal","Claudin Low","Infiltrated Luminal","Luminal"
# Pairwise comparison against reference
compare_means(GSTM1_SCAN.UPC ~ bca_subtype,  data = f2, ref.group = "Basal",
              method = "t.test")

p = ggboxplot(f2, x = "bca_subtype", y = "GSTM1_SCAN.UPC",
          color = "bca_subtype", ggtheme = theme_gray() ,add = "jitter")+
  stat_compare_means(method = "anova", label.y = 5) +      # Add global p-value
  stat_compare_means(label = "p.signif", method = "t.test",
                     ref.group = "Basal") # Pairwise comparison against reference

###
###
###
# Multiple pairwise tests against all (base-mean)

compare_means(GSTM1_SCAN.UPC ~ bca_subtype,  data = f2, ref.group = ".all.",
              method = "t.test")

# Visualize the expression profile
p = ggboxplot(f2, x = "bca_subtype", y = "GSTM1_SCAN.UPC",
          color = "bca_subtype", ggtheme = theme_gray() ,add = "jitter") +
  #rotate_x_text(angle = 45)+
   geom_hline(yintercept = mean(f2$GSTM1_SCAN.UPC), linetype = 2)+ # Add horizontal line at base mean
  stat_compare_means(method = "anova", label.y = 3)+        # Add global annova p-value
  stat_compare_means(label = "p.signif", method = "t.test",
                     ref.group = ".all.") +  theme(legend.position = "none")  # Pairwise comparison against all

p
pdf('output/GSTM1_mean_vs_allgroup.pdf')
plot(p)
dev.off()
## it can be interpert as GSTM1 is significantlly down-expressed in Claudin_low type.


##
##
# Plot for GSTM1 del genotpye vs GSTM1 expression
#
# read file
geno = read.delim('GSTM1_del_geno_vs_exp.txt')
# remove NA in genotype
geno1 = geno[rowSums(is.na(geno[,9:10])) == 0, ]
geno1 = geno1[,c(1,9,10)]


## rearrange
geno1 = geno1 %>% arrange(GSTM1_byfreq)
# make otehr genotype
geno1$delvsother = c(rep('del/del',155),rep('other',150))

## make plot, make var as factor
geno1$GSTM1_byfreq = as.factor(geno1$GSTM1_byfreq)
geno1$delvsother = as.factor(geno1$delvsother)
# plot

p = ggboxplot(geno1, x = "delvsother", y = "GSTM1_SCAN.UPC",
               color = "delvsother", ggtheme = theme_gray(),
               add = "jitter") + stat_compare_means(method = "t.test",label.y = 2.5) + theme(legend.position = "none")
p

pdf('output/GSTM1_del_vs_other.pdf')
plot(p)
dev.off()

###
###
### plot 3 genotype group 
compare_means(GSTM1_SCAN.UPC ~ GSTM1_byfreq, data = geno1 , method = 't.test')

my_comparisons  = list(c('del/del','del/nodel'),c('del/del','nodel/nodel'))
p = ggboxplot(geno1, x = "GSTM1_byfreq", y = "GSTM1_SCAN.UPC",
          color = "GSTM1_byfreq",ggtheme = theme_gray() ,
          add = "jitter") + stat_compare_means(comparisons = my_comparisons)+ # Add pairwise comparisons p-value
  stat_compare_means(label.y = 3.25,method = 'anova') + theme(legend.position = "none") 

p

pdf('output/GSTM1_all_group.pdf')
plot(p)
dev.off()


