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

WITH Bikes AS (
    SELECT
        brand,
        model,
        type,
        price_inr
    FROM bikes b1
    WHERE price_inr > (
        SELECT
            AVG(price_inr) AS Average_price
        FROM bikes b2
        WHERE b1.type = b2.type
    )
)
SELECT
    brand,
    model,
    type,
    price_inr
FROM Bikes;

-- Now using multiple CTEs. Basically trying to emulate the JOIN solution I created

WITH
Type_averages AS (
    SELECT
        type,
        AVG(price_inr) AS Average_price
    FROM bikes
    GROUP BY type
),
Bikes AS (
    SELECT
        brand,
        model,
        type,
        price_inr
    FROM bikes
)
SELECT
    b.brand,
    b.model,
    b.type,
    b.price_inr
FROM Bikes b
INNER JOIN Type_averages t
    ON
        b.type = t.type
        AND b.price_inr > t.Average_price;



/*
3b. Write a query using two CTEs that:
    First CTE: calculates each customer's total spend (using the discount formula from earlier)
    Second CTE: calculates the average total spend across all customers
    Final query: returns customers whose total spend is above the average
*/

WITH
Customer_Average AS (
    SELECT
        c.name,
        c.city,
        SUM(b.price_inr * o.quantity * (1 - o.discount / 100)) AS Total_spent
    FROM orders AS o
    INNER JOIN customers AS c
        ON o.customer_id = c.customer_id
    INNER JOIN bikes AS b
        ON o.bike_id = b.bike_id
    GROUP BY
        c.name,
        c.city
),
Total_average AS (
    SELECT AVG(Total_spent) Average_spent
    FROM Customer_Average
)
SELECT ca.name
FROM Customer_Average ca
CROSS JOIN Total_average ta
WHERE ca.Total_spent > ta.Average_spent;





/*
How to read a problem and pick the right tool

The key is to train yourself to spot patterns in the problem statement, not just the words. Every SQL problem falls into a small number of
recognisable shapes.

Pattern 1 — "Give me data from multiple tables"
Keywords: "show me X along with Y", "for each customer show their orders"
Tool: JOIN
The moment a problem mentions data that lives in different tables, you're joining. The question is just which type:

Only want matching rows on both sides? → INNER JOIN
Want all rows from one side regardless? → LEFT JOIN
Want to find rows with no match? → LEFT JOIN + IS NULL, or NOT EXISTS


Pattern 2 — "Filter or compare against a computed value"
Keywords: "above average", "more than the total", "higher than the maximum of their group"
Tool: Subquery or CTE
The moment the WHERE condition itself requires a calculation, you can't do it in one flat query. You need to compute something first, then filter
against it.

Single computed value (one number)? → Scalar subquery
Computed value per group? → Correlated subquery or CTE + JOIN
Complex enough that you'd nest more than two levels? → CTEs


Pattern 3 — "For each X, tell me something about Y"
Keywords: "for each brand", "per customer", "by city"
Tool: GROUP BY + aggregate, often with a JOIN first
This is aggregation territory. The "for each" phrasing almost always means GROUP BY. If the data needed lives in multiple tables, JOIN first, then
GROUP BY.


Pattern 4 — "Only include X if some condition about related data is true"
Keywords: "customers who have placed an order", "bikes that have never been ordered", "who has at least one..."
Tool: EXISTS / NOT EXISTS, or LEFT JOIN + IS NULL
The distinction from Pattern 1: here you don't want data from the related table — you just want to check whether a related row exists. If you need
columns from the other table, use JOIN. If you just need a yes/no existence check, EXISTS is cleaner.


Pattern 5 — "Combine two separate lists into one"
Keywords: "all X and all Y together", "everything from A and B"
Tool: UNION / UNION ALL
Two separate queries whose results need to be stacked vertically. The columns must be compatible.


Pattern 6 — "What's common between two groups" or "What's in one group but not the other"
Keywords: "both conditions", "in A but not in B", "overlap between"
Tool: INTERSECT / EXCEPT


Pattern 7 — "Multi-step logic where step 2 depends on step 1"
Keywords: any problem where you catch yourself thinking "first I need to calculate X, then use X to find Y"
Tool: CTE
This is the CTE signal. Any time you find yourself saying "first..." in your head, that first step is a CTE. Two "first..." steps? Two CTEs.


The decision process in practice

When you read a problem, ask these questions in order:
    1. Does this involve more than one table?
            Yes → I need a JOIN somewhere
        
    2. Does my WHERE or HAVING condition require a calculation?
            Yes → I need a subquery or CTE
        
    3. Am I just checking existence, not pulling data from the other table?
            Yes → EXISTS / NOT EXISTS over JOIN
        
    4. Do I need to stack two result sets vertically?
            Yes → UNION / UNION ALL
        
    5. Do I need overlap or difference between two sets?
            Yes → INTERSECT / EXCEPT
        
    6. Is my logic multi-step — where I need to compute something before I can compute the next thing?
            Yes → CTEs to break it into readable steps


Applied to the tasks you just did

Task 3b — "customers whose total spend is above the average total spend"
    "total spend per customer" → GROUP BY + SUM → that's step 1, needs a CTE
    "above the average of those totals" → AVG of an already-aggregated result → that's step 2, needs another CTE
    Two steps → two CTEs ✅

Task 2b — "bikes that have never been ordered"
    "never been ordered" → existence check → NOT EXISTS ✅
    Alternatively: "all bikes, show NULL where no order exists" → LEFT JOIN + IS NULL ✅
    Both valid, EXISTS is the more direct read

Task 1a — "bikes priced above the average for their type"
    "average for their type" → needs a calculation per group → correlated subquery or CTE
    "for their type" → the calculation depends on the current row's type → correlated subquery fits
    Alternatively: pre-compute type averages separately → CTE + JOIN ✅


The more problems you solve, the faster this pattern recognition becomes automatic. Right now you're consciously running through the checklist — in a
few months you'll read a problem and the tool will just surface. That's the goal.
*/