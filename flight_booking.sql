-- =====================================================
-- Flight Booking Management System
-- Complete MySQL Script (Schema + Data + Queries)
-- Compatible with MySQL Workbench
-- =====================================================

-- Create and use database
DROP DATABASE IF EXISTS flight_booking;
CREATE DATABASE flight_booking;
USE flight_booking;

-- -----------------------------------------------------
-- TABLE: Airlines
-- -----------------------------------------------------
CREATE TABLE Airlines (
    airline_id      INT AUTO_INCREMENT PRIMARY KEY,
    airline_name    VARCHAR(100) NOT NULL UNIQUE,
    country         VARCHAR(50)  NOT NULL,
    iata_code       VARCHAR(10)  UNIQUE
);

-- -----------------------------------------------------
-- TABLE: Flights
-- -----------------------------------------------------
CREATE TABLE Flights (
    flight_id       INT AUTO_INCREMENT PRIMARY KEY,
    flight_number   VARCHAR(20)  NOT NULL UNIQUE,
    airline_id      INT          NOT NULL,
    departure_city  VARCHAR(50)  NOT NULL,
    arrival_city    VARCHAR(50)  NOT NULL,
    departure_time  DATETIME     NOT NULL,
    arrival_time    DATETIME     NOT NULL,
    capacity        INT          NOT NULL CHECK (capacity > 0),
    base_price      DECIMAL(10,2) NOT NULL CHECK (base_price > 0),
    FOREIGN KEY (airline_id) REFERENCES Airlines(airline_id)
);

-- -----------------------------------------------------
-- TABLE: Passengers
-- -----------------------------------------------------
CREATE TABLE Passengers (
    passenger_id    INT AUTO_INCREMENT PRIMARY KEY,
    first_name      VARCHAR(50)  NOT NULL,
    last_name       VARCHAR(50)  NOT NULL,
    email           VARCHAR(100) UNIQUE,
    phone           VARCHAR(20),
    date_of_birth   DATE
);

-- -----------------------------------------------------
-- TABLE: Bookings
-- -----------------------------------------------------
CREATE TABLE Bookings (
    booking_id      INT AUTO_INCREMENT PRIMARY KEY,
    passenger_id    INT          NOT NULL,
    flight_id       INT          NOT NULL,
    booking_date    DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    seat_number     VARCHAR(10),
    status          ENUM('Confirmed', 'Cancelled', 'Pending', 'Completed') 
                    NOT NULL DEFAULT 'Confirmed',
    total_amount    DECIMAL(10,2),
    FOREIGN KEY (passenger_id) REFERENCES Passengers(passenger_id),
    FOREIGN KEY (flight_id)    REFERENCES Flights(flight_id)
);

-- =====================================================
-- SAMPLE DATA
-- =====================================================

INSERT INTO Airlines (airline_id, airline_name, country, iata_code) VALUES
(1, 'Air India',          'India',        'AI'),
(2, 'IndiGo',             'India',        '6E'),
(3, 'Emirates',           'UAE',          'EK'),
(4, 'Qatar Airways',      'Qatar',        'QR'),
(5, 'Singapore Airlines', 'Singapore',    'SQ'),
(6, 'Lufthansa',          'Germany',      'LH');

