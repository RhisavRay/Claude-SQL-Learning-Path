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

*/