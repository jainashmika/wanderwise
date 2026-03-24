-- ============================================================
--  SMART TRAVEL PLANNER — Database Expansion PART 2
--  Adds: More Users, PackageDetails, Itineraries,
--        More Transport, Bookings, Payments, Reviews,
--        Wishlists, ChatLogs
--  Run AFTER schema.sql, seed_data.sql, expand_database.sql
-- ============================================================

USE smart_travel_planner;

-- ============================================================
-- 1. MORE USERS (15 additional diverse Indian users)
-- ============================================================
INSERT INTO Users (name, email, password_hash, phone) VALUES
('Rohan Mehta',        'rohan.mehta@gmail.com',      'hashed_pass_4',  '9123456780'),
('Priya Sharma',       'priya.sharma@gmail.com',      'hashed_pass_5',  '9234567891'),
('Arjun Nair',         'arjun.nair@gmail.com',        'hashed_pass_6',  '9345678902'),
('Sneha Reddy',        'sneha.reddy@gmail.com',       'hashed_pass_7',  '9456789013'),
('Vikram Singh',       'vikram.singh@gmail.com',      'hashed_pass_8',  '9567890124'),
('Ananya Bose',        'ananya.bose@gmail.com',       'hashed_pass_9',  '9678901235'),
('Karan Patel',        'karan.patel@gmail.com',       'hashed_pass_10', '9789012346'),
('Divya Menon',        'divya.menon@gmail.com',       'hashed_pass_11', '9890123457'),
('Rahul Gupta',        'rahul.gupta@gmail.com',       'hashed_pass_12', '9901234568'),
('Meera Iyer',         'meera.iyer@gmail.com',        'hashed_pass_13', '9012345679'),
('Aditya Khanna',      'aditya.khanna@gmail.com',     'hashed_pass_14', '9123456789'),
('Pooja Joshi',        'pooja.joshi@gmail.com',       'hashed_pass_15', '9234567800'),
('Nikhil Desai',       'nikhil.desai@gmail.com',      'hashed_pass_16', '9345678901'),
('Swati Mukherjee',    'swati.mukherjee@gmail.com',   'hashed_pass_17', '9456789012'),
('Gaurav Tiwari',      'gaurav.tiwari@gmail.com',     'hashed_pass_18', '9567890123');

-- ============================================================
-- 2. ADDITIONAL TRANSPORT ROUTES
--    Inter-city routes + more departures for new destinations
-- ============================================================
INSERT INTO Transport (type, operator_name, source, destination, departure_time, arrival_time, fare, available_seats) VALUES
-- More routes to Udaipur
('Flight','SpiceJet',         'Bangalore', 'Udaipur',   '09:30:00','11:30:00', 5800.00, 150),
('Bus',   'RSRTC Volvo',      'Ahmedabad', 'Udaipur',   '22:00:00','04:30:00',  250.00,  40),
('Train', 'Indian Railways',  'Ahmedabad', 'Udaipur',   '06:15:00','11:00:00',  320.00, 180),
-- More routes to Rishikesh
('Bus',   'UPSRTC',           'Dehradun',  'Rishikesh', '06:00:00','08:00:00',   80.00,  50),
('Train', 'Indian Railways',  'Delhi',     'Rishikesh', '06:15:00','11:45:00',  350.00, 150),
-- More routes to Darjeeling
('Train', 'Indian Railways',  'Delhi',     'NJP',       '09:30:00','10:30:00',  800.00, 200),
('Bus',   'NBSTC',            'Gangtok',   'Darjeeling','09:00:00','13:00:00',  200.00,  40),
-- More routes to Shimla
('Bus',   'HRTC',             'Chandigarh','Shimla',    '07:00:00','11:00:00',  230.00,  44),
('Train', 'Indian Railways',  'Delhi',     'Chandigarh','07:00:00','10:30:00',  380.00, 250),
-- More routes to Varanasi
('Flight','SpiceJet',         'Bangalore', 'Varanasi',  '07:00:00','09:30:00', 5200.00, 180),
('Train', 'Indian Railways',  'Kolkata',   'Varanasi',  '07:10:00','17:00:00',  480.00, 200),
-- More routes to Agra
('Train', 'Indian Railways',  'Mumbai',    'Agra',      '06:00:00','22:00:00',  650.00, 200),
('Bus',   'UPSRTC',           'Lucknow',   'Agra',      '06:00:00','10:30:00',  300.00,  44),
-- More routes to Coorg
('Bus',   'KSRTC',            'Mangalore', 'Coorg',     '07:00:00','10:00:00',  180.00,  44),
('Bus',   'KSRTC',            'Coimbatore','Coorg',     '06:00:00','11:00:00',  350.00,  40),
-- More routes to Ooty
('Bus',   'TNSTC',            'Mysore',    'Ooty',      '07:00:00','11:30:00',  180.00,  44),
('Bus',   'TNSTC',            'Bangalore', 'Coimbatore','21:30:00','05:00:00',  450.00,  40),
-- More routes to Mysore
('Train', 'Indian Railways',  'Chennai',   'Mysore',    '06:00:00','13:30:00',  380.00, 200),
('Bus',   'KSRTC',            'Coimbatore','Mysore',    '07:00:00','11:30:00',  240.00,  44),
-- More routes to Hampi
('Bus',   'KSRTC',            'Hyderabad', 'Hampi',     '21:00:00','06:30:00',  600.00,  40),
('Train', 'Indian Railways',  'Hyderabad', 'Hospet',    '22:30:00','08:00:00',  400.00, 150),
-- Cross-destination routes (connecting new cities to each other)
('Bus',   'RSRTC',            'Udaipur',   'Jaipur',    '06:30:00','14:00:00',  380.00,  44),
('Bus',   'RSRTC',            'Udaipur',   'Jodhpur',   '07:00:00','13:00:00',  320.00,  44),
('Train', 'Indian Railways',  'Agra',      'Varanasi',  '14:30:00','20:00:00',  350.00, 180),
('Train', 'Indian Railways',  'Varanasi',  'Kolkata',   '22:00:00','09:00:00',  550.00, 200),
('Bus',   'KSRTC',            'Mysore',    'Hampi',     '06:00:00','13:00:00',  450.00,  44),
('Bus',   'TNSTC',            'Ooty',      'Mysore',    '08:00:00','12:00:00',  160.00,  44),
('Bus',   'KSRTC',            'Coorg',     'Mysore',    '07:00:00','10:30:00',  180.00,  44);

-- ============================================================
-- 3. PACKAGE DETAILS FOR NEW PACKAGES
--    Links packages to hotels, transport, and tourist spots
--    Uses (SELECT ...) subqueries so IDs auto-resolve
-- ============================================================

-- Helper: Udaipur Royal Romance
INSERT INTO PackageDetails (package_id, hotel_id, transport_id, spot_id)
SELECT p.package_id, h.hotel_id, t.transport_id, s.spot_id
FROM
  (SELECT package_id FROM BudgetPackages WHERE package_name = 'Udaipur Royal Romance' LIMIT 1) p,
  (SELECT hotel_id   FROM Hotels           WHERE hotel_name = 'Hotel Badi Haveli'      LIMIT 1) h,
  (SELECT transport_id FROM Transport      WHERE source='Delhi' AND destination='Udaipur' AND type='Flight' LIMIT 1) t,
  (SELECT spot_id    FROM TouristSpots     WHERE spot_name = 'City Palace Udaipur'     LIMIT 1) s;

INSERT INTO PackageDetails (package_id, hotel_id, transport_id, spot_id)
SELECT p.package_id, NULL, NULL, s.spot_id
FROM
  (SELECT package_id FROM BudgetPackages WHERE package_name = 'Udaipur Royal Romance' LIMIT 1) p,
  (SELECT spot_id    FROM TouristSpots   WHERE spot_name = 'Lake Pichola'             LIMIT 1) s;

-- Udaipur Heritage Explorer
INSERT INTO PackageDetails (package_id, hotel_id, transport_id, spot_id)
SELECT p.package_id, h.hotel_id, t.transport_id, s.spot_id
FROM
  (SELECT package_id FROM BudgetPackages WHERE package_name = 'Udaipur Heritage Explorer' LIMIT 1) p,
  (SELECT hotel_id   FROM Hotels           WHERE hotel_name = 'Hotel Badi Haveli'           LIMIT 1) h,
  (SELECT transport_id FROM Transport      WHERE source='Delhi' AND destination='Udaipur' AND type='Train' LIMIT 1) t,
  (SELECT spot_id    FROM TouristSpots     WHERE spot_name = 'Sajjangarh Monsoon Palace'    LIMIT 1) s;

-- Rishikesh Yoga & Rafting
INSERT INTO PackageDetails (package_id, hotel_id, transport_id, spot_id)
SELECT p.package_id, h.hotel_id, t.transport_id, s.spot_id
FROM
  (SELECT package_id FROM BudgetPackages WHERE package_name = 'Rishikesh Yoga & Rafting' LIMIT 1) p,
  (SELECT hotel_id   FROM Hotels           WHERE hotel_name = 'Parmarth Niketan Ashram'   LIMIT 1) h,
  (SELECT transport_id FROM Transport      WHERE source='Delhi' AND destination='Rishikesh' AND type='Bus' LIMIT 1) t,
  (SELECT spot_id    FROM TouristSpots     WHERE spot_name = 'Triveni Ghat'               LIMIT 1) s;

INSERT INTO PackageDetails (package_id, hotel_id, transport_id, spot_id)
SELECT p.package_id, NULL, NULL, s.spot_id
FROM
  (SELECT package_id FROM BudgetPackages WHERE package_name = 'Rishikesh Yoga & Rafting' LIMIT 1) p,
  (SELECT spot_id    FROM TouristSpots   WHERE spot_name = 'Laxman Jhula'                LIMIT 1) s;

