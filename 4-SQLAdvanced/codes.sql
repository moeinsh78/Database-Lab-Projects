------------ Part 1 --------------
select r.*, t.territory_id , t.territory_description 
from region r inner join territories t 
	on r.region_id = t.region_id;

------------ Part 2 --------------
select r.region_description , count(et.employee_id) as employee_count
from region r inner join territories t 
	on t.region_id = r.region_id, employee_territories et
where t.territory_id = et.territory_id
group by r.region_id;

------------ Part 3 --------------
select o.order_id, SUM((1 - od.discount) * od.unit_price * od.quantity)
from orders o left outer join order_details od 
	on o.order_id = od.order_id 
group by o.order_id;

------------ Part 4 --------------
select od.product_id, SUM(od.quantity) as total_order_count
from order_details od 
group by od.product_id 
order by total_order_count desc
limit 10;

------------ Part 5 --------------
select od.product_id
from products p left outer join order_details od on p.product_id = od.product_id 
where od.quantity is null or od.quantity = 0;

------------ Part 6 --------------
select od.product_id, p.product_name, count(distinct od.order_id) as orders_count
from products p left outer join order_details od on p.product_id = od.product_id 
group by od.product_id, p.product_name;

------------ Part 7 --------------
with order_total_cost as (
	select o.order_id, o.employee_id, SUM((1 - od.discount) * od.unit_price * od.quantity) as total_cost
	from orders o left outer join order_details od 
		on o.order_id = od.order_id
	where date_part('year', o.order_date) = 1998 
	group by o.order_id, o.employee_id
)
select e.first_name, e.last_name, SUM(otc.total_cost) as total_handled_orders_cost
from order_total_cost otc inner join employees e on e.employee_id = otc.employee_id 
group by otc.employee_id, e.first_name, e.last_name
order by total_handled_orders_cost desc
limit 1;

------------ Part 8 --------------
select o.order_date, o.shipped_date, o.order_id,
	case 
		when o.shipped_date::timestamp = o.order_date::timestamp then 'perfect'
		when date_part('day', o.shipped_date::timestamp - o.order_date::timestamp) < 3 then 'good'
		when date_part('day', o.shipped_date::timestamp - o.order_date::timestamp) >= 3 then 'bad'
		else 'error'
	end 
		as shipping_quality_tag
from orders o
where o.shipped_date is not null;

------------ Part 9 --------------
WITH RECURSIVE reporting AS (
	select e.employee_id as employee_id, 
		concat(e.first_name, e.last_name) as employee_name, 
		e.reports_to as manager_id
	from employees e
	union
		select e2.employee_id, 
			concat(e2.first_name, e2.last_name) as employee_name, 
			e2.reports_to as manager_id
		from employees e2 inner join reporting r on r.employee_id = e2.reports_to
)
select * from reporting;

------------ Part 10 --------------
select date_part('year', o.shipped_date) as shipped_year, sum(b.sub_total)
from orders o inner join (
	select distinct order_id,
		sum(od.unit_price * od.quantity) as sub_total
	from order_details od
	group by od.order_id 
	) b on o.order_id = b.order_id
where o.shipped_date is not null
group by shipped_year
order by shipped_year;

------------ Part 11 --------------
create view reorder_limit_reached as 
select p.product_name, p.units_in_stock, p.reorder_level
from products p 
where p.units_in_stock < p.reorder_level 
order by p.units_in_stock asc;

select * from reorder_limit_reached;

------------ Part 12 --------------
with france_orders as (
	select od.product_id, o.ship_country, o.order_id 
	from orders o inner join order_details od 
	on o.order_id = od.order_id
	where o.ship_country = 'France'
), product_cats as (
	select c.category_id, c.category_name, c.description, p.product_id, p.product_name 
	from products p right outer join categories c on p.category_id = c.category_id
)
select distinct pc.category_id, pc.category_name, pc.description
from france_orders fo right outer join product_cats pc on pc.product_id = fo.product_id
where fo.ship_country is null;

------------ Part 13 --------------
select c.customer_id, c.contact_name, c.phone 
from customers c 
where c.fax is null;

------------ Part 14 --------------
create view employees_age as (
	select 
		e.employee_id,
		e.first_name,
		e.last_name,
		date_part('year', age(current_date, e.birth_date)) as employee_age 
	from employees e
);

select r.region_id, avg(employees_age.employee_age) as age_average
from employees_age 
	inner join employee_territories et on et.employee_id = employees_age.employee_id
	inner join territories t on t.territory_id = et.territory_id 
	right outer join region r on r.region_id = t.region_id 
group by r.region_id;