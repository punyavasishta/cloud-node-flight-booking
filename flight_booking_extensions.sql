-- =====================================================
-- ADDITIVE EXTENSIONS ONLY
-- Do not modify any previous tables or existing rows.
-- Run AFTER the base flight_booking.sql script.
-- =====================================================
-- Adds:
--   1. FlightSchedules (daily / recurring templates)
--   2. Daily flight instances so any selected date has flights
--   3. Payments (payment gateway records)
--   4. BookingDetails (contact + extra passenger details at booking time)
-- =====================================================

USE flight_booking;

-- -----------------------------------------------------
-- TABLE: FlightSchedules (templates for daily operation)
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS FlightSchedules (
    schedule_id     INT AUTO_INCREMENT PRIMARY KEY,
    flight_number   VARCHAR(20)  NOT NULL,          -- base number e.g. AI101
    airline_id      INT          NOT NULL,
    departure_city  VARCHAR(50)  NOT NULL,
    arrival_city    VARCHAR(50)  NOT NULL,
    dep_time        TIME         NOT NULL,          -- daily departure time
    arr_time        TIME         NOT NULL,          -- arrival time (may be next day)
    duration_mins   INT          NOT NULL,
    capacity        INT          NOT NULL CHECK (capacity > 0),
    base_price      DECIMAL(10,2) NOT NULL CHECK (base_price > 0),
    days_of_week    VARCHAR(20)  NOT NULL DEFAULT '1234567', -- 1=Mon ... 7=Sun
    is_active       TINYINT(1)   NOT NULL DEFAULT 1,
    FOREIGN KEY (airline_id) REFERENCES Airlines(airline_id)
);

-- -----------------------------------------------------
-- TABLE: Payments (payment gateway)
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS Payments (
    payment_id      INT AUTO_INCREMENT PRIMARY KEY,
    booking_id      INT          NOT NULL,
    amount          DECIMAL(10,2) NOT NULL CHECK (amount > 0),
    currency        VARCHAR(3)   NOT NULL DEFAULT 'INR',
    payment_method  ENUM('Card','UPI','NetBanking','Wallet','Cash') NOT NULL,
    card_last4      VARCHAR(4),
    upi_id          VARCHAR(100),
    transaction_ref VARCHAR(64)  NOT NULL UNIQUE,
    gateway         VARCHAR(50)  NOT NULL DEFAULT 'CloudNodePay',
    status          ENUM('Pending','Success','Failed','Refunded') NOT NULL DEFAULT 'Pending',
    paid_at         DATETIME,
    created_at      DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (booking_id) REFERENCES Bookings(booking_id)
);

-- -----------------------------------------------------
-- TABLE: BookingDetails (extra fields filled at booking)
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS BookingDetails (
    detail_id       INT AUTO_INCREMENT PRIMARY KEY,
    booking_id      INT          NOT NULL UNIQUE,
    contact_name    VARCHAR(100) NOT NULL,
    contact_email   VARCHAR(100) NOT NULL,
    contact_phone   VARCHAR(20),
    passport_number VARCHAR(30),
    nationality     VARCHAR(50),
    special_requests VARCHAR(255),
    billing_address VARCHAR(255),
    created_at      DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (booking_id) REFERENCES Bookings(booking_id)
);

