# Load Required Libraries
library(tidyverse)
library(ggplot2)

# Loading the Dataset
data_sal <- read.csv("C:\\Users\\User\\Desktop\\ds_salary.csv")

# Data Overview
str(data_sal)
summary(data_sal)

# Checking for Missing Values
missing_values <- colSums(is.na(data_sal))
print(format(missing_values, big.mark=","))

# Histogram of Salary Distribution
ggplot(data_sal, aes(x = salary_in_usd)) +
  geom_histogram(binwidth = 10000, fill = "skyblue", color = "black", alpha = 0.9) +
  labs(
    title = "Distribution of Data Scientist Salaries",
    x = "Salary (USD)",
    y = "Frequency"
  ) +
  theme_minimal()

# Order Experience Levels
data_sal$experience_level <- factor(data_sal$experience_level, levels = c("EN", "MI", "SE", "EX"))

# Boxplot for Experience Levels and Salaries
ggplot(data_sal, aes(x = experience_level, y = salary_in_usd, fill = experience_level)) +
  geom_boxplot() +
  labs(
    title = "Impact of Experience Levels on Salaries",
    x = "Experience Level",
    y = "Salary (USD)"
  ) +
  theme_minimal() + theme(legend.position = "none")

# Order Employment Types
data_sal$employment_type <- factor(data_sal$employment_type, levels = c("Part_time", "FreeLance", "Fulltime", "Contract"))

# Boxplot for Employment Types and Salaries
ggplot(data_sal, aes(x = employment_type, y = salary_in_usd, fill = employment_type)) +
  geom_boxplot() +
  labs(
    title = "Impact of Employment Types on Salaries",
    x = "Employment Type",
    y = "Salary (USD)"
  ) +
  theme_minimal() + theme(legend.position = "none")


# Top 20 Job Titles by Median Salary
top_20_jobs <- data_sal %>%
  group_by(job_title) %>%
  summarise(median_salary = median(salary_in_usd, na.rm = TRUE)) %>%
  arrange(desc(median_salary)) %>%
  head(20)

ggplot(top_20_jobs, aes(x = reorder(job_title, median_salary), y = median_salary)) +
  geom_col(fill = "skyblue") +
  coord_flip() +
  labs(
    title = "Top 20 Job Titles with Highest Median Salary",
    x = "Job Title",
    y = "Median Salary (USD)"
  ) +
  theme_minimal()

# Scatterplot for Remote Work and Salaries
ggplot(data_sal, aes(x = remote_ratio, y = salary_in_usd)) +
  geom_point() +
  geom_smooth(method = "lm") +
  labs(
    title = "Correlation Between Remote Work and Salaries",
    x = "Remote Ratio (%)",
    y = "Salary (USD)"
  ) +
  theme_minimal()

# Creating a Factor for Remote Work Type
data_sal$remote_ratio <- cut(data_sal$remote_ratio,
                             breaks = c(-Inf, 0, 50, 100),
                             labels = c("On-Site", "Hybrid", "Fully Remote"),
                             include.lowest = TRUE)

# Boxplot for Salary Variation between Remote Work Types
ggplot(data_sal, aes(x = remote_ratio, y = salary_in_usd, fill = remote_ratio)) +
  geom_boxplot() +
  labs(
    title = "Salary Variation between Remote Work Types",
    x = "Remote Work Type",
    y = "Salary (USD)"
  ) +
  theme_minimal() + theme(legend.position = "none")

# Violin Plot for Company Size and Salaries
ggplot(data_sal, aes(x = company_size, y = salary_in_usd, fill = company_size)) +
  geom_violin(trim = FALSE, scale = "width", draw_quantiles = c(0.25, 0.5, 0.75)) +
  scale_fill_manual(
    values = c("S" = "skyblue", "M" = "lightgreen", "L" = "salmon"),  # Custom colors for each size
    labels = c("S" = "Small", "M" = "Medium", "L" = "Big")            # Custom labels for legend
  ) +
  labs(
    title = "Salary Distribution by Company Size",
    x = "Company Size",
    y = "Salary (USD)",
    fill = "Company Size"  # Legend title
  ) +
  theme_minimal()

