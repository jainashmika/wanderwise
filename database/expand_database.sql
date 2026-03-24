-- ============================================================
--  SMART TRAVEL PLANNER — Database Expansion
--  NEW CITIES: Udaipur, Rishikesh, Darjeeling, Shimla,
--              Varanasi, Agra, Coorg, Ooty, Mysore, Hampi
--  NEW TABLES: TravelTips, Itineraries, Activities,
--              Restaurants, Events, Guides
--  Run AFTER schema.sql and seed_data.sql
-- ============================================================

USE smart_travel_planner;

-- ============================================================
-- TABLE 13: TravelTips
-- Per-destination insider tips (packing, culture, safety)
-- ============================================================
CREATE TABLE IF NOT EXISTS TravelTips (
    tip_id          INT AUTO_INCREMENT PRIMARY KEY,
    destination_id  INT NOT NULL,
    category        ENUM('Packing','Culture','Safety','Food','Budget','Transport') NOT NULL,
    tip_text        TEXT NOT NULL,
    FOREIGN KEY (destination_id) REFERENCES Destinations(destination_id) ON DELETE CASCADE
);

-- ============================================================
-- TABLE 14: Itineraries
-- Day-by-day plans linked to a package
-- ============================================================
CREATE TABLE IF NOT EXISTS Itineraries (
    itinerary_id    INT AUTO_INCREMENT PRIMARY KEY,
    package_id      INT NOT NULL,
    day_number      INT NOT NULL,
    title           VARCHAR(150),
    description     TEXT,
    activities      TEXT,
    meals_included  SET('Breakfast','Lunch','Dinner'),
    FOREIGN KEY (package_id) REFERENCES BudgetPackages(package_id) ON DELETE CASCADE
);

-- ============================================================
-- TABLE 15: Activities
-- Bookable experiences at each destination
-- (rafting, paragliding, cooking class, etc.)
-- ============================================================
CREATE TABLE IF NOT EXISTS Activities (
    activity_id     INT AUTO_INCREMENT PRIMARY KEY,
    destination_id  INT NOT NULL,
    activity_name   VARCHAR(150) NOT NULL,
    description     TEXT,
    category        ENUM('Adventure','Cultural','Wellness','Food','Nature','Spiritual') NOT NULL,
    duration_hours  DECIMAL(4,1),
    price_per_person DECIMAL(10,2) NOT NULL,
    max_participants INT DEFAULT 20,
    difficulty      ENUM('Easy','Moderate','Hard') DEFAULT 'Easy',
    available_daily BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (destination_id) REFERENCES Destinations(destination_id) ON DELETE CASCADE
);

-- ============================================================
-- TABLE 16: Restaurants
-- Local dining spots with cuisine type and price range
-- ============================================================
CREATE TABLE IF NOT EXISTS Restaurants (
    restaurant_id   INT AUTO_INCREMENT PRIMARY KEY,
    destination_id  INT NOT NULL,
    restaurant_name VARCHAR(150) NOT NULL,
    cuisine_type    VARCHAR(100),
    address         VARCHAR(255),
    price_range     ENUM('Budget','Mid-range','Fine Dining') DEFAULT 'Mid-range',
    rating          DECIMAL(2,1) CHECK (rating BETWEEN 1.0 AND 5.0),
    must_try_dish   VARCHAR(200),
    opening_hours   VARCHAR(100),
    FOREIGN KEY (destination_id) REFERENCES Destinations(destination_id) ON DELETE CASCADE
);

-- ============================================================
-- TABLE 17: Events
-- Festivals and seasonal events at each destination
-- ============================================================
CREATE TABLE IF NOT EXISTS Events (
    event_id        INT AUTO_INCREMENT PRIMARY KEY,
    destination_id  INT NOT NULL,
    event_name      VARCHAR(150) NOT NULL,
    description     TEXT,
    month_of_year   TINYINT CHECK (month_of_year BETWEEN 1 AND 12),
    duration_days   INT DEFAULT 1,
    event_type      ENUM('Festival','Cultural','Adventure','Food','Music','Religious') NOT NULL,
    entry_fee       DECIMAL(10,2) DEFAULT 0.00,
    FOREIGN KEY (destination_id) REFERENCES Destinations(destination_id) ON DELETE CASCADE
);

-- ============================================================
-- TABLE 18: Guides
-- Local guides available for hire at each destination
-- ============================================================
CREATE TABLE IF NOT EXISTS Guides (
    guide_id        INT AUTO_INCREMENT PRIMARY KEY,
    destination_id  INT NOT NULL,
    guide_name      VARCHAR(100) NOT NULL,
    languages       VARCHAR(200),
    speciality      VARCHAR(150),
    experience_years INT,
    price_per_day   DECIMAL(10,2) NOT NULL,
    rating          DECIMAL(2,1) CHECK (rating BETWEEN 1.0 AND 5.0),
    phone           VARCHAR(15),
    certified       BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (destination_id) REFERENCES Destinations(destination_id) ON DELETE CASCADE
);

-- ============================================================
-- 10 NEW DESTINATIONS
-- (IDs will be 6–15 assuming 1–5 already exist)
-- ============================================================
INSERT INTO Destinations (city, country, description, best_season, image_url) VALUES
('Udaipur',    'India', 'City of Lakes — romantic palaces, shimmering lakes and Rajput royalty.',      'October–March',    'images/udaipur.jpg'),
('Rishikesh',  'India', 'Yoga capital of the world — Ganges rafting, ashrams and Himalayan foothills.','September–November','images/rishikesh.jpg'),
('Darjeeling', 'India', 'Queen of the Hills — toy train, Himalayan views and the finest tea on Earth.', 'March–May, Sep–Nov','images/darjeeling.jpg'),
('Shimla',     'India', 'Colonial hill station with snow-capped peaks, apple orchards and old-world charm.','March–June',    'images/shimla.jpg'),
('Varanasi',   'India', 'Oldest living city — sacred Ganga ghats, ancient temples and spiritual fire.',  'October–March',    'images/varanasi.jpg'),
('Agra',       'India', 'Home of the Taj Mahal — the greatest monument to love ever built.',             'October–March',    'images/agra.jpg'),
('Coorg',      'India', "India's Scotland — coffee estates, misty valleys, Tibetan culture and waterfalls.", 'October–March', 'images/coorg.jpg'),
('Ooty',       'India', 'Nilgiri queen — rolling tea gardens, botanical gardens and the famous toy train.','April–June',     'images/ooty.jpg'),
('Mysore',     'India', 'City of Palaces — Mysore Palace, silk sarees, sandalwood and Dasara grandeur.', 'October–March',   'images/mysore.jpg'),
('Hampi',      'India', 'UNESCO World Heritage — ruins of the Vijayanagara Empire across boulder landscapes.','October–February','images/hampi.jpg');

-- ============================================================
-- HOTELS FOR NEW CITIES
-- Destination IDs: Udaipur=6, Rishikesh=7, Darjeeling=8,
-- Shimla=9, Varanasi=10, Agra=11, Coorg=12, Ooty=13,
-- Mysore=14, Hampi=15
-- ============================================================

-- UDAIPUR (6)
INSERT INTO Hotels (hotel_name, destination_id, address, price_per_night, rating, amenities, available_rooms) VALUES
('Taj Lake Palace Udaipur',      6, 'Pichola Lake, Udaipur',           28000.00, 5.0, 'Lake Palace, Butler, Fine Dining, Spa, Infinity Pool', 5),
('Zostel Udaipur',               6, 'Gangaur Ghat, Udaipur',             850.00, 4.2, 'Lake View Rooftop, Dorm, Kayaking, WiFi', 24),
('Raas Devigarh',                6, 'Delwara, Rajsamand',              12000.00, 4.8, 'Heritage Fort, Pool, Panoramic Rajasthan Views', 10),
('Hotel Badi Haveli',            6, 'City Palace Road, Udaipur',        2400.00, 4.3, 'Heritage Haveli, Lake View, Rooftop, WiFi', 18),
('The Leela Palace Udaipur',     6, 'Lake Pichola, Udaipur',           19500.00, 4.9, 'Private Island, Spa, 3 Restaurants, Pool', 8);

-- RISHIKESH (7)
INSERT INTO Hotels (hotel_name, destination_id, address, price_per_night, rating, amenities, available_rooms) VALUES
('Zostel Rishikesh',             7, 'Swarg Ashram, Rishikesh',            750.00, 4.4, 'Ganga View, Yoga Deck, Dorm, Cafe', 28),
('Aloha on the Ganges',          7, 'Rishikesh Road, Rishikesh',         4500.00, 4.6, 'Riverside, Yoga Studio, Meditation, Ayurveda', 14),
('The Glasshouse on the Ganges', 7, 'Rishikesh Highway, Rishikesh',      7200.00, 4.7, 'Luxury Cottages, Spa, River View, Rafting', 10),
('Parmarth Niketan Ashram',      7, 'Swarg Ashram, Rishikesh',            600.00, 4.0, 'Ashram Stay, Meals, Ganga Aarti, Yoga', 40),
('Ananda in the Himalayas',      7, 'Narendra Nagar, Rishikesh',        22000.00, 5.0, 'Luxury Spa Resort, Yoga, Ayurveda, Himalayan View', 6);

-- DARJEELING (8)
INSERT INTO Hotels (hotel_name, destination_id, address, price_per_night, rating, amenities, available_rooms) VALUES
('The Elgin Darjeeling',         8, 'HD Lama Road, Darjeeling',          6500.00, 4.7, 'Heritage Colonial, Fireplace, Tea Lounge, Garden', 8),
('Zostel Darjeeling',            8, 'Gandhi Road, Darjeeling',             780.00, 4.3, 'Mountain View Terrace, Dorm, Cafe, Toy Train Nearby', 20),
('Glenburn Tea Estate',          8, 'Glenburn, Darjeeling',             14500.00, 4.9, 'Working Tea Estate, Colonial Bungalow, Tea Tours, Views', 4),
('Windamere Hotel',              8, 'Observatory Hill, Darjeeling',       8000.00, 4.6, '1939 Heritage Property, Fireplace, Kanchenjunga View', 6),
('Cedar Inn',                    8, 'Jalapahar Road, Darjeeling',         1800.00, 4.1, 'Mountain View, WiFi, Gardens, Breakfast', 14);

