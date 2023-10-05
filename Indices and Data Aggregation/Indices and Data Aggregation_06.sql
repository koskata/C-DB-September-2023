-----------------01 Exercise 04/10/2023------------------
USE Gringotts

SELECT COUNT(*) AS [Count] FROM WizzardDeposits

-----------------02 Exercise 04/10/2023------------------

SELECT MAX(MagicWandSize) AS [LongestMagicWand] FROM WizzardDeposits

-----------------03 Exercise 04/10/2023------------------

SELECT DepositGroup, MAX(MagicWandSize) AS [LongestMagicWand] 
FROM WizzardDeposits
GROUP BY DepositGroup

-----------------04 Exercise 04/10/2023------------------

SELECT TOP(2) DepositGroup
FROM WizzardDeposits
GROUP BY DepositGroup
ORDER BY AVG(MagicWandSize)

-----------------05 Exercise 04/10/2023------------------

SELECT DepositGroup, SUM(DepositAmount) AS [TotalSum]
FROM WizzardDeposits
GROUP BY DepositGroup

-----------------06 Exercise 04/10/2023------------------

SELECT DepositGroup, SUM(DepositAmount) AS [TotalSum]
FROM WizzardDeposits
WHERE MagicWandCreator = 'Ollivander family'
GROUP BY DepositGroup

-----------------07 Exercise 04/10/2023------------------

SELECT DepositGroup, SUM(DepositAmount) AS [TotalSum]
FROM WizzardDeposits
WHERE MagicWandCreator = 'Ollivander family'
GROUP BY DepositGroup
HAVING SUM(DepositAmount) < 150000
ORDER BY TotalSum DESC

-----------------08 Exercise 04/10/2023------------------

SELECT DepositGroup, MagicWandCreator, MIN(DepositCharge) 
FROM WizzardDeposits
GROUP BY DepositGroup, MagicWandCreator
ORDER BY MagicWandCreator, DepositGroup

-----------------09 Exercise 04/10/2023------------------

SELECT AgeGroups, COUNT(*) FROM
(SELECT FirstName, Age, 
	CASE
		WHEN Age BETWEEN 0 AND 10 THEN '[0-10]'
		WHEN Age BETWEEN 11 AND 20 THEN '[11-20]'
		WHEN Age BETWEEN 21 AND 30 THEN '[21-30]'
		WHEN Age BETWEEN 31 AND 40 THEN '[31-40]'
		WHEN Age BETWEEN 41 AND 50 THEN '[41-50]'
		WHEN Age BETWEEN 51 AND 60 THEN '[51-60]'
		ELSE '[61+]'
	END AgeGroups
FROM WizzardDeposits) AS subq
GROUP BY AgeGroups

-----------------10 Exercise 04/10/2023------------------

SELECT SUBSTRING(FirstName, 1, 1)
FROM WizzardDeposits
WHERE DepositGroup = 'Troll Chest'
GROUP BY SUBSTRING(FirstName, 1, 1)
ORDER BY SUBSTRING(FirstName, 1, 1)

-----------------11 Exercise 04/10/2023------------------

SELECT DepositGroup, IsDepositExpired, AVG(DepositInterest) AS AverageInterest
FROM WizzardDeposits
WHERE DepositStartDate > '1985-01-01'
GROUP BY DepositGroup, IsDepositExpired
ORDER BY DepositGroup DESC, IsDepositExpired

SELECT * FROM WizzardDeposits

-----------------12 Exercise 04/10/2023------------------

-----------------13 Exercise 05/10/2023------------------

USE SoftUni

SELECT DepartmentID, SUM(Salary) AS TotalSalary
FROM Employees
GROUP BY DepartmentID
ORDER BY DepartmentID

-----------------14 Exercise 05/10/2023------------------

SELECT DepartmentID, MIN(Salary) 
FROM Employees
WHERE DepartmentID IN (2, 5, 7) 
	AND HireDate > '2000-01-01'
GROUP BY DepartmentID

-----------------15 Exercise 05/10/2023------------------

SELECT * INTO EmployeesNew
FROM Employees
WHERE Salary > 30000

DELETE
FROM EmployeesNew
WHERE ManagerID = 42

UPDATE EmployeesNew
SET Salary = Salary + 5000
WHERE DepartmentID = 1

SELECT DepartmentID, AVG(Salary)
FROM EmployeesNew
GROUP BY DepartmentID

-----------------16 Exercise 05/10/2023------------------

SELECT DepartmentID, MAX(Salary) AS MaxSalary
FROM Employees
GROUP BY DepartmentID
HAVING MAX(Salary) NOT BETWEEN 30000 AND 70000

-----------------17 Exercise 05/10/2023------------------

SELECT COUNT(EmployeeID) AS [Count]
FROM Employees
WHERE ManagerID IS NULL

-----------------18 Exercise 05/10/2023------------------

