-- Consumer Credit Trend Forecasting --
DROP TABLE IF EXISTS accepted_monthly_risk;

CREATE TABLE accepted_monthly_risk AS
SELECT
    STR_TO_DATE(DATE_FORMAT(issue_date, '%Y-%m-01'), '%Y-%m-%d') AS issue_month,
    COUNT(*) AS loan_count,
    SUM(is_default) AS bad_count,
    CAST(AVG(is_default) AS DECIMAL(8,6)) AS bad_outcome_rate,
    CAST(AVG(int_rate_num) AS DECIMAL(8,4)) AS avg_int_rate,
    CAST(AVG(fico_mid) AS DECIMAL(8,2)) AS avg_fico,
    CAST(AVG(loan_to_income_capped) AS DECIMAL(10,6)) AS avg_lti,
    CAST(AVG(CASE WHEN term_months = 60 THEN 1 ELSE 0 END) AS DECIMAL(8,6)) AS share_60m,
    CAST(AVG(CASE WHEN grade IN ('D','E','F','G') THEN 1 ELSE 0 END) AS DECIMAL(8,6)) AS share_low_grade
FROM accepted_analytics_final
WHERE is_default IS NOT NULL
  AND issue_date IS NOT NULL
GROUP BY STR_TO_DATE(DATE_FORMAT(issue_date, '%Y-%m-01'), '%Y-%m-%d')
ORDER BY issue_month;

-- Sanity Check --
SELECT 
    COUNT(*) AS n_months,
    MIN(issue_month) AS min_month,
    MAX(issue_month) AS max_month
FROM accepted_monthly_risk;

SELECT *
FROM accepted_monthly_risk
ORDER BY issue_month
LIMIT 12;

SELECT *
FROM accepted_monthly_risk
ORDER BY issue_month DESC
LIMIT 12;

SELECT
    MIN(loan_count) AS min_loan_count,
    MAX(loan_count) AS max_loan_count,
    AVG(loan_count) AS avg_loan_count,

    MIN(bad_outcome_rate) AS min_bad_rate,
    MAX(bad_outcome_rate) AS max_bad_rate,
    AVG(bad_outcome_rate) AS avg_bad_rate,

    MIN(avg_int_rate) AS min_avg_int_rate,
    MAX(avg_int_rate) AS max_avg_int_rate,

    MIN(avg_fico) AS min_avg_fico,
    MAX(avg_fico) AS max_avg_fico,

    MIN(avg_lti) AS min_avg_lti,
    MAX(avg_lti) AS max_avg_lti
FROM accepted_monthly_risk;

SELECT *
FROM accepted_monthly_risk
WHERE loan_count < 100
ORDER BY issue_month;

-- model-ready table --
DROP TABLE IF EXISTS accepted_monthly_risk_model;

CREATE TABLE accepted_monthly_risk_model AS
SELECT
    *,
    CASE WHEN loan_count < 100 THEN 1 ELSE 0 END AS low_volume_flag
FROM accepted_monthly_risk
WHERE issue_month >= '2007-10-01'
  AND issue_month <= '2017-12-01'
ORDER BY issue_month;

SELECT 
    COUNT(*) AS n_months,
    MIN(issue_month) AS min_month,
    MAX(issue_month) AS max_month
FROM accepted_monthly_risk_model;

SELECT *
FROM accepted_monthly_risk_model
ORDER BY issue_month
LIMIT 12;

SELECT *
FROM accepted_monthly_risk_model
ORDER BY issue_month DESC
LIMIT 12;

SELECT *
FROM accepted_monthly_risk_model;