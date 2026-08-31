library(xml2)
library(rvest)
library(purrr)
library(dplyr)
library(tibble)

url<-"https://en.wikipedia.org/wiki/List_of_mathematicians_born_in_the_19th_century"

doc <- read_html(url)
doc

doc |> html_elements(css = "li")

doc |> html_elements(css = "#mwCg")

doc |> html_elements(css = ".mw-body p")
doc |> html_elements(css = "#mw-content-text li")
doc |> html_elements(css = ".mw-body-content li") |> str()

ppl <- doc |> html_elements(css = "#mw-content-text li")
flo <- ppl[[1]]

extract_title_link <- function(list_item) {
  content <- html_text(list_item)
  name <- list_item |> html_children() |> html_text()
  link <- list_item |> html_children() |> html_attr(name="href")
  bdate <- list_item |> html_children() |> html_attr(name="bdate")
  tibble(content, name, link)
}

extract_title_link(ppl[[1]])

ppl |> map(~extract_title_link(.))
ppl |> map_dfr(.f = extract_title_link)

ppl |> map(.f = extract_title_link) |> list_rbind() |> filter(!is.na(link))

# delete duplicate names:
ppl_plus <- ppl |> map(.f = extract_title_link) |> list_rbind() |>
  group_by(content) |>
  mutate(n = n()) |>
  arrange(desc(n))
