/* 
1. My partner and I want to come by each of the stores in person and meet the managers. 
Please send over the managers’ names at each store, with the full address 
of each property (street address, district, city, and country please).  
*/ 

select 
	concat(stf.first_name, " ", stf.last_name) as full_name,
    concat(ad.address, ", ", ad.district, ", ", ci.city, ", ", co.country) as full_address
from store as sto
left join staff as stf 
	on sto.manager_staff_id = stf.staff_id
left join address as ad
	on ad.address_id = stf.address_id
left join city as ci
	on ad.city_id = ci.city_id
left join country as co
	on ci.country_id = co.country_id;


	
/*
2.	I would like to get a better understanding of all of the inventory that would come along with the business. 
Please pull together a list of each inventory item you have stocked, including the store_id number, 
the inventory_id, the name of the film, the film’s rating, its rental rate and replacement cost. 
*/

select 
	store_id,
    inventory_id,
    fi.title as name_of_film,
    fi.rating as film_rating,
    fi.rental_rate as film_rental_rate,
    fi.replacement_cost as film_replacement_cost
from inventory
left join film as fi 
	on inventory.film_id = fi.film_id;
    


/* 
3.	From the same list of films you just pulled, please roll that data up and provide a summary level overview 
of your inventory. We would like to know how many inventory items you have with each rating at each store. 
*/


select 
	store_id,
	fi.rating as film_rating,
    count(fi.title) as count_of_film
from inventory
left join film as fi 
	on inventory.film_id = fi.film_id
group by 1, 2;



/* 
4. Similarly, we want to understand how diversified the inventory is in terms of replacement cost. We want to 
see how big of a hit it would be if a certain category of film became unpopular at a certain store.
We would like to see the number of films, as well as the average replacement cost, and total replacement cost, 
sliced by store and film category. 
*/ 


select 
	store_id,
    cat.name as film_category,
    count(fi.film_id) as no_of_films,
    avg(fi.replacement_cost) as avg_replacement_cost,
    sum(fi.replacement_cost) as total_replalcement_cost
from inventory
left join film_category as fc
	on fc.film_id = inventory.film_id
left join film as fi
	on fi.film_id = fc.film_id
left join category as cat
	on fc.category_id = cat.category_id
group by 1,2;
    



/*
5.	We want to make sure you folks have a good handle on who your customers are. Please provide a list 
of all customer names, which store they go to, whether or not they are currently active, 
and their full addresses – street address, city, and country. 
*/


select
	concat(cu.first_name, " ", cu.last_name) as full_name,
    store_id,
    concat(ad.address, ", ", ci.city, ", ", co.country) as full_address,
    (case when active = "1" then "YES" when active = "0" then "NO" else null end) as Active
from customer as cu
left join address as ad
	on ad.address_id = cu.address_id
left join city as ci 
	on ci.city_id = ad.city_id
left join country as co 
	on co.country_id = ci.country_id;


/*
6.	We would like to understand how much your customers are spending with you, and also to know 
who your most valuable customers are. Please pull together a list of customer names, their total 
lifetime rentals, and the sum of all payments you have collected from them. It would be great to 
see this ordered on total lifetime value, with the most valuable customers at the top of the list. 
*/


select 
	concat(cu.first_name, " ", cu.last_name) as Full_name,
    count(rt.rental_id) as Lifetime_rentals,
    sum(py.amount) as Total_payment
from customer as cu
left join rental as rt
	on rt.customer_id = cu.customer_id
left join payment as py
	on py.customer_id = rt.customer_id
group by 1
order by 2 desc;

    
    
    
/*
7. My partner and I would like to get to know your board of advisors and any current investors.
Could you please provide a list of advisor and investor names in one table? 
Could you please note whether they are an investor or an advisor, and for the investors, 
it would be good to include which company they work with. 
*/


select 
	concat(inv.first_name, " ", inv.last_name) as Full_name,
    "Investor" as Designation,
    company_name
from investor as inv
union
select 
	concat(adv.first_name, " ", adv.last_name) as Full_name,
    "Advisor" as Designation,
    null as company_name
from advisor as adv;




/*
8. We're interested in how well you have covered the most-awarded actors. 
Of all the actors with three types of awards, for what % of them do we carry a film?
And how about for actors with two types of awards? Same questions. 
Finally, how about actors with just one award? 
*/

select
	(case when actor_award.awards = 'Emmy, Oscar, Tony ' then "Three Awards"
	  when actor_award.awards in ('Emmy, Oscar', 'Emmy, Tony', 'Oscar, Tony') then "Two Awards"
      else "One Award" end) as No_of_Awards,
	avg(case when actor_award.actor_id is null then 0  else 1 end) as PCT_of_Films
from 
actor_award
group by
	(case when actor_award.awards = 'Emmy, Oscar, Tony ' then "Three Awards"
	  when actor_award.awards in ('Emmy, Oscar', 'Emmy, Tony', 'Oscar, Tony') then "Two Awards"
      else "One Award" end)




    
    
	