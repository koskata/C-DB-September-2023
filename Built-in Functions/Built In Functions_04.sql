USE SoftUni

----------01 Exercise 25/09/2023--------------

SELECT FirstName, LastName 
FROM Employees
WHERE SUBSTRING(FirstName, 1, 2) = 'Sa'

-----Other example of first exercise---------

SELECT FirstName, LastName 
FROM Employees
WHERE FirstName LIKE 'Sa%'


----------02 Exercise 26/09/2023--------------

SELECT FirstName, LastName
FROM Employees
WHERE LastName LIKE '%ei%'

----------03 Exercise 26/09/2023--------------

SELECT FirstName
FROM Employees
WHERE DepartmentID IN(3, 10) AND HireDate BETWEEN '1995-01-01' AND '2005-12-31'

----------04 Exercise 26/09/2023--------------

SELECT FirstName, LastName
FROM Employees
WHERE JobTitle NOT LIKE '%engineer%'

----------05 Exercise 26/09/2023--------------

SELECT [Name]
FROM Towns
WHERE LEN([Name]) = 5 OR LEN([Name]) = 6
ORDER BY [Name]

----------06 Exercise 26/09/2023--------------

SELECT [TownID], [Name]
FROM Towns
WHERE [Name] LIKE '[MKBE]%'
ORDER BY [Name]

----------07 Exercise 26/09/2023--------------

SELECT [TownID], [Name]
FROM Towns
WHERE [Name] NOT LIKE '[RBD]%'
ORDER BY [Name]

----------08 Exercise 26/09/2023--------------

CREATE VIEW V_EmployeesHiredAfter2000 
AS
SELECT FirstName, LastName
FROM Employees
WHERE HireDate > '2000-12-31'

----------09 Exercise 26/09/2023--------------

SELECT FirstName, LastName
FROM Employees
WHERE LEN(LastName) = 5

----------10/11 Exercise 26/09/2023--------------

SELECT * FROM
(SELECT EmployeeID, FirstName, LastName, Salary,
DENSE_RANK() OVER (PARTITION BY Salary ORDER BY EmployeeID) AS [Rank]
FROM Employees
WHERE Salary BETWEEN 10000 AND 50000) AS [Subquery]
WHERE Subquery.Rank = 2
ORDER BY Salary DESC

----------12 Exercise 27/09/2023--------------

USE [Geography]

SELECT CountryName, IsoCode FROM Countries
WHERE CountryName LIKE '%A%A%A%'
ORDER BY IsoCode

----------13 Exercise 27/09/2023--------------

SELECT [PeakName]
           ,[RiverName]
           ,LOWER(CONCAT([P].[PeakName], SUBSTRING(R.[RiverName], 2, LEN([R].[RiverName]) - 1)))
           AS [Mix]
     FROM [Peaks] AS [P]
          ,[Rivers] AS [R]
    WHERE RIGHT([PeakName], 1) = LEFT([RiverName], 1)
 ORDER BY [Mix]

----------14 Exercise 27/09/2023--------------

USE Diablo

SELECT TOP(50) [Name], FORMAT([Start], 'yyyy-MM-dd', 'bg-BG') AS [Start]
FROM Games
WHERE [Start] BETWEEN '2011-01-01' AND '2012-12-31'
ORDER BY [Start], [Name]

----------15 Exercise 27/09/2023--------------

SELECT Username, 
SUBSTRING(Email, (CHARINDEX('@', [Email], 1) + 1), LEN([Email]) - CHARINDEX('@', [Email], 1)) 
AS [Email Providers] 
FROM Users

----------16 Exercise 27/09/2023--------------

SELECT [Username]
	   ,[IpAddress]
FROM  [Users]
WHERE [IpAddress] LIKE '___.1_%._%.___'
ORDER BY [Username]

----------17 Exercise 27/09/2023--------------

SELECT [Name] AS [Game]
	      ,CASE
			   WHEN DATEPART(HOUR, [Start]) >= 0 AND DATEPART(HOUR, [Start]) < 12 THEN 'Morning'
			   WHEN DATEPART(HOUR, [Start]) >= 12 AND DATEPART(HOUR, [Start]) < 18 THEN 'Afternoon'
			   ELSE 'Evening'
	      END AS [Part of the Day]
	      ,CASE
			   WHEN [Duration] <= 3 THEN 'Extra Short'
			   WHEN [Duration] BETWEEN 4 AND 6 THEN 'Short'
			   WHEN [Duration] > 6 THEN 'Long'
			   ELSE 'Extra Long'
	      END AS [Duration]
     FROM [Games]
 ORDER BY [Game], [Duration], [Part of the Day]

----------18 Exercise 27/09/2023--------------

USE Orders

SELECT [ProductName]
	   ,[OrderDate]
	   ,DATEADD(DAY,3,OrderDate) AS [Pay Due]
	   ,DATEADD(MONTH,1,OrderDate) AS [Deliver Due]
     FROM [Orders]