# WanderWise - Smart Travel Planner 

A full-stack travel planning web application.
Plan trips across 15 Indian destinations with hotel booking, transport search, AI chatbot assistance, and an animated frontend.

---

## Tech Stack

| Layer | Technology |
|---|---|
| **Frontend** | HTML5, CSS3, Vanilla JavaScript |
| **Backend** | Java 17, Spring Boot 3, Spring Data JPA |
| **Database** | MySQL 8 (18 tables, 15 destinations, 75+ hotels) |
| **API** | RESTful JSON API (Spring MVC) |
| **Animations** | Canvas API, RequestAnimationFrame, IntersectionObserver |

---

## Features

- **15 Indian Destinations** - Goa, Manali, Jaipur, Kerala, Ladakh, Udaipur, Rishikesh, Darjeeling, Shimla, Varanasi, Agra, Coorg, Ooty, Mysore, Hampi
- **Hotel Search & Booking** - 75+ hotels with price, rating, amenities
- **Transport Search** - Flights, trains, buses between cities
- **Budget Packages** - 60+ curated packages with day-by-day itineraries
- **Tourist Spots** - 90+ attractions with entry fees, hours, categories
- **AI Chatbot "Yami"** - Personalized travel recommendations with conversation memory
- **Animated UI** - Floating particles, cursor glow, scroll reveal, typewriter effect, card tilt
- **Turquoise Design System** - Consistent colour theme across all pages

---

## Project Structure

```
wanderwise/
├── frontend/
│   ├── index.html          # Homepage with destination grid + packages
│   ├── destination.html    # Per-destination page (hero, tabs, spots, hotels)
│   ├── planner.html        # Trip planner - search, select, book
│   ├── animations.js       # Global animation engine (particles, orbs, typewriter)
│   └── chatbot.js          # Yami AI chatbot with conversation memory
│
├── backend/
│   ├── src/main/java/com/smarttravel/
│   │   ├── controller/     # REST API endpoints (7 controllers)
│   │   ├── model/          # JPA entities (10 models)
│   │   ├── repository/     # Spring Data JPA repositories
│   │   ├── service/        # Business logic (Booking, User)
│   │   └── config/         # CORS configuration
│   └── src/main/resources/
│       └── application.properties
│
└── database/
    ├── schema.sql              # 12 core tables
    ├── seed_data.sql           # Initial data (5 cities, 25 hotels, 35 spots)
    ├── expand_database.sql     # 6 new tables + 10 new cities (full data)
    └── expand_database_part2.sql  # Itineraries, bookings, reviews, chat logs
```

---

## Database Schema (18 Tables)

**Core Tables:** Destinations · Users · Hotels · Transport · TouristSpots · BudgetPackages · PackageDetails · Bookings · Payments · Reviews · Wishlist · ChatLogs

**Extended Tables:** TravelTips · Itineraries · Activities · Restaurants · Events · Guides

---

## API Endpoints

| Method | Endpoint | Description |
|---|---|---|
| GET | `/api/destinations` | All destinations |
| GET | `/api/hotels?city={city}` | Hotels by city |
| GET | `/api/transport/search?source={src}&destination={dest}` | Transport routes |
| GET | `/api/packages` | All packages |
| GET | `/api/packages/destination/{id}` | Packages by destination |
| GET | `/api/spots?city={city}` | Tourist spots by city |
| POST | `/api/bookings` | Create a booking |
| GET | `/api/users/{id}` | User profile |

---

## Setup & Run

### Prerequisites
- Java 17+
- Maven
- MySQL 8+
- Any modern browser

### 1. Database Setup
```sql
-- Run in MySQL Workbench in this order:
source database/schema.sql
source database/seed_data.sql
source database/expand_database.sql
source database/expand_database_part2.sql
```

### 2. Configure Database Password
Edit `backend/src/main/resources/application.properties`:
```properties
spring.datasource.password=YOUR_MYSQL_PASSWORD
```

### 3. Start Backend
```bash
cd backend
mvnw spring-boot:run
```
Backend runs at `http://localhost:8080`

### 4. Open Frontend
Open in browser:
```
frontend/index.html
```
Or paste into Chrome: `file:///path/to/frontend/index.html`

---

## Screenshots

> Homepage with animated particle background and turquoise design system

> Destination page with full-screen hero, 4-tab layout (Overview / Spots / Hotels / Packages)

> Trip Planner with hotel search, transport picker, and booking confirmation

> Yami AI chatbot with personalized destination recommendations

---

## Database Stats

| Table | Records |
|---|---|
| Destinations | 15 cities |
| Hotels | 75+ |
| Tourist Spots | 90+ |
| Transport Routes | 80+ |
| Budget Packages | 60+ |
| Itineraries | 30+ day plans |
| Activities | 55+ |
| Restaurants | 45+ |
| Events/Festivals | 25+ |
| Local Guides | 20 |
| Users | 18 |
| Reviews | 45+ |

---

## Made By

**Ashmika Jain** 
