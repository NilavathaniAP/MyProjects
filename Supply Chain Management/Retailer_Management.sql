--DATE CLEANING for Retailer

SELECT * 
from SCM..Retailer


--Separating month & year 
SELECT Date, PARSENAME(replace(date,'-','.'),2) as Month
, PARSENAME(REPLACE(date,'-','.'),1) as Year
from SCM..Retailer

alter table SCM..Retailer
add Month varchar(50)

alter table SCM..Retailer
add Year numeric

update SCM..Retailer
set Month = PARSENAME(replace(date,'-','.'),2)
from SCM..Retailer

update SCM..Retailer
set Year = PARSENAME(replace(date,'-','.'),1)
from SCM..Retailer

alter table scm..retailer 
drop column Date  

--DATE CLEANING Failed set

SELECT * 
from SCM..Failed


--Separating month & year 
SELECT Date, PARSENAME(replace(date,'-','.'),2) as Month
, PARSENAME(REPLACE(date,'-','.'),1) as Year
from SCM..Failed

alter table SCM..Failed
add Month varchar(50)

alter table SCM..Failed
add Year numeric

update SCM..Failed
set Month = PARSENAME(replace(date,'-','.'),2)
from SCM..Failed

update SCM..Failed
set Year = PARSENAME(replace(date,'-','.'),1)
from SCM..Failed

alter table scm..failed
drop column Date

--DATE EXPLORATION

--Demand Vs Cost
select demand, Procurement_Cost, round(Procurement_Cost/Demand,2) as cost_per_unit
from SCM..Retailer
group by Demand, Procurement_Cost

--Creating index
create index idx_orderid_retailer
on SCM..Retailer(orderid)

create index idx_orderid_failed
on SCM..failed(orderid)


--REPLACEMENT ANALYSIS

select *
from scm..Failed

--failed tablets
select *, 0 as date_0 from SCM..Failed

alter table scm..failed
add Day_0 numeric

update scm..failed
set Day_0 = 0 
from scm..Failed

--success tablets

alter table SCM..Failed 
add day_s0 numeric
, day_s1 numeric
, day_s2 numeric
, day_s3 numeric
, day_s4 numeric
, day_s5 numeric
, day_s6 numeric;

update  SCM..Failed 
set day_s0 = demand-Day_0

update  SCM..Failed 
set day_s1 = demand-Day_1

update  SCM..Failed 
set day_s2 = Day_s1-Day_2

update  SCM..Failed 
set day_s3 = Day_s2-Day_3

update  SCM..Failed 
set day_s4 = day_s3-Day_4

update  SCM..Failed 
set day_s5 = day_s4-Day_5

update  SCM..Failed 
set day_s6 = day_s5-Day_6

--probability of failure for each day and storing it in a temp table for further calculations

drop table if exists #xt

create table #xt
(
Orderid numeric,
p_0 float, p_1 float, p_2 float, p_3 float,
p_4 float, p_5 float, p_6 float, x_0 float,
x_1 float, x_2 float, x_3 float, x_4 float,
x_5 float, x_6 float, sx_1 float, sx_2 float,
sx_3 float, sx_4 float, sx_5 float, sx_6 float);

with p_t as(
select OrderID,
0 as p_0 ,
cast((day_s0-day_s1)/day_s0 as float)  as p_1,
cast((day_s1-day_s2)/day_s0 as float)  as p_2,
cast((day_s2-day_s3)/day_s0 as float)  as p_3,
cast((day_s3-day_s4)/day_s0 as float)  as p_4,
cast((day_s4-day_s5)/day_s0 as float)  as p_5,
cast((day_s5-day_s6)/day_s0 as float)  as p_6
from scm..failed
), 

--finding xt 
finding_xt as
(
select
f.orderid,
cast(f.Demand as float) as x_0,
cast(f.Demand*pt.p_1 as float) as x_1
, cast(null as float) as x_2 --placeholder for recursive usage
, cast(null as float) as x_3
, cast(null as float) as x_4
, cast(null as float) as x_5
, cast(null as float) as x_6
, 1 as level
from scm..failed f
join p_t pt
on f.OrderID=pt.OrderID

 union all

select 
fx.OrderID
,fx.x_0
,fx.x_1
,cast((fx.x_0*pt.p_2) +(fx.x_1*pt.p_1)as float) as x_2
,cast((fx.x_0*pt.p_3) +(fx.x_1*pt.p_2)+(fx.x_2*pt.p_1) as float)as x_3
,cast((fx.x_0*pt.p_4) +(fx.x_1*pt.p_3)+(fx.x_2*pt.p_2)+(fx.x_3*pt.p_1) as float)as x_4
,cast((fx.x_0*pt.p_5) +(fx.x_1*pt.p_4)+(fx.x_2*pt.p_3)+(fx.x_3*pt.p_2)+(fx.x_4*pt.p_1) as float) as x_5
,cast((fx.x_0*pt.p_6) +(fx.x_1*pt.p_5)+(fx.x_2*pt.p_4)+(fx.x_3*pt.p_3)+(fx.x_4*pt.p_2) +(fx.x_5*pt.p_1) as float)as x_6
, fx.level+1 as level
from finding_xt fx
join p_t pt
on fx.OrderID=pt.OrderID
where fx.level <6 --control from infinite recurrsion
),

