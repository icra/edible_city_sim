repo_url <-  "http://cran.us.r-project.org"
local_folder <- "../R/library"

if(!require(tidyverse, lib.loc = local_folder)) 
  install.packages("tidyverse", lib = local_folder , repos = repo_url)
if(!require(stars, lib.loc = local_folder)) 
  install.packages("stars", lib = local_folder , repos = repo_url)
if(!require(parallel, lib.loc = local_folder)) 
  install.packages("parallel", lib = local_folder , repos = repo_url)
if(!require(ediblecity, lib.loc = local_folder)) 
  remotes::install_github("icra/edibleCity", lib = local_folder)

print("All installed")