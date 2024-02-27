Select *
From dbo.CovidDeaths
where continent is not null ----added this filter because continent names are in the location column where continent column is NULL.
order by 2,3,4;

----Select *
----From dbo.CovidVaccinations
----order by 3,4


--Select the needed data

Select location, date, total_cases, new_cases,total_deaths, population
From dbo.CovidDeaths
where continent is not null
order by 1,2;


---Total deaths vs total cases.
---Shows the likelihood of dying if you have covid in your country (Nigeria)

Select location, date, total_cases,total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From dbo.CovidDeaths
where location = 'Nigeria' and continent is not null
order by 1,2; 


---Total cases vs population
---Shows the percentage of covid infected persons in your country(Nigeria)

Select location, date, population, total_cases, (total_cases/population)*100 as PercentagePopulationInfected
From dbo.CovidDeaths
where location = 'Nigeria' and continent is not null
order by 1,2;


---Infected_Population per Country
---Shows infected percentage count compared to population per country

Select location, population, MAX(total_cases) as TotalInfectionCount, MAX((total_cases/population))*100 as PercentagePopulationInfected
From dbo.CovidDeaths
where continent is not null
group by location, population
order by PercentagePopulationInfected desc


-----No. of Deaths Per Country

Select location, MAX(cast(total_deaths as int)) as HighestdeathCount
From dbo.CovidDeaths
where continent is not null
group by location
order by HighestdeathCount desc


----Total deaths per Continent. 

WITH T1 as
(Select continent, location, MAX(CAST(total_deaths as int)) as HighestDeathCount 
From dbo.CovidDeaths
where continent is not null
group by continent, location)
Select continent, SUM(HighestDeathCount) as Totaldeaths 
From T1
group by continent
order by Totaldeaths DESC;


---- GLOBAL NUMBERS

----Global Daily covid cases, deaths, and daily likelihood of dying if infected.

Select date, sum(new_cases) as Totalcovidcases, sum(cast(new_deaths as int)) as Totaldeaths, sum(cast(new_deaths as int))/sum(new_cases)*100 as DeathPercentage
From dbo.CovidDeaths
where continent is not null
group by date
order by 1

---Total deaths in the world and the death percentage

Select sum(new_cases) as Totalcovidcases, sum(cast(new_deaths as int)) as Totaldeaths, sum(cast(new_deaths as int))/sum(new_cases)*100 as DeathPercentage
From dbo.CovidDeaths
where continent is not null;


---Vaccinations

Select * 
from dbo.CovidVaccinations;

---Joining both tables

Select *
From dbo.CovidDeaths as dea
Join dbo.CovidVaccinations as vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
order by 3;


--- Total vaccinations per country. 

Select dea.location, dea.population, max(convert(int, vac.total_vaccinations)) as total_vaccinations, 
		(max(convert(int, vac.total_vaccinations))/dea.population)*100 as PercentageVaccinated
From dbo.CovidDeaths as dea
Join dbo.CovidVaccinations as vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
Group By dea.location, dea.population
order by 1;

--- Total vaccinations vs Population.


With T2 as
(Select dea.location, dea.population, max(convert(int, vac.total_vaccinations)) as maxtotalvac
From dbo.CovidDeaths as dea
Join dbo.CovidVaccinations as vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
Group By dea.location, dea.population)---first get the highest(max) totalvaccinations for each country
Select sum(maxtotalvac) as Global_vaccinations,sum(population) as Global_population, sum(maxtotalvac)/(sum(population))*100 as Percentage_Vaccinated
from T2




