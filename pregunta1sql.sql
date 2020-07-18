--Obtener el nombre de las ciudades de Chile
SELECT city FROM country AS co INNER JOIN city AS ci ON co.country_id=ci.country_id WHERE lower(co.country)='CHILE';

--Obtener los clientes asociados a la ciudad de Santiago
SELECT cu.first_name, cu.last_name FROM city AS ci, address AS ad, customer AS cu WHERE ci.city_id=ad.city_id AND ad.address_id=cu.address_id AND lower(ci.city)='Santiago';

--Obtener las ciudades que no tienen clientes
SELECT ci.city FROM city AS ci LEFT JOIN address AS ad ON ci.city_id=ad.city_id LEFT JOIN customer AS cu ON ad.address_id=cu.address_id GROUP BY city HAVING COUNT(customer_id)=0;

--Cantidad de arriendo de pelC-culas por tienda, ordenado de la mayor a la menor
SELECT s.store_id, COUNT(re.rental_id) AS n_rental FROM store AS s INNER JOIN customer AS cu ON s.store_id=cu.store_id LEFT JOIN rental AS re ON re.customer_id=cu.customer_id GROUP BY store_id ORDER BY n_rental DESC;

--Las 5 ciudades con mayor cantidad de arriendos de pelC-culas
SELECT city, COUNT(rental_id) as n_rental FROM city AS ci LEFT JOIN address AS ad ON ci.city_id=ad.city_id LEFT JOIN customer AS cu ON ad.address_id=cu.address_id LEFT JOIN rental AS re ON cu.customer_id=re.customer_id GROUP BY ci.city ORDER BY n_rental DESC LIMIT 5;

--Anio/mes con mayor cantidad de arriendo de pelC-culas
SELECT COUNT(r.rental_id) AS NUMBER_RENTALS, MONTH(rental_date) AS MONTH, YEAR(rental_date) AS YEAR FROM rental AS r GROUP BY EXTRACT(YEAR_MONTH FROM rental_date);

--La tienda con mayor cantidad de dinero por arriendo de pelC-culas
SELECT s.store_id, SUM(p.amount) AS total_venta FROM store AS s INNER JOIN staff as sf ON s.store_id=sf.store_id LEFT JOIN payment AS p ON sf.staff_id=p.staff_id GROUP BY s.store_id ORDER BY total_venta DESC LIMIT 1;

--Clientes que mC!s gastaron en arriendo de pelC-culas
SELECT p.customer_id, c.first_name, c.last_name, SUM(p.amount) AS TOTAL_SPENT FROM customer AS c LEFT JOIN payment AS p ON c.customer_id=p.customer_id GROUP BY p.customer_id ORDER BY TOTAL_SPENT DESC LIMIT 1;

--Categoria de pelC-culas que mC!s recaudan dinero
SELECT SUM(p.amount) AS TOTAL_EARNING, c.name AS category FROM payment AS p INNER JOIN rental AS r ON p.rental_id=r.rental_id INNER JOIN inventory AS i ON r.inventory_id=i.inventory_id INNER JOIN film AS f ON i.film_id=f.film_id INNER JOIN film_category as fc ON f.film_id=fc.film_id INNER JOIN category AS c ON fc.category_id=c.category_id GROUP BY c.name ORDER BY SUM(p.amount) DESC LIMIT 1;

--Promedio de ventas mensuales por tienda
SELECT s.store_id, MONTH(payment_date) AS MONTH, AVG(amount) AS AVG_AMOUNT FROM store AS s LEFT JOIN staff as sf ON s.store_id=sf.store_id LEFT JOIN payment AS p ON sf.staff_id=p.staff_id GROUP BY MONTH, store_id ORDER BY store_id, MONTH;

--Cantidad de stock de pelC-culas por categoria
SELECT c.name, COUNT(f.film_id) AS TOTAL FROM inventory AS i INNER JOIN film AS f ON i.film_id=f.film_id INNER JOIN film_category AS fc ON f.film_id=fc.film_id INNER JOIN category AS c ON fc.category_id=c.category_id GROUP BY fc.category_id;

--Generar una vista con las ventas generadas por los vendedores de las tiendas
CREATE VIEW sales_staff AS SELECT s.first_name, s.last_name, SUM(p.amount) AS total_sales FROM staff AS s INNER JOIN payment AS p ON s.staff_id=p.staff_id GROUP BY s.staff_id;