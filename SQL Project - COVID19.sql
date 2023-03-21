SELECT *
FROM [PortfolioProject].[dbo].[CovidDeaths]
WHERE continent IS NOT NULL
ORDER BY 3,4

SELECT *
FROM [PortfolioProject].[dbo].[CovidVaccinations]
WHERE continent IS NOT NULL
ORDER BY 3,4

--select the data that we are going to be using

SELECT Location, date, total_cases,new_cases,total_deaths,population
FROM [PortfolioProject].[dbo].[CovidDeaths]
WHERE continent IS NOT NULL
ORDER BY 1,2

--Looking at 'total cases vs total deaths'
--Shows the likelyhood of dieying if you contract covid in Morocco

SELECT Location, date, total_cases,new_cases,total_deaths, (total_deaths/total_cases)*100 as 'death_rate %'
FROM PortfolioProject..CovidDeaths
WHERE location = 'Morocco' AND continent IS NOT NULL
ORDER BY 1,2


--looking at the 'total cases vs the population'
-- shows what percentage of population got covid

SELECT location, date, population, total_cases, (total_cases/population)*100 as 'PopulationInfected %'
FROM PortfolioProject..CovidDeaths
WHERE location ='Morocco' AND continent IS NOT NULL
ORDER BY location, date

--looking at countries with highest infection rate compared to population :

SELECT Location, population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population))*100 as 'PopulationInfected %'
FROM PortfolioProject..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY location, population
ORDER BY 'PopulationInfected %' DESC

--Showing the countries with the highest death count per population :

SELECT Location, MAX(total_deaths) AS 'TotalDeathCount'
FROM PortfolioProject..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY location
ORDER BY 'TotalDeathCount' DESC

--let's break things down by continent
--Showing the continents with the highest death count
 
SELECT location, MAX(total_deaths) AS 'TotalDeathCount'
FROM PortfolioProject..CovidDeaths
WHERE continent IS NULL AND location IN ('Europe','Africa', 'North America', 'South America', 'Asia', 'Oceania')
GROUP BY location
ORDER BY TotalDeathCount DESC


-- GLOBAL NUMBERS :

SELECT date, SUM(new_cases) AS global_new_cases, SUM(new_deaths) AS global_new_deaths, (SUM(new_deaths)/SUM(new_cases))*100 AS 'GlobalDeath %'
FROM PortfolioProject..CovidDeaths
WHERE continent IS NOT NULL 
GROUP BY date
HAVING SUM(new_cases) <> 0
ORDER BY 1

--Overall, across the world :

SELECT SUM(new_cases) AS global_new_cases, SUM(new_deaths) AS global_new_deaths, (SUM(new_deaths)/SUM(new_cases))*100 AS 'GlobalDeath %'
FROM PortfolioProject..CovidDeaths
WHERE continent IS NOT NULL 




--Joining the Vaccination table

SELECT *
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date

--Looking at Total Population vs Vaccinations :

SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
,SUM(vac.new_vaccinations) OVER(PARTITION BY dea.location ORDER BY dea.location,
dea.date) as RollingPeopleVaccinated
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
ORDER BY 2,3


--USE CTE
--Looking at the Percentenge of vaccinated people in Morocco

WITH PopvsVac (continent, location, date, population, new_vaccinations, RollingPeopleVaccinated)
AS 
(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
,SUM(vac.new_vaccinations) OVER(PARTITION BY dea.location ORDER BY dea.location,
dea.date) as RollingPeopleVaccinated
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
)

SELECT *, (RollingPeopleVaccinated/population)*100 as 'PercentagePeopleVaccinated %'
FROM PopvsVac
WHERE location ='Morocco'




--Temp Table :

DROP TABLE IF EXISTS #PercentagePopulationVaccinated --in case any alteration is wanted

CREATE TABLE #PercentPopulationVaccinated
(
Continent varchar(50),
Location varchar(50),
date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)
INSERT INTO #PercentPopulationVaccinated 
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
,SUM(vac.new_vaccinations) OVER(PARTITION BY dea.location ORDER BY dea.location,
dea.date) as RollingPeopleVaccinated
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent IS NOT NULL

SELECT *
FROM #PercentPopulationVaccinated


-- Creating View to store data for later visualizations

CREATE VIEW PercentPopulationVaccinated AS
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
,SUM(vac.new_vaccinations) OVER(PARTITION BY dea.location ORDER BY dea.location,
dea.date) as RollingPeopleVaccinated
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent IS NOT NULL


SELECT *
FROM PercentPopulationVaccinated