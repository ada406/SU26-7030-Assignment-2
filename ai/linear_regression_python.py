#!/usr/bin/env python3
"""Simple linear regression: Salary ~ YearsExperience (Python).

Reads regression_data.csv from the script directory (or cwd), plots the data,
fits a linear model, overlays the regression line, and evaluates the model.

Usage:
    python linear_regression_python.py
"""

from pathlib import Path

import matplotlib

matplotlib.use("Agg")  # non-interactive; works on OSC / headless sessions
import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
from sklearn.linear_model import LinearRegression
from sklearn.metrics import mean_absolute_error, mean_squared_error, r2_score

SCRIPT_DIR = Path(__file__).resolve().parent
OUTPUT_DIR = SCRIPT_DIR / "output_python"
OUTPUT_DIR.mkdir(exist_ok=True)


def resolve_data_path() -> Path:
    candidates = [
        SCRIPT_DIR / "regression_data.csv",
        Path.cwd() / "regression_data.csv",
        Path("regression_data.csv"),
    ]
    for path in candidates:
        if path.exists():
            return path
    raise FileNotFoundError(
        "Could not find regression_data.csv. "
        "Place it in the same folder as this script."
    )


def main() -> None:
    print(f"pandas: {pd.__version__}")
    print(f"numpy: {np.__version__}")

    data_path = resolve_data_path()
    print(f"Using data file: {data_path.resolve()}")

    # 1. Load and inspect
    df = pd.read_csv(data_path)
    print(f"Shape: {df.shape[0]} rows x {df.shape[1]} columns")
    print(f"Columns: {list(df.columns)}\n")
    print(df)
    print()
    print(df.describe())
    print()
    df.info()

    # 2. Scatter plot
    fig, ax = plt.subplots(figsize=(7, 5))
    ax.scatter(df["YearsExperience"], df["Salary"], color="steelblue", s=60)
    ax.set_title("Salary vs Years of Experience")
    ax.set_xlabel("Years of Experience")
    ax.set_ylabel("Salary")
    ax.grid(True, alpha=0.3)
    plt.tight_layout()
    scatter_path = OUTPUT_DIR / "01_scatter.png"
    fig.savefig(scatter_path, dpi=120)
    plt.close(fig)
    print(f"\nSaved: {scatter_path}")

    # 3. Fit model
    X = df[["YearsExperience"]].to_numpy()
    y = df["Salary"].to_numpy()

    model = LinearRegression()
    model.fit(X, y)

    intercept = float(model.intercept_)
    slope = float(model.coef_[0])

    print(f"\nFitted model: Salary = {intercept:.2f} + {slope:.2f} * YearsExperience")
    print(f"Intercept: {intercept:.4f}")
    print(f"Slope:     {slope:.4f}")

    # 4. Overlay regression line
    x_line = np.linspace(X.min(), X.max(), 100).reshape(-1, 1)
    y_line = model.predict(x_line)

    fig, ax = plt.subplots(figsize=(7, 5))
    ax.scatter(
        df["YearsExperience"], df["Salary"], color="steelblue", s=60, label="Observed"
    )
    ax.plot(x_line, y_line, color="#DC143C", linewidth=2, label="Fitted line")
    ax.set_title("Linear Regression: Salary ~ YearsExperience")
    ax.set_xlabel("Years of Experience")
    ax.set_ylabel("Salary")
    ax.legend()
    ax.grid(True, alpha=0.3)
    plt.tight_layout()
    fit_path = OUTPUT_DIR / "02_regression_line.png"
    fig.savefig(fit_path, dpi=120)
    plt.close(fig)
    print(f"Saved: {fit_path}")

    # 5. Evaluate
    y_pred = model.predict(X)
    residuals = y - y_pred

    n = len(y)
    p = 1
    r2 = r2_score(y, y_pred)
    adj_r2 = 1 - (1 - r2) * (n - 1) / (n - p - 1)
    mae = mean_absolute_error(y, y_pred)
    mse = mean_squared_error(y, y_pred)
    rmse = float(np.sqrt(mse))

    print("\nModel evaluation")
    print("-" * 40)
    print(f"R-squared:           {r2:.4f}")
    print(f"Adjusted R-squared:  {adj_r2:.4f}")
    print(f"MAE:                 {mae:.2f}")
    print(f"MSE:                 {mse:.2f}")
    print(f"RMSE:                {rmse:.2f}")
    print(f"Residual mean:       {residuals.mean():.4f}")
    print(f"Residual std. dev.:  {residuals.std(ddof=1):.2f}")

    results = pd.DataFrame(
        {
            "YearsExperience": df["YearsExperience"],
            "Salary": y,
            "Predicted": y_pred,
            "Residual": residuals,
        }
    )
    print()
    print(results)

    results_path = OUTPUT_DIR / "predictions.csv"
    results.to_csv(results_path, index=False)
    print(f"\nSaved: {results_path}")

    fig, axes = plt.subplots(1, 2, figsize=(12, 5))
    axes[0].scatter(y_pred, residuals, color="steelblue", s=60)
    axes[0].axhline(0, color="#DC143C", linestyle="--")
    axes[0].set_title("Residuals vs Fitted")
    axes[0].set_xlabel("Predicted Salary")
    axes[0].set_ylabel("Residual")
    axes[0].grid(True, alpha=0.3)

    axes[1].scatter(y, y_pred, color="steelblue", s=60)
    lims = [min(y.min(), y_pred.min()), max(y.max(), y_pred.max())]
    axes[1].plot(lims, lims, color="#DC143C", linestyle="--")
    axes[1].set_title("Actual vs Predicted")
    axes[1].set_xlabel("Actual Salary")
    axes[1].set_ylabel("Predicted Salary")
    axes[1].grid(True, alpha=0.3)
    plt.tight_layout()
    diag_path = OUTPUT_DIR / "03_diagnostics.png"
    fig.savefig(diag_path, dpi=120)
    plt.close(fig)
    print(f"Saved: {diag_path}")

    print("\nDone.")


if __name__ == "__main__":
    main()
