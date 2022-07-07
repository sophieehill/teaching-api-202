

# 5 different schools
school <- paste0("School ", rep(1:2, each = 10))

# observations of 10 years for each school
year <- rep(2011:2020, 2)

treated <- case_when(school == "School 1" ~ 0,
                     school == "School 2" ~ 1,)

post <- case_when(year > 2014 ~ 1,
                  TRUE ~ 0)
# create tibble
df <- tibble(school, year, treated, post)


df <-
  df %>% mutate(
    test_score = -10040 + 15 * treated + 5 * year + 20 * treated * post,
    test_score = case_when(test_score > 100 ~ 100,
                           TRUE ~ test_score)
  )

df


lm(test_score ~ treated * post, data = df) %>% tidy()

p1 <- df %>%
  group_by(treated, year) %>%
  summarize(mean = mean(test_score)) %>%
  ggplot(aes(
    x = as.factor(year),
    y = mean,
    group = as.factor(treated),
    color = as.factor(treated)
  )) +
  ylim(0, 100) +
  geom_rect(xmin = "2014", xmax = Inf,
            ymin = -Inf, ymax = Inf,
            fill = "lightgrey",
            color = "lightgrey",
            alpha = 0.2) +
  geom_line() +
  labs(x = "Year",
       y = "Avg test score",
       title = "Difference-in-differences") +
  scale_color_manual(values = c("blue", "red")) +
  theme(legend.position = "none") +
 # geom_vline(xintercept = "2014", lty = "dotted") +
  annotate(
    "text",
    x = "2019",
    y = 98,
    label = "Treated\nunits",
    color = "red"
  ) +
  annotate(
    "text",
    x = "2019",
    y = 48,
    label = "Control\nunits",
    color = "blue"
  ) +
  annotate(
    "text",
    x = "2013",
    y = 0,
    label = "Before treatment",
    hjust = 0.8,
    color = "black"
  ) +
  annotate(
    "text",
    x = "2015",
    y = 0,
    label = "After treatment",
    hjust = 0.2,
    color = "black"
  )
p1

p2 <- p1 + geom_segment(
  x = "2013",
  xend = "2013",
  y = 25,
  yend = 40,
  color = "black",
  arrow = arrow(
    ends = "both",
    type = "closed",
    length = unit(0.1, "inches")
  )
) +
  geom_segment(
    x = "2016",
    xend = "2016",
    y = 40,
    color = "black",
    yend = 75,
    arrow = arrow(
      ends = "both",
      type = "closed",
      length = unit(0.1, "inches")
    )
  ) + annotate(
    "text",
    x = "2016",
    y = 67,
    label = "Observed\ndiff (post)",
    hjust = -0.2
    ) +
  annotate(
    "text",
    x = "2013",
    y = 48,
    label = "Observed\ndiff (pre)"
    )
p2

p3 <- p2 +
  geom_segment(
    x = "2014",
    xend = "2020",
    y = 45,
    yend = 75,
    lty = "dashed"
  ) +
  geom_segment(
    x = "2019",
    xend = "2019",
    y = 70,
    yend = 90,
    color = "black",
    arrow = arrow(
      ends = "both",
      type = "closed",
      length = unit(0.1, "inches")
    )
  )  +
  annotate(
    "text",
    x = "2019",
    y = 82,
    label = "Treatment\n   effect",
    color = "black",
    hjust = -0.2
  )
p3

p4 <- p2 +
  geom_segment(
    x = "2014",
    xend = "2020",
    y = 45,
    yend = 83,
    lty = "dashed"
  ) +
  geom_segment(
    x = "2019",
    xend = "2019",
    y = 77,
    yend = 90,
    color = "black",
    arrow = arrow(
      ends = "both",
      type = "closed",
      length = unit(0.1, "inches")
    )
  )  +
  annotate(
    "text",
    x = "2019",
    y = 82,
    label = "Treatment\n   effect",
    color = "black",
    hjust = -0.2
  )
p4


ggsave(filename = "RS9/p1.png", p1, width = 7, height = 5)
ggsave(filename = "RS9/p2.png", p2, width = 7, height = 5)
ggsave(filename = "RS9/p3.png", p3, width = 7, height = 5)
ggsave(filename = "RS9/p4.png", p4, width = 7, height = 5)

