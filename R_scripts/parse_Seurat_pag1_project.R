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



mat_path <- "~/Desktop/Parse_10X_singel_cell_project/result/combined/Brenen Control/DGE_filtered/"
mat <- ReadParseBio(mat_path)

# Check to see if empty gene names are present, add name if so.
table(rownames(mat) == "")
rownames(mat)[rownames(mat) == ""] <- "unknown"

# Read in cell meta data
cell_meta <- read.csv(paste0(mat_path, "/cell_metadata.csv"), row.names = 1)

# Create object
# reateSeuratObject(counts = pag1.data, project = "pag13k", min.cells = 3, min.features = 200)
Control <- CreateSeuratObject(mat,min.features =100, min.cells = 3,
                           names.feild = 0, meta.data = cell_meta)

# Setting our initial cell class to a single type, this will changer after clustering. 
Control@meta.data$orig.ident <- factor(rep("control", nrow(Control@meta.data)))
Idents(Control) <- Control@meta.data$orig.ident


Control[["percent.mt"]] <- PercentageFeatureSet(Control, pattern = "^MT-")

VlnPlot(Control, pt.size = 0.10,
        features = c("nFeature_RNA", "nCount_RNA", "percent.mt"), ncol = 3)

# plot correlation for difine which factor is corrleate with which one # 

plot1 <- FeatureScatter(Control, feature1 = "nCount_RNA", feature2 = "percent.mt")
plot2 <- FeatureScatter(Control, feature1 = "nCount_RNA", feature2 = "nFeature_RNA")
plot1 + plot2


# Perform the filtering # percent.mt < 15 / or 60 

Control <- subset(Control, subset = nFeature_RNA > 200 & nFeature_RNA < 5000 & percent.mt < 35)


########
# pag1 #
########


mat_path <- "~/Desktop/Parse_10X_singel_cell_project/result/combined/Brenen Sample 1 Pag 1/DGE_filtered/"
mat <- ReadParseBio(mat_path)

# Check to see if empty gene names are present, add name if so.
table(rownames(mat) == "")
rownames(mat)[rownames(mat) == ""] <- "unknown"

# Read in cell meta data
cell_meta <- read.csv(paste0(mat_path, "/cell_metadata.csv"), row.names = 1)

# Create object
# reateSeuratObject(counts = pag1.data, project = "pag13k", min.cells = 3, min.features = 200)
pag1 <- CreateSeuratObject(mat, min.features = 100, min.cells = 3,
                           names.feild = 0, meta.data = cell_meta)

pag1@meta.data$orig.ident <- factor(rep("pag1", nrow(pag1@meta.data)))
Idents(pag1) <- pag1@meta.data$orig.ident



pag1[["percent.mt"]] <- PercentageFeatureSet(pag1, pattern = "^MT-")
VlnPlot(pag1, pt.size = 0.10,
        features = c("nFeature_RNA", "nCount_RNA", "percent.mt"), ncol = 3)

# Perform the filtering # percent.mt < 15 / or 60 
pag1 <- subset(pag1, subset = nFeature_RNA > 200  & nFeature_RNA < 8000 & percent.mt <30)


# merged data after QC and then analysis
pag1.combined <- merge(Control, y = c(pag1), add.cell.ids = c("control", "pag1"), project = "pag1_project")


SaveObject(pag1.combined,'pag1_project_all')


#####
#####
#####

pag1.combined = ReadObject('pag1_project_all')

########################
# Normalizing the data # 
########################

pag1.combined <- NormalizeData(pag1.combined, normalization.method = "LogNormalize", scale.factor = 10000)

###############################################
# Identification of highly variable features #
##############################################

pag1.combined <- FindVariableFeatures(pag1.combined, selection.method = "vst", nfeatures = 2000)
# Identify the 10 most highly variable genes
top10 <- head(VariableFeatures(pag1.combined), 10)
# plot variable features with and without labels
plot1 <- VariableFeaturePlot(pag1.combined)
plot2 <- LabelPoints(plot = plot1, points = top10, repel = TRUE)
# SaveFigure((plot1 + plot2), "var_features", width = 12, height = 6)
plot2
#####################
# Scaling the data #
####################

# This step gives equal weight in downstream analyses,
# so that highly-expressed genes do not dominate.
# The results of this are stored in pag1[["RNA"]]@scale.data
all.genes <- rownames(pag1.combined)
pag1.combined <- ScaleData(pag1.combined, features = all.genes)

####################################
# PCA, linear dimensional reduction#
####################################

pag1.combined <- RunPCA(pag1.combined)

