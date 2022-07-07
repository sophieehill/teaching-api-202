## Practice problems ----

fit <- lm(gender_pay_ratio ~ pctfemaleleg, data = dat)

## Q1: Interpreting regression results

# (a) Using the coef() function, extract the coefficients from the model and then interpret what they mean. (You can write you answer inside your .R script as a comment. Just remember to put a "#" at the start of the line!)

coef(fit)
# (Intercept) pctfemaleleg 
# 71.4712114    0.2610263 
# We can interpret the intercept as the predicted value of the Gender Pay Ratio when our "x" variable (the % of women in the state legislature) is 0. 
# The coefficient for pctfemaleleg means that a 1 percentage point increase in women in the state legislature is associated with a 0.26 percentage point increase in the Gender Pay Ratio.

# (b) Using the summary() function, examine the uncertainty around our estimates of the intercept and slope coefficient. Are these estimates statistically significant? 

summary(fit)
# Yes, both estimates are statistically significant, with p values well below 0.05. 

# (c) Using the output of the tidy() function, construct a 95% confidence interval for both coefficients by using the formula: estimate +/- (2 * standard error). Do either of the confidence intervals cover 0?

tidy(fit) %>% 
  mutate(ci_lower = estimate - 2*std.error,
         ci_upper = estimate + 2*std.error)
# Neither confidence interval covers 0.

## Q2: Evaluating model fit

# (a) Recall that we saved the coefficients from our model as "intercept_lm" and "slope_lm". Use these saved values to calculate the predicted values from the model for each value of x in the data. Add this new variable to the dataset and called it "y_hat".
dat <- dat %>% 
  mutate(
    y_hat = intercept_lm + (slope_lm * pctfemaleleg),
  )

# (b) Calculate the prediction error, which is the difference between the true value of y and the predicted value of y. Add this to the dataset and called it "pred_error".

dat <- dat %>% 
  mutate(
    pred_error = gender_pay_ratio - y_hat
  )

# (c) Display the residuals on the scatterplot by drawing vertical lines from each point to the line of best fit. Here is some template code to get you started; you just need to fill in the correct variable names.

# p <- p + geom_segment(data = dat,
#                       aes(x = X_VAR,
#                           xend = X_VAR,
#                           y = ACTUAL_Y,
#                           yend = PREDICTED_Y),
#                       color = "red",
#                       lty = "dotted")

p + geom_segment(data = dat,
                      aes(x = pctfemaleleg,
                          xend = pctfemaleleg,
                          y = gender_pay_ratio,
                          yend = y_hat),
                      color = "red",
                      lty = "dotted")

# (d) Arrange your dataset according to the absolute magnitude of the residuals. Do you notice any patterns in terms of which states lie close to the line of best fit and which states do not?

dat %>% 
  mutate(pred_error_abs = abs(pred_error)) %>% 
  arrange(-pred_error_abs) %>%
  select(state, pctfemaleleg, gender_pay_ratio, pred_error_abs)

# Out of the top 5 states with the largest prediction errors, 4 of them are heavily Democratic states with high levels of gender pay equity and high average incomes (California, District of Columbia, Delaware, New York). This suggests it might be useful to control for the partisan composition of the state, or even allow it as an interaction term.


