create database MovieBooking;
use MovieBooking;

-- 1. Theater Table
CREATE TABLE Theater (
    TheaterID INT PRIMARY KEY,
    TheaterName VARCHAR(100),
    Location VARCHAR(100),
    Phone VARCHAR(20)
);

-- 2. Screen Table
CREATE TABLE Screen (
    ScreenID INT PRIMARY KEY,
    ScreenName VARCHAR(100),
    TheaterID INT FOREIGN KEY REFERENCES Theater(TheaterID),
    TotalSeats INT
);

-- 3. Genre Table
CREATE TABLE Genre (
    GenreID INT PRIMARY KEY,
    GenreName VARCHAR(100)
);

-- 4. Movie Table
CREATE TABLE Movie (
    MovieID INT PRIMARY KEY,
    MovieName VARCHAR(100),
    Duration VARCHAR(50),
    GenreID INT FOREIGN KEY REFERENCES Genre(GenreID)
);

-- 5. Shows Table
CREATE TABLE Shows (
    ShowsID INT PRIMARY KEY,
    MovieID INT FOREIGN KEY REFERENCES Movie(MovieID),
    ScreenID INT FOREIGN KEY REFERENCES Screen(ScreenID),
    ShowDate DATE,
    ShowTime TIME
);

-- 6. SeatType Table
CREATE TABLE SeatType (
    SeatTypeID INT PRIMARY KEY,
    SeatName VARCHAR(50)
);

-- 7. Seats Table
CREATE TABLE Seats (
    SeatID INT PRIMARY KEY,
    SeatName VARCHAR(10),
    ScreenID INT FOREIGN KEY REFERENCES Screen(ScreenID),
    TotalSeats INT,
    SeatTypeID INT FOREIGN KEY REFERENCES SeatType(SeatTypeID),
    Status VARCHAR(20)
);

-- 8. SeatPrice Table
CREATE TABLE SeatPrice (
    SeatPriceID INT PRIMARY KEY,
    SeatTypeID INT FOREIGN KEY REFERENCES SeatType(SeatTypeID),
    ScreenID INT FOREIGN KEY REFERENCES Screen(ScreenID),
    Price INT
);

-- 9. Customer Table
CREATE TABLE Customer (
    CustomerID INT PRIMARY KEY,
    CustomerName VARCHAR(100),
    Email VARCHAR(100),
    Phone VARCHAR(20),
    Address VARCHAR(255)
);

-- 10. Bookings Table
CREATE TABLE Bookings (
    BookingID INT PRIMARY KEY,
    CustomerID INT FOREIGN KEY REFERENCES Customer(CustomerID),
    ShowID INT FOREIGN KEY REFERENCES Shows(ShowsID),
    BookingDate DATE,
    BookingTime TIME,
    TotalSeatBooked INT,
    TotalAmount INT
);

-- 11. BookedSeats Table
CREATE TABLE BookedSeats (
    BookedSeatID INT PRIMARY KEY,
    BookingID INT FOREIGN KEY REFERENCES Bookings(BookingID),
    SeatID INT FOREIGN KEY REFERENCES Seats(SeatID)
);

-- 12. PaymentType Table
CREATE TABLE PaymentType (
    PaymentTypeID INT PRIMARY KEY,
    PaymentName VARCHAR(50)
);

-- 13. Payment Table
CREATE TABLE Payment (
    PaymentID INT PRIMARY KEY,
    CustomerID INT FOREIGN KEY REFERENCES Customer(CustomerID),
    PaymentTypeID INT FOREIGN KEY REFERENCES PaymentType(PaymentTypeID),
    BookingID INT FOREIGN KEY REFERENCES Bookings(BookingID),
    AmountPaid DECIMAL(10,2)
);


-- Theater
INSERT INTO Theater VALUES (1, 'PVR Cinemas', 'Chennai', '044-9998887');