# SaveObject(pag1.combined, "seurat_obj_after_PCA")
# pag1.combined <- ReadObject("seurat_obj_after_PCA")

# Examine and visualize PCA results a few different ways
print(pag1.combined[["pca"]], dims = 1:5, nfeatures = 5)

#plot <- VizDimLoadings(pag1.combined, dims = 1:2, reduction = "pca")
# SaveFigure(plot, "viz_PCA_loadings", width = 10, height = 8)

plot <- DimPlot(pag1.combined, reduction = "pca" )
plot
# SaveFigure(plot, "pc1_2_scatter", width = 8, height = 6)

plot <- DimHeatmap(pag1.combined, dims = 1, cells = 500, balanced = TRUE, fast = FALSE)
plot

DimHeatmap(pag1.combined, dims = 1:15, cells = 500, balanced = TRUE, fast = FALSE)

##################################################
# Determine the 'dimensionality' of the dataset #
##################################################

# NOTE: This process can take a long time for big datasets, comment out for expediency. More
# approximate techniques such as those implemented in ElbowPlot() can be used to reduce
# computation time

pag1.combined <- JackStraw(pag1.combined, num.replicate = 100)
pag1.combined <- ScoreJackStraw(pag1.combined, dims = 1:20)

JackStrawPlot(pag1.combined, dims = 1:15)
ElbowPlot(pag1.combined)

# find elbow and slect the PCA number for clusting cells

# ex: choose 1 to 30 ..

#####################
# Cluster the cells #
#####################

pag1.combined <- FindNeighbors(pag1.combined, dims = 1:15)
pag1.combined <- FindClusters(pag1.combined, resolution = 0.50) #  We find that setting resolution parameter between 0.4-1.2 

###################################################
# Reorder clusters according to their similarity # 
###################################################

pag1.combined <- BuildClusterTree(pag1.combined, reorder = TRUE, reorder.numeric = TRUE)

#####################################################
# Run non-linear dimensional reduction (UMAP/tSNE) # 
#####################################################

pag1.combined <- RunUMAP(pag1.combined, dims = 1:15)
DimPlot(pag1.combined, reduction = "umap",group.by = 'orig.ident')
DimPlot(pag1.combined, reduction = "umap", label = TRUE) 

SaveFigure(p, "B_pag1_all_umap_by_group", width = 9, height = 8)


# can save object as clusterd 
# SaveObject(pag1.combined, "seurat_obj_clustered")
# pag1.combined <- ReadObject("seurat_obj_clustered")

###########################################################
# Differential gene expression (finding cluster markers) # 
###########################################################

# group_by is dplyr() function, Group data into rows with the same value in group_by()

cluster1.markers <- FindMarkers(pag1.combined, ident.1 = 1, min.pct = 0.25)
head(cluster1.markers, n = 5)

cluster2.markers <- FindMarkers(pag1.combined, ident.1 = 2, min.pct = 0.25)
head(cluster2.markers, n = 5)



#pag1.combined_markers <- FindAllMarkers(pag1.combined , min.pct = 0.25, logfc.threshold = 0.25)
#pag1.combined_markers %>% group_by(cluster) %>% top_n(n = 2, wt = avg_log2FC)

pag1.combined.markers <- FindAllMarkers(pag1.combined, only.pos = TRUE, min.pct = 0.25, logfc.threshold = 0.25)
pag1.combined.markers %>%
  group_by(cluster) %>%
  slice_max(n = 2, order_by = avg_log2FC)

plot <- VlnPlot(pag1.combined, features = c("PAG1", "LCORL","DUSP16","ACSF2","PRICKLE2"))
plot

FeaturePlot(pag1.combined, features = c("PAG1", "LCORL","DUSP16","ACSF2","PRICKLE2"))

# SaveFigure(plot, "vln_exp1", width = 16, height = 8)

############################################
# Visualizing the top n genes per cluster # 
############################################

top5 <- pag1_markers %>% group_by(cluster) %>% top_n(n = 5, wt = avg_log2FC)
to_plot <- unique(top5$gene)
DotPlot(pag1.combined, features = to_plot, group.by = "tree.ident") + coord_flip()
# SaveFigure(plot, "dplot_top5", width = 9, height = 20)

plot

pag1.markers %>%
  group_by(cluster) %>%
  top_n(n = 10, wt = avg_log2FC) -> top10
DoHeatmap(pag1.combined, features = top10$gene) + NoLegend()



# not sure if this work #
# DefaultAssay(pag1.combined) <- "RNA"
pag1.combined$newid = paste0(paste0(gsub("Brenen Sample [0-9]+ ","",pag1.combined$orig.ident)))

