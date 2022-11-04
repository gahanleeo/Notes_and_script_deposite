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

#####################
# Merge replicates #
####################

####
#3D#
####

RT4_3D_1 = 'Desktop/Parse_10X_singel_cell_project/result/combined/High_Round 3 RT4 3D_2022 02 04/DGE_filtered/'
mat <- ReadParseBio(RT4_3D_1)
table(rownames(mat) == "")
rownames(mat)[rownames(mat) == ""] <- "unknown"
cell_meta <- read.csv(paste0(RT4_3D_1, "/cell_metadata.csv"), row.names = 1)

RT4_3D_1  <- CreateSeuratObject(mat, min.features = 200, min.cells = 3,
                           names.feild = 0, meta.data = cell_meta)


RT4_3D_2 = 'Desktop/Parse_10X_singel_cell_project/result/combined/Low round 3 RT4 3D_2022 02 04/DGE_filtered/'
mat <- ReadParseBio(RT4_3D_2)
table(rownames(mat) == "")
rownames(mat)[rownames(mat) == ""] <- "unknown"
cell_meta <- read.csv(paste0(RT4_3D_2, "/cell_metadata.csv"), row.names = 1)

RT4_3D_2  <- CreateSeuratObject(mat, min.features = 200, min.cells = 3,
                                names.feild = 0, meta.data = cell_meta)



RT4_3D_3 = 'Desktop/Parse_10X_singel_cell_project/result/combined/Round 4 RT4 3D_2022 02 09/DGE_filtered/'
mat <- ReadParseBio(RT4_3D_3)
table(rownames(mat) == "")
rownames(mat)[rownames(mat) == ""] <- "unknown"
cell_meta <- read.csv(paste0(RT4_3D_3, "/cell_metadata.csv"), row.names = 1)

RT4_3D_3  <- CreateSeuratObject(mat, min.features = 200, min.cells = 3,
                                names.feild = 0, meta.data = cell_meta)



RT4_3D.big <- merge(RT4_3D_1, y = c(RT4_3D_2, RT4_3D_3), add.cell.ids = c("3D1", "3D2", "3D3"), project = "RT4_3D")

RT4_3D.big

SaveObject(object = RT4_3D.big,'RT4_3D_merged')

######
# 2D #
######


RT4_2D_1 = 'Desktop/Parse_10X_singel_cell_project/result/combined/High round 3 RT4 2D_2022 02 04/DGE_filtered/'
mat <- ReadParseBio(RT4_2D_1)
table(rownames(mat) == "")
rownames(mat)[rownames(mat) == ""] <- "unknown"
cell_meta <- read.csv(paste0(RT4_2D_1, "/cell_metadata.csv"), row.names = 1)

RT4_2D_1  <- CreateSeuratObject(mat, min.features = 200, min.cells = 3,
                                names.feild = 0, meta.data = cell_meta)


RT4_2D_2 = 'Desktop/Parse_10X_singel_cell_project/result/combined/Low round 3 RT4 2D_2022 02 04/DGE_filtered/'
mat <- ReadParseBio(RT4_2D_2)
table(rownames(mat) == "")
rownames(mat)[rownames(mat) == ""] <- "unknown"
cell_meta <- read.csv(paste0(RT4_2D_2, "/cell_metadata.csv"), row.names = 1)

RT4_2D_2  <- CreateSeuratObject(mat, min.features = 200, min.cells = 3,
                                names.feild = 0, meta.data = cell_meta)


RT4_2D_3 = 'Desktop/Parse_10X_singel_cell_project/result/combined/Round 4 RT4 2D_2022 02 09/DGE_filtered/'
mat <- ReadParseBio(RT4_2D_3)
table(rownames(mat) == "")
rownames(mat)[rownames(mat) == ""] <- "unknown"
cell_meta <- read.csv(paste0(RT4_2D_3, "/cell_metadata.csv"), row.names = 1)

RT4_2D_3  <- CreateSeuratObject(mat, min.features = 200, min.cells = 3,
                                names.feild = 0, meta.data = cell_meta)


RT4_2D.big <- merge(RT4_2D_1, y = c(RT4_2D_2, RT4_2D_3), add.cell.ids = c("2D1", "2D2", "2D3"), project = "RT4_2D")

RT4_2D.big


SaveObject(object = RT4_2D.big,'RT4_2D_merged')

pbmc = RT4_2D.big 


# Setting our initial cell class to a single type, this will changer after clustering. 
pbmc@meta.data$orig.ident <- factor(rep("pbmc", nrow(pbmc@meta.data)))
Idents(pbmc) <- pbmc@meta.data$orig.ident

#SaveObject(pbmc, "seurat_obj_before_QC")
#pbmc <- ReadObject("seurat_obj_before_QC")


#############
## Cell QC ##
#############

pbmc[["percent.mt"]] <- PercentageFeatureSet(pbmc, pattern = "^MT-")
VlnPlot(pbmc, pt.size = 0.10,
                features = c("nFeature_RNA", "nCount_RNA", "percent.mt"), ncol = 3)
# SaveFigure(plot, "vln_QC", width = 12, height = 6)

plot1 <- FeatureScatter(pbmc, feature1 = "nCount_RNA", feature2 = "percent.mt")
plot2 <- FeatureScatter(pbmc, feature1 = "nCount_RNA", feature2 = "nFeature_RNA")

plot1
plot2

# SaveFigure((plot1 + plot2),"scatter_QC", width = 12, height = 6, res = 200)

