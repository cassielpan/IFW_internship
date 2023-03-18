library(dplyr)
library(readxl)
library(countrycode)
library(openxlsx)
library(tidyverse)
library(tibble)
library(reshape2)

#########merge bridata and africa visits data###############
bri <- read.csv("bri_countries.csv")
africa_visit <- read_xlsx("china_visits_africa.xlsx")

merge_data <- full_join(africa_visit, bri, by = "country")
# save data to csv file
write.csv(merge_data, "china_visits_africa_merge.csv", row.names = FALSE)

###############add continent to dataset##################
data_6 <- read_xlsx("datasets_merging/6_ChinesePublicDiplomacy.xlsx")

data_6$continent <- countrycode(sourcevar = data_6$receiving_country,
                            origin = "country.name",
                            destination = "continent")
write.xlsx(data_6, "datasets_merging/6_ChinesePublicDiplomacy.xlsx", rowNames = FALSE)


data_7 <- read_xlsx("datasets_merging/7_Confucius-Institutes.xlsx")

data_7$continent <- countrycode(sourcevar = data_7$country,
                                origin = "country.name",
                                destination = "continent")
write.xlsx(data_7, "datasets_merging/7_Confucius-Institutes.xlsx", rowNames = FALSE)


data_8 <- read.csv("datasets_merging/8_foreign_leader_visits_toUSA.csv")

data_8$continent <- countrycode(sourcevar = data_8$country_clean,
                                origin = "country.name",
                                destination = "continent")
write.xlsx(data_8, "datasets_merging/8_foreign_leader_visits_toUSA.xlsx", rowNames = FALSE)


data_9 <- read.csv("datasets_merging/9_president_travels_toWorld.csv")

data_9$continent <- countrycode(sourcevar = data_9$country_clean,
                                origin = "country.name",
                                destination = "continent")
write.xlsx(data_9, "datasets_merging/9_president_travels_toWorld.xlsx", rowNames = FALSE)


data_10 <- read_xlsx("datasets_merging/10_us_foreignaid_greenbook.xlsx")

data_10$continent <- countrycode(sourcevar = data_10$Country,
                                origin = "country.name",
                                destination = "continent")
write.xlsx(data_10, "datasets_merging/10_us_foreignaid_greenbook.xlsx", rowNames = FALSE)

############merge multiple dataset into one big file one by one##################
######import all data########
file1.1 <- read_xlsx("1.1_global_cdf.xlsx")
file1.2 <- read_xlsx("1.2_military.xlsx")
file2.1 <- read_xlsx("2.1_CN_EXtoAfr.xlsx")
file2.2 <- read_xlsx("2.2_CN_IMfromAfr.xlsx")
file2.3 <- read_xlsx("2.3_US_EXtoAfr.xlsx")
file2.4 <- read_xlsx("2.4_US_IMfromAfr.xlsx")
file3 <- read.csv("3_china_visits_africa_merge.csv")
file4 <- read_xlsx("4_CN_Africa_fdi_flow.xlsx")
file5 <- read_xlsx("5_ChineseFinancialPublicDiplomacyProjectDetails.xlsx")
file6<- read_xlsx("6_ChinesePublicDiplomacy.xlsx")
file7 <- read_xlsx("7_Confucius-Institutes.xlsx")
file8 <- read_xlsx("8_Afr_visits_toUSA.xlsx")
file9 <- read_xlsx("9_president_travels_toAfr.xlsx")
file10.1 <- read_xlsx("10.1_us_aid_toAfr_eco.xlsx")
file10.2 <- read_xlsx("10.2_us_aid_toAfr_mili.xlsx")

######convert some data########
file2.1 <- file2.1 %>% remove_rownames %>% column_to_rownames(var="...1") 
file2.1_t <- as.data.frame(t(file2.1))
file2.1_t <- tibble::rownames_to_column(file2.1_t, "country")
file2.1_t <- melt(file2.1_t, id.vars=c("country"))
names(file2.1_t)[names(file2.1_t) == "variable"] <- "year"

