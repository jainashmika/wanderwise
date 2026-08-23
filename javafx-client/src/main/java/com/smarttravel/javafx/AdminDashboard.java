package com.smarttravel.javafx;

import javafx.animation.*;
import javafx.application.Platform;
import javafx.collections.FXCollections;
import javafx.collections.ObservableList;
import javafx.collections.transformation.FilteredList;
import javafx.collections.transformation.SortedList;
import javafx.concurrent.Task;
import javafx.geometry.*;
import javafx.scene.Scene;
import javafx.scene.canvas.Canvas;
import javafx.scene.canvas.GraphicsContext;
import javafx.scene.control.*;
import javafx.scene.control.cell.PropertyValueFactory;
import javafx.scene.layout.*;
import javafx.scene.paint.Color;
import javafx.scene.shape.ArcType;
import javafx.scene.text.*;
import javafx.stage.*;
import javafx.util.Duration;

import java.io.File;
import java.io.PrintWriter;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
import java.util.*;
import java.util.stream.Collectors;

/**
 * WanderWise JavaFX Admin Dashboard
 *
 * JavaFX features used:
 *  1. Custom Canvas charts  — donut chart (payment methods) + bar chart (booking status)
 *  2. Animated stat counters — count-up animation on every data load
 *  3. Pulsing connection dot — FadeTransition on the status indicator
 *  4. Live clock            — Timeline updating HH:mm:ss every second
 *  5. Auto-refresh          — Timeline fires loadData() every 30 s with countdown label
 *  6. FilteredList + SortedList — instant live search on both tables
 *  7. Colored status badges — custom CellFactory renders pill-shaped Label nodes
 *  8. Double-click detail popup — Stage with slide-in animation (FadeTransition + TranslateTransition)
 *  9. Toast notifications   — transparent Stage with FadeTransition auto-dismiss
 * 10. Hover lift on stat cards — box-shadow deepened via inline CSS on mouse events
 * 11. CSV export            — FileChooser + PrintWriter
 * 12. Recent activity list  — styled HBox rows with hover darkening
 */
public class AdminDashboard {

    // ── Brand colours ─────────────────────────────────────────────────────────
    private static final String TEAL  = "#0CD4DE";
    private static final String BLUE  = "#0096C7";
    private static final String BLACK = "#1D1D1F";
    private static final String BG    = "#F0FAFA";
    private static final String GRAY  = "#6E6E73";
    private static final String GREEN = "#10B981";
    private static final String RED   = "#EF4444";
    private static final String AMBER = "#F59E0B";
    private static final String WHITE = "#FFFFFF";

    private static final String[] CHART_COLORS = {TEAL, BLUE, GREEN, AMBER, RED, "#8B5CF6"};

    // ── State ─────────────────────────────────────────────────────────────────
    private final Stage stage;

    // Stat labels
    private Label totalBookingsLbl, totalRevenueLbl, totalPaymentsLbl;
    private Label statusDot, countdownLbl, clockLbl;

    // Shared observable lists — tables read from these
    private final ObservableList<BookingRow> bookingsData = FXCollections.observableArrayList();
    private final ObservableList<PaymentRow> paymentsData = FXCollections.observableArrayList();

    // Custom chart canvases
    private Canvas donutCanvas;
    private Canvas barCanvas;
    private VBox   donutLegend;
    private VBox   recentBox;

    // Auto-refresh
    private int countdown = 30;

    // ── Constructor ────────────────────────────────────────────────────────────
    public AdminDashboard(Stage stage) {
        this.stage = stage;

        VBox root = new VBox(buildHeader(), buildStatsRow(), buildTabs(), buildFooter());
        root.setStyle("-fx-background-color:" + BG + ";");
        VBox.setVgrow(root.getChildren().get(2), Priority.ALWAYS);

        stage.setTitle("WanderWise  —  Admin Dashboard");
        stage.setMinWidth(960);
        stage.setMinHeight(660);
        stage.setScene(new Scene(root, 1200, 760));
        stage.show();

        startClock();
        startAutoRefresh();
        loadData();
    }

    // ══════════════════════════════════════════════════════════════════════════
    //  HEADER
    // ══════════════════════════════════════════════════════════════════════════
    private HBox buildHeader() {
        Label wander = lbl("Wander", 22, FontWeight.BOLD, WHITE);
        Label wise   = lbl("Wise",   22, FontWeight.BOLD, TEAL);
        Label sub    = lbl("  ·  Admin Dashboard", 13, FontWeight.NORMAL, GRAY);

        clockLbl = lbl("", 13, FontWeight.NORMAL, GRAY);
        clockLbl.setStyle("-fx-font-family:'Courier New';");
        clockLbl.setPadding(new Insets(0, 20, 0, 0));

        statusDot = lbl("● Live", 12, FontWeight.BOLD, GREEN);
        statusDot.setPadding(new Insets(0, 16, 0, 0));
        pulse(statusDot);

        countdownLbl = lbl("Refresh in 30s", 11, FontWeight.NORMAL, GRAY);
        countdownLbl.setPadding(new Insets(0, 16, 0, 0));

        Button refresh = pill("⟳  Refresh", TEAL, WHITE);
        refresh.setOnAction(e -> { countdown = 30; loadData(); });

        Region sp = new Region();
        HBox.setHgrow(sp, Priority.ALWAYS);

        HBox bar = hbox(wander, wise, sub, sp, clockLbl, statusDot, countdownLbl, refresh);
        bar.setPadding(new Insets(14, 28, 14, 28));
        bar.setStyle("-fx-background-color:" + BLACK + ";");
        return bar;
    }

