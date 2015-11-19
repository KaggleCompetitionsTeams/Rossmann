# Based on Ben Hammer script from Springleaf
# https://www.kaggle.com/benhamner/springleaf-marketing-response/random-forest-example

###############################################################################
#Libraries#####################################################################
###############################################################################

libs <- c('readr', 'randomForest', 'dplyr', 'lubridate', 'magrittr')
sapply(libs, require, character.only = TRUE)

###############################################################################
#Data loading##################################################################
###############################################################################

cat("reading the train, test and store data\n")
train <- read_csv('~/Documents/kaggle_data/kaggle_rossmann/train.csv')
test <- read_csv('~/Documents/kaggle_data/kaggle_rossmann/test.csv')
stores <- read_csv('~/Documents/kaggle_data/kaggle_rossmann/store.csv')

###############################################################################
#Data prep#####################################################################
###############################################################################

train <- inner_join(train, stores, by = 'Store')
test <- inner_join(test, stores, by = 'Store')

# NA handling

train[is.na(train)] <- 0
test[is.na(test)] <- 0

# date parsing
train$Date <- train$Date %>% ymd()
test$Date <- test$Date %>% ymd()
train$month <- month(train$Date)
test$month <- month(test$Date)
train$year <- year(train$Date)
test$year <- year(test$Date)
train$day <- day(train$Date)
test$day <- day(test$Date)

train <- train %>% select(-Date)
test <- test %>% select(-Date)

# State holiday too many NAs we remove it

train <- train %>% select(-StateHoliday)
test <- test %>% select(-StateHoliday)

# we only look at open shops
train <- filter(train, Open == 1)

feature.names <- names(train)[c(1,2,6,8:12,14:19)]
feature.names
cat("assuming text variables are categorical & replacing them with numeric ids\n")
for (f in feature.names) {
  if (class(train[[f]])=="character") {
    levels <- unique(c(train[[f]], test[[f]]))
    train[[f]] <- as.integer(factor(train[[f]], levels=levels))
    test[[f]]  <- as.integer(factor(test[[f]],  levels=levels))
  }
}

cat("checking all stores are accounted for\n")
length(unique(train$Store))

###############################################################################
#Random Forest Fitting#########################################################
###############################################################################

clf <- randomForest(train[,feature.names], 
                    log(train$Sales+1),
                    mtry=5,
                    ntree=50,
                    sampsize=100000,
                    do.trace=TRUE)

cat("model stats\n")
clf
cat("print model\n")
print(clf)
cat("Importance 1\n")
importance(clf)
cat("Permutation Importance Unscaled\n")
importance(clf, type = 1)
cat("GINI Importance\n")
importance(clf, type = 2)
cat("Plot Model\n")
plot(clf)
cat("Plot Importance\n")
plot(importance(clf), lty=2, pch=16)

cat("Predicting Sales\n")

pred <- exp(predict(clf, test)) -1

submit(pred, "~/Documents/kaggle_data/kaggle_rossmann/submission_rf_1.csv")
