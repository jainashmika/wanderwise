package com.smarttravel.javafx;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;

import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.util.ArrayList;
import java.util.List;

/**
 * Calls the WanderWise Spring Boot REST API.
 * Requires the backend to be running at localhost:8080.
 */
public class ApiService {

    private static final String BASE = "http://localhost:8080/api";
    private static final HttpClient HTTP = HttpClient.newHttpClient();
    private static final ObjectMapper JSON = new ObjectMapper();

    // ── Fetch all bookings ──────────────────────────────────────────────────
    public static List<BookingData> fetchAllBookings() throws Exception {
        String body = get(BASE + "/bookings/all");
        JsonNode arr = JSON.readTree(body);
        List<BookingData> list = new ArrayList<>();
        for (JsonNode n : arr) {
            BookingData b = new BookingData();
            b.bookingId   = n.path("bookingId").asInt();
            b.userName    = n.path("user").path("name").asText("—");
            b.hotelName   = n.path("hotel").path("hotelName").asText("—");
            b.checkIn     = n.path("checkInDate").asText("—");
            b.checkOut    = n.path("checkOutDate").asText("—");
            b.numPeople   = n.path("numPeople").asInt(1);
            b.status      = n.path("status").asText("—");
            b.totalAmount = n.path("totalAmount").asDouble(0);
            list.add(b);
        }
        return list;
    }

    // ── Fetch all payments ──────────────────────────────────────────────────
    public static List<PaymentData> fetchAllPayments() throws Exception {
        String body = get(BASE + "/payments/all");
        JsonNode arr = JSON.readTree(body);
        List<PaymentData> list = new ArrayList<>();
        for (JsonNode n : arr) {
            PaymentData p = new PaymentData();
            p.paymentId     = n.path("paymentId").asInt();
            p.bookingId     = n.path("booking").path("bookingId").asInt();
            p.transactionId = n.path("transactionId").asText("—");
            p.paymentMethod = n.path("paymentMethod").asText("—");
            p.status        = n.path("status").asText("—");
            p.amount        = n.path("amount").asDouble(0);
            // Trim the date to a readable format
            String raw = n.path("paymentDate").asText("—");
            p.paymentDate = raw.length() > 19 ? raw.substring(0, 19).replace("T", "  ") : raw;
            list.add(p);
        }
        return list;
    }

    // ── Fetch total revenue ─────────────────────────────────────────────────
    public static double fetchTotalRevenue() throws Exception {
        String body = get(BASE + "/bookings/reports/revenue");
        JsonNode n = JSON.readTree(body);
        return n.path("totalRevenue").asDouble(0);
    }

    // ── HTTP GET helper ─────────────────────────────────────────────────────
    private static String get(String url) throws Exception {
        HttpRequest req = HttpRequest.newBuilder()
            .uri(URI.create(url))
            .header("Accept", "application/json")
            .GET().build();
        return HTTP.send(req, HttpResponse.BodyHandlers.ofString()).body();
    }

    // ── Data classes ────────────────────────────────────────────────────────
    public static class BookingData {
        public int bookingId, numPeople;
        public String userName, hotelName, checkIn, checkOut, status;
        public double totalAmount;
    }

    public static class PaymentData {
        public int paymentId, bookingId;
        public String transactionId, paymentMethod, status, paymentDate;
        public double amount;
    }
}
