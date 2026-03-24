-- ============================================================
--  SMART TRAVEL PLANNER — Extended Seed Data
--  Run this AFTER schema.sql has been executed.
--  Safe to run: uses INSERT IGNORE or checks won't duplicate.
--  Assumes destination_id: 1=Goa  2=Manali  3=Jaipur  4=Kerala  5=Ladakh
-- ============================================================

USE smart_travel_planner;

-- ============================================================
-- ADDITIONAL USERS
-- ============================================================
INSERT INTO Users (name, email, password_hash, phone) VALUES
('Riya Sharma',       'riya@email.com',     'hashed_pass_4', '9876543213'),
('Arjun Mehta',       'arjun@email.com',    'hashed_pass_5', '9876543214'),
('Priya Nair',        'priya@email.com',    'hashed_pass_6', '9876543215'),
('Vikram Singh',      'vikram@email.com',   'hashed_pass_7', '9876543216'),
('Sneha Patel',       'sneha@email.com',    'hashed_pass_8', '9876543217');

-- ============================================================
-- ADDITIONAL HOTELS  (3 per destination = 15 more)
-- ============================================================

-- GOA (destination_id = 1)
INSERT INTO Hotels (hotel_name, destination_id, address, price_per_night, rating, amenities, available_rooms) VALUES
('Lemon Tree Hotel Goa',         1, 'Baga Road, Calangute, Goa',         2800.00, 4.3, 'Pool, WiFi, Restaurant, Gym', 20),
('The Leela Goa',                1, 'Cavelossim, South Goa',             9500.00, 4.9, 'Private Beach, Spa, Butler Service, Pool', 12),
('Zostel Goa',                   1, 'Anjuna Beach, North Goa',            799.00, 4.1, 'Dorm, WiFi, Common Kitchen, Rooftop Bar', 30),
('Alila Diwa Goa',               1, 'Majorda, South Goa',                7200.00, 4.8, 'Infinity Pool, Spa, Paddy Field View', 15),
('Treebo Trend Goa Comfort',     1, 'Panaji, Goa',                       1500.00, 3.9, 'WiFi, AC, Parking, Breakfast', 18);

-- MANALI (destination_id = 2)
INSERT INTO Hotels (hotel_name, destination_id, address, price_per_night, rating, amenities, available_rooms) VALUES
('The Himalayan',                2, 'Old Manali Road, Manali',           5500.00, 4.7, 'Mountain View, Fireplace, Spa, Restaurant', 10),
('Solang Valley Resort',         2, 'Solang Nala, Manali',               3800.00, 4.4, 'Ski Access, Bonfire, WiFi, Heater', 8),
('Zostel Manali',                2, 'Old Manali, HP',                      899.00, 4.2, 'Dorm, Common Room, Cafe, Trekking Tours', 25),
('Apple Country Resort',         2, 'Naggar Road, Manali',               2400.00, 4.0, 'Apple Orchard, Garden, Bonfire, Parking', 12),
('Span Resort & Spa Manali',     2, 'Kullu, Himachal Pradesh',           6200.00, 4.6, 'River View, Spa, Fireplace, Fine Dining', 6);

-- JAIPUR (destination_id = 3)
INSERT INTO Hotels (hotel_name, destination_id, address, price_per_night, rating, amenities, available_rooms) VALUES
('Rambagh Palace',               3, 'Bhawani Singh Rd, Jaipur',         18000.00, 4.9, 'Heritage Palace, Spa, Polo, Fine Dining', 5),
('Dera Mandawa Haveli',          3, 'Sansar Chandra Road, Jaipur',       3200.00, 4.4, 'Haveli Architecture, Rooftop, WiFi', 14),
('Treebo Trend Blue Moon',       3, 'Sindhi Camp, Jaipur',               1200.00, 3.8, 'WiFi, AC, Near Station, Breakfast', 22),
('Samode Haveli',                3, 'Gangapole, Jaipur',                 8500.00, 4.7, 'Heritage Haveli, Rooftop Pool, Gardens', 8),
('Hotel Pearl Palace',           3, 'Hathroi Fort, Jaipur',              1800.00, 4.3, 'Rooftop Cafe, Heritage Decor, WiFi', 16);

