# CO2 Electroreduction: From Data to Insight

## Project Overview

Electrochemical CO2 reduction, or CO2RR, can convert carbon dioxide into useful chemicals and fuels.

CO2RR performance can vary with the catalyst, electrolyte, temperature, operating conditions, and the product formed.

In this project, I used SQL and Python to organise and analyse literature data on CO2 reduction.

The goal was to compare different CO2RR systems, identify useful patterns, and find promising combinations for further research.

---

## Business / Research Problem

CO2RR involves many possible catalysts, products, electrolytes, and operating conditions.

This makes it difficult to decide which systems should be studied further.

The main question in this project is:

> Which CO2RR systems appear promising enough for further research?

The analysis compares electrochemical performance, reported catalyst cost, and operating conditions to support early-stage research and development decisions.

---

## Dataset

The project uses a literature-based CO2 reduction dataset from Malek et al. (2021).

The original Excel file contains two experimental data sections, which were analysed separately.

### Low-Temperature Dataset

- 101 experimental records
- Includes catalyst, product, reported catalyst cost, applied potential, Faradaic efficiency, current density, selectivity, and production rate

### Second Experimental Dataset

- 181 experimental records
- Includes catalyst, electrolyte, temperature, total current density, voltage, and Faradaic efficiency

---

## Research Questions

1. How do Faradaic efficiency and current density vary across catalyst–product combinations?
2. Which catalyst–product combinations combine above-average Faradaic efficiency, above-average current density, and below-average reported catalyst cost?
3. How does total current density vary across catalyst–electrolyte combinations?
4. How do catalyst–electrolyte systems and current density differ across temperature groups?

---

## Hypotheses

### Hypothesis 1

Catalyst–product combinations will show different Faradaic efficiencies and current densities.

### Hypothesis 2

Only some catalyst–product combinations will combine high Faradaic efficiency, high current density, and lower reported catalyst cost.

### Hypothesis 3

Total current density will vary across catalyst–electrolyte combinations.

### Hypothesis 4

The low- and high-temperature groups will contain different catalyst–electrolyte systems and different current-density patterns.

---

## Project Workflow

The project followed these main steps:

1. Extract the relevant data from the original Excel file.
2. Explore the data and check for missing values, duplicates, and unusual values.
3. Clean and standardise the data.
4. Design a relational database with primary and foreign keys.
5. Load the cleaned data into SQLite.
6. Use SQL to answer the research questions.
7. Visualise and interpret the main findings.

---

## Database Design

The cleaned data were organised into five related tables.

### Lookup Tables

- `catalysts`
- `products`
- `electrolytes`

### Experiment Tables

- `low_temp_experiments`
- `second_experiments`

Primary keys uniquely identify records in each table.

Foreign keys connect the experiment tables to the corresponding catalyst, product, and electrolyte records.

### Entity Relationship Diagram

![Entity Relationship Diagram](images/erd.png)

---

## SQL Analysis

SQL was used to answer the research questions and compare the different CO2RR systems.

The analysis included:

- `JOIN`
- `GROUP BY`
- `HAVING`
- `COUNT`
- `AVG`
- `MIN`
- `MAX`
- subqueries
- `CASE`
- CTEs
- window functions

The complete SQL queries are stored in:

`sql/queries.sql`

---

## Key Findings

### 1. Performance differed across catalyst–product combinations

Faradaic efficiency and current density varied widely across the different catalyst–product combinations.

This shows that a combination with high Faradaic efficiency does not necessarily also have a high current density.

### 2. Only a few combinations met all three screening criteria

Only four catalyst–product combinations had:

- above-average Faradaic efficiency
- above-average current density
- below-average reported catalyst cost

The four combinations were:

- `Ir-HCOOH`
- `Ag-CO`
- `Cu-CO`
- `Ag-H2`

This shows that relatively few combinations performed well across all three criteria at the same time.

### 3. Catalyst and electrolyte should be considered together

Total current density varied across catalyst–electrolyte combinations.

The highest average current densities were observed for:

- `Ni-YSZ / YSZ`
- `Ni-YSZ / CGO-YSZ`

This suggests that catalyst performance should not be considered separately from the electrolyte used with it.

### 4. Temperature-group differences were descriptive

The systems with the highest average current densities were found in the high-temperature group.

However, the low- and high-temperature groups contained different catalyst–electrolyte systems.

Therefore, the analysis does not show that temperature alone caused the difference in current density.

---

## Business / R&D Implications

The analysis can support early-stage research and development decisions.

It can help researchers:

- identify promising catalyst systems
- compare systems using several performance criteria
- reduce the number of systems selected for further testing
- decide where to focus future experimental work

The results do not show which system is ready for commercial use.

Further evaluation would require additional information such as catalyst stability, energy efficiency, long-term performance, scale-up behaviour, and full process cost.

---

## Limitations

The results should be interpreted with care because:

- the data come from different literature studies
- experimental conditions were not always the same
- some catalyst–product groups contain only a small number of observations
- voltage and Faradaic efficiency were not reported together in the second dataset
- catalyst, electrolyte, temperature, and other operating conditions can differ at the same time

Because of these limitations, the analysis identifies patterns and associations in the data but does not prove cause and effect.

---

## Next Steps

Future work could include:

- adding more standardised CO2RR data
- comparing full data distributions instead of only averages
- using larger sample sizes for stronger comparisons
- including catalyst stability and energy-efficiency data
- applying statistical analysis when enough comparable data are available
- applying machine-learning methods to larger and more standardised datasets

---

## Repository Structure

```text
project-1-eda-sql/
│
├── data/
│   ├── raw/
│   ├── clean/
│   └── project.db
│
├── images/
│   ├── erd.drawio
│   ├── erd.png
│   └── project visualisations
│
├── notebooks/
│   ├── 01_eda.ipynb
│   ├── 02_processing.ipynb
│   └── 03_hypothesis_and_visualization.ipynb
│
├── sql/
│   ├── schema.sql
│   └── queries.sql
│
├── src/
│   └── functions.py
│
├── README.md
├── requirements.txt
└── RUBRIC.md
```

---

## How to Run the Project

1. Clone the repository:

```bash
git clone <repository-url>
cd project-1-eda-sql    *NB. This is just a placeholder. I will eventually replace with my actual GitHub repository link.*
```

2. Install the required packages:

```bash
pip install -r requirements.txt
```

3. Run the notebooks in this order:

```text
01_eda.ipynb
02_processing.ipynb
03_hypothesis_and_visualization.ipynb
```

Notebook 02 creates and loads the SQLite database used for the SQL analysis.

---

## Tools Used

- Python
- Pandas
- NumPy
- Matplotlib
- Seaborn
- SQLite
- SQL
- Jupyter Notebook
- DB Browser for SQLite
- draw.io
- Git
- GitHub

---

## References

Malek, A. et al. (2021).  
*A Data-Driven Framework for the Accelerated Discovery of CO2 Reduction Electrocatalysts.*  
Frontiers in Energy Research, 9, 609070.  
https://doi.org/10.3389/fenrg.2021.609070

IPCC. (2021).  
*Climate Change 2021: The Physical Science Basis.*  
Contribution of Working Group I to the Sixth Assessment Report of the Intergovernmental Panel on Climate Change.  
Cambridge University Press.