###############################################################################
#Libraries#####################################################################
###############################################################################

libs <- c('readr', 'stringr')
sapply(libs, require, character.only=TRUE)

###############################################################################
#Submit function#

submit <- function(pred_vec, file_path) {
  # this function takes as input 
  # pred_vec: a vector of sales predictions
  # file_path: a string which gives the path where to write the submission
  submit_df <- data.frame(Id = 1:41088, Sales = pred_vec)
  write_csv(submit_df, file_path)
}

# Example usage:
# submit(rep(0,nrow(test_data)), 
# "~/Documents/kaggle_data/kaggle_rossmann/submission1.csv")

#Error function#

rmspe <- function(true_vec, pred_vec) {
  # this function computes the rmspe given 
  # true_vec: a vector of observations
  # pred_vec: a vector of predictions
  error <- sqrt(mean( (true_vec - pred_vec)^2 / true_vec ))
  return(error)
}

#NA proportion#

na_proportion <- function(dataset, digits = 2) {
  # this function computes the proportion of missing values
  # for each column in dataset
  sapply(dataset, function(x) round(sum(is.na(x)) / length(x), digits = digits))
}