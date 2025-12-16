options(repos = c(CRAN = "https://cloud.r-project.org"))

pkgs <- c("tidyverse","caret","glmnet","knitr","rmarkdown","here")
to_install <- setdiff(pkgs, rownames(installed.packages()))
if (length(to_install) > 0) install.packages(to_install)

dir.create("docs", showWarnings = FALSE)

# clear old outputs so we don't accumulate duplicates
unlink(list.files("docs", full.names = TRUE), recursive = TRUE, force = TRUE)

# Render to a fixed filename
rmarkdown::render(
  "report/Airbnb_Pricing_Project.Rmd",
  output_dir = "docs",
  knit_root_dir = here::here(),
  output_file = "Report.md"
)

# Normalize the assets folder name (GitHub preview uses these images)
if (dir.exists("docs/Report_files")) unlink("docs/Report_files", recursive = TRUE, force = TRUE)
if (dir.exists("docs/Airbnb_Pricing_Project_files")) file.rename("docs/Airbnb_Pricing_Project_files", "docs/Report_files")
