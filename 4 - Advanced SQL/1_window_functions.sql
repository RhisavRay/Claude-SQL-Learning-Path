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