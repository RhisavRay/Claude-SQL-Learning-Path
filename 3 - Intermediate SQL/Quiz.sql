/*
Stage 3 Quiz

Q1. Write a query using a scalar subquery that returns the model and price_inr of the single most expensive bike in the table. Do not use ORDER BY + LIMIT — use a subquery.
*/




/*
Q2. Using a CTE, find all customers who have spent more than ₹5,00,000 in total across all their orders (use the discount formula). Show their name, city, and total_spent.
*/




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