file2.2 <- file2.2 %>% remove_rownames %>% column_to_rownames(var="...1") 
file2.2_t <- as.data.frame(t(file2.2))
file2.2_t <- tibble::rownames_to_column(file2.2_t, "country")
file2.2_t <- melt(file2.2_t, id.vars=c("country"))
names(file2.2_t)[names(file2.2_t) == "variable"] <- "year"

file2.3 <- file2.3 %>% remove_rownames %>% column_to_rownames(var="...1") 
file2.3_t <- as.data.frame(t(file2.3))
file2.3_t <- tibble::rownames_to_column(file2.3_t, "country")
file2.3_t <- melt(file2.3_t, id.vars=c("country"))
names(file2.3_t)[names(file2.3_t) == "variable"] <- "year"

file2.4 <- file2.4 %>% remove_rownames %>% column_to_rownames(var="...1") 
file2.4_t <- as.data.frame(t(file2.4))
file2.4_t <- tibble::rownames_to_column(file2.4_t, "country")
file2.4_t <- melt(file2.4_t, id.vars=c("country"))
names(file2.4_t)[names(file2.4_t) == "variable"] <- "year"

file4 <- file4 %>% remove_rownames %>% column_to_rownames(var="...1") 
file4_t <- as.data.frame(t(file4))
file4_t <- tibble::rownames_to_column(file4_t, "country")
file4_t <- melt(file4_t, id.vars=c("country"))
names(file4_t)[names(file4_t) == "variable"] <- "year"

######separate date in file9########
file9[c('start_year','start_month', 'start_day')] <- str_split_fixed(file9$start_date, '-', 3)


######make negative value to pisitive and aggregate file 10.1&10.2########
##replace 1976.9 with 1976##
file10.1$`Fiscal Year`[file10.1$`Fiscal Year` == '1976.9'] <- '1976'
file10.2$`Fiscal Year`[file10.2$`Fiscal Year` == '1976.9'] <- '1976'

file10.1$`Obligations (Historical Dollars)` <- abs(file10.1$`Obligations (Historical Dollars)`)
file10.1$`Obligations (Constant Dollars)` <- abs(file10.1$`Obligations (Constant Dollars)`)
file10.1$`Fiscal Year` <- round(as.numeric(file10.1$`Fiscal Year`), digits = 0)
file10.1 <- file10.1 %>%
  group_by(`Fiscal Year`, Country) %>% 
  summarise(sum_historical_dollars=sum(`Obligations (Historical Dollars)`),
            sum_constant_dollars= sum(`Obligations (Constant Dollars)`),
            total_count_aid=n(),
            .groups = 'drop') %>%
  as.data.frame()


file10.2$`Obligations (Historical Dollars)` <- abs(file10.2$`Obligations (Historical Dollars)`)
file10.2$`Obligations (Constant Dollars)` <- abs(file10.2$`Obligations (Constant Dollars)`)
file10.2$`Fiscal Year` <- round(as.numeric(file10.2$`Fiscal Year`), digits = 0)
file10.2 <- file10.2 %>%
  group_by(`Fiscal Year`, Country) %>% 
  summarise(sum_historical_dollars=sum(`Obligations (Historical Dollars)`),
            sum_constant_dollars= sum(`Obligations (Constant Dollars)`),
            total_count_aid=n(),
            .groups = 'drop') %>%
  as.data.frame()

######merge file1.1 and file5 and aggregate########
names(file1.1)[names(file1.1) == 'AidData TUFF Project ID'] <- 'project_id'
names(file1.1)[names(file1.1) == 'Recipient'] <- 'recipient'
names(file1.1)[names(file1.1) == 'Commitment Year'] <- 'commitment_year'
names(file1.1)[names(file1.1) == 'Amount (Constant USD2017)'] <-'amount_constant_usd2017'
file1.1n5 <- merge(file1.1, file5, all = TRUE)
file1.1n5 <- file1.1n5 %>%
  group_by(recipient, commitment_year) %>% 
  summarise(sum_constant_usd2017=sum(amount_constant_usd2017 ),
            sum_nominal= sum(amount_nominal),
            total_count_project=n(),
            .groups = 'drop') %>%
  as.data.frame()