    // ══════════════════════════════════════════════════════════════════════════
    //  STAT CARDS
    // ══════════════════════════════════════════════════════════════════════════
    private HBox buildStatsRow() {
        totalBookingsLbl = bigNum();
        totalRevenueLbl  = bigNum();
        totalPaymentsLbl = bigNum();

        VBox c1 = statCard("📋  Total Bookings",         totalBookingsLbl, TEAL);
        VBox c2 = statCard("💰  Revenue Collected (₹)", totalRevenueLbl,  GREEN);
        VBox c3 = statCard("💳  Payments Processed",    totalPaymentsLbl, BLUE);
        HBox.setHgrow(c1, Priority.ALWAYS);
        HBox.setHgrow(c2, Priority.ALWAYS);
        HBox.setHgrow(c3, Priority.ALWAYS);

        HBox row = new HBox(16, c1, c2, c3);
        row.setPadding(new Insets(20, 28, 12, 28));
        return row;
    }

    private VBox statCard(String title, Label value, String accent) {
        Label t = lbl(title, 12, FontWeight.NORMAL, GRAY);
        VBox card = new VBox(6, t, value);
        card.setPadding(new Insets(18, 22, 18, 22));
        String base =
            "-fx-background-color:" + WHITE + ";" +
            "-fx-background-radius:12;" +
            "-fx-effect:dropshadow(gaussian,rgba(0,0,0,0.07),14,0,0,4);" +
            "-fx-border-color:transparent transparent transparent " + accent + ";" +
            "-fx-border-width:0 0 0 4;-fx-border-radius:0 12 12 0;";
        card.setStyle(base);
        // Hover lift effect
        card.setOnMouseEntered(e -> card.setStyle(base.replace("0.07", "0.18")));
        card.setOnMouseExited(e  -> card.setStyle(base));
        return card;
    }

    // ══════════════════════════════════════════════════════════════════════════
    //  TAB PANE
    // ══════════════════════════════════════════════════════════════════════════
    private TabPane buildTabs() {
        TabPane tp = new TabPane();
        tp.setTabClosingPolicy(TabPane.TabClosingPolicy.UNAVAILABLE);
        tp.getTabs().addAll(
            new Tab("  📊  Overview  ",  buildOverviewTab()),
            new Tab("  📋  Bookings  ",  buildBookingsTab()),
            new Tab("  💳  Payments  ",  buildPaymentsTab())
        );
        return tp;
    }

    // ══════════════════════════════════════════════════════════════════════════
    //  OVERVIEW TAB  — custom Canvas charts + recent activity
    // ══════════════════════════════════════════════════════════════════════════
    private ScrollPane buildOverviewTab() {

        // ── Donut chart (payment methods) ──────────────────────────────────
        donutCanvas = new Canvas(240, 240);
        donutLegend = new VBox(8);
        Label pieTitle = lbl("Payment Methods", 14, FontWeight.BOLD, BLACK);
        VBox pieBox = new VBox(12, pieTitle, donutCanvas, donutLegend);
        pieBox.setAlignment(Pos.CENTER);
        VBox pieCard = wrapInCard(pieBox);
        pieCard.setPadding(new Insets(20));
        HBox.setHgrow(pieCard, Priority.ALWAYS);

        // ── Bar chart (bookings by status) ─────────────────────────────────
        barCanvas = new Canvas(380, 240);
        Label barTitle = lbl("Bookings by Status", 14, FontWeight.BOLD, BLACK);
        VBox barBox = new VBox(12, barTitle, barCanvas);
        barBox.setAlignment(Pos.CENTER);
        VBox barCard = wrapInCard(barBox);
        barCard.setPadding(new Insets(20));
        HBox.setHgrow(barCard, Priority.ALWAYS);

        HBox charts = new HBox(20, pieCard, barCard);

        // ── Recent activity ────────────────────────────────────────────────
        Label recentTitle = lbl("Recent Bookings", 16, FontWeight.BOLD, BLACK);
        recentBox = new VBox(8);

        VBox content = new VBox(20, charts, new VBox(10, recentTitle, recentBox));
        content.setPadding(new Insets(20, 28, 28, 28));
        content.setStyle("-fx-background-color:" + BG + ";");

        ScrollPane sp = new ScrollPane(content);
        sp.setFitToWidth(true);
        sp.setStyle("-fx-background:" + BG + ";-fx-background-color:" + BG + ";");
        return sp;
    }

