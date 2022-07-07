library(tidyverse)
theme_set(theme_classic())

data(msleep)
names(msleep)

# look at a scatterplot and "eyeball"
s_plot <- msleep %>% 
  ggplot(aes(x = sleep_rem,
             y = sleep_total)) +
  geom_point() +
  xlim(0,8) +
  ylim(0, 25) +
  labs(title = "Scatterplot")
s_plot


# the line of best fit!
# intercept = where does the line hit the y-axis
# slope = if we go along 1 unit on the x-axis, how many units do we go up on the y-axis to meet the line
s_plot +
  geom_abline(color = "red",
              slope = 2.5,
              intercept = 5)

# ok, now let's actually compute it
# instead of "eyeballing"!
lm(sleep_total ~ sleep_rem, data = msleep) %>%
  summary()

# using summary() gives us a nicely-laid out summary printed to the console
# however, sometimes we want a more "tidyverse" style output (e.g. to feed into a plot)
# in that case, we can use tidy() from the broom package

# install.packages("broom")
library(broom)

lm(sleep_total ~ sleep_rem, data = msleep) %>%
  tidy()

# So how do we use a linear model to generate predictions?
# Let's do it manually first!

# Let's fix an x-value of, say, 2
# i.e. we have an animal that gets 2 hours 
# of rem sleep
x <- 2

# What is our prediction for
# that animal's *total* sleep hours?
# From the regression above we have:
# intercept = 5.47
# slope = 2.62

# So our predicted y value is:
5.47 + 2.62*x

# That is, we would predict that an 
# animal that has 2 hours of REM sleep
# would have 10.71 total hours of sleep.

# If we wanted to make lots of predictions
# (i.e. feed in lots of different x values)
# we could write a function:

pred <- function(x, intercept, slope){
  y <- intercept + slope*x
  return(y)
}

pred(2, 5.47, 2.62) # same as above
  
# The advantage of writing this as a function is that we can feed in lots of x values at once!
# E.g. here are predicted y-values for x = 1,2,...,10
pred(c(1:10), 5.47, 2.62)

# We can also feed in all the observed x's
# i.e., the sleep REM values of the animals in our dataset
msleep <- msleep %>% 
  mutate(sleep_total_pred = pred(sleep_rem, 5.47, 2.62))

# What will it look like if I create a 
# scatterplot of the real x values vs
# the predicted y values?
msleep %>% 
  ggplot(aes(x = sleep_rem,
             y = sleep_total_pred)) +
  geom_point() +
  xlim(0,8) +
  ylim(0, 25)

# Our prediction error is the difference
# between our predicted value and the true value

# We can visualize our prediction errors
# as the vertical distance from the line of 
# best fit to the data point

msleep %>% 
  ggplot(aes(x = sleep_rem,
             y = sleep_total)) +
  geom_smooth(method = "lm", 
              se = FALSE) +
  geom_linerange(aes(x = sleep_rem,
                     ymin = sleep_total,
                     ymax = sleep_total_pred),
                 color = "red") +
  geom_point()
  



