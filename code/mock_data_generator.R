# mock data generator
# similar to that supplied by HIRMEOS
# but includes titles & publishers (taken from JSTOR OA catalogue)

library(dplyr)
library(readxl)
library(wakefield)
library(lubridate)

set.seed(1001)

jstor <- read_excel("~/Dropbox/projects/github_projects/CCAT/JSTOR/data/JSTOR-OpenAccess-Export-20170731[2].xlsx") %>% 
  select(Publisher, Title, URI = DOI) %>% 
  mutate(URI = paste0("info:", URI))

measures <- read_csv("~/Dropbox/projects/github_projects/hirmeos_dashboard/data/measures.csv")

countries <- read_csv("~/Dropbox/projects/github_projects/hirmeos_dashboard/data/iso3166-2.csv") %>% 
  mutate(Country = paste0("urn:iso:std:3166:-2:", Code))

mock_data <- tibble(Measure = sample(measures$Measure, 20000, replace = TRUE),
                    Timestamp = date_stamp(20000, x = seq(as.Date("2018-01-01"), length.out = 365, by = "1 day")) %>% paste("00:00:00"),
                    Country = sample(countries$Country, 20000, replace = TRUE),
                    Value = sample(1:100, 20000, replace = TRUE)) %>% 
  bind_cols(sample_n(jstor, 20000, replace = TRUE)) %>% 
  select(Measure, Timestamp, URI, Country, Value, Publisher, Title)

mock_data %>% 
  write_csv("Dropbox/projects/github_projects/hirmeos_dashboard/data/mock_data.csv")