######aggregate file1.2########
file1.2 <- file1.2 %>%
  group_by(`Recipient`, `Commitment Year`) %>% 
  summarise(sum_constant_usd2017=sum(`Amount (Constant USD2017)` ),
            sum_nominal= sum(`Amount (Nominal)`),
            total_count_project=n(),
            .groups = 'drop') %>%
  as.data.frame()

######add prefix to each column for each data########
colnames(file1.1n5) <- paste("1.1n5", colnames(file1.1n5), sep = "_")
colnames(file1.2) <- paste("1.2", colnames(file1.2), sep = "_")
colnames(file2.1_t) <- paste("2.1", colnames(file2.1_t), sep = "_")
colnames(file2.2_t) <- paste("2.2", colnames(file2.2_t), sep = "_")
colnames(file2.3_t) <- paste("2.3", colnames(file2.3_t), sep = "_")
colnames(file2.4_t) <- paste("2.4", colnames(file2.4_t), sep = "_")
colnames(file3) <- paste("3", colnames(file3), sep = "_")
colnames(file4_t) <- paste("4", colnames(file4_t), sep = "_")
colnames(file6) <- paste("6", colnames(file6), sep = "_")
colnames(file7) <- paste("7", colnames(file7), sep = "_")
colnames(file8) <- paste("8", colnames(file8), sep = "_")
colnames(file9) <- paste("9", colnames(file9), sep = "_")
colnames(file10.1) <- paste("10.1", colnames(file10.1), sep = "_")
colnames(file10.2) <- paste("10.2", colnames(file10.2), sep = "_")

######get ISO3 for each data and replacate year in order to merge the data########
file1.1n5$ISO3 <- countrycode(sourcevar =file1.1n5$'1.1n5_recipient',
                              origin = "country.name", destination = "iso3c")
file1.1n5 <- file1.1n5[!file1.1n5$'1.1n5_recipient'=="Africa, regional",] # remove rows without specific contry name
file1.1n5$year_merge <- as.numeric(file1.1n5$`1.1n5_commitment_year`)
file1.1n5 <- file1.1n5 %>% 
  relocate(ISO3, .before="1.1n5_recipient") %>% ##set IOS3 to the first positio
  relocate(year_merge, .before="1.1n5_recipient")

file1.2$ISO3 <- countrycode(sourcevar =file1.2$'1.2_Recipient',
                            origin = "country.name", destination = "iso3c")
file1.2 <- file1.2[!file1.2$'1.2_Recipient'=="Africa, regional",]
file1.2$year_merge <- as.numeric(file1.2$`1.2_Commitment Year`)

file2.1_t$ISO3 <- countrycode(sourcevar =file2.1_t$'2.1_country',
                              origin = "country.name", destination = "iso3c")
file2.1_t$year_merge <- as.numeric(as.character(file2.1_t$`2.1_year`))

file2.2_t$ISO3 <- countrycode(sourcevar =file2.2_t$'2.2_country',
                              origin = "country.name", destination = "iso3c")
file2.2_t$year_merge <- as.numeric(as.character(file2.2_t$`2.2_year`))

file2.3_t$ISO3 <- countrycode(sourcevar =file2.3_t$'2.3_country',
                              origin = "country.name", destination = "iso3c")
file2.3_t$year_merge <- as.numeric(as.character(file2.3_t$`2.3_year`))


file2.4_t$ISO3 <- countrycode(sourcevar =file2.4_t$'2.4_country',
                              origin = "country.name", destination = "iso3c")
file2.4_t$year_merge <- as.numeric(as.character(file2.4_t$`2.4_year`))


file3$ISO3 <- countrycode(sourcevar =file3$'3_country',
                          origin = "country.name", destination = "iso3c")
file3$year_merge <- as.numeric(file3$`3_year`)

file4_t$ISO3 <- countrycode(sourcevar =file4_t$'4_country',
                            origin = "country.name", destination = "iso3c")
file4_t$year_merge <- as.numeric(as.character(file4_t$`4_year`))


file6$ISO3 <- countrycode(sourcevar =file6$'6_receiving_country',
                          origin = "country.name", destination = "iso3c")
