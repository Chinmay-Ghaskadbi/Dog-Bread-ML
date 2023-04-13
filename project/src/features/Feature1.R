library(data.table)
library(caret)

example_sub<-fread("./project/volume/data/raw/example_sub.csv")

head(example_sub)

example_sub[, c("breed_1", "breed_2")] <- 0.5

example_sub[, c("breed_3", "breed_4")] <- 0

head(example_sub)

fwrite(example_sub,"./project/volume/data/processed/weirdsubmit.csv") 


