--1. Crea el esquema de la BBDD.

-- ACTORES
actor(actor_id, first_name, last_name, last_update)

-- PELÍCULAS
film(film_id, title, description, release_year, language_id, original_language_id, rental_duration, rental_rate, length, replacement_cost, rating, last_update, special_features, fulltext)

-- ACTORES EN PELÍCULAS
film_actor(actor_id, film_id, last_update)

-- CATEGORÍAS DE PELÍCULAS
category(category_id, name, last_update)
film_category(film_id, category_id, last_update)

-- INVENTARIO
inventory(inventory_id, film_id, store_id, last_update)

-- ALQUILERES Y PAGOS
rental(rental_id, rental_date, inventory_id, customer_id, return_date, staff_id, last_update)
payment(payment_id, customer_id, staff_id, rental_id, amount, payment_date)

-- CLIENTES
customer(customer_id, store_id, first_name, last_name, email, address_id, activebool, create_date, last_update, active)

-- PERSONAL Y TIENDAS
staff(staff_id, first_name, last_name, address_id, email, store_id, active, username, password, last_update, picture)
store(store_id, manager_staff_id, address_id, last_update)

-- DIRECCIONES Y LOCALIZACIONES
address(address_id, address, address2, district, city_id, postal_code, phone, last_update)
city(city_id, city, country_id, last_update)
country(country_id, country, last_update)

-- IDIOMAS
language(language_id, name, last_update)

/* TABLAS VIEW, existe la posibilidad de uso. En este caso hemos decidido no implementarlas, debido a que la entrega se limita a un documento sql con los scripts,
el editor iba a detectar diversos errores por tablas faltantes que deberiamos ejecutar en otro script. Aún así, dejamos reflejado las diferentes tablas VIEW y también
dejamos reflejadas en comentarios las diferentes queries que podrían aprovecharse de estas tablas.

-- Actor y Película
CREATE VIEW vista_actor_peliculas AS
SELECT a.actor_id, a.first_name, a.last_name, f.film_id, f.title
FROM actor a
JOIN film_actor fa ON a.actor_id = fa.actor_id
JOIN film f ON fa.film_id = f.film_id;

-- Película y categoría
CREATE VIEW vista_peliculas_categoria AS
SELECT f.film_id, f.title, c.name AS categoria
FROM film f
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category c ON fc.category_id = c.category_id;

-- Alquiler y Cliente
CREATE VIEW vista_alquileres_clientes AS
SELECT r.rental_id, r.rental_date, r.return_date, c.customer_id, c.first_name, c.last_name
FROM rental r
JOIN customer c ON r.customer_id = c.customer_id;

-- Alquiler y Películas
CREATE VIEW vista_alquileres_peliculas AS
SELECT f.film_id, f.title, r.rental_id, r.rental_date, r.return_date
FROM film f
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id;

*/ 
-- 2. Muestra los nombres de todas las películas con una clasificación por edades de ‘Rʼ.
SELECT title
FROM film
WHERE rating = 'R';

-- 3.  Encuentra los nombres de los actores que tengan un “actor_idˮ entre 30 y 40.
SELECT first_name, last_name
FROM actor
WHERE actor_id BETWEEN 30 AND 40;

-- 4. Obtén las películas cuyo idioma coincide con el idioma original.
SELECT title
FROM film
WHERE language_id = original_language_id;

-- 5. Ordena las películas por duración de forma ascendente.
SELECT title, length
FROM film
ORDER BY length ASC;

-- 6. Encuentra el nombre y apellido de los actores que tengan ‘Allenʼ en su apellido.
SELECT first_name, last_name
FROM actor
WHERE last_name ILIKE '%Allen%';

-- 7.  Encuentra la cantidad total de películas en cada clasificación de la tabla 
-- “filmˮ y muestra la clasificación junto con el recuento.
SELECT rating, COUNT(*) AS total_peliculas
FROM film
GROUP BY rating
ORDER BY rating;

-- 8.  Encuentra el título de todas las películas que son ‘PG-13ʼ o tienen una duración mayor a 3 horas en la tabla film.
SELECT title
FROM film
WHERE rating = 'PG-13'
   OR length > 180;

