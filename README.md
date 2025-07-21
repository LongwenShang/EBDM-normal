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

You can also use `method = "weighted"` when variance estimates are unavailable.

---

## 📈 Reproducing Simulation Studies

This repository includes the simulation code used in our paper to evaluate the performance of the `ebdm` package across **4*5 different settings**, with **1000 replications per setting**.
The simulations assess estimation accuracy, confidence interval coverage, and robustness under varying sample sizes and dependency structures.

### Simulation Workflow Overview
| File            | Purpose                                                                  |
|-----------------|--------------------------------------------------------------------------|
| `main.R`        | Core simulation logic. Takes a setting index and a seed index as input.  |
| `submit.sh`     | Shell script to submit 1000 replications for a given setting.            |
| `seeds.rda`     | Fixed random seeds to ensure reproducibility.                            |
| `results/`      | Stores raw outputs from each simulation replicate.                       |
| `merge_result.R`| Aggregates all simulation results.                                       |
| `eval.R`        | Computes performance metrics and generates plots.        
### Run on SLURM Cluster Submit simulation jobs with:
```bash
for j in 1 2 3 4;
do
sbatch submit.sh $j
done
```
Each job (`submit.sh`) runs 1000 replicates for one simulation setting.
### After Simulation: Merge and Evaluate
After all simulations are completed, run `merge_result.R` to merge the results. Then use `eval.R` to analyze the merged results and generate plots, which computes:
- Bias of point estimates
- Empirical standard errors
- Confidence interval coverage
- Plots for publication
### Directory Structure
```
simulations/
├── main.R
├── submit1.sh
├── seeds.rda
├── results/
├── merge_result.R
└── eval.R
```
All simulation results are stored in `results/`. The seeds file ensures reproducibility.


## 📚 Citation

If you use this package or method in your work, please cite:
```bibtex
@article{shang2025ebdm,
 title = {Estimating the Joint Distribution of Two Binary Variables from Their Marginal Summaries},
 author = {Shang, Longwen and Tsao, Min and Zhang, Xuekui},
 journal = {arXiv preprint arXiv:2505.03995},
 year = {2025}
}
```








## 💬 Contact

For questions or feedback, please contact:
- 📧 **Xuekui Zhang** – xuekui@uvic.ca
- 📧 **Longwen Shang** – shanglongwen0918@gmail.com









