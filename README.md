# ebdm-normal: Estimating Bivariate Normal Distribution from Marginal Summaries

This repository accompanies the continuous extension of the R package **ebdm**, now available on CRAN.

The package implements a **maximum likelihood method** to estimate the joint distribution, especially the **correlation coefficient** (ρ) of two **normally distributed variables**, using only **marginal summary statistics** (means, variances, and sample sizes) from multiple independent studies. This is useful in privacy-preserving settings such as federated meta-analysis or clinical trial simulations (CTS) where only aggregated data are available.

The method is detailed in our manuscript: (Coming Soon)

---

## 🔍 Introduction

In many real-world scenarios such as drug development, access to individual-level patient data is limited. Researchers often only observe summary-level data—such as marginal proportions of demographic or risk variables across multiple studies. Estimating the dependency structure (i.e., the joint distribution) between two such binary variables is critical for realistic clinical trial simulations, but challenging under privacy constraints.

In many real-world applications (e.g., drug development, biostatistics, federated learning), **individual-level data** are unavailable due to privacy concerns. Instead, researchers often only have access to **study-level summaries**, such as sample means, variances, and sizes.

This package provides a **numerically stable, likelihood-based estimator** for correlation:
- Closed-form estimates of marginal means and variances
- 1D MLE search for correlation ρ
- Standard errors via observed Fisher information
- Confidence intervals via normal or likelihood-ratio methods

---

## 📦 Installation

The `ebdm` package is available on CRAN. Install it using:

```r
install.packages("ebdm")
```

---

## 🌰 Usage Example

```r
# Load the package
library(ebdm)

# Load continuous example data
data(cont_example)

# Estimate correlation and other parameters with proposed MLE + likelihood ratio CI
result <- cor_cont(
  n     = cont_example$Sample_Size,
  xbar  = cont_example$Mean_X,
  ybar  = cont_example$Mean_Y,
  s2x   = cont_example$Variance_X,
  s2y   = cont_example$Variance_Y,
  method = "proposed",
  ci_method = "lr"
)

print(result)
```

You can also use `method = "weighted"` when sample variances are unavailable.

---

## 📈 Reproducing Simulation Studies

This repository includes the simulation code used in the manuscript. It evaluates estimation accuracy, CI coverage, and SE performance under various: True correlation values, Number of studies (k) and Sample size ranges.

### Simulation Workflow Overview
| File            | Purpose                                                                  |
|-----------------|--------------------------------------------------------------------------|
| `main.R`        | Simulates one replicate of all settings  |
| `submit.sh`     | Submits 1000 replicates on SLURM            |
| `seeds.rda`     | Fixed random seeds to ensure reproducibility                            |
| `results/`      | Stores raw outputs from each simulation replicate.                       |
| `merge_result.R`| Merges simulation outputs                                       |
| `eval.R`        | Summarizes coverage and plots        
### Run on SLURM Cluster Submit simulation jobs with:
```bash
for i in {1..1000}; do
sbatch submit.sh $i
done
```
### After Simulation: Merge and Evaluate
After all simulations are completed, run `merge_result.R` to merge the results. Then use `eval.R` to analyze the merged results and generate plots, which computes:
- Bias of point estimates
- Empirical standard errors
- Confidence interval coverage
- Plots in the manuscript
### Directory Structure
```
simulations/
├── main.R
├── submit.sh
├── seeds.rda
├── results/
├── merge_result.R
└── eval.R
```
All simulation results are stored in `results/`. The seeds file ensures reproducibility.


## 📚 Citation

If you use this package or method in your work, please cite:









## 💬 Contact

For questions or feedback, please contact:
- 📧 **Xuekui Zhang** – xuekui@uvic.ca
- 📧 **Longwen Shang** – shanglongwen0918@gmail.com