    // ══════════════════════════════════════════════════════════════════════════
    //  BOOKINGS TAB
    // ══════════════════════════════════════════════════════════════════════════
    @SuppressWarnings({"unchecked","rawtypes"})
    private VBox buildBookingsTab() {
        FilteredList<BookingRow> filtered = new FilteredList<>(bookingsData, p -> true);
        SortedList<BookingRow>   sorted   = new SortedList<>(filtered);

        TableView<BookingRow> table = new TableView<>(sorted);
        sorted.comparatorProperty().bind(table.comparatorProperty());
        styleTable(table);
        VBox.setVgrow(table, Priority.ALWAYS);

        TableColumn<BookingRow, String> statusCol = new TableColumn<>("Status");
        statusCol.setCellValueFactory(new PropertyValueFactory<>("status"));
        statusCol.setMaxWidth(110);
        statusCol.setCellFactory(c -> new TableCell<>() {
            @Override protected void updateItem(String v, boolean empty) {
                super.updateItem(v, empty);
                setGraphic(empty || v == null ? null : bookingBadge(v));
                setText(null);
            }
        });

        table.getColumns().addAll(
            col("ID",        "bookingId",   80),
            col("Guest",     "userName",   160),
            col("Hotel",     "hotelName",  180),
            col("Check-In",  "checkIn",    110),
            col("Check-Out", "checkOut",   110),
            col("Guests",    "numPeople",   70),
            statusCol,
            col("Total (₹)", "totalAmount", 120)
        );

        table.setRowFactory(tv -> {
            TableRow<BookingRow> row = new TableRow<>();
            row.setOnMouseClicked(e -> {
                if (e.getClickCount() == 2 && !row.isEmpty()) bookingDetail(row.getItem());
            });
            return row;
        });

        TextField search = searchBar("Search by guest, hotel or status…");
        search.textProperty().addListener((obs, o, v) ->
            filtered.setPredicate(r -> v == null || v.isBlank() ? true :
                r.getUserName().toLowerCase().contains(v.toLowerCase()) ||
                r.getHotelName().toLowerCase().contains(v.toLowerCase()) ||
                r.getStatus().toLowerCase().contains(v.toLowerCase())));

        Button export = pill("⬇  Export CSV", BLACK, WHITE);
        export.setOnAction(e -> exportCsv("bookings"));

        Label hint = lbl("💡 Double-click a row for full details", 11, FontWeight.NORMAL, GRAY);
        Region sp = new Region(); HBox.setHgrow(sp, Priority.ALWAYS);
        HBox toolbar = hbox(search, hint, sp, export);

        VBox tab = new VBox(12, toolbar, table);
        tab.setPadding(new Insets(16, 24, 24, 24));
        tab.setStyle("-fx-background-color:" + BG + ";");
        return tab;
    }

    // ══════════════════════════════════════════════════════════════════════════
    //  PAYMENTS TAB
    // ══════════════════════════════════════════════════════════════════════════
    @SuppressWarnings({"unchecked","rawtypes"})
    private VBox buildPaymentsTab() {
        FilteredList<PaymentRow> filtered = new FilteredList<>(paymentsData, p -> true);
        SortedList<PaymentRow>   sorted   = new SortedList<>(filtered);

        TableView<PaymentRow> table = new TableView<>(sorted);
        sorted.comparatorProperty().bind(table.comparatorProperty());
        styleTable(table);
        VBox.setVgrow(table, Priority.ALWAYS);

        TableColumn<PaymentRow, String> statusCol = new TableColumn<>("Status");
        statusCol.setCellValueFactory(new PropertyValueFactory<>("status"));
        statusCol.setMaxWidth(100);
        statusCol.setCellFactory(c -> new TableCell<>() {
            @Override protected void updateItem(String v, boolean empty) {
                super.updateItem(v, empty);
                setGraphic(empty || v == null ? null : paymentBadge(v));
                setText(null);
            }
        });

        table.getColumns().addAll(
            col("Pay ID",         "paymentId",     80),
            col("Booking",        "bookingId",     80),
            col("Transaction ID", "transactionId", 190),
            col("Method",         "paymentMethod", 130),
            statusCol,
            col("Amount (₹)",     "amount",        110),
            col("Date & Time",    "paymentDate",   180)
        );

        table.setRowFactory(tv -> {
            TableRow<PaymentRow> row = new TableRow<>();
            row.setOnMouseClicked(e -> {
                if (e.getClickCount() == 2 && !row.isEmpty()) paymentDetail(row.getItem());
            });
            return row;
        });

        TextField search = searchBar("Search by transaction ID, method or status…");
        search.textProperty().addListener((obs, o, v) ->
            filtered.setPredicate(r -> v == null || v.isBlank() ? true :
                r.getTransactionId().toLowerCase().contains(v.toLowerCase()) ||
                r.getPaymentMethod().toLowerCase().contains(v.toLowerCase()) ||
                r.getStatus().toLowerCase().contains(v.toLowerCase())));

        Button export = pill("⬇  Export CSV", BLACK, WHITE);
        export.setOnAction(e -> exportCsv("payments"));

        Label hint = lbl("💡 Double-click a row for full details", 11, FontWeight.NORMAL, GRAY);
        Region sp = new Region(); HBox.setHgrow(sp, Priority.ALWAYS);
        HBox toolbar = hbox(search, hint, sp, export);

        VBox tab = new VBox(12, toolbar, table);
        tab.setPadding(new Insets(16, 24, 24, 24));
        tab.setStyle("-fx-background-color:" + BG + ";");
        return tab;
    }

