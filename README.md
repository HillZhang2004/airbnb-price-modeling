# Airbnb Pricing in European Cities (R)

Predict nightly Airbnb listing prices from tabular listing features across major European cities.

**Fast scan:** data cleaning → feature engineering → baseline regression → lasso/ridge regularization → held-out evaluation → readable report.

## Quick links

- **Report (HTML):** [docs/Report.html](docs/Report.html)
- **Report (Markdown):** [docs/Report.md](docs/Report.md)
- **Source analysis (Rmd):** [report/Airbnb_Pricing_Project.Rmd](report/Airbnb_Pricing_Project.Rmd)

## What this project shows

- Real-world tabular data cleaning and joining across many CSV files
- Feature engineering for mixed numeric and categorical inputs
- Baseline linear regression (plus log price transform for skew)
- Regularization with lasso/ridge via `glmnet` for stability
- Clear reporting with plots and reproducible execution

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
  knit_root_dir = here::here()
)
```

## Data

This repository does **not** include the raw dataset files.

Place the city CSVs in:

`data/raw/`

The report expects these files (weekdays + weekends for each city):

- `amsterdam_weekdays.csv`, `amsterdam_weekends.csv`
- `athens_weekdays.csv`, `athens_weekends.csv`
- `barcelona_weekdays.csv`, `barcelona_weekends.csv`
- `berlin_weekdays.csv`, `berlin_weekends.csv`
- `budapest_weekdays.csv`, `budapest_weekends.csv`
- `lisbon_weekdays.csv`, `lisbon_weekends.csv`
- `london_weekdays.csv`, `london_weekends.csv`
- `paris_weekdays.csv`, `paris_weekends.csv`
- `rome_weekdays.csv`, `rome_weekends.csv`
- `vienna_weekdays.csv`, `vienna_weekends.csv`

`data/` is git-ignored to avoid committing large raw files.

## Repo structure

```
.
├── report/
│   └── Airbnb_Pricing_Project.Rmd
├── docs/
│   ├── Report.html
│   ├── Report.md
│   └── Airbnb_Pricing_Project_files/   # images used by the HTML
├── data/raw/                           # not tracked in git
├── render_report.R
├── .gitignore
└── README.md
```
