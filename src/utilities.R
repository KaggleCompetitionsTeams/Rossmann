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
  submit_df <- data.frame(Id = seq_along(pred_vec), Sales = pred_vec)
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
  non_zero_indices <- which(true_vec > 0)
  error <- sqrt(mean( (true_vec[non_zero_indices] - pred_vec[non_zero_indices])^2 / true_vec[non_zero_indices] ))
  return(error)
}

#NA proportion#

na_proportion <- function(dataset, digits = 2) {
  # returns the proportion of missing values
  # in each column of dataset, for which there is NAs
  na_col <- names(which(apply(dataset, 2, function(x) any(is.na(x))) == TRUE))
  if (length(na_col) >= 1) {
    sapply(select(dataset, one_of(na_col)), 
           function(x) round(sum(is.na(x)) / length(x), digits = digits))
  } else {
    cat("No missing values.")
  }
}

#Set pred to zero
set_pred_closed <- function(pred_vec) {
  # this function set to zero the Sales predictions
  # anytime the shop is closed in the test set
  pred_vec[which(test$Open == 0)] <- 0
}

#Validation set
split_period <- function(begin_date, end_date) {
  validation_interval <- interval(begin_validation, end_validation)
  logical_interval <- train$Date %within% validation_interval
  split_test <- list(train_train = train[!logical_interval, ],
                     train_test = train[logical_interval, ])
  return(split_test)
}