file6$`6_year`[file6$`6_year` == "Date Not Available"] <- ""
file6$year_merge <- as.numeric(file6$`6_year`)

file7$ISO3 <- countrycode(sourcevar =file7$'7_country',
                          origin = "country.name", destination = "iso3c")
file7$year_merge <- as.numeric(file7$`7_year_opened`)

file8$ISO3 <- countrycode(sourcevar =file8$'8_country_clean',
                          origin = "country.name", destination = "iso3c")
file8$year_merge <- as.numeric(file8$`8_year`)

file9$ISO3 <- countrycode(sourcevar =file9$'9_country_clean',
                          origin = "country.name", destination = "iso3c")
file9$year_merge <- as.numeric(file9$`9_start_year`)

file10.1$ISO3 <- countrycode(sourcevar =file10.1$'10.1_Country',
                             origin = "country.name", destination = "iso3c")
file10.1$year_merge <- file10.1$`10.1_Fiscal Year`

file10.2$ISO3 <- countrycode(sourcevar =file10.2$'10.2_Country',
                             origin = "country.name", destination = "iso3c")
file10.2$year_merge <- file10.2$`10.2_Fiscal Year`

######get ISO3 for each data in order to merge the data########
list_df = list(file1.1n5, file1.2,file2.1_t, file2.2_t, file2.3_t, file2.4_t,
               file3, file4_t, file6, file7, file8, file9, file10.1,file10.2)
data_merged <- list_df %>% 
  reduce(full_join, by=c('ISO3', 'year_merge'))

######reshape the data to get whole time period for each country########
c1 <- rep("AGO", 31)
y1 <- c(1946:1976)
data_merged <- add_row(data_merged, ISO3 = c1, year_merge = y1)

c2 <- rep("BDI", 15)
y2 <- c(1946:1960)
data_merged <- add_row(data_merged, ISO3 = c2, year_merge = y2)

c3 <- rep("BEN", 13)
y3 <- c(1946:1958)
data_merged <- add_row(data_merged, ISO3 = c3, year_merge = y3)

c4 <- rep("BFA", 15)
y4 <- c(1946:1960)
data_merged <- add_row(data_merged, ISO3 = c4, year_merge = y4)

c5 <- rep("BWA", 19)
y5 <- c(1946:1964)
data_merged <- add_row(data_merged, ISO3 = c5, year_merge = y5)

c6 <- rep("CAF", 15)
y6 <- c(1946:1960)
data_merged <- add_row(data_merged, ISO3 = c6, year_merge = y6)

c7 <- rep("CIV", 15)
y7 <- c(1946:1960)
data_merged <- add_row(data_merged, ISO3 = c7, year_merge = y7)

c8 <- rep("CMR", 14)
y8 <- c(1946:1959)
data_merged <- add_row(data_merged, ISO3 = c8, year_merge = y8)

c9 <- rep("COD", 6)
y9 <- c(1946:1951)
data_merged <- add_row(data_merged, ISO3 = c9, year_merge = y9)

c10 <- rep("COG", 15)
y10 <- c(1946:1960)
data_merged <- add_row(data_merged, ISO3 = c10, year_merge = y10)

c11 <- rep("COM", 34)
y11 <- c(1946:1979)
data_merged <- add_row(data_merged, ISO3 = c11, year_merge = y11)

c12 <- rep("CPV", 29)
y12 <- c(1946:1974)
data_merged <- add_row(data_merged, ISO3 = c12, year_merge = y12)

c13 <- rep("DJI", 31)
y13 <- c(1946:1976)
data_merged <- add_row(data_merged, ISO3 = c13, year_merge = y13)

c14 <- rep("DZA", 10)
y14 <- c(1946:1955)
data_merged <- add_row(data_merged, ISO3 = c14, year_merge = y14)

c15 <- rep("ERI", 46)
y15 <- c(1946:1991)
data_merged <- add_row(data_merged, ISO3 = c15, year_merge = y15)

c16 <- rep("ESH", 58)
y16 <- c(1946:2002, 2021)
data_merged <- add_row(data_merged, ISO3 = c16, year_merge = y16)

