## 0. Keyboard shortcuts ----

# For mac:
# Cmd + Enter to run code
# Cmd + SHIFT + C to toggle comment
# Cmd + SHIFT + A to reformat code

# (For Windows, use Cntrl insted of Cmd)

# install.package("tidyverse")

# try it out!!
2 + 2 / 54 ^ 2
print(c("hello", "world", "helloooooo"))


## 1. Set Up: Loading Packages ----

# At the top of your script you should load
# ALL the required packages. A package only
# needs to be installed ONCE on your computer,
# but it still needs to be loaded at the top
# of each script to be used.

# To install a package, use this syntax:
# install.packages("packagename")
# (Note the quotation marks!)

# To load a package, use this syntax:
# library(packagename)

# You will almost ALWAYS want to load the tidyverse.
# Why? It's super useful!!
# It is a "suite" of several packages, including:
# dplyr - for data wrangling
# ggplot2 - for beautiful plots
# and more!

# Another great package is "ggrepel", which
# builds on the ggplot2 package and allows us
# to automatically label points on a plot
# without obscuring the data.

# Load packages
library(tidyverse) # for data wrangling
library(ggrepel) # for labelling points on a plot

## 2. Loading in data ----

# We use different functions to load data into R depending
# on how the data is stored (i.e., the file extension).

# Here are the main tools you will need,
# using the format of package_name::function_name()

#   .xls / .xlsx --> use readxl::read_excel()
#   .csv --> use readr::read_csv()
#   .tab --> use readr::read_delim()
#   .Rdata --> use load()
#   .dta --> use readstata13::read.dta13()

# Whenever we load data into R, we need to give it a name
# in order to store it as an object in our environment.
# We do this using the assignment operator "<-".

# Object names should:
#   1. Be meaningful (e.g. "weo" for the "WEO-2018" dataset)
#   2. Be short (because you're going to have to write it out a bunch of times!)
#   3. Not contain any special characters except an underscore (e.g. "weo_2018" would be OK, "weo-2018" or "weo.2018" would not)

# To load data we need to give R the file path.
# You can do this in two ways:

#   1. Give the ABSOLUTE file path
#   e.g. my_data <- read_csv("/Users/sophiehill/Google-Drive/Harvard/Teaching/HKS API-202/Review Sessions/my-dataset.csv")

#   2. Give the RELATIVE file path
#   e.g. my_data <- read_csv("my-dataset.csv")

# "Relative" means: relative to your current working directory.
# You can check where your working directory is by running:
getwd()

# If you create an R project file, then the working directory
# will be automatically set to the location of the project file.
# If you just create a .R script on its own, the working
# directory will be set to some default location (e.g. "~/Downloads")

# To change the working directory, run this:
# setwd("path/to/working/directory")
# OR, go to the menu bar:
# Session --> Set Working Directory --> Choose Directory

# R also has some built-in datasets.
# You can see a list by running:
# data()

# For example, you can load the "msleep" dataset like this:
data(msleep)

# Let's take a peak:
head(msleep)
str(msleep)
glimpse(msleep)

# Note: if you want to *remove* objects from the 
# environment, you can use this syntax:
# rm(object_name)


# For example:
thing1 <- c("temporary", "thing")
rm(thing1)

## 3. Slicing and dicing ----

# We can slice and dice data in two main ways:
#   1. Manually tell R which rows/columns we want
#   2. Tell R to find rows/columns that match some criteria


## Manually slicing and dicing:

# In tidyverse syntax, we deal with rows and columns separately:
# slice() or filter() for rows
# select() for columns
msleep %>% slice(1) # row 1 only
msleep %>% select(1) # column 1 only
msleep %>% slice(1) %>% select(1) # row 1 column 1
msleep %>% slice(1, 5, 7) %>% select(2, 4) # rows 1, 5, 7, columns 2, 4
msleep %>% slice(1:10) %>% select(1:2) # rows 1-10, columns 1-2

