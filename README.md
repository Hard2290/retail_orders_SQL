# Retail Orders - Data Analysis - SQL
- Dataset on Kaggle - https://www.kaggle.com/datasets/ankitbansal06/retail-orders
- The dataset contains 2022 and 2023 Global Mart sales which can be downloaded from kaggle as a csv file.

## Problem Statement :
- Analyse the sales dataset for the year 2022 and 2023 and write SQL queries to derive various insights out of it.

## Tools used :
- Python - Coding Language
- Pandas - For Data Processing
- Anaconda - For package and environment management
- SQLAlchemy - For creating connection to SQL server
- SQL Server management Studio - For SQL queries

## Preprocessing:
- Utilized Kaggle API within Jupyter (Anaconda environment) to download and manage the dataset.
- Read the dataset while mentioning entries 'Not Available' and 'unknown' as missing values( NA values).
- Renamed columns to lowercase with underscore instead of whitespaces to make it convenient to use while writing queries.
- Created 3 new features "discount", "sale_price" and "profit" using "discount_percent", "list_price" and "cost_price" features.
- Dropped "discount_percent", "list_price" and "cost_price" features from the dataset.
- Corrected data type of feature "order_date" from "Object" to "Datetime64"

## Data Importing:
- Using SQLAlchemy to create connection to SQL server using ODBC driver, loaded the data into SQL server.

## Data Analysis:
- Created Table "df_orders" and appended data from the csv file to it thus preventing allocation of space more than required.
- Analyzed the data by answering the following:
