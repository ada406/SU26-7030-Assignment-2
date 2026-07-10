#!/usr/bin/env Rscript
# Simple linear regression with command-line arguments (R)
#
# Same analysis as linear_regression_r.R, but inputs/outputs are configurable.
#
# Examples:
#   Rscript linear_regression_r_cli.R
#   Rscript linear_regression_r_cli.R --data regression_data.csv
#   Rscript linear_regression_r_cli.R \
#       --data regression_data.csv \
#       --x-col YearsExperience \
#       --y-col Salary \
#       --output-dir output_r_cli

parse_args <- function(args) {
  defaults <- list(
    data = NULL,
    x_col = "YearsExperience",
    y_col = "Salary",
    output_dir = NULL,
    no_plots = FALSE,
    help = FALSE
  )

  i <- 1
  while (i <= length(args)) {
    arg <- args[[i]]
    if (arg %in% c("-h", "--help")) {
      defaults$help <- TRUE
    } else if (arg == "--data") {
      i <- i + 1
      defaults$data <- args[[i]]
    } else if (arg == "--x-col") {
      i <- i + 1
      defaults$x_col <- args[[i]]
    } else if (arg == "--y-col") {
      i <- i + 1
      defaults$y_col <- args[[i]]
    } else if (arg == "--output-dir") {
      i <- i + 1
      defaults$output_dir <- args[[i]]
    } else if (arg == "--no-plots") {
      defaults$no_plots <- TRUE
    } else {
      stop("Unknown argument: ", arg, "\nUse --help for usage.", call. = FALSE)
    }
    i <- i + 1
  }
  defaults
}

print_help <- function() {
  cat("Usage: Rscript linear_regression_r_cli.R [options]\n\n")
  cat("Options:\n")
  cat("  --data PATH         Path to CSV data file (default: regression_data.csv next to script)\n")
  cat("  --x-col NAME        Predictor column name (default: YearsExperience)\n")
  cat("  --y-col NAME        Response column name (default: Salary)\n")
  cat("  --output-dir PATH   Directory for plots and predictions (default: output_r_cli)\n")
  cat("  --no-plots          Skip writing plot PNG files\n")
  cat("  -h, --help          Show this help message\n")
}

# Locate script directory
args_all <- commandArgs(trailingOnly = FALSE)
file_arg <- grep("^--file=", args_all, value = TRUE)
script_dir <- if (length(file_arg) > 0) {
  dirname(normalizePath(sub("^--file=", "", file_arg[1])))
} else {
  getwd()
}

opts <- parse_args(commandArgs(trailingOnly = TRUE))
if (isTRUE(opts$help)) {
  print_help()
  quit(save = "no", status = 0)
}

data_path <- if (is.null(opts$data)) {
  file.path(script_dir, "regression_data.csv")
} else {
  opts$data
}
output_dir <- if (is.null(opts$output_dir)) {
  file.path(script_dir, "output_r_cli")
} else {
  opts$output_dir
}
x_col <- opts$x_col
y_col <- opts$y_col

if (!file.exists(data_path)) {
  stop("Data file not found: ", data_path)
}
dir.create(output_dir, showWarnings = FALSE, recursive = TRUE)

has_ggplot2 <- requireNamespace("ggplot2", quietly = TRUE)
if (!has_ggplot2) {
  message("ggplot2 not found. Using base graphics.")
}

cat("ggplot2 available:", has_ggplot2, "\n")
cat("R version:", R.version.string, "\n")
cat("Using data file:", normalizePath(data_path), "\n")
cat("X column:", x_col, "\n")
cat("Y column:", y_col, "\n")
cat("Output dir:", normalizePath(output_dir, mustWork = FALSE), "\n")

df <- read.csv(data_path, stringsAsFactors = FALSE)
if (!(x_col %in% names(df)) || !(y_col %in% names(df))) {
  stop(
    "Columns must include '", x_col, "' and '", y_col, "'. Found: ",
    paste(names(df), collapse = ", ")
  )
}