INSERT INTO Flights (flight_id, flight_number, airline_id, departure_city, arrival_city, departure_time, arrival_time, capacity, base_price) VALUES
(1,  'AI101', 1, 'Delhi',       'Mumbai',      '2026-11-05 08:30:00', '2026-11-05 10:45:00', 180, 4500.00),
(2,  'AI202', 1, 'Mumbai',      'Bangalore',   '2026-11-05 14:00:00', '2026-11-05 15:50:00', 160, 3800.00),
(3,  '6E301', 2, 'Delhi',       'Hyderabad',   '2026-11-06 06:15:00', '2026-11-06 08:20:00', 186, 3200.00),
(4,  '6E405', 2, 'Bangalore',   'Chennai',     '2026-11-06 11:00:00', '2026-11-06 12:10:00', 186, 2800.00),
(5,  'EK501', 3, 'Dubai',       'Delhi',       '2026-11-07 03:45:00', '2026-11-07 09:00:00', 350, 18500.00),
(6,  'EK512', 3, 'Dubai',       'Mumbai',      '2026-11-07 10:30:00', '2026-11-07 15:00:00', 350, 17200.00),
(7,  'QR701', 4, 'Doha',        'Delhi',       '2026-11-08 01:20:00', '2026-11-08 07:45:00', 300, 19500.00),
(8,  'SQ801', 5, 'Singapore',   'Delhi',       '2026-11-08 23:55:00', '2026-11-09 03:30:00', 280, 22000.00),
(9,  'LH901', 6, 'Frankfurt',   'Mumbai',      '2026-11-09 13:00:00', '2026-11-10 01:30:00', 250, 28500.00),
(10, 'AI303', 1, 'Kolkata',     'Delhi',       '2026-11-10 07:00:00', '2026-11-10 09:15:00', 170, 4100.00),
(11, '6E512', 2, 'Hyderabad',   'Mumbai',      '2026-11-10 16:45:00', '2026-11-10 18:30:00', 186, 3500.00),
(12, 'AI404', 1, 'Delhi',       'Goa',         '2026-11-11 09:30:00', '2026-11-11 12:00:00', 150, 5200.00),
(13, '6E620', 2, 'Chennai',     'Delhi',       '2026-11-11 18:00:00', '2026-11-11 20:45:00', 186, 3900.00),
(14, 'EK603', 3, 'Dubai',       'Bangalore',   '2026-11-12 02:15:00', '2026-11-12 07:40:00', 350, 16800.00),
(15, 'QR812', 4, 'Doha',        'Mumbai',      '2026-11-12 22:00:00', '2026-11-13 04:30:00', 300, 18900.00);

INSERT INTO Passengers (passenger_id, first_name, last_name, email, phone, date_of_birth) VALUES
(1,  'Rahul',    'Sharma',     'rahul.sharma@email.com',    '+91-9876543210', '1990-05-12'),
(2,  'Priya',    'Patel',      'priya.patel@email.com',     '+91-9123456780', '1988-11-23'),
(3,  'Amit',     'Kumar',      'amit.kumar@email.com',      '+91-9988776655', '1995-03-08'),
(4,  'Sneha',    'Reddy',      'sneha.reddy@email.com',     '+91-9876501234', '1992-07-19'),
(5,  'Vikram',   'Singh',      'vikram.singh@email.com',    '+91-9765432109', '1985-01-30'),
(6,  'Ananya',   'Iyer',       'ananya.iyer@email.com',     '+91-9654321098', '1998-09-14'),
(7,  'Rohan',    'Mehta',      'rohan.mehta@email.com',     '+91-9543210987', '1991-12-05'),
(8,  'Neha',     'Gupta',      'neha.gupta@email.com',      '+91-9432109876', '1993-04-22'),
(9,  'Arjun',    'Nair',       'arjun.nair@email.com',      '+91-9321098765', '1987-08-17'),
(10, 'Kavya',    'Joshi',      'kavya.joshi@email.com',     '+91-9210987654', '1996-06-28'),
(11, 'Siddharth','Malhotra',   'sid.malhotra@email.com',    '+91-9109876543', '1989-02-11'),
(12, 'Meera',    'Desai',      'meera.desai@email.com',     '+91-9098765432', '1994-10-03');

