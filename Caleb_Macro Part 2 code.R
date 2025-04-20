# Load libraries
library(ipumsr)
library(dplyr)
library(tidyr)
library(ggplot2)

# Step 1: Load data
ddi <- read_ipums_ddi("cps_00001.xml")
data <- read_ipums_micro(ddi)

# Step 2: Use EMPSTAT instead of PEMLR
data <- data %>%
  select(CPSIDP, YEAR, MONTH, EMPSTAT) %>%
  mutate(
    STATUS = case_when(
      EMPSTAT %in% 10:12 ~ "E",   # Employed
      EMPSTAT %in% 20:21 ~ "U",   # Unemployed
      EMPSTAT >= 30      ~ "N",   # Not in labor force
      TRUE ~ NA_character_
    )
  ) %>%
  filter(!is.na(STATUS))


# Step 3: Create next-month status by CPSIDP
data <- data %>%
  arrange(CPSIDP, YEAR, MONTH) %>%
  group_by(CPSIDP) %>%
  mutate(
    NEXT_STATUS = lead(STATUS),
    NEXT_YEAR = lead(YEAR),
    NEXT_MONTH = lead(MONTH)
  ) %>%
  ungroup()

# Step 4: Filter for valid transitions only
data_trans <- data %>%
  filter(!is.na(NEXT_STATUS))

# Step 5: Create a combined YYYY-MM format for grouping
data_trans <- data_trans %>%
  mutate(YEAR_MONTH = sprintf("%04d-%02d", YEAR, MONTH))

# Step 6: Calculate transition rates by month
monthly_transitions <- data_trans %>%
  group_by(YEAR_MONTH) %>%
  summarise(
    E_to_U = sum(STATUS == "E" & NEXT_STATUS == "U") / sum(STATUS == "E"),
    U_to_E = sum(STATUS == "U" & NEXT_STATUS == "E") / sum(STATUS == "U"),
    N_to_U = sum(STATUS == "N" & NEXT_STATUS == "U") / sum(STATUS == "N"),
    U_to_N = sum(STATUS == "U" & NEXT_STATUS == "N") / sum(STATUS == "U")
  ) %>%
  ungroup()

# Step 7: Reshape for plotting
plot_data <- monthly_transitions %>%
  pivot_longer(cols = c(E_to_U, U_to_E, N_to_U, U_to_N),
               names_to = "Transition", values_to = "Share") %>%
  mutate(YEAR_MONTH = as.Date(paste0(YEAR_MONTH, "-01")))

# Step 8: Plot the transitions
ggplot(plot_data, aes(x = YEAR_MONTH, y = Share, color = Transition)) +
  geom_line(size = 1.2) +
  geom_point() +
  labs(
    title = "Monthly Labor Force Transitions",
    x = "Month", y = "Share of Individuals", color = "Transition"
  ) +
  theme_minimal() +
  scale_x_date(date_labels = "%Y", date_breaks = "year") +
  theme(axis.text.x = element_text(angle = 315, hjust = 1))

