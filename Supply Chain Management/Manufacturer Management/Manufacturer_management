--DATE CLEANING

SELECT * 
from SCM..Manufacturer


--Separating month & year 
SELECT Date, PARSENAME(replace(date,'-','.'),2) as Month
, PARSENAME(REPLACE(date,'-','.'),1) as Year
from SCM..Manufacturer

alter table scm..manufacturer
add Month varchar(50)

alter table scm..manufacturer
add Year numeric

update scm..manufacturer
set Month = PARSENAME(replace(date,'-','.'),2)
from SCM..Manufacturer

update scm..manufacturer
set Year = PARSENAME(replace(date,'-','.'),1)
from SCM..Manufacturer

alter table scm..manufacturer
drop column Date  

--Standardising the cost format
SELECT Procurement_Cost, ROUND(Procurement_Cost,2)
from SCM..Manufacturer

update SCM..Manufacturer
set Procurement_Cost = ROUND(Procurement_Cost,2)


--DATE EXPLORATION

--Checking fro distinct months if null or duplicates present
SELECT distinct(MONTH)
from SCM..Manufacturer
--group by year

select month, year, ROW_NUMBER()over(partition by month order by year)
from SCM..Manufacturer

--Checking for monthly patterns & its demands 
--Creating a VIEW for it
create view mothly_pattern as
select month, demand, sum(demand) over(partition by month order by year) as month_pattern
from SCM..Manufacturer

select month, max(demand)
from SCM..Manufacturer
group by month

--Demand Vs Cost
select demand, Procurement_Cost, round(Procurement_Cost/Demand,2) as cost_per_unit
from SCM..Manufacturer
group by Demand, Procurement_Cost

--Creating index
create index idx_orderid
on scm..manufacturer(orderid)


--BREAK-EVEN ANALYSIS

--Creating temp table and using Recursive CTE method

drop table if exists break_even_point

create table break_even_point(
Units numeric,Fixed_cost numeric, Variable_cost numeric, Selling_price numeric)

with br as
(
select 0 as Units
union all
select units+10
from br
where br.units<150
)

insert into break_even_point(Units)
select units from br

update break_even_point
set Variable_cost=  bp.units*od.value 
from
SCM..other_details od
right join break_even_point bp
on 1=1
where code in ('vc')

update break_even_point
set Selling_price= bp.units*od.value 
from
SCM..other_details od
right join break_even_point bp
on 1=1
where code in ('sp')

update break_even_point
set Fixed_cost= od.value 
from
SCM..other_details od
right join break_even_point bp
on 1=1
where code in ('fc')

select * from break_even_point

--creating view on Breakk-even for vizualization
use SCM;
go
create view BEP as
select *, Fixed_cost+Variable_cost as Total_cost
from break_even_point

select * from BEP

--finding the BEP using subqueries
select distinct
cast((select value from SCM..[Other_Details ] where code = 'fc')/
((select value from SCM..[Other_Details ] where code = 'sp')-
(select value from SCM..[Other_Details ] where code = 'vc'))as int) as Result
from SCM..[Other_Details ]


--CUMMULATIVE WORK HOURS

--Finding work hours for progress rate for 90%
declare @pr float;
declare @wh float;
declare @de float;

select @pr = log(0.9)/log(2) ;
select @wh = value from scm..[Other_Details ] where code='wh'
select @de =  demand from scm..manufacturer

select Month, Year, Demand, round((@wh/(1+@pr))*
   (power(Demand+0.5,1+@pr)-POWER(0.5,1+@pr)),2)
   as Work_Hours
   from SCM..manufacturer


--MANUFACTURER DECISION MODEL

--total cost, quantity, procurement level
declare @ic float;
declare @hc float;
declare @pro float;

select @ic = value from scm..[Other_Details ] where code='icm'
select @hc = value from scm..[Other_Details ] where code='hcm'
select @pro = value from scm..[Other_Details ] where code='pr'

select month,year,Demand,Procurement_Lead_Time,Procurement_Cost,
round((@ic*Demand)+SQRT(2*Procurement_Cost*@hc*Demand*(1-(Demand/@pro))),2) as total_cost
, cast(SQRT((2*Procurement_Cost*Demand)/(@hc*(1-(Demand/@pro)))) as int) as quantity
, cast(demand*procurement_lead_time as int) as procurement_level
from scm..manufacturer
