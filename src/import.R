###############################################################################
# Import libraries#############################################################
###############################################################################

libs <- c('readr')
sapply(libs, require, character.only=TRUE)

###############################################################################
# Import data##################################################################
###############################################################################

train_path <- "~/Documents/kaggle_data/kaggle_rossmann/data/train.csv"
test_path <- "~/Documents/kaggle_data/kaggle_rossmann/data/test.csv"
store_path <- "~/Documents/kaggle_data/kaggle_rossmann/data/store.csv"

train_data <- read_csv(train_path)
test_data <- read_csv(test_path)
stores_data <- read_csv(store_path)