-- SHIMLA (9)
INSERT INTO Hotels (hotel_name, destination_id, address, price_per_night, rating, amenities, available_rooms) VALUES
('Wildflower Hall Shimla',       9, 'Chharabra, Shimla',               12000.00, 4.9, 'Oberoi Heritage, Spa, Cedar Forest View, Fine Dining', 8),
('Zostel Shimla',                9, 'The Ridge, Shimla',                   820.00, 4.2, 'City View, Dorm, Cafe, Mall Road Nearby', 22),
('The Cecil Shimla',             9, 'Chaura Maidan, Shimla',             7500.00, 4.7, 'Heritage Colonial, Spa, Lawn, Valley Views', 10),
('Hptdc Hotel Holiday Home',     9, 'Cart Road, Shimla',                 1500.00, 3.9, 'Budget, Valley View, Parking, Breakfast', 30),
('Kufri Holiday Resort',         9, 'Kufri, Shimla',                     3200.00, 4.3, 'Snow Sports Access, Bonfire, Mountain View, Heater', 16);

-- VARANASI (10)
INSERT INTO Hotels (hotel_name, destination_id, address, price_per_night, rating, amenities, available_rooms) VALUES
('Brijrama Palace Varanasi',    10, 'Darbhanga Ghat, Varanasi',          9500.00, 4.8, '18th Century Palace, Ganga View, Heritage, Fine Dining', 7),
('Zostel Varanasi',             10, 'Assi Ghat, Varanasi',                 700.00, 4.3, 'Ganga View, Dorm, Rooftop Cafe, Ghat Walks', 25),
('BrijRama Palace Heritage',    10, 'Munshi Ghat, Varanasi',             6500.00, 4.6, 'Heritage, Ghat View, Yoga, Boat Ride', 12),
('Hotel Ganges View',           10, 'Assi Ghat, Varanasi',               2800.00, 4.2, 'Ganges View, Rooftop, Traditional Decor, WiFi', 18),
('Taj Ganges Varanasi',         10, 'Nadan Mahal Road, Varanasi',        8500.00, 4.7, 'Luxury, Spa, Ayurveda, Pool, Heritage Decor', 20);

-- AGRA (11)
INSERT INTO Hotels (hotel_name, destination_id, address, price_per_night, rating, amenities, available_rooms) VALUES
('Oberoi Amarvilas',            11, 'Taj East Gate Road, Agra',         38000.00, 5.0, 'Taj Mahal View From Every Room, Butler, Fine Dining', 5),
('Zostel Agra',                 11, 'Taj Nagari, Agra',                    680.00, 4.1, 'Near Taj Mahal, Dorm, Rooftop, Tour Bookings', 22),
('ITC Mughal Agra',             11, 'Fatehabad Road, Agra',             12000.00, 4.8, 'Mughal Gardens, Spa, 5 Restaurants, Pool', 10),
('Hotel Taj Resorts',           11, 'Fatehabad Road, Agra',              2200.00, 4.0, 'Near Taj, WiFi, Pool, Breakfast', 25),
('The Coral Tree Homestay',     11, 'Civil Lines, Agra',                 1800.00, 4.5, 'Boutique, Garden, Homemade Meals, Heritage Tours', 8);

-- COORG (12)
INSERT INTO Hotels (hotel_name, destination_id, address, price_per_night, rating, amenities, available_rooms) VALUES
('Evolve Back Coorg',           12, 'Kakkabe, Coorg',                   18000.00, 4.9, 'Luxury Cottages, Coffee Estate, Spa, Nature Walks', 6),
('Zostel Coorg',                12, 'Madikeri, Coorg',                     820.00, 4.2, 'Coffee Estate View, Dorm, Trekking, Cafe', 20),
('Taj Madikeri Resort',         12, 'Galibeedu, Madikeri',               9500.00, 4.7, 'Tree Canopy Resort, Spa, Nature, Coffee Estate Tour', 12),
('The Tamara Coorg',            12, 'Yavakapady, Coorg',                 7200.00, 4.6, 'Rainforest, Coffee Plantation, Spa, Wildlife', 10),
('Orange County Resort',        12, 'Siddapur, Coorg',                   6800.00, 4.5, 'Plantation Resort, Pool, Outdoor Activities, Cooking Class', 14);

-- OOTY (13)
INSERT INTO Hotels (hotel_name, destination_id, address, price_per_night, rating, amenities, available_rooms) VALUES
('Taj Savoy Hotel Ooty',        13, 'Sylks Road, Ooty',                  7500.00, 4.7, 'Heritage 1829 Property, Fireplace, Tea Garden, Lawn', 8),
('Zostel Ooty',                 13, 'Charing Cross, Ooty',                 760.00, 4.1, 'Tea Garden View, Dorm, Cafe, Toy Train Nearby', 18),
('Sterling Elk Hill Ooty',      13, 'Fernhill Road, Ooty',               4500.00, 4.4, 'Valley Views, Bonfire, Trekking, Cozy Rooms', 16),
('The Monarch Hotel Ooty',      13, 'Commercial Road, Ooty',             2200.00, 4.0, 'Central Location, WiFi, Valley View, Breakfast', 20),
('Glenary Guest House',         13, 'Charing Cross, Ooty',               1200.00, 3.9, 'Budget, Tea Estate Walk, Garden, Breakfast', 12);

-- MYSORE (14)
INSERT INTO Hotels (hotel_name, destination_id, address, price_per_night, rating, amenities, available_rooms) VALUES
('Radisson Blu Plaza Mysore',   14, 'New Sayyaji Rao Road, Mysore',      6500.00, 4.6, 'City Views, Pool, Spa, Fine Dining, Palace Nearby', 15),
('Zostel Mysore',               14, 'Shivarampet, Mysore',                 750.00, 4.3, 'City Centre, Dorm, Cycle Tours, Rooftop Cafe', 22),
('Lalitha Mahal Palace Hotel',  14, 'T Narasipura Road, Mysore',         8500.00, 4.7, 'Heritage Palace Hotel, Billiards, Grand Staircase, Pool', 8),
('Green Hotel Mysore',          14, 'Chittaranjan Palace, Mysore',       3200.00, 4.4, 'Eco Hotel, Heritage Property, Organic Garden, Restaurant', 12),
('Hotel Mayura Hoysala',        14, 'Jhansi Lakshmibai Road, Mysore',    1600.00, 3.8, 'KSTDC Budget Property, WiFi, Restaurant, City Access', 25);

-- HAMPI (15)
INSERT INTO Hotels (hotel_name, destination_id, address, price_per_night, rating, amenities, available_rooms) VALUES
('Evolve Back Hampi',           15, 'Kamalapura, Hampi',                16000.00, 4.9, 'Luxury Boutique, Ruins View, Pool, Heritage Tours', 8),
('Zostel Hampi',                15, 'Virupapur Gadde, Hampi',              680.00, 4.5, 'Riverside, Bouldering, Yoga, Hippie Vibe, Dorm', 26),
('Kishkinda Heritage Resort',   15, 'Gangavati Road, Hospet',            3500.00, 4.3, 'Near Ruins, Pool, Cultural Shows, Heritage Walks', 14),
('The Boulders',                15, 'Virupapur Gadde, Hampi',            2200.00, 4.4, 'Riverside Cottages, Bouldering, Cycling, Cafe', 10),
('Hampi Boulders',              15, 'Nagerhal, Hampi',                   4500.00, 4.6, 'Eco Cottages, Rock Boulders, Pool, Ruins View', 6);

-- ============================================================
-- TOURIST SPOTS FOR NEW CITIES (5–6 per city)
-- ============================================================

-- UDAIPUR (6)
INSERT INTO TouristSpots (spot_name, destination_id, description, entry_fee, opening_hours, category) VALUES
('City Palace Udaipur',  6, 'Magnificent palace complex on Lake Pichola — largest palace in Rajasthan, built over 400 years.',        100.00, '09:30–17:30', 'Heritage'),
('Lake Pichola',         6, 'Shimmering lake at heart of Udaipur — boat rides reveal the iconic Jag Niwas and Jag Mandir palaces.',     50.00, '08:00–18:00', 'Nature'),
('Jag Mandir Island',    6, 'Stunning island palace on Lake Pichola used as refuge by Shah Jahan. Reached by boat.',                   400.00, '10:00–18:00', 'Heritage'),
('Sajjangarh Monsoon Palace',6,'Hilltop fort with panoramic city and lake views — especially magical at sunset.',                       80.00, '08:00–18:00', 'Heritage'),
('Bagore Ki Haveli',     6, '18th-century haveli on Gangaur Ghat with 100-room museum and nightly Rajasthani cultural shows.',          60.00, '10:00–17:30', 'Culture'),
('Fateh Sagar Lake',     6, 'Beautiful artificial lake with boating, Nehru Island garden and panoramic Aravalli backdrop.',             30.00, '08:00–20:00', 'Nature');

-- RISHIKESH (7)
INSERT INTO TouristSpots (spot_name, destination_id, description, entry_fee, opening_hours, category) VALUES
('Laxman Jhula',         7, 'Iconic iron suspension bridge over the Ganges, 450m long — sacred and scenic in equal measure.',           0.00, '24 hours',    'Heritage'),
('Triveni Ghat',         7, 'Sacred bathing ghat where Ganga, Yamuna and Saraswati meet. Nightly aarti is deeply moving.',             0.00, '05:00–21:00', 'Spiritual'),
('Neelkanth Mahadev Temple',7,'Ancient Shiva temple in the mountains, 32 km from Rishikesh — a beautiful trek or scenic drive.',       0.00, '06:00–18:00', 'Spiritual'),
('Beatles Ashram',       7, 'Maharishi Mahesh Yogi''s ashram where the Beatles stayed in 1968 — covered in surreal wall murals.',     600.00, '09:00–17:00', 'Culture'),
('Rajaji National Park', 7, 'Wildlife sanctuary with elephants, leopards, tigers and 315 bird species at the Himalayan foothills.',    150.00, '06:00–17:00', 'Nature'),
('Ganga Beach Rishikesh',7, 'Sandy beach on the Ganges — yoga at sunrise, bonfire at night, and world-class white water nearby.',       0.00, '24 hours',    'Beach');

