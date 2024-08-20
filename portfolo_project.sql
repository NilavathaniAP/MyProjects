select *
from PortfolioProject..CovidDeaths
where continent != ' '
order by 3,4

--selcet *
--from portfolio..covidvaccinations


--total cases Vs total deaths
select top 100 location, date, total_cases, total_deaths, round(convert(float,total_deaths)/nullif(convert(float,total_cases),0)*100,2) as death_per
from PortfolioProject..CovidDeaths
where location = 'india'
ORDER BY 1,CONVERT(DATE, date, 103)

--total cases Vs population
select top 1000 location, date, total_cases, population, round(convert(float,total_cases)/nullif(convert(float,population),0)*100,2) as overall_pop_per
from PortfolioProject..CovidDeaths
where location = 'india'
ORDER BY 1,CONVERT(DATE, date, 103)

--highest infection compared to population
select top 1000 location, max(total_cases), population, max(round(convert(float,total_cases)/nullif(convert(float,population),0)*100,2)) as infection_percent
from PortfolioProject..CovidDeaths
--where location = 'india'
group by location, population
order by infection_percent desc

--highest death count per population
select top 1000 continent, max(cast(total_deaths as int)) as totaldeaths
from PortfolioProject..CovidDeaths
--where location = 'india'
where continent != ' '
group by continent
order by totaldeaths desc

--for location
select top 1000 location, max(cast(total_deaths as int)) as totaldeaths
from PortfolioProject..CovidDeaths
--where location = 'india'
where continent != ' '
group by location
order by totaldeaths desc


--global numbers death rate
select top 500  sum(cast(new_cases as int)) as casescount, sum(cast(total_deaths as float)) as deathcount, round(sum(cast(new_deaths as float))/nullif(sum(cast(new_cases as float)),0)*100,2) as deathrate
from PortfolioProject..CovidDeaths
where continent != ' '
--group by date
ORDER BY 1,2

--total population vs vaccination
select cd.continent, cd.location,cd.date, cd.population, cv.new_vaccinations
, sum(cast(new_vaccinations as float)) over (partition by cd.location order by cd.location, convert(date,cd.date,103)) as rolling_peoplevaccinated
from PortfolioProject..CovidDeaths cd
join PortfolioProject..CovidVaccinations cv
on cd.location = cv.location
and cd.date=cv.date
where cd.continent != ' '
order by 2,convert(date, cd.date, 103)

--using CTE(Common Table Expression)
with popvsvac (continent, location,date, population, new_vaccinations,roll_peoplevac)
as
(
select cd.continent, cd.location,cd.date, cd.population, cv.new_vaccinations
, sum(cast(new_vaccinations as float)) over (partition by cd.location order by cd.location, convert(date,cd.date,103)) as roll_peoplevac
from PortfolioProject..CovidDeaths cd
join PortfolioProject..CovidVaccinations cv
on cd.location = cv.location
and cd.date=cv.date
where cd.continent != ' '
--order by 2,convert(date, cd.date, 103)
)
select *, (roll_peoplevac/nullif(CAST(population as int),0))*100 as people_vaccinated
from popvsvac
where location = 'india'

--use temp table

drop table if exists #tempvacc
create table #tempvacc
(
continent nvarchar(255)
, location nvarchar(255)
,date nvarchar(255)
, population nvarchar(255)
, new_vaccinations nvarchar(255),roll_peoplevac numeric
)

insert into #tempvacc
select cd.continent, cd.location,cd.date, cd.population, cv.new_vaccinations
, sum(cast(new_vaccinations as float)) over (partition by cd.location order by cd.location, convert(date,cd.date,103)) as roll_peoplevac
from PortfolioProject..CovidDeaths cd
join PortfolioProject..CovidVaccinations cv
on cd.location = cv.location
and cd.date=cv.date
where cd.continent != ' '
--order by 2,convert(date, cd.date, 103)

select *, (roll_peoplevac/nullif(CAST(population as int),0))*100 as people_vaccinated
from #tempvacc

--creating view for visalization
use PortfolioProject;
go

create view people_vaccinated as
select cd.continent, cd.location,cd.date, cd.population, cv.new_vaccinations
, sum(cast(new_vaccinations as float)) over (partition by cd.location order by cd.location, convert(date,cd.date,103)) as roll_peoplevac
from PortfolioProject..CovidDeaths cd
join PortfolioProject..CovidVaccinations cv
on cd.location = cv.location
and cd.date=cv.date
where cd.continent != ' '

select * from people_vaccinated

drop view if exists people_vaccinated;

--to view the scheme name of the view
USE PortfolioProject;
GO

SELECT 
    schema_name(schema_id) AS schema_name,
    name AS view_name
FROM 
    sys.views
WHERE 
    name = 'people_vaccinated';