-- Screen
INSERT INTO Screen VALUES (1, 'Screen 1', 1, 100),
                          (2, 'Screen 2', 1, 120);

-- Genre
INSERT INTO Genre VALUES (1, 'Action'), (2, 'Comedy');

-- Movies
INSERT INTO Movie VALUES (1, 'Leo', '2hr 30min', 1),
                         (2, 'Jawan', '2hr 45min', 2);

-- Shows
INSERT INTO Shows VALUES (1, 1, 1, '2025-06-15', '18:00:00'),
                         (2, 2, 2, '2025-06-15', '21:00:00');

-- SeatType
INSERT INTO SeatType VALUES (1, 'Regular'), (2, 'Premium');

-- Seats
INSERT INTO Seats VALUES 
(101, 'A1', 1, 100, 1, 'Available'),
(102, 'A2', 1, 100, 1, 'Available'),
(103, 'B1', 2, 120, 2, 'Available');

-- SeatPrice
INSERT INTO SeatPrice VALUES 
(1, 1, 1, 150),
(2, 2, 2, 250);

-- Customer
INSERT INTO Customer VALUES 
(1, 'Ajay Kumar', 'ajay@gmail.com', '9876543210', 'Chennai'),
(2, 'Divya S', 'divya@gmail.com', '9998887777', 'Coimbatore');

-- Bookings
INSERT INTO Bookings VALUES 
(201, 1, 1, '2025-06-14', '10:00:00', 2, 300),
(202, 2, 2, '2025-06-14', '12:00:00', 1, 250);

-- Booked Seats
INSERT INTO BookedSeats VALUES 
(1, 201, 101),
(2, 201, 102),
(3, 202, 103);

-- PaymentType
INSERT INTO PaymentType VALUES (1, 'Card'), (2, 'UPI');

-- Payments
INSERT INTO Payment VALUES 
(301, 1, 1, 201, 300),
(302, 2, 2, 202, 250);


SELECT * FROM Theater;
SELECT * FROM Screen;
SELECT * FROM Genre;
SELECT * FROM Movie;
SELECT * FROM Shows;
SELECT * FROM SeatType;
SELECT * FROM Seats;
SELECT * FROM SeatPrice;
SELECT * FROM Customer;
SELECT * FROM Bookings;
SELECT * FROM BookedSeats;
SELECT * FROM PaymentType;
SELECT * FROM Payment;


--Joins & Real-Time Queries
--1. . Display CustomerName, MovieName, TheaterName, ShowTime, and TotalSeatBooked for all bookings.
select c.CustomerName, m.MovieName, t.TheaterID, sh.ShowTime, b.TotalSeatBooked
from Bookings b
inner join Shows sh on b.ShowID = sh.ShowsID
inner join Customer c on c.CustomerID = b.CustomerID
inner join Movie m on sh.MovieID = m.MovieID
inner join Screen sc on sh.ScreenID = sc.ScreenID
inner join Theater t on t.TheaterID = sc.TheaterID;

--2. List customers who booked for a movie titled “Leo”.
select c.CustomerName from Bookings b
inner join Customer c on b.CustomerID = c.CustomerID
inner join Shows sh on b.ShowID = sh.ShowsID
inner join Movie m on sh.MovieID = m.MovieID
where m.MovieName = 'Leo';

--3. Show all movies that are playing in more than 2 different theatres.
select m.MovieName from Movie m
inner join Shows sh on m.MovieID = sh.MovieID
inner join Screen sc on sh.ScreenID = sc.ScreenID
inner join Theater t on sc.TheaterID = t.TheaterID
group by m.MovieName
having Count(*) > 2;

--4. Write a query to find shows where total seats booked > 100.
select s.ShowsID , SUM(b.TotalSeatBooked) as SeatsBooked from Bookings b
inner join Shows s on  b.ShowID = s.ShowsID
group by s.ShowsID 
having sum(b.TotalSeatBooked) > 100;