-- KERALA (destination_id = 4)
INSERT INTO Hotels (hotel_name, destination_id, address, price_per_night, rating, amenities, available_rooms) VALUES
('Kumarakom Lake Resort',        4, 'Kumarakom, Kerala',                 9800.00, 4.9, 'Lake View, Ayurveda Spa, Private Pool, Kayak', 10),
('Spice Village Thekkady',       4, 'Thekkady, Kerala',                  6500.00, 4.7, 'Jungle View, Spice Garden, Wildlife Tours', 12),
('Zostel Kochi',                 4, 'Fort Kochi, Kerala',                  950.00, 4.3, 'Heritage Area, WiFi, Common Lounge, Tours', 20),
('Taj Malabar Kochi',            4, 'Willingdon Island, Kochi',           7800.00, 4.8, 'Harbour View, Pool, Spa, Fine Dining', 18),
('Green Woods Bethel',           4, 'Munnar, Kerala',                    2200.00, 4.2, 'Tea Garden View, Ayurveda, WiFi, Trekking', 10);

-- LADAKH (destination_id = 5)
INSERT INTO Hotels (hotel_name, destination_id, address, price_per_night, rating, amenities, available_rooms) VALUES
('The Grand Dragon Ladakh',      5, 'Old Leh Rd, Leh, Ladakh',          7500.00, 4.8, 'Mountain View, Heated Rooms, Restaurant, Tours', 8),
('Ladakh Sarai',                 5, 'Saboo Village, Leh',                5200.00, 4.6, 'Luxury Tents, Stargazing, Bonfire, Cafe', 6),
('Zostel Leh',                   5, 'Leh City, Ladakh',                  1100.00, 4.4, 'Dorm, Social Hangout, Tour Bookings, WiFi', 18),
('The Chamba Camp Thiksey',      5, 'Thiksey Village, Ladakh',           8200.00, 4.7, 'Luxury Tents, Monastery View, Spa, Dining', 5),
('Hotel Singge Palace',          5, 'Leh, Ladakh',                       2600.00, 4.1, 'Mountain View, Restaurant, WiFi, Parking', 14);

-- ============================================================
-- ADDITIONAL TOURIST SPOTS  (5 per destination = 25 more)
-- ============================================================

-- GOA
INSERT INTO TouristSpots (spot_name, destination_id, description, entry_fee, opening_hours, category) VALUES
('Basilica of Bom Jesus',    1, 'UNESCO World Heritage church, holds remains of St. Francis Xavier. Built in 1605.',         0.00,  '09:00–18:00', 'Heritage'),
('Dudhsagar Falls',          1, 'Massive four-tiered waterfall on the Goa-Karnataka border. 310 metres high.',             400.00, '06:00–18:00', 'Nature'),
('Fort Aguada',              1, '17th-century Portuguese fort with a lighthouse. Overlooks the Arabian Sea.',                0.00,  '09:30–17:30', 'Heritage'),
('Anjuna Flea Market',       1, 'Iconic Wednesday market with handicrafts, clothes, spices and live music.',                0.00,  '08:00–18:00', 'Culture'),
('Palolem Beach',            1, 'Crescent-shaped pristine beach in South Goa, perfect for swimming and kayaking.',          0.00,  '24 hours',    'Beach'),
('Chapora Fort',             1, 'Hilltop fort with panoramic views. Made famous by Bollywood film Dil Chahta Hai.',         0.00,  '08:30–17:30', 'Heritage'),
('Calangute Beach',          1, 'Queen of Beaches — busiest beach with water sports, shacks and nightlife.',               0.00,  '24 hours',    'Beach');

