🌦️ Delhi Monthly Temperature Forecasting (1942–2025)
📌 Project Overview

This project builds an end-to-end time series forecasting pipeline to predict monthly average temperatures for Delhi, India, using historical climate data from NOAA.

The project demonstrates:

Real-world data engineering on AWS

Strong baseline vs machine learning comparison

Production-style forecast evaluation

🧠 Problem Statement

Accurately forecasting temperature is crucial for:

Climate analysis

Urban planning

Energy demand estimation

The key challenge is to model long-term seasonality while handling missing and irregular historical climate data.

📊 Dataset

Source: NOAA Global Historical Climatology Network (GHCN)

Granularity: Daily → Aggregated to Monthly

Time Range: 1942 – 2025

Location: Delhi (Representative station: IN022021900)

🏗️ Architecture & Workflow
1️⃣ Data Engineering (AWS)

Stored raw NOAA data in Amazon S3

Queried and transformed data using Amazon Athena (SQL)

Aggregated daily temperature records into monthly averages

Created a leakage-safe train/test split (last 24 months as test)

2️⃣ Baseline Forecasting

Implemented classical baseline models:

Naive baseline (last observed value)

Moving average forecast

These baselines establish a minimum performance benchmark before ML.

3️⃣ Machine Learning Forecasting

Used Facebook Prophet to model:

Strong yearly seasonality

Long-term temperature trends

Irregular gaps in historical observations

📈 Model Evaluation
Model MAE RMSE
Naive Baseline 6.57 9.06
Prophet 1.11 1.42

✅ Prophet reduced forecasting error by ~80%, clearly outperforming the baseline models.

📉 Visualizations

Monthly temperature trends (1942–2025)

Prophet forecast with confidence intervals

Actual vs predicted temperature comparison on test data

🛠️ Tech Stack

AWS S3 – Data storage

Amazon Athena – SQL analytics

Python – Data processing & modeling

Pandas, NumPy – Analysis

Facebook Prophet – Time series forecasting

Matplotlib – Visualization

📁 Project Structure
weather-forecasting-delhi/
│
├── sql/
│ └── athena_queries.sql # All Athena SQL (data engineering)
│
├── notebooks/
│ └── delhi_weather_forecasting.ipynb
│ # EDA + Baselines + Prophet ML (single notebook)
│
├── data/
│ └── prophet_train_delhi.csv # Exported train data from Athena
│
└── README.md

🧪 Key Learnings

Real-world climate data is messy and incomplete

Establishing baselines is critical before applying ML

Prophet performs exceptionally well when seasonality is strong

Combining cloud SQL + local ML enables scalable workflows

👤 Author

Auchitya Singh
Aspiring Data Scientist | Data Analytics | Time Series Forecasting
