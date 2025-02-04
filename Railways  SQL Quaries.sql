--Basic Level (Fundamentals of SQL)

-- Que-1 Retrieve all records from the Trains table. 

 select * from trains;

--Que-2 Find the total number of stations in the Stations table.
select count(*) from stations;

--Que-3 Retrieve all trains running on a specific route (e.g., New Delhi to Mumbai Central).

select distinct t.train_name,t.train_type,t.train_id from trains as t
inner join bookings as b
on t.train_id = b.train_id
where b.source_station_id = (select station_id from stations where station_name = 'New Delhi')
and b.destination_station_id = (select station_id from stations where station_name = 'Mumbai Central');


--Que-4 Get details of all bookings where the ticket price is greater than ₹450.

select b.booking_id,b.passenger_id,b.train_id,b.Journey_date,t.fare_amount  from bookings as b
inner join tickets as t on b.booking_id = t.booking_id
where t.fare_amount > 450
order by t.fare_amount  desc;

--Que-5 Find the total number of tickets booked for a specific train (Train_ID = 23).
select count(*) from bookings
where train_id = 23;

--Que-6 Retrieve distinct train types  from the Trains table.

select distinct train_type from trains;





--Que-7 Find the average ticket price for all bookings.

select avg(fare_amount) as avg_amount from tickets;

--Que-8 Retrieve all trains departing from a specific station (e.g., Mumbai Central)

select t.train_id,t.train_name,t.train_type,s.station_name from trains as t
inner join bookings as b on b.train_id = t.train_id
inner join stations as s on s.station_id = b.source_station_id
where b.source_station_id = (select station_id from stations
where station_name = 'Mumbai central')
group by t.train_id,t.train_name,t.train_type,s.station_name;



--Que-9 Find the total number of passengers who traveled in the last month.

select count(*) as Total_passengers from bookings
where journey_date < getdate()
and journey_date >= dateadd(month,-1,getdate())

--Que-10 Find the average ticket price for all train_type.

select t.train_type,avg(tk.fare_amount) as Average_amount from trains as t
inner join bookings as b on b.train_id = t.train_id
inner join tickets as tk on b.booking_id=tk.booking_id
group by t.train_type
order by avg(tk.fare_amount) desc;







--Intermediate Level (Joins, Grouping, and Aggregations)


--Que-11 Find the number of trains available for each source-destination pair.

select ss.station_name as source_station,ds.station_name as destination_station,
count(*) as Trains_available from trains as t
inner join bookings as b on t.train_id = b.train_id
inner join stations as ss on ss.station_id = b.source_station_id
inner join stations as ds on ds.station_id = b.destination_station_id
where b.source_station_id != b.destination_station_id
group by ss.station_name,ds.station_name
order by count(*) desc ;

--Que-12List the top 5 busiest stations (based on total departures).

select top 5 s.station_name,count(*) as Total_departure from stations as s
inner join bookings as b on b.source_station_id=s.station_id
group by s.station_name
order by count(*) desc;
 
 -- based on total arrivals 
 select top 5 s.station_name,count(*) as Total_arrival from stations as s
inner join bookings as b on b.destination_station_id=s.station_id
group by s.station_name
order by count(*) desc;







--Que-13Get the total revenue generated from ticket sales for each train.

select t.train_id,t.train_name,sum(tk.fare_amount) as Total_revenue from trains as t
inner join bookings as b on b.train_id = t.train_id
inner join tickets as tk on tk.booking_id = b.booking_id
group by t.train_id,t.train_name
order by t.train_id;


--Que-14Find all passengers who have booked tickets for more than 3 different trains.

select p.passenger_id,p.full_name,
count(distinct b.train_id) as Ticket_for_train from Passengers as p
inner join bookings as b on b.passenger_id = p.passenger_id
group by p.passenger_id,p.full_name
having count(distinct b.train_id) > 3

--Que-15Retrieve the most frequently booked train based on ticket sales.
 
 select t.train_name,count(tk.ticket_id) as Total_sales from trains as t
 inner join bookings as b on b.train_id = t.train_id
 inner join tickets as tk on tk.booking_id = b.booking_id
 group by t.train_name
 order by count(tk.ticket_id) desc

--Advanced Level (Window Functions, Subqueries, Performance Optimization)

--Que-16 Rank the top 5 highest revenue-generating trains.
select train_name,total_sales,
rank() over(order by total_sales desc) as Rank_based_on_sales
from
(select t.train_name,sum(tk.fare_amount) as Total_sales from trains as t
 inner join bookings as b on b.train_id = t.train_id
 inner join tickets as tk on tk.booking_id = b.booking_id
 group by t.train_name)t;

--Que-17 Find the customer who has spent the most on tickets.

select top 1 p.passenger_id,p.full_name,
sum(tk.fare_amount) as total_spending from Passengers as p
inner join bookings as b on b.passenger_id = p.passenger_id
inner join tickets as tk on tk.booking_id = b.booking_id
group by p.passenger_id,p.full_name
order by sum(tk.fare_amount) desc;


/* Que-18 Find the total revenue generated from each station 
(considering both departures and arrivals). */


select s.station_name,
sum(case when b.source_station_id = s.station_id then tk.fare_amount else 0 end) +
sum(case when b.destination_station_id = s.station_id then tk.fare_amount else 0 end) as total_revenue
from stations as s
left join  bookings as b on b.source_station_id = s.station_id or b.destination_station_id = s.station_id
left join tickets as tk on tk.booking_id = b.booking_id
group by s.station_name
order by total_revenue desc;

-- Que-19 Find the train with the maximum number of cancellations.

select t.train_name,count(b.booking_id) as Cencellations from bookings as b
inner join trains as t on t.train_id = b.train_id
where b.booking_status = 'Cancelled'
group by t.train_name
order by count(b.booking_id) desc ;