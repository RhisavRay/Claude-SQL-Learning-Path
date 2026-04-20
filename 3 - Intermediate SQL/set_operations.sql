/*
Set Operations
Set operations combine the results of two or more queries into a single result set. Think of it like the mathematical idea of sets — union,
intersection, difference.

Three rules that always apply:
    1. Both queries must return the same number of columns
    2. Corresponding columns must have compatible data types
    3. Column names in the final result come from the first query
*/




/*
UNION and UNION ALL

UNION combines two result sets and removes duplicates. UNION ALL combines and keeps everything including duplicates.

UNION ALL is faster because it skips the deduplication step. Use it when you know there are no duplicates or when duplicates are meaningful to keep.
*/

-- All cities where we have customers OR where bikes are manufactured
SELECT city AS location
FROM customers

UNION

SELECT brand AS location
FROM bikes;