-- Rishikesh Adventure Camp
INSERT INTO PackageDetails (package_id, hotel_id, transport_id, spot_id)
SELECT p.package_id, h.hotel_id, NULL, s.spot_id
FROM
  (SELECT package_id FROM BudgetPackages WHERE package_name = 'Rishikesh Adventure Camp' LIMIT 1) p,
  (SELECT hotel_id   FROM Hotels           WHERE hotel_name = 'Zostel Rishikesh'          LIMIT 1) h,
  (SELECT spot_id    FROM TouristSpots     WHERE spot_name = 'Ganga Beach Rishikesh'      LIMIT 1) s;

-- Darjeeling Tea & Mountains
INSERT INTO PackageDetails (package_id, hotel_id, transport_id, spot_id)
SELECT p.package_id, h.hotel_id, t.transport_id, s.spot_id
FROM
  (SELECT package_id FROM BudgetPackages WHERE package_name = 'Darjeeling Tea & Mountains' LIMIT 1) p,
  (SELECT hotel_id   FROM Hotels           WHERE hotel_name = 'Zostel Darjeeling'           LIMIT 1) h,
  (SELECT transport_id FROM Transport      WHERE source='Delhi' AND destination='Bagdogra' AND type='Flight' LIMIT 1) t,
  (SELECT spot_id    FROM TouristSpots     WHERE spot_name = 'Tiger Hill Sunrise'           LIMIT 1) s;

INSERT INTO PackageDetails (package_id, hotel_id, transport_id, spot_id)
SELECT p.package_id, NULL, NULL, s.spot_id
FROM
  (SELECT package_id FROM BudgetPackages WHERE package_name = 'Darjeeling Tea & Mountains' LIMIT 1) p,
  (SELECT spot_id    FROM TouristSpots   WHERE spot_name = 'Darjeeling Himalayan Railway'  LIMIT 1) s;

-- Shimla Snow Holiday
INSERT INTO PackageDetails (package_id, hotel_id, transport_id, spot_id)
SELECT p.package_id, h.hotel_id, t.transport_id, s.spot_id
FROM
  (SELECT package_id FROM BudgetPackages WHERE package_name = 'Shimla Snow Holiday' LIMIT 1) p,
  (SELECT hotel_id   FROM Hotels           WHERE hotel_name = 'The Cecil Shimla'     LIMIT 1) h,
  (SELECT transport_id FROM Transport      WHERE source='Delhi' AND destination='Shimla' AND type='Bus' LIMIT 1) t,
  (SELECT spot_id    FROM TouristSpots     WHERE spot_name = 'The Ridge Shimla'      LIMIT 1) s;

INSERT INTO PackageDetails (package_id, hotel_id, transport_id, spot_id)
SELECT p.package_id, NULL, NULL, s.spot_id
FROM
  (SELECT package_id FROM BudgetPackages WHERE package_name = 'Shimla Snow Holiday' LIMIT 1) p,
  (SELECT spot_id    FROM TouristSpots   WHERE spot_name = 'Kufri Adventure Park'   LIMIT 1) s;

-- Varanasi Spiritual Journey
INSERT INTO PackageDetails (package_id, hotel_id, transport_id, spot_id)
SELECT p.package_id, h.hotel_id, t.transport_id, s.spot_id
FROM
  (SELECT package_id FROM BudgetPackages WHERE package_name = 'Varanasi Spiritual Journey' LIMIT 1) p,
  (SELECT hotel_id   FROM Hotels           WHERE hotel_name = 'Hotel Ganges View'           LIMIT 1) h,
  (SELECT transport_id FROM Transport      WHERE source='Delhi' AND destination='Varanasi' AND type='Flight' LIMIT 1) t,
  (SELECT spot_id    FROM TouristSpots     WHERE spot_name = 'Dashashwamedh Ghat'          LIMIT 1) s;

INSERT INTO PackageDetails (package_id, hotel_id, transport_id, spot_id)
SELECT p.package_id, NULL, NULL, s.spot_id
FROM
  (SELECT package_id FROM BudgetPackages WHERE package_name = 'Varanasi Spiritual Journey' LIMIT 1) p,
  (SELECT spot_id    FROM TouristSpots   WHERE spot_name = 'Kashi Vishwanath Temple'       LIMIT 1) s;

-- Agra Taj Mahal Experience
INSERT INTO PackageDetails (package_id, hotel_id, transport_id, spot_id)
SELECT p.package_id, h.hotel_id, t.transport_id, s.spot_id
FROM
  (SELECT package_id FROM BudgetPackages WHERE package_name = 'Agra Taj Mahal Experience' LIMIT 1) p,
  (SELECT hotel_id   FROM Hotels           WHERE hotel_name = 'Hotel Taj Resorts'          LIMIT 1) h,
  (SELECT transport_id FROM Transport      WHERE source='Delhi' AND destination='Agra' AND type='Train' LIMIT 1) t,
  (SELECT spot_id    FROM TouristSpots     WHERE spot_name = 'Taj Mahal'                  LIMIT 1) s;

INSERT INTO PackageDetails (package_id, hotel_id, transport_id, spot_id)
SELECT p.package_id, NULL, NULL, s.spot_id
FROM
  (SELECT package_id FROM BudgetPackages WHERE package_name = 'Agra Taj Mahal Experience' LIMIT 1) p,
  (SELECT spot_id    FROM TouristSpots   WHERE spot_name = 'Agra Fort'                    LIMIT 1) s;

-- Coorg Coffee & Wilderness
INSERT INTO PackageDetails (package_id, hotel_id, transport_id, spot_id)
SELECT p.package_id, h.hotel_id, t.transport_id, s.spot_id
FROM
  (SELECT package_id FROM BudgetPackages WHERE package_name = 'Coorg Coffee & Wilderness' LIMIT 1) p,
  (SELECT hotel_id   FROM Hotels           WHERE hotel_name = 'Orange County Resort'       LIMIT 1) h,
  (SELECT transport_id FROM Transport      WHERE source='Bangalore' AND destination='Coorg' AND type='Bus' LIMIT 1) t,
  (SELECT spot_id    FROM TouristSpots     WHERE spot_name = 'Abbey Falls'                 LIMIT 1) s;

INSERT INTO PackageDetails (package_id, hotel_id, transport_id, spot_id)
SELECT p.package_id, NULL, NULL, s.spot_id
FROM
  (SELECT package_id FROM BudgetPackages WHERE package_name = 'Coorg Coffee & Wilderness' LIMIT 1) p,
  (SELECT spot_id    FROM TouristSpots   WHERE spot_name = 'Dubare Elephant Camp'          LIMIT 1) s;

-- Ooty Hill Station Escape
INSERT INTO PackageDetails (package_id, hotel_id, transport_id, spot_id)
SELECT p.package_id, h.hotel_id, t.transport_id, s.spot_id
FROM
  (SELECT package_id FROM BudgetPackages WHERE package_name = 'Ooty Hill Station Escape' LIMIT 1) p,
  (SELECT hotel_id   FROM Hotels           WHERE hotel_name = 'The Monarch Hotel Ooty'    LIMIT 1) h,
  (SELECT transport_id FROM Transport      WHERE source='Coimbatore' AND destination='Ooty' AND type='Bus' LIMIT 1) t,
  (SELECT spot_id    FROM TouristSpots     WHERE spot_name = 'Ooty Botanical Gardens'     LIMIT 1) s;

INSERT INTO PackageDetails (package_id, hotel_id, transport_id, spot_id)
SELECT p.package_id, NULL, NULL, s.spot_id
FROM
  (SELECT package_id FROM BudgetPackages WHERE package_name = 'Ooty Hill Station Escape' LIMIT 1) p,
  (SELECT spot_id    FROM TouristSpots   WHERE spot_name = 'Nilgiri Mountain Railway'     LIMIT 1) s;

-- Mysore Royal Heritage Tour
INSERT INTO PackageDetails (package_id, hotel_id, transport_id, spot_id)
SELECT p.package_id, h.hotel_id, t.transport_id, s.spot_id
FROM
  (SELECT package_id FROM BudgetPackages WHERE package_name = 'Mysore Royal Heritage Tour' LIMIT 1) p,
  (SELECT hotel_id   FROM Hotels           WHERE hotel_name = 'Radisson Blu Plaza Mysore'  LIMIT 1) h,
  (SELECT transport_id FROM Transport      WHERE source='Bangalore' AND destination='Mysore' AND type='Train' LIMIT 1) t,
  (SELECT spot_id    FROM TouristSpots     WHERE spot_name = 'Mysore Palace'               LIMIT 1) s;

INSERT INTO PackageDetails (package_id, hotel_id, transport_id, spot_id)
SELECT p.package_id, NULL, NULL, s.spot_id
FROM
  (SELECT package_id FROM BudgetPackages WHERE package_name = 'Mysore Royal Heritage Tour' LIMIT 1) p,
  (SELECT spot_id    FROM TouristSpots   WHERE spot_name = 'Chamundeshwari Temple'         LIMIT 1) s;

-- Hampi Ruins & Boulders
INSERT INTO PackageDetails (package_id, hotel_id, transport_id, spot_id)
SELECT p.package_id, h.hotel_id, t.transport_id, s.spot_id
FROM
  (SELECT package_id FROM BudgetPackages WHERE package_name = 'Hampi Ruins & Boulders'   LIMIT 1) p,
  (SELECT hotel_id   FROM Hotels           WHERE hotel_name = 'Zostel Hampi'              LIMIT 1) h,
  (SELECT transport_id FROM Transport      WHERE source='Bangalore' AND destination='Hospet' AND type='Train' LIMIT 1) t,
  (SELECT spot_id    FROM TouristSpots     WHERE spot_name = 'Vittala Temple Complex'     LIMIT 1) s;

