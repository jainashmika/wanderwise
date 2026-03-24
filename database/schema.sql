-- ============================================================
--   SMART TRAVEL PLANNING SYSTEM
--   Database Schema
--   MANIPAL ACADEMY OF HIGHER EDUCATION
-- ============================================================

CREATE DATABASE IF NOT EXISTS smart_travel_planner;
USE smart_travel_planner;

-- ============================================================
-- TABLE 1: Destinations
-- Master table for all cities/locations.
-- This is an EXTRA table that normalizes location data —
-- instead of storing city name as plain text everywhere,
-- we store it once here and reference it by ID (3NF principle).
-- ============================================================
CREATE TABLE Destinations (
    destination_id   INT AUTO_INCREMENT PRIMARY KEY,
    city             VARCHAR(100)  NOT NULL,
    country          VARCHAR(100)  NOT NULL DEFAULT 'India',
    description      TEXT,
    best_season      VARCHAR(50),
    image_url        VARCHAR(255)
);

-- ============================================================
-- TABLE 2: Users  (from synopsis)
-- Stores registered user accounts.
-- password_hash: we never store plain passwords — always hashed.
-- ============================================================
CREATE TABLE Users (
    user_id          INT AUTO_INCREMENT PRIMARY KEY,
    name             VARCHAR(100)  NOT NULL,
    email            VARCHAR(150)  NOT NULL UNIQUE,
    password_hash    VARCHAR(255)  NOT NULL,
    phone            VARCHAR(15),
    created_at       TIMESTAMP     DEFAULT CURRENT_TIMESTAMP
);

-- ============================================================
-- TABLE 3: Hotels  (from synopsis)
-- destination_id links to Destinations table (Foreign Key).
-- available_rooms tracks real-time room availability.
-- ============================================================
CREATE TABLE Hotels (
    hotel_id         INT AUTO_INCREMENT PRIMARY KEY,
    hotel_name       VARCHAR(150)  NOT NULL,
    destination_id   INT,
    address          VARCHAR(255),
    price_per_night  DECIMAL(10,2) NOT NULL,
    rating           DECIMAL(2,1)  CHECK (rating BETWEEN 1.0 AND 5.0),
    amenities        TEXT,
    available_rooms  INT           DEFAULT 0,
    FOREIGN KEY (destination_id) REFERENCES Destinations(destination_id)
        ON DELETE SET NULL
);

-- ============================================================
-- TABLE 4: Transport  (from synopsis)
-- ENUM for type ensures only valid values are stored.
-- available_seats tracks real-time seat availability.
-- ============================================================
CREATE TABLE Transport (
    transport_id     INT AUTO_INCREMENT PRIMARY KEY,
    type             ENUM('Bus','Train','Flight') NOT NULL,
    operator_name    VARCHAR(100),
    source           VARCHAR(100)  NOT NULL,
    destination      VARCHAR(100)  NOT NULL,
    departure_time   TIME,
    arrival_time     TIME,
    fare             DECIMAL(10,2) NOT NULL,
    available_seats  INT           DEFAULT 0
);

-- ============================================================
-- TABLE 5: TouristSpots  (from synopsis)
-- category groups spots (e.g. Heritage, Beach, Adventure).
-- ============================================================
CREATE TABLE TouristSpots (
    spot_id          INT AUTO_INCREMENT PRIMARY KEY,
    spot_name        VARCHAR(150)  NOT NULL,
    destination_id   INT,
    description      TEXT,
    entry_fee        DECIMAL(10,2) DEFAULT 0.00,
    opening_hours    VARCHAR(100),
    category         VARCHAR(50),
    FOREIGN KEY (destination_id) REFERENCES Destinations(destination_id)
        ON DELETE SET NULL
);

