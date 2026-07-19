args <- commandArgs(trailingOnly = TRUE)
if (length(args) != 3) {
  stop("Usage: Rscript linear_model.R <filename> <x_column> <y_column>")
}

filename <- args[1]
x_col <- args[2]
y_col <- args[3]

data <- read.csv(filename)
formula <- as.formula(paste(y_col, "~", x_col))
model <- lm(formula, data = data)

slope <- coef(model)[2]
intercept <- coef(model)[1]
r <- cor(data[[x_col]], data[[y_col]])
pred <- predict(model)
mse <- mean((data[[y_col]] - pred)^2)

cat("Slope:", slope, "\n")
cat("Intercept:", intercept, "\n")
cat("Correlation coefficient (r):", r, "\n")
cat("Mean Squared Error (MSE):", mse, "\n")

library(ggplot2)

plot <- ggplot(data, aes_string(x = x_col, y = y_col)) +
  geom_point(color = "red") +
  geom_smooth(method = "lm", se = FALSE, color = "blue") +
  annotate(
    "text",
    x = min(data[[x_col]]) + (max(data[[x_col]]) - min(data[[x_col]])) * 0.55,
    y = min(data[[y_col]]) + (max(data[[y_col]]) - min(data[[y_col]])) * 0.15,
    label = paste(
      "y =", round(slope, 2), "x +", round(intercept, 2),
      "\nr =", round(r, 2), "\nMSE =", round(mse, 2)
    ),
    size = 4
  ) +
  ggtitle(paste(y_col, "vs", x_col)) +
  xlab(x_col) +
  ylab(y_col)

ggsave("regression_plot_r.png", plot)
print(plot)
