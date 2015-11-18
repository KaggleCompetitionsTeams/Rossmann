###############################################################################
#Libraries#####################################################################
###############################################################################

libs <- c('readr', 'stringr')
sapply(libs, require, character.only=TRUE)

###############################################################################
#Submit function###############################################################
###############################################################################

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