    // ══════════════════════════════════════════════════════════════════════════
    //  FOOTER
    // ══════════════════════════════════════════════════════════════════════════
    private HBox buildFooter() {
        Label l = lbl("WanderWise Admin  ·  REST API at localhost:8080", 11, FontWeight.NORMAL, GRAY);
        HBox bar = new HBox(l);
        bar.setAlignment(Pos.CENTER);
        bar.setPadding(new Insets(9, 28, 9, 28));
        bar.setStyle("-fx-background-color:" + WHITE + ";-fx-border-color:#E5E7EB 0 0 0;-fx-border-width:1 0 0 0;");
        return bar;
    }

    // ══════════════════════════════════════════════════════════════════════════
    //  DATA LOADING
    // ══════════════════════════════════════════════════════════════════════════
    private void loadData() {
        setStatus("⟳ Loading…", TEAL);

        Task<Void> task = new Task<>() {
            List<ApiService.BookingData> b;
            List<ApiService.PaymentData> p;
            double revenue;

            @Override protected Void call() throws Exception {
                b       = ApiService.fetchAllBookings();
                p       = ApiService.fetchAllPayments();
                revenue = ApiService.fetchTotalRevenue();
                return null;
            }

            @Override protected void succeeded() {
                animateCount(totalBookingsLbl, b.size(), false);
                animateCount(totalRevenueLbl,  revenue,  true);
                animateCount(totalPaymentsLbl, p.size(), false);

                bookingsData.setAll(b.stream().map(x -> new BookingRow(
                    x.bookingId, x.userName, x.hotelName,
                    x.checkIn, x.checkOut, x.numPeople,
                    x.status, String.format("%.2f", x.totalAmount)
                )).toList());

                paymentsData.setAll(p.stream().map(x -> new PaymentRow(
                    x.paymentId, x.bookingId, x.transactionId,
                    x.paymentMethod, x.status,
                    String.format("%.2f", x.amount), x.paymentDate
                )).toList());

                // Refresh custom charts
                Map<String, Long> payMethods = p.stream()
                    .collect(Collectors.groupingBy(x -> x.paymentMethod, Collectors.counting()));
                Map<String, Long> bkStatus = b.stream()
                    .collect(Collectors.groupingBy(x -> x.status, Collectors.counting()));

                drawDonutChart(donutCanvas, payMethods);
                buildDonutLegend(donutLegend, payMethods);
                drawBarChart(barCanvas, bkStatus);
                refreshRecent(b);

                setStatus("● Live", GREEN);
                toast("✓ Refreshed — " + b.size() + " bookings · " + p.size() + " payments");
            }

            @Override protected void failed() {
                setStatus("✕ Backend unreachable", RED);
                toast("✕ Cannot connect to localhost:8080 — is the backend running?");
            }
        };
        new Thread(task).start();
    }

    // ══════════════════════════════════════════════════════════════════════════
    //  CUSTOM CANVAS — DONUT CHART
    // ══════════════════════════════════════════════════════════════════════════
    private void drawDonutChart(Canvas canvas, Map<String, Long> data) {
        GraphicsContext gc = canvas.getGraphicsContext2D();
        double W = canvas.getWidth(), H = canvas.getHeight();
        gc.clearRect(0, 0, W, H);

        if (data.isEmpty()) {
            gc.setFill(Color.web("#E5E7EB"));
            gc.fillOval(20, 20, W - 40, H - 40);
            return;
        }

        double total = data.values().stream().mapToLong(v -> v).sum();
        double cx = W / 2, cy = H / 2, r = Math.min(W, H) / 2 - 10, innerR = r * 0.48;
        double angle = 90;
        int i = 0;

        for (Map.Entry<String, Long> e : data.entrySet()) {
            double sweep = 360.0 * e.getValue() / total;
            gc.setFill(Color.web(CHART_COLORS[i % CHART_COLORS.length]));
            gc.fillArc(cx - r, cy - r, r * 2, r * 2, angle, -sweep, ArcType.ROUND);
            angle -= sweep;
            i++;
        }

        // Donut hole
        gc.setFill(Color.web(WHITE));
        gc.fillOval(cx - innerR, cy - innerR, innerR * 2, innerR * 2);

        // Center label: total count
        gc.setFill(Color.web(BLACK));
        gc.setFont(Font.font("Arial", FontWeight.BOLD, 22));
        gc.setTextAlign(TextAlignment.CENTER);
        gc.setTextBaseline(VPos.CENTER);
        gc.fillText(String.valueOf((long) total), cx, cy - 8);
        gc.setFont(Font.font("Arial", 11));
        gc.setFill(Color.web(GRAY));
        gc.fillText("payments", cx, cy + 14);
    }

