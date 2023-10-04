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