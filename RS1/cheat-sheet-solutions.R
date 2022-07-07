## Solutions: ReadMe ----
## This script contains solutions to the exercises in the cheat sheet.
## Note: this code is not self-contained. You must first run the code 
## in the cheat sheet up to a particular exercise in order to be able
## to run the solution.

## Exercise 3.1 ----
# Write code to find the names of all animals that have 
# below-mean total sleep and above-mean brain weight

msleep %>%
  filter(sleep_total > median(sleep_total, na.rm=TRUE),
         sleep_rem < median(sleep_rem, na.rm=TRUE)) %>%
  select(name) %>%
  pull()

# Note: pull() is optional here, it simply prints the result as a
# 1-dimensional vector, instead of 3x1 tibble.

## Exercise 3.2 ----

# (a) Find the carnivore with the biggest brain weight.
msleep %>% 
  filter(vore == "carni") %>% 
  slice_max(brainwt) %>%
  select(name) %>%
  pull()

# (b) Count how many omnivores have a brain weight of > 0.1
msleep %>%
  filter(vore == "omni",
         brainwt > 0.1) %>% 
  nrow()

# (c) Calculate the mean body weight of all animals, first including and then excluding any elephants.

# Hint: you can use str_subset() to find any names containing the word "elephant".

elephant_names <- msleep %>% 
  select(name) %>% 
  pull() %>% 
  str_subset("elephant")

sum1 <- msleep %>%
  summarize(mean_wt_all = mean(bodywt, na.rm=TRUE))

sum2 <- msleep %>%
  filter(!(name %in% elephant_names)) %>%
  summarize(mean_wt_nonelephant = mean(bodywt, na.rm=TRUE))

bind_cols(sum1, sum2)

## Exercise 5.1 ----

# (a) Which column has the highest number of missing values?
msleep %>% 
  summarise_all(~ sum(is.na(.))) %>%
  which.max()

# (b) Create a new variable called sleep_rem_imputed, 
# where you replace all missing values of sleep_rem with
# the overall median.

median_sleep_rem <- median(msleep$sleep_rem, na.rm=TRUE)
median_sleep_rem # 1.5

msleep <- msleep %>%
  mutate(sleep_rem_imputed = case_when(is.na(sleep_rem) ~ median_sleep_rem,
                                       TRUE ~ sleep_rem))

# (c) Compare the mean and median of sleep_rem vs sleep_rem_imputed.

msleep %>% 
  summarise(mean_sleep_rem = mean(sleep_rem, na.rm=TRUE),
            median_sleep_rem = median(sleep_rem, na.rm=TRUE),
            mean_sleep_rem_imp = mean(sleep_rem_imputed),
            median_sleep_rem_imp = median(sleep_rem_imputed))

## Exercise 6.1 ----
# (a) Which group (carni / herbi / insecti / omni) has the
# highest mean REM sleep?

# ANSWER: insectivores

# (b) How could you find this using code (instead of just looking)?
# Hint: try using slice_max(). Find the syntax by running ?slice_max

msleep %>% 
  group_by(vore) %>%
  summarise(mean_sleep_rem = mean(sleep_rem, na.rm=TRUE),
            median_sleep_rem = median(sleep_rem, na.rm=TRUE)) %>% 
  slice_max(mean_sleep_rem, n=1) %>% 
  select(vore)

