--select * from PortfolioProject..CovidDeaths
--where continent is not null
--order by 3,4

--select * from PortfolioProject..CovidVaccinations
--order by 3,4

--select location,date,total_cases,new_cases,total_deaths,population 
--from CovidDeaths
--order by 1,2


-- Total Cases vs Total Deaths
-- shows likelihood of dying if you contract covid in India
--select location,date,total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathRate 
--from PortfolioProject..CovidDeaths
--where location like '%India%'
--order by 1,2

-- Total Population vs Total cases
-- shows likelihood of getting infected if you live in India
--select location,date,population, total_cases,(total_cases/population)*100 as InfectionRate 
--from PortfolioProject..CovidDeaths
--where location like '%india%'
--order by 1,2

--Looking for countries with highest Infection Rate campared to Population

--Select location,population,MAX(total_cases) as HeighestInfectionCount, MAX((total_cases/population)*100) as InfectionRate
--from PortfolioProject..CovidDeaths
--group by location,population
--order by InfectionRate desc

--Showing the countries with the heighest death count per population

--Select location,population, max(total_deaths) as TotaldeathCount
--from PortfolioProject..CovidDeaths
--where continent is not null
--group by location, population
--order by TotaldeathCount desc

-- Total cases for continents

--select location as Continent, max(total_cases) as totalCases
--from PortfolioProject..CovidDeaths
--where location in ('Asia','Africa','North America','South America','Europe','Australia','Oceania')
--group by location
--order by 2 desc


--select location, MAX(total_cases) as totalCases
--from PortfolioProject..CovidDeaths
--where continent is null
--group by location
--order by 2 desc


--Total deaths for each continent

--select location as Continent, MAX(total_deaths) as TotalDeaths 
--from CovidDeaths
--where location in ('Asia','Africa','North America','South America','Europe','Oceania')
--group by location

--Breaking Global numbers

--select sum(new_cases) as Total_cases, sum(new_deaths) as Total_deaths, sum(new_deaths)/nullif(SUM(new_cases),0)*100 as DeathPercentage
--from PortfolioProject..CovidDeaths
--where continent is not null
--order by 1,2

--select date, sum(total_cases) as Total_cases, sum(total_deaths) as Total_deaths, sum(total_deaths)/nullif(SUM(total_cases),0)*100 as DeathPercentage
--from PortfolioProject..CovidDeaths
--where continent is not null
--group by date
--order by 1,2


--Looking a total population vs vaccination

--select dea.continent,dea.location,dea.date,population,vac.new_vaccinations
--from PortfolioProject..CovidDeaths dea
--join PortfolioProject..CovidVaccinations vac
--	on dea.location=vac.location 
--	and dea.date=vac.date
--	where dea.continent is not null
--order by 2,3


--Rolling count
--select dea.continent,dea.location,dea.date,population,vac.new_vaccinations,
--sum(vac.new_vaccinations) over (partition by dea.location order by dea.date) as RollingVaccinated
--from PortfolioProject..CovidDeaths dea
--join PortfolioProject..CovidVaccinations vac
--	on dea.location=vac.location 
--	and dea.date=vac.date
--	where dea.continent is not null
--order by 2,3


--Use CTE
--with PopulationVsVaccination as
--(
--select dea.continent,dea.location,dea.date,population,vac.new_vaccinations,
--sum(vac.new_vaccinations) over (partition by dea.location order by dea.date) as RollingVaccinated
--from PortfolioProject..CovidDeaths dea
--join PortfolioProject..CovidVaccinations vac
--	on dea.location=vac.location 
--	and dea.date=vac.date
--	where dea.continent is not null
--)
--select * ,(RollingVaccinated/population)*100 popvsvacc
--from PopulationVsVaccination
--where location='india'


--Creating View to store data for later visualizations

--create view percentPopulationVaccinated as
--select dea.continent,dea.location,dea.date,population,vac.new_vaccinations,
--sum(vac.new_vaccinations) over (partition by dea.location order by dea.date) as RollingVaccinated
--from PortfolioProject..CovidDeaths dea
--join PortfolioProject..CovidVaccinations vac
--	on dea.location=vac.location 
--	and dea.date=vac.date
--	where dea.continent is not null


select * 
from percentPopulationVaccinated