INSERT INTO PackageDetails (package_id, hotel_id, transport_id, spot_id)
SELECT p.package_id, NULL, NULL, s.spot_id
FROM
  (SELECT package_id FROM BudgetPackages WHERE package_name = 'Hampi Ruins & Boulders' LIMIT 1) p,
  (SELECT spot_id    FROM TouristSpots   WHERE spot_name = 'Virupaksha Temple'          LIMIT 1) s;

-- ============================================================
-- 4. ITINERARIES — Day-by-day plans for key packages
-- ============================================================

-- ── Udaipur Royal Romance (4 nights) ──────────────────────
INSERT INTO Itineraries (package_id, day_number, title, description, activities, meals_included)
SELECT package_id, 1, 'Arrival & Lake Pichola Sunset',
  'Fly into Udaipur, check in to your haveli hotel. Late afternoon boat ride on Lake Pichola to see Jag Mandir island palace as the sun sets.',
  'Boat ride on Lake Pichola, evening stroll on Gangaur Ghat', 'Dinner'
FROM BudgetPackages WHERE package_name = 'Udaipur Royal Romance' LIMIT 1;

INSERT INTO Itineraries (package_id, day_number, title, description, activities, meals_included)
SELECT package_id, 2, 'City Palace & Cultural Evening',
  'Full guided tour of the City Palace complex — 11 palaces, crystal gallery, royal armoury. Evening Bagore Ki Haveli cultural show with Rajasthani folk dance.',
  'City Palace guided tour, Bagore Ki Haveli show', 'Breakfast,Dinner'
FROM BudgetPackages WHERE package_name = 'Udaipur Royal Romance' LIMIT 1;

INSERT INTO Itineraries (package_id, day_number, title, description, activities, meals_included)
SELECT package_id, 3, 'Sajjangarh & Rajasthani Cooking Class',
  'Morning at Sajjangarh (Monsoon Palace) for panoramic views. Afternoon Rajasthani cooking class — learn to make dal baati churma from a local chef.',
  'Sajjangarh Palace visit, Cooking class, Fateh Sagar lake walk', 'Breakfast,Lunch,Dinner'
FROM BudgetPackages WHERE package_name = 'Udaipur Royal Romance' LIMIT 1;

INSERT INTO Itineraries (package_id, day_number, title, description, activities, meals_included)
SELECT package_id, 4, 'Bazaar Shopping & Departure',
  'Morning shopping at Hathi Pol and Bada Bazaar for miniature paintings, bandhani textiles and silver jewellery. Afternoon departure.',
  'Old city bazaar shopping, Jagdish Temple visit', 'Breakfast'
FROM BudgetPackages WHERE package_name = 'Udaipur Royal Romance' LIMIT 1;

-- ── Rishikesh Yoga & Rafting (4 nights) ───────────────────
INSERT INTO Itineraries (package_id, day_number, title, description, activities, meals_included)
SELECT package_id, 1, 'Arrival & Ganga Aarti',
  'Arrive in Rishikesh by evening bus from Delhi. Check in to riverside guesthouse or ashram. Attend the evening Ganga Aarti at Triveni Ghat.',
  'Ganga Aarti ceremony, Ghat walk', 'Dinner'
FROM BudgetPackages WHERE package_name = 'Rishikesh Yoga & Rafting' LIMIT 1;

INSERT INTO Itineraries (package_id, day_number, title, description, activities, meals_included)
SELECT package_id, 2, 'Sunrise Yoga & White-Water Rafting',
  'Begin with a 90-minute sunrise yoga session on the Ganga bank. After breakfast, full-day white-water rafting on the Shivpuri to Rishikesh stretch.',
  'Morning yoga, Rafting (Grade III-IV), Laxman Jhula walk', 'Breakfast,Dinner'
FROM BudgetPackages WHERE package_name = 'Rishikesh Yoga & Rafting' LIMIT 1;

INSERT INTO Itineraries (package_id, day_number, title, description, activities, meals_included)
SELECT package_id, 3, 'Beatles Ashram & Neer Garh Trek',
  'Visit the Beatles Ashram (Chaurasi Kutia) — explore the mural-covered ruins. Afternoon trek to Neer Garh waterfall through dense forest (5km round trip).',
  'Beatles Ashram tour, Neer Garh waterfall trek, Cafe hopping on Laxman Jhula', 'Breakfast,Lunch'
FROM BudgetPackages WHERE package_name = 'Rishikesh Yoga & Rafting' LIMIT 1;

INSERT INTO Itineraries (package_id, day_number, title, description, activities, meals_included)
SELECT package_id, 4, 'Ayurveda Session & Departure',
  'Morning Ayurvedic consultation and Shirodhara treatment at a certified clinic. Afternoon meditation by the Ganges before departure.',
  'Ayurveda treatment, River meditation, Souvenir shopping', 'Breakfast'
FROM BudgetPackages WHERE package_name = 'Rishikesh Yoga & Rafting' LIMIT 1;

-- ── Darjeeling Tea & Mountains (4 nights) ─────────────────
INSERT INTO Itineraries (package_id, day_number, title, description, activities, meals_included)
SELECT package_id, 1, 'Arrival in Darjeeling',
  'Fly to Bagdogra, then shared jeep to Darjeeling (3 hours through tea-covered hills). Check in, explore Mall Road and Chowrasta square at leisure.',
  'Mall Road walk, Keventers milkshake stop', 'Dinner'
FROM BudgetPackages WHERE package_name = 'Darjeeling Tea & Mountains' LIMIT 1;

INSERT INTO Itineraries (package_id, day_number, title, description, activities, meals_included)
SELECT package_id, 2, 'Tiger Hill Sunrise & Toy Train',
  '4am jeep ride to Tiger Hill for the iconic Kanchenjunga sunrise. Return via Ghoom Monastery. Afternoon UNESCO toy train joy ride through the mountain loops.',
  'Tiger Hill sunrise, Ghoom Monastery, Toy train ride, Batasia Loop', 'Breakfast,Dinner'
FROM BudgetPackages WHERE package_name = 'Darjeeling Tea & Mountains' LIMIT 1;

INSERT INTO Itineraries (package_id, day_number, title, description, activities, meals_included)
SELECT package_id, 3, 'Tea Estate & Zoo',
  'Morning guided walk through Happy Valley Tea Estate — see plucking, withering, rolling and drying. Afternoon at Padmaja Naidu Himalayan Zoological Park.',
  'Happy Valley Tea Estate tour, Tea factory visit, Zoo (red pandas!)', 'Breakfast,Lunch,Dinner'
FROM BudgetPackages WHERE package_name = 'Darjeeling Tea & Mountains' LIMIT 1;

INSERT INTO Itineraries (package_id, day_number, title, description, activities, meals_included)
SELECT package_id, 4, 'Tea Tasting & Departure',
  'Professional tea tasting session — compare first flush, second flush and autumnal Darjeeling at a heritage tea house. Shop for single-estate tea before departure.',
  'Expert tea tasting, Tea shopping, Glenary\'s bakery visit', 'Breakfast'
FROM BudgetPackages WHERE package_name = 'Darjeeling Tea & Mountains' LIMIT 1;

-- ── Varanasi Spiritual Journey (4 nights) ─────────────────
INSERT INTO Itineraries (package_id, day_number, title, description, activities, meals_included)
SELECT package_id, 1, 'Arrival & Evening Ganga Aarti',
  'Arrive in Varanasi by flight. Check into ghat hotel. Early evening Ganga Aarti at Dashashwamedh Ghat — the fire ceremony with 7 priests is unforgettable.',
  'Hotel check-in, Dashashwamedh Ghat Aarti, evening ghat walk', 'Dinner'
FROM BudgetPackages WHERE package_name = 'Varanasi Spiritual Journey' LIMIT 1;

INSERT INTO Itineraries (package_id, day_number, title, description, activities, meals_included)
SELECT package_id, 2, 'Sunrise Boat Ride & Kashi Vishwanath',
  '5am sunrise boat ride past all 84 ghats — Manikarnika, Panchganga, Assi — as the city wakes and pilgrims bathe. Darshan at Kashi Vishwanath Temple.',
  'Sunrise Ganga boat ride, Kashi Vishwanath darshan, Old city lanes walk', 'Breakfast,Dinner'
FROM BudgetPackages WHERE package_name = 'Varanasi Spiritual Journey' LIMIT 1;

INSERT INTO Itineraries (package_id, day_number, title, description, activities, meals_included)
SELECT package_id, 3, 'Sarnath Day Trip',
  'Day trip to Sarnath (10km) — where the Buddha gave his first sermon. Visit Dhamek Stupa, Ashoka Pillar and the superb Sarnath Museum.',
  'Sarnath Dhamek Stupa, Sarnath Museum, Return for evening Aarti', 'Breakfast,Lunch'
FROM BudgetPackages WHERE package_name = 'Varanasi Spiritual Journey' LIMIT 1;

INSERT INTO Itineraries (package_id, day_number, title, description, activities, meals_included)
SELECT package_id, 4, 'Silk Workshop & Departure',
  'Morning visit to a Banarasi silk weaving workshop — watch master weavers on handlooms. Morning street food walk: kachori sabzi at dawn, thandai and malaiyo.',
  'Silk weaving workshop, Street food tour, Ganga morning meditation', 'Breakfast'