    private void buildDonutLegend(VBox legend, Map<String, Long> data) {
        legend.getChildren().clear();
        long total = data.values().stream().mapToLong(v -> v).sum();
        int i = 0;
        for (Map.Entry<String, Long> e : data.entrySet()) {
            String colour = CHART_COLORS[i % CHART_COLORS.length];
            double pct = total > 0 ? e.getValue() * 100.0 / total : 0;

            Label dot  = lbl("●", 16, FontWeight.BOLD, colour);
            Label name = lbl(e.getKey().replace("_", " "), 12, FontWeight.NORMAL, BLACK);
            name.setMinWidth(110);
            Label pctL = lbl(String.format("%.0f%%  (%d)", pct, e.getValue()), 12, FontWeight.BOLD, GRAY);

            HBox row = hbox(dot, name, pctL);
            legend.getChildren().add(row);
            i++;
        }
    }

    // ══════════════════════════════════════════════════════════════════════════
    //  CUSTOM CANVAS — BAR CHART
    // ══════════════════════════════════════════════════════════════════════════
    private void drawBarChart(Canvas canvas, Map<String, Long> data) {
        GraphicsContext gc = canvas.getGraphicsContext2D();
        double W = canvas.getWidth(), H = canvas.getHeight();
        gc.clearRect(0, 0, W, H);

        if (data.isEmpty()) return;

        long maxVal = data.values().stream().mapToLong(v -> v).max().orElse(1);
        int  n      = data.size();
        double maxBarH = H - 70;
        double barW    = Math.min(70, (W - 40) / n - 20);
        double gap     = (W - 40 - n * barW) / (n + 1);
        double baseY   = H - 36;

        // Y-axis grid lines
        gc.setStroke(Color.web("#E5E7EB"));
        gc.setLineWidth(1);
        for (int g = 1; g <= 4; g++) {
            double y = baseY - maxBarH * g / 4;
            gc.strokeLine(20, y, W - 10, y);
            gc.setFill(Color.web(GRAY));
            gc.setFont(Font.font("Arial", 10));
            gc.setTextAlign(TextAlignment.RIGHT);
            gc.setTextBaseline(VPos.CENTER);
            gc.fillText(String.valueOf(maxVal * g / 4), 16, y);
        }

        int i = 0;
        for (Map.Entry<String, Long> e : data.entrySet()) {
            double barH = maxVal > 0 ? (double) e.getValue() / maxVal * maxBarH : 0;
            double x    = 30 + gap + i * (barW + gap);
            double y    = baseY - barH;
            String col  = CHART_COLORS[i % CHART_COLORS.length];

            // Animate bar growing from bottom using Timeline
            final double targetH = barH;
            final double targetY = y;
            final double finalX  = x;
            Timeline anim = new Timeline();
            int frames = 20;
            for (int f = 1; f <= frames; f++) {
                double frac = (double) f / frames;
                double h = targetH * frac;
                double fy = baseY - h;
                KeyFrame kf = new KeyFrame(Duration.millis(f * 18.0), ev -> {
                    gc.clearRect(finalX - 1, fy - 2, barW + 2, baseY - fy + 4);
                    gc.setFill(Color.web(col));
                    gc.fillRoundRect(finalX, fy, barW, h, 8, 8);
                });
                anim.getKeyFrames().add(kf);
            }
            anim.play();

            // Count label above bar
            final int idx = i;
            anim.setOnFinished(ev -> {
                gc.setFill(Color.web(BLACK));
                gc.setFont(Font.font("Arial", FontWeight.BOLD, 13));
                gc.setTextAlign(TextAlignment.CENTER);
                gc.setTextBaseline(VPos.BOTTOM);
                gc.fillText(String.valueOf(e.getValue()), finalX + barW / 2, targetY - 4);
            });

            // Status label below bar
            gc.setFill(Color.web(GRAY));
            gc.setFont(Font.font("Arial", 11));
            gc.setTextAlign(TextAlignment.CENTER);
            gc.setTextBaseline(VPos.TOP);
            gc.fillText(e.getKey(), x + barW / 2, baseY + 6);

            i++;
        }
    }

