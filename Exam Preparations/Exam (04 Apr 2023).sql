-----------------01 Exercise 07/10/2023-----------------------

USE Accounting

CREATE DATABASE Accounting

CREATE TABLE Countries(
	[Id] INT PRIMARY KEY IDENTITY,
	[Name] VARCHAR(10) NOT NULL
)

CREATE TABLE Addresses(
	[Id] INT PRIMARY KEY IDENTITY,
	[StreetName] NVARCHAR(20) NOT NULL,
	[StreetNumber] INT NOT NULL,
	[PostCode] INT NOT NULL,
	[City] VARCHAR(25) NOT NULL,
	[CountryId] INT FOREIGN KEY REFERENCES [Countries]([Id]) NOT NULL
)

CREATE TABLE Categories(
	[Id] INT PRIMARY KEY IDENTITY,
	[Name] VARCHAR(35) NOT NULL
)

CREATE TABLE Vendors(
	[Id] INT PRIMARY KEY IDENTITY,
	[Name] NVARCHAR(25) NOT NULL,
	[NumberVAT] NVARCHAR(15) NOT NULL,
	[AddressId] INT FOREIGN KEY REFERENCES [Addresses]([Id]) NOT NULL
)

CREATE TABLE Products(
	[Id] INT PRIMARY KEY IDENTITY,
	[Name] NVARCHAR(35) NOT NULL,
	[Price] DECIMAL(18, 2) NOT NULL,
	[CategoryId] INT FOREIGN KEY REFERENCES [Categories]([Id]) NOT NULL,
	[VendorId] INT FOREIGN KEY REFERENCES [Vendors]([Id]) NOT NULL
)


CREATE TABLE Clients(
	[Id] INT PRIMARY KEY IDENTITY,
	[Name] NVARCHAR(25) NOT NULL,
	[NumberVAT] NVARCHAR(15) NOT NULL,
	[AddressId] INT FOREIGN KEY REFERENCES [Addresses]([Id]) NOT NULL
)

CREATE TABLE Invoices(
	[Id] INT PRIMARY KEY IDENTITY,
	[Number] INT UNIQUE NOT NULL,
	[IssueDate] DATETIME2 NOT NULL,
	[DueDate] DATETIME2 NOT NULL,
	[Amount] DECIMAL(18, 2) NOT NULL,
	[Currency] VARCHAR(5) NOT NULL,
	[ClientId] INT FOREIGN KEY REFERENCES [Clients]([Id]) NOT NULL
)

CREATE TABLE ProductsClients(
	[ProductId] INT FOREIGN KEY REFERENCES [Products]([Id]) NOT NULL,
	[ClientId] INT FOREIGN KEY REFERENCES [Clients]([Id]) NOT NULL,
	PRIMARY KEY(ProductId, ClientId)
)


-----------------02 Exercise 08/10/2023-----------------------

INSERT INTO Products([Name], Price, CategoryId, VendorId)
	VALUES
	('SCANIA Oil Filter XD01', 78.69, 1, 1),
	('MAN Air Filter XD01', 97.38, 1, 5),
	('DAF Light Bulb 05FG87', 55.00, 2, 13),
	('ADR Shoes 47-47.5', 49.85, 3, 5),
	('Anti-slip pads S', 5.87, 5, 7)
	
INSERT INTO Invoices(Number, IssueDate, DueDate, Amount, Currency, ClientId)
	VALUES
	(1219992181, '2023-03-01', '2023-04-30', 180.96, 'BGN', 3),
	(1729252340, '2022-11-06', '2023-01-04', 158.18, 'EUR', 13),
	(1950101013, '2023-02-17', '2023-04-18', 615.15, 'USD', 19)

-----------------03 Exercise 08/10/2023-----------------------

UPDATE Invoices
SET DueDate = '2023-04-01'
WHERE IssueDate BETWEEN '2022-11-01' AND '2022-11-30'

UPDATE Clients
SET AddressId = 3
WHERE [Name] LIKE '%co%'

