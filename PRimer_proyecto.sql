--PAISES

--casos totales por pais
SELECT max(total_cases) as CasosTotales, location as País
FROM CovidData..CovidDeaths
WHERE continent is not null
group by location
order by CasosTotales desc

--muertes totales por país
SELECT MAX(total_deaths/10) as MuertesTotales, location AS País
FROM CovidData..CovidDeaths
WHERE continent is not null
group by location
order by muertesTotales desc

--maximo numero de nuevos casos en un día 
SELECT location as País, max(new_cases) as CasosNuevos 
FROM CovidData..CovidDeaths
WHERE continent is not null
group by location
order by CasosNuevos desc

--maximo numero de nuevas muertes en un día 
SELECT max(new_deaths) as MuertesNuevas, location as País
FROM CovidData..CovidDeaths
WHERE continent is not null
group by location
order by MuertesNuevas desc

--maximo numero de nuevas hospitalisaciones en una semana 
SELECT max(weekly_hosp_admissions) as PacientesHospital, location as País
FROM CovidData..CovidDeaths
WHERE continent is not null
group by location
order by PacientesHospital desc


--maximo numero de nuevos pacientes UCI en una semana 
SELECT max(weekly_icu_admissions) as PacientesUCI, location as País
FROM CovidData..CovidDeaths
WHERE continent is not null
group by location
order by PacientesUCI desc





--CONTINENTES

--casos totales por continente
SELECT max(total_cases) as CasosTotales, continent as Continente
FROM CovidData..CovidDeaths
WHERE continent is not null
group by continent
order by CasosTotales desc

--muertes totales por continente
SELECT MAX(total_deaths/10) as MuertesTotales, continent AS Continente
FROM CovidData..CovidDeaths
WHERE continent is not null
group by continent
order by muertesTotales desc

--maximo numero de nuevos casos en un día 
SELECT continent as Continente, max(new_cases) as CasosNuevos 
FROM CovidData..CovidDeaths
WHERE continent is not null
group by continent
order by CasosNuevos desc

--maximo numero de nuevas muertes en un día 
SELECT max(new_deaths) as MuertesNuevas, continent as continente
FROM CovidData..CovidDeaths
WHERE continent is not null
group by continent
order by MuertesNuevas desc



--CIFRAS GLOBALES

--linea de tiempo casos vs muertes
SELECT date, SUM(new_cases/10) as CasosTotales, SUM(new_deaths/10) as MuertesTotales, (SUM(new_deaths)/SUM(new_cases))*100 as PorcentajeFatalidad
FROM CovidData..CovidDeaths
WHERE continent is not null
group by date
order by 1,2

--cifras totalizadas casos vs muertes
SELECT  SUM(new_cases/10) as CasosTotales, SUM(new_deaths/10) as MuertesTotales, (SUM(new_deaths)/SUM(new_cases))*100 as PorcentajeFatalidad
FROM CovidData..CovidDeaths
WHERE continent is not null
--group by date
--order by 1,2



--tabla vacunas

USE CovidData
SELECT *
FROM CovidData..CovidDeaths dea
join coviddata..covidVaccinations vac
	on dea.location=vac.location
	and dea.date= vac.date


-- nuevos vacunados
with PopvsVac (continent, location, date, population, new_vaccinations, totalVacunados)
as
(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
,SUM(convert(float, vac.new_vaccinations)) OVER (Partition by dea.location order by dea.location, dea.date) as TotalVacunados
--, (totalVacunados/population)*100 as porcentajeVacunacion
FROM CovidData..CovidDeaths dea
join coviddata..covidVaccinations vac
	on dea.location=vac.location
	and dea.date= vac.date
WHERE dea.continent is not null
--order by 1, 2, 3
)
select *, (totalVacunados/population)*100 as porcentajeVacunacion
from PopvsVac



