/*
Q1. Write a query that returns each city from the customers table along with the number of customers in that city. Only show cities with more than
1 customer.
*/

SELECT
	city,
    COUNT(city) AS No_of_people
FROM customers
GROUP BY city
HAVING No_of_people > 1;


/*
Q2. Write a query showing each customer's name and the most expensive bike they've ever ordered (by price_inr). Only include customers who have
placed at least one order.
*/

SELECT
	c.name,
    MAX(b.price_inr) AS Costliest_Bike
FROM orders AS o
INNER JOIN customers AS c
	ON c.customer_id = o.customer_id
INNER JOIN bikes AS b
	ON b.bike_id = o.bike_id
GROUP BY
	o.customer_id,
    c.name;


/*
Q3. Write a query that returns all bikes that have never been ordered. Show brand, model, and type.
*/

SELECT
	b.brand,
    b.model,
    b.type
FROM bikes AS b
LEFT JOIN orders AS o
	ON b.bike_id = o.bike_id
WHERE o.order_id IS Null;


/*
Q4. We need to add a new order to the system:
    
    order_id: 16
    Customer: Vikram Singh
    Bike: KTM 250 Duke
    order_date: today's date
    quantity: 1, discount: 0.00

Write the INSERT — but look up the correct customer_id and bike_id from the data yourself rather than hardcoding from memory.
*/

SELECT
	customer_id,
    name
FROM customers
WHERE name = 'Vikram Singh';

SELECT
	bike_id,
    brand,
    model
FROM bikes
WHERE brand = 'KTM' and model = '250 Duke';

INSERT INTO orders VALUES
(16, 9, 4, '2026-04-18', 1, 0.00);

-- *** An alternative solution ***

INSERT INTO orders VALUES (
    16,
    (SELECT customer_id FROM customers WHERE name = 'Vikram Singh'),
    (SELECT bike_id FROM bikes WHERE brand = 'KTM' AND model = '250 Duke'),
    '2026-04-18',
    1,
    0.00
);


/*
Q5. Without running it — what is wrong with this query, and what would you change?

    SELECT brand, COUNT(*) as total
    FROM bikes
    WHERE total > 2
    GROUP BY brand;

Explain the problem and write the corrected version.
*/

/*
There are 2 things that need to change:

    1. It twill not be WHERE. It Would be HAVING
    2. The HAVING statement will be after GROUP BY

Something like this,
*/
SELECT brand, COUNT(*) as total
FROM bikes
GROUP BY brand
HAVING total > 2;





/*
The complete SQL execution order

There are two orders to keep in mind — the order you write a query, and the order MySQL executes it.

The order you write it:

SELECT       -- 1
FROM         -- 2
JOIN         -- 3
WHERE        -- 4
GROUP BY     -- 5
HAVING       -- 6
ORDER BY     -- 7
LIMIT        -- 8

The order MySQL executes it:

FROM         -- 1. which table(s) am I working with?
JOIN         -- 2. combine tables, build the full working dataset
WHERE        -- 3. filter individual rows before any grouping
GROUP BY     -- 4. collapse rows into groups
HAVING       -- 5. filter groups based on aggregate results
SELECT       -- 6. compute the columns and expressions to return
ORDER BY     -- 7. sort the result
LIMIT        -- 8. cut to the requested number of rows


Why this matters practically — four rules that flow directly from this order:

1. Rule 1 — WHERE can't use SELECT aliases
    SELECT price_inr * 0.9 AS discounted — you can't then say WHERE discounted < 200000 because WHERE runs at step 3, before SELECT computes
    discounted at step 6. You'd have to repeat the expression: WHERE price_inr * 0.9 < 200000.

2. Rule 2 — HAVING can use SELECT aliases in MySQL
    HAVING total > 2 works in MySQL even though HAVING runs at step 5 and SELECT runs at step 6. MySQL makes a special exception here — it resolves
    SELECT aliases early for HAVING. This is MySQL-specific behaviour and won't work in PostgreSQL.

3. Rule 3 — WHERE filters rows, HAVING filters groups
    WHERE in_stock = TRUE removes out-of-stock rows before grouping. HAVING COUNT(*) > 2 removes groups after counting. Putting aggregate conditions
    in WHERE fails because aggregation hasn't happened yet at step 3.

4. Rule 4 — ORDER BY can use SELECT aliases everywhere
    ORDER BY Total_spent DESC works because ORDER BY runs at step 7, after SELECT at step 6 has already computed Total_spent. This one is safe across
    all databases.
*/




