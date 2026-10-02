-- =========================================================================
-- queries.sql
-- Project 1 | SQL: From Data to Insight
-- Team: Bright Jaato
-- Dataset: CO2 Reduction Electrocatalyst Dataset - Malek et al. (2021)
--
-- This file contains the SQL queries used to answer the main research
-- questions and explore additional patterns in the CO2RR dataset.
-- =========================================================================

-- ============================================================
-- Research Question 1
-- How do Faradaic efficiency and current density vary across
-- catalyst-product combinations in the low-temperature dataset?
-- ============================================================

-- Hypothesis:
-- Catalyst-product combinations will show different average
-- Faradaic efficiencies and current densities.

-- Finding:
-- Performance varied widely across the 37 catalyst-product combinations.
-- Average Faradaic efficiency ranged from about 10.52% to 89.49%,
-- while average current density ranged from about 93.43 to 873.40 mA/cm2.

-- PSEUDOCODE:
-- 1. Start from the low-temperature experiment table.
-- 2. Join catalysts so catalyst IDs become readable names.
-- 3. Join products so product IDs become readable names.
-- 4. Group experiments by catalyst and product.
-- 5. Calculate the number of records, average Faradaic efficiency,
--    and average current density for each combination.
-- 6. Sort by average Faradaic efficiency from highest to lowest.

SELECT
    c.catalyst_name,
    p.product_name,
    COUNT(*) AS experiment_count,
    ROUND(AVG(l.faradaic_efficiency_pct), 2) AS avg_faradaic_efficiency_pct,
    ROUND(AVG(l.current_density_ma_cm2), 2) AS avg_current_density_ma_cm2
FROM low_temp_experiments AS l
JOIN catalysts AS c
    ON l.catalyst_id = c.catalyst_id
JOIN products AS p
    ON l.product_id = p.product_id
GROUP BY
    c.catalyst_name,
    p.product_name
ORDER BY
    avg_faradaic_efficiency_pct DESC;
	
	-- Detailed report:
-- Catalyst-product combinations showed substantial variation in both
-- Faradaic efficiency and current density. Average Faradaic efficiency
-- ranged from 10.52% for Pd-CH4 to 89.49% for Ir-C2H5OH, while average
-- current density ranged from 93.43 mA/cm2 for C-CH4 to 873.40 mA/cm2
-- for Au-C2H5OH. Ir-HCOOH combined relatively high average Faradaic
-- efficiency (84.22%) with high current density (713.44 mA/cm2).
-- However, several highly ranked combinations were represented by only
-- one or two observations, so the rankings should be interpreted
-- descriptively rather than as definitive performance comparisons.

-- =========================================================================
-- Research Question 2
-- Which catalyst-product combinations combine above-average
-- Faradaic efficiency and current density with below-average
-- reported cost in the low-temperature dataset?
-- =========================================================================

-- Hypothesis:
-- Only some catalyst-product combinations will combine
-- above-average Faradaic efficiency, above-average current density,
-- and below-average reported catalyst cost.

-- Finding:
-- Four catalyst-product combinations met all three criteria:
-- Ir-HCOOH, Ag-CO, Cu-CO, and Ag-H2.


-- PSEUDOCODE:
-- 1. Group experiments by catalyst and product.
-- 2. Calculate the average Faradaic efficiency, current density,
--    and reported cost for each catalyst-product combination.
-- 3. Compare each group's averages with the overall dataset averages.
-- 4. Keep only combinations that have:
--      - above-average Faradaic efficiency,
--      - above-average current density,
--      - below-average reported cost.
-- 5. Rank the remaining combinations by Faradaic efficiency.

SELECT
    c.catalyst_name,
    p.product_name,
    COUNT(*) AS experiment_count,
    ROUND(AVG(l.faradaic_efficiency_pct), 2) AS avg_faradaic_efficiency_pct,
    ROUND(AVG(l.current_density_ma_cm2), 2) AS avg_current_density_ma_cm2,
    ROUND(AVG(l.cost_usd_per_tco2), 2) AS avg_cost_usd_per_tco2
