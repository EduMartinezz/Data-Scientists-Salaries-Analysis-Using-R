# Data-Scientists-Salaries-Analysis-Using-R
## **Overview**
This project analyzes the "2023 Data Scientists Salaries" dataset from Kaggle to uncover critical insights into the salary trends and influencing factors in the data science profession. The analysis focuses on understanding how experience level, employment type, remote work, company size, job title, and geographical factors contribute to salary variations.
The project leverages R for data cleaning, exploration, visualization, and statistical analysis, aiming to provide actionable insights for job seekers, employers, and policymakers. With interactive visualizations and detailed storytelling, this project bridges the gap between data and decision-making.


### **Project Objectives**
1. **Explore salary trends**: Analyze distributions and variations across roles, experience, and locations.
2. **Identify key factors**: Uncover how employment type, remote work, and company size impact salaries.
3. **Provide actionable insights**: Equip job seekers and employers with data-driven recommendations.

### **Key Features**
**Comprehensive Exploratory Data Analysis (EDA):**
- Detailed examination of salary distributions, experience levels, employment types, and remote work ratios.
- Insights into salary trends by region, job title, and company size.

**Interactive Visualizations:**
- Dynamic scatterplots and treemaps to enable deeper exploration of the data.

**Advanced Statistical Analysis:**
- ANOVA test for identifying significant salary variations.
- Correlation analysis for exploring relationships between key variables.

**Storytelling and Reporting:**
- A narrative-driven approach to highlight findings and recommendations.

**Reusable and Scalable Codebase:**
- Modular scripts for easy updates and replication.


## **Dataset Overview**
Source - Kaggle.com: 2023 Data Scientists Salaries

### __Features__
The dataset contains information about:
1. **Job Title**: Specific data science roles (e.g., Data Scientist, Machine Learning Engineer).
2. **Salary in USD**: Compensation in USD.
3. **Experience Level**: Levels categorized as:
    - **EN**: Entry-level
    - **MI**: Mid-level
    - **SE**: Senior-level
    - **EX**: Executive
4. **Employment Type**: Categorized as:
    - **PT**: Part-time
    - **FL**: Freelance
    - **FT**: Full-time
    - **CT**: Contract
5. **Remote Ratio**: Work type based on remote percentage:
    - **0%**: On-Site
    - **50%**: Hybrid
    - **100%**: Fully Remote
6. **Company Size**: Size of the company:
    - **S**: Small
    - **M**: Medium
    - **L**: Large

7. **Work Year**: Year of salary observation.

8. **Company Location**: Geographical location of the company.


### **Workflow and Methods**
**Step 1: Data Preprocessing**
- Checked for missing values and cleaned the data.
- Converted relevant columns (e.g., experience_level, employment_type) to factors for better 
  analysis.
- Created additional variables (e.g., region) for geographical analysis.

**Step 2: Exploratory Data Analysis**
- Created visualizations to understand salary distributions, remote work trends, and employment type effects.

**Step 3: Statistical Analysis**
- Performed an ANOVA test to check significant salary variations across remote work types.
- Used correlation analysis to identify relationships between numerical variables..

**Step 4: Reporting and Insights**
- Created visualizations and dashboards for storytelling.
- Highlighted actionable insights for key stakeholders.


## __Key Findings__
__Experience Levels:__
- Executive roles earn the highest salaries, followed by senior roles.
- Entry-level roles offer limited earning potential but grow significantly with experience.

__Employment Types:__
- Full-time roles dominate in terms of salary range, while freelance and contract roles show variability.

__Remote Work:__
- Fully remote roles are competitive in salaries, highlighting the acceptance of remote work in the field.

__Company Size:__
- Larger companies tend to offer higher salaries compared to smaller firms.

__Regional Trends:__
- North America leads in average salaries, followed by Europe and Asia.

__Visualizations and Insights__
Here are some of the key visualizations from the analysis:

__Salary Distribution__
- A histogram showing the spread of salaries, highlighting outliers and trends.

__Impact of Experience Levels__
- Boxplots comparing salaries across experience levels (Entry to Executive).

__Top-Paying Job Titles__
- Bar charts ranking job titles based on median salary.

__Remote Work and Salaries__
- Scatterplots and boxplots showcasing the influence of remote work types on salaries.

__Regional Salary Trends__
- Boxplots comparing salary differences across global regions.

### **Code Highlights**
**Histogram of Salary Distribution**
ggplot(data_sal, aes(x = salary_in_usd)) +
  geom_histogram(binwidth = 10000, fill = "skyblue", color = "black") +
  labs(
    title = "Distribution of Data Scientist Salaries",
    x = "Salary (USD)",
    y = "Frequency"
  ) +
  theme_minimal()


**Boxplot for Experience Levels**
ggplot(data_sal, aes(x = experience_level, y = salary_in_usd, fill = experience_level)) +
  geom_boxplot() +
  labs(
    title = "Impact of Experience Levels on Salaries",
    x = "Experience Level",
    y = "Salary (USD)"
  ) +
  theme_minimal()


**Scatterplot for Remote Work**
ggplot(data_sal, aes(x = remote_ratio, y = salary_in_usd)) +
  geom_point() +
  geom_smooth(method = "lm") +
  labs(
    title = "Correlation Between Remote Work and Salaries",
    x = "Remote Ratio",
    y = "Salary"
  ) +
  theme_minimal()

**Treemap for Job Titles**
ggplot(data_sal, aes(area = salary_in_usd, fill = salary_in_usd, label = job_title)) +
  geom_treemap() +
  geom_treemap_text(fontface = "italic", color = "white", place = "center") +
  scale_fill_viridis_c() +
  labs(
    title = "Treemap of Salaries by Job Title",
    fill = "Salary (USD)"
  ) +
  theme_minimal()


### **Dependencies and Setup**
**Required R Libraries**
Install the following libraries:

install.packages(c("tidyverse", "ggplot2", "dplyr", "plotly", "wordcloud", "treemapify"))

**Setting Up the Environment**
Download the dataset from Kaggle and save it as ds_salary.csv. and Set the file path 

**Folder Structure**
📂 DataScientistsSalaries
├── 📁 Data
│   └── ds_salary.csv
├── 📁 Scripts
│   └── analysis_script.R
├── 📁 Output
│   ├── wordcloud.png
│   ├── visualizations/
│   └── reports/
├── README.md


## **Recommendations**
**Job Seekers:**
- Pursue senior or executive roles for higher earning potential.
- Consider fully remote roles, which often pay competitively.

**Employers:**
- Offer competitive salaries for senior-level positions to retain talent.
- Promote flexible work policies to attract global talent.

**Policymakers:**
-   Encourage remote work adoption to bridge regional salary disparities.

**Future Work**
1. Adjust for cost-of-living differences across regions for more accurate salary comparisons.
2. Track salary trends over multiple years by integrating historical datasets.
3. Develop an interactive dashboard for real-time insights into the data science job market.


This README provides a detailed guide to the 2023 Data Scientists Salaries Analysis project. It serves as a comprehensive resource for anyone seeking to understand, replicate, or extend the analysis.

