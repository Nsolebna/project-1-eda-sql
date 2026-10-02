-- =========================================================================
-- schema.sql
-- Project 1 | SQL: From Data to Insight
-- Team: Bright Jaato
-- Dataset: CO2 Reduction Electrocatalyst Dataset - Malek et al. (2021)
-- =========================================================================

-- Enable foreign-key enforcement in SQLite.
PRAGMA foreign_keys = ON;

-- Remove existing child tables before parent tables
-- so the schema can be rerun safely.
DROP TABLE IF EXISTS second_experiments;
DROP TABLE IF EXISTS low_temp_experiments;
DROP TABLE IF EXISTS electrolytes;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS catalysts;

-- =========================================================================
-- Lookup tables
-- =========================================================================

CREATE TABLE catalysts (
    catalyst_id INTEGER PRIMARY KEY,
    catalyst_name TEXT NOT NULL UNIQUE
);

CREATE TABLE products (
    product_id INTEGER PRIMARY KEY,
    product_name TEXT NOT NULL UNIQUE
);

CREATE TABLE electrolytes (
    electrolyte_id INTEGER PRIMARY KEY,
    electrolyte_name TEXT NOT NULL UNIQUE
);

-- =========================================================================
-- Experiment tables
-- =========================================================================

CREATE TABLE low_temp_experiments (
    experiment_id INTEGER PRIMARY KEY,
    catalyst_id INTEGER NOT NULL,
    product_id INTEGER NOT NULL,
    cost_usd_per_tco2 REAL NOT NULL,
    applied_potential_v REAL NOT NULL,
    faradaic_efficiency_pct REAL NOT NULL,
    current_density_ma_cm2 REAL NOT NULL,
    selectivity_pct REAL NOT NULL,
    production_rate_m3_hr REAL NOT NULL,

    FOREIGN KEY (catalyst_id)
        REFERENCES catalysts(catalyst_id),

    FOREIGN KEY (product_id)
        REFERENCES products(product_id)
);

CREATE TABLE second_experiments (
    experiment_id INTEGER PRIMARY KEY,
    catalyst_id INTEGER NOT NULL,
    product_id INTEGER NOT NULL,
    electrolyte_id INTEGER NOT NULL,
    voltage_v REAL,
    total_current_density_ma_cm2 REAL NOT NULL,
    faradaic_efficiency_pct REAL,
    temperature_c INTEGER NOT NULL,

    FOREIGN KEY (catalyst_id)
        REFERENCES catalysts(catalyst_id),

    FOREIGN KEY (product_id)
        REFERENCES products(product_id),

    FOREIGN KEY (electrolyte_id)
        REFERENCES electrolytes(electrolyte_id)
);

-- =========================================================================
-- Optional indexes for faster joins
-- =========================================================================

CREATE INDEX idx_low_temp_catalyst
ON low_temp_experiments(catalyst_id);

CREATE INDEX idx_low_temp_product
ON low_temp_experiments(product_id);

CREATE INDEX idx_second_catalyst
ON second_experiments(catalyst_id);

CREATE INDEX idx_second_product
ON second_experiments(product_id);

CREATE INDEX idx_second_electrolyte
ON second_experiments(electrolyte_id);