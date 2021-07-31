library(tidyverse)

setwd("/data")

# Get list of emails that are definitely NOT attriters
our_emails = c("mirza2020@berkeley.edu", "deveshkhandelwal@berkeley.edu",
               "rahosbach@berkeley.edu", "tgao2020@berkeley.edu",
               "tgao2020@berkely.edu")
responded_emails = read.csv("survey_response_emails.csv")
ignore_emails = c(our_emails, responded_emails$Email)

# Read in all 5 rounds of emails
d11 <- read.csv("round1_0702_group1_0702_0941.csv") %>%
  select(Email, Merge1 = Merge.status)
d21 <- read.csv("round1_0702_group2_0702_1028.csv") %>%
  select(Email, Merge1 = Merge.status)
d31 <- read.csv("round1_0702_group3_0702_1055.csv") %>%
  select(Email, Merge1 = Merge.status)
round1 <- rbind(d11, d21, d31) %>%
  filter(!Email %in% ignore_emails)

attriters <- round1 %>% 
  filter(Merge1 == "BOUNCED") %>% 
  select(Email)


# We agreed to count attriters as those who bounced from round 1.
# Further analyses with the other 4 rounds are below
# round2 <- read.csv("round2_0709_all_0716_1117.csv") %>%
#   select(Email, Merge2 = Merge.status) %>% 
#   filter(!Email %in% ignore_emails)
# round3 <- read.csv("round3_0716_all_0722_1046.csv") %>%
#   select(Email, Merge3 = Merge.status) %>% 
#   filter(!Email %in% ignore_emails)
# round4 <- read.csv("round4_0722_all_0723_1131.csv") %>%
#   select(Email, Merge4 = Merge.status) %>% 
#   filter(!Email %in% ignore_emails)
# round5 <- read.csv("round5_0723_all_0724_1219.csv") %>%
#   select(Email, Merge5 = Merge.status) %>% 
#   filter(!Email %in% ignore_emails)
# 
# # Join the email rounds together
# joined <- left_join(round1, round2) %>%
#   left_join(round3) %>%
#   left_join(round4) %>%
#   left_join(round5)
# 
# # Table of counts
# joined %>%
#   gather(Round, Status, -Email) %>%
#   select(Round, Status) %>%
#   table()
# 
# # There are two people that show email_sent in the 1st round and
# # email bounced in the 2nd round; 35 people vice-versa
# joined %>% 
#   filter(Merge1 != "BOUNCED" & Merge2 == "BOUNCED")
# joined %>%
#   filter(Merge1 == "BOUNCED" & Merge2 != "BOUNCED")
# 
# # Number of people who ever bounced
# joined %>% 
#   filter(Merge1 == "BOUNCED" | Merge2 == "BOUNCED" | Merge3 == "BOUNCED" |
#            Merge4 == "BOUNCED" | Merge5 == "BOUNCED") %>%
#   nrow()
