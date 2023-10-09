----------------------01 Exercise 09/10/2023------------------------------------

USE Boardgames

CREATE DATABASE Boardgames

CREATE TABLE Categories(
	[Id] INT PRIMARY KEY IDENTITY,
	[Name] VARCHAR(50) NOT NULL
)

CREATE TABLE Addresses(
	[Id] INT PRIMARY KEY IDENTITY,
	[StreetName] NVARCHAR(100) NOT NULL,
	[StreetNumber] INT NOT NULL,
	[Town] VARCHAR(30) NOT NULL,
	[Country] VARCHAR(50) NOT NULL,
	[ZIP] INT NOT NULL
)

CREATE TABLE Publishers(
	[Id] INT PRIMARY KEY IDENTITY,
	[Name] VARCHAR(30) UNIQUE NOT NULL,
	[AddressId] INT FOREIGN KEY REFERENCES [Addresses]([Id]) NOT NULL,
	[Website] NVARCHAR(40),
	[Phone] NVARCHAR(20)
)

CREATE TABLE PlayersRanges(
	[Id] INT PRIMARY KEY IDENTITY,
	[PlayersMin] INT NOT NULL,
	[PlayersMax] INT NOT NULL
)

CREATE TABLE Boardgames(
	[Id] INT PRIMARY KEY IDENTITY,
	[Name] NVARCHAR(30) NOT NULL,
	[YearPublished] INT NOT NULL,
	[Rating] DECIMAL(5, 2) NOT NULL,
	[CategoryId] INT FOREIGN KEY REFERENCES Categories(Id) NOT NULL,
	[PublisherId] INT FOREIGN KEY REFERENCES Publishers(Id) NOT NULL,
	[PlayersRangeId] INT FOREIGN KEY REFERENCES PlayersRanges(Id) NOT NULL
)

CREATE TABLE Creators(
	[Id] INT PRIMARY KEY IDENTITY,
	[FirstName] NVARCHAR(30) NOT NULL,
	[LastName] NVARCHAR(30) NOT NULL,
	[Email] NVARCHAR(30) NOT NULL,
)

CREATE TABLE CreatorsBoardgames(
	[CreatorId] INT FOREIGN KEY REFERENCES Creators(Id) NOT NULL,
	[BoardgameId] INT FOREIGN KEY REFERENCES Boardgames(Id) NOT NULL,
	PRIMARY KEY(CreatorId, BoardgameId)
)

----------------------02 Exercise 09/10/2023------------------------------------

INSERT INTO Boardgames([Name], YearPublished, Rating, CategoryId, PublisherId, PlayersRangeId)
	VALUES
	('Deep Blue', 2019, 5.67, 1, 15, 7),
	('Paris', 2016, 9.78, 7, 1, 5),
	('Catan: Starfarers', 2021, 9.87, 7, 13, 6),
	('Bleeding Kansas', 2020, 3.25, 3, 7, 4),
	('One Small Step', 2019, 5.75, 5, 9, 2)

INSERT INTO Publishers([Name], AddressId, Website, Phone)
	VALUES
	('Agman Games', 5, 'www.agmangames.com', '+16546135542'),
	('Amethyst Games', 7, 'www.amethystgames.com', '+15558889992'),
	('BattleBooks', 13, 'www.battlebooks.com', '+12345678907')

----------------------03 Exercise 09/10/2023------------------------------------

UPDATE PlayersRanges
SET PlayersMax = PlayersMax + 1
WHERE PlayersMin = 2 AND PlayersMax = 2

UPDATE Boardgames
SET [Name] = [Name] + 'V2'
WHERE YearPublished >= 2020

----------------------04 Exercise 09/10/2023------------------------------------

DELETE FROM CreatorsBoardgames WHERE BoardgameId IN(1, 16, 31, 47)
DELETE FROM Boardgames WHERE PublisherId IN(1, 16)
DELETE FROM Publishers WHERE AddressId = 5
DELETE FROM Addresses WHERE Town LIKE 'L%'

