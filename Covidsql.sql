--covid death percentage in Georgia by date

select location, 
       date, 
       total_cases, 
       total_deaths, 
       round((CONVERT(float, total_deaths) / nullif(CONVERT(float, total_cases),0))*100,2) as Deathpercentage
from coviddeaths
where location='georgia'
order by 1,2;


--covid infected percentage in Georgia by date

with cte_perc_georgia as(
	select location, 
               date, 
	       total_cases, 
	       population, 
               round((CONVERT(float, total_cases) / nullif(CONVERT(float, population),0))*100,2) as percentage
        from coviddeaths
)

select *
from cte_perc_georgia
where location = 'Georgia'
order by 1,2


--10 highest infected percentage per population by country

with cte_percentage as(
	select location, 
	       sum(new_cases) as total_cases, 
	       population, 
               max(round((CONVERT(float, total_cases) / nullif(CONVERT(float, population),0))*100,2)) as percentage
from coviddeaths
group by location, population
)

select top 10 *
from cte_percentage
order by percentage desc


--10 highest death percentage per population by country

WITH cte_Deathpercentage AS (
    SELECT location,
           MAX(CAST(total_deaths AS INT)) AS deaths,
           population,
           MAX(ROUND((CONVERT(FLOAT, total_deaths) / NULLIF(CONVERT(FLOAT, population), 0) * 100), 2)) AS Deathpercentage
    FROM coviddeaths
    WHERE continent IS NOT NULL
    GROUP BY location, population
)
	
SELECT TOP 10 *
FROM cte_Deathpercentage
ORDER BY Deathpercentage DESC

	
--deaths by continent

select location, 
       max(cast(total_deaths as int)) as total_deaths
from coviddeaths
where continent is null and
location not in ('High income', 'Upper middle income', 'Lower middle income','Low income', 'World')
group by location
order by Total_deaths desc


--6. global numbers by date

select date, 
       sum(new_cases) as total_cases, 
       sum(new_deaths) as total_deaths, 
       (round((CONVERT(float, sum(new_deaths)) / nullif(CONVERT(float, sum(new_cases)),0))*100,2)) as death_percentage
from coviddeaths
where continent is not null
group by date
order by date


--total deaths and cases

select sum(new_cases) as total_cases, 
       sum(new_deaths) as total_deaths, 
       (round((CONVERT(float, sum(new_deaths)) / nullif(CONVERT(float, sum(new_cases)),0))*100,2)) as death_percentage
from coviddeaths
where continent is not null


--8. vactination by country and date

select d.continent, 
       d.location, 
       d.date, 
       d.population, 
       v.new_vaccinations ,
       sum(convert(int, v.new_vaccinations)) over (partition by d.location order by d.location, d.date) as rollingvaccinated
from coviddeaths d join covidvactinations v
on d.location=v.location and
d.date=v.date
where d.continent is not null
order by 2,3

