# Delhi Monthly Temperature Forecasting

A time-series forecasting project for predicting monthly average temperatures in Delhi using historical NOAA climate data, AWS-based data preparation, and Prophet modeling.

## Project Overview

This project builds an end-to-end forecasting workflow that starts with historical weather data and ends with model evaluation against a simple baseline.

The pipeline includes:

- data preparation using AWS services
- monthly aggregation of historical temperature records
- baseline forecasting for comparison
- Prophet-based forecasting for improved predictive performance

## Problem Statement

Accurate temperature forecasting is useful for climate analysis, planning, and demand estimation. The main challenge in this project is handling long-term seasonality while working with historical data that can be incomplete or irregular.

## Dataset

- Source: NOAA Global Historical Climatology Network
- Location: Delhi, India
- Time range: 1942 to 2025
- Granularity: daily records aggregated into monthly averages

## Tech Stack

- AWS S3
- Amazon Athena
- Python
- pandas
- NumPy
- Prophet
- Matplotlib

## Workflow

1. Store raw climate data in Amazon S3
2. Query and transform data with Amazon Athena
3. Aggregate daily records into monthly averages
4. Create a leakage-safe train and test split
5. Compare baseline forecasts with Prophet
6. Evaluate model performance using MAE and RMSE

## Results

The Prophet model significantly outperformed the baseline forecast and showed strong performance for a seasonal time-series problem.

Example reported results:

- Naive baseline RMSE: 9.06
- Prophet RMSE: 1.42

## Repository Structure

```text
Readme.md
weather forcasting/
  DATA/
    prophet_train_delhi.csv
  notebook/
    delhi_wea_forcasting.ipynb
  SQL/
    athena_queries.sql
```

## What This Project Demonstrates

- time-series forecasting with business context
- baseline-versus-model evaluation
- cloud-based data preparation using AWS
- practical use of Prophet for long-term seasonal trends
- end-to-end analytical workflow from data engineering to prediction
