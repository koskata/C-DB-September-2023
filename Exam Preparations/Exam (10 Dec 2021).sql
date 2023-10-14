--------------------01 Exercise 14/10/2023-----------------------------
USE Airport

CREATE DATABASE Airport

CREATE TABLE Passengers(
	[Id] INT PRIMARY KEY IDENTITY,
	[FullName] VARCHAR(100) UNIQUE NOT NULL,
	[Email] VARCHAR(50) UNIQUE NOT NULL
)

CREATE TABLE Pilots(
	[Id] INT PRIMARY KEY IDENTITY,
	[FirstName] VARCHAR(30) UNIQUE NOT NULL,
	[LastName] VARCHAR(30) UNIQUE NOT NULL,
	[Age] TINYINT NOT NULL
		CHECK(Age >= 21 AND Age <= 62),
	[Rating] FLOAT 
		CHECK(Rating >= 0.0 AND Rating <= 10.0)
)

CREATE TABLE AircraftTypes(
	[Id] INT PRIMARY KEY IDENTITY,
	[TypeName] VARCHAR(30) UNIQUE NOT NULL
)

CREATE TABLE Aircraft(
	[Id] INT PRIMARY KEY IDENTITY,
	[Manufacturer] VARCHAR(25) NOT NULL,
	[Model] VARCHAR(30) NOT NULL,
	[Year] INT NOT NULL,
	[FlightHours] INT,
	[Condition] CHAR(1) NOT NULL,
	[TypeId] INT FOREIGN KEY REFERENCES AircraftTypes(Id) NOT NULL
)

CREATE TABLE PilotsAircraft(
	[AircraftId] INT FOREIGN KEY REFERENCES Aircraft(Id) NOT NULL,
	[PilotId] INT FOREIGN KEY REFERENCES Pilots(Id) NOT NULL,
	PRIMARY KEY(AircraftId, PilotId)
)

CREATE TABLE Airports(
	[Id] INT PRIMARY KEY IDENTITY,
	[AirportName] VARCHAR(70) UNIQUE NOT NULL,
	[Country] VARCHAR(100) UNIQUE NOT NULL
)

CREATE TABLE FlightDestinations(
	[Id] INT PRIMARY KEY IDENTITY,
	[AirportId] INT FOREIGN KEY REFERENCES Airports(Id) NOT NULL,
	[Start] DATETIME NOT NULL,
	[AircraftId] INT FOREIGN KEY REFERENCES Aircraft(Id) NOT NULL,
	[PassengerId] INT FOREIGN KEY REFERENCES Passengers(Id) NOT NULL,
	[TicketPrice] DECIMAL(18, 2) DEFAULT 15 NOT NULL
)

--------------------02 Exercise 14/10/2023-----------------------------

DECLARE @count INT = 0

WHILE @count <= 10
BEGIN
INSERT INTO Passengers (FullName, Email) VALUES
		(CONCAT_WS(' ', 
		(
			SELECT FirstName 
			FROM Pilots 
			WHERE Id = 5 + @count
		), 
		(
			SELECT LastName 
			FROM Pilots
			WHERE Id = 5 + @count
		)),  CONCAT(
		(
			SELECT FirstName 
			FROM Pilots
			WHERE Id = 5 + @count
		), 
		(
			SELECT LastName 
			FROM Pilots
			WHERE Id = 5 + @count
		), '@gmail.com'))


		SET @count += 1;
END

--------------------03 Exercise 14/10/2023-----------------------------

UPDATE Aircraft
SET Condition = 'A'
WHERE (Condition = 'C' OR Condition = 'B') 
			AND (FlightHours IS NULL OR FlightHours <= 100)
				AND [Year] >= 2013

--------------------04 Exercise 14/10/2023-----------------------------

DELETE FROM Passengers WHERE LEN(FullName) <= 10

--------------------05 Exercise 14/10/2023-----------------------------

DROP DATABASE Airport

SELECT Manufacturer, Model, FlightHours, Condition 
FROM Aircraft
ORDER BY FlightHours DESC

--------------------06 Exercise 14/10/2023-----------------------------

