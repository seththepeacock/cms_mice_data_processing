import scipy.io as sio
import numpy as np
import matplotlib.pyplot as plt
import pandas as pd
from sklearn.svm import SVC
from sklearn.preprocessing import StandardScaler
import time
from helper_funcs import *
import itertools

start = time.time()



# Decide on Columns
column_names = ["Smallest Min", "Largest Max", "Max Value Persistence", "Max Clearance Value Persistence", "Max Release Value Persistence", "Max Time Persistence", "Max Clearance Time Persistence", "Max Release Time Persistence", "Average Value Persistence", "Average Clearance Value Persistence", "Average Release Value Persistence", "Average Time Persistence", "Average Clearance Time Persistence", "Average Release Time Persistence", "Difference Between Average CVP and Average RVP", "Difference Between Max CVP and Max RVP", "Difference Between Average CTP and Average RTP", "Difference Between Max CTP and Max RTP", "Max Slope", "Max Clearance Slope", "Max Release Slope", "Average Slope", "Average Clearance Slope", "Average Release Slope", "Difference Between Average CS and Average RS", "Difference Between Max CS and Max RS", "Variance of Slopes", "Variance of Clearance Slopes", "Variance of Release Slopes", "Min Slope", "Min Clearance Slope", "Min Release Slope", "Average of x-to-60 Slopes (x = 1, 2, ..., 30)", "|Average of x-to-60 Slopes (x = 1, 2, ..., 30)|", "Signed Average Slope (Release is +, Clearance is -)"]
# Columns to drop (uninteresting separation)
columns_to_drop = ["Mouse Type", "Smallest Min", "Largest Max", "Average of x-to-60 Slopes (x = 1, 2, ..., 30)", "|Average of x-to-60 Slopes (x = 1, 2, ..., 30)|"]
# Additional columns to drop
columns_to_drop.extend([])
# Columns to keep (note this overwrites the drops)
# columns_to_keep = ["Max Slope", "Max Clearance Slope", "Max Release Slope", "Average Slope", "Average Clearance Slope", "Average Release Slope", "Difference Between Average CS and Average RS", "Difference Between Max CS and Max RS", "Variance of Slopes", "Variance of Clearance Slopes", "Variance of Release Slopes", "Min Slope", "Min Clearance Slope", "Min Release Slope", "Signed Average Slope (Release is +, Clearance is -)"]
columns_to_keep = []

# Additional parameters
C = 1e10 # High C => prioritize minimizing (softly enforced) margin, low C => prioritize making ALL points over the plane
drop_m6 = True # Optionally drop the outlier depressed mouse
normalize = True # Normalize SVM so that each feature has mean 0 and unit variance?
plot = False # Make 3D plot?
print_top_features = True # Print top features?
top_3_only = False # Only use top 3 features in column list (or all combos of top 10)?
max_wrong = 0 # Max number of points on wrong side of the plane
plot_non_normalized = False # Plot the pre-normalized (interpretable) data
n_top_features = 10 # Number of top feature-importance-sorted features to use (31 max)



# Load .mat file
data = sio.loadmat('artificial_processes.mat')
coordinates = data['artificial_coordinates3D_75']
# Convert to df
coordinates_df = pd.DataFrame(coordinates, columns=column_names)
# One hot encode the cms / control mice
cms_labels = np.ones(8, dtype=int)
control_labels = np.zeros(10, dtype=int)
mouse_type = np.concatenate([cms_labels, control_labels])
# Make a df from that column
mouse_type_df = pd.DataFrame(mouse_type, columns=["Mouse Type"])
# Concatenate with og dataframe
df = pd.concat([mouse_type_df, coordinates_df], axis=1)
# Optionally drop the outlier depressed mouse
if drop_m6:
    df = df.drop(6-1)

# Get type labels
y_labels = df['Mouse Type']

