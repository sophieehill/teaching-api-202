## Review Session 3: Useful Tips for Pset1 ----

# Note: there are "coding hints" in the PSet that
# refer to the winter assignment solutions. So
# make sure to have those up! They are available on
# your API-202 Canvas site under Files.

# You will submit two things for the PSet:
# (1) A Word document containing your explanations and plots
# (2) A reproducible .R script containing all the code

# *Do not paste R code into the Word doc*
# There _might_ be some cases where you may wish to paste
# R output (i.e. the stuff that gets printed to the console)
# into your Word doc. But in general you should try to extract
# the information needed and include it in a well-written sentence,
# or nicely formatted table.
# E.g. instead of pasting "Mean   :4.352", you should write:
# "The mean of this variable is 4.352."

## Initial set-up ----

# Load tidyverse package
library(tidyverse)

# Set theme for plots
# If you set the theme like this, you don't have to 
# add "+ theme_bw()" to each plot individually :)
theme_set(theme_bw())

# Load data
# Note: Make sure you can see this csv file in the Files pane (bottom-right)
# If you can't you need to move the file or set your working directory to the file's location
agg.data <- read.csv("dhs_aggregate.csv")

# read.csv() is a base R function
# read_csv() is the tidyverse equivalent
# you can use either here!

## Exploring the data ----

# Take a peek
glimpse(agg.data)

# Here are some examples of useful R code to 
# help us understand the variables in the dataset
# Note: these not directly related to any particular 
# question on the PSet!

# How many observations do we have in each region?
agg.data %>% group_by(region) %>% tally()

# use summary() to tell us some basic
# summary statistics for the variable "tfr" 
agg.data %>% select(tfr) %>% summary()

# summary() is a base R function we can also get 
# summary statistics using its tidyverse cousin, summarize()
agg.data %>% summarize(mean_tfr = mean(tfr))

# the benefit of doing things the tidyverse way
# is that we have much more flexibility

# For example, I can pick and choose which summary
# statistics I want for which variables:
agg.data %>% 
  summarize(mean_tfr = mean(tfr),
            median_wif = median(w.if))

# I can also use the group_by() function to disaggregate
# E.g., what is mean tfr *within* each region?
agg.data %>% 
  group_by(region) %>% 
  summarize(mean_tfr = mean(tfr))

# And why stop there! What is the mean tfr *within* each 
# region *within* each year??
agg.data %>% 
  group_by(region, year) %>% 
  summarize(mean_tfr = mean(tfr))

# Cool! 
# Of course, when "grouping" the data like this it's important to think
# about how many observations are falling within each group
# We don't want to calculate a mean without knowing that 
# there's only one observation in that group!

# Check the tallies
agg.data %>% 
  group_by(region, year) %>% 
  summarize(n = n())

## Making and saving plots ----

# Another nice thing about summarize() is that
# the output it provides works nicely with ggplot()

# For example: let's plot the number of countries in each region
# in the sample by year
agg.data %>% 
  group_by(region, year) %>% 
  summarize(median_tfr = median(tfr)) %>%
  ggplot(aes(x = year, 
             y = median_tfr, 
             color = region)) +
  geom_line()

# To save a plot we use ggsave()
# There are two ways to use it:
# (1) Create a plot and then run ggsave(filename = "my_plot.png")
# (2) Save the plot by giving it a name, e.g. "my_plot", 
# using the assignment operator <--, and then run: 
# ggsave(plot = my_plot, filename = "my_plot.png")

# Method (1)
ggsave(filename = "line_plot.png")

# Method (2)
line_plot <- agg.data %>% 
  group_by(region, year) %>% 
  summarize(median_tfr = median(tfr)) %>%
  ggplot(aes(x = year, 
             y = median_tfr, 
             color = region)) +
  geom_line()

ggsave(plot = line_plot, filename = "line_plot2.png")

# Now open up the image files "line_plot.png" and "line_plot2.png"
# They should be exactly the same!

# We can specify the dimensions of the image like this:
ggsave(plot = line_plot, 
       filename = "line_plot.png",
       height = 5,
       width = 7)

# Bring up help page to see the arguments:
?ggsave

# We can use several different units:
ggsave(plot = line_plot, 
       filename = "line_plot.png",
       height = 20,
       width = 30, 
       units = "cm")

# It's hard to guess what the "right" dimensions would be
# So often a good first step is to use the Plots pane (bottom-right)
# Click Export --> Save as Image 
# It will show a live preview where you can alter the dimensions

# A good default for most plots is 5 x 7 inches:
ggsave(plot = line_plot, 
       filename = "line_plot.png",
       height = 5,
       width = 7, 
       units = "in")

## Optional: Exporting nice tables to Word ----

# Save the table that I want to export by giving it a name
my_tab <- agg.data %>% 
  group_by(region, year) %>% 
  summarize(n = n()) %>% 
  head(n=20)

my_tab

# Load the rtf package
# install.packages("rtf")
library(rtf)

# create a temporary word doc
# WARNING: do not use the name of your PSet solutions doc, 
# it will get overwritten!!
temp <- RTF("temp.doc") 
# insert table
addTable(temp, my_tab)
# we can also insert text
# the "\n" symbol indicates a line break
addParagraph(temp, "Here is some text I inserted! \n")
# now tell R we are done editing the file
done(temp)

# You can now open the Word doc called "temp.doc" and 
# copy and paste the nicely-formatted table into your
# PSet solutions Word doc.