SELECT FirstName, LastName, a.Manufacturer, a.Model, a.FlightHours 
FROM Pilots AS p
JOIN PilotsAircraft AS pa ON p.Id = pa.PilotId
JOIN Aircraft AS a ON a.Id = pa.AircraftId
WHERE a.FlightHours < 304 AND FlightHours IS NOT NULL
ORDER BY a.FlightHours DESC, FirstName

--------------------07 Exercise 14/10/2023-----------------------------

SELECT TOP(20) fd.Id, [Start], p.FullName,ar.AirportName, TicketPrice
FROM FlightDestinations AS fd
JOIN Passengers As p ON fd.PassengerId = p.Id
JOIN Airports AS ar ON fd.AirportId = ar.Id
WHERE DAY([Start]) % 2 = 0 
ORDER BY TicketPrice DESC, ar.AirportName

--------------------08 Exercise 14/10/2023-----------------------------

SELECT a.Id AS [AircraftId], Manufacturer, FlightHours, COUNT(fd.Id) AS FlightDestinationsCount, ROUND(AVG(fd.TicketPrice), 2) AS AvgPrice
FROM Aircraft AS a
JOIN FlightDestinations AS fd ON fd.AircraftId = a.Id
GROUP BY a.Id, Manufacturer, FlightHours
HAVING COUNT(fd.Id) >= 2
ORDER BY FlightDestinationsCount DESC, a.Id 

--------------------09 Exercise 14/10/2023-----------------------------

SELECT FullName, COUNT(a.Id) AS CountOfAircraft, SUM(TicketPrice) AS TotalPayed
FROM Passengers AS p
JOIN FlightDestinations AS fd ON fd.PassengerId = p.Id
JOIN Aircraft AS a ON fd.AircraftId = a.Id
WHERE SUBSTRING(FullName, 2, 1) = 'a'
GROUP BY FullName
HAVING COUNT(a.Id) > 1
ORDER BY FullName

--------------------10 Exercise 14/10/2023-----------------------------

SELECT a.AirportName, [Start] AS DayTime, TicketPrice, p.FullName, ar.Manufacturer, ar.Model
FROM FlightDestinations AS fd
JOIN Airports AS a ON fd.AirportId = a.Id
JOIN Aircraft AS ar ON fd.AircraftId = ar.Id 
JOIN Passengers AS p ON fd.PassengerId = p.Id
WHERE (DATEPART(HOUR, [Start]) BETWEEN 6 AND 20) AND TicketPrice > 2500
ORDER BY ar.Model

--------------------11 Exercise 14/10/2023-----------------------------

CREATE FUNCTION udf_FlightDestinationsByEmail(@email VARCHAR(30))
RETURNS INT
AS
BEGIN
	DECLARE @total INT = (
		SELECT COUNT(*)
		FROM FlightDestinations AS fd
		JOIN Passengers AS p ON fd.PassengerId = p.Id
		WHERE p.Email = @email
	)

	RETURN @total
END

SELECT dbo.udf_FlightDestinationsByEmail('PierretteDunmuir@gmail.com')

--------------------12 Exercise 14/10/2023-----------------------------

CREATE PROC usp_SearchByAirportName(@airportName VARCHAR(70))
AS


	SELECT ar.AirportName, p.FullName, 
		CASE 
			WHEN TicketPrice <= 400 THEN 'Low'
			WHEN TicketPrice BETWEEN 401 AND 1500 THEN 'Medium'
			WHEN TicketPrice > 1500 THEN 'High'
		END LevelOfTickerPrice,
		a.Manufacturer, Condition, [at].TypeName
	FROM FlightDestinations AS fd
	JOIN Airports AS ar ON fd.AirportId = ar.Id
	JOIN Passengers AS p ON fd.PassengerId = p.Id
	JOIN Aircraft AS a ON fd.AircraftId = a.Id
	JOIN AircraftTypes As [at] ON a.TypeId = [at].Id
	WHERE ar.AirportName = @airportName
	ORDER BY Manufacturer, FullName

EXEC usp_SearchByAirportName 'Sir Seretse Khama International Airport'