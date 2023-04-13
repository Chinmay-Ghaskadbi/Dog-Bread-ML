library(data.table)
library(Rtsne)
library(ggplot2)
library(caret)
library(ggplot2)
library(ClusterR)


set.seed(3)

data<-fread("./project/volume/data/raw/data.csv")

id<-data$id
data$id<-NULL

pca<-prcomp(data)

screeplot(pca)
summary(pca)
biplot(pca)

pca_dt<-data.table(unclass(pca)$x)
ggplot(pca_dt,aes(x=PC1,y=PC2))+geom_point()

pca_dt$id<-id

list_of_cols <- pca_dt[,c(1:15)]

pca_dt$G1 <- pca_dt$PC1 > 12

pca_dt$breed_1 <- 0.30
pca_dt[G1 == 11]$breed_1 <-0.10

pca_dt$breed_2 <- 0.30
pca_dt [G1 == 1]$breed_2 <- 0.10

pca_dt$breed_3 <- 0.30
pca_dt [G1 == 1]$breed_3 <- 0.10

pca_dt$breed_4 <- 0.10
pca_dt [G1 == 1]$breed_3 <- 0.70

output$breed_1 <- pca_dt$breed_1
output$breed_2 <- pca_dt$breed_2
output$breed_3 <- pca_dt$breed_3
output$breed_4 <- pca_dt$breed_4


fwrite(output,"./project/volume/data/processed/wierdsub2.csv") 

print("Done")
