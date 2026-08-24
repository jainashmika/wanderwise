# 🚀 Deploying WanderWise to Render

This guide provides step-by-step instructions to deploy **WanderWise (Smart Travel Planner)** on **[Render](https://render.com)** as a production Docker Web Service, connect a cloud MySQL database, and monitor it with **[UptimeRobot](https://uptimerobot.com)**.

---

## 🏗️ Architecture Overview

The application is containerized using a multi-stage `Dockerfile`:
1. **Builder Stage**: Compiles the Spring Boot backend with Maven and bundles all frontend static assets (`index.html`, `destination.html`, `planner.html`, `payment.html`, `chatbot.js`).
2. **Runtime Stage**: Runs on a secure, ultra-lightweight Eclipse Temurin Alpine JRE container (`~150MB`).
3. **Unified Delivery**: The single Web Service serves both the web frontend (`/`) and REST APIs (`/api/*`) on the same domain, with zero CORS issues.

---

## 📋 Step 1: Cloud MySQL Database Setup

Render Web Services require an external or managed MySQL database. You can use any free cloud MySQL provider:

### Recommended Free MySQL Providers:
- **[Aiven for MySQL](https://aiven.io/)** (Free tier available, high performance)
- **[TiDB Serverless](https://tidb.cloud/)** (Free 5GB MySQL-compatible database)
- **[Railway](https://railway.app/)** (One-click MySQL provision)
- **[Clever Cloud](https://www.clever-cloud.com/)** (Free MySQL add-on)

### Database Migration:
Once your cloud database is created, run the SQL initialization scripts located in the `database/` folder in this exact order:
1. `database/schema.sql`
2. `database/seed_data.sql`
3. `database/expand_database.sql`
4. `database/expand_database_part2.sql`

---

## 🚢 Step 2: Deploy to Render

### Method A: Blueprint Deployment (One-Click)
1. Push your repository to **GitHub** or **GitLab**.
2. Go to your **[Render Dashboard](https://dashboard.render.com/)**.
3. Click **New +** $\rightarrow$ **Blueprint**.
4. Connect your `wanderwise` repository.
5. Render will automatically detect [`render.yaml`](./render.yaml).
6. Fill in your MySQL credentials when prompted:
   - `SPRING_DATASOURCE_URL`
   - `SPRING_DATASOURCE_USERNAME`
   - `SPRING_DATASOURCE_PASSWORD`
7. Click **Apply**.

---

### Method B: Manual Web Service Creation
1. Go to **[Render Dashboard](https://dashboard.render.com/)** $\rightarrow$ Click **New +** $\rightarrow$ **Web Service**.
2. Select **Build and deploy from a Git repository** $\rightarrow$ Connect your repository.
3. Configure the settings:
   - **Name**: `wanderwise-travel-planner`
   - **Region**: Select the region closest to you or your database (e.g., *Oregon (US West)* or *Frankfurt (EU)*).
   - **Language / Runtime**: `Docker`
   - **Dockerfile Path**: `./Dockerfile`
   - **Instance Type**: `Free`
4. Expand **Advanced** $\rightarrow$ Add **Environment Variables**:

| Variable Name | Example Value | Description |
|---|---|---|
| `PORT` | `8080` | Render internal listening port |
| `SPRING_DATASOURCE_URL` | `jdbc:mysql://<HOST>:<PORT>/smart_travel_planner?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true` | JDBC MySQL connection URL |
| `SPRING_DATASOURCE_USERNAME` | `admin` | Database username |
| `SPRING_DATASOURCE_PASSWORD` | `<YOUR_DB_PASSWORD>` | Database password |
| `SPRING_JPA_HIBERNATE_DDL_AUTO` | `none` | JPA DDL validation setting |

5. Under **Health Check Path**, enter: `/healthz`
6. Click **Create Web Service**.

---

## 🤖 Step 3: Set Up UptimeRobot (Free 24/7 Keep-Alive)

Render's free tier spins down instances after 15 minutes of inactivity. You can keep your service awake and monitor uptime 24/7 for free using **[UptimeRobot](https://uptimerobot.com)**:

1. Sign up / Log in to [UptimeRobot](https://uptimerobot.com/).
2. Click **+ Add New Monitor**.
3. Configure:
   - **Monitor Type**: `HTTP(s)`
   - **Friendly Name**: `WanderWise Render`
   - **URL (or IP)**: `https://your-service-name.onrender.com/healthz`
   - **Monitoring Interval**: `5 minutes` (keeps Render awake continuously)
4. Click **Create Monitor**.

---

## 🔍 Step 4: Verification & URLs

Once deployed, your Render URL will be live at `https://<your-service-name>.onrender.com`:

| Page / Endpoint | URL |
|---|---|
| 🏠 **Home Page** | `https://<app>.onrender.com/` |
| 🗺️ **Destination Explorer** | `https://<app>.onrender.com/destination.html?id=1` |
| 🧭 **Trip Planner** | `https://<app>.onrender.com/planner.html` |
| 💳 **Payment Portal** | `https://<app>.onrender.com/payment.html` |
| 🩺 **Health Check** | `https://<app>.onrender.com/healthz` |
| 📡 **REST API** | `https://<app>.onrender.com/api/destinations` |
