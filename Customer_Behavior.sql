use custom_behavior;
      show databases;
      show tables;
      
      USE custom_behavior;
SELECT * FROM customers;

SELECT COUNT(*) FROM customers;

select * from customers limit 20;


# 1.what is the total revenue genarated by male vs female customers

select Gender,sum(purchase_amount) as revenue
from customers
group by gender;

ALTER TABLE customers
RENAME COLUMN `Season` TO season;
select * from customers;

# 2.which customer used a discount but still spent more than average purchase amount
select customer_id,purchase_amount
from customers
where discount_applied='yes' and purchase_amount >= (select avg(purchase_amount) from customers);

# Which are the Top 5 products with the highest average review rating
select item_purchased,round(avg(cast(review_rating as decimal(10,2))),2) as "Average Product Rating"
from customers
group by item_purchased
order by avg(review_rating) desc
limit 5;

#4.Compare the average purchase amounts between standard and Express shipping
select shipping_type,
avg(purchase_amount) 
from customers
where shipping_type in ('Standard','Express')
group by shipping_type;

#5.Do subscribed customers spend more? compare average spend and total revenue between subscribers and non-subscribers
SELECT 
    subscription_status,
    COUNT(customer_id) AS total_customers,
    ROUND(AVG(purchase_amount), 2) AS avg_spend,
    ROUND(SUM(purchase_amount), 2) AS total_revenue
FROM customers
GROUP BY subscription_status
ORDER BY total_revenue DESC, avg_spend DESC;

# 6. Which 5 products have the highest percentage of purchases with discount applied
 select item_purchased,
 round(sum(case when discount_applied='yes' then 1 else 0 end) /count(*) * 100.0,2) as discount_rate
 from customers
 group by item_purchased
 order by discount_rate desc
 limit 5;
 
 # 7.Segment customers into new,returning and loyal based on their total number of previous purchase and show the count of each segment
  with customer_type as(
  select customer_id,previous_purchases,
  case 
  when previous_purchases =1 then 'New'
  when previous_purchases between 2 and 10 then'Returning'
  else 'Loyal'
  end as customer_segment
   from customers
   )
   select customer_segment,count(*) as "Number of Customers"
   from customer_type 
   group by customer_segment;
   
   # 8.what are the top 3 most_purchased products within each category
   with item_count as(
   select category,
   item_purchased,
   count(customer_id) as total_orders,
   row_number() over (partition by category order by count(customer_id) desc) as item_rank
   from customers
   group by category,item_purchased
   )
   select item_rank,category,item_purchased,total_orders
   from item_count
   where item_rank <=3;
   
   # 9. Are customers who are repeate buyer(more than 5 previous purchases) also likely subscribe?
   select subscription_status,
   count(customer_id) as repeat_buyers
   from customers
   where previous_purchases > 5
   group by subscription_status;
   
   # 10.What is the revenue contribution of each age group?
   select age_group,
   sum(purchase_amount) as total_revenue
   from customers
   group by age_group
   order by total_revenue desc;
   
   select * from customers;
   UPDATE customers
SET age_group = 
    CASE 
        WHEN age < 25 THEN 'Young Adult'
        WHEN age BETWEEN 25 AND 39 THEN 'Middle Adult'
        WHEN age BETWEEN 40 AND 59 THEN 'Adult'
        ELSE 'Senior'
    END;
   
   ALTER TABLE customers
ADD COLUMN age_group VARCHAR(20);

