

Examples

## Example 1: two-group comparison

dds <- makeExampleDESeqDataSet(m=4)

dds <- DESeq(dds)
res <- results(dds, contrast=c("condition","B","A"))

# with more than two groups, the call would look similar, e.g.:
# results(dds, contrast=c("condition","C","A"))
# etc.

## Example 2: two conditions, two genotypes, with an interaction term

dds <- makeExampleDESeqDataSet(n=100,m=12)
dds$genotype <- factor(rep(rep(c("I","II"),each=3),2))

design(dds) <- ~ genotype + condition + genotype:condition
dds <- DESeq(dds) 
resultsNames(dds)

# Note: design with interactions terms by default have betaPrior=FALSE

# the condition effect for genotype I (the main effect)
results(dds, contrast=c("condition","B","A"))

# the condition effect for genotype II
# this is, by definition, the main effect *plus* the interaction term
# (the extra condition effect in genotype II compared to genotype I).
results(dds, list( c("condition_B_vs_A","genotypeII.conditionB") ))

# the interaction term, answering: is the condition effect *different* across genotypes?
results(dds, name="genotypeII.conditionB")

## Example 3: two conditions, three genotypes

# ~~~ Using interaction terms ~~~

dds <- makeExampleDESeqDataSet(n=100,m=18)
dds$genotype <- factor(rep(rep(c("I","II","III"),each=3),2))
design(dds) <- ~ genotype + condition + genotype:condition
dds <- DESeq(dds)
resultsNames(dds)

# the condition effect for genotype I (the main effect)
results(dds, contrast=c("condition","B","A"))

# the condition effect for genotype III.
# this is the main effect *plus* the interaction term
# (the extra condition effect in genotype III compared to genotype I).
results(dds, contrast=list( c("condition_B_vs_A","genotypeIII.conditionB") ))

# the interaction term for condition effect in genotype III vs genotype I.
# this tests if the condition effect is different in III compared to I
results(dds, name="genotypeIII.conditionB")

# the interaction term for condition effect in genotype III vs genotype II.
# this tests if the condition effect is different in III compared to II
results(dds, contrast=list("genotypeIII.conditionB", "genotypeII.conditionB"))

# Note that a likelihood ratio could be used to test if there are any
# differences in the condition effect between the three genotypes.

# ~~~ Using a grouping variable ~~~

# This is a useful construction when users just want to compare
# specific groups which are combinations of variables.

dds$group <- factor(paste0(dds$genotype, dds$condition))
design(dds) <- ~ group
dds <- DESeq(dds)
resultsNames(dds)

# the condition effect for genotypeIII
results(dds, contrast=c("group", "IIIB", "IIIA"))