-- ============================================================
-- TABLE 6: BudgetPackages  (from synopsis)
-- A package bundles a hotel + transport + spots into one deal.
-- max_people sets the group size limit.
-- ============================================================
CREATE TABLE BudgetPackages (
    package_id       INT AUTO_INCREMENT PRIMARY KEY,
    package_name     VARCHAR(150)  NOT NULL,
    destination_id   INT,
    total_cost       DECIMAL(10,2) NOT NULL,
    duration_days    INT           NOT NULL,
    description      TEXT,
    max_people       INT           DEFAULT 1,
    FOREIGN KEY (destination_id) REFERENCES Destinations(destination_id)
        ON DELETE SET NULL
);

-- ============================================================
-- TABLE 7: PackageDetails  (EXTRA — resolves Many-to-Many)
-- One package can include multiple hotels, transports, spots.
-- This is a junction/bridge table — a key DBMS concept.
-- ============================================================
CREATE TABLE PackageDetails (
    detail_id        INT AUTO_INCREMENT PRIMARY KEY,
    package_id       INT NOT NULL,
    hotel_id         INT,
    transport_id     INT,
    spot_id          INT,
    FOREIGN KEY (package_id)    REFERENCES BudgetPackages(package_id) ON DELETE CASCADE,
    FOREIGN KEY (hotel_id)      REFERENCES Hotels(hotel_id)           ON DELETE SET NULL,
    FOREIGN KEY (transport_id)  REFERENCES Transport(transport_id)    ON DELETE SET NULL,
    FOREIGN KEY (spot_id)       REFERENCES TouristSpots(spot_id)      ON DELETE SET NULL
);

-- ============================================================
-- TABLE 8: Bookings  (from synopsis)
-- Central transaction table — links User + Hotel + Transport.
-- status tracks the booking lifecycle.
-- ============================================================
CREATE TABLE Bookings (
    booking_id       INT AUTO_INCREMENT PRIMARY KEY,
    user_id          INT           NOT NULL,
    hotel_id         INT,
    transport_id     INT,
    package_id       INT,
    check_in_date    DATE,
    check_out_date   DATE,
    num_people       INT           DEFAULT 1,
    booking_date     TIMESTAMP     DEFAULT CURRENT_TIMESTAMP,
    status           ENUM('Pending','Confirmed','Cancelled') DEFAULT 'Pending',
    total_amount     DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (user_id)        REFERENCES Users(user_id)            ON DELETE CASCADE,
    FOREIGN KEY (hotel_id)       REFERENCES Hotels(hotel_id)          ON DELETE SET NULL,
    FOREIGN KEY (transport_id)   REFERENCES Transport(transport_id)   ON DELETE SET NULL,
    FOREIGN KEY (package_id)     REFERENCES BudgetPackages(package_id)ON DELETE SET NULL
);

-- ============================================================
-- TABLE 9: Payments  (EXTRA — stands out)
-- Tracks payment for each booking separately.
-- transaction_id is UNIQUE to prevent duplicate payments.
-- ============================================================
CREATE TABLE Payments (
    payment_id       INT AUTO_INCREMENT PRIMARY KEY,
    booking_id       INT           NOT NULL,
    payment_date     TIMESTAMP     DEFAULT CURRENT_TIMESTAMP,
    amount           DECIMAL(10,2) NOT NULL,
    payment_method   ENUM('Credit Card','Debit Card','UPI','Net Banking') NOT NULL,
    status           ENUM('Success','Failed','Pending') DEFAULT 'Pending',
    transaction_id   VARCHAR(100)  UNIQUE,
    FOREIGN KEY (booking_id) REFERENCES Bookings(booking_id)
        ON DELETE CASCADE
);

-- ============================================================
-- TABLE 10: Reviews  (EXTRA — stands out)
-- Users can review hotels OR tourist spots after visiting.
-- CHECK constraint ensures rating is 1–5 only.
-- ============================================================
CREATE TABLE Reviews (
    review_id        INT AUTO_INCREMENT PRIMARY KEY,
    user_id          INT           NOT NULL,
    hotel_id         INT,
    spot_id          INT,
    rating           INT           CHECK (rating BETWEEN 1 AND 5),
    comment          TEXT,
    review_date      TIMESTAMP     DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id)   REFERENCES Users(user_id)        ON DELETE CASCADE,
    FOREIGN KEY (hotel_id)  REFERENCES Hotels(hotel_id)      ON DELETE CASCADE,
    FOREIGN KEY (spot_id)   REFERENCES TouristSpots(spot_id) ON DELETE CASCADE
);

