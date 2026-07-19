# AI-Assisted Linear Regression — Assignment 3

This file is the **AI-generated README** for the `ai/` folder.  
It does **not** replace the root `README.md` or `manual/README`.

## Project purpose

This repository analyzes the relationship between **years of experience** and **salary** with simple linear regression. Assignment 3 adds model diagnostics and annotated plots, and uses a Git branch / pull-request workflow.

The `ai/` folder is the **AI-assisted** version of that analysis (Part B). The parallel student-built version lives in `manual/`.

## Dataset

| Item | Value |
|------|--------|
| File (Assignment 3) | `regression_data-1.csv` |
| X (predictor) | `YearsExperience` |
| Y (response) | `Salary` |

There may also be an older `regression_data.csv` from Assignment 2; use `regression_data-1.csv` for the Assignment 3 `linear_model*` files.

## Repository layout

```text
SU26-7030-Assignment-2/
├── README.md                 # hand-written root README
├── manual/                   # Part A (manual work)
│   ├── README                # hand-written manual README (do not overwrite)
│   ├── linear_model.py
│   ├── linear_model.R
│   ├── linear_model_python.ipynb
│   ├── linear_model_r.ipynb
│   ├── regression_data-1.csv
│   ├── regression_plot_python.png
│   └── regression_plot_r.png
└── ai/                       # Part B (AI-assisted)
    ├── README_AI.md          # this file
    ├── PROMPTS.md
    ├── CODE_REVIEW.md
    ├── linear_model.py
    ├── linear_model.R
    ├── linear_model_python.ipynb
    ├── linear_model_r.ipynb
    ├── regression_data-1.csv
    ├── regression_plot_python.png
    ├── regression_plot_r.png
    ├── environment.yml
    └── setupenv.sh
```

### Assignment 3 deliverables vs older files

Use these **Assignment 3** names in `ai/`:

- `linear_model.py`, `linear_model.R`
- `linear_model_python.ipynb`, `linear_model_r.ipynb`
- `regression_plot_python.png`, `regression_plot_r.png`

Older Assignment 2-style files may still appear (for example `linear_regression_*.py`, `*_cli.*`, HTML exports, `output_*` folders). They are historical reference, not the primary Assignment 3 entry points.

## What the AI scripts and notebooks do

For both Python and R:

1. Fit a linear model: `Salary ≈ intercept + slope × YearsExperience`
2. Print to the console:
   - slope
   - intercept
   - Pearson correlation coefficient (*r*)
   - mean squared error (MSE)
3. Plot original data points and the fitted line
4. Annotate the plot with the equation `y = mx + b` and *r*
5. Scripts save the figure as a PNG

Notebooks also include Markdown cells that explain the calculations and interpret slope, intercept, *r*, and MSE.

## Environment setup

From the `ai/` directory:

```bash
bash setupenv.sh
conda activate regression-analysis
```

Or:

```bash
conda env create -f environment.yml
conda activate regression-analysis
```

Main packages used:

- **Python:** pandas, NumPy, SciPy (`linregress`), scikit-learn (`mean_squared_error`), matplotlib
- **R:** `lm`, `cor`, ggplot2

On OSC, you may instead use the course environment (for example `conda activate 7030_class_1`) if it already includes these packages.

## How to run the scripts

```bash
cd ai

python linear_model.py regression_data-1.csv YearsExperience Salary
Rscript linear_model.R regression_data-1.csv YearsExperience Salary
```

### Expected console output (approximate)

```text
Slope: 8285.29...
Intercept: 29203.52...
Correlation coefficient (r): 0.886...
Mean Squared Error (MSE): 17523844...
```

### Expected plot files

- `regression_plot_python.png`
- `regression_plot_r.png`

## How to run the notebooks

Open in JupyterLab / Jupyter Notebook:

- `linear_model_python.ipynb`
- `linear_model_r.ipynb`

Run all cells. You should see printed diagnostics and an annotated scatter plot.

## Related documentation in `ai/`

| File | Purpose |
|------|---------|
| `PROMPTS.md` | Prompts used to generate/assist Part B work |
| `CODE_REVIEW.md` | AI review of the Assignment 3 PR and follow-up notes |
| `README_AI.md` | This AI-generated overview |

For the hand-written project description and manual workflow, see the root `README.md` and `manual/README`.
