args <- commandArgs(trailingOnly = TRUE) # take command argument
seed_index = as.numeric(args[1]) # passing first argument(seed's index)
print(seed_index)

load(file = paste0("./seeds.rda"))
library(ebdm)
RNGkind(kind = "L'Ecuyer-CMRG", normal.kind = "Inversion", sample.kind = "Rejection")
seed = seeds[seed_index]
set.seed(seed)
print(runif(1, min = 0, max = 1))


library(MASS)
true_rhos = c(0.9, 0.8, 0.7, 0.6, 0.5, 0.4, 0.3, 0.2, 0.1, 0, -0.1, -0.2, -0.3, -0.4, -0.5, -0.6, -0.7, -0.8, -0.9)
k_values = c(10,20,30,40,50)

# Function that generates the sample
generate_samples <- function(mu_X, mu_Y, sigma_X, sigma_Y, rho, n_samples) {
  mu <- c(mu_X, mu_Y)
  Sigma <- matrix(c(sigma_X^2, rho * sigma_X * sigma_Y,rho * sigma_X * sigma_Y, sigma_Y^2), nrow = 2)
  samples <- mvrnorm(n = n_samples, mu = mu, Sigma = Sigma)
  return(samples)
}

simulation_results <- list()

for (ii in 1:length(true_rhos)) {
  for (n_level in 1:2){
    for(kk in 1:length(k_values)){
      
      print(ii)
      # Parameters settings
      true_mu_X <- 0
      true_mu_Y <- 0
      true_sigma_X <- 1
      true_sigma_Y <- 1
      true_rho = true_rhos[ii]
      k_value = k_values[kk]
      if (n_level == 1) {
        nmin <- 100
        nmax <- 200
      } else {
        nmin <- 800
        nmax <- 1000
      }
      n_samples_list <- sample(nmin:nmax, k_value, replace = TRUE)

      # Generate Data
      simulated_data <- data.frame(Mean_X = numeric(k_value), Mean_Y = numeric(k_value), Variance_X = numeric(k_value), Variance_Y = numeric(k_value), Sample_Size = integer(k_value))
      
      
      for (i in 1:k_value) {
        n_samples <- n_samples_list[i]
        samples <- generate_samples(true_mu_X, true_mu_Y, true_sigma_X, true_sigma_Y, true_rho, n_samples)
        mean_X <- mean(samples[, 1])
        mean_Y <- mean(samples[, 2])
        var_X <- var(samples[, 1])
        var_Y <- var(samples[, 2])
        simulated_data[i, ] <- c(mean_X, mean_Y, var_X, var_Y, n_samples)
      }
      rm(i, samples, mean_X, mean_Y, var_X, var_Y)
      
      
      est1 <- cor_cont(simulated_data$Sample_Size, simulated_data$Mean_X, simulated_data$Mean_Y,
                       simulated_data$Variance_X, simulated_data$Variance_Y, method = "proposed", ci_method = "normal")
      est2 <- cor_cont(simulated_data$Sample_Size, simulated_data$Mean_X, simulated_data$Mean_Y,
                       simulated_data$Variance_X, simulated_data$Variance_Y, method = "proposed", ci_method = "lr")
      est3 <- cor_cont(simulated_data$Sample_Size, simulated_data$Mean_X, simulated_data$Mean_Y, method = "weighted")
      
      naive_mle = cor(simulated_data$Mean_X, simulated_data$Mean_Y, method = "pearson")
      
      
      
      CI_1_up = est1$ci["upper"]
      CI_1_low = est1$ci["lower"]
      CI_1_up  <- if (!is.null(est1$ci)) est1$ci["upper"] else NA
      CI_1_low <- if (!is.null(est1$ci)) est1$ci["lower"] else NA
      CI_2_up = est2$ci["upper"]
      CI_2_low = est2$ci["lower"]
      
      CI_1_cover <- if (!is.null(est1$ci) &&
                        true_rho >= CI_1_low &&
                        true_rho <= CI_1_up) {1} else {0}
      if(true_rho<=CI_2_up & true_rho>=CI_2_low){
        CI_2_cover = 1
      }else{CI_2_cover = 0}
      
      result <- list(
        samples_k = k_value,
        samples_n_i = nmax,
        true_rho = true_rho,
        est_rho = est1$rho,
        est_rho_onlysamplemeans = est3$rho,
        naive_rho = naive_mle,
        true_mu_X = true_mu_X,
        est_mu_X = est1$mu_x,
        true_mu_Y = true_mu_Y,
        est_mu_Y = est1$mu_y,
        true_sigma_X = true_sigma_X,
        est_sigma_X = est1$sigma_x,
        true_sigma_Y = true_sigma_Y,
        est_sigma_Y = est1$sigma_y,
        SE = est1$se,
        CI_1_up = CI_1_up,
        CI_1_low = CI_1_low,
        CI_1_cover = CI_1_cover,
        CI_2_up = CI_2_up,
        CI_2_low = CI_2_low,
        CI_2_cover = CI_2_cover
      )
      simulation_results[[length(simulation_results) + 1]] <- result
    }
  }
}

result <- do.call(rbind, lapply(simulation_results, as.data.frame))
save(result, file = paste0("./2cv/","result_",seed_index,".rda"))