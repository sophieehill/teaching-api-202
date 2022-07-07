## Set up ----
library(tidyverse)
library(broom)
library(sjPlot)

theme_set(theme_classic())

set.seed(02134)

## Generate fake data ----

# Dataset with 5 variables:
## school = categorical variable, 5 different schools
## year = 2011-2020
## avg_income = average income for that school district in $, constant over time but varies across schools
## class_size = varies according to avg_income, plus some random error
## test_score = test scores out of 100, increasing with avg_income and decreasing with class_size


# 5 different schools
school <- paste0("School ", rep(1:5, each = 10))

# observations of 10 years for each school
year <- rep(2011:2020, 5)

# omitted variable = average household income
# varies across schools but is constant over time
avg_income <- rep(c(40000, 35000, 100000, 55000, 75000),
                  each = 10)

# create tibble
df <- cbind(school, year, avg_income) %>% as_tibble()
df <- df %>% mutate(avg_income = as.numeric(avg_income))

df <-
  df %>% mutate(class_size = round(800000 / avg_income + runif(50, -3, 10), 0))


df <-
  df %>% mutate(
    test_score = 0.001 * avg_income - 0.5 * class_size + runif(50, -10, 10),
    test_score = case_when(test_score > 100 ~ 100,
                           TRUE ~ test_score)
  )

df

## Fixed effects ----

fit1 <- lm(test_score ~ class_size, data = df)
fit2 <- lm(test_score ~ class_size + school, data = df)

p1 <- augment(fit1, df) %>%
  ggplot(aes(x = class_size)) +
  geom_point(aes(y = test_score)) +
  ylim(0, 100) +
  xlim(0, 40) +
  labs(x = "Class size",
       y = "Average test score",
       title = "Do smaller class sizes improve test scores?")
p1

p2 <- p1 + geom_line(aes(y = .fitted)) +
  annotate("text", x= 30, y = 75,
           label = "Slope: -3.4")


p3 <- augment(fit2, df) %>%
  ggplot(aes(x = class_size,
             group = school,
             color = school)) +
  geom_point(aes(y = test_score)) +
  ylim(0, 100) +
  xlim(0, 40) +
  labs(x = "Class size",
       y = "Average test score",
       title = "Do smaller class sizes improve test scores?", color = "")

p3

p4 <- p3 +
  geom_line(aes(y = .fitted)) +
  annotate("text", x= 30, y = 75,
           label = "Slope: -0.6")

ggsave(filename = "RS9/fe1.png", p1, width = 7, height = 5)
ggsave(filename = "RS9/fe2.png", p2, width = 7, height = 5)
ggsave(filename = "RS9/fe3.png", p3, width = 7, height = 5)
ggsave(filename = "RS9/fe4.png", p4, width = 7, height = 5)
