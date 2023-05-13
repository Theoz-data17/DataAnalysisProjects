select *
from coviddeaths 
order by 3;

update coviddeaths 
set date = str_to_date(date, '%d/%m/%Y');

select *
from coviddeaths 
order by 3,4;

-- What was the death percentage for all countries at different points in time?

select 
	location, 
	continent, 
	date, 
	total_cases, 
	total_deaths, 
	population,
	(total_deaths/total_cases)*100 as death_percentage
from coviddeaths
where continent is not null;

-- What was the average global death percentage for the different years?

select 
	Year(date),
	Avg((total_deaths/total_cases)*100) as Avg_death_percentage
from coviddeaths
where continent is not null
group by Year(date);

-- What was the average continental death percentage for the different years?
select 
	Year(date),
	continent,
	Avg((total_deaths/total_cases)*100) as Avg_death_percentage
from coviddeaths
where continent <> ''
group by Year(date),continent;

-- countries infection rate at any given point in time
select
	continent,
	location,
	date,
	population,
	new_cases,
	(new_cases/population)*100 as case_percentage
from coviddeaths;

-- 5 countries which reached the highest case percentage 
select
	location,
	max((new_cases/population)*100 )as case_percentage
from coviddeaths
group by location
order by case_percentage desc 
limit 5;
 


-- what was the death rate in all locations at any point in time 
select 
	location,
	continent,
	date,
	total_deaths,
	total_cases,
	(total_deaths/total_cases)*100 as death_percentage
from coviddeaths;

-- Global numbers
-- percentage daily new_cases and new deaths per population

select 
	date,
	sum(population),
	sum(new_cases) as new_cases,
	sum(new_deaths) as new_deaths,
	sum((new_cases/population)*100) as new_cases_percentage,
	sum((new_deaths/population)*100) as new_deaths_percentage
from coviddeaths
where continent <> ''
group by date;

-- rolling total vaccinations in each location 
select 
	cd.continent,
	cv.location,
	cd.`date` ,
	cd.population,
	cv.new_vaccinations,
	sum(cv.new_vaccinations) 
		over (partition by location order by location,date) as total_vacc_rolling,
	sum((cv.new_vaccinations/cd.population)*100) 
		over (partition by location order by location,date) as percent_pop_vacc
from coviddeaths cd
join covidvaccinations cv
		using(location, date)
having cv.new_vaccinations is not null and continent <> '';