cat("Shape:", nrow(df), "rows x", ncol(df), "columns\n")
print(df[, c(x_col, y_col)])
print(summary(df[, c(x_col, y_col)]))

# Build formula dynamically
form <- as.formula(paste(y_col, "~", x_col))

if (!isTRUE(opts$no_plots)) {
  scatter_path <- file.path(output_dir, "01_scatter.png")
  png(scatter_path, width = 700, height = 500, res = 120)
  if (has_ggplot2) {
    library(ggplot2)
    print(
      ggplot(df, aes(x = .data[[x_col]], y = .data[[y_col]])) +
        geom_point(color = "steelblue", size = 3) +
        labs(
          title = paste(y_col, "vs", x_col),
          x = x_col,
          y = y_col
        ) +
        theme_minimal()
    )
  } else {
    plot(
      df[[x_col]], df[[y_col]],
      pch = 19, col = "steelblue",
      xlab = x_col, ylab = y_col,
      main = paste(y_col, "vs", x_col)
    )
    grid()
  }
  dev.off()
  cat("\nSaved:", scatter_path, "\n")
}

model <- lm(form, data = df)
intercept <- coef(model)[["(Intercept)"]]
slope <- coef(model)[[x_col]]

cat(sprintf(
  "\nFitted model: %s = %.2f + %.2f * %s\n",
  y_col, intercept, slope, x_col
))
cat(sprintf("Intercept: %.4f\n", intercept))
cat(sprintf("Slope:     %.4f\n\n", slope))
print(summary(model))

y <- df[[y_col]]
y_pred <- fitted(model)
residuals_vec <- residuals(model)

if (!isTRUE(opts$no_plots)) {
  fit_path <- file.path(output_dir, "02_regression_line.png")
  png(fit_path, width = 700, height = 500, res = 120)
  if (has_ggplot2) {
    print(
      ggplot(df, aes(x = .data[[x_col]], y = .data[[y_col]])) +
        geom_point(color = "steelblue", size = 3) +
        geom_smooth(method = "lm", se = FALSE, color = "#DC143C", linewidth = 1) +
        labs(
          title = paste("Linear Regression:", y_col, "~", x_col),
          x = x_col,
          y = y_col
        ) +
        theme_minimal()
    )
  } else {
    plot(
      df[[x_col]], df[[y_col]],
      pch = 19, col = "steelblue",
      xlab = x_col, ylab = y_col,
      main = paste("Linear Regression:", y_col, "~", x_col)
    )
    abline(model, col = "#DC143C", lwd = 2)
    grid()
  }
  dev.off()
  cat("Saved:", fit_path, "\n")
}

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
  df[[x_col]],
  y,
  Predicted = as.numeric(y_pred),
  Residual = as.numeric(residuals_vec)
)
names(results)[1:2] <- c(x_col, y_col)
print(results)

results_path <- file.path(output_dir, "predictions.csv")
write.csv(results, results_path, row.names = FALSE)
cat("\nSaved:", results_path, "\n")

if (!isTRUE(opts$no_plots)) {
  diag_path <- file.path(output_dir, "03_diagnostics.png")
  png(diag_path, width = 1200, height = 500, res = 120)
  op <- par(mfrow = c(1, 2))
  plot(
    y_pred, residuals_vec,
    pch = 19, col = "steelblue",
    xlab = paste("Predicted", y_col), ylab = "Residual",
    main = "Residuals vs Fitted"
  )
  abline(h = 0, col = "#DC143C", lty = 2)

  plot(
    y, y_pred,
    pch = 19, col = "steelblue",
    xlab = paste("Actual", y_col), ylab = paste("Predicted", y_col),
    main = "Actual vs Predicted"
  )
  abline(0, 1, col = "#DC143C", lty = 2)
  par(op)
  dev.off()
  cat("Saved:", diag_path, "\n")
}

cat("\nDone.\n")
