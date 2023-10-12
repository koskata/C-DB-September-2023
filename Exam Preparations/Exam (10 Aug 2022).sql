----------------------01 Exercise 11/10/2023------------------------------
USE NationalTouristSitesOfBulgaria

CREATE DATABASE NationalTouristSitesOfBulgaria

CREATE TABLE Categories(
	[Id] INT PRIMARY KEY IDENTITY,
	[Name] VARCHAR(50) NOT NULL
)

CREATE TABLE Locations(
	[Id] INT PRIMARY KEY IDENTITY,
	[Name] VARCHAR(50) NOT NULL,
	[Municipality] VARCHAR(50),
	[Province] VARCHAR(50)
) 

CREATE TABLE Sites(
	[Id] INT PRIMARY KEY IDENTITY,
	[Name] VARCHAR(100) NOT NULL,
	[LocationId] INT FOREIGN KEY REFERENCES Locations(Id) NOT NULL,
	[CategoryId] INT FOREIGN KEY REFERENCES Categories(Id) NOT NULL,
	[Establishment] VARCHAR(15)
)

CREATE TABLE Tourists(
	[Id] INT PRIMARY KEY IDENTITY,
	[Name] VARCHAR(50) NOT NULL,
	[Age] INT NOT NULL CHECK(Age >= 0 AND Age <= 120),
	[PhoneNumber] VARCHAR(20) NOT NULL,
	[Nationality] VARCHAR(30) NOT NULL,
	[Reward] VARCHAR(20)
)

CREATE TABLE SitesTourists(
	[TouristId] INT FOREIGN KEY REFERENCES Tourists(Id) NOT NULL,
	[SiteId] INT FOREIGN KEY REFERENCES Sites(Id) NOT NULL
	PRIMARY KEY(TouristId, SiteId)
)

CREATE TABLE BonusPrizes(
	[Id] INT PRIMARY KEY IDENTITY,
	[Name] VARCHAR(50) NOT NULL,
)

CREATE TABLE TouristsBonusPrizes(
	[TouristId] INT FOREIGN KEY REFERENCES Tourists(Id) NOT NULL,
	[BonusPrizeId] INT FOREIGN KEY REFERENCES BonusPrizes(Id) NOT NULL,
	PRIMARY KEY(TouristId, BonusPrizeId)
)

----------------------02 Exercise 11/10/2023------------------------------

INSERT INTO Tourists([Name], Age, PhoneNumber, Nationality, Reward)
	VALUES
	('Borislava Kazakova', 52, '+359896354244', 'Bulgaria', NULL),
	('Peter Bosh', 48, '+447911844141', 'UK', NULL),
	('Martin Smith', 29, '+353863818592', 'Ireland', 'Bronze badge'),
	('Svilen Dobrev', 49, '+359986584786', 'Bulgaria', 'Silver badge'),
	('Kremena Popova', 38, '+359893298604', 'Bulgaria', NULL)

INSERT INTO Sites([Name], LocationId, CategoryId, Establishment)
	VALUES
	('Ustra fortress', 90, 7, 'X'),
	('Karlanovo Pyramids', 65, 7, NULL),
	('The Tomb of Tsar Sevt', 63, 8, 'V BC'),
	('Sinite Kamani Natural Park', 17, 1, NULL),
	('St. Petka of Bulgaria – Rupite', 92, 6, '1994')

----------------------03 Exercise 11/10/2023------------------------------

UPDATE Sites
SET Establishment = 'not defined'
WHERE Establishment IS NULL

----------------------04 Exercise 11/10/2023------------------------------

SELECT * FROM BonusPrizes
SELECT * FROM TouristsBonusPrizes

DELETE FROM TouristsBonusPrizes WHERE BonusPrizeId = 5
DELETE FROM BonusPrizes WHERE Id = 5

----------------------05 Exercise 11/10/2023------------------------------

DROP DATABASE NationalTouristSitesOfBulgaria

CREATE DATABASE NationalTouristSitesOfBulgaria

SELECT [Name], Age, PhoneNumber, Nationality 
FROM Tourists
ORDER BY Nationality, Age DESC, [Name]

----------------------06 Exercise 11/10/2023------------------------------

