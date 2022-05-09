library(tidyverse); library(lubridate) 

# read data
week <- read_csv("week.csv")
store <- read_csv("store.csv")

wcer <- read_csv("wcer_cereal.csv", col_types = "dc")
upccer <- read_csv("upccer_cereal.csv", col_types = "dc")

# clean data
wcer %>% filter(OK != 0) -> wcer	
wcer %>% mutate(SALE = MOVE * PRICE / QTY) -> wcer
wcer %>% select(STORE, UPC, WEEK, PRICE, MOVE, SALE, PROFIT) -> wcer

# merge data
wcer_week <- merge(x = wcer, y = week, by="WEEK", all.x = TRUE)
wcer_week %>% 
  mutate(date = ymd( paste(year, month, day, sep="-"))) -> wcer_week

# prepare data for figures
wcer_week %>% filter(UPC %in% c(1600066590,4300011240) & STORE == 93) -> plot_data

plot(PRICE ~ date, data=plot_data, col=factor(UPC), pch = 16, cex = 2.5)

plot <- ggplot(plot_data, aes(x = date, y = PRICE)) +
  geom_line(aes(colour = UPC), size = 8) + 
  xlab("") 
show(plot)
