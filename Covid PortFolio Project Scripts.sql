Select * 
from CovidDeaths dea
join CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date


--Looking at Total Population vs Vaccination

Select distinct dea.continent,dea.location, dea.date, dea.population, vac.new_vaccinations 
from CovidDeaths dea
join CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
Order by 2,3 


-- Doing a rolling count on the Number of new Vaccinations using partition by

Select distinct dea.continent,dea.location, dea.date, dea.population, vac.new_vaccinations, 
sum(convert (bigint, vac.new_vaccinations )) over (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
--or sum(convert(int, vac.new_vaccinations) this is the same as cast
from CovidDeaths dea
join CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
Order by 2,3 


--looking at the Total population vs Vaccination using CTE


With PopVsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(

Select distinct dea.continent,dea.location, dea.date, dea.population, vac.new_vaccinations, 
sum(convert (bigint, vac.new_vaccinations )) over (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
--or sum(convert(int, vac.new_vaccinations) this is the same as cast
from CovidDeaths dea
join CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--Order by 2,3 
)
Select * , (RollingPeopleVaccinated/Population)*100
From PopVsVac



--Temp Table

Drop Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar (255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vacinations numeric,
RollingPeopleVaccinated numeric
)


Insert into #PercentPopulationVaccinated
Select distinct dea.continent,dea.location, dea.date, dea.population, vac.new_vaccinations, 
sum(convert (bigint, vac.new_vaccinations )) over (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
--or sum(convert(int, vac.new_vaccinations) this is the same as cast
from CovidDeaths dea
join CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--Order by 2,3 

Select * , (RollingPeopleVaccinated/Population)*100
From #PercentPopulationVaccinated




--Creating View to store data for later visualizations

Create View PercentPopulationVaccinated as

Select distinct dea.continent,dea.location, dea.date, dea.population, vac.new_vaccinations, 
sum(convert (bigint, vac.new_vaccinations )) over (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
--or sum(convert(int, vac.new_vaccinations) this is the same as cast
from CovidDeaths dea
join CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--Order by 2,3 

Select * 
From PercentPopulationVaccinated