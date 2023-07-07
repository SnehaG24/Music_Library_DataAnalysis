-- did data analysis on music store 

SET SESSION sql_mode=(SELECT REPLACE(@@sql_mode,'ONLY_FULL_GROUP_BY',''));
select * from album;
select * from artist;
select * from employee;
select * from media_type;
select * from customer;
select * from invoice;
select * from genre;
select * from invoice_line;
select * from playlist;
select * from playlist_track;
select * from track;

-- fetch invoice date only

select date(invoice_date) from invoice;

-- fetch only date from invoice

select invoice_date , day(invoice_date)  from invoice;

-- fetch day from invoice date

select invoice_date , dayname(invoice_date)  from invoice;


--  Who is the senior employee based on job title?

select * from employee
order by levels desc limit 1;

--  Which countries have the most Invoices?

select billing_country , count(invoice_id) AS TOTAL_NO_OF_INVOICES
from invoice
group by billing_country
order by count(invoice_id) desc
limit 1 ;


--  What are top 3 values of total invoice?

select * from invoice
order by total desc limit 3;

--  Write a query that returns one city that has the highest sum of invoice totals. Return both the city name & sum of all invoice totals

select billing_city AS City_Name, sum(total) AS Invoice_total
from invoice
group by billing_city 
order by sum(total) desc 
limit 1;

--  Who is the best customer? The customer who has spent the most money will be declared the best customer. Write a query that returns the person who has spent the most money

-- select * from customer;

select invoice.customer_id , sum(invoice.total)
from invoice
join customer
on invoice.customer_id = customer.customer_id
group by invoice.customer_id
order by sum(invoice.total) desc 
limit 1 ;

-- another method 

select concat(first_name , last_name) AS best_customername , customer_id , address , city , phone , email 
from customer
where customer_id = (
select invoice.customer_id
from invoice
join customer
on invoice.customer_id = customer.customer_id
group by invoice.customer_id
order by sum(invoice.total) desc 
limit 1);

-- ANOTHER METHOD 

select * 
from customer
join invoice
on invoice.customer_id = customer.customer_id
where customer.customer_id = (
select invoice.customer_id
from invoice
join customer
on invoice.customer_id = customer.customer_id
group by invoice.customer_id
order by sum(invoice.total) desc 
limit 1);


-- which day were the most deliveries/orders taken or customer ordered 
-- On which day do we receive the most customer orders

select dayname(invoice_date) , count(dayname(invoice_date))
from invoice
group by dayname(invoice_date) 
order by count(dayname(invoice_date)) desc
limit 1; 


--  Write query to return the email, first name, last name, & Genre of all Rock Music listeners. 

select customer_id , first_name , last_name , email 
from customer
where customer_id IN(
select distinct customer_id
from invoice
where invoice_id IN (
select distinct invoice_line.invoice_id
from invoice
join invoice_line
on invoice.invoice_id  = invoice_line.invoice_id
where invoice_line.track_id IN (
select track.track_id 
from track
join genre
on track.genre_id = genre.genre_id
where genre.name = 'Rock'
)))
order by email;


-- Let's invite the artists who have written the most rock music in our dataset. Write a query that returns the Artist name and total track count of the top 10 rock bands

select artist.artist_id  ,  artist.name , count(artist.artist_id) AS number_of_songs
from track
join album on album.album_id = track.album_id
join artist on artist.artist_id = album.artist_id
join genre on genre.genre_id = track.genre_id
where genre.name like 'Rock'
group by artist.artist_id 
order by number_of_songs desc
limit 10;

--  Return all the track names that have a song length longer than the average song length. Return the Name and Milliseconds for each track. Order by the song length with the longest songs listed first

select  name , milliseconds , track_id
from track
where milliseconds > (
select avg(milliseconds)
from track)
order by milliseconds desc;

-- Type of jobs people doing in this music store data

select distinct title
from employee ;

-- From which city do the most orders come

select billing_city , count(invoice_id)
from invoice
group by billing_city
order by count(invoice_id) desc
limit 1;

-- join artist and album 
-- Retrieve the complete data including the name of the song and the artist name who has sung that song

select *
from album
join artist 
on album.artist_id = artist.artist_id;

-- song sung by particular artist 

select album.title
from album
join artist
on album.artist_id = artist.artist_id
where artist.name = 'Deep Purple';

-- fetch first_name , last name , email and phone number of customer who lives in Delhi

select customer.first_name , customer.last_name , customer.phone , customer.email , invoice.billing_city , invoice.total
from customer
join invoice
on customer.customer_id = invoice.customer_id 
where invoice.billing_city = 'Delhi';

-- To extract the real address of customers, along with their billing address or delivery address 

select customer.first_name , customer.last_name , customer.address , invoice.billing_address , invoice.billing_country
from customer
join invoice
on customer.customer_id = invoice.customer_id;

-- -- To extract the real address of customers, along with their billing address or delivery address from india

select customer.first_name , customer.last_name , customer.address , invoice.billing_address , invoice.billing_country
from customer
join invoice
on customer.customer_id = invoice.customer_id
where invoice.billing_country = 'India' And invoice.billing_city = 'Bangalore';