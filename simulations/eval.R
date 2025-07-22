################################################################################
# download data
################################################################################
load(file = paste0("./results.rda"))
true_rhos = c(0.9, 0.5, 0.1)
ni_group = c(200, 1000)
k_group = c(10, 20, 30, 40, 50)
################################################################################
# calculate SE
################################################################################
final_results <- data.frame()
for (rr in 1:length(true_rhos)){
  for (nn in 1:length(ni_group)){
    for (kk in 1:length(k_group)){
      DD = subset(results, true_rho==true_rhos[rr] & samples_n_i==ni_group[nn] & samples_k==k_group[kk])
      DD$SE[DD$SE == 999] <- NaN
      true_SE <- sd(DD$est_rho)
      DD$true_SE <- true_SE
      DD$SE_bias <- DD$SE - true_SE
      final_results <- rbind(final_results, DD)
    }
  }
}
results = final_results
rm(DD, final_results)
################################################################################
# calculate delta_i
################################################################################
est_rho_bias = abs(results$est_rho - results$true_rho)
est_rho_onlysamplemeans_bias = abs(results$est_rho_onlysamplemeans - results$true_rho)
est_rho_naive_bias = abs(results$naive_rho - results$true_rho)

results$delta_rho1 = est_rho_bias - est_rho_onlysamplemeans_bias
results$delta_rho2 = est_rho_bias - est_rho_naive_bias
################################################################################
# CI coverage rate
################################################################################
results_sub = subset(results, samples_n_i==200)
# cover rate
for (ii in 1:length(true_rhos)) {
  print('true rho:')
  print(true_rhos[ii])
  for(kk in 1:5){
    DD = subset(results_sub, true_rho==true_rhos[ii] & samples_k==kk*10 & CI_1_cover==1)
    ratio = nrow(DD)/1000
    print(ratio)
  }
}
#average width
for (ii in 1:length(true_rhos)) {
  print('true rho is:')
  print(true_rhos[ii])
  for(kk in 1:5){
    DD = subset(results_sub, true_rho==true_rhos[ii] & samples_k==kk*10)
    widths = DD$CI_1_up - DD$CI_1_low
    average = mean(widths, na.rm = TRUE)
    print(average)
  }
}
rm(results_sub, DD)
################################################################################
# The results of estimated rho
################################################################################
library(ggplot2)
for (ii in 1:length(true_rhos)){
  rho = true_rhos[ii]
  DD1 = subset(results, true_rho == rho & samples_n_i == 200)
  DD2 = subset(results, true_rho == rho & samples_n_i == 1000)
  
  DD1$group <- "ni around 200"
  DD2$group <- "ni around 1000"
  combined_data <- rbind(DD1, DD2)
  
  combined_data$samples_k <- as.factor(combined_data$samples_k)
  combined_data$group <- as.factor(combined_data$group)
  
  gplot <- ggplot(combined_data, aes(x = est_rho, y = samples_k, fill = group)) +
    geom_boxplot() + 
    geom_vline(xintercept = rho, color = "red", linetype = "dashed", size = 0.8) +
    scale_fill_manual(values = c( "lightgrey","white"),
                      guide = guide_legend(reverse = TRUE) ) +
    labs(
      title = bquote( rho == .(rho) ~ "for different" ~ n[i] ~ "ranges"),
      x = expression(hat(rho)),
      y = expression(k)
    ) +
    theme(
      plot.title = element_text(size = 20, face = "bold", hjust = 0.5, family = "serif"),
      legend.title = element_blank(),
      axis.title.y = element_text(angle = 0, size = 16, family = "serif"),
      axis.title.x = element_text(size = 16, family = "serif"),
      axis.text = element_text(size = 14, family = "serif"),
      legend.text = element_text(size = 14, family = "serif"),
      legend.position = c(0.01, 0.99), 
      legend.justification = c("left", "top")
    )
  plot(gplot)
}
################################################################################
# Compare the results of estimated rho by 3 different methods
################################################################################
library(ggplot2)
library(ggpattern)
fill_colors <- c(
  "Proposed Method" = "white",  
  "Weighted Mean-Based" = "gray50",  
  "Naive Mean-Based" = "white"  
)
pattern_types <- c(
  "Proposed Method" = "stripe",  
  "Weighted Mean-Based" = "none",  
  "Naive Mean-Based" = "none"  
)
for (ii in 1:length(true_rhos)){
  rho = true_rhos[ii]
  DD = subset(results, true_rho == rho & samples_n_i == 200)
  method_data <- data.frame(
    samples_k = factor(rep(DD$samples_k, 3)), 
    est_rho = c(DD$est_rho, DD$est_rho_onlysamplemeans, DD$naive_rho),
    method = factor(rep(c("Proposed Method", "Weighted Mean-Based", "Naive Mean-Based"), each = nrow(DD)),
                    levels = c("Naive Mean-Based", "Weighted Mean-Based", "Proposed Method")
                    )
  )
  gplot <- ggplot(method_data, aes(x = est_rho, y = samples_k, fill = method, pattern = method)) +
    geom_boxplot_pattern(
      aes(pattern_fill = method), 
      pattern_density = 0.1, 
      pattern_spacing = 0.02,
      pattern_fill = "black", 
      pattern_colour = "black", 
      pattern_angle = 45, 
      alpha = 0.5 
    ) +
    geom_vline(xintercept = rho, color = "red", linetype = "dashed", linewidth = 0.8) + 
    
    scale_pattern_manual(values = pattern_types) +  
    scale_fill_manual(values = fill_colors) +  
    guides(pattern = guide_legend(reverse = TRUE), fill = guide_legend(reverse = TRUE)) +  
    
    labs(
      title = bquote( rho == .(rho) ~ " "),
      x = expression(hat(rho)),
      y = expression(k)
    ) +
    theme(
      plot.title = element_text(size = 20, face = "bold", hjust = 0.5, family = "serif"),
      legend.title = element_blank(),
      axis.title.y = element_text(angle = 0, size = 16, family = "serif"),
      axis.title.x = element_text(size = 16, family = "serif"),
      axis.text = element_text(size = 14, family = "serif"),
      legend.text = element_text(size = 14, family = "serif"),
      legend.position.inside = c(0.01, 0.99), 
      legend.justification = c("left", "top") 
    )
  plot(gplot)
}
################################################################################
# Compare the estimated results (delta) from 3 different methods
################################################################################
library(ggplot2)
for (ii in 1:length(true_rhos)){
  rho = true_rhos[ii]
  DD1 = subset(results, true_rho == rho & samples_n_i == 200)
  DD2 = subset(results, true_rho == rho & samples_n_i == 1000)
  
  DD1$group <- "ni around 200"
  DD2$group <- "ni around 1000"
  combined_data <- rbind(DD1, DD2)
  
  combined_data$samples_k <- as.factor(combined_data$samples_k)
  combined_data$group <- as.factor(combined_data$group)
  
  gplot <- ggplot(combined_data, aes(x = delta_rho1, y = samples_k, fill = group)) +
    geom_boxplot() +
    geom_vline(xintercept = 0, color = "red", linetype = "dashed", size = 0.8) +
    scale_fill_manual(values = c( "lightgrey","white"),
                      guide = guide_legend(reverse = TRUE) ) +
    labs(
      title = bquote( rho == .(rho) ~ "for" ~ delta[1]),
      x = expression(delta),
      y = expression(k)
    ) +
    xlim(-0.5, 0.5) +
    theme(
      plot.title = element_text(size = 20, face = "bold", hjust = 0.5, family = "serif"),
      legend.title = element_blank(),
      axis.title.y = element_text(angle = 0, size = 16, family = "serif"),
      axis.title.x = element_text(size = 16, family = "serif"),
      axis.text = element_text(size = 14, family = "serif"),
      legend.text = element_text(size = 14, family = "serif"),
      legend.position = c(0.01, 0.99),
      legend.justification = c("left", "top")
    )
  plot(gplot)
}

