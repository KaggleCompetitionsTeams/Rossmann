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

cat("reading the train and test data\n")
train <- read_csv(train_path,
                  col_types = list(
                    StateHoliday = col_factor(c("0", "a", "b", "c"))
                  ))

test <- read_csv(test_path,
                 col_types = list(
                   StateHoliday = col_factor(c("0", "a", "b", "c"))
                 ))

stores <- read_csv(store_path)