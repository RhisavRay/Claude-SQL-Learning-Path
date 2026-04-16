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




SELECT 
    customers.name,
    bikes.model,
    orders.order_date
FROM orders
INNER JOIN customers
ON orders.customer_id = customers.customer_id
INNER JOIN bikes
ON orders.bike_id = bikes.bike_id;

/*
INNER JOIN — only the overlap

This example joins all three tables at once. Only orders that have a matching customer AND a matching bike will appear — if either link is broken,
the row is excluded.
*/




SELECT 
    c.name,
    b.model,
    o.order_date
FROM orders o
INNER JOIN customers c ON o.customer_id = c.customer_id
INNER JOIN bikes b ON o.bike_id = b.bike_id;

/*
Table aliases — typing full table names gets tedious. Use aliases:

Same query, much cleaner. The alias is defined right after the table name in FROM and JOIN. Use short, obvious aliases — o for orders, c for
customers, b for bikes.
*/




/*
Task 1 — INNER JOIN:

1a. Write a query that returns the customer's name, the model of bike they ordered, and the order_date. Use aliases.
*/

SELECT
    c.name,
    b.model,
    o.order_date
FROM orders AS o
INNER JOIN customers AS c
	ON o.customer_id = c.customer_id
INNER JOIN bikes AS b
	ON o.bike_id = b.bike_id


/*
1b. Extend the same query to also show the price_inr of the bike and the discount from the order. Sort by order_date ascending.
*/

SELECT
	c.name,
    b.model,
    b.price_inr,
    o.discount,
    o.order_date
FROM orders AS o
INNER JOIN customers AS c
	ON o.customer_id = c.customer_id
INNER JOIN bikes AS b
	ON o.bike_id = b.bike_id
ORDER BY o.order_date;




/*
LEFT JOIN — keeping the unmatched left side

INNER JOIN only returns rows with matches on both sides. LEFT JOIN returns all rows from the left table, plus whatever matches from the right — and
fills in NULL where there's no match.

Classic use case: "Show me all customers, even those who haven't placed an order yet."
*/




SELECT 
    c.name,
    o.order_id,
    o.order_date
FROM customers c
LEFT JOIN orders o
    ON c.customer_id = o.customer_id;

/*
Customers with no orders will appear with NULL in order_id and order_date.
*/




/*
Task 2 — LEFT JOIN:

2a. Write a query that returns all customers and their orders. Customers who have never placed an order should still appear — with NULL in the order
columns.
*/

SELECT
	c.customer_id,
    c.name,
    o.order_id
FROM customers AS c
LEFT JOIN orders as o
	ON c.customer_id = o.customer_id


/*
2b. Modify the query to return only customers who have never placed an order. Think about how to filter for NULLs on the joined side.
*/

SELECT
	c.customer_id,
    c.name,
    o.order_id
FROM customers AS c
LEFT JOIN orders as o
	ON c.customer_id = o.customer_id
WHERE o.order_id IS Null




-- These two are identical in result:
SELECT *
FROM customers c
RIGHT JOIN orders o
    ON c.customer_id = o.customer_id;

SELECT *
FROM orders o
LEFT JOIN customers c
    ON o.customer_id = c.customer_id;

/*
RIGHT JOIN

RIGHT JOIN is just a LEFT JOIN flipped — all rows from the right table are preserved, with NULLs on the left where there's no match.

Honestly, most SQL writers rarely use RIGHT JOIN in practice. Any RIGHT JOIN can be rewritten as a LEFT JOIN by swapping the table order, and
left-to-right reading feels more natural. But you should know it exists and recognise it.
*/