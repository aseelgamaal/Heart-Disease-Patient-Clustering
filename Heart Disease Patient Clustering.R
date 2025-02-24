#for preprocessing
#1-remove id col
#2-remove na by mean for numerical data and mode to the categorical data ( we don't found any numeical data nulls)
#3-handle age negative ( Not exist)
#5-remove duplicates=>i dont think that there are any but i added it for ressurance
#6-remove outliers

mydata<-read.csv("C:/Users/Nadeen/Documents/Heartdiseas.txt",fill=TRUE,na.strings = "")
mydata<-mydata[-1]
str(mydata)
summary(mydata)
dim(mydata)

# Check if any NA values exist
if (any(is.na(mydata))) {
  print("There is Null")
  colSums(is.na(mydata))
  
  # List columns with missing values
  colnames(mydata)[colSums(is.na(mydata)) > 0]
} else {
  print("No Null values found")
}

# Calculate the frequency of each unique value in the 'slope' column
value_counts <- table(mydata$slope)
value_counts

mode_value <- as.numeric(names(which.max(value_counts)))

cat("The most frequent value (mode) in the slope column is:", mode_value, "\n")
mydata$slope[is.na(mydata$slope)] <- mode_value

if (any(is.na(mydata$slope))) {
  print("There is Null")
} else {
  print("No Null values found")
}


# there is duplicates 
dim(mydata)
mydata <- mydata[!duplicated(mydata), ]
dim(mydata)
replace_outliers<-function(data,col){
  q1<-quantile(data[[col]],0.25,na.rm=TRUE)
  q3<-quantile(data[[col]],0.75,na.rm=TRUE)
  IQR<- q3-q1
  lower<-q1-(1.5*IQR)
  upper<-q3+(1.5*IQR)
  data[[col]][data[[col]] < lower] <- lower
  data[[col]][data[[col]] > upper] <- upper
  return(data)
  
}

modifiedData<-mydata

# Apply outlier replacement to specific columns
columns_with_outliers <- c("chol", "trestbps", "thalach") # Specify columns
for (col in columns_with_outliers) {
  modifiedData<- replace_outliers(modifiedData, col)
}

#par(mfcol = c(2,1))

boxplot(mydata)

boxplot(modifiedData)


#-------------------------------------------------------------#
#Clustering Algorithms

# KMeans
install.packages("cluster")
library(cluster)

elbow_method <- function(data, max_clusters = 10) {
  wss <- numeric(max_clusters)
  
  for (k in 1:max_clusters) {
    kmeans_result <- kmeans(data, centers = k)
    wss[k] <- sum(kmeans_result$withinss,0)
  }
  
  plot(1:max_clusters, wss, type = "b", pch = 19, frame = FALSE,
       xlab = "Number of Clusters", ylab = "Within-Cluster Sum of Squares",
       main = "Elbow Method")
}

elbow_method(mydata, max_clusters = 15)
elbow_method(modifiedData, max_clusters = 15)

kmeanresult<-kmeans(mydata,3)
kmeanresult2<-kmeans(modifiedData,3)


plot(mydata$chol, mydata$thalach, 
     col = kmeanresult$cluster, 
     pch = 19, 
     main = "Cluster Visualization (Thalach vs Chol)", 
     xlab = "Maximum Heart Rate Achieved (Thalach)", 
     ylab = "Serum Cholesterol (Chol)")

plot(modifiedData$chol, modifiedData$thalach, 
     col = kmeanresult2$cluster, 
     pch = 19, 
     main = "Cluster Visualization (Thalach vs Chol)", 
     xlab = "Maximum Heart Rate Achieved (Thalach)", 
     ylab = "Serum Cholesterol (Chol)")

#---------------------------------------------------------------------------
#DBSCAN algorithm :
install.packages("dbscan")
library(dbscan)
dbscan_result <- dbscan(mydata, eps = 29, minPts = 3)
dbscan_result
#--------------------------------------------------------------------------
# Hierarchical Clustering
if (!require("cluster")) install.packages("cluster")
if (!require("factoextra")) install.packages("factoextra")
if (!require("ggplot2")) install.packages("ggplot2")
library(cluster)
library(factoextra)
library(ggplot2)

# Select only numeric columns from the dataset (make sure there are no non-numeric columns)
mydata_numeric <- mydata[sapply(mydata, is.numeric)]
mydata_numeric2 <- modifiedData[sapply(modifiedData, is.numeric)]

# Remove rows with missing values (you can also impute them if necessary)
mydata_numeric <- na.omit(mydata_numeric)
mydata_numeric2 <- na.omit(mydata_numeric2)

# Compute the distance matrix (Euclidean by default)
dist_matrix <- dist(mydata_numeric)
dist_matrix2 <- dist(mydata_numeric2)

# Perform hierarchical clustering using Ward's method
hc_result <- hclust(dist_matrix, method = "ward.D2")
hc_result2 <- hclust(dist_matrix2, method = "ward.D2")

# Plot the dendrogram
plot(hc_result, 
     main = "Hierarchical Clustering Dendrogram",
     xlab = "Observation Points",
     sub = "",
     cex = 0.6)  # Adjust size of text labels on the dendrogram

plot(hc_result2, 
     main = "Hierarchical Clustering Dendrogram",
     xlab = "Observation Points",
     sub = "",
     cex = 0.6)  # Adjust size of text labels on the dendrogram



# Display cluster assignments (optional)
clusters <- cutree(hc_result, 2)
clusters2 <- cutree(hc_result2, 2)

print(clusters)
print(clusters2)
#----------------------------------------------------------------------------------------------------------------------------
par(mfcol = c(2,1))

#Kmediods
# Install and load the cluster package (if not installed)
if (!require("cluster")) install.packages("cluster")
library(cluster)

# best k
k <- 3

# Perform K-Medoids clustering using PAM (Partitioning Around Medoids)
kmedoids_result <- pam(mydata, k)
kmedoids_results <- pam(modifiedData, k)


# View the clustering result
print(kmedoids_result)

# Get the cluster labels (which cluster each point belongs to)
clusters <- kmedoids_result$clustering

# Plot the clusters (using two columns like 'chol' and 'thalach' for simplicity)
# You can choose other columns for better visualization.
plot(mydata$chol, mydata$thalach, 
     col = clusters, pch = 19, 
     main = "K-Medoids Clustering", 
     xlab = "Cholesterol (Chol)", ylab = "Thalach")

# Add a legend to the plot
legend("topright", legend = unique(clusters), 
       col = unique(clusters), pch = 19, title = "Clusters")


plot(modifiedData$chol, modifiedData$thalach, 
     col = clusters, pch = 19, 
     main = "K-Medoids Clustering", 
     xlab = "Cholesterol (Chol)", ylab = "Thalach")

# Add a legend to the plot
legend("topright", legend = unique(clusters), 
       col = unique(clusters), pch = 19, title = "Clusters")

# compare which the best algorism

par(mfrow = c(2, 2))
plot(mydata$chol, mydata$thalach, col = kmeanresult$cluster, main = "K-Means Clustering")
plot(modifiedData$chol, modifiedData$thalach, col = kmedoids_results$clustering, main = "K-Medoids Clustering")
plot(mydata$chol, mydata$thalach, col =clusters , main = "Hierarchical Clustering")
plot(mydata$chol, mydata$thalach, col = dbscan_result$cluster +1 , main = "DBSCAN Clustering")

