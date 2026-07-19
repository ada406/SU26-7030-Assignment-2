# Prompts Log — Assignment 3 Part B (AI-assisted)

Tool used: Cursor (AI coding assistant)

This file records the prompts used for the three required AI-assisted parts of Assignment 3 Part B.

---

## 1. Creating the enhanced notebooks and scripts

> I need you to compete an assignment for me. For this assignment, I needed to clone a github repository (originallly at think link: https://github.com/ada406/SU26-7030-Assignment-2/commit/80ca530f82b4b10a457c805fdbb9f3bde60600c0 ), create an asssignment 3 branch containing a manual folder with new notebook and script files upgrading the previous notebooks and scripts contained within the manual folder of the main branch of assignment 2 (linked above). Now that those tasks have been completed, I need you to create enhanced notebooks and scripts, which should fit a linear regression model, print slope, y-intercpet, correlation coefficient, and MSE to the console, show the scatter plot with original data, the regressionn lline, and text annotationss on the plot (equation, correlation coefficient). the script needs to save this output as a png file. the notebook needs markdown cells to explain what is being calculated and the interpretation of the sslope, intercept, correlation coefficient, and MSE. You should do all this in a new ai folder as part of assignment 3. since i've already done the pull request, you will need to commit this the the same assignment 3 branch with a new pull request. Before you comit anything to the repossitory, please let me review it!

**Outputs produced from this prompt:**
- `ai/linear_model.py`
- `ai/linear_model.R`
- `ai/linear_model_python.ipynb`
- `ai/linear_model_r.ipynb`
- `ai/regression_plot_python.png`
- `ai/regression_plot_r.png`
- supporting files (`environment.yml`, `setupenv.sh`, dataset copy)

---

## 2. Code review

> great! now can you review my assignment 3 pull request. save your review as "ai/CODE_REVIEW.md" in the repository. after this, i will ask you to help me address at least one of your comments

**Output produced from this prompt:**
- `ai/CODE_REVIEW.md`

**Follow-up (addressing a review comment):**  
After the review, the comment about missing console prints in `manual/linear_model.py` was addressed by adding `print` statements for slope, intercept, correlation coefficient (*r*), and MSE.

---

## 3. AI-generated README

> next, generate a fresh README. Save it as ai/README_AI.md. Don't overwrite the manual README please!

**Output produced from this prompt:**
- `ai/README_AI.md`  
  (root `README.md` and `manual/README` were left unchanged)

---

## Notes

- Prompts are recorded as used in the Assignment 3 Part B workflow.
- AI-generated code and docs were reviewed before committing.
- At least one substantive code-review comment was addressed (`manual/linear_model.py` print statements).
