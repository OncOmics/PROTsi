# PROTsi – Stemness Model Application on Proteomics

This repository provides scripts to calculate the **protein-based stemness signature (PROTsi)** scores by applying our pre-trained OCLR model weights to normalized proteomic data.

<p align="center">
  <img src="https://ars.els-cdn.com/content/image/1-s2.0-S2666979X25001077-fx1_lrg.jpg" alt="PROTsi overview" width="600"/>
</p>

---

## 📂 Repository Structure

- **`data/`**
  - `HipSci-PROTstemsig.tsv` – model weights (trained on iPSCs).
  - `expression_matrix.tsv` – example of a normalized proteomic expression matrix.  
    - Each **row** = a protein.  
    - Each **column** = a sample.  
    - Protein names must be in the **first column**.

- **`scripts/`**
  - `run_PROTsi.R` – command-line script to calculate scores and save them to a file.  
  - `calculate_PROTsi.R` – step-by-step version (for running interactively in RStudio).

---

## ⚙️ Requirements

- **R ≥ 4.0** ([Download R](https://cran.r-project.org/))
- R packages:
  - [`openxlsx`](https://cran.r-project.org/package=openxlsx)
  - `stats` (default in R)

---

## 🚀 Usage

Clone this repository:

```bash
git clone https://github.com/OncOmics/PROTsi
cd PROTsi
```

### Command-line execution

Run the example data provided in `data/`:

```bash
Rscript ./scripts/run_PROTsi.R --input data/expression_matrix.tsv --output myresult.tsv
```

Or run on your own data (adjusting the paths):

```bash
Rscript /path/to/PROTsi/scripts/run_PROTsi.R \
	--input data/my_matrix.tsv \
	--output myresult.tsv \
	--weights /path/to/PROTsi/data/HipSci-PROTstemsig.tsv
```

### Step-by-step (RStudio)

 1. Open calculate_PROTsi.R in R interface/RStudio.
 2.  (Optional) Edit the setwd() line to point to your project directory.
 3. Update all the input/output file paths as needed.
 4. Run the script line by line.

## 📖 Citation

Author:  [Renan Simões](https://github.com/RenanSimoesBR) 


If you use this code, please cite:  **Kołodziejczak-Guglas I, Simões RLS, de Souza Santos E, et al.** *Proteomic-based stemness score measures oncogenic dedifferentiation and enables the identification of druggable targets.* _Cell Genomics_, 5(6):100851, 2025. [![DOI](https://img.shields.io/badge/DOI-10.1016%2Fj.xgen.2025.100851-blue)](https://doi.org/10.1016/j.xgen.2025.100851)