-- =====================================================
-- SEED: Flight schedules (daily templates matching front-end cities)
-- =====================================================
INSERT INTO FlightSchedules
(flight_number, airline_id, departure_city, arrival_city, dep_time, arr_time, duration_mins, capacity, base_price, days_of_week)
VALUES
-- Domestic India (daily)
('AI101', 1, 'Delhi',     'Mumbai',    '08:30:00', '10:45:00', 135, 180,  4500.00, '1234567'),
('AI102', 1, 'Mumbai',    'Delhi',     '18:00:00', '20:15:00', 135, 180,  4500.00, '1234567'),
('AI202', 1, 'Mumbai',    'Bangalore', '14:00:00', '15:50:00', 110, 160,  3800.00, '1234567'),
('AI203', 1, 'Bangalore', 'Mumbai',    '07:30:00', '09:20:00', 110, 160,  3800.00, '1234567'),
('AI303', 1, 'Kolkata',   'Delhi',     '07:00:00', '09:15:00', 135, 170,  4100.00, '1234567'),
('AI304', 1, 'Delhi',     'Kolkata',   '16:30:00', '18:45:00', 135, 170,  4100.00, '1234567'),
('AI404', 1, 'Delhi',     'Goa',       '09:30:00', '12:00:00', 150, 150,  5200.00, '1234567'),
('AI405', 1, 'Goa',       'Delhi',     '13:30:00', '16:00:00', 150, 150,  5200.00, '1234567'),
('6E301', 2, 'Delhi',     'Hyderabad', '06:15:00', '08:20:00', 125, 186,  3200.00, '1234567'),
('6E302', 2, 'Hyderabad', 'Delhi',     '19:00:00', '21:05:00', 125, 186,  3200.00, '1234567'),
('6E405', 2, 'Bangalore', 'Chennai',   '11:00:00', '12:10:00',  70, 186,  2800.00, '1234567'),
('6E406', 2, 'Chennai',   'Bangalore', '13:30:00', '14:40:00',  70, 186,  2800.00, '1234567'),
('6E512', 2, 'Hyderabad', 'Mumbai',    '16:45:00', '18:30:00', 105, 186,  3500.00, '1234567'),
('6E513', 2, 'Mumbai',    'Hyderabad', '09:00:00', '10:45:00', 105, 186,  3500.00, '1234567'),
('6E620', 2, 'Chennai',   'Delhi',     '18:00:00', '20:45:00', 165, 186,  3900.00, '1234567'),
('6E621', 2, 'Delhi',     'Chennai',   '06:00:00', '08:45:00', 165, 186,  3900.00, '1234567'),
('6E701', 2, 'Delhi',     'Goa',       '10:00:00', '12:30:00', 150, 186,  4800.00, '1234567'),
('6E702', 2, 'Goa',       'Delhi',     '14:00:00', '16:30:00', 150, 186,  4800.00, '1234567'),
('6E801', 2, 'Mumbai',    'Goa',       '07:45:00', '09:00:00',  75, 186,  3100.00, '1234567'),
('6E802', 2, 'Goa',       'Mumbai',    '17:30:00', '18:45:00',  75, 186,  3100.00, '1234567'),
-- International (daily / near-daily)
('EK501', 3, 'Dubai',     'Delhi',     '03:45:00', '09:00:00', 315, 350, 18500.00, '1234567'),
('EK502', 3, 'Delhi',     'Dubai',     '22:00:00', '00:30:00', 210, 350, 18500.00, '1234567'),
('EK512', 3, 'Dubai',     'Mumbai',    '10:30:00', '15:00:00', 270, 350, 17200.00, '1234567'),
('EK513', 3, 'Mumbai',    'Dubai',     '18:30:00', '20:45:00', 195, 350, 17200.00, '1234567'),
('EK603', 3, 'Dubai',     'Bangalore', '02:15:00', '07:40:00', 325, 350, 16800.00, '1234567'),
('EK604', 3, 'Bangalore', 'Dubai',     '21:00:00', '23:30:00', 210, 350, 16800.00, '1234567'),
('QR701', 4, 'Doha',      'Delhi',     '01:20:00', '07:45:00', 385, 300, 19500.00, '1234567'),
('QR702', 4, 'Delhi',     'Doha',      '20:00:00', '22:30:00', 210, 300, 19500.00, '1234567'),
('QR812', 4, 'Doha',      'Mumbai',    '22:00:00', '04:30:00', 390, 300, 18900.00, '1234567'),
('QR813', 4, 'Mumbai',    'Doha',      '06:00:00', '08:15:00', 195, 300, 18900.00, '1234567'),
('SQ801', 5, 'Singapore', 'Delhi',     '23:55:00', '03:30:00', 335, 280, 22000.00, '1234567'),
('SQ802', 5, 'Delhi',     'Singapore', '11:00:00', '19:30:00', 330, 280, 22000.00, '1234567'),
('LH901', 6, 'Frankfurt', 'Mumbai',    '13:00:00', '01:30:00', 510, 250, 28500.00, '135'),
('LH902', 6, 'Mumbai',    'Frankfurt', '02:45:00', '08:00:00', 495, 250, 28500.00, '246');

-- =====================================================
-- GENERATE DAILY FLIGHT INSTANCES
-- Covers 2026-10-25 through 2026-12-31 so any date
-- chosen in the front-end date picker has matching flights.
-- flight_number is made unique: BASE-YYYYMMDD
-- =====================================================
-- Helper: we insert via a procedure so the script stays portable.