    // ══════════════════════════════════════════════════════════════════════════
    //  RECENT ACTIVITY
    // ══════════════════════════════════════════════════════════════════════════
    private void refreshRecent(List<ApiService.BookingData> bookings) {
        recentBox.getChildren().clear();
        bookings.stream().limit(6).forEach(b -> {
            Label num   = lbl("#" + b.bookingId,                       13, FontWeight.BOLD,   TEAL);
            Label name  = lbl(b.userName,                              13, FontWeight.BOLD,   BLACK);
            Label hotel = lbl(b.hotelName,                             12, FontWeight.NORMAL, GRAY);
            Label amt   = lbl("₹ " + String.format("%.0f", b.totalAmount), 13, FontWeight.BOLD,   BLACK);
            Label badge = bookingBadge(b.status);

            num.setMinWidth(48);
            name.setMinWidth(140);
            Region sp = new Region(); HBox.setHgrow(sp, Priority.ALWAYS);

            HBox entry = hbox(num, name, hotel, sp, amt, badge);
            entry.setPadding(new Insets(12, 16, 12, 16));
            String base =
                "-fx-background-color:" + WHITE + ";" +
                "-fx-background-radius:8;" +
                "-fx-effect:dropshadow(gaussian,rgba(0,0,0,0.05),8,0,0,2);";
            entry.setStyle(base);
            entry.setOnMouseEntered(e -> entry.setStyle(base.replace("0.05", "0.13")));
            entry.setOnMouseExited(e  -> entry.setStyle(base));
            recentBox.getChildren().add(entry);
        });
    }

    // ══════════════════════════════════════════════════════════════════════════
    //  DETAIL POPUPS  (slide-in animation)
    // ══════════════════════════════════════════════════════════════════════════
    private void bookingDetail(BookingRow r) {
        showDetail("Booking #" + r.getBookingId(), new String[][]{
            {"Booking ID",   String.valueOf(r.getBookingId())},
            {"Guest",        r.getUserName()},
            {"Hotel",        r.getHotelName()},
            {"Check-In",     r.getCheckIn()},
            {"Check-Out",    r.getCheckOut()},
            {"Guests",       String.valueOf(r.getNumPeople())},
            {"Status",       r.getStatus()},
            {"Total Amount", "₹ " + r.getTotalAmount()},
        }, 6);
    }

    private void paymentDetail(PaymentRow r) {
        showDetail("Payment #" + r.getPaymentId(), new String[][]{
            {"Payment ID",    String.valueOf(r.getPaymentId())},
            {"Booking ID",    String.valueOf(r.getBookingId())},
            {"Transaction",   r.getTransactionId()},
            {"Method",        r.getPaymentMethod()},
            {"Status",        r.getStatus()},
            {"Amount",        "₹ " + r.getAmount()},
            {"Date & Time",   r.getPaymentDate()},
        }, 4);
    }

    private void showDetail(String title, String[][] rows, int statusRow) {
        Stage dlg = new Stage();
        dlg.initOwner(stage);
        dlg.initModality(Modality.APPLICATION_MODAL);
        dlg.setTitle(title);

        Label heading = lbl(title, 20, FontWeight.BOLD, BLACK);

        GridPane grid = new GridPane();
        grid.setHgap(20); grid.setVgap(14);

        for (int i = 0; i < rows.length; i++) {
            Label key = lbl(rows[i][0], 13, FontWeight.BOLD, GRAY);
            key.setMinWidth(130);
            grid.add(key, 0, i);
            if (i == statusRow) {
                grid.add(title.startsWith("Booking") ? bookingBadge(rows[i][1])
                                                     : paymentBadge(rows[i][1]), 1, i);
            } else {
                Label val = lbl(rows[i][1], 13, FontWeight.NORMAL, BLACK);
                if (rows[i][0].equals("Transaction"))
                    val.setStyle("-fx-font-family:'Courier New';-fx-font-size:13;");
                grid.add(val, 1, i);
            }
        }

        Button close = pill("Close", BLACK, WHITE);
        close.setOnAction(e -> dlg.close());

        VBox root = new VBox(14, heading, new Separator(), grid, close);
        root.setPadding(new Insets(28));
        root.setStyle("-fx-background-color:" + WHITE + ";");

        // Slide-in entrance animation
        root.setOpacity(0);
        root.setTranslateY(24);
        FadeTransition ft = new FadeTransition(Duration.millis(220), root);
        ft.setToValue(1);
        TranslateTransition tt = new TranslateTransition(Duration.millis(220), root);
        tt.setToY(0);
        new ParallelTransition(ft, tt).play();

        dlg.setScene(new Scene(root, 440, rows.length * 46 + 130));
        dlg.show();
    }

    // ══════════════════════════════════════════════════════════════════════════
    //  TOAST
    // ══════════════════════════════════════════════════════════════════════════
    private void toast(String msg) {
        Platform.runLater(() -> {
            Stage t = new Stage();
            t.initOwner(stage);
            t.initStyle(StageStyle.TRANSPARENT);
            t.setAlwaysOnTop(true);

            Label l = new Label(msg);
            l.setTextFill(Color.WHITE);
            l.setFont(Font.font("Arial", 12));
            l.setPadding(new Insets(10, 18, 10, 18));
            l.setStyle("-fx-background-color:rgba(29,29,31,0.92);-fx-background-radius:8;");

            StackPane root = new StackPane(l);
            root.setStyle("-fx-background-color:transparent;");
            Scene sc = new Scene(root);
            sc.setFill(Color.TRANSPARENT);
            t.setScene(sc);
            t.setX(stage.getX() + stage.getWidth()  - 370);
            t.setY(stage.getY() + stage.getHeight() - 72);
            t.show();

            FadeTransition fade = new FadeTransition(Duration.millis(500), root);
            fade.setDelay(Duration.millis(2200));
            fade.setFromValue(1); fade.setToValue(0);
            fade.setOnFinished(e -> t.close());
            fade.play();
        });
    }

