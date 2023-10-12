--------------------01 Exercise 12/10/2023---------------------------
USE Zoo

CREATE DATABASE Zoo

CREATE TABLE Owners(
	[Id] INT PRIMARY KEY IDENTITY,
	[Name] VARCHAR(50) NOT NULL,
	[PhoneNumber] VARCHAR(15) NOT NULL,
	[Address] VARCHAR(50)
)

CREATE TABLE AnimalTypes(
	[Id] INT PRIMARY KEY IDENTITY,
	[AnimalType] VARCHAR(30) NOT NULL
)

CREATE TABLE Cages(
	[Id] INT PRIMARY KEY IDENTITY,
	[AnimalTypeId] INT FOREIGN KEY REFERENCES AnimalTypes(Id) NOT NULL
)

CREATE TABLE Animals(
	[Id] INT PRIMARY KEY IDENTITY,
	[Name] VARCHAR(30) NOT NULL,
	[BirthDate] DATE NOT NULL,
	[OwnerId] INT FOREIGN KEY REFERENCES Owners(Id),
	[AnimalTypeId] INT FOREIGN KEY REFERENCES AnimalTypes(Id) NOT NULL
)

CREATE TABLE AnimalsCages(
	[CageId] INT FOREIGN KEY REFERENCES Cages(Id) NOT NULL,
	[AnimalId] INT FOREIGN KEY REFERENCES Animals(Id) NOT NULL,
	PRIMARY KEY(CageId, AnimalId)
)

CREATE TABLE VolunteersDepartments(
	[Id] INT PRIMARY KEY IDENTITY,
	[DepartmentName] VARCHAR(30) NOT NULL
)

CREATE TABLE Volunteers(
	[Id] INT PRIMARY KEY IDENTITY,
	[Name] VARCHAR(50) NOT NULL,
	[PhoneNumber] VARCHAR(15) NOT NULL,
	[Address] VARCHAR(50),
	[AnimalId] INT FOREIGN KEY REFERENCES Animals(Id),
	[DepartmentId] INT FOREIGN KEY REFERENCES VolunteersDepartments(Id) NOT NULL
)

--------------------02 Exercise 12/10/2023---------------------------

INSERT INTO Volunteers([Name], PhoneNumber, [Address], AnimalId, DepartmentId)
	VALUES
	('Anita Kostova', '0896365412', 'Sofia, 5 Rosa str.', 15, 1),
	('Dimitur Stoev', '0877564223', NULL, 42, 4),
	('Kalina Evtimova', '0896321112', 'Silistra, 21 Breza str.', 9, 7),
	('Stoyan Tomov', '0898564100', 'Montana, 1 Bor str.', 18, 8),
	('Boryana Mileva', '0888112233', NULL, 31, 5)

INSERT INTO Animals ([Name], BirthDate, OwnerId, AnimalTypeId)
	VALUES
	('Giraffe', '2018-09-21', 21, 1),
	('Harpy Eagle', '2015-04-17', 15, 3),
	('Hamadryas Baboon', '2017-11-02', NULL, 1),
	('Tuatara', '2021-06-30', 2, 4)

--------------------03 Exercise 12/10/2023---------------------------

UPDATE Animals
SET OwnerId = 4
WHERE OwnerId IS NULL

--------------------04 Exercise 12/10/2023---------------------------

SELECT * FROM VolunteersDepartments
SELECT * FROM Volunteers

DELETE FROM Volunteers WHERE DepartmentId = 2
DELETE FROM VolunteersDepartments WHERE Id = 2

--------------------05 Exercise 12/10/2023---------------------------

DROP DATABASE Zoo

SELECT [Name], PhoneNumber, [Address], AnimalId, DepartmentId 
FROM Volunteers
ORDER BY [Name], AnimalId, DepartmentId

--------------------06 Exercise 12/10/2023---------------------------

SELECT [Name], [at].AnimalType, FORMAT (BirthDate, 'dd.MM.yyyy')
FROM Animals AS a
JOIN AnimalTypes AS [at] ON a.AnimalTypeId = [at].Id
ORDER BY [Name]

--------------------07 Exercise 12/10/2023---------------------------

SELECT TOP(5) o.[Name] AS [Owner], COUNT(*) AS CountOfAnimals
FROM Owners AS o
JOIN Animals AS a ON o.Id = a.OwnerId
GROUP BY o.[Name]
ORDER BY CountOfAnimals DESC, [Owner]

--------------------08 Exercise 12/10/2023---------------------------

SELECT CONCAT(o.[Name], '-', a.[Name]) AS OwnersAnimals, PhoneNumber, CageId
FROM Owners AS o
JOIN Animals AS a ON o.Id = a.OwnerId
JOIN AnimalsCages AS ac ON a.Id = ac.AnimalId
JOIN Cages AS c ON c.Id = ac.CageId
JOIN AnimalTypes AS [at] ON a.AnimalTypeId = [at].Id
WHERE [at].AnimalType = 'mammals'
ORDER BY o.[Name], a.[Name] DESC

--------------------09 Exercise 12/10/2023---------------------------

SELECT v.[Name], PhoneNumber, 
				SUBSTRING([Address], CHARINDEX(',', [Address]) + 2, LEN([Address])) AS [Address]
FROM Volunteers AS v
JOIN VolunteersDepartments AS vd ON v.DepartmentId = vd.Id
WHERE [Address] LIKE '%Sofia%' AND vd.DepartmentName = 'Education program assistant' 
ORDER BY v.[Name]

--------------------10 Exercise 12/10/2023---------------------------

SELECT a.[Name], YEAR(BirthDate) AS [BirthYear], [at].AnimalType
FROM Animals AS a
JOIN AnimalTypes AS [at] ON a.AnimalTypeId = [at].Id
WHERE [OwnerId] IS NULL AND AnimalType <> 'Birds' AND YEAR(BirthDate) >= '2018'
ORDER BY a.[Name]


SELECT * FROM Animals

--------------------11 Exercise 12/10/2023---------------------------

CREATE FUNCTION udf_GetVolunteersCountFromADepartment(@VolunteersDepartment VARCHAR(50))
RETURNS INT
AS
BEGIN
	DECLARE @total INT = (
	SELECT COUNT(*)
	FROM Volunteers AS v
	JOIN VolunteersDepartments AS vd ON v.DepartmentId = vd.Id
	WHERE vd.DepartmentName = @VolunteersDepartment
	)

	RETURN @total
END

SELECT dbo.udf_GetVolunteersCountFromADepartment('Education program assistant')

--------------------12 Exercise 12/10/2023---------------------------

CREATE PROC usp_AnimalsWithOwnersOrNot(@AnimalName VARCHAR(50))
AS
	IF (SELECT OwnerId FROM Animals
			WHERE [Name] = @AnimalName) IS NULL
		SELECT a.[Name], 'For adoption' AS OwnersName
		FROM Animals AS a
		WHERE a.[Name] = @AnimalName

	ELSE
	SELECT a.[Name], o.[Name]
		FROM Animals AS a
		JOIN Owners AS o ON a.OwnerId = o.Id
		WHERE a.[Name] = @AnimalName
	
	EXEC usp_AnimalsWithOwnersOrNot 'Hippo'