-- A complete query using every clause, annotated:
SELECT                              -- step 6: compute output columns
    c.name,
    COUNT(o.order_id) AS total_orders,
    SUM(b.price_inr) AS total_spent
FROM customers c                    -- step 1: start with customers
INNER JOIN orders o                 -- step 2: bring in orders
    ON c.customer_id = o.customer_id
INNER JOIN bikes b                  -- step 2: bring in bikes
    ON o.bike_id = b.bike_id
WHERE b.type = 'Naked'             -- step 3: only Naked bike orders
GROUP BY c.customer_id, c.name     -- step 4: one row per customer
HAVING total_orders >= 1           -- step 5: only customers with orders
ORDER BY total_spent DESC          -- step 7: highest spenders first
LIMIT 5;                           -- step 8: top 5 only




/*
My question to Claude:

What if I wanna filter out rows from each table that gets joined. Can seperate where clauses be used or is that an unnecessary ask and thats why it
cannot be done, or is it a genuine drawback?
*/


/*
Really good question — and the answer is nuanced.
You cannot use multiple WHERE clauses in a single query. SQL simply doesn't allow it syntactically. One query, one WHERE. But this is not a drawback
at all — it's by design, because you don't need it. Here's why.

After a JOIN, it's all one table

This is the key mental shift. Once MySQL executes your JOINs, it doesn't think in terms of "the customers table" and "the bikes table" anymore. It
builds a single combined working dataset with all columns from all joined tables. Your WHERE clause then operates on that unified dataset.

So filtering columns from different tables in one WHERE is completely natural:
*/

SELECT c.name, b.model, o.order_date
FROM orders o
INNER JOIN customers c ON o.customer_id = c.customer_id
INNER JOIN bikes b ON o.bike_id = b.bike_id
WHERE c.city = 'Mumbai'
AND b.type = 'Adventure'
AND o.quantity >= 1;

/*
c.city comes from customers, b.type comes from bikes, o.quantity comes from orders — all filtered in one WHERE, because by the time WHERE runs,
they're all columns in the same working dataset.

Lets understand this with a few examples:
*/

/*
Example 1 — filtering from two different tables

Customers from Bangalore who ordered a Sport bike.
*/

SELECT c.name, c.city, b.model, b.type
FROM orders o
INNER JOIN customers c ON o.customer_id = c.customer_id
INNER JOIN bikes b ON o.bike_id = b.bike_id
WHERE c.city = 'Bangalore'
AND b.type = 'Sport';

/*
No need for two WHERE clauses — one WHERE handles both filters cleanly because both c.city and b.type exist as columns in the joined dataset.
*/

/*
Example 2 — filtering with a join condition AND a row filter

All in-stock bikes priced under ₹3,00,000 that have actually been ordered.
*/

SELECT b.brand, b.model, b.price_inr, o.order_date
FROM bikes b
INNER JOIN orders o ON b.bike_id = o.bike_id
WHERE b.price_inr < 300000
AND b.in_stock = TRUE;

/*
Again — b.price_inr and b.in_stock are both from bikes, sitting right next to o.order_date from orders in the same working dataset after the JOIN.
*/





/*
The one case where table-level filtering DOES have a separate mechanism

There is a scenario where you might want to filter rows from a specific table before the join happens rather than after. That's done using a condition
directly in the ON clause or a subquery — and it matters specifically with LEFT JOINs.

Compare these two:
*/

-- Filter AFTER join (WHERE): removes unmatched rows entirely
SELECT c.name, o.order_id
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
WHERE o.order_date >= '2023-10-01';
*/

/*
This loses customers with no orders — the WHERE filters out NULL order_dates, effectively turning your LEFT JOIN into an INNER JOIN.
*/

-- Filter INSIDE JOIN (ON): filters orders before joining, keeps all customers
SELECT c.name, o.order_id
FROM customers c
LEFT JOIN orders o 
    ON c.customer_id = o.customer_id
    AND o.order_date >= '2023-10-01';

/*
This keeps all customers — those with no qualifying orders just show NULL in order_id. The date filter applies only to which orders get matched, not
which customers survive.

This is the one genuine nuance — with INNER JOINs, WHERE and ON conditions are equivalent in result. With LEFT JOINs, they are not. WHERE filters the
final result; ON conditions filter what gets matched during the join itself.
*/