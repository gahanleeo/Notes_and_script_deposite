## Seurat 4.1.0 for parse downstream analysis ##

library(Seurat)
library(dplyr)
library(Matrix)
library(ggplot2)

# Convenience functions#

SaveFigure <- function(plots, name, type = "png", width, height, res){
  if(type == "png") {
    png(paste0(fig_path, name, ".", type),
        width = width, height = height, units = "in", res = 200)
  } else {
    pdf(paste0(fig_path, name, ".", type),
        width = width, height = height)
  }
  print(plots)
  dev.off()
}

SaveObject <- function(object, name){
  saveRDS(object, paste0(data_path, name, ".RDS"))
}

ReadObject <- function(name){
  readRDS(paste0(data_path, name, ".RDS"))
}

data_path = "~/Desktop/Parse_10X_singel_cell_project/Seurat_output/"
fig_path = "~/Desktop/Parse_10X_singel_cell_project/Seurat_output/Seurat_fig_out/"


################
#Reading data###
################


mat_path <- "~/Desktop/Parse_10X_singel_cell_project/result/combined/Round 4 RT4 3D_2022 02 09/DGE_filtered/"
mat <- ReadParseBio(mat_path)

# Check to see if empty gene names are present, add name if so.
table(rownames(mat) == "")
rownames(mat)[rownames(mat) == ""] <- "unknown"

# Read in cell meta data
cell_meta <- read.csv(paste0(mat_path, "/cell_metadata.csv"), row.names = 1)


r3Dround <- CreateSeuratObject(mat,min.features =100, min.cells = 3,
                              names.feild = 0, meta.data = cell_meta)

# Setting our initial cell class to a single type, this will changer after clustering. 
r3Dround@meta.data$orig.ident <- factor(rep("RT4_round_3D", nrow(r3Dround@meta.data)))
Idents(r3Dround) <- r3Dround@meta.data$orig.ident


r3Dround[["percent.mt"]] <- PercentageFeatureSet(r3Dround, pattern = "^MT-")

VlnPlot(r3Dround, pt.size = 0.10,
        features = c("nFeature_RNA", "nCount_RNA", "percent.mt"), ncol = 3)

r3Dround <- subset(r3Dround, subset = nFeature_RNA > 200 & nFeature_RNA < 7500 & percent.mt < 15 & nCount_RNA < 20000)

# load RT4_2D file 

mat_path <- "~/Desktop/Parse_10X_singel_cell_project/result/combined/High round 3 RT4 2D_2022 02 04/DGE_filtered/"
mat <- ReadParseBio(mat_path)

# Check to see if empty gene names are present, add name if so.
table(rownames(mat) == "")
rownames(mat)[rownames(mat) == ""] <- "unknown"

# Read in cell meta data
cell_meta <- read.csv(paste0(mat_path, "/cell_metadata.csv"), row.names = 1)


r2Dround <- CreateSeuratObject(mat,min.features =100, min.cells = 3,
                              names.feild = 0, meta.data = cell_meta)

# Setting our initial cell class to a single type, this will changer after clustering. 
r2Dround@meta.data$orig.ident <- factor(rep("RT4_round_2D", nrow(r2Dround@meta.data)))
Idents(Control) <- r2Dround@meta.data$orig.ident


Control[["percent.mt"]] <- PercentageFeatureSet(r2Dround, pattern = "^MT-")

VlnPlot(Control, pt.size = 0.10,
        features = c("nFeature_RNA", "nCount_RNA", "percent.mt"), ncol = 3)


r2Dround <- subset(r2Dround, subset = nFeature_RNA > 200 & nFeature_RNA < 7500 & percent.mt < 15 & nCount_RNA < 20000)


# merge the 2 object, 2d and 3d 
rt4_round = merge(r2Dround,y = r3Dround,add.cell.ids = c("round_2D", "round_3D"), project = "RT4_round")

########################
# Normalizing the data # 
########################

RT4_round = ReadObject('RT4_high_round_combined')

RT4_round <- NormalizeData(RT4_round, normalization.method = "LogNormalize", scale.factor = 10000)

###############################################
# Identification of highly variable features #
##############################################

RT4_round <- FindVariableFeatures(RT4_round, selection.method = "vst", nfeatures = 2000)
# Identify the 10 most highly variable genes
top10 <- head(VariableFeatures(RT4_round), 10)
# plot variable features with and without labels
plot1 <- VariableFeaturePlot(RT4_round)
plot2 <- LabelPoints(plot = plot1, points = top10, repel = TRUE)
# SaveFigure((plot1 + plot2), "var_features", width = 12, height = 6)
plot2
#####################
# Scaling the data #
####################

# This step gives equal weight in downstream analyses,
# so that highly-expressed genes do not dominate.
# The results of this are stored in RT4_round[["RNA"]]@scale.data

all.genes <- rownames(RT4_round)
RT4_round <- ScaleData(RT4_round, features = all.genes)

####################################
# PCA, linear dimensional reduction#
####################################

RT4_round <- RunPCA(RT4_round, features = VariableFeatures(object = RT4_round))

# SaveObject(RT4_round, "seurat_obj_after_PCA")
# RT4_round <- ReadObject("seurat_obj_after_PCA")

# Examine and visualize PCA results a few different ways
print(RT4_round[["pca"]], dims = 1:5, nfeatures = 5)

#plot <- VizDimLoadings(RT4_round, dims = 1:2, reduction = "pca")
# SaveFigure(plot, "viz_PCA_loadings", width = 10, height = 8)

