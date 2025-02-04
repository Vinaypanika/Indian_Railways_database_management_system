# Indian Railway Database Management System

## 📌 SQL Questions for Indian Railway Database System

---

## **Basic Level (Fundamentals of SQL)**

### 1. Retrieve all records from the `Trains` table.
```sql
select * from trains;
```

### 2. Find the total number of stations in the `Stations` table.
```sql
select count(*) from stations;
```

### 3. Retrieve all trains running on a specific route (e.g., New Delhi to Mumbai Central).
```sql
select distinct t.train_name,t.train_type,t.train_id from trains as t
inner join bookings as b
on t.train_id = b.train_id
where b.source_station_id = (select station_id from stations where station_name = 'New Delhi')
and b.destination_station_id = (select station_id from stations where station_name = 'Mumbai Central');
```

### 4. Get details of all bookings where the ticket price is greater than ₹450.
```sql
select b.booking_id,b.passenger_id,b.train_id,b.Journey_date,t.fare_amount  from bookings as b
inner join tickets as t on b.booking_id = t.booking_id
where t.fare_amount > 450
order by t.fare_amount  desc;
```

### 5. Find the total number of tickets booked for a specific train (Train_ID = 23).
```sql
select count(*) from bookings
where train_id = 23;
```

### 6. Retrieve distinct train types from the `Trains` table.
```sql
select distinct train_type from trains;
```

### 7. Find the average ticket price for all bookings.
```sql
select avg(fare_amount) as avg_amount from tickets;
```

### 8. Retrieve all trains departing from a specific station (e.g., Mumbai Central).
```sql
select t.train_id,t.train_name,t.train_type,s.station_name from trains as t
inner join bookings as b on b.train_id = t.train_id
inner join stations as s on s.station_id = b.source_station_id
where b.source_station_id = (select station_id from stations
where station_name = 'Mumbai central')
group by t.train_id,t.train_name,t.train_type,s.station_name;
```

### 9. Find the total number of passengers who traveled in the last month.
```sql
select count(*) as Total_passengers from bookings
where journey_date < getdate()
and journey_date >= dateadd(month,-1,getdate());
```

### 10. Find the average ticket price for each train type.
```sql
select t.train_type,avg(tk.fare_amount) as Average_amount from trains as t
inner join bookings as b on b.train_id = t.train_id
inner join tickets as tk on b.booking_id=tk.booking_id
group by t.train_type
order by avg(tk.fare_amount) desc;
```

---

## **Intermediate Level (Joins, Grouping, and Aggregations)**

### 11. Find the number of trains available for each source-destination pair.
```sql
select ss.station_name as source_station,ds.station_name as destination_station,
count(*) as Trains_available from trains as t
inner join bookings as b on t.train_id = b.train_id
inner join stations as ss on ss.station_id = b.source_station_id
inner join stations as ds on ds.station_id = b.destination_station_id
where b.source_station_id != b.destination_station_id
group by ss.station_name,ds.station_name
order by count(*) desc ;
```

### 12. List the top 5 busiest stations (based on total departures and arrivals).
```sql
select top 5 s.station_name,count(*) as Total_departure from stations as s
inner join bookings as b on b.source_station_id=s.station_id
group by s.station_name
order by count(*) desc;
```
### Based on total Arrival

```sql
select top 5 s.station_name,count(*) as Total_arrival from stations as s
inner join bookings as b on b.destination_station_id=s.station_id
group by s.station_name
order by count(*) desc;
```

### 13. Get the total revenue generated from ticket sales for each train.
```sql
select t.train_id,t.train_name,sum(tk.fare_amount) as Total_revenue from trains as t
inner join bookings as b on b.train_id = t.train_id
inner join tickets as tk on tk.booking_id = b.booking_id
group by t.train_id,t.train_name
order by t.train_id;
```

### 14. Find all passengers who have booked tickets for more than 3 different trains.
```sql
select p.passenger_id,p.full_name,
count(distinct b.train_id) as Ticket_for_train from Passengers as p
inner join bookings as b on b.passenger_id = p.passenger_id
group by p.passenger_id,p.full_name
having count(distinct b.train_id) > 3;
```

### 15. Retrieve the most frequently booked train based on ticket sales.
```sql
select t.train_name,count(tk.ticket_id) as Total_sales from trains as t
 inner join bookings as b on b.train_id = t.train_id
 inner join tickets as tk on tk.booking_id = b.booking_id
 group by t.train_name
 order by count(tk.ticket_id) desc
```

---

## **Advanced Level (Window Functions, Subqueries, Performance Optimization)**

### 16. Rank the top 5 highest revenue-generating trains.
```sql
select train_name,total_sales,
rank() over(order by total_sales desc) as Rank_based_on_sales
from
(select t.train_name,sum(tk.fare_amount) as Total_sales from trains as t
 inner join bookings as b on b.train_id = t.train_id
 inner join tickets as tk on tk.booking_id = b.booking_id
 group by t.train_name)t;
```

### 17. Find the customer who has spent the most on tickets.
```sql
select top 1 p.passenger_id,p.full_name,
sum(tk.fare_amount) as total_spending from Passengers as p
inner join bookings as b on b.passenger_id = p.passenger_id
inner join tickets as tk on tk.booking_id = b.booking_id
group by p.passenger_id,p.full_name
order by sum(tk.fare_amount) desc;
```

### 18. Find the total revenue generated from each station (considering both departures and arrivals).
```sql

select s.station_name,
sum(case when b.source_station_id = s.station_id then tk.fare_amount else 0 end) +
sum(case when b.destination_station_id = s.station_id then tk.fare_amount else 0 end) as total_revenue
from stations as s
left join  bookings as b on b.source_station_id = s.station_id or b.destination_station_id = s.station_id
left join tickets as tk on tk.booking_id = b.booking_id
group by s.station_name
order by total_revenue desc;

```

### 19. Find the train with the maximum number of cancellations.
```sql
select t.train_name,count(b.booking_id) as Cencellations from bookings as b
inner join trains as t on t.train_id = b.train_id
where b.booking_status = 'Cancelled'
group by t.train_name
order by count(b.booking_id) desc ;
```


## 📞 Contact

If you have any questions or want to connect, feel free to reach out:

- 📧 Email: [vinaypanika@gmail.com](mailto:vinaypanika@gmail.com)
- 💼 LinkedIn: [Vinay Kumar Panika](https://www.linkedin.com/in/vinaykumarpanika)
- 📂 GitHub: [VinayPanika](https://github.com/Vinaypanika)
- 🌐 Portfolio: [Visit My Portfolio](https://sites.google.com/view/vinaykumarpanika/home)
- 📞 Mobile: [+91 7415552944](tel:+917415552944)