FROM low_temp_experiments AS l
JOIN catalysts AS c
    ON l.catalyst_id = c.catalyst_id
JOIN products AS p
    ON l.product_id = p.product_id
GROUP BY
    c.catalyst_name,
    p.product_name
HAVING
    AVG(l.faradaic_efficiency_pct) >
        (SELECT AVG(faradaic_efficiency_pct)
         FROM low_temp_experiments)

    AND AVG(l.current_density_ma_cm2) >
        (SELECT AVG(current_density_ma_cm2)
         FROM low_temp_experiments)

    AND AVG(l.cost_usd_per_tco2) <
        (SELECT AVG(cost_usd_per_tco2)
         FROM low_temp_experiments)
ORDER BY
    avg_faradaic_efficiency_pct DESC,
    avg_current_density_ma_cm2 DESC;

	
	-- Detailed report:
-- Only four catalyst-product combinations met all three criteria of
-- above-average Faradaic efficiency, above-average current density,
-- and below-average reported cost. Ir-HCOOH showed the highest average
-- Faradaic efficiency among the qualifying combinations (84.22%) together
-- with a high average current density of 713.44 mA/cm2 and an average
-- reported cost of 2745.48 USD/tCO2. Ag-CO also showed strong performance
-- (78.16% FE; 686.37 mA/cm2) and was supported by five observations,
-- making it one of the more consistently represented combinations in
-- this filtered set.

-- =========================================================================
-- Research Question 3
-- How does total current density vary across catalyst-electrolyte
-- combinations in the second experimental dataset?
-- =========================================================================

-- Hypothesis:
-- Total current density will vary across catalyst-electrolyte combinations.

-- Finding:
-- Ni-YSZ / YSZ showed the highest average total current density
-- at about 446.03 mA/cm2, followed by Ni-YSZ / CGO-YSZ
-- at about 412.02 mA/cm2.

-- PSEUDOCODE:
-- 1. Start from the second experimental dataset.
-- 2. Join catalysts to obtain readable catalyst names.
-- 3. Join electrolytes to obtain readable electrolyte names.
-- 4. Group records by catalyst-electrolyte combination.
-- 5. Calculate the number of observations and summary statistics
--    for total current density.
-- 6. Sort combinations from highest to lowest average current density.

SELECT
    c.catalyst_name,
    e.electrolyte_name,
    COUNT(*) AS experiment_count,
    ROUND(AVG(s.total_current_density_ma_cm2), 2)
        AS avg_total_current_density_ma_cm2,
    ROUND(MIN(s.total_current_density_ma_cm2), 2)
        AS min_total_current_density_ma_cm2,
    ROUND(MAX(s.total_current_density_ma_cm2), 2)
        AS max_total_current_density_ma_cm2
FROM second_experiments AS s
JOIN catalysts AS c
    ON s.catalyst_id = c.catalyst_id
JOIN electrolytes AS e
    ON s.electrolyte_id = e.electrolyte_id
GROUP BY
    c.catalyst_name,
    e.electrolyte_name
ORDER BY
    avg_total_current_density_ma_cm2 DESC;
	
	-- Detailed report:
-- Total current density varied substantially across catalyst-electrolyte
-- combinations. Ni-YSZ with YSZ showed the highest average total current
-- density (446.03 mA/cm2; n = 39), followed by Ni-YSZ with CGO-YSZ
-- (412.02 mA/cm2; n = 22). Considerable within-group variation was also
-- observed; for example, Ni-YSZ with YSZ ranged from 0.42 to
-- 865.02 mA/cm2. Ag/C also showed different average current densities
-- with different electrolytes (215.45 mA/cm2 with KOH-Nafion-K2SO4
-- versus 109.14 mA/cm2 with KHCO3-Sustanion-PTFE), supporting analysis
-- at the catalyst-electrolyte combination level. These differences are
-- descriptive and should not be interpreted as evidence of a causal
-- electrolyte effect.

