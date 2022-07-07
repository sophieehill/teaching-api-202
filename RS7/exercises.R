## SETUP FOR PRACTICE PROBLEMS ----

library(tidyverse)
library(broom)
library(ggeffects)

theme_set(theme_classic())

load("hw2.RData")

cces20 <- cces_pres %>%
  filter(year == 2020,
         voted_pres_party %in% c("Democratic", "Republican")) %>%
  mutate(vote_dem = case_when(voted_pres_party=="Democratic" ~ 1,
                              voted_pres_party=="Republican" ~ 0))

## PRACTICE PROBLEMS ----

# 1. How many categories does the variable race have?



# 2. How many coefficients will this produce if we include race in our model?



# 3. Run a regression of Democratic voting on race.




# 4. What is the reference category?




# 5. Interpret each coefficient.




# 6. Create dummy variables for each category of race. Re-run the regression using all of these dummy variables except White, instead of using the variable race. How do the coefficients compare?





# 7. Re-run the regression, choosing the dummy variables so that Hispanic is the omitted category. Interpret the coefficients.




