rda_files <- list.files("./results", pattern = "\\.rda$", full.names = TRUE)
data_list <- list()
for (file in rda_files) {
  temp_env <- new.env()
  load(file, envir = temp_env)
  data <- get(ls(temp_env)[1], envir = temp_env)
  data_list[[file]] <- data
}
results <- data.frame(do.call(rbind, data_list))
save(results, file = paste0("./results.rda"))