plot <- DimPlot(RT4_round, reduction = "pca" , group.by = "orig.ident")
plot
# SaveFigure(plot, "pc1_2_scatter", width = 8, height = 6)

plot <- DimHeatmap(RT4_round, dims = 1, cells = 500, balanced = TRUE, fast = FALSE)
plot

DimHeatmap(RT4_round, dims = 1:15, cells = 500, balanced = TRUE, fast = FALSE)

##################################################
# Determine the 'dimensionality' of the dataset #
##################################################

# NOTE: This process can take a long time for big datasets, comment out for expediency. More
# approximate techniques such as those implemented in ElbowPlot() can be used to reduce
# computation time

RT4_round <- JackStraw(RT4_round, num.replicate = 100)
RT4_round <- ScoreJackStraw(RT4_round, dims = 1:20)

JackStrawPlot(RT4_round, dims = 1:20)
ElbowPlot(RT4_round)

# find elbow and slect the PCA number for clusting cells

# ex: choose 1 to 30 ..

#####################
# Cluster the cells #
#####################

RT4_round <- FindNeighbors(RT4_round, dims = 1:15)
RT4_round <- FindClusters(RT4_round, resolution = 0.50) #  We find that setting resolution parameter between 0.4-1.2 

###################################################
# Reorder clusters according to their similarity # 
###################################################

RT4_round <- BuildClusterTree(RT4_round, reorder = TRUE, reorder.numeric = TRUE)

#####################################################
# Run non-linear dimensional reduction (UMAP/tSNE) # 
#####################################################

RT4_round <- RunUMAP(RT4_round, dims = 1:15)
DimPlot(RT4_round, reduction = "umap",split.by = 'orig.ident')
 DimPlot(RT4_round, reduction = "umap", label = TRUE) 
 DimPlot(RT4_round, reduction = "umap",group.by = 'orig.ident')

###########################################################
# Differential gene expression (finding cluster markers) # 
###########################################################
 
# set idents for diff analysis
 
Idents(RT4_round) = factor(RT4_round@meta.data$orig.ident)
RT4_round = RenameIdents(RT4_round,`high_2D` = 'RT4_2D', `high_3D` = 'RT4_3D')
 
diffmarkers <- FindMarkers(RT4_round, ident.1 = 'high_3D', log2FC.threshold = 0,
                            min.pct = 0.25,  only.pos = F)

diffmarkers$gene = rownames(diffmarkers)

head(diffmarkers, n = 5)

tt = diffmarkers %>% 
  top_n(n = 5, wt = avg_log2FC)

fe = tt$gene 

VlnPlot(RT4_round, features = fe,group.by = 'orig.ident')


FeaturePlot(RT4_round, features = fe)

# SaveFigure(plot, "vln_exp1", width = 16, height = 8)



##################
# GSEA analysis #
#################

############################################
# get all the gene no matter the threshold #
############################################

diffmarkers <- FindMarkers(RT4_round, ident.1 = 'RT4_3D',ident.2 = 'RT4_2D', logfc.threshold =  0
                           , only.pos = FALSE,min.pct = 0.1, assay = "RNA" )


diffmarkers$gene = rownames(diffmarkers)

gene_rank <- setNames(diffmarkers$avg_log2FC, casefold(rownames(diffmarkers),
                                                       upper = T))
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

fgseaRes<- fgsea(fgsea_sets,stats = gene_rank, minSize = 15, maxSize = 500,eps=0 )

fgseaResTidy <- fgseaRes %>%
  as_tibble() %>%
  arrange(desc(NES))
# ?
fgseaResTidy %>% 
  dplyr::select(-leadingEdge, -NES) %>% 
  arrange(padj) %>% 
  head()

top10_UP <- fgseaRes$pathway[1:10]

# Nice summary table (shown as a plot)
dev.off()
plotGseaTable(gmt[top10_UP], gene_rank, fgseaRes, gseaParam = 0.5)

## ggplot

ggplot(fgseaRes %>% filter(pval < 0.05) , aes(reorder(pathway, NES), NES)) +
  geom_col(aes(fill= NES < 0)) +
  coord_flip() +
  labs(x="Pathway", y="Normalized Enrichment Score",
       title="Hallmark pathways NES from GSEA") + 
  theme_minimal()


## vlnplot to show gene expression



#####
# gene list from PNAS
#####


stem_genes <- c("KRT14", "KRT5", "ITGB4", "CD44", "TP63", "KRT17", "KRT6A", "KRT6B", "KRT6C")
differentiation_genes <- c("KRT20", "KRT8", "KRT18", "UPK1A", "UPK1B", "UPK2", "UPK3A", "UPK3B")

basal_genes <- c( "STAT3", "JAK2", "ITGA6", "KRT17", "CD44",'TP63')
lumnial_genes <- c("UPK1B","FOXA1","GRHL2" , "GATA3", "KRT18","KRT8")


VlnPlot(RT4_round, features = lumnial_genes)


#### 
# how to calculate the gene count in Vlnplot?
####
for (i in basal_genes ){
  p = VlnPlot(RT4_round, features = i)
  print(p$data  %>% group_by(ident) %>% summarize(counts = sum(get(i), na.rm = TRUE)))
  
}

p = VlnPlot(RT4_round, features = "STAT3")
p$data  %>% group_by(ident) %>% summarize(counts = sum(STAT3, na.rm = TRUE))

diffmarkers$gene = rownames(diffmarkers
                            )
Selection<-diffmarkers[diffmarkers$gene %in% basal_genes,]
