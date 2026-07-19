#!/usr/bin/env python3
"""Linear regression CLI script (AI-assisted Assignment 3 version)."""

import sys

import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
from scipy.stats import linregress
from sklearn.metrics import mean_squared_error

if len(sys.argv) != 4:
    print("Usage: python linear_model.py <filename> <x_column> <y_column>")
    sys.exit(1)

filename = sys.argv[1]
x_col = sys.argv[2]
y_col = sys.argv[3]

data = pd.read_csv(filename)
x = np.array(data[x_col], dtype=float)
y = np.array(data[y_col], dtype=float)

# Fit linear regression: y = slope * x + intercept
slope, intercept, r_value, p_value, std_err = linregress(x, y)
y_pred = slope * x + intercept
mse = mean_squared_error(y, y_pred)

# Required Assignment 3 console output
print("Slope:", slope)
print("Intercept:", intercept)
print("Correlation coefficient (r):", r_value)
print("Mean Squared Error (MSE):", mse)

# Scatter plot + fitted line + annotation
plt.figure(figsize=(8, 6))
plt.scatter(x, y, color="red", label="Original data")
plt.plot(x, y_pred, color="blue", label="Fitted line")
plt.text(
    min(x) + (max(x) - min(x)) * 0.55,
    min(y) + (max(y) - min(y)) * 0.15,
    f"y = {slope:.2f}x + {intercept:.2f}\n"
    f"r = {r_value:.2f}",
    fontsize=12,
)
plt.xlabel(x_col)
plt.ylabel(y_col)
plt.title(f"{y_col} vs {x_col}")
plt.legend()
plt.tight_layout()
plt.savefig("regression_plot_python.png", dpi=150)
print("Saved plot: regression_plot_python.png")
