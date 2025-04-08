
# Sales Analysis by RFM Model


## 🔍 Answering Business Questions through Power BI

Using the final Power BI dashboard, we address the key analytical questions defined earlier:

| ❓ Business Question | 💡 Insight from Power BI |
|----------------------|--------------------------|
| **1. Who are the most valuable customers?** | The *Top 10 Customers* table shows that clients like **Euro Shopping Channel** and **Mini Gifts Distributors Ltd.** contribute the highest revenue (over $1.2M combined). Their RFM Level is classified as **VIP**. |
| **2. Which customers are at risk of churning?** | The segment with `R_SCORE = 1` and high F/M values appears under the **At Risk** group. Pie charts reveal this group accounts for approximately **12% of all customers**. |
| **3. What is the distribution of customer behavior?** | The **R, F, M bar charts** show that most customers have **low frequency** and **moderate monetary** values, highlighting uneven engagement. |
| **4. How can we prioritize retention strategies?** | **Big Spenders** and **Potential Loyalists** (e.g., R=4, M=4, F=1–2) show strong potential for upselling and loyalty campaigns. This insight drives marketing prioritization. |
| **5. Are there any unexpected patterns in behavior?** | Customers in the **Others** segment occasionally show high recency spikes despite low F/M. These are **early signs of potential reactivation or new interest**. |

These insights connect the dashboard to real business actions, demonstrating the value of data-driven decision-making.

