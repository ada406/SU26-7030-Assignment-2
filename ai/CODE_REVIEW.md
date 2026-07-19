# AI Code Review — Assignment 3 Pull Request

**Reviewed:** [PR #2](https://github.com/ada406/SU26-7030-Assignment-2/pull/2) (`assignment3` → `main`), plus the Part A `manual/` deliverables merged earlier in [PR #1](https://github.com/ada406/SU26-7030-Assignment-2/pull/1).  
**Scope:** linear regression scripts/notebooks, plots, and Part B documentation under `ai/` and `manual/`.  
**Status:** PR #2 is already merged; this review is saved for the assignment’s “AI code review” requirement and to guide follow-up fixes.

---

## 1. Summary of what the PR changes

Assignment 3 upgrades the Salary ~ YearsExperience analysis so Python and R:

- fit a linear model
- report slope, intercept, Pearson’s *r*, and MSE
- plot original points + fitted line with equation / *r* annotations
- save PNGs from CLI scripts (`regression_plot_python.png`, `regression_plot_r.png`)

**Part A (`manual/`):** student-built notebooks/scripts (PR #1).  
**Part B (`ai/`):** AI-assisted repeat of the same analysis, plus `PROMPTS.md`, `README_AI.md`, `setupenv.sh`, updated `environment.yml`, and this review file (PR #2).

---

## 2. Strengths

- CLI interface is consistent and clear: `<filename> <x_column> <y_column>`.
- `ai/linear_model.py` and `ai/linear_model.R` meet the Assignment 3 checklist (console stats + annotated plot + PNG output).
- AI notebooks include Markdown that defines *and* interprets slope, intercept, *r*, and MSE.
- `ai/README_AI.md` and `setupenv.sh` make the AI pipeline easier to reproduce.
- R AI script avoids deprecated `aes_string()` by using `aes()` with `.data[[...]]`.

---

## 3. Bugs or risks

### Critical

1. **`manual/linear_model.py` never prints model diagnostics.**  
   The script computes `slope`, `intercept`, `r_value`, and `mse`, but only plots/saves. Assignment 3 requires printing those values to standard output. `manual/linear_model.R` already prints them, so Part A Python/R behavior is inconsistent.

### Medium

2. **Low contrast on the manual Python plot.**  
   Points are red and the fitted line uses `"r-"` (also red), so the line is hard to see. The R plot and `ai/` Python plot correctly use a blue line.

3. **`plt.show()` in the manual Python CLI path.**  
   After `savefig`, `plt.show()` can hang or fail in headless OSC / batch sessions. The PNG is the required artifact; interactive display is optional for scripts.

4. **No validation of CLI column names / file existence.**  
   A typo such as `YearExperience` raises a raw `KeyError` / unclear R error. A short check with a friendly usage message would make grading/demo failures easier to diagnose.

### Low

5. **`ai/` still contains older Assignment 2 artifacts** (`linear_regression_*.py`, `*_cli.*`, HTML exports, `output_*` folders). Not wrong, but graders may be unsure which files are the Assignment 3 deliverables. Clarifying in README (already partly done) or trimming unused files would help.

6. **Manual R still uses `aes_string()`**, which ggplot2 marks deprecated. Works today; may warn or break later.

---

## 4. Style / clarity suggestions

- Prefer matching Python/R plot styling across `manual/` and `ai/` (blue fitted line, legend labels “Original data” / “Fitted line”).
- Keep plot annotation focused on equation + *r* (assignment requirement); printing MSE in the console is enough.
- In notebooks, consider computing interpretation numbers from variables (e.g., `round(slope, 2)`) so prose cannot drift from the fitted model if the CSV changes.
- Sort `x` before drawing the fitted line in matplotlib if the CSV is ever unsorted (current file happens to be ordered).

---

## 5. Actionable review comments (please address ≥1)

| # | File | Comment |
|---|------|---------|
| **1** | `manual/linear_model.py` | **Add `print` statements** for Slope, Intercept, Correlation coefficient (*r*), and Mean Squared Error (MSE) before plotting—same labels/order as the R script. |
| **2** | `manual/linear_model.py` | Change the fitted line to **blue** (e.g. `color="blue"`) so it contrasts with the red scatter points; optionally label scatter vs line in the legend. |
| **3** | `manual/linear_model.py` | Remove or guard `plt.show()` in the script (keep `savefig`). Example: only call `show` if an env var is set, or delete it for CLI use. |
| **4** | `manual/linear_model.R` | Replace `aes_string(...)` with tidy `aes(x = .data[[x_col]], y = .data[[y_col]])` to match the AI script and avoid deprecation warnings. |
| **5** | `ai/` (optional cleanup) | Call out in `README_AI.md` (or remove) which legacy `linear_regression_*` files are Assignment 2 leftovers vs required Assignment 3 `linear_model*` files. |

**Suggested first fix for the assignment requirement:** Comment **#1** (print diagnostics in `manual/linear_model.py`). It is the clearest requirement gap.

---

## 6. Requirement checklist (quick)

| Requirement | `manual/` | `ai/` |
|-------------|-----------|-------|
| Fit linear regression | Yes | Yes |
| Print slope, intercept, *r*, MSE | **Python: No** / R: Yes | Yes |
| Scatter + fitted line | Yes | Yes |
| Annotate equation + *r* | Yes | Yes |
| Scripts save PNG | Yes | Yes |
| Notebook Markdown interpretation | Yes | Yes |
| `PROMPTS.md` / `README_AI.md` / this review | N/A | Yes |

---

## Changes made in response to review

_None yet. After addressing at least one comment above, document the fix here (what changed and why)._
