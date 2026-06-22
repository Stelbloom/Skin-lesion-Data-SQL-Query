# DermAI Diagnostics – SQL Skin Lesion Analytics Capstone

> **From raw clinical tables to AI‑ready skin cancer insights.**

This repository contains my SQL capstone project analysing the **DermAI Diagnostics** skin lesion dataset. It shows how I:

- Design and query a **clinic‑style relational schema** (patients + lesions)
- Use **SQL for exploratory analysis** of risk factors and lesion characteristics
- Build an **AI‑ready dataset** that can feed directly into machine learning models for skin cancer detection

This project demonstrates my ability to:

- Translate a medical problem into a **structured data model**
- Write **complex, readable SQL** with joins, window functions, and feature logic
- Think in terms of **features and labels** for downstream ML – not just dashboards

---

## 🩺 Business Context – DermAI Diagnostics

**DermAI Diagnostics** is a fictional-but-realistic startup focused on **early detection of skin cancer**.

- Skin cancer is common and potentially life‑threatening, but **early detection** drastically improves survival.
- Many patients face **delayed diagnosis** due to misdiagnosis, limited access to dermatologists, or poor understanding of environmental and demographic risk factors.
- DermAI combines **clinical dermatology data**, **environmental exposures**, and **AI‑based tools** to support dermatologists and researchers.

This project focuses on the **SQL backbone** of that vision: taking a raw skin lesion dataset and turning it into a **queryable, analysable, and model‑ready database**.

---

## 🧱 Data Model & Tables

The dataset contains **1,089 skin lesions**, modelled using two core tables:

### 1. `Patient_Info` (table1)

Each row describes a patient’s **demographics and background risk factors**.

Key columns:

- `patient_id` – unique patient identifier (primary key)
- `age` – age of the patient
- `gender` – MALE / FEMALE
- `smoke` – patient smokes (TRUE/FALSE)
- `drink` – patient drinks alcohol (TRUE/FALSE)
- `pesticide` – exposed to pesticides (TRUE/FALSE)
- `background_father`, `background_mother` – paternal and maternal ethnicity
- `skin_cancer_history` – previous skin cancer diagnosis (TRUE/FALSE)
- `cancer_history` – family history of cancer (TRUE/FALSE)
- `has_piped_water`, `has_sewage_system` – access to infrastructure (TRUE/FALSE)

### 2. `Lesion_Info` (table2)

Each row describes a **skin lesion** observed on a patient.

Key columns:

- `lesion_id` – unique lesion identifier (primary key)
- `patient_id` – foreign key to `Patient_Info`
- `fitspatrick` – Fitzpatrick skin type (1–6)
- `region` – body region of the lesion
- `diameter_1`, `diameter_2` – lesion size measurements (mm)
- `diagnostic` – lesion diagnosis (e.g. **MEL**, **BCC**, **SCC**, **NEV**, etc.)
- Symptom flags: `itch`, `grew`, `hurt`, `changed`, `bleed`, `elevation` (TRUE/FALSE)
- `img_id` – associated image ID
- `biopsed` – biopsy‑confirmed (TRUE/FALSE)

Together these tables support **rich analysis** of:

- Behaviour & demographics → `age`, `gender`, `smoke`, `drink`, `ethnicity`, `pesticide`
- Clinical symptoms → `itch`, `grew`, `changed`, `bleed`, etc.
- Lesion outcomes → `diagnostic` (cancerous vs. benign)

---

## 🎯 Project Goals

1. **Clinical analytics with SQL**  
   Explore how lifestyle, environment, and demographics link to different lesion types.

2. **Pattern discovery for early detection**  
   Use SQL to identify combinations of symptoms and risk factors that correlate with malignant lesions.

3. **ML‑ready dataset**  
   Design a **single, joined table** with clean features and an explicit target label for use in Python machine learning.

4. **Learning focus**  
   Demonstrate advanced use of SQL: joins, group‑bys, window functions, conditional aggregation, and basic feature engineering directly in queries.

---

## 🔎 Analytical Questions

I structured the SQL work around realistic clinical & ML questions:

### Lifestyle & Demographics

- What is the overall **smoking** and **drinking** rate in the cohort?
- How does **age** vary across lifestyle habits (smoke/drink combinations)?
- How are **gender** and **ethnicity** distributed across risk factors and lesion outcomes?

### Diagnostic Patterns

- How many distinct **diagnostic lesion types** exist (`diagnostic`)?
- What is the **overall distribution** of lesion types (BCC, MEL, SCC, NEV, etc.)?
- How do lesion types break down by **gender**, **Fitzpatrick type**, and **body region**?

### Environmental & Infrastructure Risk

- How does **pesticide exposure** affect the probability of malignant lesions?
- Are patients **without piped water or sewage** at higher risk for certain lesion types?

### Clinical Symptom Signals

- How often do malignant lesions **bleed**, **grow**, **itch**, **hurt**, or **change**?
- Which **body regions** have the highest proportion of malignant diagnoses?
- How does the combination of **grew + changed** affect malignancy rate?

These questions are answered with a series of **incrementally more complex queries**, building towards a final **ML feature table**.

---

## 🧮 Example SQL Analyses

> Note: in the SQL scripts, `table1` = `Patient_Info` and `table2` = `Lesion_Info`.

### 1. Cohort Lifestyle Snapshot

Compute overall smoking and drinking rates:

```sql
SELECT 
    smoke, 
    COUNT(*) AS total_smokers,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 2) AS percentage
FROM table1
GROUP BY smoke;

SELECT 
    drink, 
    COUNT(*) AS total_drinkers,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 2) AS percentage
FROM table1
GROUP BY drink;
```