SELECT * FROM Addresses
SELECT * FROM Boardgames
SELECT * FROM Publishers

----------------------05 Exercise 09/10/2023------------------------------------

SELECT [Name], [Rating] FROM Boardgames
ORDER BY YearPublished, [Name] DESC

----------------------06 Exercise 09/10/2023------------------------------------

SELECT b.[Id], b.[Name], b.[YearPublished], c.[Name] 
FROM Boardgames AS b
JOIN Categories AS c ON b.CategoryId = c.Id
WHERE c.[Name] IN('Strategy Games', 'Wargames')
ORDER BY YearPublished DESC

----------------------07 Exercise 09/10/2023------------------------------------

SELECT c.[Id], CONCAT_WS(' ', FirstName, LastName) AS CreatorName, Email
FROM Creators AS c
LEFT JOIN CreatorsBoardgames AS cb ON cb.CreatorId = c.Id
LEFT JOIN Boardgames AS b ON b.Id = cb.BoardgameId
WHERE BoardgameId IS NULL
ORDER BY CreatorName

----------------------08 Exercise 09/10/2023------------------------------------

SELECT TOP(5) b.[Name], [Rating], c.[Name] AS CategoryName
FROM Boardgames AS b
JOIN Categories AS c ON b.CategoryId = c.Id
JOIN PlayersRanges AS p ON b.PlayersRangeId = p.Id
WHERE (Rating > 7.00 AND b.[Name] LIKE '%a%') OR (Rating > 7.50 AND (p.PlayersMin = 2 AND p.PlayersMax = 5))
ORDER BY b.[Name], Rating DESC

----------------------09 Exercise 09/10/2023------------------------------------

SELECT CONCAT_WS(' ', FirstName, LastName) AS FullName, Email, MAX(b.Rating)
FROM Creators AS c
JOIN CreatorsBoardgames AS cb ON c.Id = cb.CreatorId
JOIN Boardgames AS b ON b.Id = cb.BoardgameId
WHERE Email LIKE '%.com'
GROUP BY CONCAT_WS(' ', FirstName, LastName), Email
ORDER BY FullName

----------------------10 Exercise 09/10/2023------------------------------------

SELECT LastName, CEILING(AVG(b.Rating)) AS AverageRating, p.[Name] AS PublisherName
FROM Creators AS c
JOIN CreatorsBoardgames AS cb ON c.Id = cb.CreatorId
JOIN Boardgames AS b ON b.Id = cb.BoardgameId
JOIN Publishers AS p ON b.PublisherId = p.Id
WHERE p.[Name] = 'Stonemaier Games'
GROUP BY LastName, p.[Name]
ORDER BY AVG(b.Rating) DESC

----------------------11 Exercise 09/10/2023------------------------------------

CREATE FUNCTION udf_CreatorWithBoardgames(@name NVARCHAR(100))
RETURNS INT
AS
BEGIN
	DECLARE @total INT = (
	SELECT COUNT(*)
	FROM CreatorsBoardgames AS cb
	JOIN Creators AS c ON c.Id = cb.CreatorId
	WHERE c.FirstName = @name
	)

	RETURN @total
END

SELECT dbo.udf_CreatorWithBoardgames('Bruno')

----------------------12 Exercise 09/10/2023------------------------------------

CREATE PROC usp_SearchByCategory(@category VARCHAR(100))
AS
	SELECT b.[Name], YearPublished, Rating, 
			c.[Name] AS CategoryName, 
			p.[Name] AS PublisherName, 
			CONCAT_WS(' ', pr.PlayersMin, 'people') AS MinPlayers, 
			CONCAT_WS(' ', pr.PlayersMax, 'people') AS MaxPlayers
	FROM Boardgames AS b
	JOIN Categories As c ON b.CategoryId = c.Id
	JOIN Publishers As p ON b.PublisherId = p.Id
	JOIN PlayersRanges AS pr ON b.PlayersRangeId = pr.Id
	WHERE c.[Name] = @category
	ORDER BY p.[Name], b.YearPublished DESC

EXEC usp_SearchByCategory 'Wargames'