-----------------04 Exercise 08/10/2023-----------------------

DELETE FROM ProductsClients
WHERE ClientId = 11

DELETE FROM Invoices
WHERE ClientId = 11
DELETE FROM Clients WHERE NumberVat LIKE 'IT%'

-----------------05 Exercise 08/10/2023-----------------------

SELECT Number, Currency
FROM Invoices
ORDER BY Amount DESC, DueDate

-----------------06 Exercise 08/10/2023-----------------------

SELECT p.Id, p.[Name], Price, c.[Name]
FROM Products AS p
JOIN Categories AS c ON p.CategoryId = c.Id
WHERE c.[Name] IN('ADR', 'Others')
ORDER BY Price DESC

-----------------07 Exercise 08/10/2023-----------------------

SELECT c.Id, c.[Name] AS [Client], CONCAT(a.StreetName, ' ', a.StreetNumber, ', ', a.City, ', ', a.PostCode, ', ', co.[Name]) AS [Address]
FROM Clients AS c
LEFT JOIN ProductsClients AS pc ON c.Id = pc.ClientId
JOIN Addresses AS a ON c.AddressId = a.Id
JOIN Countries AS co ON a.CountryId = co.Id
WHERE pc.ProductId IS NULL
ORDER BY c.[Name]

-----------------08 Exercise 08/10/2023-----------------------

SELECT TOP(7) Number, Amount, c.[Name] 
FROM Invoices AS i
JOIN Clients AS c ON i.ClientId = c.Id
WHERE IssueDate < '2023-01-01' AND (Currency = 'EUR' OR (Amount > 500.00 AND c.NumberVAT LIKE 'DE%'))
ORDER BY i.Number, Amount DESC

-----------------09 Exercise 08/10/2023-----------------------

SELECT c.[Name] AS [Client], MAX(p.Price) AS [Price], c.NumberVAT AS [VAT Number]
FROM Clients AS c
JOIN ProductsClients AS pc ON c.Id = pc.ClientId
JOIN Products AS p ON p.Id = pc.ProductId
WHERE c.[Name] NOT LIKE '%KG'
GROUP BY c.[Name], NumberVAT
ORDER BY MAX(p.Price) DESC

-----------------10 Exercise 08/10/2023-----------------------

SELECT c.[Name] AS [Client], FLOOR(AVG(p.Price)) AS [Average Price]
FROM Clients AS c
JOIN ProductsClients AS pc ON c.Id = pc.ClientId
JOIN Products AS p ON p.Id = pc.ProductId
JOIN Vendors AS v ON v.Id = p.VendorId
WHERE v.NumberVAT LIKE '%FR%'
GROUP BY c.[Name]
ORDER BY AVG(p.Price), c.[Name] DESC

-----------------11 Exercise 08/10/2023-----------------------

CREATE FUNCTION udf_ProductWithClients(@name NVARCHAR(100))
RETURNS INT
AS 
BEGIN
	DECLARE @total INT =
	(
	SELECT COUNT(*)
	FROM Products AS p
	JOIN ProductsClients AS pc ON p.Id = pc.ProductId
	WHERE p.[Name] = @name
	)

	RETURN @total
END

SELECT dbo.udf_ProductWithClients('DAF FILTER HU12103X')

-----------------12 Exercise 08/10/2023-----------------------

CREATE PROC usp_SearchByCountry(@country NVARCHAR(100))
AS
SELECT v.[Name] AS [Vendor], 
		v.NumberVAT AS [VAT], 
		CONCAT_WS(' ', a.StreetName, a.StreetNumber) AS [Street Info], 
		CONCAT_WS(' ', a.City, a.PostCode) AS [City Info]
FROM Vendors AS v
JOIN Addresses AS a ON v.AddressId = a.Id
JOIN Countries AS c ON a.CountryId = c.Id
WHERE c.[Name] = @country
ORDER BY v.[Name], a.City

EXEC usp_SearchByCountry 'France'