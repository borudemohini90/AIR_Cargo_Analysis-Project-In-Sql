 -- Creating Database AIR_INFORMATION and querying to start using it.
  Create Database AIR_INFORMATION
 --Write a query to create route_detailes table using suitable data types for the fields, 
 --such as route_id, flight_num, origin_airport, destination_airport, aircraft_id,
 --and distance_miles. Implement the check constraint for the flight number and 
 --unique constraint for the route_id fields. 
 --Also, make sure that the distance miles field is greater than 0.
   CREATE TABLE  route_detailes2(route_id INT 
							, flight_num2 VARCHAR(20) 
							, origin_airport VARCHAR(10)
							, destination_airport VARCHAR(10)
							, aircraft_id VARCHAR(50)
							, distance_miles INT
							, CHECK (flight_num2 IS NOT NULL)
							, UNIQUE (route_Id)
							, CHECK (distance_miles > 0)
							,PRIMARY KEY(route_id)
							,CONSTRAINT Flight_num2 CHECK ((substring(flight_num2,1,2) = '11')) )
                       
Select * from ticket_details
							

 --Write a query to display all the passengers (customers) who have travelled 
 --in routes 01 to 25. Take data  from the passengers_on_flights table.
  SELECT * FROM passengers_on_flights
  WHERE route_id between 1 and 25

 --Write a query to identify the number of passengers and total revenue in 
 --business class from the ticket_details table.

  SELECT count(customer_id) AS Passangers,
  sum(Price_per_ticket) AS Total_revenue
  FROM ticket_details
  WHERE class_id = 'Bussiness'

 --Write a query to display the full name of the customer by extracting the
 --first name and last name from the customer table.

  SELECT concat(first_name,' ',last_name) AS 'full Name'
  FROM customer

 --Write a query to extract the customers who have registered and booked a ticket. 
 --Use data from the customer and ticket_details tables.

  SELECT DISTINCT t.customer_id,
  concat(c.first_name,' ',c.last_name) AS 'full Name'
  FROM ticket_details AS t 
  JOIN customer AS c ON t.customer_id = c.customer_id

 --Write a query to identify the customer’s first name and last name based on
 --their customer ID and brand (Emirates) from the ticket_details table.

  SELECT customer.customer_id,
  CONCAT(first_name,' ',last_name) AS 'full name',
  brand AS Brand
  FROM ticket_details
  JOIN customer ON customer.customer_id = ticket_details.customer_id 
  WHERE brand = 'Emirates'

 --Write a query to identify the customers who have travelled by Economy Plus 
 --class using Group By and Having clause on the passengers_on_flights table.
  SELECT c.customer_id
  , first_name
  , last_name
  , class_id
  FROM passengers_on_flights AS p
  JOIN customer AS c ON c.customer_id = p.customer_id
  GROUP BY c.customer_id, first_name, last_name, class_id
  HAVING class_id = 'Economy Plus'


 --Write a query to identify whether the revenue has crossed 10000 using the IF
 --clause on the ticket_details table.

  SELECT CASE WHEN SUM(Price_per_ticket)>10000 
				THEN 'Yes' 
				ELSE  'No' 
				END AS 'Revenue Crossed 10000?'
  FROM ticket_details

 --Write a query to create and grant access to a new user to perform operations on a database.

  CREATE LOGIN USER111 WITH PASSWORD= 'USER1'

  CREATE USER USER111 FOR LOGIN USER111

  GRANT SELECT ON DATABASE:: AIR_INFORMATION TO USER111

 --Write a query to find the maximum ticket price 
 --for each class using window functions on the ticket_details table.

  SELECT customer_id
  ,class_id
  , no_of_tickets
  , Price_per_ticket
  , MAX(Price_per_ticket) OVER(PARTITION BY class_id ) AS class_wise_price_per_ticket
  FROM ticket_details

 --Write a query to extract the passengers whose route ID is 4 by improving the 
 --speed and performance of the passengers_on_flights table.

  SELECT * 
  FROM passengers_on_flights
  WHERE route_id = 4

 -- For the route ID 4, write a query to view the execution plan of the 
 -- passengers_on_flights table.

  SELECT *
  FROM passengers_on_flights
  WHERE route_id = 4 

 --Write a query to calculate the total price of all tickets booked by a customer
 --across different aircraft IDs using rollup function.

  SELECT COALESCE(CONVERT(VARCHAR(30),customer_id),'Total')
  , COALESCE(aircraft_id,'Total') AS Aircraft_ID
  , SUM(Price_per_ticket) AS Total_price
  FROM ticket_details
  GROUP BY ROLLUP(customer_id,aircraft_id)

 --Write a query to create a view with only business class customers 
 --along with the brand of airlines.
 Go

  CREATE OR ALTER VIEW buisness_class_customers_along_brand_airline
  AS
  SELECT c.*, brand 
  FROM ticket_details AS t
  JOIN customer AS c ON c.customer_id = t.customer_id
  WHERE class_id = 'Buisness';
  
 Go
  Select * From buisness_class_customers_along_brand_airline;
  

 --Write a query to create a stored procedure to get the details of 
 --all passengers flying between a range of routes defined in run time.
 --Also, return an error message if the table doesn't exist.
 Go
  CREATE OR ALTER PROCEDURE Flight_route_range @route1 INT, @route2 INT
  AS
  BEGIN
	DECLARE @customer_table_exist INT
	DECLARE @passanger_table_exist INT
	DECLARE @no_rows INT
	SELECT @customer_table_exist = count(*) 
	FROM INFORMATION_SCHEMA.TABLES
	WHERE TABLE_NAME ='customer'

	SELECT @passanger_table_exist = count(*) 
	FROM INFORMATION_SCHEMA.TABLES
	WHERE TABLE_NAME ='passengers_on_flights'

	IF @passanger_table_exist = 0 OR @customer_table_exist = 0
	BEGIN
		PRINT 'ERROR: Either Customer or passanger_on_flight is not exist.'
	END
	ELSE 
	BEGIN
	SET @no_rows = (SELECT COUNT(*) 
					FROM passengers_on_flights AS p
					WHERE p.route_id BETWEEN @route1 AND @route2)
	END
	IF @no_rows = 0 
	BEGIN
		PRINT 'No Record Found between the given route range.'
	END
	ELSE
	BEGIN
		SELECT c.*
		, p.route_id
		, p.depart
		, p.arrival
		, p.seat_num
		FROM customer AS c
		JOIN passengers_on_flights AS p ON c.customer_id = p.customer_id
		WHERE p.route_id BETWEEN @route1 AND @route2
	END
