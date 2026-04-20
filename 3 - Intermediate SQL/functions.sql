/*
Functions

Functions in SQL transform or compute values at the row level — unlike aggregate functions which collapse many rows into one, these operate on each
row individually.

We'll cover five categories, moving fast since most of these are intuitive once you see them.
*/




/*
String functions

The ones you'll use most often in DA work:

Function                        |        What it does
----------------------------------------------------------------------------------
CONCAT(a, b)                    |        Joins strings together
UPPER(s) / LOWER(s)             |        Case conversion
LENGTH(s)                       |        Character count
TRIM(s)                         |        Removes leading/trailing spaces
SUBSTRING(s, start, length)     |        Extracts part of a string
REPLACE(s, from, to)            |        Replaces occurrences of a substring
LIKE                            |        Pattern matching (you know this one)

Quick examples on our data:
*/

-- Full name in uppercase, and model with brand prefixed
SELECT 
    UPPER(name) AS name_upper,
    CONCAT(brand, ' ', model) AS full_name,
    LENGTH(model) AS model_length
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN bikes b ON o.bike_id = b.bike_id;





/*
Date & time functions

Function                     |   What it does
---------------------------------------------------------------
CURDATE()                    |   Today's date
NOW()                        |   Current date and time
YEAR(d) / MONTH(d) / DAY(d)  |   Extract parts of a date
DATEDIFF(d1, d2)             |   Days between two dates
DATE_FORMAT(d, fmt)          |   Format a date as a string
TIMESTAMPDIFF(unit, d1, d2)  |   Difference in specified unit
*/

-- How long has each customer been a member?
SELECT 
    name,
    member_since,
    DATEDIFF(CURDATE(), member_since) AS days_as_member,
    TIMESTAMPDIFF(YEAR, member_since, CURDATE()) AS years_as_member
FROM customers;




/*
Numeric functions

Function                 |   What it does
------------------------------------------------------------
ROUND(n, decimals)       |   Round to N decimal places
CEIL(n)                  |   Round up to nearest integer
FLOOR(n)                 |   Round down to nearest integer
ABS(n)                   |   Absolute value
MOD(n, d)                |   Remainder after division
*/

SELECT 
    model,
    price_inr,
    ROUND(price_inr / 83.5, 2) AS price_usd  -- rough INR to USD
FROM bikes;





/*
CASE WHEN — conditional logic

This is the most important function category in this section. CASE WHEN lets you add conditional logic directly inside a query — think of it as an
if/else inside SQL.
*/

SELECT 
    brand,
    model,
    price_inr,
    CASE 
        WHEN price_inr < 200000 THEN 'Budget'
        WHEN price_inr < 500000 THEN 'Mid-range'
        WHEN price_inr < 1000000 THEN 'Premium'
        ELSE 'Superpremium'
    END AS price_segment
FROM bikes;





/*
COALESCE

COALESCE is useful whenever you have nullable columns and want a fallback value instead of NULL in your output.
*/

SELECT 
    model,
    COALESCE(price_inr, 0) AS price  -- replace NULL with 0
FROM bikes;




/*
NULLIF

Returns NULL if two values are equal, otherwise returns the first value:
*/

NULLIF(discount, 0)  -- returns NULL if discount is 0, else returns discount

/*
Less common but useful for avoiding division-by-zero errors:
*/

price_inr / NULLIF(engine_cc, 0)  -- safe division





/*
CAST and CONVERT

Force a value from one data type to another. Most commonly needed when joining on columns that were stored as different types, or when formatting
output.
*/

CAST(price_inr AS DECIMAL(10,2))
CAST('2023-01-15' AS DATE)
CONVERT(engine_cc, CHAR)  -- number to string





/*
What is the difference between CAST and CONVERT?

CAST is the SQL standard syntax, works across all major databases:
*/

CAST(price_inr AS DECIMAL(10,2))
CAST(engine_cc AS CHAR)

/*
CONVERT is MySQL-specific and has two different syntaxes:
*/

-- Type conversion (similar to CAST):
CONVERT(price_inr, DECIMAL(10,2))

-- Character set conversion (unique to CONVERT):
CONVERT(name USING utf8mb4)

/*
That second form — converting character sets — is something only CONVERT can do. CAST can't do it.

Practical rule for you:

Situation                                         |  Use
-------------------------------------------------------------------------------------
Converting data types                             |  Either — CAST is more portable
Converting character sets                         |  CONVERT only
Writing code that might run on PostgreSQL later   |  CAST — it's the standard
Working purely in MySQL                           |  Either works

In DA work you'll almost always be doing type conversion, not character set conversion — so CAST is the safer default habit since it travels across
databases. Most experienced SQL writers default to CAST and only reach for CONVERT when they specifically need the character set form.
*/