-- =========================================================================
-- Research Question 4
-- How are catalyst, electrolyte, and total current density distributed
-- across the distinct temperature groups in the second experimental dataset?
-- =========================================================================

-- Hypothesis:
-- The low- and high-temperature groups will contain different
-- catalyst-electrolyte systems and different current-density patterns.

-- Finding:
-- The highest average-current-density systems appeared in the
-- high-temperature group. However, the catalyst-electrolyte systems
-- represented in the low- and high-temperature groups were different,
-- so the result does not show that temperature alone caused the difference.

-- Temperature thresholds reflect the two distinct clusters observed
-- during EDA: approximately 25–100 °C and 750–900 °C.


-- PSEUDOCODE:
-- 1. Start from the second experimental dataset.
-- 2. Join catalyst and electrolyte lookup tables.
-- 3. Use CASE to assign each experiment to a temperature group.
-- 4. Group by temperature group, catalyst, and electrolyte.
-- 5. Count records and calculate average total current density.
-- 6. Sort temperature groups in logical order:
--    low, intermediate, high.
-- 7. Within each temperature group, rank combinations by
--    average total current density.

SELECT
    CASE
        WHEN s.temperature_c <= 100 THEN 'Low temperature'
        WHEN s.temperature_c >= 750 THEN 'High temperature'
        ELSE 'Intermediate temperature'
    END AS temperature_group,

    c.catalyst_name,
    e.electrolyte_name,

    COUNT(*) AS experiment_count,

    ROUND(
        AVG(s.total_current_density_ma_cm2),
        2
    ) AS avg_total_current_density_ma_cm2

FROM second_experiments AS s

JOIN catalysts AS c
    ON s.catalyst_id = c.catalyst_id

JOIN electrolytes AS e
    ON s.electrolyte_id = e.electrolyte_id

GROUP BY
    temperature_group,
    c.catalyst_name,
    e.electrolyte_name

ORDER BY
    CASE temperature_group
        WHEN 'Low temperature' THEN 1
        WHEN 'Intermediate temperature' THEN 2
        WHEN 'High temperature' THEN 3
    END,
    avg_total_current_density_ma_cm2 DESC;
	
-- Detailed report:
-- The low- and high-temperature groups contained clearly different
-- catalyst-electrolyte systems and different current-density patterns.
-- The highest average total current densities were observed in the
-- high-temperature group for Ni-YSZ/YSZ (446.03 mA/cm2; n = 39)
-- and Ni-YSZ/CGO-YSZ (412.02 mA/cm2; n = 22). In the low-temperature
-- group, the highest average current density was observed for
-- Ag/C with KOH-Nafion-K2SO4 at 215.45 mA/cm2 (n = 12).
-- However, the catalyst-electrolyte compositions differ substantially
-- between the temperature groups, so these differences should be
-- interpreted descriptively and not as evidence that temperature
-- alone caused the change in current density.

-- =========================================================================
-- Supporting Query 5
-- Which catalyst-product combinations show the highest
-- average selectivity in the low-temperature dataset?
-- =========================================================================

-- Purpose:
-- This query provides additional insight into product selectivity
-- across catalyst-product combinations.

-- PSEUDOCODE:
-- 1. Start from the low-temperature experiment table.
-- 2. Join catalyst and product names.
-- 3. Group records by catalyst-product combination.
-- 4. Calculate the average selectivity for each combination.
-- 5. Count how many observations support each average.
-- 6. Rank combinations from highest to lowest average selectivity.

SELECT
    c.catalyst_name,
    p.product_name,
    COUNT(*) AS experiment_count,
    ROUND(AVG(l.selectivity_pct), 2) AS avg_selectivity_pct
FROM low_temp_experiments AS l

JOIN catalysts AS c
    ON l.catalyst_id = c.catalyst_id

JOIN products AS p
    ON l.product_id = p.product_id

GROUP BY
    c.catalyst_name,
    p.product_name

