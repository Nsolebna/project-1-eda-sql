"""
Project 1 | SQL: From Data to Insight
Team: Bright Jaato
Dataset: CO2 Reduction Electrocatalyst Dataset - Malek et al. (2021)

Reusable functions for the CO2RR data analysis project.

This module contains small functions used for cleaning data,
creating lookup tables, and running SQL queries.
"""

"""
Reusable functions for the CO2RR data analysis project.

This module contains small functions used for cleaning data,
creating lookup tables, and running SQL queries.
"""

from pathlib import Path
import sqlite3
import pandas as pd


# -------------------------------------------------------------------------
# Project paths
# -------------------------------------------------------------------------

ROOT = Path(__file__).resolve().parents[1]
RAW = ROOT / "data" / "raw"
CLEAN = ROOT / "data" / "clean"
DB = ROOT / "data" / "project.db"


def clean_data(df):
    """
    Clean a DataFrame by:
    - making a copy
    - removing completely empty rows
    - removing spaces at the beginning and end of text values

    Parameters
    ----------
    df : pandas.DataFrame
        DataFrame to clean.

    Returns
    -------
    pandas.DataFrame
        Cleaned copy of the DataFrame.
    """

    # PSEUDOCODE
    # 1. Make a copy so the original DataFrame stays unchanged.
    # 2. Remove rows where every value is empty.
    # 3. Find the text columns.
    # 4. Remove extra spaces from text values.
    # 5. Return the cleaned DataFrame.

    cleaned_df = df.copy()

    cleaned_df = cleaned_df.dropna(how="all")

    text_columns = cleaned_df.select_dtypes(include="object").columns

    for column in text_columns:
        cleaned_df[column] = cleaned_df[column].str.strip()

    return cleaned_df


def make_lookup(df, column, id_column):
    """
    Create a lookup table from a categorical column.

    Parameters
    ----------
    df : pandas.DataFrame
        DataFrame containing the categorical column.

    column : str
        Name of the categorical column.

    id_column : str
        Name of the new ID column.

    Returns
    -------
    pandas.DataFrame
        Lookup table containing unique category values and IDs.
    """

    # PSEUDOCODE
    # 1. Take the selected categorical column.
    # 2. Remove missing values.
    # 3. Keep each category only once.
    # 4. Sort the categories for consistency.
    # 5. Assign a unique numerical ID.
    # 6. Return the lookup table.

    unique_values = (
        df[column]
        .dropna()
        .drop_duplicates()
        .sort_values()
        .reset_index(drop=True)
    )

    lookup_table = pd.DataFrame({
        id_column: range(1, len(unique_values) + 1),
        column: unique_values
    })

    return lookup_table


def run_query(sql, db_path=DB):
    """
    Run a SQL query against the SQLite database.

    Parameters
    ----------
    sql : str
        SQL query to execute.

    db_path : Path or str
        Path to the SQLite database.

    Returns
    -------
    pandas.DataFrame
        Query results.
    """

    # PSEUDOCODE
    # 1. Open a connection to the SQLite database.
    # 2. Run the SQL query.
    # 3. Store the result in a pandas DataFrame.
    # 4. Close the database connection automatically.
    # 5. Return the result.

    with sqlite3.connect(db_path) as connection:
        result = pd.read_sql_query(sql, connection)

    return result