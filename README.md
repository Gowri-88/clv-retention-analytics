Customer Lifetime Value & Churn Analytics

Overview

End-to-end analytics pipeline designed to quantify customer value, identify churn risk, and simulate retention impact using SQL transformation, Excel scenario modeling, and Power BI visualization.

Dataset: IBM Telco Customer Churn (Kaggle)

---

Business Objective

Organizations face revenue leakage due to customer churn.
This project builds a decision-support workflow to:

- Segment customers by lifetime value
- Quantify churn exposure
- Estimate recoverable revenue
- Model retention strategy ROI

---

Tech Stack

- SQL — Data cleaning, feature engineering, segmentation
- Excel — Scenario modeling and forecast simulation
- Power BI — Executive decision dashboard
- GitHub — Version control

---

Pipeline Architecture

1. Raw ingestion and validation
2. Data cleaning & feature engineering
3. CLV computation
4. Quartile segmentation
5. Churn concentration analysis
6. Revenue risk estimation
7. Retention scenario simulation
8. Dashboard storytelling

Key Analytical Outcomes

- Customer base segmented into four CLV tiers
- Churn risk concentration identified in low-value cohorts
- Revenue exposure quantified by contract structure
- Retention strategies modeled for incremental CLV recovery
---

Dashboard Highlights

- Segment value distribution
- Churn rate diagnostics
- Revenue vs churn loss comparison
- Retention strategy impact simulation

---

Repository Structure

data/ -> Source dataset
sql/  -> Data engineering scripts
excel/ -> Forecast model
powerbi -> Dashboard file
images/ -> Visualization Screenshots
---

Screenshots

CLV Overview

"Page1" (images/page1.png)

Retention Analysis

"Page2" (images/page2.png)

Strategy Simulation

"Page3" (images/page3.png)


---