-- DARJEELING (8)
INSERT INTO TouristSpots (spot_name, destination_id, description, entry_fee, opening_hours, category) VALUES
('Tiger Hill Sunrise',   8, 'Most famous sunrise viewpoint in India — Kanchenjunga and even Everest on clear mornings at 2,590m.',     0.00, '04:00–08:00', 'Nature'),
('Darjeeling Himalayan Railway',8,'UNESCO toy train chugging through mountain loops since 1881 — a journey through colonial history.',  1200.00,'08:00–17:00','Heritage'),
('Happy Valley Tea Estate',8, 'Living 19th-century tea estate with guided plantation walks and factory tours. Famous FTGFOP1 tea.',     100.00, '08:00–16:30', 'Culture'),
('Padmaja Naidu Zoo',    8, 'Home to red pandas, snow leopards and Himalayan wolves — highest-altitude zoo in India.',                 100.00, '08:30–16:30', 'Nature'),
('Batasia Loop',         8, 'Spectacular spiral railway loop with Himalayan panorama and Gorkha War Memorial.',                          0.00, '06:00–18:00', 'Heritage'),
('Ghoom Monastery',      8, 'One of the most important Buddhist monasteries in Darjeeling — houses a 15-foot Maitreya Buddha.',         0.00, '07:00–17:00', 'Heritage');

-- SHIMLA (9)
INSERT INTO TouristSpots (spot_name, destination_id, description, entry_fee, opening_hours, category) VALUES
('The Ridge Shimla',     9, 'Heart of Shimla — colonial promenade with Christ Church, open sky and panoramic Himalayan views.',          0.00, '24 hours',    'Heritage'),
('Jakhu Temple',         9, 'Ancient Hanuman temple at 2455m. 33m statue of Hanuman visible from the city. Sacred and spectacular.',    0.00, '07:00–20:00', 'Spiritual'),
('Kufri Adventure Park', 9, 'Snow activities, yak rides, skiing and zorbing — best from December to February.',                        200.00, '09:00–17:00', 'Adventure'),
('Shimla State Museum',  9, 'Colonial-era museum with Pahari miniature paintings, sculptures and Himachal heritage artefacts.',          50.00, '10:00–17:00', 'Culture'),
('Mall Road Shimla',     9, 'The iconic Victorian-era pedestrian promenade lined with colonial buildings, cafes and handicraft shops.',   0.00, '24 hours',    'Culture'),
('Chail Wildlife Sanctuary',9,'Dense mixed forest with leopards, ghoral and Himalayan birds — great for nature walks.',                 100.00, '06:00–18:00', 'Nature');

-- VARANASI (10)
INSERT INTO TouristSpots (spot_name, destination_id, description, entry_fee, opening_hours, category) VALUES
('Dashashwamedh Ghat',  10, 'Main ghat on the Ganges — the nightly Ganga Aarti ceremony here with fire and flowers is transcendent.',    0.00, '05:00–22:00', 'Spiritual'),
('Kashi Vishwanath Temple',10,'One of the 12 Jyotirlinga temples — sacred to Shiva, rebuilt by Maharani Ahilyabai in 1780.',             0.00, '03:00–23:00', 'Spiritual'),
('Sarnath',             10, 'Where Buddha gave his first sermon — 5th-century Dhamek Stupa, Ashoka Pillar and superb museum.',         100.00, '09:00–17:00', 'Heritage'),
('Manikarnika Ghat',    10, 'The ancient cremation ghat that burns 24/7 — a profound and humbling glimpse into life and death.',          0.00, '24 hours',    'Spiritual'),
('Banaras Hindu University',10,'Asia''s largest residential university campus with Bharat Kala Bhavan art museum.',                      0.00, '09:00–17:00', 'Culture'),
('Morning Boat Ride',   10, 'Sunrise boat ride on the Ganges past all the ghats — the most magical two hours in all of India.',         200.00, '05:00–07:00', 'Culture');

-- AGRA (11)
INSERT INTO TouristSpots (spot_name, destination_id, description, entry_fee, opening_hours, category) VALUES
('Taj Mahal',           11, 'The greatest monument to love ever built — UNESCO World Heritage, built 1632–1653 by Shah Jahan.',       1100.00, '06:00–18:30', 'Heritage'),
('Agra Fort',           11, 'Massive Mughal fort (UNESCO) where Shah Jahan was imprisoned and could only see the Taj from a window.',   550.00, '06:00–18:00', 'Heritage'),
('Fatehpur Sikri',      11, 'Abandoned Mughal ghost city 37 km from Agra — perfectly preserved red sandstone palaces and mosques.',    610.00, '06:00–18:00', 'Heritage'),
('Mehtab Bagh',         11, 'Moonlit garden directly opposite the Taj Mahal — best sunset view of the white marble masterpiece.',       300.00, '06:00–18:00', 'Nature'),
('Itimad-ud-Daulah',    11, 'Baby Taj — intricate marble tomb predating the Taj, considered its prototype. Underrated gem!',           310.00, '06:00–18:00', 'Heritage'),
('Kinari Bazaar Agra',  11, 'Centuries-old bazaar for marble inlay work, leather goods, petha sweets and Zardozi embroidery.',          0.00, '10:00–20:00', 'Culture');

-- COORG (12)
INSERT INTO TouristSpots (spot_name, destination_id, description, entry_fee, opening_hours, category) VALUES
('Abbey Falls',         12, 'Stunning 70-foot waterfall surrounded by coffee and spice plantations — best after monsoon.',              50.00, '09:00–17:00', 'Nature'),
('Raja''s Seat Madikeri',12,'Garden pavilion where Coorg kings watched sunsets over misty valleys — legendary sunrise viewpoint.',       10.00, '05:30–19:00', 'Nature'),
('Dubare Elephant Camp',12, 'Interactive elephant camp on the banks of the Cauvery — morning bathing ceremony is unmissable.',         300.00, '08:00–10:30', 'Nature'),
('Namdroling Monastery',12, 'Golden Temple of the Nyingma Institute — stunning Tibetan Buddhist monastery with 40-foot Buddha.',         0.00, '09:00–18:00', 'Heritage'),
('Coorg Coffee Plantation',12,'Guided walk through working arabica and robusta plantations — learn the full farm-to-cup process.',      200.00, '09:00–17:00', 'Culture'),
('Irupu Falls',         12, 'Sacred cascade in the Brahmagiri Wildlife Sanctuary — combined with forest trekking and wildlife.',         30.00, '06:00–18:00', 'Nature');

-- OOTY (13)
INSERT INTO TouristSpots (spot_name, destination_id, description, entry_fee, opening_hours, category) VALUES
('Ooty Botanical Gardens',13,'151-year-old gardens at 2240m with 1000+ plant species, fossilised tree trunk and annual flower show.',   30.00, '07:00–18:30', 'Nature'),
('Doddabetta Peak',     13, 'Highest peak in the Nilgiris at 2637m — observatory and sweeping views of Tamil Nadu and Karnataka.',       5.00, '08:00–18:00', 'Nature'),
('Ooty Lake',           13, 'Artificial lake built in 1824 — boating, mini train ride along the shore and surrounding eucalyptus.',     15.00, '09:00–18:00', 'Nature'),
('Nilgiri Mountain Railway',13,'UNESCO toy train through the Nilgiri hills — 46km of tunnels, bridges and mountain scenery since 1908.',850.00, '07:00–17:00', 'Heritage'),
('Rose Garden Ooty',    13, 'Largest rose garden in India with 20,000+ varieties — especially glorious in April–May bloom season.',      30.00, '08:00–18:30', 'Nature'),
('Tea Museum Ooty',     13, 'Museum inside a working tea factory — learn how Nilgiri tea is processed, plus tastings.',                  50.00, '09:00–17:00', 'Culture');

-- MYSORE (14)
INSERT INTO TouristSpots (spot_name, destination_id, description, entry_fee, opening_hours, category) VALUES
('Mysore Palace',       14, 'One of the most visited sites in India — Indo-Saracenic masterpiece illuminated by 100,000 bulbs on Sundays.', 200.00,'10:00–17:30','Heritage'),
('Chamundeshwari Temple',14,'Hilltop temple to the fierce goddess, 12 km from city — panoramic Mysore views from 1062m.',               0.00, '07:30–14:00', 'Spiritual'),
('Brindavan Gardens',   14, 'Terraced gardens at the KRS Dam — famous for musical fountain show every evening at sunset.',              20.00, '06:00–20:00', 'Nature'),
('Somnathpur Hoysala Temple',14,'13th-century star-shaped Hoysala temple with intricate friezes — called the "Jewel of Hoysala art".',  25.00, '09:00–17:30', 'Heritage'),
('Devaraja Market Mysore',14,'A riot of colour and fragrance — jasmine, silk sarees, sandalwood, spices and Mysore Pak sweets.',         0.00, '07:00–20:00', 'Culture'),
('Sri Jayachamarajendra Art Gallery',14,'Royal art collection in Jaganmohan Palace — 12th-century wood-carvings to 20th-century paintings.',0.00,'08:30–17:30','Culture');

-- HAMPI (15)
INSERT INTO TouristSpots (spot_name, destination_id, description, entry_fee, opening_hours, category) VALUES
('Virupaksha Temple',   15, '7th-century temple to Shiva — oldest still-functioning temple in the world, Hampi''s spiritual heart.',     50.00, '08:00–12:30', 'Spiritual'),
('Vittala Temple Complex',15,'15th-century masterpiece with the famous Stone Chariot and Musical Pillars that emit musical notes.',     600.00, '08:30–17:30', 'Heritage'),
('Hampi Bazaar',        15, 'Ancient 13-km royal road lined with ruins of market stalls, temples and pavilions of the empire.',           0.00, '06:00–18:00', 'Heritage'),
('Matanga Hill',        15, 'Best 360° sunrise viewpoint over Hampi — boulders, temples and the Tungabhadra glittering below.',           0.00, '05:00–17:00', 'Nature'),
('Queen''s Bath',       15, 'Exquisite lotus-shaped royal bathhouse with elaborate water inlet system — stunning Vijayanagara engineering.',50.00,'08:00–17:30','Heritage'),
('Tungabhadra River',   15, 'Coracle (circular basket boat) rides on the sacred river past ruins — totally unique Hampi experience.',    200.00, '07:00–17:30', 'Nature');