-- 9.  Encuentra la variabilidad de lo que costaría reemplazar las películas.
SELECT VAR_POP(replacement_cost) AS variabilidad
FROM film;

-- 10.  Encuentra la mayor y menor duración de una película de nuestra BBDD.
SELECT 
    MAX(length) AS duracion_maxima,
    MIN(length) AS duracion_minima
FROM film;

-- 11. Encuentra lo que costó el antepenúltimo alquiler ordenado por día.
SELECT amount, payment_date
FROM payment
ORDER BY payment_date DESC
OFFSET 2 LIMIT 1;

-- 12.  Encuentra el título de las películas en la tabla “filmˮ que no sean ni
-- ‘NC-17ʼ ni ‘Gʼ en cuanto a su clasificación.
SELECT title
FROM film
WHERE rating NOT IN ('NC-17', 'G');

-- 13. Encuentra el promedio de duración de las películas para cada clasificación
-- de la tabla film y muestra la clasificación junto con el promedio de duración.
SELECT rating, AVG(length) AS promedio_duracion
FROM film
GROUP BY rating
ORDER BY rating;

-- 14.  Encuentra el título de todas las películas que tengan una duración mayor a 180 minutos.
SELECT title
FROM film
WHERE length > 180;

-- 15.  ¿Cuánto dinero ha generado en total la empresa?
SELECT SUM(amount) AS ingresos_totales
FROM payment;

-- 16. Muestra los 10 clientes con mayor valor de id.
SELECT customer_id, first_name, last_name
FROM customer
ORDER BY customer_id DESC
LIMIT 10;

-- 17.  Encuentra el nombre y apellido de los actores que aparecen en la película con título ‘Egg Igbyʼ.
SELECT a.first_name, a.last_name
FROM actor a
JOIN film_actor fa ON a.actor_id = fa.actor_id
JOIN film f ON fa.film_id = f.film_id
WHERE f.title = 'Egg Igby';

-- 18. Selecciona todos los nombres de las películas únicos.
SELECT DISTINCT title
FROM film;

-- 19.  Encuentra el título de las películas que son comedias y tienen una duración mayor a 180 minutos en la tabla “filmˮ.
SELECT f.title
FROM film f
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category c ON fc.category_id = c.category_id
WHERE c.name = 'Comedy'
  AND f.length > 180;
/*
19. Encuentra el título de las películas que son comedias y tienen una duración mayor a 180 minutos en la tabla “filmˮ.
SELECT v.title
FROM vista_peliculas_categoria v
JOIN film f ON v.film_id = f.film_id
WHERE v.categoria = 'Comedy'
  AND f.length > 180
ORDER BY v.title;
 */


-- 20.  Encuentra las categorías de películas que tienen un promedio de duración superior a 110 minutos y muestra el nombre de la categoría 
-- junto con el promedio de duración.
SELECT c.name AS categoria, AVG(f.length) AS promedio_duracion
FROM film f
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category c ON fc.category_id = c.category_id
GROUP BY c.name
HAVING AVG(f.length) > 110
ORDER BY promedio_duracion DESC;
/*
20. Encuentra las categorías de películas que tienen un promedio de duración superior a 110 minutos y muestra el nombre de la categoría junto con el promedio de duración.
SELECT v.categoria, AVG(f.length) AS promedio_duracion
FROM vista_peliculas_categoria v
JOIN film f ON v.film_id = f.film_id
GROUP BY v.categoria
HAVING AVG(f.length) > 110
ORDER BY promedio_duracion DESC;
 */

-- 21. ¿Cuál es la media de duración del alquiler de las películas?
SELECT AVG(rental_duration) AS media_dias_alquiler
FROM film;

-- 22. Crea una columna con el nombre y apellidos de todos los actores y actrices.
SELECT CONCAT(first_name, ' ', last_name) AS nombre_completo
FROM actor;

