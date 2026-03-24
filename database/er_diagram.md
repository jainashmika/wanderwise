# Smart Travel Planner — ER Diagram

> **How to view this:**
> - Open VS Code → install extension "Markdown Preview Mermaid Support"
> - Then open this file and press `Ctrl+Shift+V`
> - OR paste the code block at https://mermaid.live

```mermaid
erDiagram
    DESTINATIONS {
        int destination_id PK
        varchar city
        varchar country
        text description
        varchar best_season
        varchar image_url
    }

    USERS {
        int user_id PK
        varchar name
        varchar email
        varchar password_hash
        varchar phone
        timestamp created_at
    }

    HOTELS {
        int hotel_id PK
        varchar hotel_name
        int destination_id FK
        varchar address
        decimal price_per_night
        decimal rating
        text amenities
        int available_rooms
    }

    TRANSPORT {
        int transport_id PK
        enum type
        varchar operator_name
        varchar source
        varchar destination
        time departure_time
        time arrival_time
        decimal fare
        int available_seats
    }

    TOURISTSPOTS {
        int spot_id PK
        varchar spot_name
        int destination_id FK
        text description
        decimal entry_fee
        varchar opening_hours
        varchar category
    }

    BUDGETPACKAGES {
        int package_id PK
        varchar package_name
        int destination_id FK
        decimal total_cost
        int duration_days
        text description
        int max_people
    }

    PACKAGEDETAILS {
        int detail_id PK
        int package_id FK
        int hotel_id FK
        int transport_id FK
        int spot_id FK
    }

    BOOKINGS {
        int booking_id PK
        int user_id FK
        int hotel_id FK
        int transport_id FK
        int package_id FK
        date check_in_date
        date check_out_date
        int num_people
        timestamp booking_date
        enum status
        decimal total_amount
    }

    PAYMENTS {
        int payment_id PK
        int booking_id FK
        timestamp payment_date
        decimal amount
        enum payment_method
        enum status
        varchar transaction_id
    }

    REVIEWS {
        int review_id PK
        int user_id FK
        int hotel_id FK
        int spot_id FK
        int rating
        text comment
        timestamp review_date
    }

    WISHLIST {
        int wishlist_id PK
        int user_id FK
        int hotel_id FK
        int spot_id FK
        int package_id FK
        timestamp added_date
    }

    CHATLOGS {
        int chat_id PK
        int user_id FK
        text message
        text response
        timestamp timestamp
    }

    DESTINATIONS ||--o{ HOTELS        : "located in"
    DESTINATIONS ||--o{ TOURISTSPOTS  : "located in"
    DESTINATIONS ||--o{ BUDGETPACKAGES: "covers"

    USERS ||--o{ BOOKINGS   : "makes"
    USERS ||--o{ REVIEWS    : "writes"
    USERS ||--o{ WISHLIST   : "has"
    USERS ||--o{ CHATLOGS   : "logs"

    HOTELS       ||--o{ BOOKINGS      : "booked in"
    HOTELS       ||--o{ REVIEWS       : "reviewed in"
    HOTELS       ||--o{ WISHLIST      : "saved in"
    HOTELS       ||--o{ PACKAGEDETAILS: "included in"

    TRANSPORT    ||--o{ BOOKINGS      : "used in"
    TRANSPORT    ||--o{ PACKAGEDETAILS: "included in"

    TOURISTSPOTS ||--o{ REVIEWS       : "reviewed in"
    TOURISTSPOTS ||--o{ WISHLIST      : "saved in"
    TOURISTSPOTS ||--o{ PACKAGEDETAILS: "included in"

    BUDGETPACKAGES ||--o{ BOOKINGS      : "booked as"
    BUDGETPACKAGES ||--o{ WISHLIST      : "saved in"
    BUDGETPACKAGES ||--o{ PACKAGEDETAILS: "contains"

    BOOKINGS ||--|| PAYMENTS : "paid via"
```
