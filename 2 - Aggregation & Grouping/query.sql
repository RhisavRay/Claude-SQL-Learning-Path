/*
Stage 2 — Core SQL

We're going to cover three areas in this stage:

    Aggregation — COUNT, SUM, AVG, MIN, MAX, GROUP BY, HAVING
    Joins — INNER, LEFT, RIGHT, FULL OUTER, CROSS, self joins, multi-table joins
    DML — INSERT, UPDATE, DELETE, TRUNCATE

Joins alone will take the bulk of this stage — they're the single most important skill in SQL for a DA role. Let's start with aggregation.
*/


/*
Aggregation — the concept

So far every query returned individual rows. Aggregation collapses multiple rows into a single summary value. Instead of "show me every
bike's price", you ask "what is the average price across all bikes?"

The five core aggregate functions:

    COUNT(*): Counts rows
    COUNT(col): Counts non-NULL values in a column
    SUM(col): Adds up all values
    AVG(col): Arithmetic mean
    MIN(col): Smallest value
    MAX(col): Largest value

A simple example:

    SELECT COUNT(*), AVG(price_inr), MAX(price_inr)
    FROM bikes;

This returns a single row — the total bike count, average price, and highest price across the whole table.

Important: COUNT(*) counts all rows including NULLs. COUNT(price_inr) counts only rows where price_inr is not NULL. Given our Harley-Davidson
X440 has a NULL price, these two will return different numbers in our table. Keep that in mind.
*/




/*
Task 1 — Basic aggregation:

Write a single query that returns:

    Total number of bikes in the table
    Number of bikes that have a price listed (non-NULL)
    The cheapest price in the table
    The most expensive price in the table
    The average price (rounded to 2 decimal places is fine, no special function needed yet)

All five values in one query, one row returned.
*/

-- SELECT COUNT(*), COUNT(price_inr), MIN(price_inr), MAX(price_inr), AVG(price_inr)
-- FROM bikes;




/*

*/