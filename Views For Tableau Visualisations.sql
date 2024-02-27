---Inserting the neccessary queries into views for visualisations


------(Table 1) Global stats. total covid cases, deaths and death percentage in the world

Create view Global_numbers as
Select sum(new_cases) as Totalcovidcases, sum(cast(new_deaths as int)) as Totaldeaths, sum(cast(new_deaths as int))/sum(new_cases)*100 as DeathPercentage
From dbo.CovidDeaths
where continent is not null;

----(Table 2) Deaths by Continents.

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

---(Table 3) Infection count compared to countries population

Create view TotalInfected_by_Country as
Select location, population, MAX(total_cases) as TotalInfectionCount, MAX((total_cases/population))*100 as PercentagePopulationInfected
From dbo.CovidDeaths
where continent is not null
group by location, population
---order by PercentagePopulationInfected desc;

---(Table 4) Infection count compared to countries population and date

Create view TotalInfected_by_Country_by_dates as
Select location, population,date, MAX(total_cases) as TotalInfectionCount, MAX((total_cases/population))*100 as PercentagePopulationInfected
From dbo.CovidDeaths
where continent is not null
group by location, population,date
---order by PercentagePopulationInfected desc;


---(Other table) Deaths by Country

Create view Deaths_by_Country as
Select location, MAX(cast(total_deaths as int)) as HighestDeathCount---converted the total_deaths column from varchar to int
From dbo.CovidDeaths
where continent is not null
group by location
---order by HighestDeathCount desc;




----(4) --- Total vaccinations by country. 

Create View TotalVaccinated_by_Country as
Select dea.location, dea.population, sum(convert(int, vac.new_vaccinations)) as totalvaccinated, 
		(sum(convert(int, vac.new_vaccinations))/dea.population)*100 as PercentageVaccinated
From dbo.CovidDeaths as dea
Join dbo.CovidVaccinations as vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
Group By dea.location, dea.population
---order by percentageVaccinated asc;