msleep %>% slice(1:10) %>% select(name)
msleep %>% slice(1:10) %>% select(name, sleep_total)
msleep %>% slice(1:10) %>% select(name:sleep_total) # use ":" to specify ranges

# we can use the minus sign to specify columns to DROP:
msleep %>% select(-name) # drop name
msleep %>% select(-c(name, sleep_total)) # drop name and sleep_total
msleep %>% select(-(name:sleep_total)) # drop columns from name to sleep_total

# using criteria to slice and dice
msleep %>% filter(sleep_total > 14)
msleep %>% filter(sleep_total > 14 & vore == "omni") # & is "AND"
msleep %>% filter(sleep_total > 14 | vore == "omni") # | is "OR"
msleep %>% filter(vore != "omni") # != is "NOT equal to"
msleep %>% filter(!(sleep_total > 14)) # !(...) is NOT(...)

## Exercise 3.1 ----
# Write code to find the names of all animals that have 
# above-median total sleep and below-median REM sleep
msleep %>% filter()

names(msleep)
med1 <- median(msleep$sleep_total)
med2 <- median(msleep$sleep_rem, 
               na.rm = TRUE)



## Exercise 3.2 ----

# (a) Find the carnivore with the biggest brain weight.



# (b) Count how many omnivores have a brain weight of > 0.1


# (c) Calculate the mean body weight of all animals, first including and then excluding any elephants.

# Hint: you can use str_subset() to find any names containing the word "elephant".


## 4. A digression into data types ----

# Data types in R
# A. Character (text string)
# B. Factor (numeric with text labels)
# C. Integer (integer numbers)
# D. Double (numbers with decimal points)
# E. Logical (TRUE/FALSE)

# R's functions will try to guess the appropriate
# way to store data, but sometimes it will get it wrong.
# In those cases we have to "coerce" the type.

## A. CHARACTERS
my_character_value <- "abc"
my_character_value

my_character_vector <- c("a", "b", "c")
my_character_vector

# class() tells us the type of the object
class(my_character_value)
class(my_character_vector)

# nchar() tells us the number of characters
nchar(my_character_value)
nchar(my_character_vector)

# length tells us the length of vector
# i.e, the number of elements
length(my_character_value)
length(my_character_vector)

## B. FACTORS
my_factor_vector <- as.factor(my_character_vector)
my_factor_vector
class(my_factor_vector)

## C. INTEGERS
my_integer_value <- 3L
# wait, what the heck is that "L" doing there??
# don't worry, it's just a suffix that tells R to store
# this number as an integer with no decimal places.
my_integer_value

my_integer_vector <- c(1L, 50L, 3L)
my_integer_vector

class(my_integer_value)
class(my_integer_value)

## D. NUMERIC
my_numeric_value <- 3
my_numeric_value

my_numeric_vector <- c(1, 50, 3)
my_numeric_vector

class(my_numeric_value)
class(my_numeric_vector)

## E. LOGICAL
my_logical_value <- TRUE
# notice how RStudio will highlight the word TRUE in color
# that's because it recognizes TRUE is a logical value
# this is a rare occasion when we can write a word in
# R without using quotation marks.
my_logical_value

my_logical_vector <- c(TRUE, FALSE)
my_logical_vector

class(my_logical_value)
class(my_logical_vector)

# we can produce logical values by testing a criterion:
# Is the object "my_numeric_value" equal to 3?
my_numeric_value == 3
# Is the object "my_numeric_vector" equal to 2?
my_numeric_value == 2

# Why did we use TWO equals signs above?
# If we use ONE equals sign, R will treat it like the
# assignment operator and overwrite the value!
my_numeric_value = 2
my_numeric_value
# Using TWO equals signs tells R that we want to test
# whether something is equal, not assign it to be equal.

# it works the same with vectors:
my_numeric_vector == 3

# and we can use other operators too:
my_numeric_vector > 3
my_numeric_vector >= 3 # ">=" is greater-than-or-equal-to