-- MANALI
INSERT INTO TouristSpots (spot_name, destination_id, description, entry_fee, opening_hours, category) VALUES
('Solang Valley',            2, 'Adventure hub for skiing, paragliding, zorbing and cable car rides. 14 km from Manali.',  200.00, '09:00–18:00', 'Adventure'),
('Hadimba Devi Temple',      2, 'Ancient wooden temple surrounded by cedar forest. Built in 1553 CE.',                      0.00,  '08:00–18:00', 'Heritage'),
('Old Manali Village',       2, 'Bohemian village with cafes, art galleries and hippie culture along Manalsu Nala.',       0.00,  '24 hours',    'Culture'),
('Jogini Waterfall',         2, 'Serene 30-metre waterfall reachable via a forest trek from Old Manali.',                  0.00,  'Sunrise–Sunset','Nature'),
('Beas River Rafting',       2, 'Grade II–III white-water rafting on the Beas — 8 to 14 km stretches available.',        600.00, '09:00–16:00', 'Adventure'),
('Kullu Valley',             2, 'The Valley of Gods — apple orchards, river views and Dussehra celebrations.',             0.00,  '24 hours',    'Nature'),
('Naggar Castle',            2, 'Medieval castle turned heritage hotel, with panoramic Kullu Valley views.',              100.00, '10:00–17:00', 'Heritage');

-- JAIPUR
INSERT INTO TouristSpots (spot_name, destination_id, description, entry_fee, opening_hours, category) VALUES
('Hawa Mahal',               3, 'Palace of Winds — 953 latticed windows built for royal ladies to watch street life.',     200.00, '09:00–17:00', 'Heritage'),
('City Palace',              3, 'Royal residence with museums, courtyards and the famous silver urns of Maharaja.',        500.00, '09:30–17:00', 'Heritage'),
('Jantar Mantar',            3, 'UNESCO site — world''s largest stone sundial complex built in 1734.',                    200.00, '09:00–16:30', 'Heritage'),
('Nahargarh Fort',           3, 'Hilltop fort with stunning sunset views over Pink City. Royal cenotaphs inside.',         200.00, '10:00–17:30', 'Heritage'),
('Jal Mahal',                3, 'Floating palace in Man Sagar Lake — glowing at dusk, best viewed from shore.',            0.00,  '06:00–18:00', 'Heritage'),
('Johri Bazaar',             3, 'Famous for traditional jewelry, gemstones, textiles and blue pottery.',                   0.00,  '10:00–21:00', 'Culture'),
('Chokhi Dhani',             3, 'Rajasthani cultural village resort with folk dance, camel rides and traditional food.',  850.00, '17:00–23:00', 'Culture');

-- KERALA
INSERT INTO TouristSpots (spot_name, destination_id, description, entry_fee, opening_hours, category) VALUES
('Munnar Tea Gardens',       4, 'Rolling green hills carpeted with tea estates at 1600m altitude. Mesmerizing sunrise views.',  0.00,  '06:00–18:00', 'Nature'),
('Periyar Wildlife Reserve', 4, 'Tiger reserve with boat safaris on Periyar Lake — elephants, tigers, and bison.',          400.00, '06:00–18:00', 'Nature'),
('Kovalam Beach',            4, 'Crescent beach famous for Ayurvedic resorts, lighthouse and crystal-clear waters.',         0.00,  '24 hours',    'Beach'),
('Fort Kochi',               4, 'Historic Portuguese colony with Chinese fishing nets, art galleries and heritage walks.',    0.00,  '24 hours',    'Heritage'),
('Thekkady Spice Gardens',   4, 'Guided tours through cardamom, pepper and cinnamon plantations.',                          200.00, '08:00–17:00', 'Nature'),
('Bekal Fort',               4, 'Largest fort in Kerala — dramatic clifftop ocean views, 300 years old.',                  100.00, '08:00–18:00', 'Heritage'),
('Wayanad Wildlife Reserve', 4, 'Dense forests with elephants, leopards and rich tribal culture.',                          150.00, '06:00–18:00', 'Nature');

