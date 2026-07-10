# Simple Linear Regression Analysis

This folder (`ai/`) contains the AI-assisted version of Assignment 2. A parallel hand-built version lives in `manual/`.

This project walks through a complete simple linear regression pipeline in **both Python and R**: load data → scatter plot → fit a linear model → overlay the regression line → evaluate the model.

Anyone should be able to open these files, understand what each one does, and run the full analysis end-to-end without errors.

---

## What this analysis does

We model **Salary** as a linear function of **YearsExperience**:

```text
Salary = intercept + slope × YearsExperience + error
```

Using the included dataset (`regression_data.csv`, 10 observations), the fitted model is:

```text
Salary = 29203.52 + 8285.29 × YearsExperience
```

| Metric | Value |
|--------|------:|
| R² | 0.7852 |
| Adjusted R² | 0.7583 |
| MAE | 3526.26 |
| RMSE | 4186.15 |
| F-test p-value | 0.0006407 |

Python and R produce the **same** coefficients and evaluation metrics.

---

## Project layout

```text
regression-analysis/
├── README.md                          ← this file
├── environment.yml                    ← conda environment (Python + R + Jupyter)
├── regression_data.csv                ← input dataset
│
├── linear_regression_python.ipynb     ← Python notebook
├── linear_regression_r.ipynb          ← R notebook
├── linear_regression_python.html      ← rendered Python notebook (view in browser)
├── linear_regression_r.html           ← rendered R notebook (view in browser)
│
├── linear_regression_python.py        ← Python script (no CLI args)
├── linear_regression_r.R              ← R script (no CLI args)
├── linear_regression_python_cli.py    ← Python script with command-line arguments
├── linear_regression_r_cli.R          ← R script with command-line arguments
│
├── output_python/                     ← created when you run the Python script
├── output_r/                          ← created when you run the R script
├── output_python_cli/                 ← created when you run the Python CLI script
└── output_r_cli/                      ← created when you run the R CLI script
```

---

## What each file is and what it shows

### Data and environment

| File | What it is | What it does / shows |
|------|------------|----------------------|
| `regression_data.csv` | Input dataset | Two columns: `YearsExperience` and `Salary` (10 rows). This is the only data file the analysis needs. |
| `environment.yml` | Conda environment definition | Installs Python 3.11, pandas, numpy, matplotlib, scikit-learn, Jupyter, R, ggplot2, and IRkernel so anyone can recreate the same software stack. |

### Notebooks (interactive)

| File | What it is | What it does / shows |
|------|------------|----------------------|
| `linear_regression_python.ipynb` | Jupyter notebook (Python) | Step-by-step analysis: load data, scatter plot, fit `LinearRegression`, overlay the fitted line, print R²/MAE/RMSE, show residual diagnostics. |
| `linear_regression_r.ipynb` | Jupyter notebook (R) | Same pipeline in R using `lm()`, ggplot2 (or base graphics), ANOVA, and residual plots. |

### HTML reports (read-only review)

| File | What it is | What it does / shows |
|------|------------|----------------------|
| `linear_regression_python.html` | Static HTML export of the Python notebook | Open in any browser to review code, printed output, and plots **without** running anything. |
| `linear_regression_r.html` | Static HTML export of the R notebook | Same for the R notebook. |

### Scripts (batch / terminal)

| File | What it is | What it does / shows |
|------|------------|----------------------|
| `linear_regression_python.py` | Plain Python script | Same analysis as the Python notebook. Saves plots + `predictions.csv` to `output_python/`. |
| `linear_regression_r.R` | Plain R script | Same analysis as the R notebook. Saves plots + `predictions.csv` to `output_r/`. |
| `linear_regression_python_cli.py` | Python script with CLI arguments | Same analysis, but you can pass `--data`, `--x-col`, `--y-col`, `--output-dir`, `--no-plots`. Writes to `output_python_cli/` by default. |
| `linear_regression_r_cli.R` | R script with CLI arguments | Same CLI options for R. Writes to `output_r_cli/` by default. |

### Output folders (created when scripts run)

Each output folder contains:

| File | Contents |
|------|----------|
| `01_scatter.png` | Scatter plot of Salary vs YearsExperience |
| `02_regression_line.png` | Same scatter with the fitted regression line overlaid |
| `03_diagnostics.png` | Residuals vs fitted, and actual vs predicted |
| `predictions.csv` | Observed values, predictions, and residuals for every row |