DELIMITER //
CREATE PROCEDURE IF NOT EXISTS sp_generate_daily_flights(
    IN p_start DATE,
    IN p_end   DATE
)
BEGIN
    DECLARE v_date DATE;
    DECLARE v_dow  CHAR(1);
    DECLARE done   INT DEFAULT 0;
    DECLARE s_id, s_airline, s_cap, s_dur INT;
    DECLARE s_fn, s_dep, s_arr VARCHAR(50);
    DECLARE s_dep_t, s_arr_t TIME;
    DECLARE s_price DECIMAL(10,2);
    DECLARE s_days VARCHAR(20);
    DECLARE v_dep_dt, v_arr_dt DATETIME;
    DECLARE v_fn VARCHAR(30);

    DECLARE cur CURSOR FOR
        SELECT schedule_id, flight_number, airline_id, departure_city, arrival_city,
               dep_time, arr_time, duration_mins, capacity, base_price, days_of_week
        FROM FlightSchedules WHERE is_active = 1;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

    SET v_date = p_start;
    WHILE v_date <= p_end DO
        -- MySQL DAYOFWEEK: 1=Sunday ... 7=Saturday → map to 7=Sun, 1=Mon ... 6=Sat
        SET v_dow = CASE DAYOFWEEK(v_date)
            WHEN 1 THEN '7'
            WHEN 2 THEN '1'
            WHEN 3 THEN '2'
            WHEN 4 THEN '3'
            WHEN 5 THEN '4'
            WHEN 6 THEN '5'
            WHEN 7 THEN '6'
        END;

        SET done = 0;
        OPEN cur;
        read_loop: LOOP
            FETCH cur INTO s_id, s_fn, s_airline, s_dep, s_arr, s_dep_t, s_arr_t, s_dur, s_cap, s_price, s_days;
            IF done = 1 THEN LEAVE read_loop; END IF;

            IF INSTR(s_days, v_dow) > 0 THEN
                SET v_dep_dt = TIMESTAMP(v_date, s_dep_t);
                -- arrival may cross midnight
                IF s_arr_t <= s_dep_t THEN
                    SET v_arr_dt = TIMESTAMP(DATE_ADD(v_date, INTERVAL 1 DAY), s_arr_t);
                ELSE
                    SET v_arr_dt = TIMESTAMP(v_date, s_arr_t);
                END IF;
                SET v_fn = CONCAT(s_fn, '-', DATE_FORMAT(v_date, '%Y%m%d'));

                -- only insert if this exact flight_number does not already exist
                IF NOT EXISTS (SELECT 1 FROM Flights WHERE flight_number = v_fn) THEN
                    INSERT INTO Flights
                        (flight_number, airline_id, departure_city, arrival_city,
                         departure_time, arrival_time, capacity, base_price)
                    VALUES
                        (v_fn, s_airline, s_dep, s_arr, v_dep_dt, v_arr_dt, s_cap, s_price);
                END IF;
            END IF;
        END LOOP;
        CLOSE cur;

        SET v_date = DATE_ADD(v_date, INTERVAL 1 DAY);
    END WHILE;
END //
DELIMITER ;

-- Generate daily flights from today-ish through end of year 2026
CALL sp_generate_daily_flights('2026-10-25', '2026-12-31');

-- Optional: keep the procedure for future re-runs; comment out DROP if you want to keep it
-- DROP PROCEDURE IF EXISTS sp_generate_daily_flights;