c17 <- rep("GAB", 14)
y17 <- c(1946:1959)
data_merged <- add_row(data_merged, ISO3 = c17, year_merge = y17)

c18 <- rep("GHA", 6)
y18 <- c(1946:1951)
data_merged <- add_row(data_merged, ISO3 = c18, year_merge = y18)

c19 <- rep("GIN", 13)
y19 <- c(1946:1958)
data_merged <- add_row(data_merged, ISO3 = c19, year_merge = y19)

c20 <- rep("GMB", 10)
y20 <- c(1946:1955)
data_merged <- add_row(data_merged, ISO3 = c20, year_merge = y20)

c21 <- rep("GNB", 29)
y21 <- c(1946:1974)
data_merged <- add_row(data_merged, ISO3 = c21, year_merge = y21)

c22 <- rep("GNQ", 35)
y22 <- c(1946:1980)
data_merged <- add_row(data_merged, ISO3 = c22, year_merge = y22)

c23 <- rep("KEN", 8)
y23 <- c(1946:1953)
data_merged <- add_row(data_merged, ISO3 = c23, year_merge = y23)

c24 <- rep("LBY", 5)
y24 <- c(1946:1950)
data_merged <- add_row(data_merged, ISO3 = c24, year_merge = y24)

c25 <- rep("LSO", 15)
y25 <- c(1946:1960)
data_merged <- add_row(data_merged, ISO3 = c25, year_merge = y25)

c26 <- rep("MAR", 6)
y26 <- c(1946:1951)
data_merged <- add_row(data_merged, ISO3 = c26, year_merge = y26)

c27 <- rep("MDG", 13)
y27 <- c(1946:1958)
data_merged <- add_row(data_merged, ISO3 = c27, year_merge = y27)

c28 <- rep("MLI", 15)
y28 <- c(1946:1960)
data_merged <- add_row(data_merged, ISO3 = c28, year_merge = y28)

c29 <- rep("MOZ", 30)
y29 <- c(1946:1975)
data_merged <- add_row(data_merged, ISO3 = c29, year_merge = y29)

c30 <- rep("MRT", 14)
y30 <- c(1946:1959)
data_merged <- add_row(data_merged, ISO3 = c30, year_merge = y30)

c31 <- rep("MUS", 12)
y31 <- c(1946:1957)
data_merged <- add_row(data_merged, ISO3 = c31, year_merge = y31)

c32 <- rep("MWI", 10)
y32 <- c(1946:1955)
data_merged <- add_row(data_merged, ISO3 = c32, year_merge = y32)

c33 <- rep("MYT", 76)
y33 <- c(1946:2021)
data_merged <- add_row(data_merged, ISO3 = c33, year_merge = y33)

c34 <- rep("NAM", 44)
y34 <- c(1946:1989)
data_merged <- add_row(data_merged, ISO3 = c34, year_merge = y34)

c35 <- rep("NER", 15)
y35 <- c(1946:1960)
data_merged <- add_row(data_merged, ISO3 = c35, year_merge = y35)

c36 <- rep("NGA", 6)
y36 <- c(1946:1951)
data_merged <- add_row(data_merged, ISO3 = c36, year_merge = y36)

c37 <- rep("REU", 76)
y37 <- c(1946:2021)
data_merged <- add_row(data_merged, ISO3 = c37, year_merge = y37)

c38 <- rep("RWA", 16)
y38 <- c(1946:1961)
data_merged <- add_row(data_merged, ISO3 = c38, year_merge = y38)

c39 <- rep("SDN", 10)
y39 <- c(1946:1955)
data_merged <- add_row(data_merged, ISO3 = c39, year_merge = y39)

c40 <- rep("SEN", 15)
y40 <- c(1946:1960)
data_merged <- add_row(data_merged, ISO3 = c40, year_merge = y40)

c41 <- rep("SLE", 6)
y41 <- c(1946:1951)
data_merged <- add_row(data_merged, ISO3 = c41, year_merge = y41)

c42 <- rep("SOM", 8)
y42 <- c(1946:1953)
data_merged <- add_row(data_merged, ISO3 = c42, year_merge = y42)