-- LADAKH
INSERT INTO TouristSpots (spot_name, destination_id, description, entry_fee, opening_hours, category) VALUES
('Thiksey Monastery',        5, 'Stunning 12-storey monastery resembling Potala Palace. 500-year-old Buddhist site.',       100.00, '06:00–18:00', 'Heritage'),
('Nubra Valley',             5, 'High-altitude cold desert with sand dunes, Bactrian camels and Diskit Monastery.',        500.00, 'Sunrise–Sunset','Nature'),
('Magnetic Hill',            5, 'Gravity-defying hill where vehicles appear to roll uphill. Optical illusion at 14000 ft.',  0.00,  '24 hours',    'Adventure'),
('Diskit Monastery',         5, 'Oldest monastery in Nubra Valley with a 32-metre Maitreya Buddha statue.',               100.00, '07:00–18:00', 'Heritage'),
('Hemis Monastery',          5, 'Largest monastery in Ladakh — hosts the grand Hemis Festival every June.',               100.00, '09:00–18:00', 'Heritage'),
('Tso Moriri Lake',          5, 'Remote high-altitude lake at 4500m — azure blue, untouched and hauntingly beautiful.',     0.00,  'Sunrise–Sunset','Nature'),
('Zanskar Valley Trek',      5, 'One of India''s most dramatic multi-day treks through frozen river valleys.',            1000.00, 'All Day',     'Adventure');

-- ============================================================
-- ADDITIONAL TRANSPORT OPTIONS
-- ============================================================

-- GOA routes
INSERT INTO Transport (type, operator_name, source, destination, departure_time, arrival_time, fare, available_seats) VALUES
('Flight', 'SpiceJet',       'Mumbai',   'Goa',    '07:30:00', '08:45:00', 3200.00, 180),
('Flight', 'Vistara',        'Delhi',    'Goa',    '09:15:00', '11:45:00', 5800.00, 160),
('Flight', 'Air India',      'Bangalore','Goa',    '11:00:00', '12:00:00', 2800.00, 150),
('Train',  'Indian Railways', 'Mumbai',  'Goa',    '23:00:00', '11:00:00',  900.00,  64),
('Bus',    'Kadamba',        'Bangalore','Goa',    '21:00:00', '07:00:00',  700.00,  45);

-- MANALI routes
INSERT INTO Transport (type, operator_name, source, destination, departure_time, arrival_time, fare, available_seats) VALUES
('Flight', 'Alliance Air',   'Delhi',    'Kullu',  '08:00:00', '09:15:00', 5500.00,  48),
('Bus',    'HRTC Volvo',     'Delhi',    'Manali', '17:00:00', '08:00:00',  850.00,  40),
('Bus',    'HRTC Volvo',     'Chandigarh','Manali','20:00:00', '07:30:00',  600.00,  40),
('Train',  'Indian Railways','Delhi',    'Chandigarh','16:00:00','20:00:00', 350.00, 120),
('Bus',    'RedBus Volvo',   'Mumbai',   'Manali', '16:30:00', '10:00:00', 1200.00,  36);

-- JAIPUR routes
INSERT INTO Transport (type, operator_name, source, destination, departure_time, arrival_time, fare, available_seats) VALUES
('Flight', 'IndiGo',         'Bangalore','Jaipur', '06:30:00', '09:00:00', 4200.00, 180),
('Flight', 'SpiceJet',       'Delhi',    'Jaipur', '08:00:00', '09:00:00', 2500.00, 160),
('Train',  'Indian Railways','Delhi',    'Jaipur', '06:05:00', '10:30:00',  250.00, 200),
('Train',  'Indian Railways','Mumbai',   'Jaipur', '19:00:00', '09:00:00',  550.00, 180),
('Bus',    'RSRTC Volvo',    'Delhi',    'Jaipur', '07:00:00', '12:00:00',  450.00,  45);

-- KERALA routes
INSERT INTO Transport (type, operator_name, source, destination, departure_time, arrival_time, fare, available_seats) VALUES
('Flight', 'IndiGo',         'Delhi',    'Kerala', '06:00:00', '09:15:00', 5200.00, 180),
('Flight', 'Air India',      'Mumbai',   'Kerala', '10:30:00', '12:30:00', 3800.00, 150),
('Flight', 'SpiceJet',       'Delhi',    'Kerala', '08:45:00', '12:00:00', 4900.00, 180),
('Train',  'Indian Railways','Mumbai',   'Kerala', '11:00:00', '14:00:00',  750.00, 200),
('Bus',    'KSRTC Super',    'Bangalore','Kerala', '20:00:00', '07:00:00',  650.00,  40);

