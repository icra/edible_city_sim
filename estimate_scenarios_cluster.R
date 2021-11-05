library(ediblecity)
library(tidyverse)
library(stars)
library(parallel)

args <- commandArgs()
args <- args[6:length(args)]

if (any(is.na(args))){
  args <- c("test", 1,1,1,0.5)
  warning("The args were not present and test args have been burnt")
}

set.seed(1119)

setwd(dirname(rstudioapi::getSourceEditorContext()$path))
source("shared_functions.R")


#define scenarios
n_sim <- 10

#load SVF for UHI indicator
SVF <- read_stars("SVF_3035.tif")

start_time <- Sys.time()

#set parallelizing
cl <- makeCluster(7)
clusterEvalQ(cl,library(ediblecity))
clusterSetRNGStream(cl)
clusterExport(cl, c("estimate_scenario", "SVF", "n_sim", "args"))

#simulations of one scenario n_sim times
results <- parSapply(cl, 1:n_sim, function(u) estimate_scenario(
                      as.numeric(args[2]),
                      as.numeric(args[3]),
                      as.numeric(args[4]),
                      as.numeric(args[5])
                      )
                     )
stopCluster(cl)

#save scenario simulations results
saveRDS(results, paste0("scenarios/",args[1],"_results.RDS"))

results_df <- tibble(.rows = 3)

#estimate confidence intervals for each indicator

results_df$UHI <- interval_(unlist(lapply(results[1,], function(x) x[[3]])))
results_df$runoff <- interval_(unlist(results[2,]))
results_df$green_d <- interval_(unlist(results[3,]))
results_df$no2_seq <- interval_(unlist(results[4,]))
results_df$volunteers <- interval_(unlist(results[5,]))
results_df$green_cap <- interval_(unlist(results[6,]))
results_df$jobs <- interval_(unlist(results[7,]))
results_df$food <- interval_(unlist(results[8,]))
results_df$edible_area <- interval_(unlist(results[9,]))

#save table of confidence intervals
write_excel_csv2(results_df, paste0("scenarios/",args[1],"_df.csv"))

stop_time <- Sys.time()
stop_time - start_time