-- 23. Números de alquiler por día, ordenados por cantidad de alquiler de forma descendente.
SELECT DATE(rental_date) AS fecha, COUNT(*) AS total_alquileres
FROM rental
GROUP BY DATE(rental_date)
ORDER BY total_alquileres desc;
/*
23. Encuentra lo que costó el antepenúltimo alquiler ordenado por día.
SELECT p.amount
FROM vista_alquileres_clientes r
JOIN payment p ON r.rental_id = p.rental_id
ORDER BY r.rental_date DESC
OFFSET 2 LIMIT 1;
 */

-- 24.  Encuentra las películas con una duración superior al promedio.
SELECT title, length
FROM film
WHERE length > (SELECT AVG(length) FROM film);

-- 25. Averigua el número de alquileres registrados por mes.
SELECT EXTRACT(MONTH FROM rental_date) AS mes, COUNT(*) AS total_alquileres
FROM rental
GROUP BY mes
ORDER BY mes;
/*
25. Número de alquileres por mes
SELECT EXTRACT(MONTH FROM rental_date) AS mes, COUNT(*) AS total_alquileres
FROM vista_alquileres_clientes
GROUP BY mes
ORDER BY mes;
 */

-- 26.  Encuentra el promedio, la desviación estándar y varianza del total pagado.
SELECT 
    AVG(amount) AS promedio,
    STDDEV_POP(amount) AS desviacion_estandar,
    VAR_POP(amount) AS varianza
FROM payment;

-- 27.  ¿Qué películas se alquilan por encima del precio medio?
SELECT title, rental_rate
FROM film
WHERE rental_rate > (SELECT AVG(rental_rate) FROM film);

-- 28. Muestra el id de los actores que hayan participado en más de 40 películas.
SELECT actor_id
FROM film_actor
GROUP BY actor_id
HAVING COUNT(film_id) > 40;

-- 29. Obtener todas las películas y, si están disponibles en el inventario, mostrar la cantidad disponible.
SELECT f.title, COUNT(i.inventory_id) AS cantidad_disponible
FROM film f
LEFT JOIN inventory i ON f.film_id = i.film_id
GROUP BY f.title
ORDER BY f.title;

-- 30. Obtener los actores y el número de películas en las que ha actuado.
SELECT a.first_name, a.last_name, COUNT(fa.film_id) AS num_peliculas
FROM actor a
JOIN film_actor fa ON a.actor_id = fa.actor_id
GROUP BY a.actor_id, a.first_name, a.last_name
ORDER BY num_peliculas DESC;
/*
30. Obtener los actores y el número de películas en las que ha actuado.
SELECT first_name, last_name, COUNT(film_id) AS num_peliculas
FROM vista_actor_peliculas
GROUP BY actor_id, first_name, last_name
ORDER BY num_peliculas DESC;
*/

-- 31. Obtener todas las películas y mostrar los actores que han actuado en ellas, incluso si algunas películas no tienen actores asociados.
SELECT f.title, a.first_name, a.last_name
FROM film f
LEFT JOIN film_actor fa ON f.film_id = fa.film_id
LEFT JOIN actor a ON fa.actor_id = a.actor_id
ORDER BY f.title;
/*
31. Obtener todas las películas y mostrar los actores que han actuado en ellas, incluso si algunas películas no tienen actores asociados.
SELECT f.title, a.first_name, a.last_name
FROM film f
LEFT JOIN vista_actor_peliculas a ON f.film_id = a.film_id
ORDER BY f.title;
*/

-- 32. Obtener todos los actores y mostrar las películas en las que han actuado, incluso si algunos actores no han actuado en ninguna película.
SELECT a.first_name, a.last_name, f.title
FROM actor a
LEFT JOIN film_actor fa ON a.actor_id = fa.actor_id
LEFT JOIN film f ON fa.film_id = f.film_id
ORDER BY a.last_name, a.first_name;
/*
32. Obtener todos los actores y mostrar las películas en las que han actuado, incluso si algunos actores no han actuado en ninguna película.
SELECT a.first_name, a.last_name, v.title
FROM actor a
LEFT JOIN vista_actor_peliculas v ON a.actor_id = v.actor_id
ORDER BY a.last_name, a.first_name;
*/

