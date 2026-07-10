#!/usr/bin/env python3
"""Simple linear regression with command-line arguments (Python).

Same analysis as linear_regression_python.py, but inputs/outputs are configurable.

Examples:
    python linear_regression_python_cli.py
    python linear_regression_python_cli.py --data regression_data.csv
    python linear_regression_python_cli.py \\
        --data regression_data.csv \\
        --x-col YearsExperience \\
        --y-col Salary \\
        --output-dir output_python_cli
"""

from __future__ import annotations

import argparse
from pathlib import Path

import matplotlib

matplotlib.use("Agg")
import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
from sklearn.linear_model import LinearRegression
from sklearn.metrics import mean_absolute_error, mean_squared_error, r2_score

SCRIPT_DIR = Path(__file__).resolve().parent


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="Fit and evaluate a simple linear regression model.",
        formatter_class=argparse.ArgumentDefaultsHelpFormatter,
    )
    parser.add_argument(
        "--data",
        type=Path,
        default=SCRIPT_DIR / "regression_data.csv",
        help="Path to the CSV data file",
    )
    parser.add_argument(
        "--x-col",
        default="YearsExperience",
        help="Name of the predictor (independent) column",
    )
    parser.add_argument(
        "--y-col",
        default="Salary",
        help="Name of the response (dependent) column",
    )
    parser.add_argument(
        "--output-dir",
        type=Path,
        default=SCRIPT_DIR / "output_python_cli",
        help="Directory for plots and predictions CSV",
    )
    parser.add_argument(
        "--no-plots",
        action="store_true",
        help="Skip writing plot PNG files",
    )
    return parser.parse_args()


def main() -> None:
    args = parse_args()

    data_path = args.data
    if not data_path.exists():
        raise FileNotFoundError(f"Data file not found: {data_path}")

    output_dir = args.output_dir
    output_dir.mkdir(parents=True, exist_ok=True)

    print(f"pandas: {pd.__version__}")
    print(f"numpy: {np.__version__}")
    print(f"Using data file: {data_path.resolve()}")
    print(f"X column: {args.x_col}")
    print(f"Y column: {args.y_col}")
    print(f"Output dir: {output_dir.resolve()}")

    df = pd.read_csv(data_path)
    if args.x_col not in df.columns or args.y_col not in df.columns:
        raise ValueError(
            f"Columns must include '{args.x_col}' and '{args.y_col}'. "
            f"Found: {list(df.columns)}"
        )

    print(f"Shape: {df.shape[0]} rows x {df.shape[1]} columns")
    print(df[[args.x_col, args.y_col]])
    print()
    print(df[[args.x_col, args.y_col]].describe())

    X = df[[args.x_col]].to_numpy()
    y = df[args.y_col].to_numpy()

    if not args.no_plots:
        fig, ax = plt.subplots(figsize=(7, 5))
        ax.scatter(df[args.x_col], df[args.y_col], color="steelblue", s=60)
        ax.set_title(f"{args.y_col} vs {args.x_col}")
        ax.set_xlabel(args.x_col)
        ax.set_ylabel(args.y_col)
        ax.grid(True, alpha=0.3)
        plt.tight_layout()
        scatter_path = output_dir / "01_scatter.png"
        fig.savefig(scatter_path, dpi=120)
        plt.close(fig)
        print(f"\nSaved: {scatter_path}")

    model = LinearRegression()
    model.fit(X, y)
    intercept = float(model.intercept_)
    slope = float(model.coef_[0])

    print(f"\nFitted model: {args.y_col} = {intercept:.2f} + {slope:.2f} * {args.x_col}")
    print(f"Intercept: {intercept:.4f}")
    print(f"Slope:     {slope:.4f}")

    y_pred = model.predict(X)
    residuals = y - y_pred

    if not args.no_plots:
        x_line = np.linspace(X.min(), X.max(), 100).reshape(-1, 1)
        y_line = model.predict(x_line)

        fig, ax = plt.subplots(figsize=(7, 5))
        ax.scatter(df[args.x_col], df[args.y_col], color="steelblue", s=60, label="Observed")
        ax.plot(x_line, y_line, color="#DC143C", linewidth=2, label="Fitted line")
        ax.set_title(f"Linear Regression: {args.y_col} ~ {args.x_col}")
        ax.set_xlabel(args.x_col)
        ax.set_ylabel(args.y_col)
        ax.legend()
        ax.grid(True, alpha=0.3)
        plt.tight_layout()
        fit_path = output_dir / "02_regression_line.png"
        fig.savefig(fit_path, dpi=120)
        plt.close(fig)
        print(f"Saved: {fit_path}")

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
            args.x_col: df[args.x_col],
            args.y_col: y,
            "Predicted": y_pred,
            "Residual": residuals,
        }
    )
    print()
    print(results)

    results_path = output_dir / "predictions.csv"
    results.to_csv(results_path, index=False)
    print(f"\nSaved: {results_path}")

    if not args.no_plots:
        fig, axes = plt.subplots(1, 2, figsize=(12, 5))
        axes[0].scatter(y_pred, residuals, color="steelblue", s=60)
        axes[0].axhline(0, color="#DC143C", linestyle="--")
        axes[0].set_title("Residuals vs Fitted")
        axes[0].set_xlabel(f"Predicted {args.y_col}")
        axes[0].set_ylabel("Residual")
        axes[0].grid(True, alpha=0.3)

        axes[1].scatter(y, y_pred, color="steelblue", s=60)
        lims = [min(y.min(), y_pred.min()), max(y.max(), y_pred.max())]
        axes[1].plot(lims, lims, color="#DC143C", linestyle="--")
        axes[1].set_title("Actual vs Predicted")
        axes[1].set_xlabel(f"Actual {args.y_col}")
        axes[1].set_ylabel(f"Predicted {args.y_col}")
        axes[1].grid(True, alpha=0.3)
        plt.tight_layout()
        diag_path = output_dir / "03_diagnostics.png"
        fig.savefig(diag_path, dpi=120)
        plt.close(fig)
        print(f"Saved: {diag_path}")

    print("\nDone.")


if __name__ == "__main__":
    main()
