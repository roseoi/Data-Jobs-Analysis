# Data-Jobs-Analysis
A reproducible data analysis project (Python + SQL + Power BI) that analyzes job market datasets and demonstrates data cleaning, exploratory analysis, SQL modelling, and interactive reporting.
# DataJobsAnalysis

A public end-to-end data analytics project showcasing **Python**, **SQL**, and **Power BI** skills using a job-market dataset. This repository demonstrates data cleaning, exploratory analysis, SQL modeling, and interactive dashboard design—built to highlight practical, portfolio-ready data analytics capabilities.

**One-line:** A reproducible data analysis project (Python + SQL + Power BI) that analyzes job market datasets and demonstrates data cleaning, exploratory analysis, SQL modelling, and interactive reporting.

---

## Contents of this repository

```
/ (root)
├─ README.md                <-- (this file)
├─ data/                    <-- small sample data (CSV) — *DO NOT commit sensitive/raw full datasets*
├─ notebooks/
│  └─ datajobsanalysis.ipynb <-- main analysis notebook (Python)
├─ src/
│  └─ analysis.py           <-- optional script version of notebook
├─ sql/
│  ├─ schema.sql            <-- table DDL for demo database
│  ├─ transforms.sql        <-- SQL transformations & CTEs
│  └─ examples.sql          <-- example queries (joins, window functions)
├─ powerbi/
│  ├─ DataJobsReport.pbix   <-- Power BI Desktop file (optional, large)
│  └─ screenshots/          <-- exported images of report (PNG/PDF)
├─ requirements.txt         <-- Python dependencies
├─ .gitignore
└─ .github/workflows/       <-- optional: CI (e.g., run tests / convert notebook)
```

---

## Project overview

This repository contains an end-to-end example of: loading and cleaning job-related datasets with Python (Jupyter notebook), exploring and modelling data with SQL, and building an interactive Power BI report. The goal is to demonstrate core data engineering / analytics skills you can showcase on GitHub and in interviews.

---

## Quick start (local)

1. **Clone the repo**

```bash
git clone https://github.com/<your-username>/DataJobsAnalysis.git
cd DataJobsAnalysis
```

2. **Create a virtual environment & install dependencies**

```bash
python -m venv .venv
source .venv/bin/activate   # macOS / Linux
.venv\Scripts\activate     # Windows (PowerShell)

pip install -r requirements.txt
```

Suggested `requirements.txt` (put this file in repo):

```
pandas
numpy
jupyterlab
matplotlib
sqlalchemy
sqlite3
ipython-sql
nbconvert
```

3. **Open the notebook**

```bash
jupyter lab notebooks/datajobsanalysis.ipynb
```

4. **Run the notebook** — follow the sections: data loading → cleaning → EDA → modelling → export results.

---


## References & Acknowledgements

This project draws inspiration from publicly available learning materials, including:

* **Luke Barousse – SQL for Data Analytics**
  Source: [https://www.lukebarousse.com/sql](https://www.lukebarousse.com/sql)
  Accessed: 2025-11-26