-- 33. Obtener todas las películas que tenemos y todos los registros de alquiler.
SELECT f.title, r.rental_id, r.rental_date
FROM film f
LEFT JOIN inventory i ON f.film_id = i.film_id
LEFT JOIN rental r ON i.inventory_id = r.inventory_id
ORDER BY f.title;

-- 34. Encuentra los 5 clientes que más dinero se hayan gastado con nosotros.
SELECT c.first_name, c.last_name, SUM(p.amount) AS total_gastado
FROM customer c
JOIN payment p ON c.customer_id = p.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY total_gastado DESC
LIMIT 5;
/*
34. Encuentra los 5 clientes que más dinero se hayan gastado con nosotros.
SELECT c.first_name, c.last_name, SUM(p.amount) AS total_gastado
FROM vista_alquileres_clientes c
JOIN payment p ON c.customer_id = p.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY total_gastado DESC
LIMIT 5;
*/

-- 35. Selecciona todos los actores cuyo primer nombre es 'Johnny'.
SELECT first_name, last_name
FROM actor
WHERE first_name = 'Johnny';

-- 36. Renombra la columna “first_nameˮ como Nombre y “last_nameˮ como Apellido.
SELECT first_name AS "Nombre", last_name AS "Apellido"
FROM actor;

-- 37. Encuentra el ID del actor más bajo y más alto en la tabla actor.
SELECT 
    MIN(actor_id) AS id_mas_bajo,
    MAX(actor_id) AS id_mas_alto
FROM actor;

-- 38. Cuenta cuántos actores hay en la tabla “actorˮ.
SELECT COUNT(*) AS total_actores
FROM actor;

-- 39. Selecciona todos los actores y ordénalos por apellido en orden ascendente.
SELECT first_name, last_name
FROM actor
ORDER BY last_name ASC;

-- 40. Selecciona las primeras 5 películas de la tabla “filmˮ.
SELECT *
FROM film
LIMIT 5;

-- 41. Agrupa los actores por su nombre y cuenta cuántos actores tienen el mismo nombre. ¿Cuál es el nombre más repetido?
SELECT first_name, COUNT(*) AS cantidad
FROM actor
GROUP BY first_name
ORDER BY cantidad DESC
LIMIT 1;

-- 42. Encuentra todos los alquileres y los nombres de los clientes que los realizaron.
SELECT r.rental_id, r.rental_date, c.first_name, c.last_name
FROM rental r
JOIN customer c ON r.customer_id = c.customer_id
ORDER BY r.rental_date;
/*
42. Encuentra todos los alquileres y los nombres de los clientes que los realizaron.
SELECT rental_id, rental_date, first_name, last_name
FROM vista_alquileres_clientes
ORDER BY rental_date;
*/

-- 43. Muestra todos los clientes y sus alquileres si existen, incluyendo aquellos que no tienen alquileres.
SELECT c.first_name, c.last_name, r.rental_id, r.rental_date
FROM customer c
LEFT JOIN rental r ON c.customer_id = r.customer_id
ORDER BY c.last_name, c.first_name;
/*
43. Muestra todos los clientes y sus alquileres si existen, incluyendo aquellos que no tienen alquileres.
SELECT DISTINCT c.first_name, c.last_name, r.rental_id, r.rental_date
FROM customer c
LEFT JOIN vista_alquileres_clientes r ON c.customer_id = r.customer_id
ORDER BY c.last_name, c.first_name;
*/

-- 44. Realiza un CROSS JOIN entre las tablas film y category. ¿Aporta valor esta consulta? ¿Por qué?
SELECT f.title, c.name AS categoria
FROM film f
CROSS JOIN category c;

-- Esta consulta mo aporta valor por sí sola,ya que el CROSS JOIN devuelve todas las películas con todas las categorías 
-- indistintamente de si tienen relación o no, con lo cual, poco podemos sacar de esta consulta más allá de nombres 


-- 45. Encuentra los actores que han participado en películas de la categoría 'Action'.
SELECT DISTINCT a.first_name, a.last_name
FROM actor a
JOIN film_actor fa ON a.actor_id = fa.actor_id
JOIN film f ON fa.film_id = f.film_id
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category c ON fc.category_id = c.category_id
WHERE c.name = 'Action';
/*
45. Encuentra los actores que han participado en películas de la categoría 'Action'.
SELECT DISTINCT v.first_name, v.last_name
FROM vista_actor_peliculas v
JOIN vista_peliculas_categoria c ON v.film_id = c.film_id
WHERE c.categoria = 'Action'
ORDER BY v.last_name, v.first_name;
*/

