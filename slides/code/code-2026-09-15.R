library(jsonlite)
tree <- read_json("/Users/hofmann/Documents/Teaching/Stat 585/Spring 2023/materials-2023/03_data-structures/tree.json")
tree

# code for the homework

# deciding on a package to read
library(jsonlite)
library(dplyr)
library(purrr)

drwho2023 <- read_json("drwho-72724.json")
drwho2005 <- read_json("drwho-210.json")
drwho1963 <- read_json("drwho-766.json")


# some investigation
str(drwho2023, max.level = 1)
str(drwho2023[1], max.level = 1)
str(drwho2023[1], max.level = 2)

# getting an episode summary
drwho2023[[1]]$summary
drwho2023[[2]]$summary

#drwho2023 |> purrr::pluck("summary")
#drwho2023[1] |> purrr::pluck("summary")
#drwho2023[[1]] |> purrr::pluck("summary")
# getting all episode summaries as a list
drwho2023 |> map(.f = function(x) x$summary)

# getting all episode summaries as a vector
drwho2023 |> map_chr(.f = function(x) x$summary)

# getting the season information as a list
drwho2023 |> map(.f = function(x) x$season)
# getting the episode summary only for the second season (and NULL for the first season)
drwho2023 |> map(.f = function(x) { if (x$season == 2) x$summary })

# making a list of the second season
season2 <- drwho2023 |> keep(.p = function(x) x$season == 2)
# getting the episode summary only for the second season - without the NULLs
season2 |> map(.f = function(x) x$summary)

