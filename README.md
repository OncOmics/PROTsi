# PROTsi – Stemness Model Application on Proteomics

This script calculates PROTsi scores by applying a pre-trained OCLR model to normalized proteomic data.

## Folder Structure

- `data/`
  - `HipSci-PROTstemsig.tsv`: weights of the model trained on iPSCs (must be provided)
  - `expression_matrix.tsv`: normalized proteomic expression matrix (your own data)
- `scripts/`
  - `calculate_PROTsi.R`: R script to run the model step-by-step
- `results/`
  - Output files will be written here

## Requirements

- R >= 4.0
- R packages: `openxlsx`, `stats` (default)

## Usage

1. Edit the `setwd()` line in the script to point to your local project directory.
2. Place your files inside the `data/` folder as instructed.
3. Open R or RStudio and run the script `scripts/calculate_PROTsi.R` line by line.
4. Results will be saved to `results/PROTsi_scores.tsv`