-- 46. Encuentra todos los actores que no han participado en películas.
SELECT a.first_name, a.last_name
FROM actor a
LEFT JOIN film_actor fa ON a.actor_id = fa.actor_id
WHERE fa.film_id IS NULL;
/*
46. Encuentra todos los actores que no han participado en películas.
SELECT a.first_name, a.last_name
FROM actor a
LEFT JOIN vista_actor_peliculas v ON a.actor_id = v.actor_id
WHERE v.film_id IS NULL;
*/

-- 47. Selecciona el nombre de los actores y la cantidad de películas en las que han participado.
SELECT a.first_name, a.last_name, COUNT(fa.film_id) AS cantidad_peliculas
FROM actor a
LEFT JOIN film_actor fa ON a.actor_id = fa.actor_id
GROUP BY a.actor_id, a.first_name, a.last_name
ORDER BY cantidad_peliculas DESC;

/*
47. Selecciona el nombre de los actores y la cantidad de películas en las que han participado.
SELECT first_name, last_name, COUNT(film_id) AS cantidad_peliculas
FROM vista_actor_peliculas
GROUP BY actor_id, first_name, last_name
ORDER BY cantidad_peliculas DESC;
*/

-- 48. Crea una vista llamada “actor_num_peliculasˮ que muestre los nombres de los actores y el número de películas en las que han participado.
CREATE VIEW actor_num_peliculas AS
SELECT a.first_name, a.last_name, COUNT(fa.film_id) AS cantidad_peliculas
FROM actor a
LEFT JOIN film_actor fa ON a.actor_id = fa.actor_id
GROUP BY a.actor_id, a.first_name, a.last_name;
/*
48. Crea una vista llamada “actor_num_peliculasˮ que muestre los nombres de los actores y el número de películas en las que han participado.
CREATE VIEW actor_num_peliculas AS
SELECT first_name, last_name, COUNT(film_id) AS cantidad_peliculas
FROM vista_actor_peliculas
GROUP BY actor_id, first_name, last_name;
*/

-- 49. Calcula el número total de alquileres realizados por cada cliente.
SELECT c.first_name, c.last_name, COUNT(r.rental_id) AS total_alquileres
FROM customer c
LEFT JOIN rental r ON c.customer_id = r.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY total_alquileres DESC;
/*
49. Calcula el número total de alquileres realizados por cada cliente.
SELECT first_name, last_name, COUNT(rental_id) AS total_alquileres
FROM vista_alquileres_clientes
GROUP BY customer_id, first_name, last_name
ORDER BY total_alquileres DESC;
*/

-- 50. Calcula la duración total de las películas en la categoría 'Action'.
SELECT SUM(f.length) AS duracion_total
FROM film f
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category c ON fc.category_id = c.category_id
WHERE c.name = 'Action';
/*
50. Calcula la duración total de las películas en la categoría 'Action'.
SELECT SUM(f.length) AS duracion_total
FROM vista_peliculas_categoria v
JOIN film f ON v.film_id = f.film_id
WHERE v.categoria = 'Action';
*/

-- 51. Crea una tabla temporal llamada “cliente_rentas_temporalˮ para almacenar el total de alquileres por cliente.
CREATE TEMP TABLE cliente_rentas_temporal AS
SELECT c.customer_id, c.first_name, c.last_name, COUNT(r.rental_id) AS total_alquileres
FROM customer c
LEFT JOIN rental r ON c.customer_id = r.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name;

-- 52. Crea una tabla temporal llamada “peliculas_alquiladas” que almacene las películas que han sido alquiladas al menos 10 veces.
CREATE TEMP TABLE peliculas_alquiladas AS
SELECT f.film_id, f.title, COUNT(r.rental_id) AS total_alquileres
FROM film f
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
GROUP BY f.film_id, f.title
HAVING COUNT(r.rental_id) >= 10;

