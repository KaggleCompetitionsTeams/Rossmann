# In the following, 'merged' is the data frame resulting from the merging
# of train and store data.


# Distribution of stores in CompetitionDistance (histogram)
ggplot(merged, aes(x=CompetitionDistance)) + 
  geom_histogram(col='black', fill='white', binwidth=100) + 
  xlim(0, 4000) + theme_bw()


# Scatterplot Sales vs CompetitionDistance
ggplot(merged, aes(x=CompetitionDistance, y=Sales)) + 
  stat_density2d(aes(fill=..level..), bins=30, geom="polygon") + 
  xlim(0, 4000) + theme_bw()


# Plot the training period for stores with the lowest number (758) of training days
unlucky.stores <- (1:1115)[tapply(merged$Store, 
                                  merged$Store, 
                                  function(x) length(x)<800)]
ggplot(merged[merged$Store %in% unlucky.stores,], aes(x=as.POSIXlt(Date), y=Store, col=Store)) + 
  geom_point()