-- ============================================================
-- TRANSPORT TO NEW CITIES
-- ============================================================
INSERT INTO Transport (type, operator_name, source, destination, departure_time, arrival_time, fare, available_seats) VALUES
-- Udaipur
('Flight','IndiGo',         'Delhi',    'Udaipur',   '07:00:00','08:10:00', 3800.00, 160),
('Flight','Air India',      'Mumbai',   'Udaipur',   '10:30:00','11:45:00', 3200.00, 150),
('Train', 'Indian Railways','Delhi',    'Udaipur',   '18:05:00','07:45:00',  450.00, 200),
('Train', 'Indian Railways','Mumbai',   'Udaipur',   '22:00:00','14:00:00',  600.00, 180),
('Bus',  'RSRTC',           'Jaipur',   'Udaipur',   '06:00:00','12:00:00',  350.00,  44),
-- Rishikesh
('Flight','IndiGo',         'Delhi',    'Dehradun',  '07:30:00','08:20:00', 2800.00, 180),
('Train', 'Indian Railways','Delhi',    'Haridwar',  '07:40:00','12:30:00',  280.00, 200),
('Bus',  'UPSRTC Volvo',    'Delhi',    'Rishikesh', '23:00:00','06:00:00',  480.00,  40),
('Bus',  'GMOU',            'Haridwar', 'Rishikesh', '06:00:00','07:00:00',   50.00,  50),
-- Darjeeling
('Flight','IndiGo',         'Delhi',    'Bagdogra',  '06:15:00','08:30:00', 4500.00, 180),
('Flight','SpiceJet',       'Kolkata',  'Bagdogra',  '09:00:00','10:15:00', 2200.00, 160),
('Train', 'Indian Railways','Kolkata',  'NJP',       '20:00:00','07:00:00',  500.00, 200),
('Bus',  'NBSTC',           'Siliguri', 'Darjeeling','08:00:00','12:00:00',  120.00,  44),
-- Shimla
('Flight','Air India',      'Delhi',    'Shimla',    '08:30:00','09:20:00', 4200.00,  18),
('Bus',  'HRTC',            'Delhi',    'Shimla',    '21:30:00','07:30:00',  680.00,  40),
('Train', 'Indian Railways','Kalka',    'Shimla',    '05:30:00','09:25:00',  210.00,  60),
('Train', 'Indian Railways','Delhi',    'Kalka',     '17:30:00','22:30:00',  280.00, 150),
-- Varanasi
('Flight','IndiGo',         'Delhi',    'Varanasi',  '06:45:00','07:55:00', 3500.00, 180),
('Flight','Air India',      'Mumbai',   'Varanasi',  '11:00:00','12:30:00', 4800.00, 150),
('Train', 'Indian Railways','Delhi',    'Varanasi',  '18:40:00','07:30:00',  550.00, 200),
('Train', 'Indian Railways','Mumbai',   'Varanasi',  '14:00:00','10:00:00',  700.00, 180),
-- Agra
('Train', 'Indian Railways','Delhi',    'Agra',      '06:00:00','07:40:00',  250.00, 200),
('Bus',  'UPSRTC',          'Delhi',    'Agra',      '06:00:00','09:30:00',  350.00,  44),
('Flight','IndiGo',         'Mumbai',   'Agra',      '08:00:00','09:30:00', 4200.00, 180),
('Train', 'Indian Railways','Jaipur',   'Agra',      '07:15:00','10:30:00',  200.00, 150),
-- Coorg
('Flight','IndiGo',         'Mumbai',   'Bangalore', '08:30:00','10:00:00', 3200.00, 180),
('Flight','Air India',      'Delhi',    'Bangalore', '06:15:00','08:45:00', 4800.00, 180),
('Bus',  'KSRTC',           'Bangalore','Coorg',     '20:00:00','05:00:00',  550.00,  40),
('Bus',  'KSRTC',           'Mysore',   'Coorg',     '07:00:00','10:30:00',  200.00,  44),
-- Ooty
('Flight','SpiceJet',       'Bangalore','Coimbatore','09:00:00','10:00:00', 2800.00, 180),
('Train', 'Indian Railways','Bangalore','Coimbatore','21:00:00','05:30:00',  380.00, 200),
('Bus',  'TNSTC',           'Coimbatore','Ooty',     '06:00:00','09:30:00',  120.00,  44),
('Bus',  'KSRTC',           'Bangalore','Ooty',      '21:00:00','07:00:00',  480.00,  40),
-- Mysore
('Train', 'Indian Railways','Bangalore','Mysore',    '06:10:00','08:30:00',  130.00, 200),
('Bus',  'KSRTC',           'Bangalore','Mysore',    '06:00:00','09:00:00',  150.00,  50),
('Flight','IndiGo',         'Delhi',    'Mysore',    '07:00:00','09:30:00', 5200.00, 180),
-- Hampi
('Flight','Air India',      'Bangalore','Hubli',     '08:00:00','09:00:00', 3200.00, 70),
('Train', 'Indian Railways','Bangalore','Hospet',    '22:00:00','07:00:00',  350.00, 150),
('Bus',  'KSRTC',           'Bangalore','Hampi',     '20:00:00','05:30:00',  450.00,  40);

-- ============================================================
-- BUDGET PACKAGES FOR NEW CITIES (3 per city)
-- ============================================================
INSERT INTO BudgetPackages (package_name, destination_id, total_cost, duration_days, description, max_people) VALUES
-- Udaipur (6)
('Udaipur Royal Romance',       6, 22000.00, 4, 'Lake Pichola boat ride, City Palace, Bagore Ki Haveli cultural show and Rajasthani dinner.', 2),
('Udaipur Heritage Explorer',   6, 13500.00, 3, 'Heritage haveli stay, guided palace tours, bazaar shopping and sunset at Sajjangarh.', 4),
('Udaipur Luxury Lake Escape',  6, 65000.00, 5, 'Taj Lake Palace or Leela Palace stay, private boat, spa, fine dining, royal experiences.', 2),
-- Rishikesh (7)
('Rishikesh Yoga & Rafting',    7, 11000.00, 4, 'Ashram or riverside stay, yoga daily, Ganga Aarti, white-water rafting and Neer Garh trek.', 2),
('Rishikesh Adventure Camp',    7, 14000.00, 5, 'Camping on Ganga bank, Grade 3–4 rafting, bungee jumping, flying fox, cliff jumping.', 4),
('Rishikesh Wellness Retreat',  7, 38000.00, 7, 'Ananda in the Himalayas spa resort, Panchakarma Ayurveda, daily yoga, Himalayan meditation.', 1),
-- Darjeeling (8)
('Darjeeling Tea & Mountains',  8, 14500.00, 4, 'Tea estate stay, Tiger Hill sunrise, toy train joy ride and Kanchenjunga panorama.', 2),
('Darjeeling Himalayan Explorer',8,18000.00, 5, 'Glenburn estate stay, Sandakphu trek planning, monastery visits and tea factory tour.', 2),
('Darjeeling Budget Escape',    8,  9500.00, 3, 'Zostel stay, Tiger Hill sunrise, toy train, tea gardens and Happy Valley factory.', 1),
-- Shimla (9)
('Shimla Snow Holiday',         9, 16000.00, 4, 'Colonial hotel, Kufri snow sports, Mall Road stroll, Jakhu Temple and apple orchard walk.', 4),
('Shimla Luxury Hill Retreat',  9, 45000.00, 5, 'Wildflower Hall stay, cedar forest spa, valley walks, Chail cricket ground visit.', 2),
('Shimla Budget Explorer',      9,  9000.00, 3, 'Zostel stay, city heritage walk, Scandal Point, Mall Road, Indian Coffee House breakfast.', 1),
-- Varanasi (10)
('Varanasi Spiritual Journey',  10, 12000.00, 4, 'Ghat hotel stay, sunrise boat ride, Kashi Vishwanath darshan, Ganga Aarti, Sarnath.', 2),
('Varanasi Heritage & Soul',    10, 18000.00, 5, 'Palace hotel on the ghats, evening aarti ceremony, silk weaving workshop, old city walk.', 2),
('Varanasi Budget Pilgrim',     10,  7500.00, 3, 'Ghat guesthouse, boat ride at dawn, temple visits, street food walk in the old city.', 1),
-- Agra (11)
('Agra Taj Mahal Experience',   11, 10000.00, 2, 'Taj Mahal sunrise + sunset visit, Agra Fort, Mehtab Bagh moonview and Mughal cuisine.', 2),
('Agra Golden Triangle',        11, 24000.00, 4, 'Delhi–Agra–Jaipur with guide, 4-star hotels, Taj Mahal, Amber Fort, Qutub Minar.', 2),
('Agra Luxury Taj Stay',        11, 55000.00, 2, 'Oberoi Amarvilas — every room faces the Taj Mahal, sunset dining, private guided tour.', 2),
-- Coorg (12)
('Coorg Coffee & Wilderness',   12, 16000.00, 4, 'Plantation resort, coffee estate tour, Dubare elephant camp, Abbey Falls, Brahmagiri trek.', 2),
('Coorg Luxury Plantation',     12, 38000.00, 5, 'Evolve Back or Taj Madikeri, spa, wildlife safari, coffee trail, private jungle dining.', 2),
('Coorg Budget Explorer',       12,  9500.00, 3, 'Zostel stay, Raja''s Seat sunrise, Abbey Falls, Namdroling Monastery, local café hop.', 1),
-- Ooty (13)
('Ooty Hill Station Escape',    13, 11000.00, 3, 'Heritage hotel, toy train, Botanical Gardens, Doddabetta peak and Ooty lake boating.', 2),
('Ooty Family Holiday',         13, 14000.00, 4, 'Sterling resort, Rose Garden, Tea Museum, Avalanche Lake, Pykara waterfall, toy train.', 4),
('Ooty Nilgiri Tea Trail',      13, 22000.00, 4, 'Taj Savoy stay, private tea estate tours, tea blending masterclass, valley cycle tour.', 2),
-- Mysore (14)
('Mysore Royal Heritage Tour',  14, 13000.00, 3, 'Palace hotel stay, Mysore Palace illumination, Chamundeshwari temple, Devaraja market.', 2),
('Mysore to Coorg Explorer',    14, 22000.00, 5, 'Mysore palace + Somnathpur, drive to Coorg, coffee estate, waterfalls, Dubare elephants.', 2),
('Mysore Budget City Break',    14,  8000.00, 2, 'Zostel stay, palace guided tour, brindavan gardens, silk saree shopping, local biryani.', 1),
-- Hampi (15)
('Hampi Ruins & Boulders',      15, 12000.00, 3, 'Riverside stay, Vittala Temple, Virupaksha Temple, Matanga Hill sunrise, coracle ride.', 2),
('Hampi Heritage & Hippie Vibe',15, 15000.00, 4, 'Zostel stay, all major ruins, boulder sunset, coracle, local cafes, cycling tour.', 2),
('Hampi Luxury Heritage',       15, 42000.00, 4, 'Evolve Back resort, private ruins tour, sunset champagne at Matanga, archaeology guide.', 2);

