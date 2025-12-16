# Airbnb Price Modeling (R)

Predict Airbnb listing prices from tabular listing features.
This repo is set up to be fast for a recruiter to scan and easy to reproduce.

## TL;DR

- **Goal:** estimate nightly price from listing attributes
- **Workflow:** clean data, build features, fit baseline regression, then regularize with lasso or ridge
- **Output:** a readable report in `docs/`, and the full source analysis in `report/`

## What this project shows

- Practical data cleaning on a real world dataset
- Feature engineering for mixed numeric and categorical inputs
- Baseline modeling plus regularization with `glmnet`
- Simple, honest evaluation on a held out test split
- Clear communication through a rendered report

## Quick links

- **Report (HTML):** `docs/Report.html`
- **Report (PDF, optional):** `docs/Report.pdf`
- **Source analysis:** `report/Airbnb_Pricing_Project.Rmd`

## Run it locally

```r
install.packages(c("tidyverse","caret","glmnet","knitr","rmarkdown","here"))
rmarkdown::render("report/Airbnb_Pricing_Project.Rmd", output_dir = "docs")
```

## Data

This repository does **not** include the raw dataset.
Place your CSVs in:

- `data/raw/listings.csv`
- `data/raw/calendar.csv`
- `data/raw/reviews.csv`

If your filenames differ, update the paths in the report under **Data Loading**.

## Repository structure

```
.
├── report/
│   └── Airbnb_Pricing_Project.Rmd
├── docs/
│   ├── Report.html
│   └── Report.pdf
├── data/
│   └── raw/            # not tracked in git
├── .gitignore
└── README.md
```

## Notes

- If you want tighter reproducibility, add `renv` and commit `renv.lock`.
- This repo is written as a standalone project (no course or instructor references).
