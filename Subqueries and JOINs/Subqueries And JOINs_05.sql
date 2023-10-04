USE SoftUni

-----------------01 Exercise 30/09/2023---------------------------------

SELECT TOP(5) e.EmployeeID, e.JobTitle, e.AddressID, a.AddressText
FROM Employees AS e
JOIN Addresses AS a ON e.AddressID = a.AddressID
ORDER BY e.AddressID

-----------------02 Exercise 30/09/2023---------------------------------

SELECT TOP(50) FirstName, LastName, t.[Name] AS [Town], a.AddressText
FROM Employees AS e
JOIN Addresses AS a ON e.AddressID = a.AddressID
JOIN Towns AS t ON a.TownID = t.TownID
ORDER BY FirstName, LastName

-----------------03 Exercise 30/09/2023---------------------------------

SELECT EmployeeID, FirstName, LastName, d.[Name]
FROM Employees AS e
JOIN Departments AS d ON e.DepartmentID = d.DepartmentID
WHERE d.[Name] = 'Sales'
ORDER BY e.EmployeeID

-----------------04 Exercise 30/09/2023---------------------------------

SELECT TOP(5) EmployeeID, FirstName, Salary, d.[Name]
FROM Employees AS e
JOIN Departments AS d ON e.DepartmentID = d.DepartmentID
WHERE Salary > 15000
ORDER BY d.DepartmentID

-----------------05 Exercise 30/09/2023---------------------------------

SELECT TOP(3) e.EmployeeID, FirstName
FROM Employees AS e
WHERE e.EmployeeID NOT IN (SELECT EmployeeID FROM EmployeesProjects)
ORDER BY e.EmployeeID

-----------------06 Exercise 30/09/2023---------------------------------

SELECT FirstName, LastName, HireDate, d.[Name] AS [DeptName]
FROM Employees AS e
JOIN Departments AS d ON e.DepartmentID = d.DepartmentID
WHERE d.[Name] IN ('Sales', 'Finance')
ORDER BY HireDate

-----------------07 Exercise 30/09/2023---------------------------------

SELECT TOP(5) e.EmployeeID, FirstName, p.[Name] AS ProjectName
FROM Employees AS e
JOIN EmployeesProjects AS ep ON ep.EmployeeID = e.EmployeeID
JOIN Projects AS p ON p.ProjectID = ep.ProjectID
	WHERE p.StartDate > '2002-08-13'
		AND p.EndDate IS NULL
ORDER BY e.EmployeeID

-----------------08 Exercise 30/09/2023---------------------------------

SELECT e.EmployeeID, FirstName,
	CASE
		WHEN p.StartDate > '2004-12-31' THEN NULL
		ELSE p.[Name]
	END ProjectName
FROM Employees AS e
JOIN EmployeesProjects AS ep ON ep.EmployeeID = e.EmployeeID
JOIN Projects AS p ON p.ProjectID = ep.ProjectID
WHERE e.EmployeeID = 24

-----------------09 Exercise 30/09/2023---------------------------------

SELECT e.EmployeeID, e.FirstName, e.ManagerID, m.FirstName AS ManagerName
FROM Employees AS e
JOIN Employees AS m ON e.ManagerID = m.EmployeeID
WHERE e.ManagerID IN (3, 7)
ORDER BY e.EmployeeID

-----------------10 Exercise 30/09/2023---------------------------------

SELECT TOP(50) e.EmployeeID, CONCAT_WS(' ', e.FirstName, e.LastName) AS EmployeeName, CONCAT_WS(' ', m.FirstName, m.LastName) AS ManagerName, d.[Name] AS DepartmentName
FROM Employees AS e
JOIN Employees AS m ON e.ManagerID = m.EmployeeID
JOIN Departments AS d ON e.DepartmentID = d.DepartmentID
ORDER BY e.EmployeeID

-----------------11 Exercise 30/09/2023---------------------------------

SELECT TOP(1) AVG(e.Salary)
FROM Employees AS e
JOIN Departments AS d ON e.DepartmentID = d.DepartmentID
GROUP BY d.[Name]
ORDER BY AVG(e.Salary)

-----------------12 Exercise 30/09/2023---------------------------------

USE [Geography]

SELECT CountryCode, m.MountainRange, p.PeakName, p.Elevation
FROM MountainsCountries AS mc
JOIN Peaks AS p ON p.MountainId = mc.MountainId
JOIN Mountains AS m ON m.Id = p.MountainId
WHERE mc.CountryCode = 'BG' AND p.Elevation > 2835
ORDER BY p.Elevation DESC

-----------------13 Exercise 30/09/2023---------------------------------

SELECT mc.CountryCode, COUNT(*) AS MountainRanges
FROM MountainsCountries AS mc
WHERE mc.CountryCode IN ('BG', 'RU', 'US')
GROUP BY mc.CountryCode

-----------------14 Exercise 30/09/2023---------------------------------

SELECT TOP(5) c.CountryName, r.RiverName
FROM Countries AS c
LEFT JOIN CountriesRivers AS cr ON c.CountryCode = cr.CountryCode
LEFT JOIN Rivers AS r ON r.Id = cr.RiverId
WHERE c.ContinentCode = 'AF'
ORDER BY c.CountryName

-----------------15 Exercise 30/09/2023---------------------------------

-----------------16 Exercise 30/09/2023---------------------------------

SELECT COUNT(*)
FROM Countries AS c
LEFT JOIN MountainsCountries AS mc ON mc.CountryCode = c.CountryCode
WHERE mc.MountainId IS NULL

-----------------17 Exercise 30/09/2023---------------------------------

SELECT TOP 5 [c].[CountryName]
					  ,MAX([p].[Elevation]) AS [HighestPeakElevation]
					  ,MAX([r].[Length]) AS [LongestRiverLength]
				 FROM [Countries] AS [c]
				 LEFT JOIN [MountainsCountries] AS [mc] ON [c].[CountryCode] = [mc].[CountryCode]
				 LEFT JOIN [Mountains] AS [m] ON [mc].[MountainId] = [m].[Id]
				 LEFT JOIN [CountriesRivers] AS [rc] ON [c].[CountryCode] = [rc].[CountryCode]
				 LEFT JOIN [Rivers] AS [r] ON [rc].[RiverId] = [r].[Id]
				 LEFT JOIN [Peaks] AS [p] ON [m].[Id] = [p].[MountainId]
			 GROUP BY [c].[CountryName]
			 ORDER BY [HighestPeakElevation] DESC, [LongestRiverLength] DESC, [c].[CountryName]