# Perform the filtering # percent.mt < 15 / or 60 
pbmc <- subset(pbmc, subset = nFeature_RNA < 9000 & nCount_RNA < 100000 & percent.mt <30)


# save the seruat object for intergation analysis? 
# SaveObject(pbmc, 'seurat_obj_after_QC')

########################
# Normalizing the data # 
########################

pbmc <- NormalizeData(pbmc, normalization.method = "LogNormalize", scale.factor = 10000)

###############################################
# Identification of highly variable features #
##############################################

pbmc <- FindVariableFeatures(pbmc, selection.method = "vst", nfeatures = 2000)
# Identify the 10 most highly variable genes
top10 <- head(VariableFeatures(pbmc), 10)
# plot variable features with and without labels
plot1 <- VariableFeaturePlot(pbmc)
plot2 <- LabelPoints(plot = plot1, points = top10, repel = TRUE)
# SaveFigure((plot1 + plot2), "var_features", width = 12, height = 6)
plot2
#####################
# Scaling the data #
####################

# This step gives equal weight in downstream analyses,
# so that highly-expressed genes do not dominate.
# The results of this are stored in pbmc[["RNA"]]@scale.data

pbmc <- ScaleData(pbmc)

####################################
# PCA, linear dimensional reduction#
####################################

pbmc <- RunPCA(pbmc)

# SaveObject(pbmc, "seurat_obj_after_PCA")
# pbmc <- ReadObject("seurat_obj_after_PCA")

# Examine and visualize PCA results a few different ways
print(pbmc[["pca"]], dims = 1:5, nfeatures = 5)

#plot <- VizDimLoadings(pbmc, dims = 1:2, reduction = "pca")
# SaveFigure(plot, "viz_PCA_loadings", width = 10, height = 8)

plot <- DimPlot(pbmc, reduction = "pca" , group.by = "orig.ident")
plot
# SaveFigure(plot, "pc1_2_scatter", width = 8, height = 6)

plot <- DimHeatmap(pbmc, dims = 1, cells = 500, balanced = TRUE, fast = FALSE)
plot

DimHeatmap(pbmc, dims = 1:15, cells = 500, balanced = TRUE, fast = FALSE)

##################################################
# Determine the 'dimensionality' of the dataset #
##################################################

# NOTE: This process can take a long time for big datasets, comment out for expediency. More
# approximate techniques such as those implemented in ElbowPlot() can be used to reduce
# computation time

pbmc <- JackStraw(pbmc, num.replicate = 100)
pbmc <- ScoreJackStraw(pbmc, dims = 1:20)

JackStrawPlot(pbmc, dims = 1:15)
ElbowPlot(pbmc)

# find elbow and slect the PCA number for clusting cells

# ex: choose 1 to 30 ..

#####################
# Cluster the cells #
#####################

pbmc <- FindNeighbors(pbmc, dims = 1:50)
pbmc <- FindClusters(pbmc, resolution = 0.50) #  We find that setting resolution parameter between 0.4-1.2 

###################################################
# Reorder clusters according to their similarity # 
###################################################

pbmc <- BuildClusterTree(pbmc, reorder = TRUE, reorder.numeric = TRUE)

#####################################################
# Run non-linear dimensional reduction (UMAP/tSNE) # 
#####################################################

pbmc <- RunUMAP(pbmc, dims = 1:50)
DimPlot(pbmc, reduction = "umap")
 DimPlot(pbmc, reduction = "umap", label = TRUE) 

# SaveFigure(plot, "umap_louvain_res_p3", width = 9, height = 8)


# can save object as clusterd 
# SaveObject(pbmc, "seurat_obj_clustered")
# pbmc <- ReadObject("seurat_obj_clustered")

###########################################################
# Differential gene expression (finding cluster markers) # 
###########################################################
 
# group_by is dplyr() function, Group data into rows with the same value in group_by()
 
cluster1.markers <- FindMarkers(pbmc, ident.1 = 1, min.pct = 0.25)
head(cluster1.markers, n = 5)

cluster2.markers <- FindMarkers(pbmc, ident.1 = 2, min.pct = 0.25)
head(cluster2.markers, n = 5)



#pbmc_markers <- FindAllMarkers(pbmc , min.pct = 0.25, logfc.threshold = 0.25)
#pbmc_markers %>% group_by(cluster) %>% top_n(n = 2, wt = avg_log2FC)

pbmc.markers <- FindAllMarkers(pbmc, only.pos = TRUE, min.pct = 0.25, logfc.threshold = 0.25)
pbmc.markers %>%
  group_by(cluster) %>%
  slice_max(n = 2, order_by = avg_log2FC)

plot <- VlnPlot(pbmc, features = c("LINC01811", "ABCA9","FAM78B","DHRS2","AC016205.1"))
plot

FeaturePlot(pbmc, features = c("PAG1", "LCORL","DUSP16","ACSF2","PRICKLE2"))

# SaveFigure(plot, "vln_exp1", width = 16, height = 8)

############################################
# Visualizing the top n genes per cluster # 
############################################

top5 <- pbmc_markers %>% group_by(cluster) %>% top_n(n = 5, wt = avg_log2FC)
to_plot <- unique(top5$gene)
DotPlot(pbmc, features = to_plot, group.by = "tree.ident") + coord_flip()
# SaveFigure(plot, "dplot_top5", width = 9, height = 20)

plot

pbmc.markers %>%
  group_by(cluster) %>%
  top_n(n = 10, wt = avg_log2FC) -> top10
DoHeatmap(pbmc, features = top10$gene) + NoLegend()



## for compare different conditions : 
# https://satijalab.org/seurat/articles/integration_introduction.html


