CREATE OR ALTER VIEW buisness_class_customers_along_brand_airline
AS
SELECT c.*, brand 
FROM ticket_details AS t
JOIN customer AS c ON c.customer_id = t.customer_id
WHERE class_id = 'Bussiness';

GO

SELECT * 
 FROM ticket_details;

 Go