c43 <- rep("SSD", 46)
y43 <- c(1946:1991)
data_merged <- add_row(data_merged, ISO3 = c43, year_merge = y43)

c44 <- rep("STP", 31)
y44 <- c(1946:1976)
data_merged <- add_row(data_merged, ISO3 = c44, year_merge = y44)

c45 <- rep("SWZ", 15)
y45 <- c(1946:1960)
data_merged <- add_row(data_merged, ISO3 = c45, year_merge = y45)

c46 <- rep("SYC", 15)
y46 <- c(1946:1960)
data_merged <- add_row(data_merged, ISO3 = c46, year_merge = y46)

c47 <- rep("TCD", 15)
y47 <- c(1946:1960)
data_merged <- add_row(data_merged, ISO3 = c47, year_merge = y47)

c48 <- rep("TGO", 13)
y48 <- c(1946:1958)
data_merged <- add_row(data_merged, ISO3 = c48, year_merge = y48)

c49 <- rep("TUN", 6)
y49 <- c(1946:1951)
data_merged <- add_row(data_merged, ISO3 = c49, year_merge = y49)

c50 <- rep("TZA", 12)
y50 <- c(1946:1957)
data_merged <- add_row(data_merged, ISO3 = c50, year_merge = y50)

c51 <- rep("UGA", 8)
y51 <- c(1946:1953)
data_merged <- add_row(data_merged, ISO3 = c51, year_merge = y51)

c52 <- rep("ZMB", 7)
y52 <- c(1946:1952)
data_merged <- add_row(data_merged, ISO3 = c52, year_merge = y52)

c53 <- rep("ZWE", 8)
y53 <- c(1946:1953)
data_merged <- add_row(data_merged, ISO3 = c53, year_merge = y53)


######create a basic panel dataframe########
y1 <- c(1946:2021)
c1 <- rep("AGO", 76)
c2 <- rep("BDI", 76)
c3 <- rep("BEN", 76)
c4 <- rep("BFA", 76)
c5 <- rep("BWA", 76)
c6 <- rep("CAF", 76)
c7 <- rep("CIV", 76)
c8 <- rep("CMR", 76)
c9 <- rep("COD", 76)
c10 <- rep("COG", 76)
c11 <- rep("COM", 76)
c12 <- rep("CPV", 76)
c13 <- rep("DJI", 76)
c14 <- rep("DZA", 76)
c15 <- rep("ERI", 76)
c16 <- rep("ESH", 76)
c17 <- rep("GAB", 76)
c18 <- rep("GHA", 76)
c19 <- rep("GIN", 76)
c20 <- rep("GMB", 76)
c21 <- rep("GNB", 76)
c22 <- rep("GNQ", 76)
c23 <- rep("KEN", 76)
c24 <- rep("LBY", 76)
c25 <- rep("LSO", 76)
c26 <- rep("MAR", 76)
c27 <- rep("MDG", 76)
c28 <- rep("MLI", 76)
c29 <- rep("MOZ", 76)
c30 <- rep("MRT", 76)
c31 <- rep("MUS", 76)
c32 <- rep("MWI", 76)
c33 <- rep("MYT", 76)
c34 <- rep("NAM", 76)
c35 <- rep("NER", 76)
c36 <- rep("NGA", 76)
c37 <- rep("REU", 76)
c38 <- rep("RWA", 76)
c39 <- rep("SDN", 76)
c40 <- rep("SEN", 76)
c41 <- rep("SLE", 76)
c42 <- rep("SOM", 76)
c43 <- rep("SSD", 76)
c44 <- rep("STP", 76)
c45 <- rep("SWZ", 76)
c46 <- rep("SYC", 76)
c47 <- rep("TCD", 76)
c48 <- rep("TGO", 76)
c49 <- rep("TUN", 76)
c50 <- rep("TZA", 76)
c51 <- rep("UGA", 76)
c52 <- rep("ZMB", 76)
c53 <- rep("ZWE", 76)
c54 <- rep("EGY", 76)
c55 <- rep("ETH", 76)
c56 <- rep("LBR", 76)
c57 <- rep("ZAF", 76)

