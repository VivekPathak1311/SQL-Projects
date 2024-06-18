use pizza_kitchen;

-- Retrieve the total number of orders placed.

select
	count(distinct(order_id)) as Total_Orders
from orders;

-- Calculate the total revenue generated from pizza sales.

select 
	round(sum(p.price * od.quantity), 2) as Total_revenue
from order_details as od
left join pizzas as p
	on p.pizza_id = od.pizza_id;
    
-- Identify the highest-priced pizza.

select 
	pt.name as Highest_priced_pizza
from pizza_types as pt
left join pizzas as p
	on p.pizza_type_id = pt.pizza_type_id
order by p.price desc
limit 1;

-- Identify the most common pizza size ordered.

select
	p.size as Most_common_size_ordered
from order_details as od
left join pizzas as p
	on p.pizza_id = od.pizza_id
group by 1
order by count(od.order_id) desc 
limit 1;

-- List the top 5 most ordered pizza types along with their quantities.

select 
	pt.name as Top_5_most_ordered,
    sum(od.quantity) as Quantity
from order_details as od
left join pizzas as p
	on p.pizza_id = od.pizza_id
left join pizza_types as pt
	on p.pizza_type_id = pt.pizza_type_id
group by 1
order by count(od.order_id) desc
limit 5;


-- Join the necessary tables to find the total quantity of each pizza category ordered.

select
	pt.category as Pizza_category,
    sum(od.quantity) as Quantity_Ordered
from order_details as od
left join pizzas as p 
	on p.pizza_id = od.pizza_id
left join pizza_types as pt
	on pt.pizza_type_id = p.pizza_type_id
group by 1;

-- Determine the distribution of orders by hour of the day.

select
	distinct(hour(Time_of_order)) as Hour_of_the_day,
    count(Order_id) as Total_orders
from orders
group by 1
order by 1;

-- Join relevant tables to find the category-wise distribution of pizzas.

select
	category as Pizza_category,
    count(name) as no_of_pizzas
from pizza_types 
group by 1;


-- Group the orders by date and calculate the average number of pizzas ordered per day.

select 
	Date_of_order,
    sum(od.quantity) as Quantity_ordered
from orders
left join order_details as od
	on orders.Order_id = od.order_id
group by 1;
	
select
	round(sum(od.quantity) / count(distinct(o.Date_of_order)), 2) 
    as Average_orders_per_day
from orders as o
left join order_details as od
	on od.order_id = o.Order_id;


-- Determine the top 3 most ordered pizza types based on revenue.

select
	pt.name as Pizza_type,
	round(sum(p.price * od.quantity), 2) as Total_revenue
from order_details as od
left join pizzas as p
	on p.pizza_id = od.pizza_id
left join pizza_types as pt
	on pt.pizza_type_id = p.pizza_type_id
group by 1
order by 2 desc limit 3;

-- Calculate the percentage contribution of each pizza type to total revenue.

select
	pt.name as Pizza_type,
    round(sum(p.price * od.quantity),2) as Revenue,
    round((sum(p.price * od.quantity)/(select 
									sum(p.price * od.quantity) as Total_revenue
								from order_details as od
								left join pizzas as p
									on p.pizza_id = od.pizza_id))* 100, 2) as Pct_revenue_distribution
from pizza_types as pt
left join pizzas as p 
	on pt.pizza_type_id = p. pizza_type_id
left join order_details as od
	on od.pizza_id = p.pizza_id
group by 1;

-- Analyze the cumulative revenue generated over time.


select 
	Date_of_order,
    round(sum(revenue)over(order by Date_of_order) ,2) as Cummulative_revenue
from (select 
	o.Date_of_order,
    sum(od.quantity * p.price) as revenue
from orders as o
left join order_details as od
	on od.order_id = o.Order_id
left join pizzas as p
	on p.pizza_id = od.pizza_id
group by 1) as RBD;

-- Determine the top 3 most ordered pizza types based on revenue for each pizza category.


select 
	Rank_table.category as Category,
    Rank_table.name as Pizza_type,
    round(revenue, 2),
    pizza_rank
from (select 
	pt.category,
    pt.name,
    sum(od.quantity * p.price) as revenue ,
    rank()over(partition by pt.category order by sum(od.quantity * p.price) desc) as pizza_rank
from pizza_types as pt
left join pizzas as p
	on p.pizza_type_id = pt.pizza_type_id
left join order_details as od
	on od.pizza_id = p.pizza_id
group by 1,2) as Rank_table
where pizza_rank <=3
	

	

