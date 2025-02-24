# Heart Disease Patient Clustering
## Overview
This project focuses on clustering heart disease patients using different machine learning techniques. The goal is to analyze relationships between key health indicators like cholesterol levels, heart rate, and blood pressure.

## Data Preprocessing
To ensure data quality, several preprocessing steps were performed:
- Removed ID Column – Since it does not contribute to clustering.
- Handled Missing Values – Numerical columns were imputed using the mean, and categorical columns were imputed using the mode. (No missing values were found in numerical data.)
- Checked for Negative Age Values – None were found.
- Removed Duplicates – No significant duplicates were found, but a check was included for reassurance.
- Handled Outliers – Used the interquartile range (IQR) method to replace extreme values in key columns (chol, trestbps, thalach).

## Clustering Algorithms
Multiple clustering techniques were applied to identify meaningful groups:
### K-Means Clustering
- Used the Elbow Method to determine the optimal number of clusters.
- Applied K-Means to both raw and preprocessed data.
- Visualized clusters using thalach vs chol.
### DBSCAN (Density-Based Clustering)
- Applied DBSCAN to detect clusters based on density.
- Tuned eps and minPts parameters for optimal results.
### Hierarchical Clustering
- Used Ward's method to create a hierarchical clustering dendrogram.
- Cut the dendrogram at an optimal level to form distinct clusters.
### K-Medoids Clustering
- Applied the Partitioning Around Medoids (PAM) algorithm.
- Compared results with K-Means to evaluate performance.
## Model Comparison
To compare different clustering techniques, we visualized:
- K-Means vs. K-Medoids vs. Hierarchical vs. DBSCAN using thalach vs chol plots.

## Results
- Different clustering methods yielded varying groupings.
- Outlier handling improved the stability of K-Means and K-Medoids results.
- DBSCAN detected non-spherical clusters effectively.
- Hierarchical clustering provided an intuitive representation of relationships between data points.

## Technologies Used
Programming Language: R
Libraries: cluster, dbscan, factoextra, ggplot2