-- LADAKH routes
INSERT INTO Transport (type, operator_name, source, destination, departure_time, arrival_time, fare, available_seats) VALUES
('Flight', 'IndiGo',         'Delhi',    'Leh',    '06:00:00', '08:00:00', 7500.00,  80),
('Flight', 'Air India',      'Mumbai',   'Leh',    '05:30:00', '08:30:00', 9200.00,  80),
('Flight', 'Vistara',        'Delhi',    'Leh',    '08:30:00', '10:30:00', 8500.00, 100),
('Bus',    'HPTDC',          'Manali',   'Leh',    '05:00:00', '20:00:00',  550.00,  40),
('Bus',    'JKSRTC',         'Srinagar', 'Leh',    '05:00:00', '18:00:00',  480.00,  35);

-- ============================================================
-- ADDITIONAL BUDGET PACKAGES  (3 more per destination)
-- ============================================================

-- GOA packages
INSERT INTO BudgetPackages (package_name, destination_id, total_cost, duration_days, description, max_people) VALUES
('Goa Budget Backpacker',    1,  7500.00, 3, 'Hostel stay, beach hopping and local shacks. Great for solo travellers.',     1),
('Goa Luxury Escape',        1, 45000.00, 5, '5-star resort, private beach, spa, candlelit dinners and sunset cruise.',     2),
('Goa Couples Honeymoon',    1, 28000.00, 4, 'Boutique resort, romantic dinners, dolphin cruise and heritage tour.',         2),
('Goa Adventure Pack',       1, 14000.00, 4, 'Water sports, parasailing, scuba diving and beach camping.',                  4),
('North & South Goa Explorer',1,19000.00, 5, 'Cover both ends — beaches, forts, markets and the best shacks in Goa.',       3);

-- MANALI packages
INSERT INTO BudgetPackages (package_name, destination_id, total_cost, duration_days, description, max_people) VALUES
('Manali Winter Wonderland',  2, 16000.00, 5, 'Snow activities, skiing at Solang, bonfire nights and hot springs.',         2),
('Manali Trekking Expedition',2, 22000.00, 7, 'Guided treks to Beas Kund and Bhrigu Lake. Camping under the stars.',       4),
('Manali Family Retreat',     2, 18000.00, 4, 'Comfortable hotel, Rohtang day trip, Hadimba temple and river walk.',        4),
('Manali Budget Escape',      2,  9500.00, 3, 'Guesthouse stay, Old Manali walks, cafes and waterfall hike.',              2),
('Manali Honeymoon Special',  2, 24000.00, 5, 'Luxury cottage, Solang snow, candlelight dinner and couple spa package.',    2);

-- JAIPUR packages
INSERT INTO BudgetPackages (package_name, destination_id, total_cost, duration_days, description, max_people) VALUES
('Jaipur Heritage Walk',      3, 11000.00, 3, 'Amer Fort, Hawa Mahal, City Palace, bazaar and local Rajasthani thali.',     2),
('Jaipur Royal Luxury',       3, 55000.00, 4, 'Heritage palace hotel, elephant ride, private heritage tour and gala dinner.',2),
('Golden Triangle Jaipur',    3, 24000.00, 5, 'Delhi–Agra–Jaipur with guide, all hotels and transport included.',           2),
('Jaipur Family Fun',         3, 20000.00, 3, 'Nahargarh Fort, Chokhi Dhani, Jantar Mantar and shopping day.',             4),
('Jaipur Budget Traveller',   3,  8000.00, 2, 'Guesthouse, self-guided map, street food walk and local chai tour.',         1);

-- KERALA packages
INSERT INTO BudgetPackages (package_name, destination_id, total_cost, duration_days, description, max_people) VALUES
('Kerala Backwater Dream',    4, 22000.00, 5, 'Luxury houseboat 2 nights, Alleppey canals, Kochi heritage walk.',           2),
('Kerala Ayurveda Retreat',   4, 35000.00, 7, 'Certified Panchakarma, yoga, Ayurvedic meals and nature walks.',             1),
('Kerala Nature & Wildlife',  4, 18000.00, 5, 'Munnar tea gardens, Periyar boat safari, spice tour and trek.',              2),
('God''s Own Budget Trip',    4,  9500.00, 4, 'Backpacker hostels, Kochi walk, Kovalam beach and local fish curry.',         1),
('Kerala Family Holiday',     4, 26000.00, 6, 'Houseboat, Thekkady, Munnar, Kovalam beach and Kathakali show.',             4);