INSERT INTO Bookings (booking_id, passenger_id, flight_id, booking_date, seat_number, status, total_amount) VALUES
(1,  1,  1,  '2026-10-15 10:22:00', '12A', 'Confirmed', 4500.00),
(2,  2,  1,  '2026-10-16 14:05:00', '14C', 'Confirmed', 4500.00),
(3,  3,  1,  '2026-10-17 09:30:00', '08B', 'Confirmed', 4800.00),
(4,  4,  3,  '2026-10-18 11:45:00', '21F', 'Confirmed', 3200.00),
(5,  5,  3,  '2026-10-18 16:20:00', '22A', 'Confirmed', 3200.00),
(6,  1,  5,  '2026-10-19 08:10:00', '45K', 'Confirmed', 18500.00),
(7,  6,  5,  '2026-10-20 13:55:00', '32C', 'Confirmed', 19200.00),
(8,  7,  2,  '2026-10-20 17:40:00', '10D', 'Confirmed', 3800.00),
(9,  8,  6,  '2026-10-21 09:15:00', '18A', 'Confirmed', 17200.00),
(10, 9,  7,  '2026-10-21 20:00:00', '27B', 'Confirmed', 19500.00),
(11, 2,  3,  '2026-10-22 11:30:00', '15E', 'Confirmed', 3500.00),
(12, 10, 1,  '2026-10-22 15:45:00', '19A', 'Confirmed', 4500.00),
(13, 3,  8,  '2026-10-23 07:20:00', '41J', 'Confirmed', 22000.00),
(14, 11, 5,  '2026-10-23 12:10:00', '28F', 'Confirmed', 18500.00),
(15, 4,  2,  '2026-10-23 18:30:00', '07C', 'Confirmed', 3800.00),
(16, 12, 3,  '2026-10-24 09:00:00', '23D', 'Confirmed', 3200.00),
(17, 5,  1,  '2026-10-24 10:15:00', '11B', 'Pending',   4500.00),
(18, 6,  6,  '2026-10-24 11:40:00', '15A', 'Confirmed', 17200.00),
(19, 7,  5,  '2026-10-24 14:25:00', '33C', 'Confirmed', 18500.00),
(20, 8,  1,  '2026-10-24 16:50:00', '16F', 'Confirmed', 4700.00);

-- =====================================================
-- REQUIRED TEST QUERIES (from the image)
-- =====================================================

-- 1. Retrieve all flights with their departure and arrival cities, along with departure times.
SELECT 
    f.flight_number,
    a.airline_name,
    f.departure_city,
    f.arrival_city,
    f.departure_time
FROM Flights f
JOIN Airlines a ON f.airline_id = a.airline_id
ORDER BY f.departure_time;


-- 2. Count the total number of flights for each airline.
SELECT 
    a.airline_name,
    a.iata_code,
    COUNT(f.flight_id) AS total_flights
FROM Airlines a
LEFT JOIN Flights f ON a.airline_id = f.airline_id
GROUP BY a.airline_id, a.airline_name, a.iata_code
ORDER BY total_flights DESC;


-- 3. List all bookings with passenger names and flight details.
SELECT 
    b.booking_id,
    CONCAT(p.first_name, ' ', p.last_name) AS passenger_name,
    f.flight_number,
    a.airline_name,
    CONCAT(f.departure_city, ' → ', f.arrival_city) AS route,
    f.departure_time,
    b.seat_number,
    b.status,
    b.total_amount
FROM Bookings b
JOIN Passengers p ON b.passenger_id = p.passenger_id
JOIN Flights f    ON b.flight_id = f.flight_id
JOIN Airlines a   ON f.airline_id = a.airline_id
ORDER BY b.booking_date DESC;


-- 4. Find flights that have no bookings.
SELECT 
    f.flight_number,
    a.airline_name,
    f.departure_city,
    f.arrival_city,
    f.departure_time
FROM Flights f
JOIN Airlines a ON f.airline_id = a.airline_id
LEFT JOIN Bookings b ON f.flight_id = b.flight_id
WHERE b.booking_id IS NULL
ORDER BY f.departure_time;


-- 5. Display the top 3 most frequently booked flights, including the number of bookings.
SELECT 
    f.flight_number,
    a.airline_name,
    CONCAT(f.departure_city, ' → ', f.arrival_city) AS route,
    COUNT(b.booking_id) AS number_of_bookings
