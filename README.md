# Credit Trend Forecasting

Time-series analysis of consumer loan risk trends using monthly bad-outcome rates, forecasting baselines, and holdout evaluation on 2.2M+ LendingClub records.

## Overview

This project extends a prior credit risk analytics workflow by transforming loan-level LendingClub data into a monthly portfolio credit-risk series and evaluating whether short-term risk trends can be forecast using standard univariate time-series methods.

Using 2.2M+ consumer loan records, I aggregated loan outcomes by issue month to construct a monthly bad-outcome-rate series, then compared four forecasting approaches using holdout-period MAE and RMSE:

- Naive forecast
- 3-month rolling mean
- Holt’s linear trend
- ARIMA

The main finding was that **static multi-step forecasts struggled to capture later upward shifts in bad-outcome rates**, suggesting that **portfolio mix shifts and structural changes constrained forecasting accuracy**.

## Business Question

Can monthly portfolio credit-risk trends be forecast reliably using historical bad-outcome rates alone?

More specifically:
- How did monthly bad-outcome rates evolve over time?
- Do simple and statistical forecasting models capture short-term credit-risk movement?
- What do forecast limitations suggest about changes in portfolio composition and underlying risk structure?

## Dataset

- **Source:** LendingClub accepted loans dataset
- **Volume:** 2.2M+ consumer loan records
- **Period used for forecasting series:** 2007–2018 raw issue-month coverage
- **Modeling window after filtering:** 2007-10 to 2017-12

This project uses a cleaned and engineered analytics table built from a prior SQL-based credit risk pipeline.

## Prior Data Preparation

Before forecasting, the raw loan-level data was prepared in SQL through a separate credit risk analytics workflow:

- Imported and staged 2M+ LendingClub loan records
- Standardized nulls and converted date / percentage / numeric fields
- Engineered credit-risk features such as:
  - `term_months`
  - `fico_mid`
  - `credit_history_months`
  - `loan_to_income`
  - `loan_to_income_capped`
- Mapped raw `loan_status` values into analysis-ready outcome fields:
  - `is_default`
  - `loan_outcome` (`Good`, `Bad`, `Exclude`)

This forecasting project starts from the final clean table and aggregates it into a monthly time series.

## Forecast Target

The target variable is:

**Monthly bad-outcome rate by issue month**

\[
\text{bad outcome rate}_t = \frac{\sum \text{is\_default}}{\text{loan count}}
\]

This represents the share of loans issued in a given month that were ultimately labeled as bad outcomes under the project’s risk definition.

## Monthly Aggregation

Loan-level records were aggregated into a monthly modeling table with the following variables:

- `loan_count`
- `bad_count`
- `bad_outcome_rate`
- `avg_int_rate`
- `avg_fico`
- `avg_lti`
- `share_60m`
- `share_low_grade`

### Why portfolio mix variables were included

The project tracked not only risk rates, but also shifts in portfolio structure over time.

- **share_60m** = share of loans with 60-month term
- **share_low_grade** = share of loans in lower credit grades (D–G)

These variables helped interpret whether changes in monthly risk were driven purely by time-series behavior or partly by changes in portfolio composition.

## Modeling Scope and Filters

To improve series quality before forecasting:

- Months with very low sample counts were removed
- Late months likely affected by label maturity were excluded
- The final model-ready monthly series covered **122 months**
- Final modeling range: **2007-10-01 to 2017-12-01**

These steps helped reduce:
- instability from very small monthly samples
- distortion from incomplete bad-outcome realization in the latest issue months

## Exploratory Findings

### 1. Bad-outcome rates were not stable over time
The monthly series showed:
- an early high-risk period
- a lower and flatter middle period
- a later upward shift in risk levels

This suggested that the series was **not strongly stationary** and likely affected by changing credit conditions and portfolio structure.

### 2. Loan volume changed materially over time
Monthly loan counts increased sharply in later years, indicating that risk trends should be interpreted together with changing origination volume.

### 3. Portfolio composition also shifted over time
The share of 60-month loans and lower-grade loans changed across periods, supporting the view that changes in portfolio mix likely influenced the risk series.

## Forecasting Methods

I compared four univariate forecasting approaches:

### 1. Naive forecast
Uses the most recent observed value as the next forecast.

### 2. 3-month rolling mean
Uses the average of the most recent 3 observed months.

### 3. Holt’s linear trend
Models both level and trend in the series.

### 4. ARIMA
Tested low-order ARIMA candidates after reviewing ACF/PACF:
- ARIMA(1,1,0)
- ARIMA(0,1,1)
- ARIMA(1,1,1)
- ARIMA(2,1,1)

## Evaluation

Models were evaluated using a holdout-period split and the following metrics:

### MAE
Mean Absolute Error

\[
MAE = \frac{1}{n}\sum |y_t - \hat{y}_t|
\]

Measures the average absolute forecast error.

### RMSE
Root Mean Squared Error

\[
RMSE = \sqrt{\frac{1}{n}\sum (y_t - \hat{y}_t)^2}
\]

Penalizes larger misses more heavily than MAE.

## Time-Series Diagnostics

I reviewed:

- line plots of monthly bad-outcome rate
- rolling means
- ACF
- PACF

These diagnostics suggested:
- clear persistence in the series
- weak evidence of strong seasonality
- trend / regime-like changes that made long-horizon forecasting more difficult

This supported the use of low-order non-seasonal models rather than more complex seasonal specifications.

## Results

The main takeaway from the static holdout evaluation was:

- simple univariate forecasting methods captured broad movement only weakly
- long-horizon forecasts failed to capture the later upward shift in bad-outcome rates
- more advanced specifications provided limited improvement over simple baselines

In other words, **forecasting accuracy was constrained by portfolio mix shifts and structural changes**, not just by model choice.

## Key Takeaway

This project shows that:

- loan-level credit data can be transformed into a monthly portfolio risk series for monitoring
- univariate time-series methods can provide a structured forecasting benchmark
- but risk trends are not driven by time dependence alone
- changing portfolio composition and structural shifts can materially limit forecast accuracy

## Tools Used

- **SQL (MySQL)** for monthly aggregation and prior risk-table construction
- **Python**
  - pandas
  - NumPy
  - matplotlib
  - statsmodels
  - scikit-learn metrics

## Repository Structure

```bash
.
├── README.md
├── notebooks/
│   └── trend_forecasting.ipynb
├── sql/
│   └── monthly_aggregation.sql
├── figures/
│   ├── monthly_bad_outcome_rate.png
│   ├── monthly_loan_count.png
│   ├── portfolio_mix_over_time.png
│   └── forecast_comparison.png
└── data/
    └── (not included / sample only)
