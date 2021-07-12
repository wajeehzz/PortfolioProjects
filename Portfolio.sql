##Claculating the liklihood of dying if got infected by COVID-19

SELECT location, date_of, total_cases, total_deaths, (total_deaths/total_cases) *100 AS percentage
FROM covid_deaths
##WHERE location = 'Iraq'
ORDER BY 1,2;

## Looking at the total cases VS population in Iraq
SELECT location, date_of,population, total_cases, (total_cases/population) * 100 AS percentage
FROM covid_deaths
WHERE location = 'Iraq'
ORDER BY 1,2;

## Countries with highest infection rate compared to population 
SELECT location, population, MAX(total_cases) AS HighestInfection, MAX((total_cases/population)) * 100 AS percentage
FROM covid_deaths
##WHERE location = 'Iraq'
GROUP BY location, population
ORDER BY percentage DESC;

## Showing the countries with highest deaths per population
SELECT location, MAX(CAST(total_deaths AS SIGNED int)) AS total_death_count
FROM covid_deaths
##WHERE location = 'Iraq' 
GROUP BY location
ORDER BY  total_death_count DESC;

## Breaking things down by continent
SELECT continent, MAX(CAST(total_deaths AS SIGNED int)) AS total_death_count
FROM covid_deaths
##WHERE location = 'Iraq' 
GROUP BY continent
ORDER BY  total_death_count DESC;

## Showing some Global Numbers 
SELECT  date_of, SUM(new_cases) AS total_cases, SUM(CAST(new_deaths AS SIGNED INT)) AS total_deaths, SUM(CAST(new_deaths AS SIGNED INT))/SUM(new_cases)*100 AS percntage
FROM covid_deaths
GROUP BY date_of
ORDER BY 1,2;

## Looking at total population VS vaccinations
SELECT cd.continent, cd.location, cd.date_of, cd.population, cv.new_vaccinations, SUM(CAST(cv.new_vaccinations AS SIGNED INT)) OVER (PARTITION BY cd.location ORDER BY cd.location, cd.date_of) AS number_of_vaccinated
FROM covid_deaths cd
JOIN covid_vacc cv
ON cd.location = cv.location AND cd.date_of = cv.date_of
ORDER BY 1,2,3;

## Here I want to see the percentage of vaccinated people over the population of a country, and I did it by 2 methods;

## Subquery
SELECT ta. *, (ta.number_of_vaccinated/ta.population) *100 AS percentage_population_vaccinated
FROM (SELECT cd.continent, cd.location , cd.date_of, cd.population AS population, cv.new_vaccinations, SUM(CAST(cv.new_vaccinations AS SIGNED INT)) OVER (PARTITION BY cd.location ORDER BY cd.location, cd.date_of) AS number_of_vaccinated
FROM covid_deaths cd
JOIN covid_vacc cv
ON cd.location = cv.location AND cd.date_of = cv.date_of
ORDER BY 1,2,3) AS ta;

## CTE 
WITH VacvsPop(continet, location, date_of, population, new_vaccinations, number_of_vaccinated)
AS(
SELECT cd.continent, cd.location, cd.date_of, cd.population, cv.new_vaccinations, SUM(CAST(cv.new_vaccinations AS SIGNED INT)) OVER (PARTITION BY cd.location ORDER BY cd.location, cd.date_of) AS number_of_vaccinated
FROM covid_deaths cd
JOIN covid_vacc cv
ON cd.location = cv.location AND cd.date_of = cv.date_of
)
SELECT* , (number_of_vaccinated/population) *100 AS percentge_population_vaccinated
FROM VacvsPop;

## Creating View for potential later use
CREATE VIEW Population_Vaccinated AS
SELECT cd.continent, cd.location, cd.date_of, cd.population, cv.new_vaccinations, SUM(CAST(cv.new_vaccinations AS SIGNED INT)) OVER (PARTITION BY cd.location ORDER BY cd.location, cd.date_of) AS number_of_vaccinated
FROM covid_deaths cd
JOIN covid_vacc cv
ON cd.location = cv.location AND cd.date_of = cv.date_of;



