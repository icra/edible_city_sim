#define the function to estimate indicators for each scenario
estimate_scenario <- function(pGardens, pVacant, pRooftop, pCommercial){

  scenario <- suppressWarnings(set_scenario(
    ediblecity::city_example,
    pGardens = pGardens,
    pVacant = pVacant,
    pRooftop = pRooftop,
    pCommercial = pCommercial))

  results <- list()

  results$UHI <- ediblecity::UHI(scenario, SVF = SVF, verbose = F)
  results$runoff <- runif(1)
  results$green_distance <- ediblecity::green_distance(scenario, percent_out = T)
  results$no2_seq <- ediblecity::no2_seq(scenario)
  results$volunteers <- ediblecity::edible_volunteers(scenario, verbose=T)
  results$green_cap <- ediblecity::green_capita(scenario,
                                                private = T,
                                                neighbourhoods = neighbourhoods,
                                                inh_col = 'inhabitants',
                                                name_col = 'name',
                                                min_inh = 300)
  results$jobs <- ediblecity::edible_jobs(scenario, verbose = T)
  results$food <- ediblecity::food_production(scenario, verbose = T)
  results$edible_area <- sum(scenario$edible_area, na.rm=T)


  return(results)

}

#define a function to return confidence intervals
interval_ <- function(x){
  quantile(x, c(0.05, 0.5, 0.95), names=F)
}
