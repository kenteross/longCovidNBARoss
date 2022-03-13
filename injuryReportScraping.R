# Estimating the impact of COVID-19 on NBA point production ----


# load libraries ----
library(tidyverse)
library(rvest)
library(igraph)
library(lfe)
library(kableExtra)
library(nbastatR)
library(dummies)
library(MatchIt)
library(quantreg)


# clean environment
rm(list = ls())
dev.off()

# Uncomment following section to scrape data
## Generating dataframe COVID-19 incidents----
# Empty dataframe to fill
NBACovidTable <- data.frame()

### Get player injuries from injury reports ----
for (i in seq.int(from = 0, to = 2825, by = 25)) {
  # Web URL for NBA injury stats
  ## Pastes the page number into the webpage to iterate through the pages
  NBACovidLink = paste0('https://www.prosportstransactions.com/basketball/Search/SearchResults.php?Player=&Team=&BeginDate=2020-08-01&EndDate=2021-05-25&ILChkBx=yes&InjuriesChkBx=yes&Submit=Search&start=', i)

  # Reads the html link
  NBACovidPage = read_html(NBACovidLink)

  # Generating table
  ## To get table name, right click table then click inspect, then right click the table html code and copy selector
  covidTemp = NBACovidPage %>%
    # pulls table from the webpage
    html_nodes('body > div.container > table.datatable.center') %>%
    # Pulls the table from the list generated (pulls the first element of the list)
    html_table() %>% .[[1]]

  # Make the first row the column name then remove it
  colnames(covidTemp) = covidTemp[1,]
  covidTemp = covidTemp[-1,]

  # adds to full dataframe
  NBACovidTable <- rbind(covidTemp, NBACovidTable)
}

# Removing everything except for the main injury table
rm(list=setdiff(ls(), c("NBACovidTable")))


write.csv(NBACovidTable, file = "data/NBACovidTable.csv", row.names = F)