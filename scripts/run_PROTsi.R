# ================================================================
# PROTsi Score Calculation Script
# (OCLR model on normalized proteomic data)
# Author: Renan Simões
# Description:
#   Applies a pre-trained OCLR model (trained on iPSCs) to a
#   normalized proteomics expression matrix and outputs a
#   PROTsi score per sample.
# ================================================================


# ================================================================
# Argument parsing
# ================================================================
parse_args <- function(args) {
  out <- list()
  i <- 1
  while (i <= length(args)) {
    if (grepl("^--", args[i])) {
      key <- sub("^--", "", args[i])
      if (i + 1 <= length(args) && !grepl("^--", args[i + 1])) {
        val <- args[i + 1]
        i <- i + 2
      } else {
        val <- TRUE  # flags
        i <- i + 1
      }
      out[[key]] <- val
    } else {
      i <- i + 1
    }
  }
  return(out)
}

args <- commandArgs(trailingOnly = TRUE)

tryCatch({
  params <- parse_args(args)

  # Mandatory arguments
  if (is.null(params$input)) stop("--input is mandatory")
  if (is.null(params$output)) stop("--output is mandatory")

  # Defaults
  if (is.null(params$weights)) {
    params$weights <- "data/HipSci-PROTstemsig.tsv"
  }

  # Show parameters
  cat("Input file:        ", params$input, "\n")
  cat("Output file:       ", params$output, "\n")
  cat("Pre-trained weights:", params$weights, "\n")

}, error = function(e) {
  cat("ERROR:\n", conditionMessage(e), "\n")
  quit(status = 1)
})


# ================================================================
# Required libraries
# ================================================================
if (!requireNamespace("openxlsx", quietly = TRUE)) {
  install.packages("openxlsx", repos = "https://cloud.r-project.org")
}
library(openxlsx)  # export weights to Excel
library(stats)     # provides cor()


# ================================================================
# Load the stemness signature (weights vector)
# ================================================================
tryCatch({
  wPROTsi <- read.delim(params$weights, header = FALSE, row.names = 1)
  wPROTsi <- as.matrix(wPROTsi)
  wPROTsi <- drop(wPROTsi)  # named numeric vector

  # Save weights as Excel
  aux <- as.data.frame(wPROTsi)
  aux$Proteins <- rownames(aux)
  outfile <- file.path(dirname(params$output), "wPROTsi_weights.xlsx")
  write.xlsx(aux, file = outfile)

}, error = function(e) {
  cat("ERROR:\n", conditionMessage(e), "\n")
  quit(status = 1)
})


# ================================================================
# Load normalized expression data
# ================================================================
tryCatch({
  prot <- read.delim(params$input, header = TRUE, row.names = 1)
  prot <- as.matrix(prot)
  cat("Expression matrix loaded:\n")
  cat("  Samples: ", ncol(prot), "\n")
  cat("  Features:", nrow(prot), "\n")

}, error = function(e) {
  cat("ERROR:\n", conditionMessage(e), "\n")
  quit(status = 1)
})


# ================================================================
# Intersect and reorder
# ================================================================
wPROTsi <- wPROTsi[names(wPROTsi) %in% rownames(prot)]
prot    <- prot[rownames(prot) %in% names(wPROTsi), ]

geneorder <- match(names(wPROTsi), rownames(prot))
prot <- prot[geneorder, ]

stopifnot(identical(rownames(prot), names(wPROTsi)))


# ================================================================
# Apply model (Spearman correlation)
# ================================================================
PROTsi <- apply(prot, 2, function(z) {
  cor(z, wPROTsi, method = "spearman", use = "complete.obs")
})


# ================================================================
# Normalize PROTsi scores (0–1 range)
# ================================================================
PROTsi <- PROTsi - min(PROTsi)
PROTsi <- PROTsi / max(PROTsi)


# ================================================================
# Save results
# ================================================================
write.table(
  cbind(PROTsi),
  file      = params$output,
  sep       = "\t",
  quote     = FALSE,
  col.names = TRUE
)

outfile <- file.path(dirname(params$output), "wPROTsi_output.xlsx")
write.xlsx(aux, file = outfile)

cat("Analysis completed. Results written to", params$output, "\n")
