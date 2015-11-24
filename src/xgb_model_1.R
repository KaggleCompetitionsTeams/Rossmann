# Based on Ben Hamner script from Springleaf
# https://www.kaggle.com/benhamner/springleaf-marketing-response/random-forest-example
###############################################################################
#Libraries#####################################################################
###############################################################################

libs <- c('readr', 'xgboost')
sapply(libs, require, character.only = TRUE)

#my favorite seed^^

cat("reading the train and test data\n")
train <- read_csv('~/Documents/kaggle_data/kaggle_rossmann/data/train.csv',
                  col_types = list(
                    StateHoliday = col_factor(c("0", "a", "b", "c"))
                  ))

test <- read_csv('~/Documents/kaggle_data/kaggle_rossmann/data/test.csv',
                 col_types = list(
                   StateHoliday = col_factor(c("0", "a", "b", "c"))
                 ))

stores <- read_csv('~/Documents/kaggle_data/kaggle_rossmann/data/store.csv')

# joining

train <- inner_join(train, stores, by = 'Store')
test <- inner_join(test, stores, by = 'Store')

# There are some NAs in the integer columns so conversion to zero
train[is.na(train)]   <- 0
test[is.na(test)]   <- 0



# looking at only stores that were open in the train set
# may change this later
train <- train[ which(train$Open=='1'),]
train <- train[ which(train$Sales!='0'),]

train$Date <- ymd(train$Date, tz = "Europe/Berlin")
test$Date <- ymd(test$Date, tz = "Europe/Berlin")
train$month <- month(train$Date)
test$month <- month(test$Date)
train$year <- year(train$Date)
test$year <- year(test$Date)
train$day <- day(train$Date)
test$day <- day(test$Date)

train <- train[,-c(3)]

test <- test[,-c(4)]

feature.names <- names(train)[c(1,2,5:20)]
cat("Feature Names\n")
feature.names

cat("assuming text variables are categorical & replacing them with numeric ids\n")
for (f in feature.names) {
  if (class(train[[f]])=="character") {
    levels <- unique(c(train[[f]], test[[f]]))
    train[[f]] <- as.integer(factor(train[[f]], levels=levels))
    test[[f]]  <- as.integer(factor(test[[f]],  levels=levels))
  }
}


tra<-train[,feature.names]
RMPSE<- function(preds, dtrain) {
  labels <- getinfo(dtrain, "label")
  elab<-exp(as.numeric(labels))-1
  epreds<-exp(as.numeric(preds))-1
  err <- sqrt(mean((epreds/elab-1)^2))
  return(list(metric = "RMPSE", value = err))
}

h<-sample(nrow(train),10000)

dval<-xgb.DMatrix(data=data.matrix(tra[h,]),label=log(train$Sales+1)[h])
dtrain<-xgb.DMatrix(data=data.matrix(tra[-h,]),label=log(train$Sales+1)[-h])
watchlist<-list(val=dval,train=dtrain)
param <- list(  objective           = "reg:linear", 
                booster = "gbtree",
                eta                 = 0.25, # 0.06, #0.01,
                max_depth           = 8, #changed from default of 8
                subsample           = 0.7, # 0.7
                colsample_bytree    = 0.7 # 0.7
                
                # alpha = 0.0001, 
                # lambda = 1
)

clf <- xgb.train(   params              = param, 
                    data                = dtrain, 
                    nrounds             = 700, 
                    verbose             = 1,
                    early.stop.round    = 30,
                    watchlist           = watchlist,
                    maximize            = FALSE,
                    feval=RMPSE
)
pred <- exp(predict(clf, data.matrix(test[,feature.names]))) -1
set_pred_closed(pred)
cat("saving the submission file\n")
submit(pred, 
       "~/Documents/kaggle_data/kaggle_rossmann/submissions/submission_xgb_3.csv")

# without set_pred_closed : 0.11714 (submission_xgb_1.csv)
# with set_pred_closed: same score !
# with stateholydays correctly handled (submission_xgb_3) 0.11127