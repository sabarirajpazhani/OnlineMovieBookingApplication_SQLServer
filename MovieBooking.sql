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

create table PaymentStatus(
	PaymentStatusID int identity(201,1) primary key,
	PaymentID int,
	Status varchar(50),
	foreign key (PaymentID ) references Payment(PaymentID)
);


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
SELECT * FROM PaymentStatus

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

--5.  List bookings made on screens having more than 120 total seats.
select sc.ScreenName from Bookings b
inner join Shows sh on b.ShowID = sh.ShowsID
inner join Screen sc on sh.ScreenID = sc.ScreenID
where sc.TotalSeats > 120;

--Aggregation & Grouping
--6. Display the total number of bookings per movie.
select m.MovieName , Count(*) as NumberOfBookings from Bookings b
inner join Shows sh on b.ShowID = sh.ShowsID
inner join Movie m on sh.MovieID = m.MovieID
group by m.MovieName

--7. Find the total revenue generated per movie.
select m.MovieName , sum(b.TotalAmount) as Revenue from Bookings b
inner join Shows sh on b.ShowID = sh.ShowsID
inner join Movie m on sh.MovieID = m.MovieID
group by m.MovieName;

--8. Display the average number of seats booked per show.
select sh.ShowsID , avg(b.TotalSeatBooked) from Bookings b
inner join Shows sh on b.ShowID = sh.ShowsID
group by sh.ShowsID;

--9. List users who have never booked any ticket.
insert into Customer values
(3,'Raj','Raj@gmail.com','9987875678','Cuddalore')

select c.CustomerName from Customer c
where c.CustomerID  not in (Select c.CustomerID from Bookings b);

--10. Find the most booked movie overall.
 select top 1 m.MovieName, Sum(b.TotalSeatBooked) as TotalSeats from Bookings b
 inner join Shows sh on b.ShowID = sh.ShowsID
 inner join Movie m on sh.MovieID = m.MovieID
 group by m.MovieName
 order by TotalSeats desc;

 --11. Show the customer who made the highest total payment.
 select top 1 c.CustomerName , Sum (b.TotalAmount) as Payment from Bookings b
 inner join Customer c on b.CustomerID = c.CustomerID
 group by c.CustomerName
 order by Payment desc;

 --Views, Functions, Procedures
 --12. Create a view vw_ShowBookingDetails with:
--BookingID, CustomerName, MovieName, TheatreName, ShowDate, ShowTime, TotalAmount.
create view vw_ShowBookingDetails
as
	select b.BookingID, c.CustomerName, m.MovieName, t.TheaterName, sh.ShowDate, sh.ShowTime, b.TotalAmount from Bookings b
	inner join Customer c on b.CustomerID = c.CustomerID
	inner join Shows sh on b.ShowID = sh.ShowsID
	inner join Movie m on sh.MovieID = m.MovieID
	inner join Screen sc on sh.ScreenID = sc.ScreenID
	inner join Theater t on sc.TheaterID = t.TheaterID

select * from vw_ShowBookingDetails;

-- 13. Write a scalar function that accepts @MovieID and returns the total tickets booked for that movie.
alter function GetTotalTicketsBooked(
	@MovieID int
)
returns int
as
begin
	declare @TotalTicketsBooked int
	select @TotalTicketsBooked = sum(b.TotalSeatBooked) from Bookings b
	inner join Shows sh on b.ShowID = sh.ShowsID
	where sh.MovieID = @MovieID

	return @TotalTicketsBooked
end;

select dbo.GetTotalTicketsBooked (1);

--14. Write a stored procedure sp_BookTickets to insert a new booking with: @CustomerID, @ShowID, @TotalSeatBooked, @TotalAmount
alter procedure sp_BookTickets
	@CustomerID int,
	@ShowID int,
	@SeatID int,
	@TotalSeatBooked int,
	@TotalAmount decimal(10,2)
as
begin
	if exists (
		select 1 from BookedSeats bs
		inner join Bookings b on bs.BookingID = b.BookingID
		where bs.SeatID = @SeatID and b.ShowID = @ShowID
	)
	begin 
		print 'Already Seat booked'
		return
	end

	declare @BookingID int 
	select @BookingID = Max(BookingID)+1 from Bookings
	insert into Bookings values
	(@BookingID, @CustomerID, @ShowID, cast(getdate() as date),cast(getdate() as time), @TotalSeatBooked, @TotalAmount)

	declare @BookedSeatID int
	select @BookedSeatID = max(BookedSeatID) from BookedSeats

	insert into BookedSeats values
	(@BookedSeatID, @BookingID, @SeatID)

	print 'Booked Successfully'
end
 
exec sp_BookTickets  1, 1, 101, 2, 300; 

--15. Write a procedure to return all shows for a theatre (@TheaterID) on today's date.
alter procedure sp_AllShows
	@TheaterID int
as
begin
	select sh.ShowsID, m.MovieName, sh.ShowDate,sh.ShowTime from Shows sh
	inner join Screen sc on sh.ScreenID = sc.ScreenID
	inner join Movie m on sh.MovieID = m.MovieID
	where sc.TheaterID = @TheaterID and sh.ShowDate = cast(getdate() as date)

end;

exec sp_AllShows 1;

--Triggers & Exception Logic
--16.  Write a trigger to prevent booking if the requested number of seats exceeds the screen’s total capacity.
alter trigger tr_PreventBooking
on Bookings
instead of insert
as
begin
	if exists(
		select 1 from inserted i
		inner join Shows s on i.ShowID = s.ShowsID
		inner join Screen sc on s.ScreenID = sc.ScreenID
		where i.TotalSeatBooked > sc.TotalSeats
	)
	begin
		raiserror('Cannot book more seats than screen capacity',16,1)
		rollback
		return
	end
	else
	begin
		insert into Bookings
		select * from inserted

		declare @BookedSeatID int 
		declare @BookingID int, @SeatID int
		select @BookingID = i.BookingID, @SeatID = s.SeatID from inserted i
		inner join Shows sh on i.ShowID = sh.ShowsID
		inner join Screen sc on sh.ScreenID = sc.ScreenID
		inner join Seats s on sc.ScreenID = s.ScreenID

		select @BookedSeatID = max(BookedSeatID)+1 from BookedSeats 
		insert into BookedSeats values (@BookedSeatID , @BookingID, @SeatID)

	end
end

insert into Bookings values
(203, 3, 1,cast(getdate() as date),cast(getdate() as time),3, 390)

--17. Write a trigger that auto-updates payment status to 'Confirmed' when a payment is made.
create trigger tr_PaymentStatus
on PaymentStatus
after insert
as
begin
	begin try
		declare @PaymentID int 
		select @PaymentID = @PaymentID from inserted
		insert into PaymentStatus values (@PaymentID, 'Success')
	end try
	begin catch
		insert into PaymentStatus values (@PaymentID, 'Fail')
	end catch
end;


--UDDT, Index, Unique Rules
--18. Create a user-defined data type PhoneType as VARCHAR(15) and use it in the Customers table.
create type PhoneType from varchar(15)

--19. Create a non-clustered index on MovieName in the Movies table, include LanguageID.
create nonclustered index ix_MovieName on Movie (MovieName) include(LanguageID);