-- ============================================================
-- TRAVEL TIPS FOR ALL 15 DESTINATIONS
-- ============================================================
INSERT INTO TravelTips (destination_id, category, tip_text) VALUES
-- Goa (1)
(1,'Packing',   'Pack reef-safe sunscreen, a light sarong, flip-flops and a waterproof bag for beach days.'),
(1,'Culture',   'Dress modestly when visiting churches and temples — beachwear stays on the beach.'),
(1,'Budget',    'Eat at local shacks on the beach rather than tourist restaurants — same view, half the price, better food.'),
(1,'Safety',    'Avoid isolated beaches after dark. Keep valuables in hotel safes during water sports.'),
(1,'Transport', 'Rent a scooter — it''s the best way to explore both North and South Goa at your own pace (₹300–400/day).'),
-- Manali (2)
(2,'Packing',   'Even in summer, pack layers — temperatures drop to 10°C at night. Waterproof jacket essential.'),
(2,'Culture',   'Ask permission before photographing local Himachali women, especially in traditional dress.'),
(2,'Safety',    'Rohtang Pass requires a permit (book online 1 day ahead). Never trek alone in remote areas.'),
(2,'Transport', 'Overnight Volvo bus from Delhi is comfortable and saves a hotel night. Book 3–4 days in advance.'),
(2,'Food',      'Try Sidu (local bread) with ghee at any dhaba in Old Manali — heavenly and costs ₹30.'),
-- Jaipur (3)
(3,'Packing',   'Light cotton in summer; layer up November–January when evenings drop to 8°C.'),
(3,'Culture',   'Bargaining is expected in bazaars — start at 40–50% of the asking price and meet in the middle.'),
(3,'Budget',    'Buy a composite ticket at Amber Fort — it covers 5 monuments and saves around ₹300.'),
(3,'Food',      'The best dal baati churma in Jaipur is served at Chokhi Dhani — the full cultural experience is worth it.'),
(3,'Safety',    'Watch out for gem shop touts near tourist sites offering "factory prices" — it''s a well-known scam.'),
-- Kerala (4)
(4,'Packing',   'Pack quick-dry clothes, strong mosquito repellent and a light rain poncho — humidity is always high.'),
(4,'Culture',   'Remove shoes before entering temples and be respectful during Kathakali and Theyyam performances.'),
(4,'Budget',    'Hire an autorickshaw for short distances and negotiate the fare before getting in.'),
(4,'Food',      'Eat a proper Kerala sadya (banana leaf feast) on a Sunday at any local restaurant — life-changing.'),
(4,'Transport', 'State water transport (ferries) between Alleppey and Kottayam costs ₹15 — far more scenic than buses.'),
-- Ladakh (5)
(5,'Packing',   'Pack SPF 50+ sunscreen, UV sunglasses, warm layers for nights and a quality water bottle. UV radiation is extreme at altitude.'),
(5,'Safety',    'Acclimatise for 2 full days in Leh before any trek or high-altitude drive. Altitude sickness is serious.'),
(5,'Transport', 'Book Leh flights 6–8 weeks ahead — they sell out extremely fast. Have a contingency if weather cancels them.'),
(5,'Culture',   'Always walk clockwise around stupas and prayer walls. Ask permission at monasteries before photographing monks.'),
(5,'Budget',    'Hire a shared jeep from Leh market for Pangong and Nubra — far cheaper than private hire, and you meet great people.'),
-- Udaipur (6)
(6,'Packing',   'Comfortable walking shoes for cobbled old city lanes. Light cotton in summer; evenings cool in winter.'),
(6,'Culture',   'Evenings at Bagore Ki Haveli cultural show are unmissable — book ahead during peak season (Oct–Mar).'),
(6,'Budget',    'A public ferry on Lake Pichola to Jag Mandir costs just ₹400 round trip — much cheaper than private boats.'),
(6,'Food',      'Gatte ki sabzi, dal baati and the legendary Rajasthani thali at Ambrai restaurant with lake view is perfection.'),
(6,'Transport', 'Udaipur is compact enough to walk — hire a cycle rickshaw for the old city rather than an auto.'),
-- Rishikesh (7)
(7,'Packing',   'Carry a yoga mat, comfortable loose clothing and waterproof sandals for the ghats.'),
(7,'Safety',    'Book rafting only with GMVN-certified operators. Never raft in July–August (dangerous water levels).'),
(7,'Culture',   'Rishikesh is a dry city — alcohol is strictly prohibited. Respect the spiritual atmosphere.'),
(7,'Food',      'Chotiwala restaurant near Laxman Jhula has legendary thalis since 1958. The brown rice at the cafes in Laxman Jhula is amazing.'),
(7,'Budget',    'Ganga beach yoga at sunrise is free. Many cafes offer free yoga classes if you eat with them.'),
-- Darjeeling (8)
(8,'Packing',   'Warm layers are essential year-round — temperatures can dip below 5°C even in summer mornings.'),
(8,'Transport', 'Book the toy train at least 3–4 days ahead, especially during spring (March–May) and autumn.'),
(8,'Food',      'Keventers on Mall Road has served the same milkshakes since 1934. Glenary''s bakery is legendary.'),
(8,'Budget',    'Tiger Hill jeep sharing costs ₹120–150 per person — never pay for a private jeep when shared is available.'),
(8,'Culture',   'Learn a few words of Nepali — locals deeply appreciate the effort and it opens up real hospitality.'),
-- Shimla (9)
(9,'Packing',   'Woolens from October to March — even April can be cold. Strong walking shoes for the steep lanes.'),
(9,'Transport', 'The Kalka-Shimla toy train is an experience in itself — book 2 weeks ahead for window seats.'),
(9,'Budget',    'Avoid hotels on Mall Road — walk 10 minutes down and prices halve immediately.'),
(9,'Food',      'Indian Coffee House on the Mall has served the same menu since 1957. Order the cheese toast.'),
(9,'Safety',    'The Mall Road and Ridge area are car-free pedestrian zones — leave your vehicle at the parking lot below.'),
-- Varanasi (10)
(10,'Packing',  'Pack clothes you don''t mind getting marked with ash or water from the ghats. Modesty is important.'),
(10,'Culture',  'The Ganga Aarti ceremony at Dashashwamedh Ghat at dusk is profound — arrive 30 minutes early for a good spot.'),
(10,'Safety',   'Watch for Ganges water — don''t swim or bathe unless you''re specifically at bathing ghats. Keep valuables close in crowded alleys.'),
(10,'Food',     'Try malaiyo (winter fog milk dessert), thandai, banarasi paan, and the kachori sabzi at morning ghats.'),
(10,'Budget',   'Hire a local guide for the old city lanes — ₹500 well spent and you''ll find temples tourists never see.'),
-- Agra (11)
(11,'Packing',  'Visit the Taj at sunrise — gates open at 6am and the golden light is magical. Carry a camera with a good lens.'),
(11,'Budget',   'The composite ticket covers Taj Mahal + Agra Fort + Fatehpur Sikri + 2 other monuments — great value.'),
(11,'Safety',   'Beware of unofficial "guides" outside Taj Mahal gate — only hire ITDC-certified guides inside.'),
(11,'Food',     'Petha (sweet gourd candy) from Pancchi Petha shop near Agra Fort is the authentic souvenir to bring home.'),
(11,'Transport','Agra is only 2 hours from Delhi on the Gatimaan Express — the fastest and most comfortable option.'),
-- Coorg (12)
(12,'Packing',  'Pack rain gear even in winter — mist and drizzle appear suddenly. Leeches after monsoon — tuck trousers in socks.'),
(12,'Culture',  'Kodavas (Coorg people) are very proud of their warrior heritage and cuisine — compliment their Pandi Curry!'),
(12,'Food',     'Pandi (pork) curry with kadambuttu (steamed rice balls) is the iconic Coorg dish — try it at any homestay.'),
(12,'Budget',   'Homestays in Coorg offer better food, more personal experiences and lower prices than resorts.'),
(12,'Transport','Hire a cab from Madikeri — public buses are infrequent and distances between attractions are large.'),
-- Ooty (13)
(13,'Packing',  'Carry woolens — even in summer, mornings and evenings are cold. April–May has the best flower show.'),
(13,'Transport','Book Nilgiri Mountain Railway tickets months in advance for the famous Mettupalayam-Ooty route.'),
(13,'Food',     'Ooty Homemade Chocolate shops on Commercial Street are legendary. Also try varkey and aval payasam.'),
(13,'Budget',   'TNSTC government buses connect all major Ooty attractions cheaply. The local bus to Doddabetta costs ₹15.'),
(13,'Culture',  'The Toda tribal community lives in distinctive barrel-shaped huts — ethical tribal tourism available at Ooty.'),
-- Mysore (14)
(14,'Packing',  'Visit Mysore Palace on a Sunday evening when 100,000 light bulbs illuminate the palace — absolutely magical.'),
(14,'Culture',  'October Dasara Festival is when Mysore is at its most spectacular — book accommodation 6 months ahead!'),
(14,'Food',     'Mysore Pak from Sri Krishna Sweets, Mysore Masala Dosa, Bisi Bele Bath and the famous Mysore Sandal soap!'),
(14,'Budget',   'Mysore is very budget-friendly — excellent state-run KSTDC hotels and local dhabas everywhere.'),
(14,'Transport','Mysore is only 3 hours by train from Bangalore — a great day trip or weekend getaway.'),
-- Hampi (15)
(15,'Packing',  'Sturdy footwear essential — ruins involve extensive walking on uneven ground and boulder scrambling.'),
(15,'Culture',  'Hampi is a living religious site — dress respectfully near Virupaksha Temple and participate in its energy.'),
(15,'Budget',   'Virupapur Gadde (across the river) has much cheaper accommodation and a more backpacker-friendly vibe.'),
(15,'Food',     'Mango Tree restaurant has been an institution for travellers since the 1990s. Riverside breakfast is dreamy.'),
(15,'Transport','Cycles and mopeds are the best way to explore — ruins spread over 26 sq km. Rent at ₹100–200/day.'),
(15,'Safety',   'Carry plenty of water — Hampi''s rocky landscape has no shade. Start ruins tour before 8am to beat the heat.');