-- 53. Encuentra el título de las películas que han sido alquiladas por el cliente con el nombre ‘Tammy Sandersʼ 
-- y que aún no se han devuelto. Ordena los resultados alfabéticamente por título de película.
SELECT f.title
FROM film f
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
JOIN customer c ON r.customer_id = c.customer_id
WHERE c.first_name = 'Tammy'
  AND c.last_name = 'Sanders'
  AND r.return_date IS NULL
ORDER BY f.title;

-- 54. Encuentra los nombres de los actores que han actuado en al menos una película que pertenece a la categoría ‘Sci-Fi’.
-- Ordena los resultados alfabéticamente por apellido.
SELECT DISTINCT a.first_name, a.last_name
FROM actor a
JOIN film_actor fa ON a.actor_id = fa.actor_id
JOIN film f ON fa.film_id = f.film_id
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category c ON fc.category_id = c.category_id
WHERE c.name = 'Sci-Fi'
ORDER BY a.last_name, a.first_name;
/*
54. Encuentra los nombres de los actores que han actuado en al menos una película que pertenece a la categoría ‘Sci-Fi’. Ordena los resultados alfabéticamente por apellido.
SELECT DISTINCT v.first_name, v.last_name
FROM vista_actor_peliculas v
JOIN vista_peliculas_categoria c ON v.film_id = c.film_id
WHERE c.categoria = 'Sci-Fi'
ORDER BY v.last_name, v.first_name;
*/


-- 55. Encuentra el nombre y apellido de los actores que han actuado en películas que se alquilaron después de que la 
-- película ‘Spartacus Cheaperʼ se alquilara por primera vez. Ordena los resultados alfabéticamente por apellido.
SELECT DISTINCT a.first_name, a.last_name
FROM actor a
JOIN film_actor fa ON a.actor_id = fa.actor_id
JOIN film f ON fa.film_id = f.film_id
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
WHERE r.rental_date > ( SELECT MIN(r2.rental_date)
    FROM film f2
    JOIN inventory i2 ON f2.film_id = i2.film_id
    JOIN rental r2 ON i2.inventory_id = r2.inventory_id
    WHERE f2.title = 'Spartacus Cheaper')
ORDER BY a.last_name, a.first_name;
/*
55. Encuentra el nombre y apellido de los actores que han actuado en películas que se alquilaron después de que la película ‘Spartacus Cheaperʼ se alquilara por primera vez. Ordena los resultados alfabéticamente por apellido.
SELECT DISTINCT v.first_name, v.last_name
FROM vista_actor_peliculas v
JOIN vista_alquileres_peliculas ap ON v.film_id = ap.film_id
WHERE ap.rental_date > (SELECT MIN(rental_date)
    FROM vista_alquileres_peliculas
    WHERE title = 'Spartacus Cheaper')
ORDER BY v.last_name, v.first_name;
*/

-- 56. Encuentra el nombre y apellido de los actores que no han actuado en ninguna película de la categoría ‘Music’.
SELECT a.first_name, a.last_name
FROM actor a
WHERE a.actor_id NOT IN ( SELECT fa.actor_id
    FROM film_actor fa
    JOIN film_category fc ON fa.film_id = fc.film_id
    JOIN category c ON fc.category_id = c.category_id
    WHERE c.name = 'Music')
ORDER BY a.last_name, a.first_name;
/*
56. Encuentra el nombre y apellido de los actores que no han actuado en ninguna película de la categoría ‘Music’.
SELECT first_name, last_name
FROM actor
WHERE actor_id NOT IN (SELECT actor_id
    FROM vista_actor_peliculas v
    JOIN vista_peliculas_categoria c ON v.film_id = c.film_id
    WHERE c.categoria = 'Music' )
ORDER BY last_name, first_name;
*/

-- 57. Encuentra el título de todas las películas que fueron alquiladas por más de 8 días.
SELECT DISTINCT f.title
FROM film f
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
WHERE r.return_date IS NOT NULL
  AND r.return_date - r.rental_date > INTERVAL '8 days'
ORDER BY f.title;

