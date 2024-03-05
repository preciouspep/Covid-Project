----General view of the data
Select *
From dbo.CovidDeaths
where continent is not null ----added this filter because continent names are in the location column where continent column is NULL.
order by 2,3,4;

Select *
From dbo.CovidVaccinations
order by 3,4


--Select the needed data

Select location, date, total_cases, new_cases,total_deaths, population
From dbo.CovidDeaths
where continent is not null
order by 1,2;


---TOTAL DEATHS VS TOTAL CASES.
---This query shows the likelihood of dying if you contract covid in your country (Nigeria)

Select location, date, total_cases,total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From dbo.CovidDeaths
where location = 'Nigeria' and continent is not null
order by 1,2; 


---TOTAL CASES VS POPULATION 
---This query shows the percentage of covid infected persons in your country(Nigeria)

Select location, date, population, total_cases, (total_cases/population)*100 as PercentagePopulationInfected
From dbo.CovidDeaths
where location = 'Nigeria' and continent is not null
order by 1,2;


---INFECTION_COUNT VS POPULATION PER COUNTRY
---This query shows the percentage of infected persons compared to the respective country.

Select location, population, MAX(total_cases) as TotalInfectionCount, MAX((total_cases/population))*100 as PercentagePopulationInfected
From dbo.CovidDeaths
where continent is not null
group by location, population
order by PercentagePopulationInfected desc


-----TOTAL NUMBER OF DEATHS PER COUNTRY.

Select location, MAX(cast(total_deaths as int)) as HighestdeathCount
From dbo.CovidDeaths
where continent is not null
group by location
order by HighestdeathCount desc


----TOTAL NUMBER OF DEATHS PER CONTINENT. 

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

----GLOBAL DAILY COVID CASES, DEATHS AND DAILY LIKELIHOOOD OF DYING IF INFECTED.

Select date, sum(new_cases) as Totalcovidcases, sum(cast(new_deaths as int)) as Totaldeaths, sum(cast(new_deaths as int))/sum(new_cases)*100 as DeathPercentage
From dbo.CovidDeaths
where continent is not null
group by date
order by 1

---TOTAL DEATHS IN THE WORLD AND THE DEATH PERCENTAGE

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


---TOTAL VACCINATIONS PER COUNTRY. 

Select dea.location, dea.population, max(convert(int, vac.total_vaccinations)) as total_vaccinations, 
		(max(convert(int, vac.total_vaccinations))/dea.population)*100 as PercentageVaccinated
From dbo.CovidDeaths as dea
Join dbo.CovidVaccinations as vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
Group By dea.location, dea.population
order by 1;

---- TOTAL GLOBAL VACCINATIONS.
---This query shows the total number of people that has being vaccinated in the world.


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


---INSERTING THE NECCESSARY QUERIES INTO VIEWS FOR VISUALISATION.


------(Table 1) Total covid cases, deaths and death percentage in the world.

Create view Global_numbers as
Select sum(new_cases) as Totalcovidcases, sum(cast(new_deaths as int)) as Totaldeaths, sum(cast(new_deaths as int))/sum(new_cases)*100 as DeathPercentage
From dbo.CovidDeaths
where continent is not null;

----(Table 2) Deaths PER Continent.

Create View Death_by_Continent as
WITH T1 as
(Select continent, location, MAX(CAST(total_deaths as int)) as HighestDeathCount 
From dbo.CovidDeaths
where continent is not null
group by continent, location)
Select continent, SUM(HighestDeathCount) as Totaldeaths 
From T1
group by continent
---order by Totaldeaths;

---(Table 3) Infection_count compared to countries population

Create view TotalInfected_by_Country as
Select location, population, MAX(total_cases) as TotalInfectionCount, MAX((total_cases/population))*100 as PercentagePopulationInfected
From dbo.CovidDeaths
where continent is not null
group by location, population
---order by PercentagePopulationInfected desc;


