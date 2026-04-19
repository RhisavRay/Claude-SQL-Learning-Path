/*
CTEs — Common Table Expressions

A CTE is a named temporary result set defined at the top of a query using WITH. Think of it as giving a subquery a name so you can reference it
cleanly, like a variable.

The same derived table query from earlier:
*/

-- With a derived table:
SELECT brand, avg_price
FROM (
    SELECT brand, AVG(price_inr) AS avg_price
    FROM bikes
    GROUP BY brand
) AS brand_averages
WHERE avg_price > 400000;

-- With a CTE:
WITH brand_averages AS (
    SELECT brand, AVG(price_inr) AS avg_price
    FROM bikes
    GROUP BY brand
)
SELECT brand, avg_price
FROM brand_averages
WHERE avg_price > 400000;

-- Same result. The CTE version reads top to bottom like a story — first define what brand_averages is, then query it.





/*
Multiple CTEs chain with commas:
*/

WITH 
cte_one AS (
    SELECT ...
),
cte_two AS (
    SELECT ... FROM cte_one ...  -- can reference previous CTEs
)
SELECT * FROM cte_two;




/*
Task 3 — CTEs:

3a. Rewrite the 1a solution (bikes priced above their type's average) using a CTE instead of a derived table.
*/




/*
3b. Write a query using two CTEs that:
    First CTE: calculates each customer's total spend (using the discount formula from earlier)
    Second CTE: calculates the average total spend across all customers
    Final query: returns customers whose total spend is above the average
*/

