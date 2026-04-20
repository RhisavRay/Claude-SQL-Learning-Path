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

SELECT COUNT(*), COUNT(price_inr), MIN(price_inr), MAX(price_inr), AVG(price_inr)
FROM bikes;




/*
GROUP BY:

GROUP BY is what makes aggregation truly powerful. Instead of one summary row for the whole table, you get one summary row per group.

    SELECT brand, COUNT(*)
    FROM bikes
    GROUP BY brand;

This returns one row per brand, with a count of how many bikes each brand has.
*/




/*
Task 2

2a. Write a query that returns each type of bike along with the average price and count of bikes in that type. Sort by average price
descending.
*/

select type, COUNT(*) as Count, AVG(price_inr) as Average_price
FROM bikes
GROUP BY type
ORDER BY Average_price DESC;

/*
Two things worth highlighting here:

    1. Aliases with AS — you used COUNT(*) as Count and AVG(price_inr) as Average_price. That's the right habit. It makes output readable and,
    importantly, you then used Average_price in ORDER BY instead of repeating AVG(price_inr). MySQL allows referencing SELECT aliases in
    ORDER BY — one of the few places where the evaluation order works in your favour.

    2. The Cruiser average — notice Cruiser shows 4 bikes and an average of ₹2,96,000. But we inserted the Harley-Davidson X440 as a Cruiser
    with a NULL price. So AVG(price_inr) silently ignored that NULL row and averaged only the 3 priced Cruisers — yet COUNT(*) counted all
    4 including the NULL one. This is a subtle but real trap in real-world data: your count and your average are operating on different
    numbers of rows without warning you.
*/


/*
2b. Write a query that returns each brand along with the total number of bikes and the maximum engine size they offer. Sort by total bikes
descending.
*/

select brand, COUNT(*) as Count, MAX(engine_cc) as Highest_Capacity
FROM bikes
GROUP BY brand
ORDER BY Count DESC;




/*
Now the natural next question is:

What if you want to filter on the result of an aggregation?

For example — what if you only want brands that have more than 2 bikes in the table?

You can't use WHERE for this. WHERE filters individual rows before grouping happens. By the time COUNT(*) is calculated, WHERE has already finished
its job.

This is where HAVING comes in. It filters after grouping:

    SELECT brand, COUNT(*) as Count
    FROM bikes
    GROUP BY brand
    HAVING Count > 2;

The mental model:

    WHERE → filters rows before grouping
    HAVING → filters groups after aggregation
*/




/*
Task 3 — HAVING:

3a. Write a query that returns only the bike types that have an average price above ₹3,00,000. Show the type and the average price.
*/

select type, AVG(price_inr) Average_Price
FROM bikes
GROUP BY type
HAVING Average_Price > 300000;


/*
3b. Write a query that returns brands that have at least 2 bikes in stock (in_stock = TRUE). Show the brand and the count of in-stock bikes.
*/

select brand, count(*) as Bikes_in_stock
FROM bikes
WHERE in_stock = True
GROUP BY brand
HAVING Bikes_in_stock >= 2;

/*
The full evaluation order from MySQL's PoV so far, locked in:

FROM → WHERE → GROUP BY → HAVING → SELECT → ORDER BY → LIMIT

And from our PoV:

SELECT → FROM → WHERE → GROUP BY → HAVING → ORDER BY → LIMIT
*/