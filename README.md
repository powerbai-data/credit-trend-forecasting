# Credit Trend Forecasting

Time-series analysis of consumer loan risk trends using monthly bad-outcome rates and holdout-based forecast evaluation on 2.2M+ LendingClub records.

## Overview

This project transforms loan-level LendingClub data into a monthly portfolio credit-risk series and evaluates whether short-term risk trends can be forecast using standard univariate time-series methods.

Using 2.2M+ consumer loan records, I aggregated loan outcomes by issue month to build a monthly bad-outcome-rate series and compared four forecasting approaches:

- Naive forecast
- 3-month rolling mean
- Holt’s linear trend
- ARIMA

## Objective

The goal of this project was to assess whether historical bad-outcome rates alone could support short-term credit trend forecasting at the portfolio level.

## Data Preparation

This project builds on a prior SQL-based credit risk pipeline that:

- cleaned and standardized 2M+ loan records
- defined default-related outcome fields
- engineered borrower- and portfolio-level risk features

The forecasting workflow then aggregated the cleaned loan-level data into a monthly modeling table.

## Monthly Risk Series

The main forecast target is:

- **Monthly bad-outcome rate**

Additional monthly portfolio indicators were also tracked to help interpret changes in risk over time, including:

- average interest rate
- average FICO
- average LTI
- share of 60-month loans
- share of lower-grade loans

## Methods

After exploratory time-series analysis, I evaluated four univariate forecasting approaches using holdout-period:

- MAE
- RMSE

I also reviewed ACF and PACF patterns to support low-order ARIMA model selection.

## Key Finding

The main result was that static multi-step forecasts struggled to capture later increases in bad-outcome rates.

This suggests that **portfolio mix shifts and structural changes limited the accuracy of univariate credit trend forecasts**, even when using standard time-series methods.

## Tools

- SQL (MySQL)
- Python
- pandas
- NumPy
- matplotlib
- statsmodels
- scikit-learn

## Project Takeaway

This project shows that loan-level credit data can be transformed into a monthly portfolio risk series for time-series analysis, but also highlights an important practical limitation:

**changes in portfolio structure can materially constrain forecasting accuracy.**
