# Indian_database_management_system

# 📌 SQL Questions for Indian Railway Database System

## **Basic Level (Fundamentals of SQL)**

### 1️⃣ Retrieve all records from the `Trains` table.
```sql
SELECT * FROM Trains;
```

### 2️⃣ Find the total number of stations in the `Stations` table.
```sql
SELECT COUNT(*) AS Total_Stations FROM Stations;
```

### 3️⃣ Retrieve all trains running on a specific route (e.g., Delhi to Mumbai).
```sql
SELECT * FROM Trains WHERE source_station = 'Delhi' AND destination_station = 'Mumbai';
```

### 4️⃣ Find all passengers who have booked a ticket in the last 30 days.
```sql
SELECT * FROM Passengers WHERE booking_date >= DATEADD(DAY, -30, GETDATE());
```

### 5️⃣ Get details of all bookings where the ticket price is greater than ₹500.
```sql
SELECT * FROM Bookings WHERE ticket_price > 500;
```

### 6️⃣ Find the total number of tickets booked for a specific train (Train_ID = 101).
```sql
SELECT COUNT(*) FROM Tickets WHERE Train_ID = 101;
```

### 7️⃣ Retrieve distinct train types (Express, Superfast, Local) from the `Trains` table.
```sql
SELECT DISTINCT train_type FROM Trains;
```

### 8️⃣ Find the average ticket price for all bookings.
```sql
SELECT AVG(ticket_price) AS Average_Price FROM Tickets;
```

### 9️⃣ Retrieve all trains departing from a specific station (e.g., Mumbai Central).
```sql
SELECT * FROM Trains WHERE source_station = 'Mumbai Central';
```

### 🔟 Find the total number of passengers who traveled in the last month.
```sql
SELECT COUNT(*) FROM Passengers WHERE journey_date >= DATEADD(MONTH, -1, GETDATE());
```

---

## **Intermediate Level (Joins, Grouping, and Aggregations)**

### 1️⃣1️⃣ Find the number of trains available for each source-destination pair.
```sql
SELECT source_station, destination_station, COUNT(*) AS Number_of_Trains 
FROM Trains 
GROUP BY source_station, destination_station;
```

### 1️⃣2️⃣ List the top 5 busiest stations (based on total departures).
```sql
SELECT source_station, COUNT(*) AS Departures 
FROM Trains 
GROUP BY source_station 
ORDER BY Departures DESC 
LIMIT 5;
```

### 1️⃣3️⃣ Get the total revenue generated from ticket sales for each train.
```sql
SELECT t.Train_Name, SUM(b.ticket_price) AS Total_Revenue 
FROM Tickets b 
JOIN Trains t ON b.Train_ID = t.Train_ID 
GROUP BY t.Train_Name;
```

### 1️⃣4️⃣ Find all passengers who have booked tickets for more than 3 different trains.
```sql
SELECT Passenger_ID, COUNT(DISTINCT Train_ID) AS Unique_Trains 
FROM Tickets 
GROUP BY Passenger_ID 
HAVING COUNT(DISTINCT Train_ID) > 3;
```

### 1️⃣5️⃣ Retrieve the most frequently booked train based on ticket sales.
```sql
SELECT TOP 1 Train_ID, COUNT(*) AS Total_Bookings 
FROM Tickets 
GROUP BY Train_ID 
ORDER BY Total_Bookings DESC;
```

---

## **Advanced Level (Window Functions, Subqueries, Performance Optimization)**

### 2️⃣1️⃣ Rank the top 5 highest revenue-generating trains.
```sql
SELECT Train_ID, SUM(ticket_price) AS Total_Revenue, 
       RANK() OVER (ORDER BY SUM(ticket_price) DESC) AS Revenue_Rank 
FROM Tickets 
GROUP BY Train_ID 
LIMIT 5;
```

### 2️⃣2️⃣ Find the customer who has spent the most on tickets.
```sql
SELECT Passenger_ID, SUM(ticket_price) AS Total_Spending 
FROM Tickets 
GROUP BY Passenger_ID 
ORDER BY Total_Spending DESC 
LIMIT 1;
```

### 2️⃣3️⃣ Calculate the month-over-month percentage change in ticket sales.
```sql
SELECT FORMAT(booking_date, 'yyyy-MM') AS Month, 
       COUNT(*) AS Ticket_Sales,
       LAG(COUNT(*)) OVER (ORDER BY FORMAT(booking_date, 'yyyy-MM')) AS Previous_Month_Sales,
       (COUNT(*) - LAG(COUNT(*)) OVER (ORDER BY FORMAT(booking_date, 'yyyy-MM'))) * 100.0 / NULLIF(LAG(COUNT(*)) OVER (ORDER BY FORMAT(booking_date, 'yyyy-MM')), 0) AS MoM_Change
FROM Tickets 
GROUP BY FORMAT(booking_date, 'yyyy-MM') 
ORDER BY Month;
```

### 2️⃣4️⃣ Retrieve the longest-distance train route.
```sql
SELECT Train_ID, MAX(distance_km) AS Max_Distance 
FROM Trains 
GROUP BY Train_ID 
ORDER BY Max_Distance DESC 
LIMIT 1;
```

### 2️⃣5️⃣ Find the total revenue generated from each station (considering both departures and arrivals).
```sql
SELECT s.station_name, 
       SUM(t.ticket_price) AS Total_Revenue 
FROM Tickets t
JOIN Stations s ON t.source_station = s.station_name OR t.destination_station = s.station_name
GROUP BY s.station_name 
ORDER BY Total_Revenue DESC;
```
