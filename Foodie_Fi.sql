-- Schema Creation Foodie-Fi
	create schema foodie_fi;
    
-- Use Schema
	use foodie_fi;

-- Table Creation 
	# Plans
		Create table plans (plan_id INT, plan_name TEXT, price DECIMAL (5,2));
	# Subscriptions
		Create table subscriptions (customer_id INT, plan_id INT, start_date DATE);
        
-- Inserting Values
	# Plans
		INSERT INTO plans VALUES
		(0, "trial", 0),
		 (1, "basic monthly", 9.90),
		 (2, "pro monthly", 19.90),
		 (3, "pro annual", 199),
		 (4, "churn", null);
         
	# Subscriptions
		INSERT INTO subscriptions VALUES
		(1, 0, '2020-08-01'),
		(1, 1, '2020-08-08'),
		(2, 0, '2020-09-20'),
		(2, 3, '2020-09-27'),
		(11, 0, '2020-11-19'),
		(11, 4, '2020-11-26'),
		(13, 0, '2020-12-15'),
		(13, 1, '2020-12-22'),
		(13, 2, '2021-03-29'),
		(15, 0, '2020-03-17'),
		(15, 2, '2020-03-24'),
		(15, 4, '2020-04-29'),
		(16, 0, '2020-05-31'),
		(16, 1, '2020-06-07'),
		(16, 3, '2020-10-21'),
		(18, 0, '2020-07-06'),
		(18, 2, '2020-07-13'),
        (19, 0, '2020-06-22'),
		(19, 2, '2020-06-29'),
		(19, 3, '2020-08-29');


# A. Customer's Journey
		Select s.customer_id, p.plan_name, s.start_date from subscriptions as s inner join plans as p using (plan_id) order by s.customer_id;
        
		 # Customer ID 1's Journey
         
			Select s.customer_id, p.plan_name, s.start_date from subscriptions as s inner join plans as p using (plan_id) where customer_id = 1 order by s.customer_id;
			-- Customer 1's journey starts with the trial on 2020-08-01, and when the trial ends they upgrade to the basic monthly plan on 2020-08-08. 

		 # Customer ID 2’s Journey
         
			Select s.customer_id, p.plan_name, s.start_date from subscriptions as s inner join plans as p using (plan_id) where customer_id = 2 order by s.customer_id;
			-- Customer 2's journey starts with the trial on 2020-09-20, and when the trial ends they upgrade to the pro annual plan on 2020-09-27.

		 # Customer ID 11’s Journey
         
			Select s.customer_id, p.plan_name, s.start_date from subscriptions as s inner join plans as p using (plan_id) where customer_id = 11 order by s.customer_id;
			-- Customer 11's journey starts with the trial on 2020-11-19, and when the trial ends they churned the subscriptions on 2020-11-26.

		 # Customer ID 13’s Journey
         
			Select s.customer_id, p.plan_name, s.start_date from subscriptions as s inner join plans as p using (plan_id) where customer_id = 13 order by s.customer_id;
			-- Customer 13's journey starts with the trial on 2020-12-15, and when the trial ends they upgrade to the basic monthly plan on 2020-12-22. After 3 months, upgraded to pro monthly plan on 2021-03-29.

		 # Customer ID 15’s Journey
         
			Select s.customer_id, p.plan_name, s.start_date from subscriptions as s inner join plans as p using (plan_id) where customer_id = 15 order by s.customer_id;
			-- Customer 15's journey starts with the trial on 2020-03-17, and when the trial ends they upgrade to the pro monthly plan on 2020-03-24. After a month they churn the subscriptions on 2020-04-29.

		 # Customer ID 16 Journey
         
			Select s.customer_id, p.plan_name, s.start_date from subscriptions as s inner join plans as p using (plan_id) where customer_id = 16 order by s.customer_id;
			-- Customer 16's journey starts with the trial on 2020-05-31, and when the trial ends they upgrade to the basic monthly plan on 2020-06-07. After 4 months, they again upgraded to pro annual plan on 2021-10-21.

		 # Customer ID 18 Journey
         
			Select s.customer_id, p.plan_name, s.start_date from subscriptions as s inner join plans as p using (plan_id) where customer_id = 18 order by s.customer_id;
			-- Customer 18's journey starts with the trial on 2020-07-06, and when the trial ends they upgrade to the pro annual plan on 2020-10-21.

		 # Customer ID 19 Journey
         
			Select s.customer_id, p.plan_name, s.start_date from subscriptions as s inner join plans as p using (plan_id) where customer_id = 19 order by s.customer_id;
			-- Customer 19's journey starts with the trial on 2020-06-22, and when the trial ends they upgrade to the pro monthly plan on 2020-06-29. After 2 months, they again upgraded to the pro annual plan on 2020-08-29.


# B. Data Analysis Questions

