-- ============================================================
-- Project: Delhi Monthly Temperature Forecasting
-- Data Engineering using Amazon Athena (NOAA GHCN)
-- ============================================================


-- ============================================================
-- 1. Database & External Table Setup
-- ============================================================

CREATE DATABASE weather_noaa;

CREATE EXTERNAL TABLE ghcn_daily (
  station STRING,
  date STRING,
  element STRING,
  value INT,
  m_flag STRING,
  q_flag STRING,
  s_flag STRING,
  obs_time STRING
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
LOCATION 's3://noaa-ghcn-pds/csv/';


-- ============================================================
-- 2. Data Validation & Understanding
-- ============================================================

-- Check table schema
DESCRIBE ghcn_daily;

-- Identify available weather elements
SELECT DISTINCT element
FROM ghcn_daily;

-- Count Indian station records
SELECT COUNT(*) AS india_rows
FROM ghcn_daily
WHERE station LIKE 'IN%';


-- ============================================================
-- 3. Station Selection (India → Delhi Representative)
-- ============================================================

-- Find Indian stations with maximum temperature history
SELECT
  station,
  COUNT(*) AS temp_rows
FROM ghcn_daily
WHERE station LIKE 'IN%'
  AND element IN ('TMAX', 'TMIN', 'TAVG')
GROUP BY station
ORDER BY temp_rows DESC
LIMIT 20;

-- Selected station: IN022021900 (longest & most complete history)
SELECT
  station,
  MIN(SUBSTR(date,1,4)) AS start_year,
  MAX(SUBSTR(date,1,4)) AS end_year,
  COUNT(*) AS rows_cnt
FROM ghcn_daily
WHERE station = 'IN022021900'
  AND element IN ('TMAX','TMIN','TAVG')
GROUP BY station;


-- ============================================================
-- 4. Monthly Aggregation (ML-Ready Time Series)
-- ============================================================

SELECT
  SUBSTR(date, 1, 6) AS year_month,
  AVG(value) / 10.0 AS monthly_avg_temperature_c
FROM ghcn_daily
WHERE station = 'IN022021900'
  AND element = 'TAVG'
GROUP BY SUBSTR(date, 1, 6)
ORDER BY year_month;


-- ============================================================
-- 5. Time-Aware Train / Test Split
-- Last 24 months reserved for testing (no leakage)
-- ============================================================

WITH monthly AS (
  SELECT
    SUBSTR(date, 1, 6) AS year_month,
    AVG(value) / 10.0 AS monthly_avg_temperature_c
  FROM ghcn_daily
  WHERE station = 'IN022021900'
    AND element = 'TAVG'
  GROUP BY SUBSTR(date, 1, 6)
),
ranked AS (
  SELECT
    year_month,
    monthly_avg_temperature_c,
    ROW_NUMBER() OVER (ORDER BY year_month DESC) AS rn
  FROM monthly
)
SELECT
  year_month,
  monthly_avg_temperature_c,
  CASE
    WHEN rn <= 24 THEN 'test'
    ELSE 'train'
  END AS data_split
FROM ranked
ORDER BY year_month;


-- ============================================================
-- 6. Persist Clean Dataset to S3 (Parquet, CTAS)
-- ============================================================

CREATE TABLE weather_noaa.monthly_delhi_baseline
WITH (
  format = 'PARQUET',
  external_location = 's3://weather-forecasting-raw-auchitya/processed/monthly_delhi/'
) AS
WITH monthly AS (
  SELECT
    SUBSTR(date, 1, 6) AS year_month,
    AVG(value) / 10.0 AS monthly_avg_temperature_c
  FROM ghcn_daily
  WHERE station = 'IN022021900'
    AND element = 'TAVG'
  GROUP BY SUBSTR(date, 1, 6)
),
ranked AS (
  SELECT
    year_month,
    monthly_avg_temperature_c,
    ROW_NUMBER() OVER (ORDER BY year_month DESC) AS rn
  FROM monthly
)
SELECT
  year_month,
  monthly_avg_temperature_c,
  CASE
    WHEN rn <= 24 THEN 'test'
    ELSE 'train'
  END AS data_split
FROM ranked;


-- ============================================================
-- 7. Baseline Forecast Evaluation (SQL-Side)
-- ============================================================

-- Naive baseline (last observed value)
SELECT
  AVG(ABS(monthly_avg_temperature_c - 31.116129032258065)) AS mae,
  SQRT(AVG(POW(monthly_avg_temperature_c - 31.116129032258065, 2))) AS rmse
FROM weather_noaa.monthly_delhi_baseline
WHERE data_split = 'test';


-- ============================================================
-- 8. Moving Average Baseline (12-Month)
-- ============================================================

WITH test_data AS (
  SELECT
    year_month,
    monthly_avg_temperature_c
  FROM weather_noaa.monthly_delhi_baseline
  WHERE data_split = 'test'
),
train_data AS (
  SELECT
    year_month,
    monthly_avg_temperature_c
  FROM weather_noaa.monthly_delhi_baseline
  WHERE data_split = 'train'
),
ma_forecast AS (
  SELECT
    t.year_month,
    t.monthly_avg_temperature_c AS actual_temperature_c,
    (
      SELECT AVG(monthly_avg_temperature_c)
      FROM train_data
      WHERE year_month < t.year_month
        AND year_month >= CAST(CAST(t.year_month AS INTEGER) - 100 AS VARCHAR)
    ) AS moving_avg_forecast_c
  FROM test_data t
)
SELECT
  AVG(ABS(actual_temperature_c - moving_avg_forecast_c)) AS mae,
  SQRT(AVG(POW(actual_temperature_c - moving_avg_forecast_c, 2))) AS rmse
FROM ma_forecast
WHERE moving_avg_forecast_c IS NOT NULL;


-- ============================================================
-- 9. Export Train Data for Prophet (ML)
-- ============================================================

SELECT
  CAST(DATE_PARSE(year_month || '01', '%Y%m%d') AS DATE) AS ds,
  monthly_avg_temperature_c AS y
FROM weather_noaa.monthly_delhi_baseline
WHERE data_split = 'train'
ORDER BY ds;
