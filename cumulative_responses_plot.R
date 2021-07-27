library(tidyverse)
library(lubridate)
library(scales)

d <- read.csv("data/Qualtrics_downloaded_20210726.csv")
d <- d[3:nrow(d),]

cumsums <- d %>% 
  mutate(RecordedDate=mdy_hm(RecordedDate)) %>% 
  group_by(RecordedDate) %>% 
  summarise(Count=n()) %>% 
  mutate(CumCount=cumsum(Count))

emails <- data.frame(
  SentDate = c("7/2/2021 09:26", "7/9/2021 09:00", "7/16/2021 09:15",
           "7/22/2021 08:00", "7/23/2021 09:15"),
  Label = c("Initial email", "1st reminder", "2nd reminder",
            "3rd reminder", "Last reminder")
) %>% mutate(SentDate=mdy_hm(SentDate))

cumsums %>% ggplot(aes(x=RecordedDate, y=CumCount)) +
  geom_line() +
  geom_vline(aes(xintercept=SentDate), data=emails, linetype="dashed", color="black") +
  theme_bw() +
  #scale_x_datetime(breaks = pretty_breaks(8)) +
  scale_x_datetime(breaks = mdy_hm(c("7/2/2021 00:00", "7/9/2021 00:00", "7/16/2021 00:00",
                                          "7/23/2021 00:00")),
                   labels = date_format("%B %d, %Y")) +
  labs(x="Date",
       y="Cumulative Survey Responses",
       title="Cumulative Survey Responses over Experimental Period")
