options(repos = c(CRAN = "https://cloud.r-project.org"))

pkgs <- c("tidyverse","caret","glmnet","knitr","rmarkdown","here")
to_install <- setdiff(pkgs, rownames(installed.packages()))
if (length(to_install) > 0) install.packages(to_install)

rmarkdown::render(
  "report/Airbnb_Pricing_Project.Rmd",
  output_dir = "docs",
  knit_root_dir = here::here()
)