    // ══════════════════════════════════════════════════════════════════════════
    //  AUTO-REFRESH + CLOCK
    // ══════════════════════════════════════════════════════════════════════════
    private void startAutoRefresh() {
        Timeline tl = new Timeline(new KeyFrame(Duration.seconds(1), e -> {
            countdown--;
            countdownLbl.setText("Refresh in " + countdown + "s");
            if (countdown <= 0) { countdown = 30; loadData(); }
        }));
        tl.setCycleCount(Timeline.INDEFINITE);
        tl.play();
    }

    private void startClock() {
        DateTimeFormatter fmt = DateTimeFormatter.ofPattern("HH:mm:ss");
        Timeline tl = new Timeline(new KeyFrame(Duration.seconds(1),
            e -> clockLbl.setText(LocalTime.now().format(fmt))));
        tl.setCycleCount(Timeline.INDEFINITE);
        tl.play();
    }

    // ══════════════════════════════════════════════════════════════════════════
    //  ANIMATIONS
    // ══════════════════════════════════════════════════════════════════════════
    private void animateCount(Label lbl, double target, boolean decimal) {
        int frames = 36;
        Timeline tl = new Timeline();
        for (int i = 1; i <= frames; i++) {
            double v = target * (double) i / frames;
            KeyFrame kf = new KeyFrame(Duration.millis(i * 20.0),
                e -> lbl.setText(decimal ? String.format("%.2f", v)
                                         : String.format("%.0f", v)));
            tl.getKeyFrames().add(kf);
        }
        tl.play();
    }

    private void pulse(Label l) {
        FadeTransition ft = new FadeTransition(Duration.millis(1200), l);
        ft.setFromValue(1); ft.setToValue(0.3);
        ft.setAutoReverse(true);
        ft.setCycleCount(Timeline.INDEFINITE);
        ft.play();
    }

    private void setStatus(String txt, String colour) {
        Platform.runLater(() -> {
            statusDot.setText(txt);
            statusDot.setTextFill(Color.web(colour));
        });
    }

    // ══════════════════════════════════════════════════════════════════════════
    //  CSV EXPORT
    // ══════════════════════════════════════════════════════════════════════════
    private void exportCsv(String type) {
        FileChooser fc = new FileChooser();
        fc.setTitle("Save CSV");
        fc.setInitialFileName(type + "_wanderwise.csv");
        fc.getExtensionFilters().add(new FileChooser.ExtensionFilter("CSV", "*.csv"));
        File f = fc.showSaveDialog(stage);
        if (f == null) return;
        try (PrintWriter w = new PrintWriter(f)) {
            if (type.equals("bookings")) {
                w.println("ID,Guest,Hotel,Check-In,Check-Out,Guests,Status,Total");
                bookingsData.forEach(r -> w.printf("%d,%s,%s,%s,%s,%d,%s,%s%n",
                    r.getBookingId(), r.getUserName(), r.getHotelName(),
                    r.getCheckIn(), r.getCheckOut(), r.getNumPeople(),
                    r.getStatus(), r.getTotalAmount()));
            } else {
                w.println("ID,Booking ID,Transaction ID,Method,Status,Amount,Date");
                paymentsData.forEach(r -> w.printf("%d,%d,%s,%s,%s,%s,%s%n",
                    r.getPaymentId(), r.getBookingId(), r.getTransactionId(),
                    r.getPaymentMethod(), r.getStatus(), r.getAmount(), r.getPaymentDate()));
            }
            toast("✓ Saved to " + f.getName());
        } catch (Exception ex) {
            toast("✕ Export failed: " + ex.getMessage());
        }
    }

    // ══════════════════════════════════════════════════════════════════════════
    //  STATUS BADGE PILLS
    // ══════════════════════════════════════════════════════════════════════════
    private Label bookingBadge(String s) {
        return badge(s, switch (s) {
            case "Confirmed" -> new String[]{"rgba(16,185,129,0.15)", "#059669"};
            case "Cancelled" -> new String[]{"rgba(239,68,68,0.15)",  "#DC2626"};
            default          -> new String[]{"rgba(245,158,11,0.15)", "#D97706"};
        });
    }

    private Label paymentBadge(String s) {
        return badge(s, switch (s) {
            case "Success" -> new String[]{"rgba(16,185,129,0.15)", "#059669"};
            case "Failed"  -> new String[]{"rgba(239,68,68,0.15)",  "#DC2626"};
            default        -> new String[]{"rgba(245,158,11,0.15)", "#D97706"};
        });
    }