# Creating Word Cloud for Job Titles
library(wordcloud)
library(RColorBrewer)

wordcloud(
  words = data_sal$job_title,
  scale = c(5, 0.5),
  min.freq = 5,
  random.order = FALSE,
  colors = brewer.pal(8, "Dark2")
)

# Scatterplot for Yearly Trends in Salary
ggplot(data_sal, aes(x = work_year, y = salary_in_usd)) +
  geom_point(color = "blue") +
  labs(
    title = "Yearly Trends in Data Scientist Salaries",
    x = "Year",
    y = "Salary (USD)"
  ) +
  theme_minimal()

# Pie Chart for Remote Work Types
ggplot(data_sal, aes(x = "", fill = factor(remote_ratio))) +
  geom_bar(stat = "count", width = 1) +
  coord_polar("y") +
  labs(
    title = "Distribution of Remote Work Types",
    fill = "Remote Ratio"
  ) +
  theme_minimal()

# ANOVA Test for Salary Differences by Remote Work Type
anova_result <- aov(salary_in_usd ~ remote_ratio, data = data_sal)
print(summary(anova_result))


# Create Summary Data for Heatmap
heatmap_data <- data_sal %>%
  group_by(job_title, company_size) %>%
  summarise(avg_salary = mean(salary_in_usd, na.rm = TRUE), .groups = "drop")

# Filter for Top 20 Job Titles by Average Salary
heatmap_data_filtered <- heatmap_data %>%
  group_by(job_title) %>%
  summarise(overall_avg_salary = mean(avg_salary, na.rm = TRUE), .groups = "drop") %>%
  top_n(20, overall_avg_salary) %>%
  inner_join(heatmap_data, by = "job_title")

# Heatmap Plot
ggplot(heatmap_data_filtered, aes(x = company_size, y = reorder(job_title, overall_avg_salary), fill = avg_salary)) +
  geom_tile(color = "white") +
  geom_text(aes(label = scales::comma(round(avg_salary, 0))), size = 3, color = "white") + # Add formatted labels
  scale_fill_viridis_c(
    name = "Average Salary (USD)",
    option = "plasma", # Changed color palette for distinction
    direction = -1,
    breaks = scales::breaks_extended(n = 5), # Ensure readable and distinct legend values
    labels = scales::comma_format() # Format legend labels with commas
  ) +
  labs(
    title = "Heatmap of Salary Variation by Job Title and Company Size",
    subtitle = "Top 20 Job Titles by Average Salary",
    x = "Company Size",
    y = "Job Title"
  ) +
  theme_minimal() +
  theme(
    axis.text.x = element_text(angle = 45, hjust = 1, size = 10),
    axis.text.y = element_text(size = 8),
    legend.position = "bottom", # Position legend for better visibility
    legend.key.width = unit(1.5, "cm"), # Increase legend width for better readability
    legend.title = element_text(size = 10, face = "bold"),
    plot.title = element_text(size = 16, face = "bold"),
    plot.subtitle = element_text(size = 12)
  )


# Correlation Matrix for Numeric Variables
numeric_cols <- data_sal %>%
  select(where(is.numeric)) %>%
  cor(use = "pairwise.complete.obs")

# Melt the Correlation Matrix for Visualization
library(reshape2)
cor_melted <- melt(numeric_cols)

# Correlation Heatmap
ggplot(cor_melted, aes(x = Var1, y = Var2, fill = value)) +
  geom_tile(color = "white") +
  scale_fill_gradient2(low = "red", mid = "white", high = "blue", midpoint = 0, limit = c(-1, 1), space = "Lab") +
  geom_text(aes(label = round(value, 2)), size = 3) +
  labs(
    title = "Correlation Matrix of Numeric Variables",
    x = "",
    y = "",
    fill = "Correlation"
  ) +
  theme_minimal() +
  theme(
    axis.text.x = element_text(angle = 45, hjust = 1),
    axis.text.y = element_text(size = 10)
  )


# Install and Load Plotly
if (!require("plotly")) install.packages("plotly")
library(plotly)

