/*
What is SQL, and what are we actually doing when we query?

SQL (Structured Query Language) is the language you use to talk to a relational database. A relational database stores data in tables —
think of each table as a spreadsheet, but with strict rules about what goes in each column.

When you write a SQL query, you're not telling the database how to fetch data (that's the engine's job). You're telling it what you want.
This is called being declarative — a key mental shift from Python where you describe steps.


The anatomy of a basic query

    SELECT  <columns>
    FROM    <table>
    WHERE   <condition>
    ORDER BY <column> ASC|DESC
    LIMIT   <n>;

The clauses always go in this order when you write them. Internally MySQL evaluates them in a different order —
FROM → WHERE → SELECT → ORDER BY → LIMIT — but we'll come back to that when it matters.
*/

/*
Task 1 — Warm up:

Write a query that returns the brand, model, and price_inr of all bikes, sorted by price from highest to lowest. Limit the result to the top 5.
*/

-- SELECT brand, model, price_inr
-- FROM bikes
-- ORDER BY price_inr DESC
-- LIMIT 5;




/*
Task 2 — Adding a filter:

Write a query that returns the brand, model, type, and engine_cc of all bikes that are currently in stock, sorted by engine_cc in ascending order.
*/

-- SELECT brand, model, type, engine_cc
-- FROM bikes
-- WHERE in_stock = True
-- ORDER BY engine_cc;




/*
A small but important note on TRUE in MySQL:

MySQL stores BOOLEAN as TINYINT(1) under the hood. So TRUE = 1 and FALSE = 0. All three of these are equivalent and valid in MySQL:
    
    WHERE in_stock = TRUE
    WHERE in_stock = 1
    WHERE in_stock IS TRUE

You'll often see the = 1 form in older codebases. Your = TRUE is perfectly fine and the most readable — stick with it.

Also notice the dropped ASC from ORDER BY. ASC is the default, so it's optional. Worth knowing explicitly though: always write DESC when you
need it, and omit or optionally write ASC otherwise.
*/




/*
Task 3 — Multiple conditions:

Write a query that returns the brand, model, type, and price_inr of all bikes that are:

    Naked type, AND
    priced below ₹3,00,000, AND
    currently in stock

Sort the results by price_inr ascending.
*/

-- SELECT brand, model, type, price_inr
-- FROM bikes
-- WHERE type = 'Naked' AND price_inr < 300000 AND in_stock = True
-- ORDER BY price_inr;




/*
Task 4 — Introducing OR, IN, and BETWEEN:

Three operators, one task. Try to use all three in separate queries.

4a. Write a query that returns brand, model, and type for all bikes that are either 'Sport' or 'Adventure' type. Use OR.
*/

-- SELECT brand, model, type
-- FROM bikes
-- WHERE type = 'Sport' OR type = 'Adventure';


/*
4b. Now write the same query using IN instead of OR.
*/

-- SELECT brand, model, type
-- FROM bikes
-- WHERE type IN ('Sport', 'Adventure');


/*
4c. Write a query that returns brand, model, and engine_cc for bikes with engine displacement between 300cc and 700cc (inclusive). Use BETWEEN.
*/

-- SELECT brand, model, engine_cc
-- FROM bikes
-- WHERE engine_cc BETWEEN 300 AND 700;

/*
Two things worth locking in about BETWEEN:

First, it is inclusive on both ends. BETWEEN 300 AND 700 is exactly equivalent to engine_cc >= 300 AND engine_cc <= 700. No bike in our data
sits exactly at 300 or 700, but if one did, it would be included. This trips people up — always remember both boundaries are in.

Second, notice the results aren't sorted — you didn't add an ORDER BY and the task didn't ask for one, so MySQL returns rows in an arbitrary
order (roughly insertion order, but never rely on that). In real queries, if order matters, always be explicit about it.
*/




/*
Task 5 — NULL handling:

First, run this to add a bike with a missing price:

    INSERT INTO bikes VALUES (21, 'Harley-Davidson', 'X440', 'Cruiser', 440, NULL, 2023, TRUE);

Then write two queries:

5a. Return all bikes where price_inr is NULL.
*/

-- SELECT brand, model, type
-- FROM bikes
-- WHERE price_inr IS Null;


/*
5b. Return all bikes where price_inr is NOT NULL.
*/

-- SELECT brand, model, type
-- FROM bikes
-- WHERE price_inr IS NOT Null;



/*
Why = NULL returns nothing — ever:

NULL in SQL doesn't mean zero or empty. It means unknown. And the result of comparing anything to an
unknown is also unknown — not TRUE, not FALSE, just unknown. MySQL silently drops all rows where the
WHERE condition doesn't evaluate to TRUE. So price_inr = NULL never matches anything, including the
row that actually has NULL in that column.

This is called three-valued logic in SQL — conditions can be TRUE, FALSE, or UNKNOWN. Only TRUE rows
make it through WHERE.

The fix is IS NULL / IS NOT NULL — these are special operators designed specifically to check for the
absence of a value. They're the only correct way to filter NULLs.

A practical rule to tattoo in your brain:

    Never use = NULL or != NULL. Always use IS NULL or IS NOT NULL.
*/




/*
Stage 1 Quiz

Q1. Write a query that returns model and year of all bikes made in 2023, sorted alphabetically by model.

Q2. Write a query that returns brand, model, and price_inr of bikes that are either Cruiser type OR cost more than ₹10,00,000 — regardless
of stock status.

Q3. Write a query that returns brand and model of all bikes where year is between 2021 and 2022, and are currently in stock. Use BETWEEN.

Q4. You suspect some bikes might have a missing engine_cc. Write a query to check. What does the result tell you?

Q5. Without running it first — what will this query return, and why?

    SELECT brand, model
    FROM bikes
    WHERE type = 'Naked'
    AND price_inr > 500000;
*/