# Drop columns for final candidate coordinates
X_df = df.drop(columns_to_drop, axis=1)
# Alternatively, keep columns (note this overwrites the drop)
if len(columns_to_keep) > 0:
    X_df = df[columns_to_keep]

# Standardize features
scaler = StandardScaler()
X_scaled = scaler.fit_transform(X_df)
X_unscaled = X_df.to_numpy()

if normalize:
    X_use = X_scaled
else:
    X_use = X_unscaled

# Train linear SVM
svm = SVC(kernel='linear', C=C)
svm.fit(X_use, y_labels)

# Get feature importance (absolute value of coefficients)
feature_importance = abs(svm.coef_[0])

# Identify top features
if top_3_only:
    top_features_indices = feature_importance.argsort()[-3:][::-1] # Grab last three (highest) elements, then reverses order
else:
    top_features_indices = feature_importance.argsort()[-n_top_features:][::-1] # Grab last n_top_features (highest) elements, then reverses order

if print_top_features:
    print(f"Top {n_top_features} features:", X_df.columns[feature_importance.argsort()[-n_top_features:][::-1]].tolist())
    
    
# Generate all unique combinations of 3 indices
combinations = itertools.combinations(top_features_indices, 3)

best_num_wrong = 100
best_combo = None

# Loop through each combination
for idx_combo in combinations:
    idx_combo = list(idx_combo)
    # Extract data for the 3 features
    X_3 = X_use[:, idx_combo]
    feature_labels = X_df.columns[idx_combo]

        
    # SVM Plane
    # Get the coefficients and intercept for the 3 features
    w = svm.coef_[0][idx_combo]  # Coefficients for the 3 features
    b = svm.intercept_[0]  # Intercept
        

    # Check points against the hyperplane
    wrong_points = check_points_on_hyperplane(X_3, y_labels, w, b)
    num_wrong = len(wrong_points)
    if num_wrong <= max_wrong:
        if num_wrong == 1:
            print(f"{num_wrong} wrong point: ")
        else:
            print(f"{num_wrong} wrong points: ")
        print(f"{X_df.columns[idx_combo[0]]}, {X_df.columns[idx_combo[1]]}, {X_df.columns[idx_combo[2]]}")
        print("")
        if num_wrong < best_num_wrong:
            best_num_wrong = num_wrong
            best_combo = idx_combo
        
        
        if plot:
            # Plot 3D point cloud
            fig = plt.figure(figsize=(10, 7))
            ax = fig.add_subplot(projection='3d')
            
            if plot_non_normalized:
                X_3 = X_unscaled[:, idx_combo]

            # Scatter plot
            for label, color in zip([0, 1], ['red', 'green']):
                mask = y_labels == label
                if label == 1:
                    cat_label = "CMS"
                else:
                    cat_label = "Control"
                
                ax.scatter(
                    X_3[mask, 0], X_3[mask, 1], X_3[mask, 2],
                    label=cat_label, alpha=1, s=50, c=color
                )
                
            if normalize and not plot_non_normalized:
                # Plot the separation plane
                # Create a meshgrid for the first two features (x, y)
                x = np.linspace(X_3[:, 0].min(), X_3[:, 0].max(), 30)
                y = np.linspace(X_3[:, 1].min(), X_3[:, 1].max(), 30)
                x, y = np.meshgrid(x, y)

                # Compute z values for the plane
                z = (-w[0] * x - w[1] * y - b) / w[2]

                # Plot plane
                ax.plot_surface(x, y, z, alpha=1, color='blue')

            # Set axis labels
            ax.set_xlabel(feature_labels[0])
            ax.set_ylabel(feature_labels[1])
            ax.set_zlabel(feature_labels[2])
            ax.set_title("Point Cloud of Extracted Coordinates")
            ax.legend()
            plt.show()

# print(f"Best combination: {X_df.columns[best_combo]}")
# print(f"Minimum points on the wrong side: {best_num_wrong}")

end = time.time()
print("Time taken:", end - start)

