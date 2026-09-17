# Data Projects Portfolio

This repository houses my most notable data projects. All of these projects are from coursework in my Master of Data Science. These projects contain a variance of data analysis, data science (building, tuning, comparing models), and data engineering (Database design, ETL, document design).

## Project Overview

| Project | Description | Technologies | Key Deliverable |
|---------|-------------|--------------|-----------------|
| Spotify_Track_Popularity | Predictive classification model identifying factors driving song popularity across genres | Python, scikit-learn, statsmodels | Classification model + analysis |
| Soccer_Goalscoring_Database | Relational database (4NF) capturing professional soccer statistics with optimized schema design | SQL, Database Design (4NF) | Normalized relational schema |
| Star Schema Redesign | Converted relational database to star-schema for easier analysis | SQL, Database Design | Star Schema Database, schema diagram
|
| ETL_and_MongoDB_Migration | Extracted, transformed, and loaded a relational database and migrated to NoSQL | Python, PyMySQL, PyMongo, MongoDB | MongoDB implementation 
|
| PySpark_Predictive_Modeling | Comparative analysis of decision tree, random forest, and logistic regression | PySpark, ML algorithms | Model comparison + performance metrics 
| Web_Logs_w_Apache | Web log analysis of search queries using Apache Pig on a Hadoop cluster | MapReduce, Apache Pig, Hadoop Clustering | Pig scripts, terminal screenshots, document report
|
| DataStory_Salaries | Data analysis of salary figures for Allegheny County | Python, pandas, matplotlib.pyplot, seaborn | Data Story in Jupyter notebook

## Project Details

### 1. Spotify Track Popularity
**Folder:** `/Spotify_prediction`

**Overview:** This was a full EDA and classification predictive model I built on a dataset to determine factors contributing to a Spotify song's popularity.

**Technologies:** Python, scikit-learn, statsmodels

**Key Files:**
- `Spotify_Track_Popularity.ipynb` — Full analysis and model development


---

### 2. Soccer Goalscoring Database
**Folder:** `/Soccer_Database`

**Overview:** This project required me to find a dataset, design a relational schema, then build that schema out by loading it into the database with SQL queries.

**Technologies:** SQL, Database Design

**Key Files:**
- `DML.sql` - Full loading in of spreadsheet data into relational database
- `DDL.sql` — Changes made to database and creation of view statement
- `Query.sql/` — Sample SQL scripts demonstrating functionality
- `Physical_Diagram.png` — Physical schema design
- `project_goalscorers` - Modified spreadsheet of initial data; kept only 100 rows for project


---

### 3. Star Schema Redesign
**Folder:** `/Star_Schema_Redesign`

**Overview:** This project required me to redesign a normalized relational database into a star schema design. While this project didn't call for it, this would be in order to allow simpler analysis.

**Technologies:** SQL, Database Design

**Key Files:**
- `star_schema.sql` - The creation of my tables and relationships for the star schema
- `etl_star_migration.sql` — The loading of data into the star schema
- `integrity_checks.sql` — Validation checks to ensure the migration was successful.
- `schema_diagram.png` — Full diagram of my star schema design


---

### 4. ETL_and_MongoDB_Migration
**Folder:** `/MongoDB_Migration`

**Overview:** This project required me to convert a relational database into a document format and load it into MongoDB.

**Technologies:** Python, PyMySQL, PyMongo, MongoDB 

**Key Files:**
- `ETL_and_MongoDB_Migration.ipynb` - Full notebook including entire ETL and MongoDB migration.

---
### 5. PySpark Predictive Models
**Folder:** `/pyspark_models`

**Overview:** This project required me to use PySpark to create models predicting how likely a person is to get a loan given certain features. I built and compared three models with each other: decision trees, random forest, and logistic regression.

**Technologies:** PySpark, Decision Trees, Random Forest, Logistic Regression

**Key Files:**
- `Pyspark_Predictive_Model.py` — Full model development
- `output.txt/` — Comparison of the three models.

---

### 6. Web_Logs_w_Apache
**Folder:** `/Web_Log_Analysis_w_Apache`

**Overview:** This project required me to develop Pig Latin scripts on a Hadoop cluster to analyze online search queries.

**Technologies:** MapReduce, Apache Pig, Hadoop Clustering

**Key Files:**
- `browser.pig` - Browser popularity analysis script
- `browser.jpg` - Screenshot of results from corresponding pig script
- `freq.pig` - Search frequency analysis script
- `freq.jpg` - Screenshot of results from corresponding pig script
- `ref.pig` - Referrer analysis script
- `ref.jpg` - Screenshot of results from corresponding pig script
- `user.pig` - User analysis script
- `user.jpg` - Screenshot of results from corresponding pig script

---

### 7. Data Story
**Folder:** `/DataStory`

**Overview:** This project required me to create a narrative data story on a given dataset. I chose to use salary information from Allegheny County.

**Technologies:** Python, pandas, matplotlib.pyplot, seaborn

**Key Files:**
- `DataStory_Salaries`

---

## Skills Demonstrated

- **Data Analysis & Storytelling:** SQL querying, statistical analysis, visualization
- **Machine Learning:** Classification modeling, model evaluation, algorithm comparison
- **Database Design:** Schema normalization (4NF), star schema architecture, NoSQL migration
- **Big Data Tools:** PySpark
- **Languages:** Python, SQL, Pig


## How to Use This Repository

If you want to run any notebooks locally:
1. Clone the repo
2. Install dependencies:
3. Set environment variables (see individual project folders for details)
4. Open notebooks in Jupyter Lab
Note: Notebooks with PyMYSL and PyMongo connections cannot be replicated by another user.

---