-- 58. Encuentra el título de todas las películas que son de la misma categoría que ‘Animation’.
SELECT f.title
FROM film f
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category c ON fc.category_id = c.category_id
WHERE c.name = 'Animation'
ORDER BY f.title;
/* 
58. Encuentra el título de todas las películas que son de la misma categoría que ‘Animation’.
SELECT title
FROM vista_peliculas_categoria
WHERE categoria = 'Animation'
ORDER BY title;
*/

-- 59. Encuentra los nombres de las películas que tienen la misma duración que la película con el título ‘Dancing Fever’. 
-- Ordena los resultados alfabéticamente por título de película.
SELECT title
FROM film
WHERE length = ( SELECT length
    FROM film
    WHERE title = 'Dancing Fever')
ORDER BY title;

-- 60. Encuentra los nombres de los clientes que han alquilado al menos 7 películas distintas.
-- Ordena los resultados alfabéticamente por apellido.
SELECT c.first_name, c.last_name, COUNT(DISTINCT i.film_id) AS peliculas_distintas
FROM customer c
JOIN rental r ON c.customer_id = r.customer_id
JOIN inventory i ON r.inventory_id = i.inventory_id
GROUP BY c.customer_id, c.first_name, c.last_name
HAVING COUNT(DISTINCT i.film_id) >= 7
ORDER BY c.last_name, c.first_name;
/*
60. Encuentra los nombres de los clientes que han alquilado al menos 7 películas distintas. Ordena los resultados alfabéticamente por apellido.
SELECT c.first_name, c.last_name, COUNT(DISTINCT i.film_id) AS peliculas_distintas
FROM vista_alquileres_clientes c
JOIN rental r ON c.rental_id = r.rental_id
JOIN inventory i ON r.inventory_id = i.inventory_id
GROUP BY c.customer_id, c.first_name, c.last_name
HAVING COUNT(DISTINCT i.film_id) >= 7
ORDER BY c.last_name, c.first_name;
*/

-- 61. Encuentra la cantidad total de películas alquiladas por categoría y muestra el nombre de la categoría junto con el recuento de alquileres.
SELECT c.name AS categoria, COUNT(r.rental_id) AS total_alquileres
FROM category c
JOIN film_category fc ON c.category_id = fc.category_id
JOIN film f ON fc.film_id = f.film_id
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
GROUP BY c.name
ORDER BY total_alquileres DESC;

-- 62. Encuentra el número de películas por categoría estrenadas en 2006.
SELECT c.name AS categoria, COUNT(f.film_id) AS total_peliculas
FROM category c
JOIN film_category fc ON c.category_id = fc.category_id
JOIN film f ON fc.film_id = f.film_id
WHERE f.release_year = 2006
GROUP BY c.name
ORDER BY total_peliculas DESC;

/*
62. Encuentra el número de películas por categoría estrenadas en 2006.
SELECT v.categoria, COUNT(f.film_id) AS total_peliculas
FROM vista_peliculas_categoria v
JOIN film f ON v.film_id = f.film_id
WHERE f.release_year = 2006
GROUP BY v.categoria
ORDER BY total_peliculas DESC;
*/

-- 63. Obtén todas las combinaciones posibles de trabajadores con las tiendas que tenemos.
SELECT s.first_name, s.last_name, st.store_id
FROM staff s
CROSS JOIN store st
ORDER BY s.last_name, s.first_name, st.store_id;

-- 64. Encuentra la cantidad total de películas alquiladas por cada cliente y muestra el ID del cliente, su nombre y apellido junto con la cantidad de películas alquiladas.
SELECT c.customer_id, c.first_name, c.last_name, COUNT(r.rental_id) AS total_alquileres
FROM customer c
JOIN rental r ON c.customer_id = r.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY total_alquileres DESC;
/*
64. Encuentra la cantidad total de películas alquiladas por cada cliente y muestra el ID del cliente, su nombre y apellido junto con la cantidad de películas alquiladas.
SELECT customer_id, first_name, last_name, COUNT(rental_id) AS total_alquileres
FROM vista_alquileres_clientes
GROUP BY customer_id, first_name, last_name
ORDER BY total_alquileres DESC;
*/