-- ============================================================
-- ACTIVITIES FOR ALL 15 DESTINATIONS
-- ============================================================
INSERT INTO Activities (destination_id, activity_name, description, category, duration_hours, price_per_person, max_participants, difficulty, available_daily) VALUES
-- Goa (1)
(1,'Scuba Diving',          'Guided scuba dive at Grand Island with certified instructor. Visibility 10–20m, tropical fish.',    'Adventure', 3.0,  3500.00, 12, 'Easy',     TRUE),
(1,'Parasailing Baga',      'Soar over Baga Beach at 80m with tandem parasail — panoramic Arabian Sea views.',                 'Adventure', 0.5,  1200.00, 2,  'Easy',     TRUE),
(1,'Goan Cooking Class',    'Learn to cook prawn curry, bebinca and sorpotel in a local Goan home kitchen.',                   'Cultural',  3.0,  2500.00, 10, 'Easy',     TRUE),
(1,'Dolphin Boat Tour',     'Morning boat ride to spot spinner dolphins off Sinquerim beach.',                                 'Nature',    2.0,  1000.00, 15, 'Easy',     TRUE),
(1,'Old Goa Heritage Walk', 'Guided walk through UNESCO Basilica, Se Cathedral and 16th-century Portuguese architecture.',     'Cultural',  3.0,   800.00, 20, 'Easy',     TRUE),
-- Manali (2)
(2,'River Rafting Beas',    'Grade II–III white-water rafting on the Beas River through forest gorges.',                      'Adventure', 2.0,   800.00, 8,  'Moderate', TRUE),
(2,'Paragliding Solang',    'Tandem paragliding flight with views over the Kullu Valley and snow peaks.',                     'Adventure', 0.5,  2500.00, 2,  'Easy',     TRUE),
(2,'Beas Kund Trek',        '3-day guided trek to Beas Kund glacier lake at 3,540m. Camp under the stars.',                  'Adventure', 72.0, 8000.00, 10, 'Moderate', FALSE),
(2,'Apple Orchard Walk',    'Guided walk through working apple orchards in Naggar with farmer interaction and tasting.',       'Nature',    2.0,   500.00, 20, 'Easy',     TRUE),
(2,'Himalayan Cooking Class','Learn to cook Himachali siddu, madra and dham in a local home in Old Manali.',                  'Cultural',  3.0,  2000.00, 8,  'Easy',     TRUE),
-- Jaipur (3)
(3,'Hot Air Balloon Ride',  'Float over Jaipur at sunrise — Amber Fort, City Palace and the Pink City from above.',           'Adventure', 1.5, 10000.00, 6,  'Easy',     TRUE),
(3,'Elephant Village Visit','Ethical elephant sanctuary experience — morning feeding, bathing and interaction.',               'Nature',    2.0,  2500.00, 8,  'Easy',     TRUE),
(3,'Jaipur Street Food Tour','Guided evening walk through Johri Bazaar — pyaaz kachori, lassi, churma and kulfi tasting.',     'Cultural',  2.5,  1500.00, 12, 'Easy',     TRUE),
(3,'Pottery Workshop',      'Learn traditional blue pottery making from a 5th-generation Kashi Ram family in Sitapura.',       'Cultural',  3.0,  2000.00, 8,  'Easy',     TRUE),
(3,'Amer Fort Sound & Light','Spectacular evening show at Amer Fort narrating 500 years of Rajput history.',                  'Cultural',  1.0,   500.00, 200,'Easy',     TRUE),
-- Kerala (4)
(4,'Houseboat Overnight',   'Luxury houseboat cruise overnight in Alleppey backwaters with all meals.',                       'Cultural',  24.0,  8000.00, 4,  'Easy',     TRUE),
(4,'Kathakali Performance', 'Full 2-hour Kathakali classical dance performance with pre-show make-up demonstration.',          'Cultural',  2.5,   600.00, 50, 'Easy',     TRUE),
(4,'Ayurveda Treatment',    'Authentic Panchakarma treatment at a certified Ayurvedic centre — full-body rejuvenation.',       'Wellness',  2.0,  3500.00, 4,  'Easy',     TRUE),
(4,'Periyar Boat Safari',   'Wildlife boat ride on Periyar Lake in the tiger reserve — elephants, bison, birds.',             'Nature',    1.5,   350.00, 25, 'Easy',     TRUE),
(4,'Spice Plantation Tour', 'Guided tour of cardamom, pepper, vanilla and cinnamon plantations in Thekkady.',                'Nature',    2.0,   400.00, 20, 'Easy',     TRUE),
-- Ladakh (5)
(5,'Pangong Lake Camping',  'Overnight camping on the shore of Pangong Tso at 4350m — star gazing, sunrise colours.',        'Adventure', 24.0, 4500.00, 8,  'Moderate', FALSE),
(5,'Camel Safari Nubra',    'Bactrian double-hump camel ride on the Nubra Valley sand dunes at sunset.',                     'Adventure', 1.0,  1200.00, 10, 'Easy',     TRUE),
(5,'Monastery Trek Thiksey','Guided morning trek to Thiksey Monastery for 5am monk prayer ceremony.',                        'Spiritual', 3.0,   800.00, 12, 'Moderate', TRUE),
(5,'Leh Royal Palace Tour', 'Guided tour of 17th-century Leh Palace with Ladakhi cultural history narration.',               'Cultural',  2.0,   500.00, 20, 'Easy',     TRUE),
(5,'Star Gazing Experience','Professional astronomy session at Hanle Dark Sky Reserve — one of the darkest skies on Earth.',  'Nature',    3.0,  2500.00, 10, 'Easy',     FALSE),
-- Udaipur (6)
(6,'Lake Pichola Sunset Cruise','Private boat ride on Lake Pichola at sunset past Jag Mahal and island palaces.',           'Cultural',  1.5,  1800.00, 8,  'Easy',     TRUE),
(6,'Rajasthani Cooking Class','Learn royal Rajasthani recipes including gatte ki sabzi, dal baati and churma.',             'Cultural',  3.0,  2500.00, 10, 'Easy',     TRUE),
(6,'City Palace Guided Tour','Expert heritage tour of all 11 palaces with Rajput history narration.',                       'Cultural',  2.5,  1200.00, 15, 'Easy',     TRUE),
(6,'Mewar Festival Experience','Cultural participation during the March Mewar Festival — boat procession and folk music.',  'Cultural',  4.0,  1000.00, 20, 'Easy',     FALSE),
-- Rishikesh (7)
(7,'White Water Rafting',   'Grade III–IV rafting on the Ganga — 16km Shivpuri to Rishikesh stretch.',                     'Adventure', 3.0,   800.00, 8,  'Moderate', TRUE),
(7,'Bungee Jumping',        '83-metre bungee jump from the Mohan Chatti suspension bridge — highest in India.',              'Adventure', 0.5,  3550.00, 2,  'Hard',     TRUE),
(7,'Morning Yoga Session',  'Sunrise yoga on the Ganga bank with certified Hatha yoga instructor.',                         'Wellness',  1.5,   500.00, 20, 'Easy',     TRUE),
(7,'Ayurveda Consultation', 'Full Ayurvedic body type assessment and personalised wellness plan with treatment.',            'Wellness',  2.0,  2000.00, 4,  'Easy',     TRUE),
(7,'Beatles Ashram Tour',   'Guided tour of Chaurasi Kutia ashram where the Beatles composed the White Album in 1968.',     'Cultural',  1.5,   700.00, 15, 'Easy',     TRUE),
-- Darjeeling (8)
(8,'Tiger Hill Sunrise Drive','4am jeep ride to Tiger Hill for Kanchenjunga sunrise with tea at the summit.',               'Nature',    3.0,   350.00, 4,  'Easy',     TRUE),
(8,'Tea Tasting Tour',      'Expert-guided tasting of FTGFOP1 Darjeeling first flush, second flush and autumnal teas.',    'Cultural',  2.0,  1500.00, 10, 'Easy',     TRUE),
(8,'Sandakphu Trek',        '5-day trek to Sandakphu (3636m) — views of Everest, Lhotse, Makalu and Kanchenjunga together.','Adventure', 120.0,15000.00,6, 'Hard',     FALSE),
(8,'Toy Train Joyride',     'Round-trip joy ride on UNESCO Darjeeling Himalayan Railway through mountain loops.',            'Cultural',  2.0,  1200.00, 20, 'Easy',     TRUE),
-- Shimla (9)
(9,'Ice Skating Rink',      'Natural ice skating rink at the only natural rink in South Asia — open December to February.',  'Adventure', 1.5,   250.00, 30, 'Easy',     FALSE),
(9,'Heritage Walk Shimla',  'Guided colonial-era heritage walk past Viceregal Lodge, Gorton Castle and Christ Church.',     'Cultural',  2.5,   600.00, 15, 'Easy',     TRUE),
(9,'Jakhu Trek',            'Morning trek to Jakhu Peak (2455m) through monkey-inhabited forests.',                         'Nature',    2.0,   300.00, 20, 'Easy',     TRUE),
-- Varanasi (10)
(10,'Ganga Aarti Ceremony', 'Front-row access to the nightly Dashashwamedh Ghat Aarti with 7 priests and fire rituals.',   'Spiritual', 1.0,   500.00, 30, 'Easy',     TRUE),
(10,'Sunrise Boat Ride',    'Private boat ride past all 84 ghats at sunrise — most atmospheric hour of the day in India.',  'Cultural',  1.5,   600.00, 6,  'Easy',     TRUE),
(10,'Old City Walk',        'Expert-guided labyrinth walk through the ancient alleyways, 2500-year-old temples and silks.', 'Cultural',  3.0,   800.00, 12, 'Easy',     TRUE),
(10,'Silk Weaving Workshop','Learn Banarasi silk brocade weaving at a master craftsman''s home loom.',                     'Cultural',  2.5,  1500.00, 6,  'Easy',     TRUE),
-- Agra (11)
(11,'Taj Mahal Sunrise Visit','Professional photographer-guided Taj Mahal shoot at sunrise — golden hour magic.',          'Cultural',  2.0,  2500.00, 8,  'Easy',     TRUE),
(11,'Taj by Moonlight',     'Special full-moon night viewing of the Taj Mahal — hauntingly beautiful, only 5 nights/month.','Cultural', 1.5,  1100.00, 50, 'Easy',     FALSE),
(11,'Agra Food Walk',       'Evening street food tour — chaat, petha, bedai kachori, chai and Mughlai snacks.',            'Cultural',  2.5,  1200.00, 12, 'Easy',     TRUE),
-- Coorg (12)
(12,'Coffee Plantation Walk','In-depth guided tour of arabica and robusta estates with brewing demonstration.',             'Nature',    2.5,   800.00, 15, 'Easy',     TRUE),
(12,'Dubare Elephant Experience','Morning at the elephant camp — bathing, feeding and mahout interaction on the Cauvery.','Nature',    2.0,   600.00, 20, 'Easy',     TRUE),
(12,'Coorg Cooking Class',  'Cook Pandi curry, akki rotti, Coorg chicken and bamboo shoot curry with local family.',        'Cultural',  3.0,  2000.00, 8,  'Easy',     TRUE),
-- Ooty (13)
(13,'Tea Factory Tour',     'Full guided tour of a working Nilgiri tea factory — plucking, withering, rolling and tasting.','Cultural', 2.0,   300.00, 20, 'Easy',     TRUE),
(13,'Avalanche Lake Trek',  'Guided trek 24km from Ooty to the pristine Avalanche Lake through shola forests.',            'Nature',    6.0,  1500.00, 10, 'Moderate', TRUE),
(13,'Nilgiri Toy Train Ride','Full Nilgiri Mountain Railway experience — Mettupalayam to Ooty through 208 curves.',       'Cultural',  5.0,   850.00, 40, 'Easy',     TRUE),
-- Mysore (14)
(14,'Palace Night Illumination','Sunday evening Mysore Palace lit up by 100,000 bulbs — one of India''s greatest spectacles.','Cultural',1.0,200.00,500,'Easy',   FALSE),
(14,'Mysore Silk Weaving',  'Visit to government silk weaving factory — see Mysore silk sarees made from scratch.',        'Cultural',  1.5,   100.00, 20, 'Easy',     TRUE),
(14,'Yoga at Mysore',       'Ashtanga yoga class in the city that is considered the world capital of Ashtanga practice.',  'Wellness',  2.0,   800.00, 15, 'Easy',     TRUE),
-- Hampi (15)
(15,'Sunrise Matanga Hill', 'Guided sunrise scramble up Matanga Hill — 360° view over all of Hampi''s ruins.',            'Nature',    2.0,   500.00, 10, 'Moderate', TRUE),
(15,'Coracle River Ride',   'Circular basket boat ride across the Tungabhadra to Virupapur Gadde hippie village.',         'Adventure', 0.5,   200.00, 4,  'Easy',     TRUE),
(15,'Hampi Ruins Cycle Tour','Full-day guided cycle tour of all major monuments with Vijayanagara Empire history.',       'Cultural',  8.0,  1500.00, 8,  'Easy',     TRUE),
(15,'Boulder Sunrise Hike', 'Scramble through the famous Hampi boulderscape to a viewpoint as the sun rises over ruins.', 'Adventure', 2.0,   600.00, 8,  'Moderate', TRUE);

