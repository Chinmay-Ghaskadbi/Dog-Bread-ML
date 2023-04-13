library(data.table)
library(Rtsne)
library(ggplot2)
library(caret)
library(ggplot2)
library(ClusterR)



data<-fread("./project/volume/data/raw/data.csv")
subfile <- fread("./project/volume/data/raw/example_sub.csv")


id<-data$id
data$id<-NULL

pca<-prcomp(data)

screeplot(pca)
summary(pca)
biplot(pca)

pca_dt<-data.table(unclass(pca)$x)
ggplot(pca_dt,aes(x=PC1,y=PC2))+geom_point()

#-------------------------------------------------------------

set.seed(3)

#Tried perplexity = 20, and 70. 20  Score a 3.2

tsne<-Rtsne(pca_dt,pca = T,perplexity=25, check_duplicates = F)

tsne_dt<-data.table(tsne$Y)

tsne_dt$id<-id

ggplot(tsne_dt,aes(x=V1,y=V2))+geom_point()

#-------------------------------------------------------------


k_bic<-Optimal_Clusters_GMM(tsne_dt[,.(V1,V2)],max_clusters = 10,criterion = "BIC")

delta_k<-c(NA,k_bic[-1] - k_bic[-length(k_bic)])

del_k_tab<-data.table(delta_k=delta_k,k=1:length(delta_k))

#-------------------------------------------------------------

opt_k<-4

gmm_data<-GMM(tsne_dt[,.(V1,V2)],opt_k)

#-------------------------------------------------------------

l_clust<-gmm_data$Log_likelihood^10

l_clust<-data.table(l_clust)

net_lh<-apply(l_clust,1,FUN=function(x){sum(1/x)})

cluster_prob<-1/l_clust/net_lh

#-------------------------------------------------------------


tsne_dt$Cluster_1_prob<-cluster_prob$V1
tsne_dt$Cluster_2_prob<-cluster_prob$V2
tsne_dt$Cluster_3_prob<-cluster_prob$V3
tsne_dt$Cluster_4_prob<-cluster_prob$V4


subfile$breed_1 <- tsne_dt$Cluster_1_prob
subfile$breed_2 <- tsne_dt$Cluster_2_prob
subfile$breed_3 <- tsne_dt$Cluster_3_prob
subfile$breed_4 <- tsne_dt$Cluster_4_prob

#------------------------------------------------------------

head(subfile)

ggplot(tsne_dt,aes(x=V1,y=V2,col=Cluster_1_prob))+geom_point()
ggplot(tsne_dt,aes(x=V1,y=V2,col=Cluster_2_prob))+geom_point()
ggplot(tsne_dt,aes(x=V1,y=V2,col=Cluster_3_prob))+geom_point()
ggplot(tsne_dt,aes(x=V1,y=V2,col=Cluster_4_prob))+geom_point()

fwrite(subfile,"./project/volume/data/processed/idk.csv") 








