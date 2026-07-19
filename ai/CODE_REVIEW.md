# AI Code Review — Assignment 3 (`assignment3` branch)

Reviewer role: AI assistant reviewing the Assignment 3 regression enhancements relative to the course requirements (slope/intercept/r/MSE, annotated plots, notebook markdown).

## 1. Summary of changes

Assignment 3 upgrades the salary-vs-experience analysis so both Python and R:

- fit a linear model
- print slope, intercept, Pearson’s *r*, and MSE
- show a scatter plot with a fitted line and text annotations (equation and *r*)
- save PNG plots from the CLI scripts

Part A lives in `manual/`. Part B repeats the same analysis in `ai/` with AI assistance and documentation (`PROMPTS.md`, this review, `README_AI.md`).

## 2. Strengths

- Clear CLI usage pattern: `filename`, `x_column`, `y_column`
- Same dataset and scientific story across Python and R
- Notebooks include Markdown that defines and interprets slope, intercept, *r*, and MSE
- Plot annotations place the equation away from the densest data region

## 3. Bugs or risks

1. **Critical (manual Python script):** `manual/linear_model.py` builds the model and plot but **does not print** slope, intercept, *r*, or MSE to the console, even though Assignment 3 requires console output. The R script does print those stats.
2. **Plot contrast:** In the manual Python script, both points and the fitted line use red (`"r-"`), which makes the line harder to distinguish than the R plot (blue line).
3. **Interactive `plt.show()` in CLI:** Calling `plt.show()` in a batch/headless environment can hang or fail; saving the PNG is the essential script requirement.

## 4. Style / clarity suggestions

- Prefer an explicit blue fitted line and a legend labeling “Original data” vs “Fitted line”
- Keep annotation text focused on equation + *r* (as required); MSE can remain in console output
- Document exact run commands in `ai/README_AI.md`

## 5. Actionable comments

1. **Add `print(...)` statements for slope, intercept, *r*, and MSE in the Python CLI script** so it matches the R script and the assignment checklist.
2. **Change the fitted line color to blue** (or another high-contrast color) so it is visually distinct from the red scatter points.
3. **Avoid relying on `plt.show()` for the script path**; `savefig` is enough for the required PNG artifact.

## Changes made in response to review

Addressed comment **#1** (and related #2/#3) in the AI-assisted Python script `ai/linear_model.py`:

- prints Slope, Intercept, Correlation coefficient (*r*), and MSE
- uses a blue fitted line with a clear legend
- saves `regression_plot_python.png` without requiring an interactive display

Also updated `ai/linear_model.R` to avoid deprecated `aes_string()` (use `aes()` with `.data[[...]]`), which removed a ggplot2 warning when generating `regression_plot_r.png`.

The same console-output and annotation requirements are implemented in `ai/linear_model.R` and mirrored in the AI notebooks.