# R does not like it when you try to combine different
# data types in a single vector.

# For example:
c(TRUE, 5)
# will get coerced to c(1, 5)

c("hello", 5)
# will get coerced to c("hello", "5")

## 5. Missing data ----

# Let's go back to the "msleep" dataset.

# We can ask whether values are missing
# using the is.na() function.
sum(is.na(msleep$sleep_rem))

# Note that just like TRUE and FALSE, NA is a special symbol
# which is distinct from the character string "NA"
is.na(NA)
is.na("NA")

# We can then count the number of missing values for a specific variable:
# (Note: when you add up logical values TRUE is 1 and FALSE is 0).

msleep %>% summarise(n_sleep_rem_missing = sum(is.na(sleep_rem)))

# Or we can ask R to count missing values across ALL columns:
msleep %>% summarise_all(~ sum(is.na(.)))

# To remove all rows with any missing observations,
# we can use na.omit().
# This is called "casewise deletion".
msleep_nonmissing <- msleep %>% na.omit()

# count number of rows
nrow(msleep) # 83
nrow(msleep_nonmissing) # 20

# confirm there are now no missing values
msleep_nonmissing %>% summarise_all(~ sum(is.na(.)))

# There is no "easy" way to deal with missing data.
# Researchers must use their substantive knowledge
# to weight the pros and cons of different approaches
# and justify their choices.

## Exercise 5.1 ----

# (a) Which column has the highest number of missing values?

# (b) Create a new variable called sleep_rem_imputed, 
# where you replace all missing values of sleep_rem with
# the overall median.

# (c) Compare the mean and median of sleep_rem vs sleep_rem_imputed.


## 6. Summary statistics ----

# After loading a dataset and taking a peak
# using head() and str(), our next move
# is often to compute some summary statistics.

# summary() is a useful base R function
# we can use it on the whole dataset:
summary(msleep)

# or on a specific variable:
summary(msleep$sleep_total)
summary(msleep$sleep_rem)

# we can also do this the tidyverse way:
# the summarise() function serves the same
# purpose as pivot tables etc. in Excel
# It collapses our data from 1 row = 1 observation
# to aggregate statistics for groups of observations

# Let's calculate the mean and median amount of REM sleep
# across all animal in the dataset:
msleep %>%
  summarise(
    mean_sleep_rem = mean(sleep_rem, na.rm = TRUE),
    median_sleep_rem = median(sleep_rem, na.rm = TRUE)
  )

# Now let's do the same thing but taking
# means/medians WITHIN groups
# To do this, we first "group" the animals based on what they eat:
msleep %>%
  group_by(vore) %>%
  summarise(
    mean_sleep_rem = mean(sleep_rem, na.rm = TRUE),
    median_sleep_rem = median(sleep_rem, na.rm = TRUE)
  )

## Exercise 6.1 ----
# (a) Which group (carni / herbi / insecti / omni) has the
# highest mean REM sleep?

# (b) How could you find this using code (instead of just looking)? Hint: try using slice_max(). Find the syntax by running ?slice_max


# We can also group by more than one variable

# First let's create a new variable to classify
# animals as "big" or "small" based on their body weight

# Let's look at the distribution of body weight:
summary(msleep$bodywt)

# Wow! Look at the difference between the mean and median... what does this tell us?
# There are some very heavy outliers!
# In our case it's two species of elephants!

# save median weight as an object
median_weight <- median(msleep$bodywt)

# create categorical variable big/small
msleep <- msleep %>% mutate(size = case_when(bodywt >= median_weight ~ "big",
                                             bodywt < median_weight ~ "small"))

# check
msleep %>% group_by(size) %>% count()

# OK! Now let's try grouping by vore AND size
msleep %>%
  group_by(vore, size) %>%
  summarise(
    mean_sleep_rem = mean(sleep_rem, na.rm = TRUE),
    median_sleep_rem = median(sleep_rem, na.rm = TRUE)
  )