# Interactive Scatterplot for Salaries vs. Remote Ratio
plot_ly(data_sal, x = ~remote_ratio, y = ~salary_in_usd, type = 'scatter', mode = 'markers',
        text = ~paste("Job Title:", job_title, "<br>Company Size:", company_size),
        marker = list(size = 10, opacity = 0.6)) %>%
  layout(
    title = "Interactive Scatterplot: Salaries vs. Remote Ratio",
    xaxis = list(title = "Remote Ratio"),
    yaxis = list(title = "Salary (USD)")
  )


# Install and Load Treemapify
if (!require("treemapify")) install.packages("treemapify")
library(treemapify)

# Aggregate data to calculate the average salary per job title
treemap_data <- data_sal %>%
  group_by(job_title) %>%
  summarise(
    avg_salary = mean(salary_in_usd, na.rm = TRUE),
    count = n()
  ) %>%
  arrange(desc(avg_salary)) %>%
  slice_head(n = 20)  # Filter for top 20 job titles by average salary

# Creating the treemap
ggplot(treemap_data, aes(area = count, fill = avg_salary, label = paste0(job_title, "\nCount: ", count, "\n$", round(avg_salary, 0)))) +
  geom_treemap() +
  geom_treemap_text(
    fontface = "bold",
    color = "white",
    place = "center",
    grow = TRUE,
    reflow = TRUE
  ) +
  scale_fill_viridis_c(option = "plasma", name = "Avg. Salary (USD)") +
  labs(
    title = "Treemap of Top 20 Job Titles by Average Salary",
    subtitle = "Size Represents Count; Color Represents Salary",
    caption = "Data Source: Kaggle 2023 Data Scientist Salaries Dataset"
  ) +
  theme_minimal()

# Add Region Column (Example Categorization)
data_sal <- data_sal %>%
  mutate(region = case_when(
    company_location %in% c("US", "CA") ~ "North America",
    company_location %in% c("UK", "DE", "FR") ~ "Europe",
    company_location %in% c("IN", "CN", "JP") ~ "Asia",
    TRUE ~ "Other"
  ))

# Boxplot for Salaries by Region
ggplot(data_sal, aes(x = region, y = salary_in_usd, fill = region)) +
  geom_boxplot() +
  labs(
    title = "Regional Salary Trends for Data Scientists",
    x = "Region",
    y = "Salary (USD)"
  ) +
  theme_minimal() + theme(legend.position = "none")



# Grouped Bar Plot: Experience Level and Employment Type
ggplot(data_sal, aes(x = experience_level, y = salary_in_usd, fill = employment_type)) +
  geom_bar(stat = "identity", position = "dodge") +
  labs(
    title = "Impact of Experience Level and Employment Type on Salaries",
    x = "Experience Level",
    y = "Salary (USD)",
    fill = "Employment Type"
  ) +
  theme_minimal() +
  scale_fill_brewer(palette = "Set2") + theme(legend.position = "none")



# Line Plot for Salary Trends by Year
ggplot(data_sal, aes(x = work_year, y = salary_in_usd, group = 1)) +
  geom_line(color = "blue", size = 1) +
  geom_point(size = 2) +
  labs(
    title = "Salary Growth Over Time",
    x = "Year",
    y = "Average Salary (USD)"
  ) +
  theme_minimal()


# Faceted Scatter Plot: Experience vs. Salary by Remote Work Type
ggplot(data_sal, aes(x = experience_level, y = salary_in_usd, color = remote_ratio)) +
  geom_jitter(width = 0.2, alpha = 0.6) +
  facet_wrap(~ remote_ratio) +
  labs(
    title = "Relationship Between Experience and Remote Work on Salaries",
    x = "Experience Level",
    y = "Salary (USD)",
    color = "Remote Work Type"
  ) +
  theme_minimal()


# Create a Treemap for Salaries by Job Industry
if (!require("treemapify")) install.packages("treemapify")
library(treemapify)

treemap_data <- data_sal %>%
  group_by(job_title) %>%
  summarise(
    avg_salary = mean(salary_in_usd, na.rm = TRUE),
    count = n()
  ) %>%
  ungroup()

