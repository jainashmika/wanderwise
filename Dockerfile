# ============================================================
# Stage 1: Build the full-stack Spring Boot jar
# ============================================================
FROM maven:3.9.6-eclipse-temurin-17-alpine AS builder

WORKDIR /build

# Copy pom and pre-download dependencies for layer caching
COPY backend/pom.xml ./backend/
RUN cd backend && mvn dependency:go-offline -B || true

# Copy static frontend and backend source code
COPY frontend/ ./backend/src/main/resources/static/
COPY backend/src/ ./backend/src/

# Build production jar skipping unit tests
RUN cd backend && mvn clean package -DskipTests

# ============================================================
# Stage 2: Lightweight Production Runtime
# ============================================================
FROM eclipse-temurin:17-jre-alpine

WORKDIR /app

# Create non-root system user for security
RUN addgroup -S appgroup && adduser -S appuser -G appgroup

# Copy compiled jar from builder
COPY --from=builder /build/backend/target/smart-travel-planner-*.jar /app/app.jar

# Set ownership
RUN chown -R appuser:appgroup /app

USER appuser

# Render injects PORT dynamically (defaults to 8080)
ENV PORT=8080
EXPOSE ${PORT}

# Health check
HEALTHCHECK --interval=30s --timeout=5s --start-period=30s --retries=3 \
  CMD wget --quiet --tries=1 --spider http://localhost:${PORT}/healthz || exit 1

ENTRYPOINT ["java", "-Djava.security.egd=file:/dev/./urandom", "-jar", "/app/app.jar"]
