#!/usr/bin/env Rscript
# Simple linear regression: Salary ~ YearsExperience (R)
#
# Reads regression_data.csv from the script directory (or cwd), plots the data,
# fits a linear model, overlays the regression line, and evaluates the model.
#
# Usage:
#   Rscript linear_regression_r.R

args_all <- commandArgs(trailingOnly = FALSE)
file_arg <- grep("^--file=", args_all, value = TRUE)
script_dir <- if (length(file_arg) > 0) {
  dirname(normalizePath(sub("^--file=", "", file_arg[1])))
} else {
  getwd()
}

output_dir <- file.path(script_dir, "output_r")
dir.create(output_dir, showWarnings = FALSE, recursive = TRUE)

has_ggplot2 <- requireNamespace("ggplot2", quietly = TRUE)
if (!has_ggplot2) {
  message("ggplot2 not found. Using base graphics.")
}
cat("ggplot2 available:", has_ggplot2, "\n")
cat("R version:", R.version.string, "\n")

# Resolve data path
candidates <- c(
  file.path(script_dir, "regression_data.csv"),
  file.path(getwd(), "regression_data.csv"),
  "regression_data.csv"
)
data_path <- candidates[file.exists(candidates)][1]
if (is.na(data_path) || !file.exists(data_path)) {
  stop("Could not find regression_data.csv. Place it in the same folder as this script.")
}
cat("Using data file:", normalizePath(data_path), "\n")

# 1. Load and inspect
df <- read.csv(data_path, stringsAsFactors = FALSE)
cat("Shape:", nrow(df), "rows x", ncol(df), "columns\n")
cat("Columns:", paste(names(df), collapse = ", "), "\n\n")
print(df)
print(summary(df))
str(df)

# 2. Scatter plot
scatter_path <- file.path(output_dir, "01_scatter.png")
png(scatter_path, width = 700, height = 500, res = 120)
if (has_ggplot2) {
  library(ggplot2)
  print(
    ggplot(df, aes(x = YearsExperience, y = Salary)) +
      geom_point(color = "steelblue", size = 3) +
      labs(
        title = "Salary vs Years of Experience",
        x = "Years of Experience",
        y = "Salary"
      ) +
      theme_minimal()
  )
} else {
  plot(
    df$YearsExperience, df$Salary,
    pch = 19, col = "steelblue",
    xlab = "Years of Experience",
    ylab = "Salary",
    main = "Salary vs Years of Experience"
  )
  grid()
}
dev.off()
cat("\nSaved:", scatter_path, "\n")

# 3. Fit model
model <- lm(Salary ~ YearsExperience, data = df)
intercept <- coef(model)[["(Intercept)"]]
slope <- coef(model)[["YearsExperience"]]

cat(sprintf(
  "\nFitted model: Salary = %.2f + %.2f * YearsExperience\n",
  intercept, slope
))
cat(sprintf("Intercept: %.4f\n", intercept))
cat(sprintf("Slope:     %.4f\n\n", slope))
print(summary(model))

# 4. Overlay regression line
fit_path <- file.path(output_dir, "02_regression_line.png")
png(fit_path, width = 700, height = 500, res = 120)
if (has_ggplot2) {
  print(
    ggplot(df, aes(x = YearsExperience, y = Salary)) +
      geom_point(color = "steelblue", size = 3) +
      geom_smooth(method = "lm", se = FALSE, color = "#DC143C", linewidth = 1) +
      labs(
        title = "Linear Regression: Salary ~ YearsExperience",
        x = "Years of Experience",
        y = "Salary"
      ) +
      theme_minimal()
  )
} else {
  plot(
    df$YearsExperience, df$Salary,
    pch = 19, col = "steelblue",
    xlab = "Years of Experience",
    ylab = "Salary",
    main = "Linear Regression: Salary ~ YearsExperience"
  )
  abline(model, col = "#DC143C", lwd = 2)
  grid()
  legend(
    "topleft",
    legend = c("Observed", "Fitted line"),
    col = c("steelblue", "#DC143C"),
    pch = c(19, NA),
    lty = c(NA, 1),
    lwd = c(NA, 2)
  )
}
dev.off()
cat("Saved:", fit_path, "\n")

# 5. Evaluate
y <- df$Salary
y_pred <- fitted(model)
residuals_vec <- residuals(model)

r2 <- summary(model)$r.squared
adj_r2 <- summary(model)$adj.r.squared
mae <- mean(abs(residuals_vec))
mse <- mean(residuals_vec^2)
rmse <- sqrt(mse)

cat("\nModel evaluation\n")
cat(strrep("-", 40), "\n")
cat(sprintf("R-squared:           %.4f\n", r2))
cat(sprintf("Adjusted R-squared:  %.4f\n", adj_r2))
cat(sprintf("MAE:                 %.2f\n", mae))
cat(sprintf("MSE:                 %.2f\n", mse))
cat(sprintf("RMSE:                %.2f\n", rmse))
cat(sprintf("Residual mean:       %.4f\n", mean(residuals_vec)))
cat(sprintf("Residual std. dev.:  %.2f\n", sd(residuals_vec)))

cat("\nANOVA / F-test:\n")
print(anova(model))

results <- data.frame(
  YearsExperience = df$YearsExperience,
  Salary = y,
  Predicted = as.numeric(y_pred),
  Residual = as.numeric(residuals_vec)
)
print(results)

results_path <- file.path(output_dir, "predictions.csv")
write.csv(results, results_path, row.names = FALSE)
cat("\nSaved:", results_path, "\n")

diag_path <- file.path(output_dir, "03_diagnostics.png")
png(diag_path, width = 1200, height = 500, res = 120)
op <- par(mfrow = c(1, 2))
plot(
  y_pred, residuals_vec,
  pch = 19, col = "steelblue",
  xlab = "Predicted Salary", ylab = "Residual",
  main = "Residuals vs Fitted"
)
abline(h = 0, col = "#DC143C", lty = 2)

plot(
  y, y_pred,
  pch = 19, col = "steelblue",
  xlab = "Actual Salary", ylab = "Predicted Salary",
  main = "Actual vs Predicted"
)
abline(0, 1, col = "#DC143C", lty = 2)
par(op)
dev.off()
cat("Saved:", diag_path, "\n")

cat("\nDone.\n")
