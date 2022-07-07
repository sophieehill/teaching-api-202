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

# 1. How many categories does the variable race have?

cces20 %>% count(race)
#### The variable race has 5 categories.

# 2. How many coefficients will this produce if we include race in our model?
### Including race will produce 5-1 = 4 coefficients.


# 3. Run a regression of Democratic voting on race.
lm(vote_dem ~ race, data = cces20) %>% tidy()

# 4. What is the reference category?
### The reference category is White.

# 5. Interpret each coefficient.

### Being Black (vs White) is associated with a 38.9 percentage point increase in the probability of voting Democrat.
### Being Hispanic (vs White) is associated with a 12.4 percentage point increase in the probability of voting Democrat.
### Being in the "Other" race category (vs White) is associated with a 2.5 percentage point decrease in the probability of voting Democrat.
### Being Asian (vs White) is associated with a 22.3 percentage point increase in the probability of voting Democrat.

# 6. Create dummy variables for each category of race. Re-run the regression using all of these dummy variables except White, instead of using the variable race. How do the coefficients compare?

cces20 <- cces20 %>%
  mutate(White = ifelse(race == "White", 1, 0),
         Black = ifelse(race == "Black", 1, 0),
         Hispanic = ifelse(race == "Hispanic", 1, 0),
         Other = ifelse(race == "Other", 1, 0),
         Asian = ifelse(race == "Asian", 1, 0))

lm(vote_dem ~ Black + Hispanic + Other + Asian, data = cces20) %>% tidy()

### Exactly the same results!

# 7. Re-run the regression, choosing the dummy variables so that Hispanic is the omitted category. Interpret the coefficients.

lm(vote_dem ~ White + Black + Other + Asian, data = cces20) %>% tidy()

### The coefficients should now be interpreted as the "effect" of being in a given racial category versus being Hispanic.
