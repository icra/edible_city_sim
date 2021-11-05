library(ediblecity)
library(tidyverse)
library(stars)
library(parallel)

args <- commandArgs()
args <- args[6:length(args)]
args <- c("test", 1,1,1,0.5)

set.seed(1119)

setwd(dirname(rstudioapi::getSourceEditorContext()$path))
source("shared_functions.R")


#define scenarios
n_sim <- 3

#load SVF for UHI indicator
SVF <- read_stars("SVF_3035.tif") #cal preparar aquest arxiu en un repositori

start_time <- Sys.time()

  #set parallelizing
  cl <- makeCluster(11)
  clusterEvalQ(cl,library(ediblecity))
  clusterSetRNGStream(cl)
  clusterExport(cl, c("estimate_scenario", "SVF", "scenarios", "n_sim", "i"))

  #simulations of one scenario n_sim times
  results <- parSapply(cl, 1:n_sim, function(u) estimate_scenario(
                        args[2],
                        args[3],
                        args[4],
                        args[5]
                        )
                       )
  stopCluster(cl)

  #handling results
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

  assign(scenarios$names[i], results_df)

}
stop_time <- Sys.time()
stop_time - start_time

all_dfs <- list("BAU" = BAU,
                "S1" = S1,
                "S2.0" = S2.0,
                "S2.25" = S2.25,
                "S2.50" = S2.50,
                "S2.75" = S2.75,
                "S2.100" = S2.100,
                "S3.0" = S3.0,
                "S3.25" = S3.25,
                "S3.50" = S3.50,
                "S3.75" = S3.75,
                "S3.100" = S3.100)
saveRDS(all_dfs, "scenarios/all_dfs.RDS")