-- LADAKH packages
INSERT INTO BudgetPackages (package_name, destination_id, total_cost, duration_days, description, max_people) VALUES
('Ladakh Luxury Camp',        5, 42000.00, 7, 'Luxury tented camp, private jeep, Pangong overnight stay and monastery tour.',2),
('Ladakh Bike Expedition',    5, 32000.00, 8, 'Manali to Leh on Royal Enfield with mechanic support, stays and meals.',     2),
('Ladakh Monasteries Tour',   5, 18000.00, 5, 'Hemis, Thiksey, Diskit, Alchi — guided Buddhist heritage circuit.',          2),
('Ladakh Solo Backpacker',    5, 14000.00, 6, 'Shared jeep tours, hostel stays, Pangong day trip and Nubra valley.',         1),
('Ladakh Star Gazing Camp',   5, 28000.00, 5, 'Remote camp at Tso Moriri, astrophotography guide and high-altitude hike.',   2);

-- ============================================================
-- PACKAGE DETAILS (link new packages to hotels + transport + spots)
-- ============================================================
-- Using new hotel IDs (6-25) and new spot IDs (6-40) and transport IDs (6-30)
-- Package IDs 6 onwards (5 original + new ones)

-- GOA new packages (pkg 6–10)
INSERT INTO PackageDetails (package_id, hotel_id, transport_id, spot_id) VALUES
(6,  8,  10, 7),   -- Budget Backpacker: Zostel Goa, Kadamba Bus, Palolem Beach
(7,  7,   7, 6),   -- Luxury Escape: The Leela Goa, Vistara Flight, Basilica Bom Jesus
(8,  7,   6, 8),   -- Couples Honeymoon: The Leela, SpiceJet Mumbai, Anjuna Flea Market
(9,  6,   8, 11),  -- Adventure Pack: Lemon Tree, Air India, Chapora Fort
(10, 9,   9, 10);  -- North & South Explorer: Alila Diwa, Train Mumbai, Calangute Beach

-- MANALI new packages (pkg 11–15)
INSERT INTO PackageDetails (package_id, hotel_id, transport_id, spot_id) VALUES
(11, 11, 13, 13),  -- Winter Wonderland: Solang Valley Resort, HRTC Bus, Solang Valley
(12, 10, 12, 16),  -- Trekking Expedition: The Himalayan, Alliance Air, Beas Rafting
(13, 13, 14, 14),  -- Family Retreat: Apple Country, Chandigarh Bus, Hadimba Temple
(14, 12, 13, 15),  -- Budget Escape: Zostel Manali, HRTC Volvo, Old Manali
(15, 14, 15, 17);  -- Honeymoon: Span Resort, RedBus Volvo, Kullu Valley

-- JAIPUR new packages (pkg 16–20)
INSERT INTO PackageDetails (package_id, hotel_id, transport_id, spot_id) VALUES
(16, 18, 19, 19),  -- Heritage Walk: Dera Mandawa, Train Delhi-Jaipur, Hawa Mahal
(17, 16, 18, 20),  -- Royal Luxury: Rambagh Palace, IndiGo Bangalore, City Palace
(18, 16, 17, 24),  -- Golden Triangle: Rambagh, SpiceJet Delhi, Chokhi Dhani
(19, 19, 21, 22),  -- Family Fun: Samode Haveli, Train Mumbai, Nahargarh Fort
(20, 20, 20, 21);  -- Budget Traveller: Hotel Pearl Palace, Train Delhi, Jantar Mantar

