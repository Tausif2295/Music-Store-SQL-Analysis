select * from album

Q1: who is the senior most employee based on job title?

select * from employee
order by levels desc
limit 1

Q2: which countries have the most invoices?
select * from invoice
select count(*) as c, billing_country 
from invoice
group by billing_country
order by c desc

Q3: what are top 3 values of total invoice?

select * from invoice
order by total desc
limit 3

Q4: which city has the best customers? we would like to throw a promotional music festival
in the city we made the most money. write a query that returns one city that has the highest
sum of invoice totals.returns both the city name and sum of all invoice totals.



select sum(total) invoice_total, billing_city from invoice
group by billing_city
order by invoice_total desc

who is the best customer? The customer who has spent the most money will be declared the best
customer. Write a query that returns the person who has spent the most money.

select customer.customer_id, customer.first_name,customer.last_name,sum (invoice.total) as total
from customer
join invoice on customer.customer_id = invoice.customer_id
group by customer.customer_id 
order by total desc
limit 3

---write a query to return email, first name, last name,& genre of all rock music listeners
---return your list ordered alphabetically by email starting with 	A
select * from genre
select distinct email, first_name, last_name  
from customer
join invoice on customer.customer_id = invoice.customer_id
join invoice_line on invoice.invoice_id = invoice_line.invoice_id
where track_id in(
	select track_id from track
	join genre on track.genre_id = genre.genre_id
	where genre.name like 'Rock'
)
order by email;

---lets invite the artist who have written the most rock music in our dataset. 
---write a query that returns the artist name and the total track count of the top 10 rock bands.

select artist.artist_id, artist.name, count(artist.artist_id) as no_of_songs
from track
join album on album.album_id = track.album_id
join artist on artist.artist_id = album.artist_id
join genre on genre.genre_id = track.genre_id
where genre.name like 'Rock'
group by artist.artist_id
order by no_of_songs desc
limit 10;

---return all the track names that have a song lenght longer than the average song length.
---return the name and milliseconds for each track. order by the song length with the longest songs 
---listed first.

select name, milliseconds
from track
where milliseconds >(
	select avg (milliseconds) as avg_track_length
	from track)
order by milliseconds desc

---find how much amount spent by each customer on artist? write a query to return customer name,
---artist name and total spent.

WITH best_selling_artist AS (
    SELECT 
        artist.artist_id AS artist_id, 
        artist.name AS artist_name,
        SUM(invoice_line.unit_price * invoice_line.quantity) AS total_sales
    FROM 
        invoice_line
    JOIN 
        track ON track.track_id = invoice_line.track_id
    JOIN 
        album ON album.album_id = track.album_id
    JOIN 
        artist ON artist.artist_id = album.artist_id
    GROUP BY 
        artist.artist_id, artist.name
    ORDER BY 
        total_sales DESC
    LIMIT 1
)
SELECT 
    c.customer_id, 
    c.first_name, 
    c.last_name, 
    bsa.artist_name,
    SUM(il.unit_price * il.quantity) AS amount_spent
FROM 
    invoice i
JOIN 
    customer c ON c.customer_id = i.customer_id
JOIN 
    invoice_line il ON il.invoice_id = i.invoice_id
JOIN 
    track t ON t.track_id = il.track_id
JOIN 
    album alb ON alb.album_id = t.album_id
JOIN 
    best_selling_artist bsa ON bsa.artist_id = alb.artist_id
GROUP BY 
    c.customer_id, c.first_name, c.last_name, bsa.artist_name
ORDER BY 
    amount_spent DESC;
	
---we want to find out the most popular genre for each country. we determine the most popular
---genre with the highest amount of purchases. write a query that returns each country with 
---the top genre. for the countries where the maximum number of purchases is shared return all genres.

with popular_genre as(
	select count(invoice_line.quantity) as purchases, customer.country, genre.name, genre.genre_id,
	row_number() over(partition by customer.country order by count (invoice_line.quantity)desc) as row_no
	from invoice_line
	join invoice on invoice.invoice_id = invoice_line.invoice_id
	join customer on customer.customer_id = invoice.customer_id
	join track on track.track_id = invoice_line.track_id
	join genre on genre.genre_id = track.genre_id
	group by 2,3,4
	order by 2 asc,1 desc
)
select * from popular_genre where row_no <=1




















