drop database ecommerce_analytics_database;
drop database join_practice;
create database customer_behaviour;
drop table customer;
rename table cleaned_customer_shopping_behavior to customer;

-- Q1. what is the total revenue generate by male and female
select gender,sum(purchase_amount) as total_revenue
from customer
group by gender;
-- Q2. which customer used discount but purchased more than the avg purchase amount
select c.customer_id,c.purchase_amount from customer c where discount_applied = 'Yes' and  purchase_amount>=(select avg(purchase_amount) from customer);

--  Q3. which are the top 5 products with highest avg review rating

SELECT
    item_purchased,
    ROUND(AVG(review_rating),2) AS Average_Product_Rating
FROM customer
GROUP BY item_purchased
ORDER BY Average_Product_Rating desc
LIMIT 5;


-- Q4. found the avg purchase amount between standard and express shipping
select shipping_type,round(avg(purchase_amount),2) as Avg_Purchase_Amount
from customer 
where shipping_type in ('Standard','Express')
group by shipping_type;

-- Q5. do subscribe customers spend more? compare avg spend and total  revenue between subcribers and non-subcribers
select count(customer_id),subscription_status,avg(purchase_amount)as Avg_Spend,sum(purchase_amount) as Total_Revenue
from customer 
group by subscription_status
order by Total_Revenue,Avg_Spend
desc;

-- Q6. which top 5  product have the highest % of purchases with discount applied

SELECT 
    item_purchased,
    ROUND(
        SUM(CASE WHEN discount_applied = 'Yes' THEN 1 ELSE 0 END) * 100.0 
        / COUNT(*), 
    2) AS discount_percentage
FROM customer
GROUP BY item_purchased
ORDER BY discount_percentage DESC
LIMIT 5;

-- Q7. Segment customers into new,returning and loyal based on their total no of previous purchased  and show the count of each segment
with customer_type as(
select customer_id,previous_purchases,
case
     when previous_purchases = 1 then 'New'
     when previous_purchases between 2 and 10 then 'Returning'
     else 'Loyal'
     end as customer_segment
     from customer)
     
     select customer_segment,count(*) as No_of_customers
     from customer_type
     group by customer_segment;
     
     -- Q8. what is the top 3  purchased product within each category
     WITH product_counts AS (
    SELECT 
        category,
        item_purchased,
        COUNT(*) AS total_purchases,
        ROW_NUMBER()OVER(partition by category order by count(*) desc) as item_rank
    FROM customer
    GROUP BY category, item_purchased
)
select item_purchased,category,total_purchases,item_rank
from product_counts
where item_rank<=3;

-- Q9. are the customers reapeat buyers(more than 5 previous purchases) are likely to subscribe
select subscription_status,count(customer_id) as repeat_buyers
from customer 
where previous_purchases>=5
group by subscription_status;

-- Q10. what is revenue by each age group
select age_group,sum(purchase_amount) as total_revenue from customer 
group by age_group
order by total_revenue desc ;

     
	

