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




/*
Task 5 — Functions:

5a. Write a query that returns a single column called bike_summary containing a formatted string for each bike, like:
"Royal Enfield - Classic 350 (Cruiser) | ₹192000"
Use CONCAT to build this. All text should be in the exact format shown.
*/

SELECT
    CONCAT(brand, ' - ', model, ' (', type, ') | ', COALESCE(price_inr, 0)) AS Bike_details
FROM bikes;


/*
5b. Write a query that returns each customer's name, how many days they've been a member as of today, and a loyalty_tier column using CASE WHEN:

Less than 365 days → 'New'
365 to 1095 days (1–3 years) → 'Regular'
More than 1095 days → 'Loyal'
*/

SELECT
    name,
    DATEDIFF(CURDATE(), member_since) as days_of_membership,
    CASE
        WHEN DATEDIFF(CURDATE(), member_since) < 365 THEN 'New'
        WHEN DATEDIFF(CURDATE(), member_since) < 1095 THEN 'Regular'
        ELSE 'Loyal'
    END AS loyalty_tier
FROM customers


/*
5c. Write a query showing each bike's model, price_inr, price_usd (converted at ₹83.5 per dollar, rounded to 2 decimal places), and a segment column:

Under ₹2,00,000 → 'Budget'
₹2,00,000 to ₹5,00,000 → 'Mid-range'
Above ₹5,00,000 → 'Premium'
*/

SELECT
    model,
    COALESCE(price_inr, 0.0),
    ROUND(COALESCE(price_inr, 0) / 83.5, 2) AS price_usd,
    CASE
        WHEN price_inr < 200000 THEN 'Budget'
        WHEN price_inr < 500000 THEN 'Mid-range'
        WHEN price_inr >= 500000 THEN 'Premium'
        ELSE 'Price is unavailable'
    END AS segment
FROM bikes;


/*
5d. Using COALESCE, write a query that returns all bikes with their model and price_inr — but where price_inr is NULL, show 0 instead.
*/

