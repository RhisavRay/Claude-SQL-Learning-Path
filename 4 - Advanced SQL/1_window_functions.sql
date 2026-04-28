/*
Stage 4 — Advanced SQL

Two topics in this stage:
    1. Window functions — the biggest leap in analytical SQL
    2. Transactions — ACID, BEGIN/COMMIT/ROLLBACK, isolation levels

Window functions will take the bulk of this stage. Let's start there.
*/




/*
Window Functions

Every aggregate function you've used so far collapses rows into groups. GROUP BY brand gives you one row per brand. The individual bike rows are gone
from the result.

Window functions are different. They compute across a set of rows but keep every row intact. You get the aggregated value alongside the original row
— nothing collapses.

Compare these two:
*/

-- Aggregate: collapses to one row per type
SELECT type, AVG(price_inr) AS avg_price
FROM bikes
GROUP BY type;

-- Window: keeps every row, adds avg alongside
SELECT brand, model, type, price_inr,
    AVG(price_inr) OVER (PARTITION BY type) AS avg_type_price
FROM bikes;

/*
The second query returns all 21 bike rows, each with its own avg_type_price showing the average for its type category. No rows lost, no grouping.

The anatomy of a window function:
*/

function_name() OVER (
    PARTITION BY column    -- define the groups (optional)
    ORDER BY column        -- define the order within groups (optional)
    ROWS/RANGE ...         -- define the frame (optional, covered later)
)

/*
PARTITION BY — divides rows into groups, like GROUP BY but without collapsing. Each partition is processed independently.

ORDER BY inside OVER() — defines the order of rows within each partition. Required for ranking and running total functions, optional for pure
aggregates.

No PARTITION BY — the entire result set is treated as one partition.
*/




/*
The window function families

Family        |  Functions
--------------------------------------------------------------
Aggregate     |  SUM, AVG, COUNT, MIN, MAX — but over a window
Ranking       |  ROW_NUMBER, RANK, DENSE_RANK, NTILE
Navigation    |  LAG, LEAD, FIRST_VALUE, LAST_VALUE
*/




/*
Family 1 — Aggregate window functions
*/

SELECT 
    brand,
    model,
    type,
    price_inr,
    AVG(price_inr) OVER (PARTITION BY type) AS avg_type_price,
    price_inr - AVG(price_inr) OVER (PARTITION BY type) AS diff_from_avg
FROM bikes;

/*
This shows each bike alongside its type's average, and how far above or below that average it sits. Impossible to do cleanly with GROUP BY alone.
*/




/*
All aggregate window functions with examples

All five work the same way — swap the function, the behaviour changes, but the OVER() syntax is identical.
*/

SELECT
    o.order_id,
    o.order_date,
    b.brand,
    b.price_inr,

    -- Running total: cumulative sum so far
    SUM(b.price_inr) OVER (ORDER BY o.order_date) AS running_total,

    -- Running count: how many orders placed so far
    COUNT(o.order_id) OVER (ORDER BY o.order_date) AS running_count,

    -- Running average: average price of all orders so far
    ROUND(AVG(b.price_inr) OVER (ORDER BY o.order_date), 0) AS running_avg,

    -- Running min: cheapest bike ordered so far
    MIN(b.price_inr) OVER (ORDER BY o.order_date) AS running_min,

    -- Running max: most expensive bike ordered so far
    MAX(b.price_inr) OVER (ORDER BY o.order_date) AS running_max

FROM orders o
INNER JOIN bikes b ON o.bike_id = b.bike_id;




/*
Task 1 — Aggregate windows:

1a. Write a query that shows every bike's brand, model, type, price_inr, and two additional columns:
    
    1. avg_type_price — average price of bikes in the same type
    2. pct_of_type_avg — the bike's price as a percentage of its type's average, rounded to 1 decimal place. A bike at exactly the type average should
    show 100.0.
*/

SELECT
    brand,
    model,
    type,
    COALESCE(price_inr, 0),
    AVG(price_inr) OVER(
        PARTITION BY type
    ) AS avg_type_price,
    ROUND(COALESCE(price_inr, 0) * 100 / AVG(price_inr) OVER(
        PARTITION BY type
    ), 1) AS pct_of_type_avg
FROM bikes;


/*
1b. Write a query that shows each order's order_id, customer_id, order_date, the bike's price_inr, and a running_total — the cumulative sum of
price_inr ordered by order_date across all orders. This is your first running total — it requires ORDER BY inside OVER().
*/

SELECT
    o.order_id,
    o.customer_id,
    o.order_date,
    b.price_inr,
    SUM(b.price_inr) OVER (
        ORDER BY o.order_date
    ) AS running_total
FROM orders o
INNER JOIN bikes b
    ON o.bike_id = b.bike_id;




/*
All aggregate window functions with examples

All five work the same way — swap the function, the behaviour changes, but the OVER() syntax is identical.
*/

SELECT
    o.order_id,
    o.order_date,
    b.brand,
    b.price_inr,

    -- Running total: cumulative sum so far
    SUM(b.price_inr) OVER (ORDER BY o.order_date) AS running_total,

    -- Running count: how many orders placed so far
    COUNT(o.order_id) OVER (ORDER BY o.order_date) AS running_count,

    -- Running average: average price of all orders so far
    ROUND(AVG(b.price_inr) OVER (ORDER BY o.order_date), 0) AS running_avg,

    -- Running min: cheapest bike ordered so far
    MIN(b.price_inr) OVER (ORDER BY o.order_date) AS running_min,

    -- Running max: most expensive bike ordered so far
    MAX(b.price_inr) OVER (ORDER BY o.order_date) AS running_max

FROM orders o
INNER JOIN bikes b ON o.bike_id = b.bike_id;