FROM BudgetPackages WHERE package_name = 'Varanasi Spiritual Journey' LIMIT 1;

-- ── Agra Taj Mahal Experience (2 nights) ──────────────────
INSERT INTO Itineraries (package_id, day_number, title, description, activities, meals_included)
SELECT package_id, 1, 'Taj Mahal Sunset & Agra Fort',
  'Arrive by Gatimaan Express from Delhi (only 100 minutes!). Afternoon visit to Agra Fort. Sunset at Mehtab Bagh garden — the best view of the Taj across the Yamuna.',
  'Agra Fort tour, Mehtab Bagh sunset, Kinari Bazaar evening stroll', 'Dinner'
FROM BudgetPackages WHERE package_name = 'Agra Taj Mahal Experience' LIMIT 1;

INSERT INTO Itineraries (package_id, day_number, title, description, activities, meals_included)
SELECT package_id, 2, 'Taj Mahal at Sunrise & Departure',
  'Wake at 5:30am for the Taj Mahal at sunrise — the golden hour light on white marble is the most beautiful sight in India. Departure by afternoon train.',
  'Taj Mahal sunrise, Itimad-ud-Daulah (Baby Taj), Petha shopping', 'Breakfast'
FROM BudgetPackages WHERE package_name = 'Agra Taj Mahal Experience' LIMIT 1;

-- ── Coorg Coffee & Wilderness (4 nights) ──────────────────
INSERT INTO Itineraries (package_id, day_number, title, description, activities, meals_included)
SELECT package_id, 1, 'Arrival & Coffee Estate',
  'Overnight bus from Bangalore, arriving in Madikeri morning. Check into plantation resort. Afternoon guided walk through arabica and robusta coffee estates.',
  'Coffee estate orientation, Estate walk, Sunset at Raja\'s Seat', 'Lunch,Dinner'
FROM BudgetPackages WHERE package_name = 'Coorg Coffee & Wilderness' LIMIT 1;

INSERT INTO Itineraries (package_id, day_number, title, description, activities, meals_included)
SELECT package_id, 2, 'Dubare Elephant Camp',
  'Morning at Dubare Elephant Camp on the Cauvery River — witness morning bathing, feeding elephants and the mahout interaction session (8:00–10:30am).',
  'Dubare elephant camp, Cauvery riverside walk, Abbey Falls', 'Breakfast,Lunch,Dinner'
FROM BudgetPackages WHERE package_name = 'Coorg Coffee & Wilderness' LIMIT 1;

INSERT INTO Itineraries (package_id, day_number, title, description, activities, meals_included)
SELECT package_id, 3, 'Namdroling Monastery & Irupu Falls',
  'Morning at Namdroling Golden Temple — stunning Tibetan Buddhist monastery with giant gilded Buddhas. Afternoon drive to Irupu Falls in Brahmagiri forest.',
  'Namdroling Golden Temple, Irupu Falls trek, Local Kodava dinner', 'Breakfast,Dinner'
FROM BudgetPackages WHERE package_name = 'Coorg Coffee & Wilderness' LIMIT 1;

INSERT INTO Itineraries (package_id, day_number, title, description, activities, meals_included)
SELECT package_id, 4, 'Cooking Class & Departure',
  'Morning Coorg cooking class — learn pandi curry, akki rotti and bamboo shoot curry with a Kodava family. Afternoon departure to Bangalore.',
  'Coorg cooking class, Coffee tasting and shopping, Departure', 'Breakfast,Lunch'
FROM BudgetPackages WHERE package_name = 'Coorg Coffee & Wilderness' LIMIT 1;

-- ── Hampi Ruins & Boulders (3 nights) ─────────────────────
INSERT INTO Itineraries (package_id, day_number, title, description, activities, meals_included)
SELECT package_id, 1, 'Arrival & Virupaksha Temple',
  'Overnight train from Bangalore to Hospet, then bus to Hampi. Check in to riverside guesthouse. Evening at Virupaksha Temple — the living heart of Hampi.',
  'Virupaksha Temple, Hampi Bazaar walk, Sunset at Hemakuta Hill', 'Dinner'
FROM BudgetPackages WHERE package_name = 'Hampi Ruins & Boulders' LIMIT 1;

INSERT INTO Itineraries (package_id, day_number, title, description, activities, meals_included)
SELECT package_id, 2, 'Vittala Temple & Matanga Sunrise',
  'Wake at 5am for Matanga Hill sunrise — panoramic view over the entire ruined city. Full-day cycle tour: Vittala Temple, Stone Chariot, Royal Enclosure, Queen\'s Bath.',
  'Matanga Hill sunrise, Vittala Temple cycle tour, Coracle ride, Royal Enclosure', 'Breakfast,Lunch,Dinner'
FROM BudgetPackages WHERE package_name = 'Hampi Ruins & Boulders' LIMIT 1;

INSERT INTO Itineraries (package_id, day_number, title, description, activities, meals_included)
SELECT package_id, 3, 'Hippie Island & Departure',
  'Morning coracle ride across the Tungabhadra to Virupapur Gadde (hippie island side). Explore lotus pond, banana plantations and small temples. Afternoon departure.',
  'Coracle boat ride, Virupapur Gadde walk, Boulder sunrise, Departure', 'Breakfast'
FROM BudgetPackages WHERE package_name = 'Hampi Ruins & Boulders' LIMIT 1;

-- ── Mysore Royal Heritage Tour (3 nights) ─────────────────
INSERT INTO Itineraries (package_id, day_number, title, description, activities, meals_included)
SELECT package_id, 1, 'Arrival & Devaraja Market',
  'Morning train from Bangalore (3 hours). Check in. Afternoon at Devaraja Market — Mysore\'s oldest and most fragrant bazaar. Evening palace area walk.',
  'Devaraja Market, Palace evening walk, Silk showroom visit', 'Dinner'
FROM BudgetPackages WHERE package_name = 'Mysore Royal Heritage Tour' LIMIT 1;

INSERT INTO Itineraries (package_id, day_number, title, description, activities, meals_included)
SELECT package_id, 2, 'Mysore Palace & Chamundi Hills',
  'Full-day of royal Mysore. Morning at Mysore Palace with expert guide. Afternoon drive to Chamundeshwari Temple on Chamundi Hills. Evening: stay for Sunday palace illumination.',
  'Mysore Palace guided tour, Chamundi Hills temple, Palace illumination (Sunday)', 'Breakfast,Dinner'
FROM BudgetPackages WHERE package_name = 'Mysore Royal Heritage Tour' LIMIT 1;

INSERT INTO Itineraries (package_id, day_number, title, description, activities, meals_included)
SELECT package_id, 3, 'Brindavan Gardens & Departure',
  'Morning at Brindavan Gardens and KRS Dam — terraced gardens with musical fountain show. Mysore Pak sweet shopping at Sri Krishna Sweets. Afternoon departure.',
  'Brindavan Gardens, KRS Dam, Mysore Pak shopping, Silk saree shopping', 'Breakfast'
FROM BudgetPackages WHERE package_name = 'Mysore Royal Heritage Tour' LIMIT 1;

-- ── Shimla Snow Holiday (4 nights) ────────────────────────
INSERT INTO Itineraries (package_id, day_number, title, description, activities, meals_included)
SELECT package_id, 1, 'Arrival via Kalka–Shimla Toy Train',
  'Take the stunning Kalka–Shimla UNESCO toy train from Kalka (5:30am, arrives 9:25am). Check in near The Ridge. Evening Mall Road stroll.',
  'Kalka-Shimla toy train, Mall Road stroll, Christ Church visit', 'Dinner'
FROM BudgetPackages WHERE package_name = 'Shimla Snow Holiday' LIMIT 1;

INSERT INTO Itineraries (package_id, day_number, title, description, activities, meals_included)
SELECT package_id, 2, 'Kufri Snow Sports',
  'Day trip to Kufri (13km) — snow activities including zorbing, tobogganing, skiing and yak rides. Return to Shimla for evening Heritage Walk.',
  'Kufri snow activities, Jakhu Temple monkey walk, Heritage Walk', 'Breakfast,Dinner'
FROM BudgetPackages WHERE package_name = 'Shimla Snow Holiday' LIMIT 1;

INSERT INTO Itineraries (package_id, day_number, title, description, activities, meals_included)
SELECT package_id, 3, 'Chail Day Trip',
  'Day trip to Chail — world\'s highest cricket ground, Chail Palace and Chail Wildlife Sanctuary. Return via the scenic Mashobra apple orchard road.',
  'Chail Palace, World\'s highest cricket ground, Apple orchard walk', 'Breakfast,Lunch,Dinner'
FROM BudgetPackages WHERE package_name = 'Shimla Snow Holiday' LIMIT 1;

INSERT INTO Itineraries (package_id, day_number, title, description, activities, meals_included)
SELECT package_id, 4, 'State Museum & Departure',
  'Morning at Shimla State Museum (Pahari miniature paintings, sculptures). Final Mall Road shopping. Afternoon bus to Delhi.',
  'Shimla State Museum, Mall Road shopping, Indian Coffee House breakfast', 'Breakfast'
FROM BudgetPackages WHERE package_name = 'Shimla Snow Holiday' LIMIT 1;

-- ── Ooty Hill Station Escape (3 nights) ───────────────────
INSERT INTO Itineraries (package_id, day_number, title, description, activities, meals_included)
SELECT package_id, 1, 'Nilgiri Mountain Railway & Arrival',
  'Take the UNESCO Nilgiri Mountain Railway from Mettupalayam to Ooty — a 5-hour mountain journey with 208 curves through jungle and tea estates. Check in and explore.',
  'Nilgiri toy train ride, Charing Cross exploration, Ooty Chocolate shopping', 'Dinner'
