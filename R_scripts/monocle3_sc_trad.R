library(dplyr)
library(monocle3)


setwd('~/Desktop/Parse_10X_singel_cell_project/combined_output/all-well/DGE_filtered/')

mat <- readMM("DGE.mtx")
cell_meta <- read.delim("cell_metadata.csv",stringsAsFactor = FALSE, sep = ",")
genes <- read.delim( "all_genes.csv",stringsAsFactor = FALSE, sep = ",")
cell_meta$bc_wells <- make.unique(cell_meta$bc_wells, sep = "_dup")
rownames(cell_meta) <- cell_meta$bc_wells
genes$gene_name <- make.unique(genes$gene_name, sep = "_dup")



# Setting column and rownames to expression matrix
colnames(mat) <- genes$gene_name
rownames(mat) <- rownames(cell_meta)
mat_t <- t(mat)

# save mtx files
writeMM(mat_t, file="~/Desktop/mat.mtx")
# Remove empty rownames, if they exist
mat_t <- mat_t[(rownames(mat_t) != ""),]

# MAKE NEW TSV FILE WITHOUT HEADER from parse gene_name and cell_meta
write.table(cell_meta,'~/Desktop/barcode.tsv',col.names = F,row.names = F,quote = F,sep = '\t')
write.table(genes,'~/Desktop/genes.tsv',col.names = F,row.names = F,quote = F,sep = '\t')

cds <- load_mm_data(mat_path = "matrix_2.mtx", 
                    feature_anno_path = "genes.tsv", 
                    cell_anno_path = "barcode.tsv")

# pre-process
cds <- preprocess_cds(cds, num_dim = 100)

# plot_pcas
plot_pc_variance_explained(cds)
# reduce dim
cds <- reduce_dimension(cds)
# cluster cell
cds <- cluster_cells(cds)
# plotting cells
## Step 5: Learn a graph

## Step 6: Order cells
cds <- order_cells(cds)
plot_cells(cds)



plot_cells(cds, color_cells_by  = 'partition',label_cell_groups=F,)

###
###
###

cds <- cluster_cells(cds, resolution=1e-5)
plot_cells(cds)
marker_test_res <- top_markers(cds, group_cells_by="partition", 
                               reference_cells=1000, cores=8)


top_specific_markers <- marker_test_res %>%
  filter(fraction_expressing >= 0.10) %>%
  group_by(cell_group) %>%
  top_n(1, pseudo_R2)

top_specific_marker_ids <- unique(top_specific_markers %>% pull(gene_id))
# 
# assignshor_gene_name and plot 
rowData(cds)$gene_short_name <- row.names(mat_t) 

plot_genes_by_group(cds,
                    top_specific_marker_ids,
                    group_cells_by="V2",
                    ordering_type="maximal_on_diag",
                    max.size=3)

cds <- learn_graph(cds)
plot_cells(cds,
           color_cells_by = "V2",
           label_groups_by_cluster=FALSE,
           label_leaves=FALSE,
           label_branch_points=FALSE)
