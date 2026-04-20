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