Idents(pag1.combined) = factor(pag1.combined$newid)
cluster.averages <- as.data.frame(AverageExpression(pag1.combined,verbose = FALSE)[["RNA"]])
tt = as.data.frame(log1p(AverageExpression(pag1.combined, verbose = FALSE,slot = "data")$RNA))

#Idents(pag1.combined)


#########################################################################
#########################################################################
#########################################################################
#########################################################################

########################
# for intergation data # 
#######################




pag1.combined = ReadObject('pag1_project_all')

pag1_inter <- SplitObject(pag1.combined, split.by = "orig.ident")

pag1_inter <- lapply(X = pag1_inter, FUN = function(x) {
  x <- NormalizeData(x)
  x <- FindVariableFeatures(x, selection.method = "vst", nfeatures = 2000)
})

# select features that are repeatedly variable across datasets for integration
features <- SelectIntegrationFeatures(object.list = pag1_inter)

# perform anchor # 

pag1.anchors <- FindIntegrationAnchors(object.list = pag1_inter, anchor.features = features)

# this command creates an 'integrated' data assay
pag1.combined <- IntegrateData(anchorset = pag1.anchors)


# Perform an integrated analysis # 

# specify that we will perform downstream analysis on the corrected data note that the
# original unmodified data still resides in the 'RNA' assay

DefaultAssay(pag1.combined) <- "integrated"

# Run the standard workflow for visualization and clustering
pag1.combined <- ScaleData(pag1.combined, verbose = FALSE)
pag1.combined <- RunPCA(pag1.combined, npcs = 30, verbose = FALSE)
pag1.combined <- RunUMAP(pag1.combined, reduction = "pca", dims = 1:30)
pag1.combined <- FindNeighbors(pag1.combined, reduction = "pca", dims = 1:30)

# below process change identation to 1...6 
pag1.combined <- FindClusters(pag1.combined, resolution = 0.5)

# optional, Reorder clusters according to their similarity
# pag1.combined <- BuildClusterTree(pag1.combined, reorder = TRUE, reorder.numeric = TRUE)



# Visualization

DimPlot(pag1.combined, reduction = "umap")
DimPlot(pag1.combined, reduction = "umap", split.by ="orig.ident")



##################################################
### FINDING DIFFERENTED GENE from 3D vs 2D   ###
#################################################

# not sure if this work #
DefaultAssay(pag1.combined) <- "RNA"
#pag1.combined$newid = paste0(paste0(gsub("Brenen Sample [0-9]+ ","",pag1.combined$sample)))

#Idents(pag1.combined) = factor(pag1.combined$newid,levels = c('Brenen Control','Pag 1'))
#Idents(pag1.combined)

########################


# set Ident between control and pag1 
Brene_c_vs_p <- SetIdent(pag1.combined, value = "orig.ident")

Brene_c_vs_p = pag1.combined
# checking levels/Idents
levels(Brene_c_vs_p)
# diff analysis with all default, #default logfc.threshold = 0.25
pag1_diff <- FindMarkers(Brene_c_vs_p, ident.1 = "pag1",ident.2 = "control", verbose = FALSE,logfc.threshold = 0.1,test.use = "DESeq2")

pag1_diff$gene = rownames(pag1_diff)

FeaturePlot(pag1.combined, features = c("PAG1"), split.by = "orig.ident", max.cutoff = 3,
            cols = c("grey", "red"))

VlnPlot(Brene_c_vs_p, features = 'PAG1',
        ncol = 2, group.by = "orig.ident", assay = "RNA", pt.size =1)



# plot expression, find most sign p-val
# n = top n ...

DGE_cell_selection %>%
  group_by(cluster) %>%
  top_n(-3, p_val) -> top5_cell_selection

VlnPlot(Brene_c_vs_p, features = as.character(unique(top5_cell_selection$gene)),
        ncol = 3, group.by = "orig.ident", assay = "RNA", pt.size = 0.1)

FeaturePlot(Brene_c_vs_p, features = as.character(unique(top5_cell_selection$gene)),  max.cutoff = 3, cols = c("grey", "red"))

# Visualizing the top n genes per indent

DotPlot(Brene_c_vs_p, features = as.character(unique(DGE_cell_selection$gene)), group.by = "orig.ident") + coord_flip()





###############
## referecne###
###############


# https://satijalab.org/seurat/articles/de_vignette.html
# https://satijalab.org/seurat/articles/integration_introduction.html
# https://nbisweden.github.io/workshop-scRNAseq/labs/compiled/seurat/seurat_05_dge.html

