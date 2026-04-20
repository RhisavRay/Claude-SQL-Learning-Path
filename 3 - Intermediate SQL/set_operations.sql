/*
Set Operations
Set operations combine the results of two or more queries into a single result set. Think of it like the mathematical idea of sets — union,
intersection, difference.

Three rules that always apply:
    1. Both queries must return the same number of columns
    2. Corresponding columns must have compatible data types
    3. Column names in the final result come from the first query
*/




/*
UNION and UNION ALL

UNION combines two result sets and removes duplicates. UNION ALL combines and keeps everything including duplicates.

UNION ALL is faster because it skips the deduplication step. Use it when you know there are no duplicates or when duplicates are meaningful to keep.
*/

-- All cities where we have customers OR where bikes are manufactured
SELECT city AS location
FROM customers
UNION
SELECT brand AS location
FROM bikes;




/*
INTERSECT — what's in both

Returns only rows that appear in both result sets.

MySQL 8.0 added native INTERSECT support — it didn't exist in MySQL 5.7, which is another reason we upgraded.
*/

-- Hypothetical: cities that appear in both tables
SELECT city
FROM customers
INTERSECT
SELECT city
FROM suppliers;




/*
EXCEPT — what's in the first but not the second

Returns rows from the first query that don't appear in the second.

Also added natively in MySQL 8.0.
*/

SELECT city
FROM customers
EXCEPT
SELECT city
FROM blacklisted_cities;




/*
Where CTEs add on top

This is where it gets powerful. Set operations on raw tables are useful but limited. CTEs let you build complex intermediate results and then combine
them:
*/

WITH 
high_spenders AS (
    SELECT customer_id
    FROM orders
    GROUP BY customer_id
    HAVING SUM(quantity) > 1
),
bangalore_customers AS (
    SELECT customer_id
    FROM customers
    WHERE city = 'Bangalore'
)
SELECT customer_id
FROM high_spenders
INTERSECT
SELECT customer_id
FROM bangalore_customers;

/*
Now you're intersecting two meaningfully computed sets — not just raw columns. This pattern comes up constantly in real analytical work.
*/