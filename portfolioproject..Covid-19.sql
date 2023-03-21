Select * 
From portifolioProject..CovidDeaths
order by 3,4


--Select * 
--From portifolioProject..CovidDeaths
--order by 3,4

--select data that we are going to be using 


Select Location, date, total_cases, new_cases, total_deaths, population
from portifolioproject..Coviddeaths
order by 1,2

-- Looking at total cases vs total deaths 
-- Shows Likehood of dying if you contract covid in your country 
Select Location, date, total_cases, new_cases, total_deaths, (total_cases/total_deaths)*100 as Deathpercentage
from portifolioproject..Coviddeaths
where location like '%States%'
order by 1,2
 

 -- Lokking at total cases vs Populatipon
 -- Shows what percentage of population got covid

 Select Location, date, population, Total_cases, (total_cases/Population)*100 as Percentage_of_population_got_covid
from portifolioproject..Coviddeaths
where location like '%States%'
order by 1,2


--Looking at countries with highest infection rate compared to population 

 Select Location, population, MAX(Total_cases) as Highest_Infection_Count, max((total_cases/Population))*100 as Highest_infection_rate
from portifolioproject..Coviddeaths
Group by Location, population
order by Highest_infection_rate desc

--Showing Countries with highest Death count per population

Select continent, MAX(Total_Deaths) as Highest_Death_Count
from Coviddeaths
where continent is not null
Group by continent
order by Highest_death_Count desc

--Showing the continents with the highest death count per population

Select continent, MAX(Total_Deaths) as Total_Death_Count, MAX((total_deaths/population))*100 as Highest_death_count
from Coviddeaths
where continent is not null
Group by continent
order by Highest_death_Count desc

--join two tables coviddeaths and covid_vaccination$

Select * 
From CovidDeaths d
join CovidVaccinations v
on d.location = v.location
and d.date = v.date

--Global Numbers

select sum(new_cases) as Total_cases, sum(convert(int, New_deaths)) as total_deaths
, sum(convert(int, new_deaths))/sum(new_cases)*100 as DeathPercentage
from CovidDeaths
where continent is not null
order by 1,2; 


--lokiking at total population vs Vaccinations

Select d.continent, d.location, d.date, d.population, V.new_vaccinations
, sum(cast(v.new_vaccinations as int)) as Rolling_people_vaccinated
From CovidDeaths d
join CovidVaccinations v
	on d.location = V.location
	and d.date = v.date
where d.continent is not null
group by  d.continent, d.location, d.date, d.population, V.new_vaccinations
order by d.location, d.date;


--lokiking at total population vs Vaccinations

select d.continent, d.location, d.date, d.population, v.new_vaccinations
,sum(cast(v.new_vaccinations as int)) as Rolling_people_vaccinated
--, (Rolling_People_Vaccinated/population)*100
from coviddeaths d
join covidvaccinations v
	on d.location = v.location
	and d.date = v.date
where d.continent is not null
group by  d.continent, d.location, d.date, d.population, V.new_vaccinations
order by 2,3



--USE CTE

with popvsvac (continent, location, date, population, new_vaccinations, Rolling_People_Vaccinated)
as
(
select d.continent, d.location, d.date, d.population, v.new_vaccinations
, sum(cast(v.new_vaccinations as int)) as Rolling_people_vaccinated
--, (Rolling_People_Vaccinated/population)*100
from coviddeaths d
join covidvaccinations v
	on d.location = v.location
	and d.date = v.date
where d.continent is not null
group by d.continent, d.location, d.date, d.population, v.new_vaccinations
--order by 2,3
)
select *, (Rolling_People_Vaccinated/population)*100
from popvsvac


--sum(convert(int, v.New_vaccinations)) over (partition by d.location order by d.location, d.date) as Rolling_People_Vaccinated

--TEM Table


Create table #percentpopulation_vaccinated
(
continent varchar(225),
location varchar(225),
date datetime,
population numeric,
New_vaccinations numeric,
Rolling_people_vaccinated numeric
)


insert into   #percentpopulation_vaccinated
select d.continent, d.location, d.date, d.population, v.new_vaccinations
, sum(cast(v.new_vaccinations as int)) as Rolling_people_vaccinated
from coviddeaths d
join covidvaccinations v
	on d.location = v.location
	and d.date = v.date
where d.continent is not null
group by d.continent, d.location, d.date, d.population, v.new_vaccinations
order by 2,3

select *, (Rolling_People_Vaccinated/population)*100
from  #percentpopulation_vaccinated


--Creating view to store data for later visualizations


Create view percentpopulation_vaccinated as
select d.continent, d.location, d.date, d.population, v.new_vaccinations
, sum(cast(v.new_vaccinations as int)) as Rolling_people_vaccinated
from coviddeaths d
join covidvaccinations v
	on d.location = v.location
	and d.date = v.date
where d.continent is not null
group by d.continent, d.location, d.date, d.population, v.new_vaccinations


select * from percentpopulation_vaccinated


