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
p_0 float,
p_1 float,
p_2 float,
p_3 float,
p_4 float,
p_5 float,
p_6 float,
x_0 float,
x_1 float,
x_2 float,
x_3 float,
x_4 float,
x_5 float,
x_6 float);

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
)
insert into #xt(Orderid,p_0,p_1,p_2,p_3,p_4,p_5,p_6,x_0,x_1,x_2,x_3,x_4,x_5,x_6)
select 
fx.OrderID,
max(pt.p_0) as x_0
,max(pt.p_1) as x_1,
max(pt.p_2) as x_2 
,max(pt.p_3) as x_3 
,max(pt.p_4) as x_4
,max(pt.p_5) as x_5 
,max(pt.p_6) as x_6 ,
max(fx.x_0) as x_0
,max(fx.x_1) as x_1,
max(fx.x_2) as x_2 
,max(fx.x_3) as x_3 
,max(fx.x_4) as x_4
,max(fx.x_5) as x_5 
,max(fx.x_6) as x_6 --use max to filter out repeatition
from finding_xt fx
join p_t pt
on fx.OrderID=pt.OrderID
group by fx.OrderID

select * from #xt

--finding summation of xt for each day
select 0 as sx_1
,x_1 as sx_2
,x_1+x_2 as sx_3,
x_1+x_2+x_3 as sx_4
,x_1+x_2+x_3+x_4 as sx_5
,x_1+x_2+x_3+x_4 +x_5 as sx_6
from #xt

--finding unit cost