FROM BudgetPackages WHERE package_name = 'Ooty Hill Station Escape' LIMIT 1;

INSERT INTO Itineraries (package_id, day_number, title, description, activities, meals_included)
SELECT package_id, 2, 'Botanical Gardens & Doddabetta',
  'Morning at the Government Botanical Gardens — 150 years of horticultural history. Afternoon drive to Doddabetta Peak (2,637m) for panoramic Nilgiri views.',
  'Botanical Gardens, Doddabetta Peak, Rose Garden, Ooty Lake boating', 'Breakfast,Lunch,Dinner'
FROM BudgetPackages WHERE package_name = 'Ooty Hill Station Escape' LIMIT 1;

INSERT INTO Itineraries (package_id, day_number, title, description, activities, meals_included)
SELECT package_id, 3, 'Tea Factory Tour & Departure',
  'Morning at a working Nilgiri tea factory — see withering, rolling, drying and sorting. Tea tasting session. Buy single-estate Nilgiri tea before departure to Coimbatore.',
  'Tea factory tour, Tea tasting, Ooty market, Departure to Coimbatore', 'Breakfast'
FROM BudgetPackages WHERE package_name = 'Ooty Hill Station Escape' LIMIT 1;

-- ============================================================
-- 5. BOOKINGS — 25 realistic bookings with the new users
-- ============================================================
-- Note: user_ids 4–18 are the 15 new users above
-- Hotel IDs and Package IDs are referenced by consistent ordering

INSERT INTO Bookings (user_id, hotel_id, transport_id, package_id, check_in_date, check_out_date, num_people, status, total_amount) VALUES
-- Rohan (4) — Udaipur trip
(4,  (SELECT hotel_id FROM Hotels WHERE hotel_name='Hotel Badi Haveli' LIMIT 1),
     (SELECT transport_id FROM Transport WHERE source='Delhi' AND destination='Udaipur' AND type='Flight' LIMIT 1),
     (SELECT package_id FROM BudgetPackages WHERE package_name='Udaipur Royal Romance' LIMIT 1),
     '2025-10-15', '2025-10-19', 2, 'Confirmed', 44000.00),

-- Priya (5) — Goa trip
(5,  (SELECT hotel_id FROM Hotels WHERE hotel_name='Zostel Goa' LIMIT 1),
     (SELECT transport_id FROM Transport WHERE source='Delhi' AND destination='Goa' AND type='Flight' LIMIT 1),
     (SELECT package_id FROM BudgetPackages WHERE package_name='Goa Sunshine Package' LIMIT 1),
     '2025-12-20', '2025-12-24', 1, 'Confirmed', 15000.00),

-- Arjun (6) — Rishikesh adventure
(6,  (SELECT hotel_id FROM Hotels WHERE hotel_name='Zostel Rishikesh' LIMIT 1),
     (SELECT transport_id FROM Transport WHERE source='Delhi' AND destination='Rishikesh' AND type='Bus' LIMIT 1),
     (SELECT package_id FROM BudgetPackages WHERE package_name='Rishikesh Adventure Camp' LIMIT 1),
     '2025-09-05', '2025-09-10', 2, 'Confirmed', 28000.00),

-- Sneha (7) — Kerala honeymoon
(7,  (SELECT hotel_id FROM Hotels WHERE hotel_name='Kumarakom Lake Resort' LIMIT 1),
     NULL,
     (SELECT package_id FROM BudgetPackages WHERE package_name='Kerala Serenity Trip' LIMIT 1),
     '2025-11-01', '2025-11-07', 2, 'Confirmed', 40000.00),

-- Vikram (8) — Ladakh bike trip
(8,  (SELECT hotel_id FROM Hotels WHERE hotel_name='Chamba Camp Thiksey' LIMIT 1),
     (SELECT transport_id FROM Transport WHERE source='Delhi' AND destination='Leh' AND type='Flight' LIMIT 1),
     (SELECT package_id FROM BudgetPackages WHERE package_name='Ladakh Adventure' LIMIT 1),
     '2025-07-10', '2025-07-17', 1, 'Confirmed', 25000.00),

-- Ananya (9) — Darjeeling
(9,  (SELECT hotel_id FROM Hotels WHERE hotel_name='Glenburn Tea Estate' LIMIT 1),
     (SELECT transport_id FROM Transport WHERE source='Delhi' AND destination='Bagdogra' AND type='Flight' LIMIT 1),
     (SELECT package_id FROM BudgetPackages WHERE package_name='Darjeeling Tea & Mountains' LIMIT 1),
     '2025-04-08', '2025-04-12', 2, 'Confirmed', 58000.00),

-- Karan (10) — Shimla winter
(10, (SELECT hotel_id FROM Hotels WHERE hotel_name='The Cecil Shimla' LIMIT 1),
     (SELECT transport_id FROM Transport WHERE source='Delhi' AND destination='Shimla' AND type='Bus' LIMIT 1),
     (SELECT package_id FROM BudgetPackages WHERE package_name='Shimla Snow Holiday' LIMIT 1),
     '2026-01-15', '2026-01-19', 4, 'Pending', 64000.00),

-- Divya (11) — Varanasi spiritual
(11, (SELECT hotel_id FROM Hotels WHERE hotel_name='Hotel Ganges View' LIMIT 1),
     (SELECT transport_id FROM Transport WHERE source='Delhi' AND destination='Varanasi' AND type='Flight' LIMIT 1),
     (SELECT package_id FROM BudgetPackages WHERE package_name='Varanasi Spiritual Journey' LIMIT 1),
     '2025-10-28', '2025-11-01', 2, 'Confirmed', 24000.00),

-- Rahul (12) — Agra Taj trip
(12, (SELECT hotel_id FROM Hotels WHERE hotel_name='Hotel Taj Resorts' LIMIT 1),
     (SELECT transport_id FROM Transport WHERE source='Delhi' AND destination='Agra' AND type='Train' LIMIT 1),
     (SELECT package_id FROM BudgetPackages WHERE package_name='Agra Taj Mahal Experience' LIMIT 1),
     '2025-11-22', '2025-11-24', 2, 'Confirmed', 20000.00),

-- Meera (13) — Coorg retreat
(13, (SELECT hotel_id FROM Hotels WHERE hotel_name='The Tamara Coorg' LIMIT 1),
     (SELECT transport_id FROM Transport WHERE source='Bangalore' AND destination='Coorg' AND type='Bus' LIMIT 1),
     (SELECT package_id FROM BudgetPackages WHERE package_name='Coorg Coffee & Wilderness' LIMIT 1),
     '2025-11-10', '2025-11-14', 2, 'Confirmed', 32000.00),

-- Aditya (14) — Jaipur heritage
(14, (SELECT hotel_id FROM Hotels WHERE hotel_name='Rambagh Palace' LIMIT 1),
     (SELECT transport_id FROM Transport WHERE source='Mumbai' AND destination='Jaipur' AND type='Flight' LIMIT 1),
     (SELECT package_id FROM BudgetPackages WHERE package_name='Jaipur Royal Tour' LIMIT 1),
     '2025-12-05', '2025-12-08', 2, 'Pending', 36000.00),

-- Pooja (15) — Ooty family
(15, (SELECT hotel_id FROM Hotels WHERE hotel_name='Sterling Elk Hill Ooty' LIMIT 1),
     (SELECT transport_id FROM Transport WHERE source='Coimbatore' AND destination='Ooty' AND type='Bus' LIMIT 1),
     (SELECT package_id FROM BudgetPackages WHERE package_name='Ooty Family Holiday' LIMIT 1),
     '2025-05-01', '2025-05-05', 4, 'Confirmed', 56000.00),

-- Nikhil (16) — Mysore palace
(16, (SELECT hotel_id FROM Hotels WHERE hotel_name='Radisson Blu Plaza Mysore' LIMIT 1),
     (SELECT transport_id FROM Transport WHERE source='Bangalore' AND destination='Mysore' AND type='Train' LIMIT 1),
     (SELECT package_id FROM BudgetPackages WHERE package_name='Mysore Royal Heritage Tour' LIMIT 1),
     '2025-10-10', '2025-10-13', 2, 'Confirmed', 26000.00),

-- Swati (17) — Hampi explorer
(17, (SELECT hotel_id FROM Hotels WHERE hotel_name='Hampi Boulders' LIMIT 1),
     (SELECT transport_id FROM Transport WHERE source='Bangalore' AND destination='Hospet' AND type='Train' LIMIT 1),
     (SELECT package_id FROM BudgetPackages WHERE package_name='Hampi Ruins & Boulders' LIMIT 1),
     '2025-11-28', '2025-12-01', 2, 'Confirmed', 24000.00),

-- Gaurav (18) — Manali snow
(18, (SELECT hotel_id FROM Hotels WHERE hotel_name='The Himalayan' LIMIT 1),
     NULL,
     (SELECT package_id FROM BudgetPackages WHERE package_name='Manali Snow Escape' LIMIT 1),
     '2026-01-10', '2026-01-15', 2, 'Pending', 24000.00),

-- Rohan (4) second trip — Hampi
(4,  (SELECT hotel_id FROM Hotels WHERE hotel_name='Zostel Hampi' LIMIT 1),
     (SELECT transport_id FROM Transport WHERE source='Bangalore' AND destination='Hospet' AND type='Train' LIMIT 1),
     NULL,
     '2026-02-14', '2026-02-17', 1, 'Confirmed', 8500.00),

