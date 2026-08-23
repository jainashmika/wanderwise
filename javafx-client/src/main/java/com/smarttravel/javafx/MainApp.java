package com.smarttravel.javafx;

import javafx.application.Application;
import javafx.stage.Stage;

public class MainApp extends Application {

    @Override
    public void start(Stage stage) {
        new AdminDashboard(stage);
    }

    public static void main(String[] args) {
        launch(args);
    }
}
