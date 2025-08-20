# ================================================================
# PROTsi Score Calculation Script (OCLR model on normalized proteomic data)
# Author: Renan Simões
# Description: Applies a pre-trained OCLR model (trained on iPSCs) to a
# normalized proteomics expression matrix and outputs a PROTsi score per sample.
# ================================================================

# ----------------------
# Required libraries
# ----------------------

# read.delim is used for reading the input files (signature and matrix)
# drop() removes single-dimensional entries from arrays
# as.matrix converts data.frames to matrices
# write.xlsx is used to save the weights to an Excel file
# write.table is used to save the final PROTsi scores

library(openxlsx)  # to export weights to Excel
library(stats)     # provides cor() function

# ----------------------
# Define working directory
# ----------------------

# This script assumes a working directory where you have a 'data/' folder containing:
# - 'HipSci-PROTstemsig.tsv'  : pre-trained weights from iPSCs using OCLR
# - 'expression_matrix.tsv'   : your normalized proteomics matrix (rows = proteins, cols = samples)

setwd("/.../data/")

# ----------------------
# Load the stemness signature (weights vector)
# ----------------------

fnSig <- "HipSci-PROTstemsig.tsv"  # path to the trained OCLR weights
wPROTsi <- read.delim(fnSig, header = FALSE, row.names = 1)  # first column = protein IDs, second = weights
wPROTsi <- as.matrix(wPROTsi)  # convert to matrix for downstream use
wPROTsi <- drop(wPROTsi)       # drop dimensions (becomes named numeric vector)

# Optional: save weights as Excel for inspection
aux <- as.data.frame(wPROTsi)  # convert to data.frame
aux$Proteins <- rownames(aux)  # add protein names as column
write.xlsx(aux, file = "wPROTsi_weights.xlsx")  # save

# ----------------------
# Load normalized expression data
# ----------------------

# Your expression matrix must be normalized and preprocessed.
# Each row should be a protein; each column a sample.
prot <- read.delim("expression_matrix.tsv", header = TRUE, row.names = 1)
prot <- as.matrix(prot)

# ----------------------
# Intersect and reorder
# ----------------------

# Ensure only proteins present in both model and data are used
wPROTsi <- wPROTsi[names(wPROTsi) %in% rownames(prot)]
prot <- prot[rownames(prot) %in% names(wPROTsi), ]

# Reorder expression data to match order of weights
geneorder <- match(names(wPROTsi), rownames(prot))
prot <- prot[geneorder, ]

# Check that order is identical before applying correlation
stopifnot(identical(rownames(prot), names(wPROTsi)))

# ----------------------
# Apply model: Spearman correlation between weights and each sample
# ----------------------

PROTsi <- apply(prot, 2, function(z) {
  cor(z, wPROTsi, method = "spearman", use = "complete.obs")
})

# ----------------------
# Normalize PROTsi scores between 0 and 1
# ----------------------

PROTsi <- PROTsi - min(PROTsi)
PROTsi <- PROTsi / max(PROTsi)

# ----------------------
# Save output
# ----------------------

# Final output: one PROTsi score per sample
fnOut <- "PROTsi_scores.tsv"
write.table(cbind(PROTsi), file = fnOut, sep = "\t", quote = FALSE, col.names = TRUE)