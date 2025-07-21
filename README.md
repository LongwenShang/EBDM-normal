# ebdm-binary: Estimating Bivariate Dependency from Marginal Data (2 Binary Variables)

This repository accompanies the R package **ebdm**, available on CRAN.

The package implements a **maximum likelihood method** to estimate the joint distribution of two **binary** variables using only **marginal summary data** from multiple independent studies. This setting arises frequently in **clinical trial simulation (CTS)** where only aggregated data (e.g., proportions, sample sizes) are publicly available due to privacy constraints.

The method is detailed in our manuscript:

> Shang, Tsao, and Zhang (2025).  
> *Estimating the Joint Distribution of Two Binary Variables from Their Marginal Summaries*.  
> [arXiv:2505.03995](https://doi.org/10.48550/arXiv.2505.03995)

---

## 🔍 Introduction

In many real-world scenarios such as drug development, access to individual-level patient data is limited. Researchers often only observe summary-level data—such as marginal proportions of demographic or risk variables across multiple studies. Estimating the dependency structure (i.e., the joint distribution) between two such binary variables is critical for realistic clinical trial simulations, but challenging under privacy constraints.

This package provides a statistically sound and computationally efficient method to estimate the **joint probability mass function** of two binary variables given their marginal summaries across multiple studies with varying sample sizes.

---

## 📦 Installation

The `ebdm` package is available on CRAN. Install it using:

```r
install.packages("ebdm")
```

---

## 🌰 Usage Example

```r
library(ebdm)

# Load an example dataset
data(bin_example)

# Estimate joint distribution using likelihood ratio method for CI
result <- cor_bin(
  ni = bin_example$ni,
  xi = bin_example$xi,
  yi = bin_example$yi,
  ci_method = "lr"
)

print(result)
```

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