-- ============================================================
-- RESTAURANTS FOR ALL 15 DESTINATIONS
-- ============================================================
INSERT INTO Restaurants (destination_id, restaurant_name, cuisine_type, address, price_range, rating, must_try_dish, opening_hours) VALUES
(1,'Fisherman''s Wharf',     'Goan Seafood',          'Cavelossim, South Goa',        'Mid-range',    4.6, 'Prawn Balchão and Kingfish Rechado',  '12:00–23:00'),
(1,'Gunpowder',              'Kerala & Goan Fusion',  'Assagao, Bardez, Goa',         'Mid-range',    4.5, 'Prawn Koliwada & Toddy-Braised Pork', '12:30–22:30'),
(1,'Sublime',                'Mediterranean & Indian', 'Arpora, Goa',                 'Fine Dining',  4.7, 'Lobster Thermidor & Coconut Tart',    '19:00–23:00'),
(2,'Johnson''s Cafe',        'Continental & Indian',  'The Mall, Manali',              'Mid-range',    4.3, 'Apple Pie & Trout with Garlic Butter', '08:00–22:00'),
(2,'Drifters Inn',           'Cafe Traveller Food',   'Old Manali, Manali',           'Budget',       4.4, 'Lemon Honey Ginger Tea & Thukpa',     '08:00–21:00'),
(2,'Moondance',              'World & Indian',        'Naggar Road, Manali',          'Mid-range',    4.2, 'Tandoori Trout & Himachali Dham',     '11:00–22:00'),
(3,'Suvarna Mahal',          'Royal Rajasthani',      'Taj Rambagh Palace, Jaipur',   'Fine Dining',  4.9, 'Laal Maas & Dal Baati Churma',        '19:30–23:00'),
(3,'Niros',                  'Multi-cuisine',         'MI Road, Jaipur',              'Mid-range',    4.3, 'Ghee Chicken & Rajasthani Thali',     '10:00–23:00'),
(3,'Handi',                  'North Indian',          'MI Road, Jaipur',              'Mid-range',    4.2, 'Dal Makhani & Naan',                  '11:00–23:00'),
(4,'Malabar Junction',       'Kerala Cuisine',        'Casino Hotel, Kochi',          'Fine Dining',  4.6, 'Karimeen Pollichathu & Malabar Biryani','12:00–22:30'),
(4,'Saravana Bhavan',        'South Indian Vegetarian','M.G. Road, Kochi',            'Budget',       4.2, 'Masala Dosa & Filter Coffee',         '07:00–22:00'),
(4,'Kashi Art Cafe',         'Continental & Kerala',  'Burgher Street, Fort Kochi',   'Mid-range',    4.4, 'Coconut Fish Curry & Banana Bread',   '08:30–21:00'),
(5,'Tibetan Kitchen',        'Tibetan & Indian',      'Main Market, Leh',             'Budget',       4.3, 'Butter Tea Thukpa & Yak Cheese Momos','07:00–21:00'),
(5,'The Lehchen',            'Ladakhi Fusion',        'Changspa Road, Leh',           'Mid-range',    4.4, 'Skyu Stew & Apricot Jam Pancakes',    '08:00–22:00'),
(6,'Ambrai Restaurant',      'Rajasthani & Indian',   'Amet Haveli, Udaipur',         'Fine Dining',  4.7, 'Gatte ki Sabzi with Lake View',        '12:00–23:00'),
(6,'Upre',                   'Pan-Indian',            'Lake Pichola Hotel, Udaipur',  'Fine Dining',  4.6, 'Rajasthani Thali & Mawa Kachori',     '12:00–22:30'),
(6,'Millets of Mewar',       'Organic & Indian',      'Hanuman Ghat, Udaipur',        'Mid-range',    4.5, 'Bajra Roti with Laal Mirch Chutney',  '08:00–22:00'),
(7,'Little Buddha Cafe',     'Multi-cuisine',         'Laxman Jhula, Rishikesh',      'Budget',       4.3, 'Banana Porridge & Masala Chai',       '08:00–22:00'),
(7,'Chotiwala',              'North Indian Vegetarian','Ram Jhula, Rishikesh',         'Budget',       4.1, 'Rajma Chawal & Aam Panna',            '08:00–22:00'),
(7,'Tavern Bar & Grill',     'Continental',           'The Glasshouse, Rishikesh',    'Fine Dining',  4.5, 'Riverside Barbecue & Sparkling Water', '18:00–23:00'),
(8,'Glenary''s',             'Bakery & Continental',  'Nehru Road, Darjeeling',       'Mid-range',    4.5, 'English Breakfast & Darjeeling Tea',  '07:30–20:30'),
(8,'Keventers',              'Milkshakes & Snacks',   'The Mall, Darjeeling',         'Budget',       4.3, 'Cold Coffee & Chicken Patties',       '08:00–19:00'),
(8,'Sonam''s Kitchen',       'Tibetan & Nepali',      'Ghoom, Darjeeling',            'Budget',       4.2, 'Veg Thukpa & Bamboo Shoot Curry',     '08:00–20:00'),
(9,'Indian Coffee House',    'South Indian',          'The Mall, Shimla',             'Budget',       4.1, 'Cheese Toast & Filter Coffee (since 1957)','07:00–20:00'),
(9,'Cafe Sol',               'Continental & Indian',  'Mall Road, Shimla',            'Mid-range',    4.3, 'Baked Fish & Apple Strudel',          '11:00–23:00'),
(9,'Baljees',                'North Indian & Sweets', 'The Mall, Shimla',             'Budget',       4.2, 'Himachali Dham & Mithai',             '09:00–21:00'),
(10,'Bread of Life',         'Continental & Indian',  'Shivala Ghat, Varanasi',       'Mid-range',    4.3, 'Banana Pancakes & Aloo Tikki',        '08:00–22:00'),
(10,'Aum Cafe',              'Multi-cuisine',         'Assi Ghat, Varanasi',          'Budget',       4.2, 'Malaiyo & Thandai',                   '07:00–21:00'),
(10,'Keshari Restaurant',    'North Indian',          'Godowlia, Varanasi',           'Budget',       4.0, 'Banarasi Kachori Sabzi & Lassi',      '07:00–22:00'),
(11,'Esphahan',              'Mughlai Fine Dining',   'Oberoi Amarvilas, Agra',       'Fine Dining',  4.9, 'Dum Biryani & Korma with Taj View',   '19:30–23:00'),
(11,'Dasaprakash',           'South Indian',          'Gwalior Road, Agra',           'Budget',       4.1, 'Masala Dosa & Sweet Pongal',          '08:00–22:00'),
(11,'Pinch of Spice',        'North Indian',          'Fatehabad Road, Agra',         'Mid-range',    4.3, 'Chicken Tikka & Butter Naan',         '11:00–23:00'),
(12,'Coorg Cuisine',         'Kodava Traditional',    'Madikeri Main, Coorg',         'Budget',       4.4, 'Pandi Curry with Kadambuttu',         '12:00–22:00'),
(12,'East End Hotel',        'Coorgi & Indian',       'Siddapur Road, Coorg',         'Mid-range',    4.2, 'Mutton Pepper Fry & Akki Rotti',      '07:00–22:00'),
(12,'Raintree Cafe',         'Continental & Coffee',  'Kushalnagar, Coorg',           'Mid-range',    4.3, 'Estate Cold Brew & Avocado Toast',    '08:00–20:00'),
(13,'Sidewalk Cafe',         'Continental & South Indian','Charring Cross, Ooty',      'Mid-range',    4.2, 'Nilgiri Tea & Cheese Omelette',       '08:00–21:00'),
(13,'Hotel Welbeck',         'South Indian',          'Commercial Road, Ooty',        'Budget',       4.0, 'Varkey & Aval Payasam',               '07:00–21:00'),
(13,'Hyderabad Biryani',     'Mughlai',               'Main Bazaar, Ooty',            'Budget',       4.1, 'Hyderabadi Chicken Biryani',          '12:00–22:00'),
(14,'Dasaprakash',           'South Indian',          'Gandhi Square, Mysore',        'Budget',       4.3, 'Mysore Masala Dosa & Filter Coffee',  '07:30–22:00'),
(14,'Lalitha Mahal Palace Dining','Continental & Indian','T Narasipura Road, Mysore','Fine Dining',  4.6, 'Mysore Royal Thali & Gulkand Kulfi',  '12:00–23:00'),
(14,'The Jewel of Mysore',   'Pan-Indian',            'Hotel Metropole, Mysore',      'Mid-range',    4.3, 'Bisi Bele Bath & Mysore Pak',         '12:00–22:30'),
(15,'Mango Tree',            'Multi-cuisine Backpacker','Hampi Bazaar, Hampi',         'Budget',       4.5, 'Banana Lassi & Thali',                '08:00–21:00'),
(15,'Laughing Buddha',       'Multi-cuisine',         'Virupapur Gadde, Hampi',       'Budget',       4.3, 'Breakfast Platter & Fresh Lemon Soda', '07:30–21:30'),
(15,'The Goan Corner',       'Goan & North Indian',   'Hospet Road, Hampi',           'Mid-range',    4.1, 'Fish Curry & Mushroom Xacuti',        '11:00–22:00');