ggplot(treemap_data, aes(area = count, fill = avg_salary, label = job_title)) +
  geom_treemap() +
  geom_treemap_text(fontface = "bold", color = "white", place = "center", grow = TRUE) +
  scale_fill_viridis_c(option = "plasma", name = "Avg. Salary (USD)") +
  labs(
    title = "Treemap of Job Titles by Average Salary and Count",
    subtitle = "Size Represents Count; Color Represents Salary"
  ) +
  theme_minimal()


# Filter for Top 10 Countries by Count
top_countries <- data_sal %>%
  group_by(company_location) %>%
  summarise(count = n(), avg_salary = mean(salary_in_usd, na.rm = TRUE)) %>%
  arrange(desc(count)) %>%
  slice_head(n = 10)

# Boxplot for Salaries in Top Countries
filtered_data <- data_sal %>% filter(company_location %in% top_countries$company_location)

ggplot(filtered_data, aes(x = company_location, y = salary_in_usd, fill = company_location)) +
  geom_boxplot() +
  labs(
    title = "Salary Distribution in Top 10 Countries by Job Count",
    x = "Country",
    y = "Salary (USD)"
  ) +
  theme_minimal() +
  scale_fill_brewer(palette = "Paired") + theme(legend.position = "none")



# Density Plot for Salary Distributions
ggplot(data_sal, aes(x = salary_in_usd, fill = experience_level)) +
  geom_density(alpha = 0.6) +
  labs(
    title = "Density Plot of Salaries by Experience Level",
    x = "Salary (USD)",
    y = "Density",
    fill = "Experience Level"
  ) +
  theme_minimal()

# Linear Regression Model
model <- lm(salary_in_usd ~ experience_level + remote_ratio + company_size, data = data_sal)
summary(model)



# Set a seed for reproducibility
set.seed(123)

# Summarizing the data to calculate average salaries by job title
data_cluster <- data_sal %>%
  group_by(job_title) %>%
  summarise(avg_salary = mean(salary_in_usd, na.rm = TRUE)) %>%
  ungroup()

# Preparing data for clustering (scaling average salaries)
cluster_data <- scale(data_cluster$avg_salary)

# Perform K-means clustering with 3 clusters
kmeans_model <- kmeans(cluster_data, centers = 3)

# Add cluster results to the data
data_cluster$cluster <- as.factor(kmeans_model$cluster)

# Ensure even representation by sampling top 10 job titles from each cluster
balanced_clusters <- data_cluster %>%
  group_by(cluster) %>%
  slice_max(order_by = avg_salary, n = 10) %>%
  ungroup()

# Reassign cluster labels for meaningful interpretation
balanced_clusters <- balanced_clusters %>%
  mutate(cluster = case_when(
    cluster == "1" ~ "Cluster 1: High Salary",
    cluster == "2" ~ "Cluster 2: Medium Salary",
    cluster == "3" ~ "Cluster 3: Low Salary"
  ))

# Visualize K-means Clustering Results
ggplot(balanced_clusters, aes(x = reorder(job_title, avg_salary), y = avg_salary, fill = cluster)) +
  geom_col(width = 0.8) +
  scale_fill_manual(
    values = c("Cluster 1: High Salary" = "#FF5733", 
               "Cluster 2: Medium Salary" = "#33C3FF", 
               "Cluster 3: Low Salary" = "#75C940")
  ) +
  labs(
    title = "Clustering Job Titles by Average Salary",
    subtitle = "Using K-means Clustering (3 Clusters) with Balanced Representation",
    x = "Job Title",
    y = "Average Salary (USD)",
    fill = "Cluster"
  ) +
  theme_minimal() +
  theme(
    axis.text.x = element_text(angle = 45, hjust = 1, size = 10, face = "bold"),  # Rotate and style x-axis labels
    axis.text.y = element_text(size = 10, color = "black"),
    axis.title.x = element_text(size = 12, face = "bold"),
    axis.title.y = element_text(size = 12, face = "bold"),
    plot.title = element_text(size = 16, face = "bold", hjust = 0.5),
    plot.subtitle = element_text(size = 12, hjust = 0.5),
    legend.title = element_text(size = 12, face = "bold"),
    legend.text = element_text(size = 10)
  )
