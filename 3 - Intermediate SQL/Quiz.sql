/*
Stage 3 Quiz

Q1. Write a query using a scalar subquery that returns the model and price_inr of the single most expensive bike in the table. Do not use ORDER BY +
LIMIT — use a subquery.
*/

SELECT
    model,
    price_inr
FROM bikes
WHERE price_inr = (
    SELECT MAX(price_inr)
    FROM bikes
);


/*
Q2. Using a CTE, find all customers who have spent more than ₹5,00,000 in total across all their orders (use the discount formula). Show their name,
city, and total_spent.
*/

WITH Final_expense AS (
    SELECT
        c.name,
        c.city,
        COALESCE(SUM((o.quantity * b.price_inr) * (100 - o.discount) / 100.0), 0) as total_spent
    FROM orders o
    INNER JOIN customers c
        ON o.customer_id = c.customer_id
    INNER JOIN bikes b
        ON o.bike_id = b.bike_id
    GROUP BY
        c.name,
        c.city
    HAVING total_spent > 500000
)
SELECT
    name,
    city,
    total_spent
FROM Final_expense;


/*
Q3. Write a query that returns each bike's model, price_inr, and a value_rating column defined as:

    Engine CC per rupee lakh — i.e. engine_cc / (price_inr / 100000)
    Round to 2 decimal places
    Then add a verdict column using CASE WHEN:
        Above 1.5 → 'High value'
        Between 0.5 and 1.5 → 'Fair value'
        Below 0.5 → 'Low value'

Sort by value_rating descending.
*/

WITH value_proposition AS (
    SELECT
        model,
        price_inr,
        ROUND(engine_cc / NULLIF((price_inr / 100000), 0), 2) as value_rating
    FROM bikes
)
SELECT
    model,
    price_inr,
    value_rating,
    CASE
        WHEN value_rating > 1.5 THEN 'High value'
        WHEN value_rating > 0.5 THEN 'Fair value'
        ELSE 'Low value'
    END AS verdict
FROM value_proposition
ORDER BY value_rating DESC;


/*
Q4. Without running it first — will this query work? If not, why, and what's the fix?

    WITH order_counts AS (
        SELECT customer_id, COUNT(*) AS total_orders
        FROM orders
        GROUP BY customer_id
    )
    SELECT c.name, order_counts.total_orders
    FROM customers c
    JOIN order_counts ON c.customer_id = order_counts.customer_id
    WHERE total_orders > 1
    ORDER BY total_orders DESC;

Explain your reasoning, then run it to verify.
*/

-- Yes. This query will run and show the names of those customers who have placed more than one order with us


/*
Q5. Write a single query that produces a combined loyalty report with these columns:

    name
    city
    days_as_member
    loyalty_tier (New / Regular / Loyal — same thresholds as Task 5b)
    total_orders (0 if no orders)
    total_spent (0.00 if no orders, with discount applied)

This requires combining a JOIN, LEFT JOIN, aggregation, DATEDIFF, CASE WHEN, and COALESCE — all in one query. Include all customers including those
with no orders.
*/

WITH Customer AS (
    SELECT 
        customer_id, 
        name, 
        city,
        DATEDIFF(CURDATE(), member_since) as days_as_member
    FROM customers
),
Totals AS (
    SELECT 
        c.customer_id,
        COUNT(o.order_id) as total_orders,
        COALESCE(SUM((o.quantity * b.price_inr) * (100 - o.discount) / 100.0), 0) as total_spent
    FROM customers c
    LEFT JOIN orders o ON c.customer_id = o.customer_id
    LEFT JOIN bikes b ON o.bike_id = b.bike_id
    GROUP BY c.customer_id
)
SELECT 
    c.name,
    c.city,
    c.days_as_member,
    CASE 
        WHEN c.days_as_member < 365 THEN 'New'
        WHEN c.days_as_member < 1095 THEN 'Regular'
        ELSE 'Loyal'
    END AS loyalty_tier,
    t.total_orders,
    t.total_spent
FROM Customer c
INNER JOIN Totals t ON c.customer_id = t.customer_id;