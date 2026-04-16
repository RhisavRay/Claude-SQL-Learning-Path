/*
Joins
So far every query has pulled from a single table. But real data is never in one table — customers live in customers, purchases live in orders, and
bike details live in bikes. Joins are how you stitch them together.

The core idea:

A join combines rows from two tables based on a related column between them. In our schema, orders has a bike_id column that references
bikes.bike_id. That link is the join condition.

    SELECT *
    FROM orders
    INNER JOIN bikes ON orders.bike_id = bikes.bike_id;

This returns one row for every order, enriched with the full bike details for that order.

The four join types — visualised

Think of two overlapping circles. Left circle = Table A, Right circle = Table B.
    
    INNER JOIN - Only rows that match in both tables
    LEFT JOIN - All rows from left table + matches from right (NULLs where no match)
    RIGHT JOIN - All rows from right table + matches from left (NULLs where no match)
    FULL OUTER JOIN - Everything from both tables (NULLs where no match on either side)

MySQL doesn't support FULL OUTER JOIN natively — we'll cover how to simulate it when we get there.
*/




-- SELECT 
    -- customers.name,
    -- bikes.model,
    -- orders.order_date
-- FROM orders
-- INNER JOIN customers
-- ON orders.customer_id = customers.customer_id
-- INNER JOIN bikes
-- ON orders.bike_id = bikes.bike_id;

/*
INNER JOIN — only the overlap

This example joins all three tables at once. Only orders that have a matching customer AND a matching bike will appear — if either link is broken,
the row is excluded.
*/




-- SELECT 
    -- c.name,
    -- b.model,
    -- o.order_date
-- FROM orders o
-- INNER JOIN customers c ON o.customer_id = c.customer_id
-- INNER JOIN bikes b ON o.bike_id = b.bike_id;

/*
Table aliases — typing full table names gets tedious. Use aliases:

Same query, much cleaner. The alias is defined right after the table name in FROM and JOIN. Use short, obvious aliases — o for orders, c for
customers, b for bikes.
*/




/*
Task 1 — INNER JOIN:

1a. Write a query that returns the customer's name, the model of bike they ordered, and the order_date. Use aliases.
*/

-- SELECT
-- 	   c.name,
--     b.model,
--     o.order_date
-- FROM orders AS o
-- INNER JOIN customers AS c
-- 	ON o.customer_id = c.customer_id
-- INNER JOIN bikes AS b
-- 	ON o.bike_id = b.bike_id


/*
1b. Extend the same query to also show the price_inr of the bike and the discount from the order. Sort by order_date ascending.
*/

-- SELECT
-- 	c.name,
--     b.model,
--     b.price_inr,
--     o.discount,
--     o.order_date
-- FROM orders AS o
-- INNER JOIN customers AS c
-- 	ON o.customer_id = c.customer_id
-- INNER JOIN bikes AS b
-- 	ON o.bike_id = b.bike_id
-- ORDER BY o.order_date;