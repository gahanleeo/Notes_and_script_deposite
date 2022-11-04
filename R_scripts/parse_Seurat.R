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


mat_path <- "~/Desktop/Parse_10X_singel_cell_project/result/combined/High_Round 3 RT4 3D_2022 02 04/DGE_filtered/"
mat <- ReadParseBio(mat_path)

# Check to see if empty gene names are present, add name if so.
table(rownames(mat) == "")
rownames(mat)[rownames(mat) == ""] <- "unknown"

# Read in cell meta data
cell_meta <- read.csv(paste0(mat_path, "/cell_metadata.csv"), row.names = 1)


########################
# Normalizing the data # 
########################

RT4_high_round <- NormalizeData(RT4_high_round, normalization.method = "LogNormalize", scale.factor = 10000)

###############################################
# Identification of highly variable features #
##############################################

RT4_high_round <- FindVariableFeatures(RT4_high_round, selection.method = "vst", nfeatures = 2000)
# Identify the 10 most highly variable genes
top10 <- head(VariableFeatures(RT4_high_round), 10)
# plot variable features with and without labels
VariableFeaturePlot(RT4_high_round)
plot2 <- LabelPoints(plot = plot1, points = top10, repel = TRUE)
# SaveFigure((plot1 + plot2), "var_features", width = 12, height = 6)
plot2
#####################
# Scaling the data #
####################

# This step gives equal weight in downstream analyses,
# so that highly-expressed genes do not dominate.
# The results of this are stored in RT4_high_round[["RNA"]]@scale.data

RT4_high_round <- ScaleData(RT4_high_round)

####################################
# PCA, linear dimensional reduction#
####################################

RT4_high_round <- RunPCA(RT4_high_round)

# SaveObject(RT4_high_round, "seurat_obj_after_PCA")
# RT4_high_round <- ReadObject("seurat_obj_after_PCA")

# Examine and visualize PCA results a few different ways
print(RT4_high_round[["pca"]], dims = 1:5, nfeatures = 5)

#plot <- VizDimLoadings(RT4_high_round, dims = 1:2, reduction = "pca")
# SaveFigure(plot, "viz_PCA_loadings", width = 10, height = 8)

plot <- DimPlot(RT4_high_round, reduction = "pca" , group.by = "orig.ident")
plot
# SaveFigure(plot, "pc1_2_scatter", width = 8, height = 6)

plot <- DimHeatmap(RT4_high_round, dims = 1, cells = 500, balanced = TRUE, fast = FALSE)
plot

DimHeatmap(RT4_high_round, dims = 1:15, cells = 500, balanced = TRUE, fast = FALSE)

##################################################
# Determine the 'dimensionality' of the dataset #
##################################################

# NOTE: This process can take a long time for big datasets, comment out for expediency. More
# approximate techniques such as those implemented in ElbowPlot() can be used to reduce
# computation time

RT4_high_round <- JackStraw(RT4_high_round, num.replicate = 100)
RT4_high_round <- ScoreJackStraw(RT4_high_round, dims = 1:20)

JackStrawPlot(RT4_high_round, dims = 1:15)
ElbowPlot(RT4_high_round)

# find elbow and slect the PCA number for clusting cells

# ex: choose 1 to 30 ..

#####################
# Cluster the cells #
#####################

RT4_high_round <- FindNeighbors(RT4_high_round, dims = 1:30)
RT4_high_round <- FindClusters(RT4_high_round, resolution = 0.50) #  We find that setting resolution parameter between 0.4-1.2 

###################################################
# Reorder clusters according to their similarity # 
###################################################

RT4_high_round <- BuildClusterTree(RT4_high_round, reorder = TRUE, reorder.numeric = TRUE)

#####################################################
# Run non-linear dimensional reduction (UMAP/tSNE) # 
#####################################################

RT4_high_round = ReadObject('all-well_normalized')

RT4_high_round <- RunUMAP(RT4_high_round, dims = 1:30)
DimPlot(RT4_high_round, reduction = "umap",split.by = 'sample')
 DimPlot(RT4_high_round, reduction = "umap", label = TRUE) 
 DimPlot(RT4_high_round, reduction = "umap",group.by = 'sample')


# SaveFigure(plot, "umap_louvain_res_p3", width = 9, height = 8)


# can save object as clusterd 
# SaveObject(RT4_high_round, "seurat_obj_clustered")
# RT4_high_round <- ReadObject("seurat_obj_clustered")

###########################################################
# Differential gene expression (finding cluster markers) # 
###########################################################
 
# group_by is dplyr() function, Group data into rows with the same value in group_by()
 
cluster1.markers <- FindMarkers(RT4_high_round, ident.1 = 1, min.pct = 0.25)
head(cluster1.markers, n = 5)

cluster2.markers <- FindMarkers(RT4_high_round, ident.1 = 2, min.pct = 0.25)
head(cluster2.markers, n = 5)



#RT4_high_round_markers <- FindAllMarkers(RT4_high_round , min.pct = 0.25, logfc.threshold = 0.25)
#RT4_high_round_markers %>% group_by(cluster) %>% top_n(n = 2, wt = avg_log2FC)

RT4_high_round.markers <- FindAllMarkers(RT4_high_round, only.pos = TRUE, min.pct = 0.25, logfc.threshold = 0.25)
RT4_high_round.markers %>%
  group_by(cluster) %>%
  slice_max(n = 2, order_by = avg_log2FC)

 VlnPlot(RT4_high_round, features = c("PAG1","ABCA6","ATAD5"),group.by = 'sample',y.max = 5)


FeaturePlot(RT4_high_round, features = c("PAG1", "LCORL","DUSP16","ACSF2","PRICKLE2"))

# SaveFigure(plot, "vln_exp1", width = 16, height = 8)

############################################
# Visualizing the top n genes per cluster # 
############################################

top5 <- RT4_high_round_markers %>% group_by(cluster) %>% top_n(n = 5, wt = avg_log2FC)
to_plot <- unique(top5$gene)
DotPlot(RT4_high_round, features = to_plot, group.by = "tree.ident") + coord_flip()
# SaveFigure(plot, "dplot_top5", width = 9, height = 20)

plot

RT4_high_round.markers %>%
  group_by(cluster) %>%
  top_n(n = 10, wt = avg_log2FC) -> top10
DoHeatmap(RT4_high_round, features = top10$gene) + NoLegend()



## for compare different conditions : 
# https://satijalab.org/seurat/articles/integration_introduction.html


