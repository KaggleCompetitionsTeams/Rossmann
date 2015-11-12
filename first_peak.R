libs <- c('readr', 'tidyr', 'dplyr', 'ggplot2')
sapply(libs, require, character.only = TRUE)
train_path <- "~/Documents/kaggle_data/kaggle_rossmann/train.csv"
test_path <- "~/Documents/kaggle_data/kaggle_rossmann/test.csv"
store_path <- "~/Documents/kaggle_data/kaggle_rossmann/store.csv"

train <- read_csv(train_path)
test <- read_csv(test_path)
store <- read_csv(store_path)

View(train)
View(test)
View(store)

#train <- sample_frac(train, 0.1)

store_type_d <- filter(store, StoreType == "b")
store1_train <- filter(train, Store %in% store_type_d$Store)
store1_train <- filter(train, Store == 259)
#store1_train <- filter(train, DayOfWeek == 6 | DayOfWeek == 7)

g <- ggplot(store1_train, aes(x = DayOfWeek, y = Sales, colour = factor(Promo))) + geom_point()
g

test$Date[1]