END
Go
  Flight_route_range @route1 =1, @route2 =6

 --Write a query to create a stored procedure that extracts all the details from 
 --the routes table where the travelled distance is more than 2000 miles.
  
  Go
  CREATE OR ALTER PROCEDURE Travelled_distance_more_than_2000
  AS
  BEGIN
	SELECT *
	FROM routes
	WHERE distance_miles >'2000'
  END;
  Go
  EXEC Travelled_distance_more_than_2000
  
 --Write a query to create a stored procedure that groups the distance travelled 
 --by each flight into three categories. The categories are, short distance travel
 --(SDT) for >=0 AND <= 2000 miles, intermediate distance 
 --travel (IDT) for >2000 AND <=6500, and long-distance travel (LDT) for >6500.
  Go
  CREATE OR ALTER PROCEDURE DistanceTravelled
  AS
  SELECT *,
  CASE WHEN distance_miles >= 0 and distance_miles <=2000 THEN 'SDT' 
  WHEN distance_miles> 2000 and distance_miles < = 6500 THEN 'IDT'
  ELSE 'LDT' END AS Category
  FROM routes

  DistanceTravelled

 --Write a query to extract ticket purchase date, customer ID, 
 --class ID and specify if the complimentary services are provided
 --for the specific class using a stored function in stored procedure
 --on the ticket_details table.
 -- Condition:
 --if the class is Business and Economy Plus, then complimentary services
 --are given as Yes, else it is No
  Go
  CREATE  OR ALTER FUNCTION Comp_Service(@class VARCHAR(30))
  RETURNS VARCHAR(30)
  AS
  BEGIN
	DECLARE @res VARCHAR(10)
	IF @class = 'Bussiness' OR @class = 'Economy Plus'
	BEGIN
		SET @res = 'Yes'
	END
	ELSE
	BEGIN
		SET @res = 'No'
	END
	RETURN @res
  END
 Go
  CREATE OR ALTER PROCEDURE TicketDetailsWithCompServices
  AS
  BEGIN
	SELECT p_date
	, customer_id
	,class_id
	,dbo.Comp_Service(class_id) AS 'Complimentary services'
	FROM ticket_details
  END
  Go
  TicketDetailsWithCompServices

 -- Write a query to extract the first record of the customer whose last name ends 
 --with Scott using a cursor from the customer table.

  DECLARE cursor_name CURSOR
	FOR SELECT * 
		FROM customer
		WHERE last_name = 'Scott' ORDER BY customer_id DESC

  OPEN cursor_name
	 DECLARE @c_id INT, @fname VARCHAR(20), @lname VARCHAR(20),
			@dob VARCHAR(20), @gender VARCHAR(20)
	FETCH NEXT FROM cursor_name INTO @c_id,@fname, @lname, @dob, @gender
	SELECT @c_id AS customer_id,@fname AS f_name, @lname AS l_name, @dob AS DOB, @gender AS gender
  CLOSE cursor_name
  DEALLOCATE cursor_name


