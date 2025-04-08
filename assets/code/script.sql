CREATE SalesAnalysis

USE SalesAnalysis;

WITH rfm_base AS (
	SELECT	CUSTOMERNAME,
			DATEDIFF(DAY, MAX(ORDERDATE), (SELECT MAX(ORDERDATE) FROM sales_data)) AS recency,
			COUNT(DISTINCT ORDERNUMBER) AS frequency,
			ROUND(SUM(ACTUAL_SALES),2) AS monetary
	  FROM	sales_data
	 GROUP BY CUSTOMERNAME
),
quartiles AS (
	SELECT	DISTINCT
			PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY recency) OVER() AS r_25,
			PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY recency) OVER() AS r_50,
			PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY recency) OVER() AS r_75,
			PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY frequency) OVER() AS f_25,
			PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY frequency) OVER() AS f_50,
			PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY frequency) OVER() AS f_75,
			PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY monetary) OVER() AS m_25,
			PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY monetary) OVER() AS m_50,
			PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY monetary) OVER() AS m_75
	  FROM	rfm_base
),
rfm_scored AS(
SELECT	r.CUSTOMERNAME,
		r.recency,
		r.frequency,
		r.monetary,
		-- R_Score: Recency nhỏ là tốt
		CASE
			WHEN r.recency <= q.r_25 THEN 4
			WHEN r.recency <= q.r_50 THEN 3
			WHEN r.recency <= q.r_75 THEN 2
			ELSE 1
		END AS R_Score,

		-- F_Score: Frequency lớn là tốt
		CASE
			WHEN r.frequency <= q.f_25 THEN 1
			WHEN r.frequency <= q.f_50 THEN 2
			WHEN r.frequency <= q.f_75 THEN 3
			ELSE 4
		END AS F_Score,

		-- M_Score: Monetary lớn là tốt
		CASE
			WHEN r.monetary <= q.m_25 THEN 1
			WHEN r.monetary <= q.m_50 THEN 2
			WHEN r.monetary <= q.m_75 THEN 3
			ELSE 4
		END AS M_Score
FROM rfm_base r
CROSS JOIN quartiles q
),
 rfm_final AS (
SELECT	*,
		CAST(R_SCORE AS VARCHAR) + CAST(F_SCORE AS VARCHAR) + CAST(M_SCORE AS VARCHAR) AS RFM_SCORE,
		CASE 
			WHEN R_Score = 4 AND F_Score >= 3 AND M_Score = 4 THEN 'VIP'
			WHEN R_Score = 4 AND F_Score >= 3 THEN 'Potential Loyalist'
			WHEN M_Score = 4 THEN 'Big Spender'
			WHEN R_Score = 1 AND F_Score = 1 THEN 'Lost'
			WHEN R_Score IN (1,2) AND F_Score IN (1,2) THEN 'At Risk'
			ELSE 'Others'
		END AS RFM_LEVEL
  FROM	rfm_scored
)
 SELECT * INTO rfm_results FROM rfm_final;

 SELECT *
   FROM rfm_results;