
library(ggplot2)
library(clusterProfiler)
library(enrichplot)

##################
# GSEA analysis #
#################

############################################
# get all the gene no matter the threshold #
############################################

f1 <- read.delim('~/Desktop/TT_test.txt')
f1 = f1[,c(1,7,8)]
f1$log2fc = f1$ID94.and.52/f1$ID69.and.30


# same thing
gene_rank <- setNames(f1$log2fc, casefold(f1$Name , upper = T))
#barplot(sort(ranks, decreasing = T))
gene_list = sort(gene_rank, decreasing = TRUE)

library(msigdbr)
msigdbgmt <- msigdbr::msigdbr("Homo sapiens")
msigdbgmt <- as.data.frame(msigdbgmt)
unique(msigdbgmt$gs_subcat)
# subset geneset msigdbgmt$
msigdbgmt_subset <- msigdbgmt[msigdbgmt$gs_cat == "H", ]

#m_df<- msigdbr(species = "Homo sapiens", category = "C2")
#fgsea_sets<- m_df %>% split(x = .$gene_symbol, f = .$gs_name)


gmt <- lapply(unique(msigdbgmt_subset$gs_name), function(x) {
  msigdbgmt_subset[msigdbgmt_subset$gs_name == x, "gene_symbol"]
})

names(gmt) <- unique(paste0(msigdbgmt_subset$gs_name))
# run gsea

library(fgsea)

# Perform enrichemnt analysis
fgseaRes <- fgsea(pathways = gmt, stats = gene_rank, minSize = 15, maxSize = 500)
fgseaRes <- fgseaRes[order(fgseaRes$NES, decreasing = T), ]

# Filter the results table to show only the top 10 UP or DOWN regulated
# processes (optional)

# other way 
top10_UP <- fgseaRes$pathway[1:10]

# Nice summary table (shown as a plot)
dev.off()
plotGseaTable(gmt[top10_UP], gene_rank, fgseaRes, gseaParam = 0.5)

## ggplot

ggplot(fgseaRes[1:10] , aes(reorder(pathway, NES), NES)) +
  geom_col(aes(fill= NES < 0)) +
  coord_flip() +
  labs(x="Pathway", y="Normalized Enrichment Score",
       title="Hallmark pathways NES from GSEA") + 
  theme_minimal()


## vlnplot to show gene expression

organism = "org.Hs.eg.db"
library("org.Hs.eg.db", character.only = TRUE)



gse <- gseGO(geneList=gene_list, 
             ont ="ALL", 
             keyType = "SYMBOL", 
             nPerm = 10000, 
             minGSSize = 3, 
             maxGSSize = 800, 
             pvalueCutoff = 0.05, 
             verbose = TRUE, 
             OrgDb = organism, 
             pAdjustMethod = "none")
# KEGG



# Convert gene IDs for gseKEGG function
# We will lose some genes here because not all IDs will be converted
ids<-bitr(names(gene_list), fromType = "SYMBOL", toType = "ENTREZID", OrgDb=organism)
# remove duplicate IDS (here I use "ENSEMBL", but it should be whatever was selected as keyType)
dedup_ids = ids[!duplicated(ids[c("SYMBOL")]),]

# Create a new dataframe df2 which has only the genes which were successfully mapped using the bitr function above
df2 = f1[f1$Name %in% dedup_ids$SYMBOL,]

# Create a new column in df2 with the corresponding ENTREZ IDs
df2$Y = dedup_ids$ENTREZID

# Create a vector of the gene unuiverse
kegg_gene_list <- df2$log2fc

# Name vector with ENTREZ ids
names(kegg_gene_list) <- df2$Y

# omit any NA values 
kegg_gene_list<-na.omit(kegg_gene_list)

# sort the list in decreasing order (required for clusterProfiler)
kegg_gene_list = sort(kegg_gene_list, decreasing = TRUE)

kk2 <- gseKEGG(geneList     = kegg_gene_list,
               organism     = "hsa",
               nPerm        = 10000,
               minGSSize    = 3,
               maxGSSize    = 800,
               pvalueCutoff = 0.05,
               pAdjustMethod = "none",
               keyType       = "kegg")


require(DOSE)
dotplot(kk2, showCategory=10, split=".sign",font.size = 8) + facet_grid(.~.sign)  


