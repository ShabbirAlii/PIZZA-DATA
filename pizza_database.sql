create database youtube;

-- 1 Retrieve the total number of orders placed.
SELECT 
    COUNT(order_id)
FROM
    youtube.orders;
    
-- 2 Calculate the total revenue generated from pizza sales.

SELECT 
    ROUND(SUM(youtube.order_details.quantity * youtube.pizzas.price),
            2) AS revenue
FROM
    youtube.order_details
        JOIN
    youtube.pizzas ON youtube.order_details.pizza_id = youtube.pizzas.pizza_id;

-- 3 Identify the highest-priced pizza.
SELECT 
    youtube.pizza_types.name, youtube.pizzas.price
FROM
    youtube.pizza_types
        JOIN
    youtube.pizzas ON youtube.pizza_types.pizza_type_id = youtube.pizzas.pizza_type_id
ORDER BY youtube.pizzas.price DESC
LIMIT 1;

-- 4 Identify the most common pizza size ordered.

select youtube.pizzas.size , count(youtube.order_details.order_id) as order_count
from youtube.pizzas join youtube.order_details
on youtube.order_details.pizza_id= youtube.pizzas.pizza_id
group by youtube.pizzas.size  order by order_count desc;

-- 5 List the top 5 most ordered pizza types along with their quantities.
select youtube.pizza_types.name, sum(youtube.order_details.quantity) as quantity
from youtube.pizza_types join youtube.pizzas 
on youtube.pizza_types.pizza_type_id= youtube.pizzas.pizza_type_id
join youtube.order_details 
on youtube.order_details.pizza_id= youtube.pizzas.pizza_id
group by youtube.pizza_types.name order by quantity desc limit 5 ;

-- 6 Join the necessary tables to find the total quantity of each pizza ordered.
select youtube.pizza_types.name , sum(youtube.order_details.quantity) as quantity
from youtube.pizza_types join youtube.pizzas
on youtube.pizza_types.pizza_type_id= youtube.pizzas.pizza_type_id
join youtube.order_details
on youtube.order_details.pizza_id= youtube.pizzas.pizza_id
group by youtube.pizza_types.name order by quantity desc limit 5;

-- 7 Join the necessary tables to find the total quantity of each pizza category ordered.
select youtube.pizza_types.category , sum(youtube.order_details.quantity) as quantity
from youtube.pizza_types join youtube.pizzas
on youtube.pizza_types.pizza_type_id= youtube.pizzas.pizza_type_id
join youtube.order_details
on youtube.order_details.pizza_id= youtube.pizzas.pizza_id
group by youtube.pizza_types.category order by quantity desc;

-- 8 Determine the distribution of orders by hour of the day.
select hour(youtube.orders.time) as hour , count(youtube.orders.order_id) as order_count
from youtube.orders
group by  hour(youtube.orders.time)  order by  hour(youtube.orders.time) asc;

-- 9  Join relevant tables to find the category-wise distribution of pizzas.

select youtube.pizza_types.category, count(youtube.pizza_types.name)as pizza_type
from youtube.pizza_types 
group by youtube.pizza_types.category ;

-- 10 Group the orders by date and calculate the average number of pizzas ordered per day.
select round(avg(quantity),0) from
(select youtube.orders.date , sum(youtube.order_details.quantity) as quantity
from youtube.order_details join youtube.orders
on youtube.order_details.order_id= youtube.orders.order_id
group by youtube.orders.date ) as order_quantity  ;

-- 11 Determine the top 3 most ordered pizza types based on revenue.

select youtube.pizza_types.name, sum(youtube.order_details.quantity * youtube.pizzas.price) as revenue
from youtube.pizza_types join youtube.pizzas on youtube.pizza_types.pizza_type_id= youtube.pizzas.pizza_type_id
join youtube.order_details on youtube.order_details.pizza_id= youtube.pizzas.pizza_id
group by  youtube.pizza_types.name
order by revenue desc limit 3;

-- 12 Calculate the percentage contribution of each pizza type to total revenue.

select youtube.pizza_types.category,
round(sum(youtube.order_details.quantity * youtube.pizzas.price ) /
(select round(sum(youtube.order_details.quantity * youtube.pizzas.price ),2) as total_sales 
from youtube.order_details join youtube.pizzas
on youtube.order_details.pizza_id= youtube.pizzas.pizza_id )*100,2) as revenue
from youtube.pizza_types join youtube.pizzas
on youtube.pizza_types.pizza_type_id= youtube.pizzas.pizza_type_id
group by youtube.pizza_types.category order by revenue desc;

