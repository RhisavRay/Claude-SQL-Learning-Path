/*
Stage 3 is where you go from writing SQL to thinking in SQL. The topics here — subqueries, CTEs, set operations, and functions — are what let you
solve genuinely complex analytical problems in a single, clean query.

Here's what Stage 3 covers:
    Subqueries — scalar, correlated, derived tables, EXISTS
    Set operations — UNION, INTERSECT, EXCEPT
    String functions — CONCAT, SUBSTRING, TRIM, UPPER, LOWER, REPLACE
    Date & time functions — CURDATE, DATEDIFF, DATE_FORMAT, TIMESTAMPDIFF
    Numeric functions — ROUND, CEIL, FLOOR, ABS
    CASE WHEN — conditional logic inside queries
    COALESCE / NULLIF — NULL handling beyond IS NULL
    CAST / CONVERT — type conversion

We'll start with subqueries since you already got a preview in Q4 of the quiz and asked exactly the right question about them.
*/




/*
Subqueries

A subquery is a query nested inside another query. The inner query runs first, and its result is used by the outer query.

You already saw the scalar subquery pattern in the INSERT example. Now let's go deeper.

There are four main forms:

FORM                 |   WHERE IT APPEARS        |        RETURNS
----------------------------------------------------------------------------------------
Scalar subquery      |   SELECT, WHERE, HAVING   |        Single value (1 row, 1 col)
Row subquery         |   WHERE                   |        Single row, multiple columns
Table subquery       |   FROM                    |        A full result set (derived table)
Correlated subquery  |   WHERE, SELECT           |        Depends on outer row — reruns per row
*/




/*
Scalar subquery — single value

The simplest form. The subquery returns one number or string, used like a value:
*/

SELECT brand, model, price_inr
FROM bikes
WHERE price_inr > (SELECT AVG(price_inr) FROM bikes);

/*
The inner query SELECT AVG(price_inr) FROM bikes runs first, returns a single number (₹4,39,800 roughly), and the outer query then uses that number
in its WHERE condition. You never had to know the average beforehand — the query figures it out dynamically.
*/




/*
Derived table — subquery in FROM

A subquery in the FROM clause acts as a temporary table:
*/

SELECT brand, avg_price
FROM (
    SELECT brand, AVG(price_inr) AS avg_price
    FROM bikes
    GROUP BY brand
) AS brand_averages
WHERE avg_price > 400000;

/*
The inner query builds a summarised table of brand averages. The outer query then filters that summary. Notice the alias brand_averages after the
closing parenthesis — derived tables must always be aliased in MySQL, otherwise you get a syntax error.

You could ask — why not just use HAVING for this? You could:
*/

SELECT brand, AVG(price_inr) AS avg_price
FROM bikes
GROUP BY brand
HAVING avg_price > 400000;

/*
Both work here. Derived tables become essential when your filtering logic is more complex than what HAVING can express — for example, when you need
to filter on a value computed from an already-aggregated result.
*/




/*
Task 1 — Scalar and derived table subqueries:

1a. Write a query that returns the brand, model, and price_inr of all bikes that cost more than the average price of bikes in their own type category.
(Hint: this needs a correlated subquery or a derived table — think about which approach feels more natural first.)
*/

SELECT
    b.brand,
    b.model,
    b.price_inr
FROM (
    SELECT
        type,
        AVG(price_inr) AS Average_price
    FROM bikes
    GROUP BY type
) AS a
INNER JOIN bikes AS b
    ON a.type = b.type
    AND b.price_inr > a.Average_price;


/*
1b. Using a derived table, find the top 3 brands by average price, then from that result show only brands where the average exceeds ₹4,00,000.
*/

SELECT *
FROM (
    SELECT
        brand,
        AVG(price_inr) AS Average_price
    FROM bikes
    GROUP BY brand
    ORDER BY Average_price DESC
    LIMIT 3
) AS Top_3_average_price
WHERE Average_price > 400000;