-- ============================================================
-- TABLE 11: Wishlist  (EXTRA — stands out)
-- Users can save hotels, spots, or packages for later.
-- ============================================================
CREATE TABLE Wishlist (
    wishlist_id      INT AUTO_INCREMENT PRIMARY KEY,
    user_id          INT           NOT NULL,
    hotel_id         INT,
    spot_id          INT,
    package_id       INT,
    added_date       TIMESTAMP     DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id)      REFERENCES Users(user_id)              ON DELETE CASCADE,
    FOREIGN KEY (hotel_id)     REFERENCES Hotels(hotel_id)            ON DELETE CASCADE,
    FOREIGN KEY (spot_id)      REFERENCES TouristSpots(spot_id)       ON DELETE CASCADE,
    FOREIGN KEY (package_id)   REFERENCES BudgetPackages(package_id)  ON DELETE CASCADE
);

-- ============================================================
-- TABLE 12: ChatLogs  (from synopsis)
-- Logs every chatbot message + the bot's response.
-- ============================================================
CREATE TABLE ChatLogs (
    chat_id          INT AUTO_INCREMENT PRIMARY KEY,
    user_id          INT,
    message          TEXT          NOT NULL,
    response         TEXT,
    timestamp        TIMESTAMP     DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
        ON DELETE SET NULL
);

-- ============================================================
-- SAMPLE DATA
-- ============================================================

-- Destinations
INSERT INTO Destinations (city, country, description, best_season, image_url) VALUES
('Goa',         'India', 'Famous for beaches and nightlife.',          'October–March',   'images/goa.jpg'),
('Manali',      'India', 'Hill station with snow and adventure.',      'December–February','images/manali.jpg'),
('Jaipur',      'India', 'The Pink City, rich in Rajput heritage.',    'November–February','images/jaipur.jpg'),
('Kerala',      'India', 'Backwaters, spices and Ayurveda.',           'September–March', 'images/kerala.jpg'),
('Ladakh',      'India', 'High-altitude desert and monasteries.',      'June–September',  'images/ladakh.jpg');

-- Users (password_hash is a placeholder — real hashing done in Java)
INSERT INTO Users (name, email, password_hash, phone) VALUES
('Ashmika Jain',      'ashmika@email.com',  'hashed_pass_1', '9876543210'),
('Aakankshya Dash',   'aakankshya@email.com','hashed_pass_2', '9876543211'),
('Kavya Srivastava',  'kavya@email.com',    'hashed_pass_3', '9876543212');

-- Hotels
INSERT INTO Hotels (hotel_name, destination_id, address, price_per_night, rating, amenities, available_rooms) VALUES
('The Goa Beach Resort',  1, 'Calangute Beach Rd, Goa',     3500.00, 4.5, 'Pool, WiFi, Breakfast', 10),
('Snow Valley Inn',       2, 'Mall Road, Manali',           2200.00, 4.2, 'Fireplace, WiFi, Parking', 8),
('Rajputana Palace',      3, 'MI Road, Jaipur',             4000.00, 4.8, 'Heritage, Spa, Pool', 5),
('Backwater Bliss',       4, 'Alleppey, Kerala',            2800.00, 4.3, 'Houseboat, Ayurveda', 6),
('Himalayan Camp',        5, 'Leh, Ladakh',                 3200.00, 4.6, 'Mountain View, Trekking', 4);

-- Transport
INSERT INTO Transport (type, operator_name, source, destination, departure_time, arrival_time, fare, available_seats) VALUES
('Flight', 'IndiGo',          'Delhi',  'Goa',    '06:00:00', '08:30:00', 4500.00, 120),
('Train',  'Indian Railways',  'Delhi',  'Manali', '20:00:00', '08:00:00', 800.00,  72),
('Flight', 'Air India',        'Mumbai', 'Jaipur', '10:00:00', '11:30:00', 3200.00, 150),
('Bus',    'KSRTC',            'Bangalore','Kerala','22:00:00', '06:00:00', 600.00,  40),
('Flight', 'SpiceJet',         'Delhi',  'Leh',    '07:00:00', '09:00:00', 6000.00, 100);

