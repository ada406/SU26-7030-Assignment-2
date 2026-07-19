import sys
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
from scipy.stats import linregress
from sklearn.metrics import mean_squared_error

if len(sys.argv) != 4:
    print("Usage: python linear_model.py <filename> <x_column> <y_column>")
    sys.exit(1)

filename = sys.argv[1]
x_col = sys.argv[2]
y_col = sys.argv[3]

data = pd.read_csv(filename)
x = np.array(data[x_col])
y = np.array(data[y_col])

#Linear regresssion
slope, intercept, r_value, p_value, std_err = linregress(x, y)
y_pred = slope * x + intercept
mse = mean_squared_error(y, y_pred)

# Plot
plt.scatter(x, y, color="red")
plt.plot(x, y_pred, "r-", label="Fitted Line")
plt.text(
    max(x) * 0.55,
    min(y) + (max(y) - min(y)) * 0.15,
    f"y = {slope:.2f}x + {intercept:.2f}\n"
    f"r = {r_value:.2f}\nMSE = {mse:.2f}",
    fontsize=12,
)
plt.xlabel(x_col)
plt.ylabel(y_col)
plt.title(f"{y_col} vs {x_col}")
plt.legend()
plt.savefig("regression_plot_python.png")
plt.show()