# 1. How many customers has foodie fi ever had?
	 select count(distinct(customer_id)) as "Total no of Customers" from subscriptions;
     
# 2. What is the monthly distribution of trial plan start_date values for our dataset - use the start of the month as the group by value
     select month(start_date) as "Month", count(plan_id) as "No of Trial Plans" from subscriptions where plan_id = 0 group by month(start_date) order by Month;
     
# 3. What plan start_date values occur after the year 2020 for our dataset? Show the breakdown by count of events for each plan_name
     select plan_id as "Plan ID", plan_name as "Plan Name", count(*) as "Count of Events" from plans as p inner join subscriptions as s using(plan_id) where year(start_date) > "2020" group by p.plan_id;
     
# 4. What is the customer count and percentage of customers who have churned rounded to 1 decimal place?
     select count(customer_id) as "Customer Count" , round(count(customer_id)/(select count(distinct(customer_id)) from subscriptions)*100,1) as "% of Customers" from subscriptions where plan_id=4;
     
# 5. How many customers have churned straight after their initial free trial - what percentage is this rounded to the nearest whole number?
     create view subscriptions2 as (select *, lead(plan_id) over(partition by customer_id) as "Next_Plan_ID" from subscriptions);
     select count(customer_id) as "Customer Count", round(count(customer_id)/(select count(distinct(customer_id)) from subscriptions2)*100) as "% Churned" from subscriptions2 where plan_id = 0 and Next_Plan_ID =4;
     
# 6. What is the number and percentage of customer plans after their initial free trial?
	 select Next_Plan_ID, count(*) as "No of Customer Plans", round(count(*)/(select count(distinct(customer_id)) from subscriptions2) * 100,1) as "% of Customer Plans" from subscriptions2 where plan_id = 0 and (Next_Plan_ID = 1 or Next_Plan_ID = 2 or Next_Plan_ID = 3 or Next_Plan_ID = 4) group by Next_Plan_ID ;

# 7. What is the customer count and percentage breakdown of all 5 plan_name values at 2020-12-31?
	 create view subscriptions3 as (select *, lead(start_date) over(partition by customer_id) as "Next_Date" from subscriptions where start_date <= "2020-12-31");
     select plan_id as "Plan ID", count(distinct(customer_id)) as "Total Customers", round(count(distinct(customer_id))/(select count(distinct(customer_id)) from subscriptions3)*100,1) as "Percentage of Customers" from subscriptions3 where (start_date < "2020-12-31" and Next_Date > "2020-12-31" and Next_Date is not null) or (Next_Date is null and start_date < "2020-12-31") group by plan_id;

# 8. How many customers have upgraded to an annual plan in 2020?
	 select count(*) as "No of customers upgraded to Annual Plan" from subscriptions where plan_id = 3 and year(start_date) = "2020";
     
# 9. How many days on average does it take for a customer to an annual plan from the day they join Foodie-Fi?
	 create view free_plan_id as (select customer_id, plan_id, start_date from subscriptions where plan_id = 0 );
     create view annual_plan_id as (select customer_id, plan_id, start_date as "annual_date" from subscriptions where plan_id = 3);
     select round(avg(datediff(annual_date,start_date))) as "Average_Days" from free_plan_id as f inner join annual_plan_id using(customer_id) group by f.plan_id;
     
# 10. Can you further breakdown this average value into 30 day periods (i.e. 0-30 days, 31-60 days etc)
	  create view bins as (select customer_id, datediff(annual_date,start_date) as "Diff", round(datediff(annual_date,start_date)/30) as "bins" from free_plan_id as f join annual_plan_id using(customer_id));
      select concat((bins * 30) + 1, ' - ', (bins + 1) * 30, ' days ') as Days, count(Diff) AS Total FROM bins GROUP BY bins;
      
# 11. How many customers downgraded from a pro monthly to a basic monthly plan in 2020?
      select count(distinct(customer_id)) as "Downgraded Customers" from subscriptions2 left join plans as p using(plan_id) where plan_id = 2 and plan_id = 1 and year(start_date) = "2020";
      
      

# C. Challenge Payment Question

create view customer_id1 as (
(select customer_id, plan_id, plan_name, start_date as "payment_date", price as "amount" from plans join subscriptions using(plan_id) where plan_id not in (0,4) and customer_id =1) union all
(select customer_id, plan_id, plan_name, date_add(start_date, interval 1 month) as "payment_date", price as "amount" from plans join subscriptions using(plan_id) where plan_id not in (0,4) and customer_id = 1) union all
(select customer_id, plan_id, plan_name, date_add(start_date, interval 2 month) as "payment_date", price as "amount" from plans join subscriptions using(plan_id) where plan_id not in (0,4) and customer_id = 1) union all
(select customer_id, plan_id, plan_name, date_add(start_date, interval 3 month) as "payment_date", price as "amount" from plans join subscriptions using(plan_id) where plan_id not in (0,4) and customer_id = 1) union all
(select customer_id, plan_id, plan_name, date_add(start_date, interval 4 month) as "payment_date", price as "amount" from plans join subscriptions using(plan_id) where plan_id not in (0,4) and customer_id = 1));