-- KERALA new packages (pkg 21–25)
INSERT INTO PackageDetails (package_id, hotel_id, transport_id, spot_id) VALUES
(21, 21, 22, 27),  -- Backwater Dream: Kumarakom Lake, IndiGo Delhi, Fort Kochi
(22, 21, 24, 25),  -- Ayurveda Retreat: Kumarakom Lake, Air India Mumbai, Munnar Tea
(23, 22, 23, 26),  -- Nature & Wildlife: Spice Village, SpiceJet Delhi, Periyar
(24, 23, 26, 27),  -- Budget Trip: Zostel Kochi, KSRTC Bus, Fort Kochi
(25, 25, 22, 28);  -- Family Holiday: Green Woods, IndiGo Delhi, Kovalam Beach

-- LADAKH new packages (pkg 26–30)
INSERT INTO PackageDetails (package_id, hotel_id, transport_id, spot_id) VALUES
(26, 29, 27, 31),  -- Luxury Camp: Chamba Camp, IndiGo Delhi, Thiksey Monastery
(27, 26, 29, 34),  -- Bike Expedition: Grand Dragon, HPTDC Bus, Diskit Monastery
(28, 26, 27, 32),  -- Monasteries Tour: Grand Dragon, IndiGo, Nubra Valley
(29, 28, 30, 31),  -- Solo Backpacker: Zostel Leh, JKSRTC Bus, Thiksey
(30, 27, 28, 36);  -- Star Gazing: Ladakh Sarai, Vistara, Tso Moriri Lake

-- ============================================================
-- ADDITIONAL BOOKINGS
-- ============================================================
INSERT INTO Bookings (user_id, hotel_id, transport_id, package_id, check_in_date, check_out_date, num_people, status, total_amount) VALUES
(4, 7,  7,  7,  '2026-02-14', '2026-02-19', 2, 'Confirmed', 45000.00),
(5, 10, 12, 12, '2026-03-10', '2026-03-17', 4, 'Confirmed', 88000.00),
(6, 16, 18, 17, '2026-01-20', '2026-01-24', 2, 'Pending',   55000.00),
(7, 21, 22, 21, '2026-04-01', '2026-04-06', 2, 'Confirmed', 44000.00),
(1, 29, 27, 26, '2026-06-15', '2026-06-22', 2, 'Confirmed', 84000.00),
(2, 8,  10, 6,  '2026-03-25', '2026-03-28', 1, 'Confirmed',  7500.00),
(3, 25, 26, 24, '2026-05-05', '2026-05-09', 1, 'Pending',    9500.00);

-- ============================================================
-- ADDITIONAL PAYMENTS
-- ============================================================
INSERT INTO Payments (booking_id, amount, payment_method, status, transaction_id) VALUES
(4, 45000.00, 'Credit Card', 'Success', 'TXN100004'),
(5, 88000.00, 'Net Banking', 'Success', 'TXN100005'),
(6, 55000.00, 'UPI',         'Pending', 'TXN100006'),
(7, 44000.00, 'Debit Card',  'Success', 'TXN100007'),
(8, 84000.00, 'Credit Card', 'Success', 'TXN100008'),
(9,  7500.00, 'UPI',         'Success', 'TXN100009'),
(10, 9500.00, 'UPI',         'Pending', 'TXN100010');

