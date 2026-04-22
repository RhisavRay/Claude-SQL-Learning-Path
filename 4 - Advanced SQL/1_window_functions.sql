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