create view customer_id2 as (
(select customer_id, plan_id, plan_name, start_date as "payment_date", price as "amount" from plans join subscriptions using(plan_id) where plan_id not in (0,4) and customer_id = 2));

create view customer_id13 as (
(select customer_id, plan_id, plan_name, start_date as "payment_date", price as "amount" from plans join subscriptions using (plan_id) where plan_id not in (0,4) and customer_id = 13 limit 1));

create view customer_id15 as (
(select customer_id, plan_id, plan_name, start_date as "payment_date", price as "amount" from plans join subscriptions using(plan_id) where plan_id not in (0,4) and customer_id = 15) union all
(select customer_id, plan_id, plan_name, date_add(start_date, interval 1 month) as "payment_date", price as "amount" from plans join subscriptions using(plan_id) where plan_id not in (0,4) and customer_id = 15));


create view customer_id16 as (
(select customer_id, plan_id, plan_name, start_date as "payment_date", price as "amount" from plans join subscriptions using(plan_id) where plan_id not in (0,4) and customer_id = 16 limit 1) union all
(select customer_id, plan_id, plan_name, date_add(start_date, interval 1 month) as "payment_date", price as "amount" from plans join subscriptions using(plan_id) where plan_id not in (0,4) and customer_id = 16 limit 1) union all
(select customer_id, plan_id, plan_name, date_add(start_date, interval 2 month) as "payment_date", price as "amount" from plans join subscriptions using(plan_id) where plan_id not in (0,4) and customer_id = 16 limit 1) union all
(select customer_id, plan_id, plan_name, date_add(start_date, interval 3 month) as "payment_date", price as "amount" from plans join subscriptions using(plan_id) where plan_id not in (0,4) and customer_id = 16 limit 1) union all
(select customer_id, plan_id, plan_name, date_add(start_date, interval 4 month) as "payment_date", price as "amount" from plans join subscriptions using(plan_id) where plan_id not in (0,4) and customer_id = 16 limit 1) union all
(select customer_id, plan_id, plan_name, date_add(start_date, interval 5 month) as "payment_date", price as "amount" from plans join subscriptions using(plan_id) where plan_id = 3 and customer_id = 16));


create view customer_id18 as (
(select customer_id, plan_id, plan_name, start_date as "payment_date", price as "amount" from plans join subscriptions using(plan_id) where plan_id = 2 and customer_id = 18) union all
(select customer_id, plan_id, plan_name, date_add(start_date, interval 1 month) as "payment_date", price as "amount" from plans join subscriptions using(plan_id) where plan_id = 2 and customer_id = 18) union all
(select customer_id, plan_id, plan_name, date_add(start_date, interval 2 month) as "payment_date", price as "amount" from plans join subscriptions using(plan_id) where plan_id = 2 and customer_id = 18) union all
(select customer_id, plan_id, plan_name, date_add(start_date, interval 3 month) as "payment_date", price as "amount" from plans join subscriptions using(plan_id) where plan_id = 2 and customer_id = 18) union all
(select customer_id, plan_id, plan_name, date_add(start_date, interval 4 month) as "payment_date", price as "amount" from plans join subscriptions using(plan_id) where plan_id = 2 and customer_id = 18) union all
(select customer_id, plan_id, plan_name, date_add(start_date, interval 5 month) as "payment_date", price as "amount" from plans join subscriptions using(plan_id) where plan_id = 2 and customer_id = 18));


create view customer_id19 as (
(select customer_id, plan_id, plan_name, start_date as "payment_date", price as "amount" from plans join subscriptions using(plan_id) where plan_id not in (0,4) and customer_id = 19 limit 1) union all
(select customer_id, plan_id, plan_name, date_add(start_date, interval 1 month) as "payment_date", price as "amount" from plans join subscriptions using(plan_id) where plan_id not in (0,4) and customer_id = 19));


create table payments as (
select *, rank() over(order by payment_date) as "payment_order" from customer_id1 union all
select *, rank() over(order by payment_date) as "payment_order" from customer_id2 union all
select *, rank() over(order by payment_date) as "payment_order" from customer_id13 union all
select *, rank() over(order by payment_date) as "payment_order" from customer_id15 union all
select *, rank() over(order by payment_date) as "payment_order" from customer_id16 union all
select *, rank() over(order by payment_date) as "payment_order" from customer_id18 union all
select *, rank() over(order by payment_date) as "payment_order" from customer_id19);

select * from payments;


# D. Outside the box Questions

-- Done in Wordpad File


        
     

        


