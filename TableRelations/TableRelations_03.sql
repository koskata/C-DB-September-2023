
-----------01 Exercise	23/09/2023-------------------------

CREATE DATABASE [TableRelations_03]

USE [TableRelations_03]

CREATE TABLE [Passports](
	[PassportID] INT PRIMARY KEY IDENTITY(101, 1),
	[PassportNumber] NVARCHAR(20) NOT NULL
)

CREATE TABLE [Persons](
	[PersonID] INT PRIMARY KEY IDENTITY,
	[FirstName] NVARCHAR(100) NOT NULL,
	[Salary] DECIMAL(10, 2) NOT NULL,
	[PassportID] INT UNIQUE FOREIGN KEY REFERENCES [Passports]([PassportID])
)


INSERT INTO [Passports] (PassportNumber)
	VALUES
	('N34FG21B'),
	('K65LO4R7'),
	('ZE657QP2')

INSERT INTO [Persons] (FirstName, Salary, PassportID)
	VALUES
	('Roberto', 43300.00, 102),
	('Tom', 56100.00, 103),
	('Yana', 60200.00, 101)

SELECT * FROM Persons
SELECT * FROM Passports


-----------02 Exercise	23/09/2023-------------------------

CREATE TABLE Manufacturers(
	[ManufacturerID] INT PRIMARY KEY IDENTITY,
	[Name] NVARCHAR(100) NOT NULL,
	[EstablishedOn] DATE
)


CREATE TABLE Models(
	[ModelID] INT PRIMARY KEY IDENTITY(101, 1),
	[Name] NVARCHAR(100) NOT NULL,
	[ManufacturerID] INT FOREIGN KEY REFERENCES Manufacturers(ManufacturerID)
)

INSERT INTO Manufacturers([Name], EstablishedOn)
	VALUES
	('BMW', '1916-03-07'),
	('Tesla', '2003-01-01'),
	('Lada', '1966-05-01')

INSERT INTO Models([Name], ManufacturerID)
	VALUES
	('X1', 1),
	('i6', 1),
	('Model S', 2),
	('Model X', 2),
	('Model 3', 2),
	('Nova', 3)


SELECT * FROM Models
SELECT * FROM Manufacturers

-----------03 Exercise	23/09/2023-------------------------

CREATE TABLE Students(
	[StudentID] INT PRIMARY KEY IDENTITY,
	[Name] NVARCHAR(100) NOT NULL
)

CREATE TABLE Exams(
	[ExamID] INT PRIMARY KEY IDENTITY(101, 1),
	[Name] NVARCHAR(100) NOT NULL
)

CREATE TABLE StudentsExams(
	[StudentID] INT FOREIGN KEY REFERENCES Students(StudentID),
	[ExamID] INT FOREIGN KEY REFERENCES Exams(ExamID),
	PRIMARY KEY(StudentID, ExamID)
)

INSERT INTO Students([Name])
	VALUES
	('Mila'),
	('Toni'),
	('Ron')

INSERT INTO Exams([Name])
	VALUES
	('SpringMVC'),
	('Neo4j'),
	('Oracle 11g')

INSERT INTO StudentsExams(StudentID, ExamID)
	VALUES
	(1, 101),
	(1, 102),
	(2, 101),
	(3, 103),
	(2, 102),
	(2, 103)

SELECT * FROM Students
SELECT * FROM Exams
SELECT * FROM StudentsExams

-----------04 Exercise	23/09/2023-------------------------

CREATE TABLE Teachers(
	[TeacherID] INT PRIMARY KEY IDENTITY(101, 1),
	[Name] NVARCHAR(100) NOT NULL,
	[ManagerID] INT FOREIGN KEY REFERENCES Teachers(TeacherID)
)

INSERT INTO Teachers([Name], [ManagerID])
	VALUES
	('John', NULL),
	('Maya', 106),
	('Silvia', 106),
	('Ted', 105),
	('Mark', 101),
	('Greta', 101)

SELECT * FROM Teachers

-----------05 Exercise	23/09/2023-------------------------

CREATE TABLE Cities(
	[CityID] INT PRIMARY KEY IDENTITY,
	[Name] NVARCHAR(100) NOT NULL
)

CREATE TABLE Customers(
	[CustomerID] INT PRIMARY KEY IDENTITY,
	[Name] NVARCHAR(100) NOT NULL,
	[Birthday] DATE,
	[CityID] INT FOREIGN KEY REFERENCES Cities(CityID)
)

CREATE TABLE Orders(
	[OrderID] INT PRIMARY KEY IDENTITY,
	[CustomerID] INT FOREIGN KEY REFERENCES Customers(CustomerID)
)

CREATE TABLE ItemTypes(
	[ItemTypeID] INT PRIMARY KEY IDENTITY,
	[Name] NVARCHAR(100) NOT NULL 
)

CREATE TABLE Items(
	[ItemID] INT PRIMARY KEY IDENTITY(101, 1),
	[Name] NVARCHAR(100) NOT NULL,
	[ItemTypeID] INT FOREIGN KEY REFERENCES ItemTypes(ItemTypeID)
)


CREATE TABLE OrderItems(
	[OrderID] INT FOREIGN KEY REFERENCES Orders(OrderID),
	[ItemID] INT FOREIGN KEY REFERENCES Items(ItemID),
	PRIMARY KEY(OrderID, ItemID)
)