FROM Flights f
JOIN Airlines a ON f.airline_id = a.airline_id
JOIN Bookings b ON f.flight_id = b.flight_id
GROUP BY f.flight_id, f.flight_number, a.airline_name, f.departure_city, f.arrival_city
ORDER BY number_of_bookings DESC
LIMIT 3;


-- =====================================================
-- ADDITIONAL USEFUL QUERIES
-- =====================================================

-- 6. Average booking amount and total bookings per airline
SELECT 
    a.airline_name,
    ROUND(AVG(b.total_amount), 2) AS avg_booking_amount,
    COUNT(b.booking_id) AS total_bookings
FROM Airlines a
JOIN Flights f ON a.airline_id = f.airline_id
JOIN Bookings b ON f.flight_id = b.flight_id
GROUP BY a.airline_id, a.airline_name
ORDER BY avg_booking_amount DESC;


-- 7. Passengers who have booked more than one flight
SELECT 
    CONCAT(p.first_name, ' ', p.last_name) AS passenger_name,
    p.email,
    COUNT(b.booking_id) AS flights_booked
FROM Passengers p
JOIN Bookings b ON p.passenger_id = b.passenger_id
GROUP BY p.passenger_id, p.first_name, p.last_name, p.email
HAVING COUNT(b.booking_id) > 1
ORDER BY flights_booked DESC;


-- 8. Flights departing from Delhi with seat availability
SELECT 
    f.flight_number,
    a.airline_name,
    f.departure_time,
    f.capacity,
    COUNT(b.booking_id) AS seats_booked,
    f.capacity - COUNT(b.booking_id) AS seats_available
FROM Flights f
JOIN Airlines a ON f.airline_id = a.airline_id
LEFT JOIN Bookings b ON f.flight_id = b.flight_id AND b.status != 'Cancelled'
WHERE f.departure_city = 'Delhi'
GROUP BY f.flight_id, f.flight_number, a.airline_name, f.departure_time, f.capacity
ORDER BY f.departure_time;


-- 9. Revenue generated by each flight
SELECT 
    f.flight_number,
    a.airline_name,
    CONCAT(f.departure_city, ' → ', f.arrival_city) AS route,
    COUNT(b.booking_id) AS bookings,
    ROUND(SUM(COALESCE(b.total_amount, 0)), 2) AS total_revenue
FROM Flights f
JOIN Airlines a ON f.airline_id = a.airline_id
LEFT JOIN Bookings b ON f.flight_id = b.flight_id AND b.status = 'Confirmed'
GROUP BY f.flight_id, f.flight_number, a.airline_name, f.departure_city, f.arrival_city
ORDER BY total_revenue DESC;


-- 10. Passengers flying between 5 Nov and 8 Nov 2026
SELECT 
    CONCAT(p.first_name, ' ', p.last_name) AS passenger_name,
    f.flight_number,
    CONCAT(f.departure_city, ' → ', f.arrival_city) AS route,
    f.departure_time,
    b.seat_number
FROM Bookings b
JOIN Passengers p ON b.passenger_id = p.passenger_id
JOIN Flights f ON b.flight_id = f.flight_id
WHERE f.departure_time BETWEEN '2026-11-05 00:00:00' AND '2026-11-08 23:59:59'
ORDER BY f.departure_time;


-- 11. Most popular routes (by number of bookings)
SELECT 
    CONCAT(f.departure_city, ' → ', f.arrival_city) AS route,
    COUNT(b.booking_id) AS total_bookings
FROM Flights f
JOIN Bookings b ON f.flight_id = b.flight_id
GROUP BY f.departure_city, f.arrival_city
ORDER BY total_bookings DESC;


-- 12. Bookings by status
SELECT 
    status,
    COUNT(*) AS count,
    ROUND(SUM(total_amount), 2) AS total_amount
FROM Bookings
GROUP BY status
ORDER BY count DESC;
