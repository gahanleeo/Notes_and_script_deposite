## Seurat 4.1.0 for parse downstream analysis ##

library(Seurat)
library(dplyr)
library(Matrix)
library(ggplot2)
library(fgsea)
library(msigdbr)

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


r3Dround <- CreateSeuratObject(mat,min.features =100, min.cells = 3,
                              names.feild = 0, meta.data = cell_meta)

# Setting our initial cell class to a single type, this will changer after clustering. 
r3Dround@meta.data$orig.ident <- factor(rep("rt4_round_3D", nrow(r3Dround@meta.data)))
Idents(r3Dround) <- r3Dround@meta.data$orig.ident


r3Dround[["percent.mt"]] <- PercentageFeatureSet(r3Dround, pattern = "^MT-")

VlnPlot(r3Dround, pt.size = 0.10,
        features = c("nFeature_RNA", "nCount_RNA", "percent.mt"), ncol = 3)

r3Dround <- subset(r3Dround, subset = nFeature_RNA > 200 & nFeature_RNA < 9000 & percent.mt < 15 & nCount_RNA < 60000)

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
r2Dround@meta.data$orig.ident <- factor(rep("rt4_round_2D", nrow(r2Dround@meta.data)))
Idents(r2Dround) <- r2Dround@meta.data$orig.ident


r2Dround[["percent.mt"]] <- PercentageFeatureSet(r2Dround, pattern = "^MT-")

VlnPlot(r2Dround, pt.size = 0.10,
        features = c("nFeature_RNA", "nCount_RNA", "percent.mt"), ncol = 3)


r2Dround <- subset(r2Dround, subset = nFeature_RNA > 200 & nFeature_RNA < 9000 & percent.mt < 15 & nCount_RNA < 20000)


##################################
# merge the 2 object, 2d and 3d  # 
##################################

rt4_round = merge(r2Dround,y = r3Dround,add.cell.ids = c("round_2D", "round_3D"), project = "rt4_round")

########################
# Normalizing the data # 
########################

rt4_round  = r3Dround

rt4_round <- NormalizeData(rt4_round, normalization.method = "LogNormalize", scale.factor = 10000)

###############################################
# Identification of highly variable features #
##############################################

rt4_round <- FindVariableFeatures(rt4_round, selection.method = "vst", nfeatures = 2000)
# Identify the 10 most highly variable genes
top10 <- head(VariableFeatures(rt4_round), 10)
# plot variable features with and without labels
plot1 <- VariableFeaturePlot(rt4_round)
plot2 <- LabelPoints(plot = plot1, points = top10, repel = TRUE)
# SaveFigure((plot1 + plot2), "var_features", width = 12, height = 6)
plot2
#####################
# Scaling the data #
####################

# This step gives equal weight in downstream analyses,
# so that highly-expressed genes do not dominate.
# The results of this are stored in rt4_round[["RNA"]]@scale.data

all.genes <- rownames(rt4_round)
rt4_round <- ScaleData(rt4_round, features = all.genes)

####################################
# PCA, linear dimensional reduction#
####################################

rt4_round <- RunPCA(rt4_round, features = VariableFeatures(object = rt4_round))

# SaveObject(rt4_round, "seurat_obj_after_PCA")
# rt4_round <- ReadObject("seurat_obj_after_PCA")

# Examine and visualize PCA results a few different ways
print(rt4_round[["pca"]], dims = 1:5, nfeatures = 5)


##################################################
# Determine the 'dimensionality' of the dataset #
##################################################

# NOTE: This process can take a long time for big datasets, comment out for expediency. More
# approximate techniques such as those implemented in ElbowPlot() can be used to reduce
# computation time

rt4_round <- JackStraw(rt4_round, num.replicate = 100)
rt4_round <- ScoreJackStraw(rt4_round, dims = 1:20)

JackStrawPlot(rt4_round, dims = 1:20)
ElbowPlot(rt4_round)

# find elbow and slect the PCA number for clusting cells

# ex: choose 1 to 30 ..

#####################
# Cluster the cells #
#####################

rt4_round <- FindNeighbors(rt4_round, dims = 1:15)
rt4_round <- FindClusters(rt4_round, resolution = 0.50) #  We find that setting resolution parameter between 0.4-1.2 

#####################################################
# Run non-linear dimensional reduction (UMAP/tSNE) # 
#####################################################

rt4_round <- RunUMAP(rt4_round, dims = 1:15)
DimPlot(rt4_round, reduction = "umap", label = TRUE) 
DimPlot(rt4_round, reduction = "umap",group.by = 'orig.ident')

###########################################################
# Differential gene expression (finding cluster markers) # 
###########################################################
 
# set idents for differentail analysis

Idents(rt4_round) = factor(rt4_round@meta.data$orig.ident)


rt4_round = RenameIdents(rt4_round,`rt4_round_2D` = 'RT4_2D', `rt4_round_3D` = 'RT4_3D')

diffmarkers <- FindMarkers(rt4_round, ident.1 = 'RT4_3D',ident.2 = 'RT4_2D', logfc.threshold =  0
                           , only.pos = FALSE,min.pct = 0.1, assay = "RNA" )

diffmarkers$gene = rownames(diffmarkers)

### most up-regulated gene list
tt = diffmarkers %>% 
  top_n(n = 5, wt = avg_log2FC)
fea = tt$gene 
### plot showing the gene expression level enriched in 3D 
VlnPlot(rt4_round, features = fea,group.by = 'orig.ident')



###################################
####### lumnial/basal genes ####### 
###################################

basal_genes <- c( "STAT3", "JAK2", "ITGA6", "KRT17", "CD44",'TP63',"EGFR")
lumnial_genes <- c("UPK1B","FOXA1","UPK2" , "GATA3", "UPK3B","UPK3A")

VlnPlot(rt4_round, features = lumnial_genes)
VlnPlot(rt4_round, features = basal_genes)

########################################
# get the table of basal/luminal gene #
########################################

tb.basal = diffmarkers[diffmarkers$gene %in% basal_genes ,]
tb.luminal = diffmarkers[diffmarkers$gene %in% lumnial_genes ,]



###########################################
# geting the fusion cell in seurat object #
###########################################

# adding cb to the table
rt4_round@meta.data$cb = gsub('__s[0-9]+','',rownames(rt4_round@meta.data))

# ifelse loop to name the ident
# tar is list of cell barcode contains fusoin ex: 01_01_01 ....
tar = fusion_cb

for(i in 1:nrow(rt4_round@meta.data)){
  if(rt4_round@meta.data[i,19] %in% tar){
    rt4_round@meta.data$fusionid[i] = 'fg3_fusion'}
  else{rt4_round@meta.data$fusionid[i] = 'no_fusion'}
}

Idents(rt4_round) = factor(rt4_round@meta.data$fusionid)

diffmarkers <- FindMarkers(rt4_round, ident.1 = 'fg3_fusion',ident.2 = 'no_fusion', 
                           only.pos = T,min.pct = 0.1)
diffmarkers$gene = rownames(diffmarkers)
tt = diffmarkers %>% 
  top_n(n = 5, wt = avg_log2FC)
fea = tt$gene 
### plot showing the gene expression level enriched in 3D 
VlnPlot(rt4_round, features = fea )
# avg exp
cluster.averages <- AverageExpression(rt4_round)
head(cluster.averages)      