-- Priya (5) — Shimla
(5,  (SELECT hotel_id FROM Hotels WHERE hotel_name='Zostel Shimla' LIMIT 1),
     (SELECT transport_id FROM Transport WHERE source='Delhi' AND destination='Shimla' AND type='Bus' LIMIT 1),
     (SELECT package_id FROM BudgetPackages WHERE package_name='Shimla Budget Explorer' LIMIT 1),
     '2026-01-20', '2026-01-23', 1, 'Confirmed', 9000.00),

-- Ananya (9) — Rishikesh wellness
(9,  (SELECT hotel_id FROM Hotels WHERE hotel_name='Ananda in the Himalayas' LIMIT 1),
     NULL,
     (SELECT package_id FROM BudgetPackages WHERE package_name='Rishikesh Wellness Retreat' LIMIT 1),
     '2025-09-15', '2025-09-22', 1, 'Confirmed', 38000.00),

-- Karan (10) — Goa friends trip
(10, (SELECT hotel_id FROM Hotels WHERE hotel_name='Zostel Goa' LIMIT 1),
     (SELECT transport_id FROM Transport WHERE source='Delhi' AND destination='Goa' AND type='Flight' LIMIT 1),
     (SELECT package_id FROM BudgetPackages WHERE package_name='Goa Sunshine Package' LIMIT 1),
     '2025-12-26', '2025-12-30', 4, 'Confirmed', 60000.00),

-- Divya (11) — Kerala backwaters
(11, (SELECT hotel_id FROM Hotels WHERE hotel_name='Backwater Bliss' LIMIT 1),
     NULL,
     (SELECT package_id FROM BudgetPackages WHERE package_name='Kerala Serenity Trip' LIMIT 1),
     '2026-02-10', '2026-02-16', 2, 'Pending', 40000.00),

-- Vikram (8) — Udaipur solo
(8,  (SELECT hotel_id FROM Hotels WHERE hotel_name='Zostel Udaipur' LIMIT 1),
     (SELECT transport_id FROM Transport WHERE source='Delhi' AND destination='Udaipur' AND type='Train' LIMIT 1),
     (SELECT package_id FROM BudgetPackages WHERE package_name='Udaipur Heritage Explorer' LIMIT 1),
     '2026-03-05', '2026-03-08', 1, 'Confirmed', 13500.00),

-- Meera (13) — Mysore Dasara
(13, (SELECT hotel_id FROM Hotels WHERE hotel_name='Lalitha Mahal Palace Hotel' LIMIT 1),
     (SELECT transport_id FROM Transport WHERE source='Bangalore' AND destination='Mysore' AND type='Bus' LIMIT 1),
     (SELECT package_id FROM BudgetPackages WHERE package_name='Mysore to Coorg Explorer' LIMIT 1),
     '2025-10-03', '2025-10-08', 2, 'Confirmed', 44000.00),

-- Sneha (7) — Agra Golden Triangle
(7,  (SELECT hotel_id FROM Hotels WHERE hotel_name='ITC Mughal Agra' LIMIT 1),
     (SELECT transport_id FROM Transport WHERE source='Delhi' AND destination='Agra' AND type='Train' LIMIT 1),
     (SELECT package_id FROM BudgetPackages WHERE package_name='Agra Golden Triangle' LIMIT 1),
     '2026-02-20', '2026-02-24', 2, 'Pending', 48000.00),

-- Gaurav (18) — Varanasi
(18, (SELECT hotel_id FROM Hotels WHERE hotel_name='Zostel Varanasi' LIMIT 1),
     (SELECT transport_id FROM Transport WHERE source='Delhi' AND destination='Varanasi' AND type='Train' LIMIT 1),
     (SELECT package_id FROM BudgetPackages WHERE package_name='Varanasi Budget Pilgrim' LIMIT 1),
     '2025-11-14', '2025-11-17', 1, 'Confirmed', 7500.00),

-- Pooja (15) — Coorg budget
(15, (SELECT hotel_id FROM Hotels WHERE hotel_name='Zostel Coorg' LIMIT 1),
     (SELECT transport_id FROM Transport WHERE source='Bangalore' AND destination='Coorg' AND type='Bus' LIMIT 1),
     (SELECT package_id FROM BudgetPackages WHERE package_name='Coorg Budget Explorer' LIMIT 1),
     '2026-03-12', '2026-03-15', 1, 'Confirmed', 9500.00);

-- ============================================================
-- 6. PAYMENTS for new bookings (using booking sequence)
-- ============================================================
-- Retrieve booking IDs for confirmed bookings and create payments
-- Using a safe approach with subqueries on amount+user_id combos

INSERT INTO Payments (booking_id, amount, payment_method, status, transaction_id)
SELECT booking_id, total_amount, 'UPI', 'Success',
       CONCAT('TXN2025', LPAD(booking_id, 6, '0'))
FROM Bookings
WHERE status = 'Confirmed'
  AND booking_id > 3
  AND total_amount > 0;

INSERT INTO Payments (booking_id, amount, payment_method, status, transaction_id)
SELECT booking_id, total_amount, 'Credit Card', 'Pending',
       CONCAT('TXN2026', LPAD(booking_id, 6, '0'))
FROM Bookings
WHERE status = 'Pending'
  AND booking_id > 3
  AND total_amount > 0;

