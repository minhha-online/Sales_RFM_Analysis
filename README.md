# Sales Analysis by RFM Model

**📚 Table of Contents**
- [Objective](#objective)
- [📊 Data Source](#data-source)
- [🔄 Project Stages](#project-stages)
- [🎨 Design & Mockup](#design--mockup)
- [🛠 Tools](#tools)
- [💻 Development & Pseudocode](#development--pseudocode)
- [🔍 Data Exploration & Testing](#data-exploration--testing)
- [🧼 Data Cleaning](#data-cleaning)
- [🔧 Data Transformation](#data-transformation)
- [🧱 Create the SQL View](#create-the-sql-view)
- [✅ Data Quality Tests](#data-quality-tests)
- [📊 Visualization Highlights](#visualization-highlights)
- [📈 Results & DAX Measures](#results--dax-measures)
- [🔎 Analysis & Findings](#analysis--findings)
- [📌 Recommendations](#recommendations)
- [📚 Potential Actions](#potential-actions)
- [✅ Conclusion](#conclusion)


# Objective  
To analyze customer behavior using the RFM (Recency - Frequency - Monetary) model to identify high-value, at-risk, and potentially loyal customers, and recommend strategic actions for retention and revenue growth.

**📊 Data Source**  
- File: `sales_data.csv` from a real-world sales system  
- 2,823 transaction records, 92 unique customers  
- Key fields: ORDERNUMBER, ORDERDATE, PRODUCTCODE, QUANTITYORDERED, PRICEEACH, CUSTOMERNAME, POSTALCODE, etc.

**🔄 Project Stages**  
1. Data Exploration  
2. Data Cleaning & Transformation  
3. RFM Analysis via SQL  
4. Data Quality Testing  
5. Visualization in Power BI  
6. Analysis, Insights, and Business Recommendations

**🎨 Design & Mockup**  
Power BI dashboard layout includes:
- KPI Cards (Total Customers, Revenue, VIPs, Lost Customers)
- Pie Chart (Customer segmentation by RFM_LEVEL)
- Bar Charts (R, F, M Score distributions)
- Table (Top 10 high-spending customers)
- Slicers (By RFM Level, Score)

**🛠 Tools**  
- **Excel**: Initial cleaning and calculated columns  
- **Microsoft SQL Server**: RFM scoring logic via SQL  
- **Power BI**: Interactive visualizations and DAX

**💻 Development & Pseudocode**  
- Calculate Recency: `DATEDIFF` between last order date and reference date  
- Frequency: Count of unique orders per customer  
- Monetary: Sum of actual sales = `PRICEEACH * QUANTITYORDERED`
- Use `PERCENTILE_CONT` to assign quartile-based RFM scores (1 to 4)
- Concatenate RFM scores to form `RFM_SCORE` and classify into `RFM_LEVEL`

**🔍 Data Exploration & Testing**  
- No duplicate `ORDERNUMBER + PRODUCTCODE`  
- Missing `POSTALCODE` handled manually in Excel  
- Verified `ACTUAL_SALES` matches `PRICEEACH * QUANTITYORDERED`

**🧼 Data Cleaning**  
- Dropped irrelevant fields (PHONE, STATE, TERRITORY, etc.)  
- Standardized date format for ORDERDATE  
- Rounded monetary values to 2 decimal places

**🔧 Data Transformation**  
- Added new column: `ACTUAL_SALES`  
- Ensured `POSTALCODE` is text format

**🧱 Create the SQL View**  
```sql
-- Step 1: Aggregate RFM values
WITH rfm_base AS (
  SELECT CUSTOMERNAME,
         DATEDIFF(DAY, MAX(ORDERDATE), '2005-06-01') AS Recency,
         COUNT(DISTINCT ORDERNUMBER) AS Frequency,
         ROUND(SUM(PRICEEACH * QUANTITYORDERED), 2) AS Monetary
  FROM sales_data
  GROUP BY CUSTOMERNAME
),
-- Step 2: Quartile thresholds
quartiles AS (
  SELECT ... PERCENTILE_CONT OVER() ... 
),
-- Step 3: Assign R, F, M scores using CASE WHEN
-- Step 4: Create final RFM table with RFM_SCORE and RFM_LEVEL classification
```

**✅ Data Quality Tests**  
- RFM results aligned with total revenue  
- No null values in critical columns like CUSTOMERNAME, RFM_LEVEL

**📊 Visualization Highlights**  
- Power BI dashboard with responsive design  
- KPI summary on top, segmentation and detailed tables below  
- Conditional formatting and slicers enhance interactivity

**📈 Results & DAX Measures**  
- `Total Customers = DISTINCTCOUNT(CUSTOMERNAME)`  
- `Total Revenue = SUM(Monetary)`  
- `VIP Customers = COUNTROWS(FILTER(...))`  
- `Top Customer = CALCULATE(MAX(Monetary))`

**🔎 Analysis & Findings**  
- VIPs represent only 11% but contribute over 27% of total revenue  
- 41% of customers are classified as At Risk or Lost  
- Big Spenders show high value but low frequency → high potential for nurturing

**📌 Recommendations**  
- **VIPs**: Exclusive treatment, personalized loyalty programs  
- **Big Spenders**: Cross-sell, up-sell campaigns, periodic incentives  
- **At Risk**: Reminder emails, comeback offers  
- **Lost**: Aggressive remarketing and win-back vouchers  
- **Potential Loyalists**: Strengthen ties with loyalty schemes

**📚 Potential Actions**  
- Add clustering for deeper segmentation of "Others" group  
- Automate customer journeys using email workflows  
- Align marketing campaigns with RFM tiers

**✅ Conclusion**  
This project demonstrates a full-cycle data analytics process: data cleaning, SQL-based analysis, business insight discovery, and compelling dashboard creation. RFM modeling proves effective in guiding customer relationship strategies and can be adapted for any CRM or e-commerce platform.

**📊 Power BI Dashboard Design:**

This dashboard was built in **Sales_project.pbix**, reflecting a customer segmentation approach using the RFM model. The key visuals and layout include:

- **KPI Cards**: Displaying Total Revenue, Total Customers, VIP Customers, and Lost Customers
- **Pie Chart**: Shows customer segmentation by `RFM_LEVEL`
- **Bar Charts**: Distribution of scores for Recency, Frequency, and Monetary
- **Table**: Top 10 high-value customers sorted by spending
- **Slicer Panel**: Allows filtering by RFM Level or individual scores
- **Conditional Formatting**: Highlights high-spending customers and RFM dynamics
- **Layout**: Horizontally grouped insights for score distribution, customer segments, and detailed breakdown

The visual styling was intentionally kept clean and professional, with intuitive color coding for groups like VIP, At Risk, and Big Spenders.

📁 File: `Sales_project.pbix`