--summation of xt
yt as (
select OrderID,
0 as sx_1
,x_1 as sx_2
,x_1+x_2 as sx_3,
x_1+x_2+x_3 as sx_4
,x_1+x_2+x_3+x_4 as sx_5
,x_1+x_2+x_3+x_4 +x_5 as sx_6
from finding_xt xt )

insert into #xt(Orderid,p_0,p_1,p_2,p_3,p_4,p_5,p_6,x_0,x_1,x_2,x_3,x_4,x_5,x_6,sx_1,sx_2,sx_3,sx_4,sx_5,sx_6)
select 
fx.OrderID,
max(pt.p_0) as x_0
,max(pt.p_1) as x_1,
max(pt.p_2) as x_2 
,max(pt.p_3) as x_3 
,max(pt.p_4) as x_4
,max(pt.p_5) as x_5 
,max(pt.p_6) as x_6,
max(fx.x_0) as x_0
,max(fx.x_1) as x_1,
max(fx.x_2) as x_2 
,max(fx.x_3) as x_3 
,max(fx.x_4) as x_4
,max(fx.x_5) as x_5 
,max(fx.x_6) as x_6 --use max to filter out repeatition
,max(yt.sx_1) as sx_1,
max(yt.sx_2) as sx_2 
,max(yt.sx_3) as sx_3 
,max(yt.sx_4) as sx_4
,max(yt.sx_5) as sx_5 
,max(yt.sx_6) as sx_6 
from finding_xt fx
join p_t pt
on fx.OrderID=pt.OrderID
join yt
on fx.OrderID = yt.OrderID
group by fx.OrderID

select * from #xt

--finding the minimum cost
declare @ur float;
select @ur = value  from SCM..[Other_Details ] where Code = 'ur';
declare @gr float;
select @gr = Value  from SCM..[Other_Details ] where Code = 'gr';

--finding unit cost
with ur as(
select orderid, @ur*sx_1/1 as ur_1
, @ur*sx_2/2 as ur_2
, @ur*sx_3/3 as ur_3
, @ur*sx_4/4 as ur_4
, @ur*sx_5/5 as ur_5
, @ur*sx_6/6 as ur_6
from #xt),

--finding group cost
gr as(
select orderid, @gr*day_s0/1 as gr_1
, @gr*day_s0/2 as gr_2
, @gr*day_s0/3 as gr_3
, @gr*day_s0/4 as gr_4
, @gr*day_s0/5 as gr_5
, @gr*day_s0/6 as gr_6
from scm..Failed),

--finding total cost
t_c as (
select ur.Orderid
, ur.ur_1+gr.gr_1 as tc_1
, ur.ur_2+gr.gr_2 as tc_2
, ur.ur_3+gr.gr_3 as tc_3
, ur.ur_4+gr.gr_4 as tc_4
, ur.ur_5+gr.gr_5 as tc_5
, ur.ur_6+gr.gr_6 as tc_6
from ur join gr
on ur.orderid= gr.orderid)

select 
ur_1,ur_2,ur_3,ur_4,ur_5,ur_6,
gr_1,gr_2,gr_3,gr_4,gr_5,gr_6,
tc_1,tc_2,tc_3,tc_4,tc_5,tc_6,
least(tc_1,tc_2,tc_3,tc_4,tc_5,tc_6) as Minimum
from ur join gr
on ur.orderid= gr.orderid
join t_c
on ur.orderid= t_c.orderid

--SAFETY STOCK ANALYSIS

declare @service_level float 

--inverse function for 95% 
set @service_level = 1.64;

with find_ss as (
select distinct year
, avg(cast(demand as float)) as avg_demand
, avg(Procurement_Lead_Time) as avg_lead_time
, stdev(cast(demand as float)) as std_demand
, stdev(Procurement_Lead_Time) as std_lead_time
from scm..retailer
group by year
)
select avg_demand
, avg_demand
,std_lead_time
, std_demand
, round(sqrt(((std_demand*std_demand)+avg_lead_time) + ((avg_demand*avg_demand)+(std_lead_time*std_lead_time))),2) as combined_std
, round(sqrt(((std_demand*std_demand)+avg_lead_time) + ((avg_demand*avg_demand)+(std_lead_time*std_lead_time))),2)*@service_level as service_level
from find_ss
