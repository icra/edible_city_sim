repo_url <-  "http://cran.us.r-project.org"
local_folder <- "../R/library"

install.packages("tidyverse", lib = local_folder , repos = repo_url)
install.packages("stars", lib = local_folder , repos = repo_url)
install.packages("parallel", lib = local_folder , repos = repo_url)
remotes::install_github("icra/edibleCity", lib = local_folder)
