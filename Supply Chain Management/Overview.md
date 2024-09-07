# Comprehensive Supply Chain Strategy for Ampicillin Delivery in Chennai 

## Project Overview

This project is dedicated to crafting a **cost-effective supply chain strategy** for the distribution of **Ampicillin** to the people of **Chennai**, ensuring that it is accessible to all socioeconomic classes. By addressing the intricacies of pharmaceutical distribution throughout, the goal is to optimize costs while maintaining high-quality healthcare standards.

The data for this project was collected from a local pharmacy, and the manufacturing data reflects this specific pharmacy's operations rather than company-wide data.

For an in-depth analysis and the development of the mathematical models used, please explore the details of my [project](https://drive.google.com/file/d/1o-VWM3CXqsH7KAjNRYN_PLMT2Md5Pbpi/view?usp=sharing).

### Techniques Used ###
- Functions: `PARSENAME`, `REPLACE`, `ROUND`
- Indexing
- Recursive CTE: `WITH` clause, `UNION ALL`
- `VIEW` Creation
- Logarithmic Functions
- Variable Declaration: `DECLARE`, `SET`
- Mathematical Functions
- Temporary Table
- Rscursive / Common Table Expressions (CTEs)
- `MIN` Function
- Z-Score Calculation

### Analyses Highlights:

For the formulas used in these analyses and their explanations, please refer to Formulas_Explained.md. This document provides a detailed briefing on each topic and the key methods approached via SQL.

🔹 **Data Cleaning**: 
- Utilized the `PARSENAME` and `REPLACE` function to extract and handle specific parts of the data. This was particularly useful for separating components within a column, such as Year and Month into multiple segments.

- Used the `ROUND` function to standardize cost values to a consistent decimal format. This helped in maintaining accuracy and consistency in financial data representation.

- Created an index to improve query performance and speed up data retrieval. `Indexing` was used to optimize the efficiency of data access and enhance overall query execution times.

🔹 **Break-Even Analysis**:  
- The break-even point *(BEP)* is the moment where revenue equals costs exactly. At this moment, neither a profit nor a loss has been made. Sales beyond that amount generate profit, while sales below that amount generate a loss.
- Utilized the `WITH` clause to create a `Recursive CTE` named br for generating a sequence of units. The `UNION ALL` operator was used to recursively generate unit values.
- Used SQL updates to populate *Variable_cost, Selling_price, and Fixed_cost columns* in the table based on data from the SCM..other_details table, joined on specific codes.
- Developed a `VIEW` named BEP to visualize the break-even data, including a calculated Total_cost.

🔹 **Cumulative Work Hours**: 
- Measuring the total labor required throughout the entire supply chain to ensure efficiency. 
Production work hours decrease by a certain percentage each time the quantity produced
 doubles. It is referred to as the cumulative average work hours model. In the project I used 90% progress rate.
- Variables were declared using the `DECLARE` statement, to store the *progress rate, work hours per unit, and demand values*. These variables are used in the calculation to ensure accurate results.
- The progress rate of *90%* was calculated using `logarithmic` functions to determine how work hours decrease as production volume increases.
- Queried the SCM..manufacturer table to display the *Month, Year, Demand*, and calculated Work_Hours based on the cumulative work hours formula.

🔹 **Manufacturer Decision Models**:  
- It is crucial to ensure that pharmaceuticals and raw materials are always available and 
properly managed while keeping costs in check. Long-term storage of drugs can lead to waste, so manufacturing should begin at 
the optimal time to avoid excessive inventory and meet demand efficiently. This model aids in determining the procurement 
levels and quantities that minimize overall costs. 
- `Mathematical functions` were used to optimize the query performance

🔸 **Replacement Analysis**: 
- It's crucial to evaluate drugs for failures and replace them as needed. Group replacements might be advantageous, as they can lower transportation and purchasing costs due to bulk pricing. This analysis aims to identify the group with the lowest replacement cost, considering each manufacturer's bulk pricing rates.
- Added a new column Day_0 and updated it with 0. Added additional columns for daily *success rates* (day_s0 to day_s6), calculating the difference in demand over time.
- Created a `temporary table` #xt to store failure probabilities and replacement values for each day.
- Used `Common Table Expressions` (CTEs) to compute the probability of failure (p_t) and replacement quantities (finding_xt), summing the replacements over time (yt).
- Compared total costs for each day to identify the minimum cost of replacement and selected relevant columns and the minimum cost from the computed values using `MIN` function.

🔸 **Safety Stock**: 
- Safety stock is extra inventory kept to prevent stockouts caused by unexpected demand or supply delays.
- `@service_level` is set to 1.64, representing the z-score for a 95% service level.

This project effectively employed SQL techniques to optimize the supply chain strategy for Ampicillin delivery in Chennai. By leveraging data cleaning methods, Recursive CTEs, and various mathematical functions, we achieved a thorough analysis of break-even points, cumulative work hours, manufacturer decisions, and replacement costs. The integration of safety stock calculations ensured that we addressed demand and supply uncertainties, resulting in a streamlined and cost-effective supply chain strategy.