SELECT s.[Name] AS [Site], l.[Name], Establishment, c.[Name]
FROM Sites AS s
JOIN Locations AS l ON l.Id = s.LocationId
JOIN Categories AS c ON c.Id = s.CategoryId
ORDER BY c.[Name] DESC, l.[Name], [Site]

----------------------07 Exercise 11/10/2023------------------------------

SELECT Province, Municipality, l.[Name] AS [Location], COUNT(*) AS CountOfSites
FROM Locations AS l
JOIN Sites AS s ON s.LocationId = l.Id
WHERE Province = 'Sofia'
GROUP BY Province, Municipality, l.[Name]
ORDER BY CountOfSites DESC, l.[Name]

----------------------08 Exercise 11/10/2023------------------------------

SELECT s.[Name] AS [Site], l.[Name] AS [Location], Municipality, Province, Establishment
FROM Sites AS s
JOIN Locations AS l ON s.LocationId = l.Id
WHERE Establishment LIKE '%BC%'
						AND (l.[Name] NOT LIKE 'M%' 
							AND l.[Name] NOT LIKE 'B%' 
							AND l.[Name] NOT LIKE 'D%')
ORDER BY s.[Name]

----------------------09 Exercise 11/10/2023------------------------------

SELECT t.[Name], Age, PhoneNumber, Nationality, ISNULL(b.[Name], '(no bonus prize)') AS Reward
FROM Tourists AS t
LEFT JOIN TouristsBonusPrizes AS tb ON t.Id = tb.TouristId
LEFT JOIN BonusPrizes AS b ON b.Id = tb.BonusPrizeId
ORDER BY t.[Name]

----------------------10 Exercise 11/10/2023------------------------------

SELECT SUBSTRING(t.Name, CHARINDEX(' ', t.Name) + 1, LEN(t.Name)) AS 'LastName',
		Nationality, Age, PhoneNumber
FROM Tourists AS t
JOIN SitesTourists AS st ON t.Id = st.TouristId
JOIN Sites As s ON s.Id = st.SiteId
JOIN Categories As c ON c.Id = s.CategoryId
WHERE c.[Name] = 'History and archaeology'
GROUP BY t.[Name], Nationality, Age, PhoneNumber
ORDER BY LastName

----------------------11 Exercise 11/10/2023------------------------------

CREATE FUNCTION udf_GetTouristsCountOnATouristSite(@Site VARCHAR(100))
RETURNS INT 
AS
BEGIN
	DECLARE @total INT = (
	SELECT COUNT(*) 
	FROM Sites AS s
	JOIN SitesTourists AS st ON st.SiteId = s.Id
	JOIN Tourists AS t ON t.Id = st.TouristId
	WHERE s.[Name] = @Site
	)

	RETURN @total
END

SELECT dbo.udf_GetTouristsCountOnATouristSite('Regional History Museum – Vratsa')

----------------------12 Exercise 11/10/2023------------------------------



CREATE PROC usp_AnnualRewardLottery(@TouristName VARCHAR(50))
AS
BEGIN
	IF (SELECT COUNT(*)
			FROM Tourists AS t
			JOIN SitesTourists AS st ON t.Id = st.TouristId
			JOIN Sites As s ON s.Id = st.SiteId
			WHERE t.Name = @TouristName) >= 100
		BEGIN
			UPDATE Tourists
			SET Reward = 'Gold badge'
			WHERE Tourists.[Name] = @TouristName
		END

	ELSE IF (SELECT COUNT(*)
			FROM Tourists AS t
			JOIN SitesTourists AS st ON t.Id = st.TouristId
			JOIN Sites As s ON s.Id = st.SiteId
			WHERE t.Name = @TouristName) >= 50
		BEGIN
			UPDATE Tourists
			SET Reward = 'Silver badge'
			WHERE Tourists.[Name] = @TouristName
		END

	ELSE IF (SELECT COUNT(*)
			FROM Tourists AS t
			JOIN SitesTourists AS st ON t.Id = st.TouristId
			JOIN Sites As s ON s.Id = st.SiteId
			WHERE t.Name = @TouristName) >= 25
		BEGIN
			UPDATE Tourists
			SET Reward = 'Bronze badge'
			WHERE Tourists.[Name] = @TouristName
		END
	SELECT [Name], Reward FROM Tourists
	WHERE [Name] = @TouristName
END

EXEC usp_AnnualRewardLottery 'Stoyan Mitev'
