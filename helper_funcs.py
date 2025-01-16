import numpy as np

# Function to check if all points are on the correct side of the hyperplane
def check_points_on_hyperplane(X, y_labels, w, b):
    """
    Checks if all points are on the correct side of the hyperplane.

    Parameters:
    - X: numpy array, shape (n_samples, 3), points in the top 3 feature space.
    - y: numpy array, shape (n_samples,), labels (0 or 1).
    - w: numpy array, shape (3,), coefficients of the hyperplane.
    - b: float, intercept of the hyperplane.

    Returns:
    - all_correct: bool, True if all points are on the correct side.
    - incorrect_points: list, indices of points on the wrong side.
    """
    decision_values = np.dot(X, w) + b
    # Check if decision value is positive for class 1 and negative for class 0
    correct_side = (decision_values > 0) == (y_labels == 1)
    incorrect_points = np.where(~correct_side)[0].tolist()
    return incorrect_points