## 7. Making plots ----

# With ggplot you can make pretty much any plot you can imagine!

# ggplot works by creating LAYERS
# layers are stacked on top of each other using the "+" sign

# Some layers are made up of "geoms", i.e. "geometric objects"

# Types of geom:
# geom_point() -- scatterplot
# geom_line() -- line plot
# geom_col() -- barplot
# geom_density() -- density plot
# geom_histogram() -- histogram
# geom_abline() -- diagonal line
# geom_hline() -- horizontal line
# geom_vline() -- vertical line

# The most important question to ask yourself
# when using ggplot is:
#   Do I need to summarize my data before calling ggplot?

# If you are going to show "raw" data,
# then the answer is NO
#   e.g. scatterplots, histograms, density

# If you are going to show group-level averages,
# then the answer is YES
# e.g. bar plot, line plot

# OK... let's make some plots!


# Scatterplot
msleep %>%
  ggplot(aes(x = sleep_total,
             y = bodywt,
             color = vore)) +
  geom_point() +
  theme_classic() +
  labs(
    x = "Total hours of sleep",
    y = "Weight",
    caption = "Source: Mammals sleep dataset",
    title = "Sleepiness vs size:",
    subtitle = "An investigation"
  )

# Whoa, look at those pesky elephants!
# Let's filter them out so we can see
# the other points more clearly...

msleep %>%
  filter(bodywt < 2000) %>%
  ggplot(aes(x = sleep_total,
             y = bodywt,
             label = name)) +
  geom_point() +
  theme_classic() +
  labs(
    x = "Total hours of sleep",
    y = "Weight",
    caption = "Source: Mammals sleep dataset",
    title = "Sleepiness vs size:",
    subtitle = "An investigation"
  ) +
  geom_text_repel(size = 2)

# Lovely!

# Density plot

msleep %>%
  filter(!is.na(vore)) %>%
  ggplot(aes(x = sleep_total,
             group = vore,
             fill = vore)) +
  geom_density(alpha = 0.5, lwd = 0.1) +
  theme_classic() +
  labs(
    x = "Hours of sleep",
    y = "",
    title = "Distribution of total hours of sleep",
    subtitle = "By diet",
    caption = "Mammals sleep dataset"
  ) +
  guides(fill = guide_legend(title = "Diet"))

## Barplot
msleep %>%
  filter(!is.na(vore)) %>%
  group_by(vore) %>%
  summarise(mean_sleep = mean(sleep_total)) %>%
  ggplot(aes(
    x = mean_sleep,
    y = vore,
    fill = vore,
    label = round(mean_sleep, 0)
  )) +
  geom_col() +
  theme_classic() +
  labs(
    x = "",
    y = "",
    title = "Mean hours of sleep",
    subtitle = "By diet",
    caption = "Source: Mammals sleep dataset"
  )  +
  theme(legend.position = "none") +
  geom_text(nudge_x = 1)

## Themes
# Here I am using the Classic Theme
# theme_classic()
# There are many other themes included in ggplot2, and for extra fun ones you can install the ggthemes package...
# See: https://r-charts.com/ggplot2/themes/


# To save a plot, we first assign it as an object
# and then use a function like "ggsave" to specify
# how to save it (e.g. jpeg/png/pdf)
my_density_plot <- msleep %>%
  filter(!is.na(vore)) %>%
  ggplot(aes(x = sleep_total,
             group = vore,
             fill = vore)) +
  geom_density(alpha = 0.5, lwd = 0.1) +
  theme_classic() +
  labs(
    x = "Hours of sleep",
    y = "",
    title = "Distribution of total hours of sleep",
    subtitle = "By diet",
    caption = "Mammals sleep dataset"
  ) +
  guides(fill = guide_legend(title = "Diet"))

# save as png
# it will save to your working directory
ggsave(
  filename = "my_density_plot.png",
  plot = my_density_plot,
  width = 4,
  height = 3
)
