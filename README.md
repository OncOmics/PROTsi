# PROTsi – Stemness Model Application on Proteomics

This script calculates PROTsi scores by applying a pre-trained OCLR model to normalized proteomic data.

## Folder Structure

- `data/`
  - `HipSci-PROTstemsig.tsv`: weights of the model trained on iPSCs (must be provided)
  - `expression_matrix.tsv`: normalized proteomic expression matrix (your own data)
- `scripts/`
  - `calculate_PROTsi.R`: R script to run the model step-by-step

## Requirements

- R >= 4.0
- R packages: `openxlsx`, `stats` (default)

## Usage

1. Edit the `setwd()` line in the script to point to your local project directory.
2. Place your files inside the `data/` folder as instructed.
3. Open R or RStudio and run the script `scripts/calculate_PROTsi.R` line by line.

## Citation

Kołodziejczak-Guglas I, Simões RLS, de Souza Santos E, et al. Proteomic-based stemness score measures oncogenic dedifferentiation and enables the identification of druggable targets. *Cell Genom.* 2025;5(6):100851. doi:[10.1016/j.xgen.2025.100851](https://doi.org/10.1016/j.xgen.2025.100851)