-- TouristSpots
INSERT INTO TouristSpots (spot_name, destination_id, description, entry_fee, opening_hours, category) VALUES
('Baga Beach',       1, 'Popular beach with water sports.',  0.00,  '24 hours',    'Beach'),
('Rohtang Pass',     2, 'Scenic mountain pass at 3978m.',   500.00, '06:00–17:00', 'Adventure'),
('Amber Fort',       3, 'Magnificent 16th century fort.',   200.00, '08:00–18:00', 'Heritage'),
('Alleppey Backwaters',4,'Iconic houseboat experience.',    100.00, '06:00–20:00', 'Nature'),
('Pangong Lake',     5, 'High-altitude crystal-blue lake.',   0.00,  'Sunrise–Sunset','Nature');

-- BudgetPackages
INSERT INTO BudgetPackages (package_name, destination_id, total_cost, duration_days, description, max_people) VALUES
('Goa Sunshine Package',    1, 15000.00, 4, 'Beach + Resort + Flight Deal', 4),
('Manali Snow Escape',      2, 12000.00, 5, 'Snow, trek and cozy stay',     2),
('Jaipur Royal Tour',       3, 18000.00, 3, 'Heritage + Palace hotel',      4),
('Kerala Serenity Trip',    4, 20000.00, 6, 'Backwaters + Ayurveda',        2),
('Ladakh Adventure',        5, 25000.00, 7, 'Trekking + Camping + Lakes',   3);

-- PackageDetails (links each package to hotel + transport + spot)
INSERT INTO PackageDetails (package_id, hotel_id, transport_id, spot_id) VALUES
(1, 1, 1, 1),
(2, 2, 2, 2),
(3, 3, 3, 3),
(4, 4, 4, 4),
(5, 5, 5, 5);

-- Bookings
INSERT INTO Bookings (user_id, hotel_id, transport_id, package_id, check_in_date, check_out_date, num_people, status, total_amount) VALUES
(1, 1, 1, 1, '2025-05-01', '2025-05-05', 2, 'Confirmed', 30000.00),
(2, 3, 3, 3, '2025-06-10', '2025-06-13', 1, 'Pending',   18000.00),
(3, 5, 5, 5, '2025-07-15', '2025-07-22', 2, 'Confirmed', 50000.00);

-- Payments
INSERT INTO Payments (booking_id, amount, payment_method, status, transaction_id) VALUES
(1, 30000.00, 'UPI',         'Success', 'TXN100001'),
(2, 18000.00, 'Credit Card', 'Pending', 'TXN100002'),
(3, 50000.00, 'Net Banking', 'Success', 'TXN100003');

-- Reviews
INSERT INTO Reviews (user_id, hotel_id, spot_id, rating, comment) VALUES
(1, 1, NULL, 5, 'Amazing beachfront resort! Loved every moment.'),
(2, 3, NULL, 4, 'Rajputana Palace is breathtaking, very royal feel.'),
(3, NULL, 5, 5, 'Pangong Lake is the most beautiful place on Earth.');

-- Wishlist
INSERT INTO Wishlist (user_id, hotel_id, spot_id, package_id) VALUES
(1, NULL, 2, NULL),
(2, 5,   NULL, 5),
(3, NULL, 3,  3);

-- ChatLogs
INSERT INTO ChatLogs (user_id, message, response) VALUES
(1, 'Show me hotels in Goa under 4000.',   'Found 1 hotel: The Goa Beach Resort at ₹3500/night.'),
(2, 'What is the best season for Manali?', 'Best season for Manali is December to February for snow.'),
(3, 'Book Ladakh Adventure package.',      'Redirecting you to the booking page for Ladakh Adventure.');