**📚 Table of Contents**
- [Objective](#objective)
- [Data Source](#data-source)
- [Project Stages](#project-stages)
- [Design & Mockup](#design--mockup)
- [Tools](#tools)
- [Development & Pseudocode](#development--pseudocode)
- [Data Exploration & Testing](#data-exploration--testing)
- [Data Cleaning](#data-cleaning)
- [Data Transformation](#data-transformation)
- [Create the SQL View](#create-the-sql-view)
- [Data Quality Tests](#data-quality-tests)
- [Visualization Highlights](#visualization-highlights)
- [Results & DAX Measures](#results--dax-measures)
- [Analysis & Findings](#analysis--findings)
- [Recommendations](#recommendations)
- [Potential Actions](#potential-actions)
- [Conclusion](#conclusion)


# Objective  
The goal of this project is to perform a full-cycle customer analytics pipeline using real-world transactional sales data. By applying the RFM (Recency, Frequency, Monetary) model, we segment customers based on their purchasing behavior and translate those insights into actionable business strategies.

This project covers the complete data analytics process:
- Cleaning and transforming raw sales data using Excel  
- Modeling and segmenting customers with SQL-based RFM scoring  
- Designing an interactive Power BI dashboard to uncover insights  
- Recommending targeted CRM and marketing actions based on data

# Data Source  
- **Dataset**: Sales transaction data sourced from [Kaggle](https://www.kaggle.com/)

The dataset reflects simulated global sales activity and serves as a rich source for behavioral segmentation using the RFM model.

# Project Stages    
1. **Data Exploration**  
2. **Data Cleaning & Preparation (Excel)**  
3. **RFM Modeling with SQL Server**  
4. **Power BI Dashboard Development**  
5. **Insight Extraction & Recommendations**  
6. **Project Documentation**  

# Design & Mockup  
To uncover meaningful insights from customer transaction data, this project aims to answer the following key questions:

1. **Who are the most valuable customers?**
   - Identify top spenders and VIP customers using RFM segmentation.

2. **Which customers are at risk of churning?**
   - Detect customers with high Frequency/Monetary but low Recency.

3. **What is the distribution of customer behavior?**
   - Segment customers by RFM score and level (e.g., Lost, Loyal, Potential).

4. **How can we prioritize retention and marketing strategies?**
   - Recommend actions based on customer value and risk level.

5. **Are there any unexpected patterns in spending behavior?**
   - Analyze anomalies or opportunities within "Others" or low-F score groups.

Power BI dashboard layout includes:
- KPI Cards (Total Customers, Revenue, VIPs, Lost Customers)
- Pie Chart (Customer segmentation by RFM_LEVEL)
- Bar Charts (R, F, M Score distributions)
- Table (Top 10 high-spending customers)
- Slicers (By RFM Level, Score)

# Tools  
This project showcases the integration of four essential tools in the data analytics pipeline:

| Tool                 | Purpose                                                                 |
|----------------------|-------------------------------------------------------------------------|
| **Microsoft Excel**      | Data cleaning, transformation, and initial validation. Created `ACTUAL_SALES`, standardized date formats, and handled missing values. |
| **Microsoft SQL Server**| Built the entire RFM segmentation model using CTEs and percentile logic. Demonstrated advanced SQL capabilities including conditional scoring and customer segmentation. |
| **Power BI**             | Developed an interactive dashboard with KPI Cards, score distribution, segmentation visuals, and customer-level insights. Integrated DAX measures and slicers for user exploration. |
| **GitHub**               | Hosted the full project documentation, code versioning, and README-based walkthrough for public portfolio showcasing. |

Each tool was used for what it does best—Excel for data prep, SQL for logic-heavy modeling, Power BI for visual storytelling, and GitHub for version control and public visibility.


# 1. Data Exploration

Before diving into modeling, it's essential to explore the raw dataset
**Dataset Overview**
- **Size**: 2,823 rows × 25 columns
- **Structure**: Includes order info, product pricing, customer details, and geographic metadata

**Key Exploration Findings**

| Aspect              | Observation                                                                 |
|---------------------|------------------------------------------------------------------------------|
| **Data Types**      | Dates stored as text, numeric columns are mixed with string formatting       |
| **Missing Values**  | Lots of missing values in `POSTALCODE`, some missing `STATE`, `TERRITORY`         |
| **Revenue Issues**  | Column `SALES` had discrepancies when re-calculated from `PRICEEACH * QUANTITYORDERED` |
| **Duplicates**      | Checked via `ORDERNUMBER + PRODUCTCODE` → No exact duplicates found          |
| **Irrelevant Fields** | Columns like `PHONE`, `ADDRESSLINE2`, `CONTACTNAME` not used in RFM analysis  |
| **Geographic Data** | Some columns present but not useful for customer behavior segmentation       |

**Initial Distributions**
- Most orders are concentrated in a few frequent buyers
- Many customers made only 1–2 purchases
- High variance in monetary value across transactions

This exploration guided our decisions in the cleaning stage and ensured the focus remained on columns relevant to customer-level behavior modeling.

# 2. **Data Cleaning & Preparation (Excel)**  
**Objective**
- Clean and standardize raw Kaggle dataset
- Identify and resolve revenue inconsistencies
- Remove columns not serving behavioral analysis
- Prepare dataset for SQL-based segmentation

---
**Detecting Data Issues**

Upon initial inspection, the dataset contained a `SALES` column, representing line-level revenue. However, when we validated it against the actual logic:

```
ACTUAL_SALES = PRICEEACH * QUANTITYORDERED
```

-> The values did not consistently match, indicating data quality issues.

**Decision**: Discarded the unreliable `SALES` column and created a new, trusted column `ACTUAL_SALES` to ensure accurate analysis.

---

**Dropping Irrelevant Columns**

Out of 25 columns in the original dataset, only around 8–9 were required for RFM analysis. We removed the following:

| Category            | Columns Removed                                   | Reason                                  |
|---------------------|---------------------------------------------------|-----------------------------------------|
| Contact & Address   | PHONE, ADDRESSLINE1, ADDRESSLINE2, CITY, STATE, COUNTRY | Not relevant to behavior analysis       |
| Personal Info       | CONTACTFIRSTNAME, CONTACTLASTNAME                | Redundant with CUSTOMERNAME             |
| Order Management    | STATUS, ORDERLINENUMBER, QTR_ID, MONTH_ID, YEAR_ID | Duplicates ORDERDATE or metadata        |
| Product Segments    | PRODUCTLINE, MSRP, DEALSIZE, TERRITORY           | Not required for customer-level RFM     |

Key Columns Used in This Project:
| Column         | Description                                      |
|----------------|--------------------------------------------------|
| ORDERNUMBER    | Unique identifier for each order                 |
| ORDERDATE      | Date of the transaction                          |
| CUSTOMERNAME   | Name of the customer                             |
| PRICEEACH      | Price per item                                   |
| QUANTITYORDERED| Number of items ordered                          |
| SALES          | System-generated sales field (later replaced)   |
| ACTUAL_SALES   | Calculated as `PRICEEACH * QUANTITYORDERED`     |
| POSTALCODE     | Used for potential geographic analysis           |
| PRODUCTCODE    | Used to check for duplicates within transactions |

---

**Processing Steps in Excel**

| Step | Action                              | Description |
|------|-------------------------------------|-------------|
| 1    | Created `ACTUAL_SALES`              | Formula: `=PRICEEACH * QUANTITYORDERED`, rounded to 2 decimals |
| 2    | Standardized `ORDERDATE`            | Converted to format `yyyy-mm-dd` |
| 3    | Dropped unnecessary columns         | As listed above |
| 4    | Handled missing `POSTALCODE`        | Filled using other rows with same `CUSTOMERNAME` |
| 5    | Checked for duplicate orders        | Used helper column: `ORDERNUMBER & PRODUCTCODE`, then COUNTIFS() |
| 6    | Sorted data by `ORDERDATE`          | For Recency calculation validation |
| 7    | Exported cleaned dataset            | Saved as `sales_data_cleaned.csv` for SQL analysis |

---

**Output**

- Clean, complete, and analysis-ready dataset
- Verified revenue field (`ACTUAL_SALES`)
- Trusted input for all downstream SQL and visualization tasks

# 2. RFM Modeling with SQL Server

**Objective**
Build a robust RFM model using SQL to segment customers by Recency, Frequency, and Monetary behavior, enabling business insight and targeting strategy.

---

**Key Steps**

***1. Aggregate RFM Metrics***
```sql
WITH rfm_base AS (
  SELECT 
    CUSTOMERNAME,
    DATEDIFF(DAY, MAX(ORDERDATE), '2005-06-01') AS Recency,
    COUNT(DISTINCT ORDERNUMBER) AS Frequency,
    ROUND(SUM(ACTUAL_SALES), 2) AS Monetary
  FROM sales_data
  GROUP BY CUSTOMERNAME
)
```

***2. Calculate Quartile Thresholds***
```sql
, quartiles AS (
  SELECT
    PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY Recency) OVER () AS R25,
    PERCENTILE_CONT(0.75) ... AS R75,
    ...
  FROM rfm_base
)
```

***3. Assign R, F, M Scores (1 to 4)***
```sql
, rfm_scored AS (
  SELECT r.*,
    CASE WHEN Recency <= q.R25 THEN 4 ... ELSE 1 END AS R_SCORE,
    CASE WHEN Frequency <= q.F25 THEN 1 ... ELSE 4 END AS F_SCORE,
    CASE WHEN Monetary <= q.M25 THEN 1 ... ELSE 4 END AS M_SCORE
  FROM rfm_base r CROSS JOIN quartiles q
)
```

***4. Generate Final RFM Table***
```sql
, rfm_final AS (
  SELECT *,
    CAST(R_SCORE AS VARCHAR) + CAST(F_SCORE AS VARCHAR) + CAST(M_SCORE AS VARCHAR) AS RFM_SCORE,
    CASE 
      WHEN R_SCORE=4 AND F_SCORE=4 AND M_SCORE=4 THEN 'VIP'
      WHEN R_SCORE=4 AND F_SCORE<=2 THEN 'Big Spender'
      WHEN R_SCORE=1 AND F_SCORE>=3 THEN 'At Risk'
      WHEN R_SCORE=1 AND F_SCORE=1 THEN 'Lost'
      ELSE 'Others'
    END AS RFM_LEVEL
  FROM rfm_scored
)
```

***5. Export to New Table***
```sql
SELECT * INTO rfm_results FROM rfm_final;
```

---

**Output**
- Table `rfm_results` contains:
  - RFM metrics and scores
  - Composite `RFM_SCORE`
  - Behavior segment: `RFM_LEVEL`

This structured output feeds directly into Power BI for interactive analysis.
