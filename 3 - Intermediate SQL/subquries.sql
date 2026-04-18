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

The simplest form. The subquery returns one number or string, used like a value.
*/

SELECT brand, model, price_inr
FROM bikes
WHERE price_inr > (SELECT AVG(price_inr) FROM bikes);

/*
The inner query SELECT AVG(price_inr) FROM bikes runs first, returns a single number (₹4,39,800 roughly), and the outer query then uses that number
in its WHERE condition. You never had to know the average beforehand — the query figures it out dynamically.
*/