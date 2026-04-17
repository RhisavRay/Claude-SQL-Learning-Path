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




/*
FULL OUTER JOIN — everything from both sides

A FULL OUTER JOIN returns all rows from both tables, with NULLs wherever there's no match on either side. MySQL doesn't support it natively, but
it's easy to simulate:
*/

SELECT c.name, o.order_id
FROM customers c
LEFT JOIN orders o
    ON c.customer_id = o.customer_id

UNION

SELECT c.name, o.order_id
FROM customers c
RIGHT JOIN orders o
    ON c.customer_id = o.customer_id;

-- UNION combines the two result sets and removes duplicates — giving you the full outer join effect.





/*
Task 3 — Putting joins together with aggregation:

3a. Write a query that shows each customer's name and the total number of orders they've placed. Include customers who have placed zero orders
(Siddharth Roy and Meera Pillai should appear with a count of 0, not be excluded).
*/

SELECT
	c.name,
    COUNT(o.order_id) No_of_orders
FROM customers AS c
LEFT JOIN orders AS o
	ON c.customer_id = o.customer_id
GROUP BY c.customer_id;


/*
3b. Write a query that shows each brand and the total number of times bikes of that brand have been ordered. Brands that have never been ordered
should still appear with a count of 0.
*/

SELECT
	b.brand,
    COUNT(o.order_id) AS No_of_orders
FROM bikes AS b
LEFT JOIN orders o
	ON b.bike_id = o.bike_id
GROUP BY b.brand;

/*
Why COUNT(o.order_id) and not COUNT(*)?

For unmatched rows (Siddharth Roy, Meera Pillai, Suzuki, TVS, Harley-Davidson), the LEFT JOIN fills the orders side with NULLs. At that point:
    
    COUNT(*) counts the row itself — it would return 1, not 0
    COUNT(o.order_id) counts only non-NULL values in that column — it correctly returns 0

You used COUNT(o.order_id) — the right choice. COUNT(*) on a left-joined table gives you wrong zeros disguised as ones.

3b grouping by b.brand — also worth noting. Multiple bikes share the same brand, so grouping by b.brand correctly collapses them. We could have
also grouped by b.bike_id and then aggregated brand counts differently, but brand-level grouping is exactly what the question asked for.
*/




/*
CROSS JOIN

CROSS JOIN produces every combination of rows from two tables — no ON condition needed. With 10 customers and 21 bikes, a cross join gives 210 rows.
Rare in analytics but useful for generating combinations, test data, or calendar grids.
*/

SELECT
    c.name,
    b.model
FROM customers c
CROSS JOIN bikes b;




/*
SELF JOIN

SELF JOIN is when a table joins to itself. Useful when rows in a table relate to other rows in the same table — like an employee table where each row
has a manager_id pointing to another row in the same table.

Our bikes dataset doesn't have a natural self-referencing structure, so I'll show you the pattern conceptually:
*/

-- If bikes had a 'similar_bike_id' column pointing to another bike:
SELECT
    a.model AS bike,
    b.model AS similar_to
FROM bikes a
INNER JOIN bikes b
    ON a.similar_bike_id = b.bike_id;

-- The key is aliasing the same table twice (a and b) so MySQL treats them as two separate tables.




/*
Task 4 — Combined join + filter + aggregation:

Write a query that shows each customer's name, city, and the total amount they've spent across all orders — calculated as
SUM(b.price_inr * o.quantity). Only include customers who have actually placed orders. Sort by total spent descending.
*/

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
	c.customer_id,
    c.name,
    c.city
ORDER BY Total_spent DESC;





/*
DML — Modifying data

You already know INSERT. Here are the other three:

UPDATE — modify existing rows:

Always use WHERE with UPDATE. Without it, every row in the table gets updated — one of the most painful mistakes in SQL.
*/
