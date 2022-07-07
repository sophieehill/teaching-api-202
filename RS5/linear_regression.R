library(tidyverse)

## READ ME ----

# In this script, we're going to create a simulated dataset of x's and y's and then run linear regression model.

# The advantage of using a simulated dataset here is that we can *define* the relationship between the x and y variables. We can then test whether our fitted model is able to recover that relationship. 

## Creating a fake dataset ----

## Set our sample size
n <- 20

## Create some x values
# runif() gives us a random draw from a uniform distribution
# "uniform distribution" = a distribution where every value between the min and max is equally likely
x <- runif(n = n, min = 0, max = 50)

# Take a look
x

## Create a y variable 
# We are going to make the y values depend on the x values
# y = beta_0 + beta_1*x + noise
# y = intercept + slope*x + noise

# pick a random number for the intercept
beta_0 <- runif(n = 1, min = -10, max = 10)

# pick a random number for the slope
beta_1 <- runif(n = 1, min = -5, max = 5)

# Create some individual-level "noise" by drawing from a normal distribution using rnorm()
# FYI: I am setting the std dev of this noise term equal to the std dev of my x's. This is to ensure that we get enough noise to make things interesting but not so much that there's no discernible relationship left!
noise <- rnorm(n = n, mean = 0, sd = 1*sd(x))

# Create the y values
y <- beta_0 + (beta_1 * x) + noise

# Take a look
y

dat <- bind_cols(x = x, y = y) 

# Run a linear regression of y on x using lm()
fit <- lm(y ~ x, data = dat)

# What is this object "fit" that we just created?
str(fit)

# fit is a model object
# Using str(), we can see that it is basically a list of 12 different elements

# Luckily there are some nice pre-packaged R functions to extract useful bits and pieces from the model object

# coef() just extracts the model coefficients
coef(fit)

# summary() prints a nicely-laid out summary
summary(fit)

# Let's save the model coefficients
# coef(fit) gives us a vector of length 2
# coef(fit)[1] gives us the first element of the vector
# coef(fit)[2] gives us the second element of the vector
intercept_true <- coef(fit)[1]
slope_true <- coef(fit)[2]

# Plot our data and save as an object called "p"
p <- dat %>%
  ggplot(aes(x = x,
             y = y)) +
  geom_point() +
  labs(x = "",
       y = "")

# Take a look
p

# Now we can add our line of best fit using geom_abline(), and the slope and intercept values that we saved above:
p <- p + geom_abline(intercept = intercept_true,
              slope = slope_true,
              color = "blue")
p

## Practice problems ----


# (1) Calculate the predicted values from the model for each value of x in the data. Add this new variable to the dataset and called it "y_hat".

# (2) Calculate the prediction error, which is the difference between the true value of y and the predicted value of y. Add this to the dataset and called it "pred_error".

# (3) What is the mean of the variable "pred_error"? 