-- =====================================================
-- SAMPLE PAYMENTS for existing bookings (additive)
-- =====================================================
INSERT INTO Payments
(booking_id, amount, currency, payment_method, card_last4, upi_id, transaction_ref, gateway, status, paid_at)
VALUES
(1,  4500.00, 'INR', 'UPI',        NULL, 'rahul@upi',   'CNPAY-20261015-0001', 'CloudNodePay', 'Success', '2026-10-15 10:23:11'),
(2,  4500.00, 'INR', 'Card',       '4242', NULL,        'CNPAY-20261016-0002', 'CloudNodePay', 'Success', '2026-10-16 14:06:02'),
(3,  4800.00, 'INR', 'NetBanking', NULL, NULL,         'CNPAY-20261017-0003', 'CloudNodePay', 'Success', '2026-10-17 09:31:40'),
(4,  3200.00, 'INR', 'UPI',        NULL, 'sneha@oksbi', 'CNPAY-20261018-0004', 'CloudNodePay', 'Success', '2026-10-18 11:46:18'),
(5,  3200.00, 'INR', 'Card',       '1881', NULL,        'CNPAY-20261018-0005', 'CloudNodePay', 'Success', '2026-10-18 16:21:05'),
(6, 18500.00, 'INR', 'Card',       '9012', NULL,        'CNPAY-20261019-0006', 'CloudNodePay', 'Success', '2026-10-19 08:11:33'),
(7, 19200.00, 'INR', 'UPI',        NULL, 'ananya@paytm','CNPAY-20261020-0007', 'CloudNodePay', 'Success', '2026-10-20 13:56:22'),
(8,  3800.00, 'INR', 'Wallet',     NULL, NULL,         'CNPAY-20261020-0008', 'CloudNodePay', 'Success', '2026-10-20 17:41:09'),
(9, 17200.00, 'INR', 'Card',       '5555', NULL,        'CNPAY-20261021-0009', 'CloudNodePay', 'Success', '2026-10-21 09:16:44'),
(10,19500.00, 'INR', 'NetBanking', NULL, NULL,         'CNPAY-20261021-0010', 'CloudNodePay', 'Success', '2026-10-21 20:01:17'),
(11, 3500.00, 'INR', 'UPI',        NULL, 'priya@ybl',   'CNPAY-20261022-0011', 'CloudNodePay', 'Success', '2026-10-22 11:31:50'),
(12, 4500.00, 'INR', 'Card',       '1111', NULL,        'CNPAY-20261022-0012', 'CloudNodePay', 'Success', '2026-10-22 15:46:28'),
(13,22000.00, 'INR', 'Card',       '4444', NULL,        'CNPAY-20261023-0013', 'CloudNodePay', 'Success', '2026-10-23 07:21:03'),
(14,18500.00, 'INR', 'UPI',        NULL, 'sid@oksbi',   'CNPAY-20261023-0014', 'CloudNodePay', 'Success', '2026-10-23 12:11:41'),
(15, 3800.00, 'INR', 'Wallet',     NULL, NULL,         'CNPAY-20261023-0015', 'CloudNodePay', 'Success', '2026-10-23 18:31:19'),
(16, 3200.00, 'INR', 'UPI',        NULL, 'meera@upi',   'CNPAY-20261024-0016', 'CloudNodePay', 'Success', '2026-10-24 09:01:55'),
(17, 4500.00, 'INR', 'Card',       '7777', NULL,        'CNPAY-20261024-0017', 'CloudNodePay', 'Pending', NULL),
(18,17200.00, 'INR', 'Card',       '3333', NULL,        'CNPAY-20261024-0018', 'CloudNodePay', 'Success', '2026-10-24 11:41:08'),
(19,18500.00, 'INR', 'UPI',        NULL, 'rohan@paytm', 'CNPAY-20261024-0019', 'CloudNodePay', 'Success', '2026-10-24 14:26:37'),
(20, 4700.00, 'INR', 'NetBanking', NULL, NULL,         'CNPAY-20261024-0020', 'CloudNodePay', 'Success', '2026-10-24 16:51:12');

-- =====================================================
-- SAMPLE BOOKING DETAILS (contact / passport etc.)
-- =====================================================
INSERT INTO BookingDetails
(booking_id, contact_name, contact_email, contact_phone, passport_number, nationality, special_requests, billing_address)
VALUES
(1,  'Rahul Sharma',   'rahul.sharma@email.com',  '+91-9876543210', 'Z1234567', 'Indian',   NULL,                    '12 MG Road, Delhi'),
(2,  'Priya Patel',    'priya.patel@email.com',   '+91-9123456780', 'Z2345678', 'Indian',   'Window seat preferred',  '45 Linking Rd, Mumbai'),
(3,  'Amit Kumar',     'amit.kumar@email.com',    '+91-9988776655', 'Z3456789', 'Indian',   NULL,                    '78 Park Street, Kolkata'),
(4,  'Sneha Reddy',    'sneha.reddy@email.com',   '+91-9876501234', 'Z4567890', 'Indian',   'Vegetarian meal',        '22 Jubilee Hills, Hyderabad'),
(5,  'Vikram Singh',   'vikram.singh@email.com',  '+91-9765432109', 'Z5678901', 'Indian',   NULL,                    '9 Civil Lines, Delhi'),
(6,  'Rahul Sharma',   'rahul.sharma@email.com',  '+91-9876543210', 'Z1234567', 'Indian',   'Extra legroom',          '12 MG Road, Delhi'),
(7,  'Ananya Iyer',    'ananya.iyer@email.com',   '+91-9654321098', 'Z6789012', 'Indian',   NULL,                    '15 Anna Nagar, Chennai'),
(8,  'Rohan Mehta',    'rohan.mehta@email.com',   '+91-9543210987', 'Z7890123', 'Indian',   NULL,                    '33 SG Highway, Ahmedabad'),
(9,  'Neha Gupta',     'neha.gupta@email.com',    '+91-9432109876', 'Z8901234', 'Indian',   'Aisle seat',             '61 Connaught Place, Delhi'),
(10, 'Arjun Nair',     'arjun.nair@email.com',    '+91-9321098765', 'Z9012345', 'Indian',   NULL,                    '8 Marine Drive, Kochi'),
(11, 'Priya Patel',    'priya.patel@email.com',   '+91-9123456780', 'Z2345678', 'Indian',   NULL,                    '45 Linking Rd, Mumbai'),
(12, 'Kavya Joshi',    'kavya.joshi@email.com',   '+91-9210987654', 'Z0123456', 'Indian',   NULL,                    '19 FC Road, Pune'),
(13, 'Amit Kumar',     'amit.kumar@email.com',    '+91-9988776655', 'Z3456789', 'Indian',   'Wheelchair assistance',  '78 Park Street, Kolkata'),
(14, 'Siddharth Malhotra','sid.malhotra@email.com','+91-9109876543','Z1122334', 'Indian',   NULL,                    '4 Golf Course Rd, Gurgaon'),
(15, 'Sneha Reddy',    'sneha.reddy@email.com',   '+91-9876501234', 'Z4567890', 'Indian',   NULL,                    '22 Jubilee Hills, Hyderabad'),
(16, 'Meera Desai',    'meera.desai@email.com',   '+91-9098765432', 'Z2233445', 'Indian',   'Infant meal',            '27 CG Road, Ahmedabad'),
(17, 'Vikram Singh',   'vikram.singh@email.com',  '+91-9765432109', 'Z5678901', 'Indian',   NULL,                    '9 Civil Lines, Delhi'),
(18, 'Ananya Iyer',    'ananya.iyer@email.com',   '+91-9654321098', 'Z6789012', 'Indian',   NULL,                    '15 Anna Nagar, Chennai'),
(19, 'Rohan Mehta',    'rohan.mehta@email.com',   '+91-9543210987', 'Z7890123', 'Indian',   NULL,                    '33 SG Highway, Ahmedabad'),
(20, 'Neha Gupta',     'neha.gupta@email.com',    '+91-9432109876', 'Z8901234', 'Indian',   NULL,                    '61 Connaught Place, Delhi');

