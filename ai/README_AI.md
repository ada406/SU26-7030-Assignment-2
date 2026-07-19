# AI-Assisted Linear Regression (Assignment 3)

This folder contains the **AI-assisted** version of the Assignment 3 linear regression analysis. It mirrors the requirements completed in `manual/`, with additional documentation of prompts and review.

## Purpose

Fit a simple linear regression of **Salary** on **YearsExperience**, then report:

- slope
- y-intercept
- Pearson correlation coefficient (*r*)
- mean squared error (MSE)

Scripts also save annotated scatter plots as PNG files. Notebooks explain the calculations and interpret the results in Markdown.

## Dataset

- File: `regression_data-1.csv`
- Columns: `YearsExperience` (X), `Salary` (Y)

## Contents

| File | Description |
|------|-------------|
| `linear_model.py` | Python CLI script |
| `linear_model.R` | R CLI script |
| `linear_model_python.ipynb` | Python notebook with Markdown explanations |
| `linear_model_r.ipynb` | R notebook with Markdown explanations |
| `regression_plot_python.png` | Plot saved by the Python script |
| `regression_plot_r.png` | Plot saved by the R script |
| `environment.yml` | Conda environment specification |
| `setupenv.sh` | Helper to create/activate the conda env |
| `PROMPTS.md` | Prompts used for Part B |
| `CODE_REVIEW.md` | AI review notes and response |
| `README_AI.md` | This AI-generated README |

Older Assignment 2 artifacts (for example `linear_regression_*.py`) may still exist in this folder for history; the Assignment 3 deliverables use the `linear_model*` filenames above.

## Environment setup

```bash
cd ai
bash setupenv.sh
conda activate regression-analysis
```

Or create the environment directly:

```bash
conda env create -f environment.yml
conda activate regression-analysis
```

## How to run the scripts

From the `ai/` directory:

```bash
python linear_model.py regression_data-1.csv YearsExperience Salary
Rscript linear_model.R regression_data-1.csv YearsExperience Salary
```

### Expected console output (values approximate)

```text
Slope: 8285.29...
Intercept: 29203.52...
Correlation coefficient (r): 0.886...
Mean Squared Error (MSE): 17523844...
```

### Expected files created

- `regression_plot_python.png`
- `regression_plot_r.png`

Each plot should show the original points, the fitted line, and text for the equation `y = mx + b` and correlation *r*.

## Notebooks

Open in JupyterLab/Notebook:

- `linear_model_python.ipynb`
- `linear_model_r.ipynb`

Run all cells. Markdown cells explain what is calculated and how to interpret slope, intercept, *r*, and MSE.

## Main libraries

- **Python:** pandas, NumPy, SciPy (`linregress`), scikit-learn (`mean_squared_error`), matplotlib
- **R:** base `lm` / `cor`, ggplot2

## Relationship to `manual/`

| Folder | Role |
|--------|------|
| `manual/` | Hand-built / student-driven Part A work |
| `ai/` | AI-assisted Part B repeat of the same analysis + prompt/review docs |
