library(data.table)
library(stargazer)
library(sandwich)
library(lmtest)

d <- fread("data/Alumni Scrape_DK_join_final_data_no_bounce.csv")
d <- d[, !c("name", "firstname", "cohort", "email", "blocking_year_assignments", "Response_Default")]
d <- d[index >= 0]
d[ , group := ifelse(
  blocking_genderyear_assignments == 1, "Direct",
  ifelse(blocking_genderyear_assignments == 2, "Philanthropic", "Control"))]
d$blocking_genderyear_assignments <- NULL
d$group <- factor(d$group, levels=c("Control", "Direct", "Philanthropic"))
d$year_graduation <- factor(d$year_graduation, levels=c("2015", "2016", "2017", "2018", "2019", "2020", "2021"))
d[is.na(d)] <- 0

m1 <- d[ , lm(Y ~ group)]
m2 <- d[ , lm(Y ~ group + gender + year_graduation)]

rse1 <- sqrt(diag(vcovHC(m1)))
rse2 <- sqrt(diag(vcovHC(m2)))

stargazer(m1, m2, summary = FALSE, header = FALSE, 
          title = "ITT Effects (ignoring bounces)",
          digits = 3,
          type="text",
          se = list(rse1, rse2))