ORDER BY
    avg_selectivity_pct DESC;
	
	-- Detailed report:
-- Average selectivity varied widely across catalyst-product combinations,
-- ranging from 2.35% for Pd-CH4 to 99.79% for Au-C2H5OH. Several of
-- the highest-ranked combinations, including Au-C2H5OH, Ir-C2H5OH,
-- Ir-CO, and Sn-HCOOH, were represented by only one observation.
-- Among combinations supported by multiple observations, Cu-H2 showed
-- a high average selectivity of 83.45% (n = 3), while Cu-HCOOH reached
-- 74.63% (n = 4). The rankings should therefore be interpreted together
-- with experiment_count rather than using average selectivity alone.

-- =========================================================================
-- Supporting Query 6
-- How does overall electrochemical performance vary by catalyst
-- in the low-temperature dataset?
-- =========================================================================

-- Purpose:
-- This query summarizes catalyst-level performance across all
-- low-temperature experiments.

-- PSEUDOCODE:
-- 1. Start from the low-temperature experiment table.
-- 2. Join catalyst names.
-- 3. Group all records by catalyst.
-- 4. Count the number of experiments for each catalyst.
-- 5. Calculate average Faradaic efficiency and current density.
-- 6. Calculate minimum and maximum Faradaic efficiency.
-- 7. Rank catalysts by average Faradaic efficiency.

SELECT
    c.catalyst_name,
    COUNT(*) AS experiment_count,
    ROUND(AVG(l.faradaic_efficiency_pct), 2)
        AS avg_faradaic_efficiency_pct,
    ROUND(AVG(l.current_density_ma_cm2), 2)
        AS avg_current_density_ma_cm2,
    ROUND(MIN(l.faradaic_efficiency_pct), 2)
        AS min_faradaic_efficiency_pct,
    ROUND(MAX(l.faradaic_efficiency_pct), 2)
        AS max_faradaic_efficiency_pct
FROM low_temp_experiments AS l

JOIN catalysts AS c
    ON l.catalyst_id = c.catalyst_id

GROUP BY
    c.catalyst_name

ORDER BY
    avg_faradaic_efficiency_pct DESC;
	
	-- Detailed report:
-- Overall catalyst-level performance varied across the low-temperature
-- dataset. Ir showed the highest average Faradaic efficiency at 73.11%
-- (n = 7), while Ag showed the highest average current density at
-- 555.45 mA/cm2 (n = 18). Pt also showed a relatively high average
-- current density of 517.27 mA/cm2 (n = 19). Because these catalyst-level
-- averages combine different products and operating conditions, they
-- should be interpreted as descriptive summaries rather than as evidence
-- that one catalyst is universally superior.

-- =========================================================================
-- Supporting Query 7
-- How does electrochemical performance vary by product
-- in the low-temperature dataset?
-- =========================================================================

-- Purpose:
-- This query summarizes performance at the product level across
-- all low-temperature experiments.

-- PSEUDOCODE:
-- 1. Start from the low-temperature experiment table.
-- 2. Join product names.
-- 3. Group all records by product.
-- 4. Count the number of experiments for each product.
-- 5. Calculate average Faradaic efficiency and current density.
-- 6. Calculate minimum and maximum Faradaic efficiency.
-- 7. Rank products by average Faradaic efficiency.

SELECT
    p.product_name,
    COUNT(*) AS experiment_count,
    ROUND(AVG(l.faradaic_efficiency_pct), 2)
        AS avg_faradaic_efficiency_pct,
    ROUND(AVG(l.current_density_ma_cm2), 2)
        AS avg_current_density_ma_cm2,
    ROUND(MIN(l.faradaic_efficiency_pct), 2)
        AS min_faradaic_efficiency_pct,
    ROUND(MAX(l.faradaic_efficiency_pct), 2)
        AS max_faradaic_efficiency_pct
FROM low_temp_experiments AS l

JOIN products AS p
    ON l.product_id = p.product_id