df <- data.frame(c1,y1)
df <- add_row(df, c1 = c2, y1 = y1)
df <- add_row(df, c1 = c3, y1 = y1)
df <- add_row(df, c1 = c4, y1 = y1)
df <- add_row(df, c1 = c5, y1 = y1)
df <- add_row(df, c1 = c6, y1 = y1)
df <- add_row(df, c1 = c7, y1 = y1)
df <- add_row(df, c1 = c8, y1 = y1)
df <- add_row(df, c1 = c9, y1 = y1)
df <- add_row(df, c1 = c10, y1 = y1)
df <- add_row(df, c1 = c11, y1 = y1)
df <- add_row(df, c1 = c12, y1 = y1)
df <- add_row(df, c1 = c13, y1 = y1)
df <- add_row(df, c1 = c14, y1 = y1)
df <- add_row(df, c1 = c15, y1 = y1)
df <- add_row(df, c1 = c16, y1 = y1)
df <- add_row(df, c1 = c17, y1 = y1)
df <- add_row(df, c1 = c18, y1 = y1)
df <- add_row(df, c1 = c19, y1 = y1)
df <- add_row(df, c1 = c20, y1 = y1)
df <- add_row(df, c1 = c21, y1 = y1)
df <- add_row(df, c1 = c22, y1 = y1)
df <- add_row(df, c1 = c23, y1 = y1)
df <- add_row(df, c1 = c24, y1 = y1)
df <- add_row(df, c1 = c25, y1 = y1)
df <- add_row(df, c1 = c26, y1 = y1)
df <- add_row(df, c1 = c27, y1 = y1)
df <- add_row(df, c1 = c28, y1 = y1)
df <- add_row(df, c1 = c29, y1 = y1)
df <- add_row(df, c1 = c30, y1 = y1)
df <- add_row(df, c1 = c31, y1 = y1)
df <- add_row(df, c1 = c32, y1 = y1)
df <- add_row(df, c1 = c33, y1 = y1)
df <- add_row(df, c1 = c34, y1 = y1)
df <- add_row(df, c1 = c35, y1 = y1)
df <- add_row(df, c1 = c36, y1 = y1)
df <- add_row(df, c1 = c37, y1 = y1)
df <- add_row(df, c1 = c38, y1 = y1)
df <- add_row(df, c1 = c39, y1 = y1)
df <- add_row(df, c1 = c40, y1 = y1)
df <- add_row(df, c1 = c41, y1 = y1)
df <- add_row(df, c1 = c42, y1 = y1)
df <- add_row(df, c1 = c43, y1 = y1)
df <- add_row(df, c1 = c44, y1 = y1)
df <- add_row(df, c1 = c45, y1 = y1)
df <- add_row(df, c1 = c46, y1 = y1)
df <- add_row(df, c1 = c47, y1 = y1)
df <- add_row(df, c1 = c48, y1 = y1)
df <- add_row(df, c1 = c49, y1 = y1)
df <- add_row(df, c1 = c50, y1 = y1)
df <- add_row(df, c1 = c51, y1 = y1)
df <- add_row(df, c1 = c52, y1 = y1)
df <- add_row(df, c1 = c53, y1 = y1)
df <- add_row(df, c1 = c54, y1 = y1)
df <- add_row(df, c1 = c55, y1 = y1)
df <- add_row(df, c1 = c56, y1 = y1)
df <- add_row(df, c1 = c57, y1 = y1)
names(df)[names(df) == 'c1'] <- 'ISO3'
names(df)[names(df) == 'y1'] <- 'year_merge'


######save data########
data_merged$Country <- countrycode(sourcevar =data_merged$ISO3,
                                   origin = "iso3c", destination = "country.name")
data_merged <- data_merged %>% 
  relocate(Country, .before="year_merge") 
#sort data
data_merged_order <- data_merged %>% arrange(ISO3, year_merge)
#data_merged <- data_merged[!is.na(data_merged$year_merge),]

write.csv(data_merged_order, "data_merged.csv", row.names = FALSE)
write.xlsx(data_merged_order, "data_merged.xlsx", rowNames = FALSE)

