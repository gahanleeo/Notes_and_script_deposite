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

#######
#######

data_path = "~/Desktop/Parse_10X_singel_cell_project/Seurat_output/"
fig_path = "~/Desktop/Parse_10X_singel_cell_project/Seurat_output/Seurat_fig_out/"


################
#Reading data###
################

########################################
#3D high round and low round comparism #
########################################



mat_path <- "~/Desktop/Parse_10X_singel_cell_project/result/combined/High_Round 3 RT4 3D_2022 02 04/DGE_filtered/"
mat <- ReadParseBio(mat_path)

# Check to see if empty gene names are present, add name if so.
table(rownames(mat) == "")
rownames(mat)[rownames(mat) == ""] <- "unknown"

# Read in cell meta data
cell_meta <- read.csv(paste0(mat_path, "/cell_metadata.csv"), row.names = 1)


RT4_3D = readRDS(file = 'Desktop/Parse_10X_singel_cell_project/Seurat_output/RT4_3D_merged.RDS')
RT4_3D@meta.data$orig.ident <- factor(rep("RT4_3D", nrow(RT4_3D@meta.data)))
Idents(RT4_3D) <- RT4_3D@meta.data$orig.ident

RT4_3D[["percent.mt"]] <- PercentageFeatureSet(RT4_3D, pattern = "^MT-")
VlnPlot(RT4_3D, pt.size = 0.10,
        features = c("nFeature_RNA", "nCount_RNA", "percent.mt"), ncol = 3)


# Perform the filtering # percent.mt < 15 / or 60 
RT4_3D <- subset(RT4_3D, subset = nFeature_RNA < 10000 & nCount_RNA < 30000 & percent.mt <20)


######
# 2D #
######

RT4_2D = readRDS(file = 'Desktop/Parse_10X_singel_cell_project/Seurat_output/RT4_2D_merged.RDS')
RT4_2D@meta.data$orig.ident <- factor(rep("RT4_2D", nrow(RT4_2D@meta.data)))
Idents(RT4_2D) <- RT4_2D@meta.data$orig.ident



RT4_2D[["percent.mt"]] <- PercentageFeatureSet(RT4_2D, pattern = "^MT-")
VlnPlot(RT4_2D, pt.size = 0.10,
                features = c("nFeature_RNA", "nCount_RNA", "percent.mt"), ncol = 3)

# Perform the filtering # percent.mt < 15 / or 60 
RT4_2D <- subset(RT4_2D, subset = nFeature_RNA < 12000 & nCount_RNA < 50000 & percent.mt <30)


RT4.list = c(RT4_2D,RT4_3D)


########################
# Normalizing the data # 
########################

RT4.list <- lapply(X = RT4.list, FUN = function(x) {
  x <- NormalizeData(x)
  x <- FindVariableFeatures(x, selection.method = "vst", nfeatures = 2000)
})

# select features that are repeatedly variable across datasets for integration
features <- SelectIntegrationFeatures(object.list = RT4.list)

# perform anchor # 

RT4.anchors <- FindIntegrationAnchors(object.list = RT4.list, anchor.features = features)

# this command creates an 'integrated' data assay
RT4.combined <- IntegrateData(anchorset = RT4.anchors)


# Perform an integrated analysis # 

# specify that we will perform downstream analysis on the corrected data note that the
# original unmodified data still resides in the 'RNA' assay

DefaultAssay(RT4.combined) <- "integrated"

# Run the standard workflow for visualization and clustering
RT4.combined <- ScaleData(RT4.combined, verbose = FALSE)
RT4.combined <- RunPCA(RT4.combined, npcs = 30, verbose = FALSE)
RT4.combined <- RunUMAP(RT4.combined, reduction = "pca", dims = 1:30)
RT4.combined <- FindNeighbors(RT4.combined, reduction = "pca", dims = 1:30)

# below process change identation to 1...6 
RT4.combined <- FindClusters(RT4.combined, resolution = 0.5)

# optional, Reorder clusters according to their similarity
# RT4.combined <- BuildClusterTree(RT4.combined, reorder = TRUE, reorder.numeric = TRUE)



# Visualization

DimPlot(RT4.combined, reduction = "umap")
DimPlot(RT4.combined, reduction = "umap", split.by = "sample")



####################################
# finding marker based on cluster #
###################################





markers_3D <- FindMarkers(RT4.combined, ident.1 = 4 , min.pct = 0.25)
head(markers_3D, n = 5)


# find all marker 
all_marker <- FindAllMarkers(RT4.combined, only.pos = TRUE, min.pct = 0.25, logfc.threshold = 0.25)
tt = all_marker %>%
  group_by(cluster) %>%
  slice_max(n = 2, order_by = avg_log2FC)
#
tt1 = all_marker %>% group_by(cluster) %>% top_n(n = 2, wt = avg_log2FC)

# top 5 smallest padj genes # 


all_marker %>%
  group_by(cluster) %>%
  top_n(-5, p_val_adj) -> top5

top5 %>%
  group_by(cluster) %>%
  top_n(-2, p_val) -> top3


VlnPlot(RT4.combined, features = as.character(unique(tt1$gene)), ncol = 6,
         pt.size = 0)




##################################################
### FINDING DIFFERENTED GENE from 3D vs 2D   ###
#################################################


DefaultAssay(RT4.combined) <- "RNA"

# set Ident between 2D and 3D 
test3D_vs_2D <- SetIdent(RT4.combined, value = "orig.ident")

# differentaion analysis 

DGE_cell_selection <- FindAllMarkers(test3D_vs_2D, logfc.threshold = 0.2, test.use = "wilcox",
                                     min.pct = 0.1, min.diff.pct = 0.2, only.pos = T, max.cells.per.ident = 50,
                                     assay = "RNA")

# plot expression, find most sign p-val
# n = top n ...

DGE_cell_selection %>%
  group_by(cluster) %>%
  top_n(-3, p_val) -> top5_cell_selection

VlnPlot(test3D_vs_2D, features = as.character(unique(top5_cell_selection$gene)),
        ncol = 3, group.by = "orig.ident", assay = "RNA", pt.size = 0.1)

FeaturePlot(test3D_vs_2D, features = as.character(unique(top5_cell_selection$gene)),  max.cutoff = 3, cols = c("grey", "red"))

# Visualizing the top n genes per indent

DotPlot(test3D_vs_2D, features = as.character(unique(DGE_cell_selection$gene)), group.by = "orig.ident") + coord_flip()




# compare low only 
# and  high only

###############
## referecne###
###############


# https://satijalab.org/seurat/articles/de_vignette.html
# https://satijalab.org/seurat/articles/integration_introduction.html
# https://nbisweden.github.io/workshop-scRNAseq/labs/compiled/seurat/seurat_05_dge.html