GROUP BY
    p.product_name

ORDER BY
    avg_faradaic_efficiency_pct DESC;
	
	-- Detailed report:
-- Product-level performance showed different patterns for Faradaic
-- efficiency and current density. CO had the highest average Faradaic
-- efficiency at 60.34% (n = 26), whereas C2H5OH had the highest average
-- current density at 574.39 mA/cm2 (n = 13) but the lowest average
-- Faradaic efficiency among the five products at 49.62%. HCOOH, H2,
-- and CH4 showed similar average Faradaic efficiencies of approximately
-- 54-56%. These results indicate that the product associated with the
-- highest average Faradaic efficiency is not necessarily the one
-- associated with the highest average current density.

-- =========================================================================
-- Supporting Query 8
-- Which catalyst-product combinations show the highest
-- reported production rates in the low-temperature dataset?
-- =========================================================================

-- Purpose:
-- This query compares reported production rates across
-- catalyst-product combinations.

-- PSEUDOCODE:
-- 1. Start from the low-temperature experiment table.
-- 2. Join catalyst names.
-- 3. Join product names.
-- 4. Group records by catalyst-product combination.
-- 5. Count the number of observations in each group.
-- 6. Calculate the average, minimum, and maximum production rate.
-- 7. Rank combinations by average production rate.

SELECT
    c.catalyst_name,
    p.product_name,
    COUNT(*) AS experiment_count,
    ROUND(AVG(l.production_rate_m3_hr), 2)
        AS avg_production_rate_m3_hr,
    ROUND(MIN(l.production_rate_m3_hr), 2)
        AS min_production_rate_m3_hr,
    ROUND(MAX(l.production_rate_m3_hr), 2)
        AS max_production_rate_m3_hr
FROM low_temp_experiments AS l

JOIN catalysts AS c
    ON l.catalyst_id = c.catalyst_id

JOIN products AS p
    ON l.product_id = p.product_id

GROUP BY
    c.catalyst_name,
    p.product_name

ORDER BY
    avg_production_rate_m3_hr DESC;
	
	-- Detailed report:
-- Reported production rate varied substantially across catalyst-product
-- combinations. C-CH4 showed the highest average production rate
-- (9773.48 m3/hr), although this value was based on only one observation.
-- Among combinations represented by multiple records, Pd-C2H5OH
-- averaged 7899.57 m3/hr (n = 2), Ir-HCOOH averaged 7653.35 m3/hr
-- (n = 2), and Pt-CH4 averaged 6770.32 m3/hr (n = 5).
-- Several combinations also showed wide within-group ranges; for example,
-- Pt-CH4 ranged from 1864.06 to 9981.33 m3/hr. Production-rate rankings
-- should therefore be interpreted together with experiment_count and
-- within-group variability.

-- =========================================================================
-- Supporting Query 9
-- How are voltage and Faradaic efficiency reported across
-- records in the second experimental dataset?
-- =========================================================================

-- Purpose:
-- This query checks whether voltage and Faradaic efficiency are
-- reported together or in complementary subsets of records.

-- PSEUDOCODE:
-- 1. Count all records in the second experimental dataset.
-- 2. Count records reporting voltage only.
-- 3. Count records reporting Faradaic efficiency only.
-- 4. Count records reporting both variables.
-- 5. Count records reporting neither variable.
-- 6. Calculate percentages for the main reporting patterns.

