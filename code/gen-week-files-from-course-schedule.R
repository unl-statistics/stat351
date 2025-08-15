library(dplyr)
library(readxl)
library(purrr)
library(stringr)
library(glue)
library(yaml)

plan <- read_yaml("schedule.yaml")

plandf <- plan$schedule |> purrr::map_dfr(~ as_tibble(.))
plan_bits <- c(
  Week = "# Week {id}:",
  Date_First_Class = "",
  Title = " {Title}

",
  Reading = "## 📖 Reading

  {reading}

",
  Prepare = "## 🥣 Prepare for class

{prepare}

",
  Class1 = "## :taco: Tuesday
{class1}

",
  Class2 = "## :hammer::lightning: Thursday

{class2}

",
  Assignments = "##  🏋️ Practice your skills

{assignments}

"
)

templates <- purrr::map(
  split(plandf, 1:length(plan$schedule)),
  ~ paste(plan_bits[names(.)[!is.na(.)]], collapse = "")
)


md <- map2_chr(
  split(plandf, 1:nrow(plandf)),
  templates, glue_data
)

md <- set_names(md, sprintf("weeks/week-%02d.qmd", plandf$week))

walk2(md, names(md), ~ writeLines(.x, con = .y))