    private Label badge(String text, String[] clr) {
        Label l = new Label(text);
        l.setFont(Font.font("Arial", FontWeight.BOLD, 11));
        l.setPadding(new Insets(3, 10, 3, 10));
        l.setStyle("-fx-background-radius:980;" +
                   "-fx-background-color:" + clr[0] + ";" +
                   "-fx-text-fill:" + clr[1] + ";");
        return l;
    }

    // ══════════════════════════════════════════════════════════════════════════
    //  UI HELPERS
    // ══════════════════════════════════════════════════════════════════════════
    private Label lbl(String t, double size, FontWeight w, String hex) {
        Label l = new Label(t);
        l.setFont(Font.font("Arial", w, size));
        l.setTextFill(Color.web(hex));
        return l;
    }

    private Label bigNum() {
        Label l = new Label("—");
        l.setFont(Font.font("Arial", FontWeight.BOLD, 32));
        l.setTextFill(Color.web(BLACK));
        return l;
    }

    private Button pill(String text, String bg, String fg) {
        Button b = new Button(text);
        b.setStyle("-fx-background-color:" + bg + ";-fx-text-fill:" + fg + ";" +
                   "-fx-font-weight:bold;-fx-font-size:12;" +
                   "-fx-background-radius:8;-fx-padding:8 16;");
        return b;
    }

    private HBox hbox(javafx.scene.Node... nodes) {
        HBox h = new HBox(10, nodes);
        h.setAlignment(Pos.CENTER_LEFT);
        return h;
    }

    private VBox wrapInCard(javafx.scene.Node node) {
        VBox v = new VBox(node);
        v.setStyle("-fx-background-color:" + WHITE + ";" +
                   "-fx-background-radius:12;" +
                   "-fx-effect:dropshadow(gaussian,rgba(0,0,0,0.07),14,0,0,4);");
        return v;
    }

    private void styleTable(TableView<?> t) {
        t.setStyle("-fx-background-color:" + WHITE + ";-fx-background-radius:12;" +
                   "-fx-effect:dropshadow(gaussian,rgba(0,0,0,0.06),12,0,0,3);");
        t.setColumnResizePolicy(TableView.CONSTRAINED_RESIZE_POLICY);
    }

    private TextField searchBar(String prompt) {
        TextField f = new TextField();
        f.setPromptText(prompt);
        f.setPrefWidth(320);
        f.setStyle("-fx-background-color:" + WHITE + ";-fx-background-radius:8;" +
                   "-fx-border-color:#E5E7EB;-fx-border-radius:8;" +
                   "-fx-padding:8 12;-fx-font-size:13;");
        return f;
    }

    @SuppressWarnings({"unchecked","rawtypes"})
    private TableColumn col(String title, String prop, double maxW) {
        TableColumn c = new TableColumn(title);
        c.setCellValueFactory(new PropertyValueFactory(prop));
        if (maxW > 0) c.setMaxWidth(maxW);
        return c;
    }

    // ══════════════════════════════════════════════════════════════════════════
    //  ROW MODELS
    // ══════════════════════════════════════════════════════════════════════════
    public static class BookingRow {
        private final int bookingId, numPeople;
        private final String userName, hotelName, checkIn, checkOut, status, totalAmount;

        public BookingRow(int bookingId, String userName, String hotelName,
                          String checkIn, String checkOut, int numPeople,
                          String status, String totalAmount) {
            this.bookingId = bookingId; this.userName = userName; this.hotelName = hotelName;
            this.checkIn = checkIn; this.checkOut = checkOut; this.numPeople = numPeople;
            this.status = status; this.totalAmount = totalAmount;
        }
        public int    getBookingId()   { return bookingId; }
        public String getUserName()    { return userName; }
        public String getHotelName()   { return hotelName; }
        public String getCheckIn()     { return checkIn; }
        public String getCheckOut()    { return checkOut; }
        public int    getNumPeople()   { return numPeople; }
        public String getStatus()      { return status; }
        public String getTotalAmount() { return totalAmount; }
    }

    public static class PaymentRow {
        private final int paymentId, bookingId;
        private final String transactionId, paymentMethod, status, amount, paymentDate;

        public PaymentRow(int paymentId, int bookingId, String transactionId,
                          String paymentMethod, String status, String amount, String paymentDate) {
            this.paymentId = paymentId; this.bookingId = bookingId;
            this.transactionId = transactionId; this.paymentMethod = paymentMethod;
            this.status = status; this.amount = amount; this.paymentDate = paymentDate;
        }
        public int    getPaymentId()     { return paymentId; }
        public int    getBookingId()     { return bookingId; }
        public String getTransactionId() { return transactionId; }
        public String getPaymentMethod() { return paymentMethod; }
        public String getStatus()        { return status; }
        public String getAmount()        { return amount; }
        public String getPaymentDate()   { return paymentDate; }
    }
}
