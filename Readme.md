🌦️ Delhi Monthly Temperature Forecasting (1942–2025)
📌 Project Overview

This project builds an end-to-end time series forecasting pipeline to predict monthly average temperatures for Delhi, India, using historical climate data from NOAA.

The project demonstrates:

Real-world data engineering on AWS

Strong baseline vs ML comparison

Production-style forecast evaluation

🧠 Problem Statement

Accurately forecasting temperature is crucial for:

Climate analysis

Urban planning

Energy demand estimation

The challenge is to model long-term seasonality and handle missing historical periods in real-world climate data.

📊 Dataset

Source: NOAA Global Historical Climatology Network (GHCN)

Granularity: Daily → Aggregated to Monthly

Time Range: 1942 – 2025

Location: Delhi (representative station: IN022021900)

🏗️ Architecture & Workflow
1️⃣ Data Engineering (AWS)

Stored raw NOAA data in Amazon S3

Queried and transformed data using Amazon Athena (SQL)

Aggregated daily temperatures into monthly averages

Created clean train/test splits (last 24 months as test)

2️⃣ Baseline Forecasting

Implemented two classical baselines:

Naive baseline (last observed value)

Moving average forecast

These baselines establish a minimum performance benchmark.

3️⃣ Machine Learning Forecasting

Used Facebook Prophet to model:

Strong yearly seasonality

Long-term temperature trends

Irregular gaps in historical data

📈 Model Evaluation
Model MAE RMSE
Naive Baseline 6.57 9.06
Prophet 1.11 1.42

✅ Prophet reduced error by ~80%, clearly outperforming the baseline.

📉 Visualizations

Monthly temperature trends (1942–2025)

Prophet forecast with confidence intervals

Actual vs predicted comparison on test data

🛠️ Tech Stack

AWS S3 – Data storage

Amazon Athena – SQL analytics

Python – Data processing

Pandas, NumPy – Analysis

Facebook Prophet – Time series forecasting

Matplotlib – Visualization

📁 Project Structure
weather-forecasting-delhi/
│
├── sql/
│   └── athena_queries.sql        # All Athena SQL (data engineering)
│
├── notebooks/
│   └── delhi_weather_forecasting.ipynb
│       # EDA + Baselines + Prophet ML (single notebook)
│
├── data/
│   └── prophet_train_delhi.csv   # Exported train data from Athena
│
└── README.md


🧪 Key Learnings

Real climate data is messy and incomplete

Baselines are critical before applying ML

Prophet excels when seasonality is strong

Cloud SQL + local ML is a powerful workflow


👤 Author

Auchitya Singh
Aspiring Data Scientist | Data Analytics | Time Series Forecasting
