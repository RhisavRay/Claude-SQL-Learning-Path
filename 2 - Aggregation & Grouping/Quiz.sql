/*
Q1. Write a query that returns each city from the customers table along with the number of customers in that city. Only show cities with more than
1 customer.
*/

SELECT
	city,
    COUNT(city) AS No_of_people
FROM customers
GROUP BY city
HAVING No_of_people > 1;


/*
Q2. Write a query showing each customer's name and the most expensive bike they've ever ordered (by price_inr). Only include customers who have
placed at least one order.
*/




/*
Q3. Write a query that returns all bikes that have never been ordered. Show brand, model, and type.
*/




/*
Q4. We need to add a new order to the system:
    
    order_id: 16
    Customer: Vikram Singh
    Bike: KTM 250 Duke
    order_date: today's date
    quantity: 1, discount: 0.00

Write the INSERT — but look up the correct customer_id and bike_id from the data yourself rather than hardcoding from memory.
*/




/*
Q5. Without running it — what is wrong with this query, and what would you change?

    SELECT brand, COUNT(*) as total
    FROM bikes
    WHERE total > 2
    GROUP BY brand;

Explain the problem and write the corrected version.
*/