---

## How to get the files

### Option A — Already on your computer (this project folder)

On this machine the project lives at:

```text
/Users/lizzieadams/regression-analysis/
```

In Finder: **Go → Go to Folder…** and paste that path.

### Option B — Download / copy to another computer

1. Copy the entire `regression-analysis` folder (or clone/download the repository if it is on GitHub).
2. Keep **all files in the same folder**, especially `regression_data.csv` next to the notebooks and scripts.
3. Do **not** rename `regression_data.csv` unless you also pass a new path to the CLI scripts.

### Option C — Upload to OSC OnDemand

1. Go to [https://ondemand.osc.edu](https://ondemand.osc.edu) and log in.
2. Top menu → **Files** → **Home Directory**.
3. Create a folder (e.g. `regression-analysis`).
4. Click **Upload** and upload at least:
   - `environment.yml`
   - `regression_data.csv`
   - the notebooks and/or scripts you want to run
5. Confirm with `ls` in a shell that the files are present.

---

## One-time software setup

### Local computer (recommended: conda / mamba)

From the project folder:

```bash
cd /path/to/regression-analysis
conda env create -f environment.yml
conda activate regression-analysis
```

If the environment already exists, skip `create` and only run:

```bash
conda activate regression-analysis
```

### OSC OnDemand (Ascend)

Ascend requires a **versioned** miniconda module:

```bash
cd ~/regression-analysis
module spider miniconda3
module load miniconda3/24.1.2-py310   # use the version shown by spider if different
conda env create -f environment.yml  # only once
conda activate regression-analysis
```

If you see `CondaValueError: prefix already exists`, the environment is already built. Just activate it:

```bash
conda activate regression-analysis
```

Official OSC docs:

- [Jupyter on OnDemand](https://www.osc.edu/resources/getting_started/howto/howto_use_jupyter_on_ondemand)
- [Conda env with Jupyter](https://www.osc.edu/resources/getting_started/howto/howto_use_a_condavirtual_environment_with_jupyter)

---

## How to run each file

Always work from the project directory so the CSV is found:

```bash
cd /path/to/regression-analysis   # or: cd ~/regression-analysis on OSC
conda activate regression-analysis
```

---

### 1. Review HTML reports (no code execution)

Double-click either file, or open in a browser:

```bash
open linear_regression_python.html   # macOS
open linear_regression_r.html
```

On OSC: download the `.html` files via **Files** and open them locally.

**What you should see:** full notebook text, tables, model summary, and embedded plots.

---

### 2. Run the Jupyter notebooks

#### Locally

```bash
conda activate regression-analysis
jupyter notebook
# or: jupyter lab
```

1. Open `linear_regression_python.ipynb` → choose the **Python** kernel → **Kernel → Restart & Run All**.
2. Open `linear_regression_r.ipynb` → choose the **R** kernel → **Kernel → Restart & Run All**.

#### On OSC OnDemand

**Register kernels once** (after the conda env exists):

```bash
module load miniconda3/24.1.2-py310
conda activate regression-analysis

# Python kernel
~support/classroom/tools/create_jupyter_kernel conda regression-analysis "Python (regression-analysis)"

# R kernel
Rscript -e "IRkernel::installspec(name='regression-analysis-r', displayname='R (regression-analysis)')"
```

Then:

1. OnDemand → **Interactive Apps** → **Jupyter** / **JupyterLab**
2. Request a short job (e.g. 1 hour, 1–2 cores) → **Launch** → **Connect to Jupyter**
3. Navigate to `regression-analysis`
4. Open each notebook and select the matching kernel
5. **Restart & Run All**

**What you should see in each notebook:**

1. Data table (10 rows)
2. Scatter plot
3. Fitted equation and coefficients
4. Scatter + regression line
5. Evaluation metrics (R², MAE, RMSE, …)
6. Predictions table
7. Diagnostic plots

---

### 3. Run the plain scripts (no arguments)

```bash
python linear_regression_python.py
Rscript linear_regression_r.R
```

**What they do:** print the same metrics as the notebooks and write plots/CSV into:

- `output_python/`
- `output_r/`

---

### 4. Run the CLI scripts (with arguments)

#### Defaults (same analysis as the plain scripts)

```bash
python linear_regression_python_cli.py
Rscript linear_regression_r_cli.R
```

#### Explicit arguments

```bash
python linear_regression_python_cli.py \
  --data regression_data.csv \
  --x-col YearsExperience \
  --y-col Salary \
  --output-dir output_python_cli

Rscript linear_regression_r_cli.R \
  --data regression_data.csv \
  --x-col YearsExperience \
  --y-col Salary \
  --output-dir output_r_cli
```

#### Help

```bash
python linear_regression_python_cli.py --help
Rscript linear_regression_r_cli.R --help
```

#### CLI options

| Option | Meaning | Default |
|--------|---------|---------|
| `--data` | Path to CSV | `regression_data.csv` next to the script |
| `--x-col` | Predictor column name | `YearsExperience` |
| `--y-col` | Response column name | `Salary` |
| `--output-dir` | Where to write plots/CSV | `output_python_cli` or `output_r_cli` |
| `--no-plots` | Skip PNG files | off |
| `-h` / `--help` | Show usage | — |

**What they do:** same analysis as the plain scripts, but inputs/outputs are configurable. Results go to `output_python_cli/` and `output_r_cli/` by default.

---

## Expected output (all methods should match)

### Console summary

```text
Fitted model: Salary = 29203.52 + 8285.29 * YearsExperience
Intercept: 29203.5227
Slope:     8285.2921

Model evaluation
----------------------------------------
R-squared:           0.7852
Adjusted R-squared:  0.7583
MAE:                 3526.26
MSE:                 17523844.08
RMSE:                4186.15
Residual mean:       0.0000
Residual std. dev.:  4412.59
```

R also prints `summary(lm(...))` and an ANOVA table (F ≈ 29.24, p ≈ 0.0006407).

### Predictions (excerpt)

| YearsExperience | Salary | Predicted | Residual |
|----------------:|-------:|----------:|---------:|
| 1.1 | 39343 | ~38317 | ~1026 |
| 2.2 | 39891 | ~47431 | ~−7540 |
| 4.0 | 63218 | ~62345 | ~873 |

### Output files after running scripts

```bash
ls output_python
# 01_scatter.png  02_regression_line.png  03_diagnostics.png  predictions.csv
```

---

## Suggested order for a first-time user

1. Open `linear_regression_python.html` and `linear_regression_r.html` in a browser to see the finished analysis.
2. Create the conda environment from `environment.yml`.
3. Run both notebooks (**Restart & Run All**).
4. Run the plain `.py` / `.R` scripts and inspect the `output_*` folders.
5. Run the `*_cli` scripts with `--help`, then with explicit `--data` / `--output-dir` arguments.

---

## Troubleshooting

| Problem | Fix |
|---------|-----|
| `Could not find regression_data.csv` | `cd` into the project folder; keep the CSV next to the scripts/notebooks. |
| `conda: command not found` (OSC) | `module load miniconda3/24.1.2-py310` first. |
| `module load miniconda3` fails on Ascend | Ascend requires a version: `module load miniconda3/24.1.2-py310`. |
| `CondaValueError: prefix already exists` | Environment already created — run `conda activate regression-analysis` only. |
| R notebook has no R kernel | Register IRkernel (see notebook section above) and start a **new** Jupyter session. |
| `ggplot2 not found` | Activate `regression-analysis`. Scripts fall back to base R graphics if needed. |
| Plots don’t appear in terminal scripts | They are saved as PNGs under `output_*` (scripts use a non-interactive backend). |
| Python/R metrics disagree | They should match; confirm both used the same `regression_data.csv`. |

---

## Pipeline summary

```text
regression_data.csv
        │
        ▼
  Load & inspect data
        │
        ▼
  Scatter plot (X = YearsExperience, Y = Salary)
        │
        ▼
  Fit simple linear regression
        │
        ▼
  Overlay fitted line on scatter plot
        │
        ▼
  Evaluate: R², Adj. R², MAE, MSE, RMSE, residuals
        │
        ▼
  Notebooks / HTML  OR  scripts → output_*/ plots + predictions.csv
```

Same scientific result is available four ways: **notebook**, **HTML report**, **plain script**, and **CLI script**, in both **Python** and **R**.