### 2. Diagnostic Distribution & Malignancy Focus

Count distinct lesion types and their distribution:

```sql
-- Number of unique diagnostic lesion types
SELECT COUNT(DISTINCT diagnostic) AS distinct_diagnostic
FROM table2;

-- Overall distribution of diagnostic types
SELECT 
    diagnostic,
    COUNT(*) AS count_diagnostic,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 2) AS percentage
FROM table2
GROUP BY diagnostic;
```

### 3. Symptom‑Driven Malignancy Risk

Estimate malignancy rate (MEL/BCC/SCC) by growth, bleeding, region, etc.:

```sql
-- Does "grew" correlate with malignancy?
SELECT grew,
       COUNT(*) AS total_cases,
       SUM(CASE WHEN diagnostic IN ('MEL', 'BCC') THEN 1 ELSE 0 END) AS cancer_cases,
       ROUND(100.0 * SUM(CASE WHEN diagnostic IN ('MEL', 'BCC') THEN 1 ELSE 0 END) / COUNT(*), 2)
           AS cancer_rate_percent
FROM table2
GROUP BY grew;

-- Body regions with highest cancer rate
SELECT region,
       COUNT(*) AS total_cases,
       SUM(CASE WHEN diagnostic IN ('MEL', 'BCC') THEN 1 ELSE 0 END) AS cancer_cases,
       ROUND(100.0 * SUM(CASE WHEN diagnostic IN ('MEL', 'BCC') THEN 1 ELSE 0 END) / COUNT(*), 2)
           AS cancer_rate_percent
FROM table2
GROUP BY region
ORDER BY cancer_rate_percent DESC;
```

These queries mimic how a clinician or data scientist would **probe the data for signal** before building any model.

---

## 🧩 ML‑Ready Feature Table (Concept)

The capstone also defines a **joined, enriched table** suitable as input to a machine learning model.

Design principles:

- **Row = one lesion** (i.e. one potential cancer case)
- **Columns = features** from both patient and lesion tables (demographics, lifestyle, environment, symptoms, etc.)
- **Label**: `is_malignant` = 1 if `diagnostic` in (MEL, BCC, SCC), else 0

Example structure:

- Patient features: `age`, `gender`, `smoke`, `drink`, `pesticide`, `skin_cancer_history`, `cancer_history`, `background_father`, `background_mother`, `has_piped_water`, `has_sewage_system`
- Lesion features: `fitspatrick`, `region`, `diameter_1`, `diameter_2`, `itch`, `grew`, `hurt`, `changed`, `bleed`, `elevation`, `biopsed`
- Target: `diagnostic`, `is_malignant`

This feature design makes the database output **plug‑and‑play** for Python libraries like `pandas` and `scikit‑learn`.

---

## 📁 Repository Structure

A suggested structure for this project:

```text
.
├── data/
│   ├── dermai_patient_info.csv
│   └── dermai_lesion_info.csv
├── sql/
│   ├── CapstoneprojectSQL.sql          # Full query library
│   └── ml_feature_table.sql            # (Optional) ML-ready SELECT / VIEW
├── notebooks/
│   └── 01_sql_to_ml_pipeline.ipynb     # Python: load from DB and train model
├── reports/
│   ├── SQL_Capstone.pdf
│   └── SQL_CAPSTONE_PROJECT_slides.pptx
└── README.md
```

You can adapt this to match your actual file and folder names.

---

## 🖼 EDA Visuals in SQL

![Diagnostic Distribution](reports/figures/diagnostic_distribution.png)
*Overall distribution of lesion diagnostic types (MEL, BCC, SCC, NEV, etc.).*

![Malignancy by Symptom](reports/figures/malignancy_by_symptom.png)
*Malignancy rate by clinical symptoms such as growth, bleeding, and colour change.*

![Risk by Lifestyle & Environment](reports/figures/lifestyle_environment_risk.png)
*Smoking, drinking, pesticide exposure, and basic infrastructure plotted against malignant lesion rate.*

![Fitzpatrick & Region Risk Map](reports/figures/fitzpatrick_region_risk.png)
*Heatmap of cancer risk across skin types and body regions.*
```


---

## 🧰 Tech Stack

- **Database / Query**: SQL (joins, window functions, conditional aggregation)
- **Data Model**: two‑table clinical schema (`Patient_Info`, `Lesion_Info`)
- **Analysis**: SQL scripts + supporting PDF / slide deck
- **Machine Learning (downstream)**: Python, pandas, scikit‑learn (via exported feature table)

---

## 🚀 In order to recreate this project, you can clone it by or you can also reach out to me for collaboration

1. **Set up the database**  
   - Create `Patient_Info` and `Lesion_Info` tables (schema based on the data dictionary).  
   - Import the CSVs or raw data into these tables.

2. **Run core analysis queries**  
   - Use `CapstoneprojectSQL.sql` to explore lifestyle, environmental, demographic, and clinical patterns.

3. **Generate ML‑ready features**  
   - Use the ML feature query (or view) to export a single table where each row is a lesion with engineered features and a binary malignancy label.

4. **Train models in Python**  
   - Load the feature table into pandas (via `read_sql` or CSV export).
   - Perform encoding, scaling, and modelling with scikit‑learn.

---

## 📬 Contact

If you’re interested in **clinical data analytics, SQL‑driven feature engineering, or AI for healthcare**, feel free to reach out.

- **Author**: Ugwunwa Stella 
- **Role**: SQL & analytics for medical AI use cases

> ** In Summary :** This project is more than a set of SELECTs – it shows my ability to design a schema, ask clinically meaningful questions, build complex analytical SQL, and think explicitly about how to hand off clean features to machine learning pipelines.