-- ============================================================
-- FESTIVALS & EVENTS
-- ============================================================
INSERT INTO Events (destination_id, event_name, description, month_of_year, duration_days, event_type, entry_fee) VALUES
(1, 'Goa Carnival',          'Portuguese-heritage street carnival with floats, music, dance and revelry across Panaji and Margao.', 2, 4,  'Cultural',   0.00),
(1, 'Sunburn Festival',      'Asia''s biggest electronic music festival — world-class DJs at Vagator Beach.',                       12, 3, 'Music',    3000.00),
(1, 'Goa Food and Cultural Festival','Annual festival celebrating Goan cuisine, culture, literature and art at Panaji waterfront.', 1, 4, 'Food',     0.00),
(2, 'Hadimba Devi Fair',     'Annual temple fair at Hadimba Devi Temple with traditional Himachali music, dance and rituals.',       5, 3, 'Religious',  0.00),
(2, 'Winter Carnival Manali','Snow sports competitions, folk performances and Himachali cultural displays.',                         1, 5, 'Cultural',   0.00),
(3, 'Jaipur Literature Festival','World''s largest free literary festival at Diggi Palace — 250+ authors from 25+ countries.',       1, 5, 'Cultural',   0.00),
(3, 'Jaipur Heritage Festival','Night festival at Amer Fort with Rajasthani folk music, puppetry and illuminated ruins.',            2, 3, 'Cultural', 500.00),
(3, 'Teej Festival',         'Women''s monsoon festival with swings, fasting, singing and procession through the Pink City.',        7, 2, 'Festival',   0.00),
(4, 'Onam Festival',         'Kerala''s harvest festival — pookalam flower carpets, snake boat races and the grand Onam Sadhya.',    8, 10,'Festival',   0.00),
(4, 'Thrissur Pooram',       'Most spectacular temple festival in India — caparisoned elephants, parasols and percussion orchestras.',4, 1, 'Religious',  0.00),
(5, 'Hemis Festival',        'Ladakh''s grandest Buddhist festival at Hemis Monastery — cham masked dances, thangka unfurling.',     6, 2, 'Religious',  200.00),
(5, 'Ladakh Festival',       'Government-organised cultural festival in Leh — polo, archery, folk dances and traditional costumes.', 9, 15,'Cultural',   0.00),
(6, 'Mewar Festival',        'Welcome of spring — procession of Gangaur idols to Lake Pichola with music, boats and fireworks.',     3, 2, 'Festival',   0.00),
(6, 'Shilpgram Utsav',       'Tribal crafts fair near Udaipur — 400 artisans from across Rajasthan and India.',                    12, 10,'Cultural', 50.00),
(7, 'International Yoga Festival','World''s largest yoga gathering at Parmarth Niketan on the Ganges — 2,500 participants.',        3, 7, 'Cultural',   500.00),
(8, 'Darjeeling Carnival',   'Toy train parades, folk performances and winter carnival celebrating the hill station heritage.',      12, 5, 'Cultural',  0.00),
(8, 'Tea & Tourism Festival','Tea plucking competition, live music and tastings — celebrating Darjeeling''s most famous product.',    4, 4, 'Food',      0.00),
(9, 'Shimla Summer Festival','Himachal''s premier cultural event at the Ridge — music, dance, local food and crafts.',               6, 5, 'Cultural',   0.00),
(10,'Dev Deepawali Varanasi','80 ghats lit by a million earthen lamps on Kartik Purnima — most magical night in Varanasi.',         11, 1, 'Religious',  0.00),
(10,'Ganga Mahotsav',        '5-day cultural festival at the ghats — classical music, Ganga Aarti and boat processions.',           11, 5, 'Cultural',   0.00),
(11,'Taj Mahotsav',          '10-day Mughal craft fair near the Taj — artisans from across India, food and classical music.',        2, 10,'Cultural', 50.00),
(12,'Coorg Madikeri Dasara', 'Smaller, community Dasara celebration with processions, folk dance and traditional Kodava rituals.',  10, 1, 'Festival',   0.00),
(13,'Ooty Flower Show',      'Annual flower show at the Botanical Gardens — best rose and dahlia displays in South India.',          5, 3, 'Cultural', 30.00),
(14,'Mysore Dasara',         'Most spectacular Dasara in India — royal elephant procession, 100,000 bulbs on palace, fireworks.',   10, 10,'Festival',   0.00),
(15,'Hampi Utsav',           'Government cultural festival at the ruins — classical dance on Vittala Temple stage, laser shows.',    11, 3, 'Cultural',   0.00);

-- ============================================================
-- LOCAL GUIDES
-- ============================================================
INSERT INTO Guides (destination_id, guide_name, languages, speciality, experience_years, price_per_day, rating, phone, certified) VALUES
(1, 'Miguel D''Souza',     'English, Konkani, Hindi, Portuguese','Portuguese Heritage & Church History', 12, 2500.00, 4.9, '9823401234', TRUE),
(1, 'Priya Naik',          'English, Hindi, Konkani',            'Beach Culture & Water Sports',         8,  2000.00, 4.7, '9823401235', TRUE),
(2, 'Tenzin Dorje',        'English, Hindi, Pahari',             'Trekking & High Altitude Expeditions', 15, 3000.00, 5.0, '9816501234', TRUE),
(2, 'Ramesh Kumar',        'English, Hindi',                     'Manali Local Culture & Apple Farming', 10, 2200.00, 4.6, '9816501235', FALSE),
(3, 'Rajendra Singh',      'English, Hindi, Rajasthani',         'Rajput History & Palace Architecture', 18, 3500.00, 4.9, '9414901234', TRUE),
(3, 'Sunita Sharma',       'English, Hindi, French',             'Jaipur Art, Crafts & Bazaar Shopping', 12, 3000.00, 4.8, '9414901235', TRUE),
(4, 'Thomas Mathew',       'English, Malayalam, Tamil',          'Backwaters, Ayurveda & Temple Culture', 14, 2800.00, 4.8, '9847701234', TRUE),
(4, 'Lakshmi Pillai',      'English, Malayalam, Hindi',          'Spice Trade History & Fort Kochi Heritage',9,2500.00, 4.7, '9847701235', FALSE),
(5, 'Sonam Wangchuk',      'English, Ladakhi, Hindi',            'Buddhist Monasteries & High-Altitude Trek',20,4500.00,5.0,'9622801234', TRUE),
(5, 'Jigmet Angmo',        'English, Hindi, Ladakhi',            'Pangong Lake & Nubra Valley Jeep Tours',12, 3800.00, 4.8, '9622801235', TRUE),
(6, 'Deepak Meena',        'English, Hindi, Rajasthani',         'Lake City Heritage & Mewar Painting',   16, 3200.00, 4.8, '9413601234', TRUE),
(7, 'Swami Prakash',       'English, Hindi, Sanskrit',           'Yoga, Vedanta & Spiritual Heritage',    22, 2000.00, 4.9, '9897801234', FALSE),
(8, 'Bikash Gurung',       'English, Nepali, Hindi, Bengali',    'Tea Estates & Himalayan Trekking',      14, 2800.00, 4.7, '9832101234', TRUE),
(9, 'Kuldeep Thakur',      'English, Hindi, Pahari',             'Colonial Heritage & Shimla Architecture',10,2500.00, 4.6, '9816701234', FALSE),
(10,'Pandit Ramlal',       'English, Hindi, Sanskrit',           'Ghat Rituals, Temple History & Varanasi Spirituality',25,3000.00,5.0,'9415201234',TRUE),
(11,'Akbar Ali Khan',      'English, Hindi, Urdu',               'Mughal Architecture & Taj Mahal History',18,4000.00, 4.9, '9837601234', TRUE),
(12,'Apanna Thimmaiah',    'English, Kannada, Kodava',           'Coffee Estates & Kodava Tribal Culture', 11, 2500.00, 4.7, '9448201234', FALSE),
(13,'Suresh Murugan',      'English, Tamil, Kannada',            'Nilgiri Ecology & Toda Tribal Culture',  13, 2200.00, 4.6, '9443201234', TRUE),
(14,'Venkatesh Iyengar',   'English, Kannada, Hindi',            'Hoysala Art, Mysore Palace & Silk Weaving',15,3000.00,4.8,'9446101234', TRUE),
(15,'Ramesha Gowda',       'English, Kannada, Telugu, Hindi',    'Vijayanagara Empire & Archaeological Ruins',16,3500.00,4.9,'9448701234', TRUE);
