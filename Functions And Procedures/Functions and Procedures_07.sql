USE SoftUni
---------------01 Exercise 07/10/2023------------------------

CREATE PROC usp_GetEmployeesSalaryAbove35000
AS
SELECT FirstName, LastName
FROM Employees
WHERE Salary > 35000

EXEC usp_GetEmployeesSalaryAbove35000

---------------02 Exercise 07/10/2023------------------------

CREATE PROC usp_GetEmployeesSalaryAboveNumber(@Number DECIMAL(18, 4))
AS
SELECT FirstName, LastName
FROM Employees
WHERE Salary >= @Number

EXEC usp_GetEmployeesSalaryAboveNumber 25000

---------------03 Exercise 07/10/2023------------------------

CREATE OR ALTER PROC usp_GetTownsStartingWith (@String NVARCHAR(10))
AS
SELECT [Name]
FROM Towns
WHERE [Name] LIKE @String + '%'

EXEC usp_GetTownsStartingWith 'g'

---------------04 Exercise 07/10/2023------------------------

CREATE PROC usp_GetEmployeesFromTown (@TownName NVARCHAR(50))
AS
SELECT FirstName, LastName
FROM Employees AS e
JOIN Addresses AS a ON e.AddressID = a.AddressID
JOIN Towns AS t ON a.TownID = t.TownID
WHERE t.[Name] = @TownName 

EXEC usp_GetEmployeesFromTown 'Sofia'

---------------05 Exercise 07/10/2023------------------------

CREATE FUNCTION 
ufn_GetSalaryLevel (@salary DECIMAL(18,4))
RETURNS NVARCHAR(10)
AS 
BEGIN
	DECLARE @String NVARCHAR(10)
	IF(@salary < 30000)
		SET @String = 'Low'
	ELSE IF(@salary BETWEEN 30000 AND 50000)
		SET @String = 'Average'
	ELSE IF(@salary > 50000)
		SET @String = 'High'

	RETURN @String
END

SELECT dbo.ufn_GetSalaryLevel(35000)


---------------06 Exercise 07/10/2023------------------------

CREATE PROC usp_EmployeesBySalaryLevel (@LevelOfSalary NVARCHAR(20))
AS
SELECT FirstName, LastName
FROM Employees
WHERE dbo.ufn_GetSalaryLevel(Salary) = @LevelOfSalary

EXEC usp_EmployeesBySalaryLevel 'Low'

---------------07 Exercise 07/10/2023------------------------

CREATE FUNCTION ufn_IsWordComprised(@setOfLetters NVARCHAR(50), @word NVARCHAR(100))
RETURNS BIT
AS
BEGIN
	DECLARE @i INT = 1
	WHILE @i <= LEN(@word)
	BEGIN
		DECLARE @ch NVARCHAR(1) = SUBSTRING(@word, @i, 1)

		IF CHARINDEX(@ch, @setOfLetters) = 0
			RETURN 0
		ELSE
			SET @i += 1
	END
	RETURN 1
END

SELECT dbo.ufn_IsWordComprised('by', 'ayba')

---------------08 Exercise 07/10/2023------------------------

---------------09 Exercise 07/10/2023------------------------

USE [Bank]

CREATE PROC usp_GetHoldersFullName
AS
SELECT CONCAT_WS(' ', FirstName, LastName) AS [Full Name]
FROM AccountHolders

EXEC usp_GetHoldersFullName

---------------10 Exercise 07/10/2023------------------------

CREATE OR ALTER PROC usp_GetHoldersWithBalanceHigherThan (@Money DECIMAL(18, 4))
AS
SELECT FirstName, LastName
FROM AccountHolders AS ah
WHERE ah.Id IN (
	SELECT AccountHolderId
	FROM Accounts
	GROUP BY AccountHolderId
	HAVING SUM(Balance) > @Money
)
ORDER BY FirstName, LastName

EXEC usp_GetHoldersWithBalanceHigherThan 20000

---------------11 Exercise 07/10/2023------------------------

CREATE FUNCTION ufn_CalculateFutureValue (@Sum DECIMAL(18, 2), @Rate FLOAT, @Years INT)
RETURNS DECIMAL(20, 4)
AS
BEGIN
	RETURN @Sum * POWER((1 + @Rate), @Years)
END

SELECT dbo.ufn_CalculateFutureValue(1000, 0.1, 5)

---------------12 Exercise 07/10/2023------------------------

CREATE PROC usp_CalculateFutureValueForAccount (@AccountId INT, @InterestRate FLOAT)
AS

DECLARE @Years INT = 5

SELECT a.Id AS [Account Id], FirstName AS [First Name], LastName AS [Last Name], a.Balance,
		dbo.ufn_CalculateFutureValue(a.Balance, @InterestRate, @Years) AS [Balance in 5 years]
FROM AccountHolders AS ah
JOIN Accounts AS a ON ah.Id = a.AccountHolderId
WHERE a.Id = 1

EXEC usp_CalculateFutureValueForAccount 1, 0.1