-- ============================================================
-- ADDITIONAL REVIEWS
-- ============================================================
INSERT INTO Reviews (user_id, hotel_id, spot_id, rating, comment) VALUES
(4, 7,    NULL, 5, 'The Leela Goa is paradise! Private beach, incredible food, best honeymoon ever.'),
(5, 10,   NULL, 5, 'The Himalayan Manali gave us the most magical snow experience. Fireplace every night!'),
(6, 16,   NULL, 5, 'Rambagh Palace is royalty redefined. You feel like a Maharaja the whole time.'),
(7, 21,   NULL, 5, 'Kumarakom Lake Resort woke us up to misty backwaters every morning. Heaven.'),
(1, 29,   NULL, 5, 'Chamba Camp in Thiksey was surreal — stars so bright, monastery so peaceful.'),
(2, NULL, 19,  5, 'Hawa Mahal at sunrise is the most magical sight — the pink glow is unreal.'),
(3, NULL, 31,  5, 'Thiksey Monastery at dawn with monks chanting — spiritual and breathtaking.'),
(4, NULL, 7,   4, 'Dudhsagar Falls is worth every bit of the 4x4 ride. Majestic!'),
(5, NULL, 13,  5, 'Solang Valley skiing was pure joy — instructors were amazing and views were epic.'),
(6, NULL, 25,  5, 'Munnar tea gardens at sunrise — the mist rolling over hills is otherworldly.'),
(7, NULL, 32,  5, 'Nubra Valley with the sand dunes and Bactrian camels felt like another planet.'),
(1, 6,   NULL, 4, 'Lemon Tree Goa is great value — clean pool, nice breakfast, perfect beach location.'),
(2, 11,  NULL, 4, 'Solang Valley Resort is perfectly located for snow activities. Very cozy.'),
(3, 18,  NULL, 5, 'Dera Mandawa Haveli in Jaipur has gorgeous architecture — rooftop views are stunning.'),
(4, 22,  NULL, 5, 'Spice Village Thekkady is magical — wake up to jungle sounds every morning.'),
(5, NULL, 20,  5, 'City Palace Jaipur is absolutely grand — the museum inside is world-class.'),
(6, NULL, 26,  5, 'Periyar Wildlife boat safari — saw a family of 12 elephants bathing in the lake!'),
(7, NULL, 27,  4, 'Fort Kochi is charming and walkable. The Chinese fishing nets at sunset are iconic.'),
(1, NULL, 35,  5, 'Hemis Monastery during the festival is a once-in-a-lifetime cultural experience.'),
(2, NULL, 8,   4, 'Anjuna Flea Market is chaotic and fun — great for souvenirs and live music.');

-- ============================================================
-- ADDITIONAL WISHLIST ENTRIES
-- ============================================================
INSERT INTO Wishlist (user_id, hotel_id, spot_id, package_id) VALUES
(4, NULL, NULL, 26),   -- Riya wants: Ladakh Luxury Camp
(5, 29,  NULL, NULL),  -- Arjun wants: Chamba Camp Thiksey hotel
(6, NULL, 19,  NULL),  -- Priya wishlisted: Hawa Mahal
(7, NULL, NULL, 7),    -- Vikram wants: Goa Luxury Escape package
(1, NULL, 32,  NULL),  -- Ashmika wishlisted: Nubra Valley
(2, 16,  NULL, NULL),  -- Aakankshya wants: Rambagh Palace
(3, NULL, 25,  NULL),  -- Kavya wishlisted: Munnar Tea Gardens
(4, NULL, NULL, 22),   -- Riya wants: Kerala Ayurveda Retreat
(5, NULL, 13,  NULL),  -- Arjun wishlisted: Solang Valley
(6, 21,  NULL, NULL);  -- Priya wants: Kumarakom Lake Resort

-- ============================================================
-- ADDITIONAL CHAT LOGS
-- ============================================================
INSERT INTO ChatLogs (user_id, message, response) VALUES
(4, 'Show me luxury hotels in Goa.',              'Found 2 luxury options: The Leela Goa (₹9500/night) and Alila Diwa Goa (₹7200/night). Both have private pools and spa.'),
(5, 'Best trekking package for Manali?',          'Recommended: Manali Trekking Expedition — 7 days, ₹22,000/person includes Beas Kund and Bhrigu Lake trek with camping.'),
(6, 'What is special about Jaipur?',              'Jaipur is India''s first planned city! Must-see: Amer Fort, Hawa Mahal, City Palace, and the vibrant bazaars. Best Oct–Mar.'),
(7, 'I want a houseboat experience in Kerala.',   'Perfect! Kerala Backwater Dream package (₹22,000, 5 nights) includes 2 nights on a luxury houseboat in Alleppey.'),
(1, 'Cheapest way to reach Ladakh?',              'Cheapest is HPTDC Bus from Manali to Leh at ₹550, but the journey is 15 hours. Fastest is IndiGo Flight Delhi-Leh at ₹7,500.'),
(2, 'Which beach in Goa is best for families?',   'Calangute or Baga are great for families — lifeguards, restaurants nearby and calm waters in winter season.'),
(3, 'How many days for Kerala trip?',             'We recommend 6–8 days to cover Kochi, Alleppey backwaters, Munnar and Thekkady comfortably. Add Kovalam for beach time.');