# T test of delta
for (rr in 1:length(true_rhos)){
  for (nn in 1:length(ni_group)){
    for (kk in 1:length(k_group)){
      DD = subset(results, true_rho==true_rhos[rr] & samples_n_i==ni_group[nn] & samples_k==k_group[kk])
      test = t.test(DD$delta_rho1, mu = 0, alternative = "less")
      p_value = test$p.value
      significant = ifelse(p_value < 0.05, 1, 0)
      print(paste("Setting: rho =", true_rhos[rr], 
                  ", n_i =", ni_group[nn], 
                  ", k =", k_group[kk], 
                  ", p-value =", round(p_value, 5), 
                  ", Significant =", significant))
    }
  }
}

################################################################################
######## Bias of estimated SE
################################################################################
library(ggplot2)
for (ii in 1:length(true_rhos)){
  rho = true_rhos[ii]
  DD1 = subset(results, true_rho == rho & samples_n_i == 200)
  DD2 = subset(results, true_rho == rho & samples_n_i == 1000)
  
  DD1$group <- "ni around 200"
  DD2$group <- "ni around 1000"
  combined_data <- rbind(DD1, DD2)
  
  combined_data$samples_k <- as.factor(combined_data$samples_k)
  combined_data$group <- as.factor(combined_data$group)
  
  gplot <- ggplot(combined_data, aes(x = SE_bias, y = samples_k, fill = group)) +
    geom_boxplot() +
    geom_vline(xintercept = 0, color = "red", linetype = "dashed", size = 0.8) +
    scale_fill_manual(values = c( "lightgrey","white")
                      ,guide = guide_legend(reverse = TRUE)
                      ) +
    labs(
      title = bquote( rho == .(rho) ~ "for different" ~ n[i] ~ "ranges"),
      x = expression(hat(SE) - SE),
      y = expression(k)
    ) +
    theme(
      plot.title = element_text(size = 20, face = "bold", hjust = 0.5, family = "serif"),
      legend.title = element_blank(),
      axis.title.y = element_text(angle = 0, size = 16, family = "serif"),
      axis.title.x = element_text(size = 16, family = "serif"),
      axis.text = element_text(size = 14, family = "serif"),
      legend.text = element_text(size = 14, family = "serif"),
      legend.position = c(0.99, 0.99),
      legend.justification = c("right", "top")
    )
  plot(gplot)
}
################################################################################
#QQ & hist
################################################################################
# histogram
par(family = "serif")
par(mfcol=c(1,5))
for (rr in 1:length(true_rhos)){
  for (nn in 1:length(ni_group)){
    for (kk in 1:length(k_group)){
      ni_size = ni_group[nn]
      k_size = k_group[kk]
      rho = true_rhos[rr]
      DD = subset(results, true_rho==rho & samples_n_i==ni_size & samples_k==k_size)
      hist(DD$est_rho, xlab = expression(rho), 
           main = bquote(rho == .(rho) ~ " & ni range:" ~ .(ni_size) ~ " & " ~ k == .(k_size)))
    }
  }
}
# qqplot
par(family = "serif")
par(mfcol=c(1,5))
for (rr in 1:length(true_rhos)){
  for (nn in 1:length(ni_group)){
    for (kk in 1:length(k_group)){
      ni_size = ni_group[nn]
      k_size = k_group[kk]
      rho = true_rhos[rr]
      DD = subset(results, true_rho==rho & samples_n_i==ni_size & samples_k==k_size)
      qqnorm(DD$est_rho, main = bquote(rho == .(rho) ~ " & ni range:" ~ .(ni_size) ~ " & " ~ k == .(k_size)))
      qqline(DD$est_rho, distribution = qnorm, qtype = 7, col = 'darkred')
    }
  }
}