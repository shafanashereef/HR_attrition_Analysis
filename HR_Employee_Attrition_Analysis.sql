create database project;
use project;
SET SQL_SAFE_UPDATES = 0;

-- SQL Objective:
-- To analyze employee attrition and identify key factors affecting employee turnover.

alter table hr_attrition rename column ï»¿Age to Age;

update hr_attrition
set Attrition = case
when Attrition = 'Yes' then 'Left'
when Attrition = 'No' then 'Stayed'
end;

alter table hr_attrition
add EducationLevel varchar(20);

update hr_attrition
set EducationLevel = case
when Education = 1 then 'Below College'
when Education = 2 then 'College'
when Education = 3 then 'Bachelor'
when Education = 4 then 'Master'
when Education = 5 then 'Doctor'
end;


-- Create Age Groups
alter table hr_attrition
add AgeGroup varchar(20);

update hr_attrition
set AgeGroup = case
when Age between 18 and 25 then 'Young'
when Age between 26 and 35 then 'Adult'
when Age between 36 and 45 then 'Mid Age'
when Age between 46 and 60 then 'Senior'
end;

-- Create Income Levels
alter table hr_attrition
add IncomeLevel varchar(20);

update hr_attrition
set IncomeLevel = case
when MonthlyIncome <= 4000 then 'Low'
when MonthlyIncome between 4001 and 8000 then 'Medium'
when MonthlyIncome between 8001 and 12000 then 'High'
when MonthlyIncome > 12000 then 'Very High'
end;

SET SQL_SAFE_UPDATES = 1;

-- Total Employees
select count(EmployeeNumber) as TotalEmployees from hr_attrition;

-- Attrition Rate %
select (select count(EmployeeNumber) from hr_attrition where Attrition = 'Left') * 100.0 /
(select count(EmployeeNumber) from hr_attrition) as AttritionRate;

-- Attrition by Department
select Department, count(EmployeeNumber) as AttritionCount 
from hr_attrition where Attrition='Left' group by Department;

-- Attrition by Job Role
select JobRole, count(EmployeeNumber) as AttritionCount 
from hr_attrition where Attrition='Left' group by JobRole order by AttritionCount desc;

-- Income vs Attrition
select Attrition, avg(MonthlyIncome) as AvgMonthlyIncome 
from hr_attrition group by Attrition;

-- Education & Attrition
select EducationLevel, Attrition, avg(MonthlyIncome) as AvgIncome 
from hr_attrition group by EducationLevel, Attrition;

-- Overtime & Attrition
select OverTime, count(EmployeeNumber) as AttritionCount 
from hr_attrition where Attrition='Left' group by OverTime;

-- Distance from Home & Attrition
select DistanceFromHome, COUNT(EmployeeNumber) as AttritionCount 
from hr_attrition where Attrition='Left' group by DistanceFromHome order by DistanceFromHome;

-- High-Risk Attrition Groups
select JobRole, AgeGroup, IncomeLevel, OverTime, COUNT(*) as LeftCount
from hr_attrition
where Attrition = 'Left'
group by JobRole, AgeGroup, IncomeLevel, OverTime
order by LeftCount desc;

-- Years at Company vs Attrition
select YearsAtCompany, Attrition, COUNT(*) as Count
from hr_attrition
group by YearsAtCompany, Attrition
order by YearsAtCompany;