-- ============================================================
-- 7. REVIEWS — From new users on hotels and spots
-- ============================================================
INSERT INTO Reviews (user_id, hotel_id, spot_id, rating, comment) VALUES
-- Hotel reviews
(4,  (SELECT hotel_id FROM Hotels WHERE hotel_name='Hotel Badi Haveli' LIMIT 1),      NULL, 5, 'Absolutely stunning heritage haveli right on the ghats. Lake view from our room was like a painting. The rooftop breakfast watching the boats is an experience we'll never forget.'),
(5,  (SELECT hotel_id FROM Hotels WHERE hotel_name='Zostel Goa' LIMIT 1),             NULL, 5, 'The perfect Goa hostel! Rooftop bar, incredible social atmosphere, and the staff organised a bonfire beach night that became the highlight of our whole trip.'),
(6,  (SELECT hotel_id FROM Hotels WHERE hotel_name='Zostel Rishikesh' LIMIT 1),       NULL, 5, 'Perfect location on the Ganges. Fell asleep to the sound of the river and woke up to yoga on the deck. The staff here genuinely care about travellers.'),
(7,  (SELECT hotel_id FROM Hotels WHERE hotel_name='Kumarakom Lake Resort' LIMIT 1),  NULL, 5, 'Honeymoon dreams come true. Pool villa overlooking the backwaters, private boat rides at dawn, and the breakfast was the best we\'ve ever had in India.'),
(8,  (SELECT hotel_id FROM Hotels WHERE hotel_name='Chamba Camp Thiksey' LIMIT 1),    NULL, 5, 'Waking up to see Thiksey Monastery literally outside your tent window is surreal. Luxury tents, brilliant guides, world-class spa. Worth every rupee.'),
(9,  (SELECT hotel_id FROM Hotels WHERE hotel_name='Glenburn Tea Estate' LIMIT 1),    NULL, 5, 'This is what travel is supposed to be. Colonial bungalow, working tea estate, Kanchenjunga at breakfast, and a tea sommelier who changed how I understand tea forever.'),
(10, (SELECT hotel_id FROM Hotels WHERE hotel_name='The Cecil Shimla' LIMIT 1),       NULL, 4, 'Beautiful heritage hotel with a lovely lawn and valley views. Slightly dated rooms but the character and history make up for it. Great staff and lovely evening high tea.'),
(11, (SELECT hotel_id FROM Hotels WHERE hotel_name='Hotel Ganges View' LIMIT 1),      NULL, 4, 'Watching the Ganga Aarti from our rooftop terrace while it floated in was magical. Rooms are basic but clean. The location on Assi Ghat is absolutely unbeatable.'),
(12, (SELECT hotel_id FROM Hotels WHERE hotel_name='Hotel Taj Resorts' LIMIT 1),      NULL, 4, 'Good mid-range option near the Taj Mahal. Clean rooms, helpful staff, and the rooftop restaurant has a distant view of the Taj dome. Book the sunrise wake-up call!'),
(13, (SELECT hotel_id FROM Hotels WHERE hotel_name='The Tamara Coorg' LIMIT 1),       NULL, 5, 'Rainforest luxury. Woke up to mist in the treetops every morning. The coffee trail with the estate manager was fascinating. Absolutely in love with Coorg.'),
(14, (SELECT hotel_id FROM Hotels WHERE hotel_name='Rambagh Palace' LIMIT 1),         NULL, 5, 'This is the benchmark for luxury in India. We played polo (badly), ate in the Suvarna Mahal, and felt like royalty. Jaipur at night from the terrace is extraordinary.'),
(15, (SELECT hotel_id FROM Hotels WHERE hotel_name='Sterling Elk Hill Ooty' LIMIT 1), NULL, 4, 'Perfect for families. Bonfire every evening, the kids loved the miniature horse rides, and the valley views from our room never got old. Good food too.'),
(16, (SELECT hotel_id FROM Hotels WHERE hotel_name='Radisson Blu Plaza Mysore' LIMIT 1),NULL,4, 'Excellent base for Mysore. Pool was fantastic, location close to the palace is very convenient. Watched the Sunday evening palace illumination from the rooftop — jaw-dropping.'),
(17, (SELECT hotel_id FROM Hotels WHERE hotel_name='Hampi Boulders' LIMIT 1),         NULL, 5, 'Eco cottages built around massive granite boulders with ruins visible from the terrace. The pool at sunset, the food, the history tour with their guide — perfect 3 days.'),
(18, (SELECT hotel_id FROM Hotels WHERE hotel_name='The Himalayan' LIMIT 1),          NULL, 5, 'Fireplace in every room, spa with valley views, and the breakfast buffet with homemade apple jam from the estate orchards. Manali in winter is magical.'),
-- Spot reviews
(4,  NULL, (SELECT spot_id FROM TouristSpots WHERE spot_name='City Palace Udaipur' LIMIT 1),    5, 'The scale of the City Palace complex shocked me — 11 connected palaces built over centuries. The crystal gallery is extraordinary. Hire a guide; you\'ll miss so much without one.'),
(5,  NULL, (SELECT spot_id FROM TouristSpots WHERE spot_name='Baga Beach' LIMIT 1),            4, 'Classic Goa beach energy. Water sports are great fun, the shacks have amazing food, and the sunset here is genuinely beautiful. A bit crowded in peak season but that\'s part of it.'),
(6,  NULL, (SELECT spot_id FROM TouristSpots WHERE spot_name='Laxman Jhula' LIMIT 1),          5, 'The bridge, the Ganges below, monkeys everywhere, sadhus in orange, the sound of temple bells — this single moment summarises why India is unlike anywhere else on earth.'),
(7,  NULL, (SELECT spot_id FROM TouristSpots WHERE spot_name='Alleppey Backwaters' LIMIT 1),   5, 'Overnight houseboat honeymoon. Waking up to absolute silence and mist on the canals at 6am was the most peaceful moment of our lives. Booking this again for our anniversary.'),
(8,  NULL, (SELECT spot_id FROM TouristSpots WHERE spot_name='Pangong Lake' LIMIT 1),          5, 'No photograph prepares you for Pangong Tso. The colour is electric — somewhere between sapphire and turquoise — and the Himalayan silence is absolute. Transformative experience.'),
(9,  NULL, (SELECT spot_id FROM TouristSpots WHERE spot_name='Tiger Hill Sunrise' LIMIT 1),    5, 'We saw Kanchenjunga, Makalu AND Everest on one perfect morning. We were all speechless. The 4am alarm was the best alarm I\'ve ever set in my life.'),
(10, NULL, (SELECT spot_id FROM TouristSpots WHERE spot_name='Jakhu Temple' LIMIT 1),          4, 'Hilarious and beautiful. The monkeys are incredibly bold (hold your belongings!) but the views of Shimla below and the giant Hanuman statue are unforgettable. Go at dawn.'),
(11, NULL, (SELECT spot_id FROM TouristSpots WHERE spot_name='Dashashwamedh Ghat' LIMIT 1),    5, 'The Ganga Aarti is one of those experiences that makes you understand why people have been drawn to Varanasi for 3,000 years. Standing there at dusk, I felt genuinely moved.'),
(12, NULL, (SELECT spot_id FROM TouristSpots WHERE spot_name='Taj Mahal' LIMIT 1),             5, 'I\'ve seen thousands of photos of the Taj Mahal. None of them prepare you for the real thing. At sunrise, with the sky turning gold behind it, I stood there with tears in my eyes.'),
(13, NULL, (SELECT spot_id FROM TouristSpots WHERE spot_name='Dubare Elephant Camp' LIMIT 1),  5, 'Watching the mahouts lead their elephants into the Cauvery for morning bathing is the most joyful thing I\'ve seen in India. Book the early morning slot — worth waking up for.'),
(14, NULL, (SELECT spot_id FROM TouristSpots WHERE spot_name='Amber Fort' LIMIT 1),            5, 'Amber Fort is genuinely one of the most impressive structures I\'ve seen anywhere in the world. The mirror palace (Sheesh Mahal) is breathtaking. Go early before the crowds arrive.'),
(15, NULL, (SELECT spot_id FROM TouristSpots WHERE spot_name='Ooty Botanical Gardens' LIMIT 1),4, 'Beautifully maintained and surprisingly huge. The 20-million-year-old fossilised tree trunk is remarkable. Go during the annual flower show in May for the best experience.'),
(16, NULL, (SELECT spot_id FROM TouristSpots WHERE spot_name='Mysore Palace' LIMIT 1),         5, 'The Sunday evening illumination with 100,000 bulbs is not a tourist exaggeration — it genuinely looks like something from a fairy tale. Nothing in India quite prepares you for it.'),
(17, NULL, (SELECT spot_id FROM TouristSpots WHERE spot_name='Vittala Temple Complex' LIMIT 1),5, 'The Stone Chariot alone is worth the trip to Hampi. But the Musical Pillars, the scale of the complex, the boulders all around — it\'s an archaeological dream. Cycle here at dawn.'),
(18, NULL, (SELECT spot_id FROM TouristSpots WHERE spot_name='Rohtang Pass' LIMIT 1),          5, 'One of the most dramatic landscapes I\'ve ever seen. Snow in July, prayer flags in the wind, motorcycle convoys going to Leh. The permit system is annoying but very necessary.'),
-- Cross-reviews (existing users reviewing new spots)
(1,  NULL, (SELECT spot_id FROM TouristSpots WHERE spot_name='Lake Pichola' LIMIT 1),          5, 'I visited Udaipur specifically for Lake Pichola. The sunset boat ride was even better than I imagined — the way the marble palaces reflect in the water at golden hour is extraordinary.'),
(2,  NULL, (SELECT spot_id FROM TouristSpots WHERE spot_name='Taj Mahal' LIMIT 1),             5, 'Every Indian should visit the Taj Mahal at least once. I went at sunrise and stood there for an hour just absorbing it. It is genuinely the most beautiful human creation I\'ve ever seen.'),
(3,  NULL, (SELECT spot_id FROM TouristSpots WHERE spot_name='Vittala Temple Complex' LIMIT 1),5, 'Hampi is in another category from any other heritage site in India. The ruins spread for 26 square kilometres and the landscape of boulders and banana groves makes it feel like another planet.');

-- ============================================================
-- 8. WISHLISTS — New users saving places for future trips
-- ============================================================
INSERT INTO Wishlist (user_id, hotel_id, spot_id, package_id) VALUES
(4,  NULL, (SELECT spot_id FROM TouristSpots WHERE spot_name='Pangong Lake' LIMIT 1),               NULL),
(4,  NULL, NULL, (SELECT package_id FROM BudgetPackages WHERE package_name='Ladakh Adventure' LIMIT 1)),
(5,  (SELECT hotel_id FROM Hotels WHERE hotel_name='Ananda in the Himalayas' LIMIT 1),              NULL, NULL),
(5,  NULL, (SELECT spot_id FROM TouristSpots WHERE spot_name='Taj Mahal' LIMIT 1),                  NULL),
(6,  NULL, NULL, (SELECT package_id FROM BudgetPackages WHERE package_name='Kerala Serenity Trip' LIMIT 1)),
(6,  NULL, (SELECT spot_id FROM TouristSpots WHERE spot_name='Tiger Hill Sunrise' LIMIT 1),         NULL),
(7,  (SELECT hotel_id FROM Hotels WHERE hotel_name='Taj Lake Palace Udaipur' LIMIT 1),              NULL, NULL),
(7,  NULL, NULL, (SELECT package_id FROM BudgetPackages WHERE package_name='Udaipur Luxury Lake Escape' LIMIT 1)),
(8,  NULL, (SELECT spot_id FROM TouristSpots WHERE spot_name='Vittala Temple Complex' LIMIT 1),     NULL),
(8,  NULL, NULL, (SELECT package_id FROM BudgetPackages WHERE package_name='Hampi Ruins & Boulders' LIMIT 1)),
(9,  (SELECT hotel_id FROM Hotels WHERE hotel_name='Evolve Back Coorg' LIMIT 1),                    NULL, NULL),
(9,  NULL, NULL, (SELECT package_id FROM BudgetPackages WHERE package_name='Coorg Luxury Plantation' LIMIT 1)),
(10, NULL, (SELECT spot_id FROM TouristSpots WHERE spot_name='Dashashwamedh Ghat' LIMIT 1),         NULL),
(10, NULL, (SELECT spot_id FROM TouristSpots WHERE spot_name='Kashi Vishwanath Temple' LIMIT 1),    NULL),
(11, NULL, NULL, (SELECT package_id FROM BudgetPackages WHERE package_name='Mysore to Coorg Explorer' LIMIT 1)),
(11, (SELECT hotel_id FROM Hotels WHERE hotel_name='Lalitha Mahal Palace Hotel' LIMIT 1),           NULL, NULL),
(12, NULL, (SELECT spot_id FROM TouristSpots WHERE spot_name='Mysore Palace' LIMIT 1),              NULL),
(12, NULL, NULL, (SELECT package_id FROM BudgetPackages WHERE package_name='Mysore Royal Heritage Tour' LIMIT 1)),
(13, (SELECT hotel_id FROM Hotels WHERE hotel_name='Evolve Back Hampi' LIMIT 1),                    NULL, NULL),
(13, NULL, (SELECT spot_id FROM TouristSpots WHERE spot_name='Matanga Hill' LIMIT 1),               NULL),
(14, NULL, NULL, (SELECT package_id FROM BudgetPackages WHERE package_name='Agra Golden Triangle' LIMIT 1)),
(14, (SELECT hotel_id FROM Hotels WHERE hotel_name='Oberoi Amarvilas' LIMIT 1),                     NULL, NULL),
(15, NULL, (SELECT spot_id FROM TouristSpots WHERE spot_name='Hemis Festival' LIMIT 1),             NULL),
(16, NULL, NULL, (SELECT package_id FROM BudgetPackages WHERE package_name='Darjeeling Himalayan Explorer' LIMIT 1)),
(17, NULL, (SELECT spot_id FROM TouristSpots WHERE spot_name='Abbey Falls' LIMIT 1),                NULL),
(18, NULL, NULL, (SELECT package_id FROM BudgetPackages WHERE package_name='Rishikesh Wellness Retreat' LIMIT 1));

-- ============================================================
-- 9. CHAT LOGS — Realistic Yami chatbot conversations
-- ============================================================
INSERT INTO ChatLogs (user_id, message, response) VALUES
(4,  'I want to plan a romantic trip for my anniversary. Any suggestions?',
     'Congratulations on your anniversary! For romance in India, Udaipur is absolutely unbeatable — lake palaces, candlelit boats, and the most beautiful sunsets in Rajasthan. Kerala backwaters on a private houseboat is equally magical. What is your approximate budget?'),
(4,  'Budget around 50000 for 4 nights for two people.',
     'Perfect! For ₹50,000 for two over 4 nights, I recommend the Udaipur Royal Romance package. Includes a heritage haveli hotel on the lake, City Palace guided tour, sunset boat ride, and a Rajasthani cultural evening. Shall I take you to the booking page?'),
(5,  'Best beaches in Goa? First time visiting!',
     'Welcome to Goa! For first-timers: Calangute for energy and water sports, Anjuna for bohemian vibes and the famous flea market, and Palolem in South Goa for sheer beauty and a quieter pace. I recommend starting in North Goa and ending with 1–2 days in South Goa!'),
(5,  'Is December a good time to visit Goa?',
     'December is the BEST time for Goa! Peak season, perfect weather (27–30°C, no rain), all the beach shacks are open, and the Christmas and New Year celebrations are legendary. Book accommodation well in advance — it sells out months ahead for December!'),
(6,  'Tell me about rafting in Rishikesh.',
     'Rishikesh is India\'s white-water rafting capital! The classic stretch is Shivpuri to Rishikesh — 16km of Grade II–IV rapids through forest gorges. Marine Drive is more intense for experienced rafters. Season: February to June and September to November. Price: ₹600–900 per person with certified operators.'),
(6,  'Can beginners do rafting there?',
     'Absolutely! The Brahmpuri to Rishikesh stretch (9km) is Grade I–II, perfect for complete beginners and families with children. The Shivpuri stretch has Grade III rapids which are exciting but manageable. The operators give full safety briefing and all equipment. I recommend Marine Drive only for experienced swimmers!'),
(7,  'We are a couple looking for a honeymoon destination. Kerala or Udaipur?',
     'Both are incredible for honeymoons! Kerala gives you private houseboat mornings, Ayurvedic spa retreats, and lush backwaters. Udaipur gives you lake palace hotels, rooftop candlelit dinners, and Rajasthani royalty vibes. My honest pick: Kerala for nature & wellness, Udaipur for romance & grandeur. What\'s your vibe?'),
(8,  'What is the best time to visit Ladakh?',
     'Ladakh is only accessible June to September — roads open after the snowmelt. July–August has all routes open including Pangong Tso and Nubra Valley. June and September are slightly quieter and cheaper. AVOID October–May — the Manali–Leh and Srinagar–Leh highways are closed and temperatures hit -30°C!'),
(9,  'Tell me about the Darjeeling toy train.',
     'The Darjeeling Himalayan Railway is a UNESCO World Heritage Site and one of the most scenic rail journeys in the world! The steam engine chugs through mountain loops, tea estates, mist and tunnels. The famous Batasia Loop spiral is stunning. Book tickets 3–4 days ahead, especially in spring. The round-trip joy ride from Darjeeling station takes 2 hours — perfect!'),
(10, 'Is Shimla worth visiting in January?',
     'January in Shimla is MAGICAL if you love snow! The Ridge and Mall Road get blanketed in white, the Kufri ski slopes are at their best, and the colonial buildings with snow on them look like a Christmas card. Just pack very warm clothes — it drops to -5°C. The Kalka-Shimla toy train through snowy landscapes is breathtaking!'),
(11, 'What should I not miss in Varanasi?',
     'Non-negotiables in Varanasi: (1) Dawn boat ride on the Ganges — 5am, before tourists, the most moving sight in India. (2) Ganga Aarti at Dashashwamedh Ghat at dusk — arrive 30 min early. (3) Old city alley walk with a good guide. (4) Morning kachori sabzi breakfast at a ghat dhaba. (5) Sarnath day trip — where Buddha gave his first sermon. Varanasi needs 3 full days minimum.'),
(12, 'How do I book Taj Mahal tickets?',
     'Taj Mahal tickets can be booked online at the Archaeological Survey of India website (asi.payumoney.com) or at the ticket counters near the east and west gates. Foreign visitors: ₹1,100. Indian citizens: ₹50. MUST-DO: Book the sunrise slot (gates open 6am) — the light at dawn is extraordinary and crowds are minimal. The full-moon night viewing is special but limited to 400 tickets, booked weeks ahead!'),
(13, 'What is special about Coorg?',
     'Coorg (Kodagu) is Karnataka\'s most beautiful district and completely different from any other India destination! It\'s famous for coffee and cardamom estates you can actually stay on, the Kodava warrior culture with their unique cuisine (pandi curry is incredible), Abbey Falls hidden in coffee forest, and Dubare Elephant Camp on the Cauvery River. Plus Nagarhole Tiger Reserve is just 40km away for safari.'),
(14, 'Tell me about the best hotels in Jaipur.',
     'Jaipur has incredible hotels at every price point! Budget: Pearl Palace Heritage (₹1,800/night, rooftop cafe). Mid-range: Dera Mandawa Haveli (₹3,200/night, authentic haveli). Luxury: Rambagh Palace (₹18,000/night) — the former royal residence of the Maharaja with polo, fine dining and butler service. For pure indulgence, staying in the palace is the ultimate Jaipur experience!'),
(15, 'Is Ooty good for families?',
     'Ooty is fantastic for families! Kids love: the Nilgiri Mountain Railway toy train, Ooty Lake boating, the Botanical Gardens fossil tree, pony rides at Doddabetta, and the homemade chocolate shops (they will not stop asking for more!). Sterling Elk Hill resort is excellent for families — bonfire, activities, and beautiful valley views. Best time: April–June during school holidays for perfect weather.'),
(16, 'What can I do in Mysore in 2 days?',
     'Mysore in 2 days — perfect! Day 1: Mysore Palace (morning), Devaraja Market (afternoon), Chamundeshwari Temple at sunset, Sunday palace illumination at 7pm. Day 2: Brindavan Gardens, Somnathpur Hoysala Temple (1 hour away, don\'t skip), Mysore silk factory, Dasaprakash for Mysore masala dosa. Buy Mysore Pak sweets to take home! If visiting in October, the Dasara festival makes this one of the greatest spectacles in India.'),
(17, 'How many days for Hampi?',
     'Hampi deserves 3 full days minimum — it\'s 26 square kilometres of ruins! Day 1: Virupaksha Temple, Hampi Bazaar, Hemakuta Hill sunset. Day 2: Sunrise at Matanga Hill, full cycle tour of Vittala Temple, Stone Chariot, Royal Enclosure, Queen\'s Bath. Day 3: Cross the river by coracle to Virupapur Gadde (hippie island) — completely different relaxed vibe. Rent a bicycle — it\'s the best way to explore!'),
(18, 'Best time to visit Manali?',
     'Two distinct seasons! March–June: trekking season — green valleys, Beas river rafting, Rohtang Pass opens, pleasant 15–20°C. Perfect for adventure. December–February: snow season — Solang skiing, snowfall in Old Manali, Rohtang completely white, -5°C but magical. Avoid July–August (monsoon landslides on the Manali-Leh highway). My favourite? Early September — Rohtang is still open, crowds thin, and the valleys are at their greenest!'),
(1,  'I am planning to expand my trip — where should I go after Goa?',
     'After Goa, the logical next step is Kerala — completely different vibe! Trade the beach parties for backwater houseboats, Ayurvedic spa retreats, and misty Munnar tea gardens. Alternatively, head up to Goa\'s Hampi for an incredible 3-day heritage detour into Vijayanagara Empire ruins that will completely reframe your sense of India\'s history. Both are accessible from Goa by overnight bus!'),
(2,  'Is Udaipur better than Jaipur?',
     'Different magic entirely! Jaipur: royal grandeur, fort after incredible fort, the best bazaars in Rajasthan, and big-city energy. Udaipur: intimate, romantic, slower — all about the lake, the palaces reflected in water, and candlelit rooftop dinners. My advice: do both! They\'re 3 hours apart by bus. Jaipur first, then wind down with Udaipur\'s serenity. The contrast makes both even better.'),
(3,  'Tell me more about Hampi.',
     'Hampi was once literally the richest city in the world — capital of the Vijayanagara Empire in the 14th–16th centuries, larger than Rome. After it was sacked in 1565, it was abandoned and the jungle slowly reclaimed it. What remains is extraordinary: 500+ monuments across 26 km², with an otherworldly landscape of giant orange granite boulders. The Vittala Temple\'s Stone Chariot and Musical Pillars are India\'s most beautiful archaeological masterpieces. Plan 3 days — you\'ll wish you\'d planned more.');

-- ============================================================
-- END OF EXPANSION PART 2
-- Final record counts after running all 3 SQL files:
-- Destinations: 15  |  Hotels: ~75  |  Tourist Spots: ~90
-- Transport: ~80+   |  Packages: ~60 |  Users: 18
-- Bookings: ~28     |  Payments: ~28 |  Reviews: ~45
-- Wishlists: ~30    |  ChatLogs: ~23 |  Activities: ~55
-- Restaurants: ~45  |  Events: ~25  |  Guides: 20
-- TravelTips: ~75   |  Itineraries: ~30
-- ============================================================
