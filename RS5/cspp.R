# CSPP = The Correlates of State Policy Project
# https://cran.r-project.org/web/packages/cspp/vignettes/cspp-vignette.html
# The CSPP compiles more than 900 variables across 50 states from 1900-2016.
# Even better: it has a cool R package which makes it super easy to grab the data!

# install.packages("cspp")
library(cspp) # to access CSPP data
# install.packages("broom")
library(broom) # to use the tidy() function

library(tidyverse)

# set theme for plots
theme_set(theme_bw())

# Here are the categories of variables in the CSPP:
unique(get_var_info()$category)

# And here's a looooong list of all the variables!
get_var_info() %>% 
  select(variable:category) %>%
  View()

# I'd like to extract the data for 2 variables:
# pctfemaleleg: Percent of state legislators that are female
# gender_gap: Size of the gender wage gap in the state, expressed as a percentage


dat <- get_cspp_data(vars = c("pctfemaleleg", "gender_gap"), 
                           years = c(2019))

glimpse(dat)

# I want to recode the gender_gap variable to make it easier to understand what higher or lower values mean!
dat <- dat %>%
  mutate(gender_pay_ratio = (100 - gender_gap))

p <- dat %>% ggplot(aes(x = pctfemaleleg,
                   y = gender_pay_ratio)) +
  geom_point(size = 3, alpha = 0.7) +
  labs(x  = "Women in state leg (%)",
       y = "Gender Pay Ratio",
       title = "Descriptive representation and wage equality",
       caption = "\nCSPP data from 2019. The Gender Pay Ratio is calculated as:\n(Median Women's Full-time Earnings) / (Median Men's Full-time Earnings),\nso a value of 1 represents wage equality.") +
  theme(text = element_text(size = 18),
        plot.caption=element_text(hjust = 0))
p

# Linear regression of gender pay ratio on the percentage of women in the state leg
fit <- lm(gender_pay_ratio ~ pctfemaleleg, 
          data = dat)

# We have saved the model output as an object called "fit"
# Unlike most of the objects we have seen so far (e.g. vectors, datasets), model outputs tend to have quite a complex structure
# Using str() we can see that fit is actually a list of 12 different elements!
str(fit)

# Don't panic. There are lots of useful functions to extract the relevant information.

# coef() just extracts the model coefficients
coef(fit)

# summary() prints a nicely-laid out summary
summary(fit)

# tidy() is the best way to turn our model output into something we can put into ggplot
tidy(fit)

# Let's save the model coefficients
# coef(fit) gives us a vector of length 2
# coef(fit)[1] gives us the first element of the vector
# coef(fit)[2] gives us the second element of the vector
intercept_lm <- coef(fit)[1]
slope_lm <- coef(fit)[2]

# Now we can manually add a line of best fit to our scatterplot!
p <- p + geom_abline(intercept = intercept_lm,
                     slope = slope_lm,
                     color = "blue",
                lwd = 2)
p

# Of course, you don't need to do this manually with lm() and geom_abline(), you can also use geom_smooth() to run the regression and add the line of best fit all in one go!
p + geom_smooth(method = "lm", se = FALSE)

# And you can choose whether to show a confidence interval around the line
p + geom_smooth(method = "lm", se = TRUE)

## Practice problems ----

## Q1: Interpreting regression results

# (a) Using the coef() function, extract the coefficients from the model and then interpret what they mean. (You can write you answer inside your .R script as a comment. Just remember to put a "#" at the start of the line!)

# (b) Using the summary() function, examine the uncertainty around our estimates of the intercept and slope coefficient. Are these estimates statistically significant? 

# (c) Using the output of the tidy() function, construct a 95% confidence interval for both coefficients by using the formula: estimate +/- (2 * standard error). Do either of the confidence intervals cover 0?

tidy(fit) %>% 
  mutate(
    ci_lower = estimate - (2 * std.error),
    ci_upper = estimate + (2 * std.error))

## Q2: Evaluating model fit

# (a) Recall that we saved the coefficients from our model as "intercept_lm" and "slope_lm". Use these saved values to calculate the predicted values from the model for each value of x in the data. Add this new variable to the dataset and called it "y_hat".

# (b) Calculate the prediction error, which is the difference between the true value of y and the predicted value of y. Add this to the dataset and called it "pred_error".

# (c) Display the residuals on the scatterplot by drawing vertical lines from each point to the line of best fit. Here is some template code to get you started; you just need to fill in the correct variable names.

# p <- p + geom_segment(data = dat,
#                       aes(x = X_VAR,
#                           xend = X_VAR,
#                           y = ACTUAL_Y,
#                           yend = PREDICTED_Y),
#                       color = "red",
#                       lty = "dotted")


# (d) Arrange your dataset according to the absolute magnitude of the residuals. Do you notice any patterns in terms of which states lie close to the line of best fit and which states do not?