SELECT
    COUNT(*) AS total_records,

    SUM(
        CASE
            WHEN voltage_v IS NOT NULL
                 AND faradaic_efficiency_pct IS NULL
            THEN 1
            ELSE 0
        END
    ) AS voltage_only_count,

    ROUND(
        100.0 * SUM(
            CASE
                WHEN voltage_v IS NOT NULL
                     AND faradaic_efficiency_pct IS NULL
                THEN 1
                ELSE 0
            END
        ) / COUNT(*),
        2
    ) AS voltage_only_pct,

    SUM(
        CASE
            WHEN voltage_v IS NULL
                 AND faradaic_efficiency_pct IS NOT NULL
            THEN 1
            ELSE 0
        END
    ) AS faradaic_efficiency_only_count,

    ROUND(
        100.0 * SUM(
            CASE
                WHEN voltage_v IS NULL
                     AND faradaic_efficiency_pct IS NOT NULL
                THEN 1
                ELSE 0
            END
        ) / COUNT(*),
        2
    ) AS faradaic_efficiency_only_pct,

    SUM(
        CASE
            WHEN voltage_v IS NOT NULL
                 AND faradaic_efficiency_pct IS NOT NULL
            THEN 1
            ELSE 0
        END
    ) AS both_reported_count,

    SUM(
        CASE
            WHEN voltage_v IS NULL
                 AND faradaic_efficiency_pct IS NULL
            THEN 1
            ELSE 0
        END
    ) AS neither_reported_count

FROM second_experiments;

-- Detailed report:
-- The second experimental dataset contains 181 records with a fully
-- complementary reporting pattern between voltage and Faradaic efficiency.
-- Voltage was reported without Faradaic efficiency in 76 records (41.99%),
-- while Faradaic efficiency was reported without voltage in 105 records
-- (58.01%). No records reported both variables, and no records omitted both.
-- This shows a highly structured reporting pattern in the source data
-- rather than isolated missing values.

-- =========================================================================
-- Supporting Query 10
-- Which catalyst-electrolyte combinations are represented
-- in each temperature group of the second experimental dataset?
-- =========================================================================

-- Purpose:
-- This query shows the composition of each temperature group and
-- calculates the share of each catalyst-electrolyte combination
-- within that group.

-- PSEUDOCODE:
-- 1. Start from the second experimental dataset.
-- 2. Join catalyst and electrolyte names.
-- 3. Use CASE to assign each record to a temperature group.
-- 4. Group by temperature group, catalyst, and electrolyte.
-- 5. Count how many records belong to each combination.
-- 6. Calculate each combination's share within its temperature group.
-- 7. Sort by temperature group and record count.

WITH grouped_data AS (
    SELECT
        CASE
            WHEN s.temperature_c <= 100 THEN 'Low temperature'
            WHEN s.temperature_c >= 750 THEN 'High temperature'
            ELSE 'Intermediate temperature'
        END AS temperature_group,

        c.catalyst_name,
        e.electrolyte_name,
        COUNT(*) AS record_count

    FROM second_experiments AS s

    JOIN catalysts AS c
        ON s.catalyst_id = c.catalyst_id

    JOIN electrolytes AS e
        ON s.electrolyte_id = e.electrolyte_id

    GROUP BY
        temperature_group,
        c.catalyst_name,
        e.electrolyte_name
)

SELECT
    temperature_group,
    catalyst_name,
    electrolyte_name,
    record_count,

    ROUND(
        100.0 * record_count /
        SUM(record_count) OVER (
            PARTITION BY temperature_group
        ),
        2
    ) AS percentage_within_temperature_group

FROM grouped_data

ORDER BY
    CASE temperature_group
        WHEN 'Low temperature' THEN 1
        WHEN 'Intermediate temperature' THEN 2
        WHEN 'High temperature' THEN 3
    END,
    record_count DESC;
	
	-- Detailed report:
-- The catalyst-electrolyte composition differed substantially between
-- the low- and high-temperature groups. In the high-temperature group,
-- Ti/Li2O-Li2CO3 accounted for 40.20% of records, Ni-YSZ/YSZ for
-- 38.24%, and Ni-YSZ/CGO-YSZ for 21.57%. In contrast, the low-
-- temperature group contained six different Ag- or Au-based
-- catalyst-electrolyte combinations, with Ag/KK2SO4-KHCO3-ZrO2-
-- K2SO4-KHCO3 representing the largest share at 30.38%.
-- Because catalyst-electrolyte composition changes with temperature
-- group, differences between the groups should not be attributed to temperature alone.