
/*SQL Script – Fleet Management Analysis (Continuation)
This script extends the analysis previously conducted in Python.
It is designed to generate actionable KPIs and insights for monitoring vehicle costs, mileage, and overall fleet condition.
The objective is to support operational decision-making and prepare the dataset for a future Power BI dashboard.*/

/* =====================================================
   BUSINESS QUESTIONS TO ANSWER WITH SQL
   Fleet Management Analysis
   ===================================================== */

-- 1. What is the distribution of the fleet by vehicle type (cars, vans, trucks) in order to understand the structure of the fleet?

-- 2. Which vehicle types generate the highest total cost (fuel + maintenance) and therefore represent the main cost drivers?

-- 3. How is the fleet distributed by department in order to identify the geographic areas with the highest vehicle concentration?

-- 4. Which vehicle types show the highest average maintenance costs and require special attention?

-- 5. Which departments generate the highest total operational costs (fuel + maintenance)?

-- 6. What is the distribution of vehicles according to their status (Active, Maintenance, etc.) in order to assess fleet operational availability?

-- 7. What is the overall fleet availability rate, and to what extent is operational capacity impacted by unavailable vehicles?

-- 8. Which vehicles are the most expensive in terms of maintenance and should be monitored or potentially optimized or replaced?

-- 9. What are the overall fleet performance indicators (average mileage, average fuel cost, average maintenance cost)?

-- 10. How are costs globally distributed between fuel and maintenance in order to identify the main expense categories?

-- 11. Which vehicle types and departments concentrate the economic inefficiencies of the fleet?

-- 12. How do the different fleet segments contribute overall to operational costs and business performance?

CREATE DATABASE fleet;

USE fleet;

/*** Fleet size by vehicle type ***/
SELECT Type, COUNT(*) AS nb_vehicules
FROM fleet_management_clean 
GROUP BY Type
ORDER BY nb_vehicules DESC;
/* Vans are the majority (79), followed by Trucks (62) and Cars (59).
This distribution helps anticipate maintenance requirements and operational costs across each vehicle category. */

/*** Total cost by vehicle type ***/
SELECT Type,
       ROUND(SUM(Maintenance_Cost + Fuel_Cost),2) AS total_cost
FROM fleet_management_clean
GROUP BY Type
ORDER BY total_cost DESC;
/* This helps identify the categories generating the highest expenses and prioritize optimization actions.
Trucks show the highest total cost, followed by vans and then cars. */

/*** Fleet distribution by department ***/
SELECT Department, COUNT(*) AS nb_vehicules
FROM fleet_management_clean
GROUP BY Department
ORDER BY nb_vehicules DESC;
/* Lyon has the highest number of vehicles (41), followed by Madrid and Seville (34), while Barcelona has the lowest (25).
This helps identify high-activity areas for logistics tracking and budget monitoring. */

/*** Average maintenance cost by vehicle type ***/
SELECT Type, ROUND(AVG(Maintenance_Cost),2) AS avg_maintenance
FROM fleet_management_clean
GROUP BY Type
ORDER BY avg_maintenance DESC;
/* This helps identify the most expensive categories and guide renewal decisions.
Trucks show the highest average cost, representing the main lever for cost optimization. */

/*** Total cost by department (maintenance + fuel) ***/
SELECT Department,
       ROUND(SUM(Maintenance_Cost + Fuel_Cost),2) AS total_cost
FROM fleet_management_clean
GROUP BY Department
ORDER BY total_cost DESC;
/* Lyon generates the highest costs (~105.7k), followed by Paris (~90.3k), while Barcelona shows the lowest expenses (~63.8k).
This helps identify priority areas for budget optimization and cost control. */

/*** Vehicle status ***/
SELECT Status, COUNT(*) AS nb
FROM fleet_management_clean
GROUP BY Status;
/* This helps assess operational availability and identify unavailable vehicles requiring maintenance follow-up. */

/*** Fleet availability rate ***/
SELECT 
ROUND(
SUM(CASE WHEN Status='Active' THEN 1 ELSE 0 END)*100.0/COUNT(*),2
) AS availability_rate
FROM fleet_management_clean;
/* The KPI shows that approximately 80% of vehicles are active.
This helps assess operational performance and identify the need to monitor non-available vehicles. */

/*** Most expensive vehicles to maintain ***/
SELECT Vehicle_ID, Type, Department, Maintenance_Cost
FROM fleet_management_clean
ORDER BY Maintenance_Cost DESC
LIMIT 10;
/* Costs mainly concern trucks, with several occurrences in Marseille and Madrid.
This helps target the most expensive vehicles for closer monitoring or potential replacement. */

/*** Fleet global KPI ***/
SELECT 
    COUNT(*) AS total_vehicles,
    ROUND(AVG(Mileage),0) AS avg_mileage,
    ROUND(AVG(Fuel_Cost),2) AS avg_fuel_cost,
    ROUND(AVG(Maintenance_Cost),2) AS avg_maintenance_cost
FROM fleet_management_clean;
/* 200 vehicles in total, with an average mileage of approximately 62,046 km.
Average fuel cost is approximately €1,630 and average maintenance cost is approximately €974.
This provides a quick overview of fleet usage levels and average expenditures. */


/* SQL insights: this script provides precise fleet KPI
- Total and average cost by vehicle type and department
- Average mileage and vehicle status
- Most expensive vehicles in terms of maintenance
These analyses complement the Python exploration and prepare the dataset for a Power BI dashboard, enabling cost monitoring, prioritization, and optimization. */






