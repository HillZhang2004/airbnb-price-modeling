# Airbnb Pricing in European Cities (R)

Predict nightly Airbnb listing prices from tabular listing features across major European cities.

**Fast scan:** data cleaning → feature engineering → baseline regression → lasso/ridge regularization → held-out evaluation → readable report.

## Results (held-out test set)

- **Test metrics:** see the report (linked below).  
  *(Optional: once you pick your final model, paste Test RMSE / MAE / R² here.)*

## Quick links

- **Live report (GitHub Pages):** https://hillzhang2004.github.io/airbnb-price-modeling/Report.html
- **Report (HTML file):** [docs/Report.html](docs/Report.html)
- **Report (Markdown):** [docs/Report.md](docs/Report.md)
- **Source analysis (Rmd):** [report/Airbnb_Pricing_Project.Rmd](report/Airbnb_Pricing_Project.Rmd)

## Dataset

Dataset: **Airbnb Prices in European Cities (Kaggle)**, weekday and weekend CSVs for **10 cities** (one pair per city).  
Raw files go in `data/raw/` and are **not committed**.

## What this project shows

- Real-world tabular data cleaning and joining across many CSV files
- Feature engineering for mixed numeric and categorical inputs
- Baseline linear regression (plus log price transform for skew)
- Regularization with lasso/ridge via `glmnet` for stability
- Clear reporting with plots and reproducible execution

## Modeling choices

- Log-transform of price to reduce skew
- One-hot encoding for categorical features
- Train/test split with consistent preprocessing
- Basic leakage checks (no target-derived features)

## Reproduce locally

One-command render:

```bash
R -q -f render_report.R
```

Or inside R:

```r
options(repos = c(CRAN = "https://cloud.r-project.org"))
pkgs <- c("tidyverse","caret","glmnet","knitr","rmarkdown","here")
install.packages(setdiff(pkgs, rownames(installed.packages())))

rmarkdown::render(
  "report/Airbnb_Pricing_Project.Rmd",
  output_dir = "docs",
  knit_root_dir = here::here(),
  output_file = "Report.md"
)
```

## Repo structure

```
.
├── report/
│   └── Airbnb_Pricing_Project.Rmd
├── docs/
│   ├── Report.html
│   └── Report.md
├── data/raw/                           # not tracked in git
├── render_report.R
├── .gitignore
└── README.md
```