-- =====================================================
-- HELPER VIEWS (additive – for front-end / API convenience)
-- =====================================================

CREATE OR REPLACE VIEW v_flights_available AS
SELECT
    f.flight_id,
    f.flight_number,
    a.airline_name,
    a.iata_code,
    f.departure_city,
    f.arrival_city,
    f.departure_time,
    f.arrival_time,
    f.capacity,
    f.base_price,
    COUNT(CASE WHEN b.status != 'Cancelled' THEN b.booking_id END) AS booked,
    f.capacity - COUNT(CASE WHEN b.status != 'Cancelled' THEN b.booking_id END) AS available
FROM Flights f
JOIN Airlines a ON f.airline_id = a.airline_id
LEFT JOIN Bookings b ON f.flight_id = b.flight_id
GROUP BY f.flight_id, f.flight_number, a.airline_name, a.iata_code,
         f.departure_city, f.arrival_city, f.departure_time, f.arrival_time,
         f.capacity, f.base_price;

CREATE OR REPLACE VIEW v_bookings_full AS
SELECT
    b.booking_id,
    CONCAT(p.first_name, ' ', p.last_name) AS passenger_name,
    p.email AS passenger_email,
    f.flight_number,
    a.airline_name,
    CONCAT(f.departure_city, ' → ', f.arrival_city) AS route,
    f.departure_time,
    b.seat_number,
    b.status,
    b.total_amount,
    b.booking_date,
    pay.transaction_ref,
    pay.payment_method,
    pay.status AS payment_status,
    bd.contact_name,
    bd.contact_email,
    bd.contact_phone,
    bd.passport_number,
    bd.nationality,
    bd.special_requests
FROM Bookings b
JOIN Passengers p ON b.passenger_id = p.passenger_id
JOIN Flights f    ON b.flight_id = f.flight_id
JOIN Airlines a   ON f.airline_id = a.airline_id
LEFT JOIN Payments pay ON b.booking_id = pay.booking_id
LEFT JOIN BookingDetails bd ON b.booking_id = bd.booking_id
ORDER BY b.booking_date DESC;

-- =====================================================
-- QUICK CHECK QUERIES (optional)
-- =====================================================
-- SELECT COUNT(*) AS total_daily_flights FROM Flights WHERE flight_number LIKE '%-%';
-- SELECT DATE(departure_time) AS day, COUNT(*) AS flights
-- FROM Flights GROUP BY DATE(departure_time) ORDER BY day LIMIT 15;
-- SELECT * FROM Payments LIMIT 5;
-- SELECT * FROM BookingDetails LIMIT 5;
-- SELECT * FROM v_flights_available WHERE available > 0 LIMIT 10;
