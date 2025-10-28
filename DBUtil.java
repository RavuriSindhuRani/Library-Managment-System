package com.example.library.util;

import java.sql.DriverManager;

import java.sql.Connection;

import java.sql.SQLException;

public class DBUtil {
    // Database URL, username, and password
    private static final String URL = "jdbc:mysql://localhost:3306/librarydb";
    private static final String USER = "root";           // Replace with your DB username
    private static final String PASSWORD = "Sin857@@"; // Replace with your DB password

    // Load JDBC driver and return connection
    public static Connection getConnection() {
        Connection conn = null;
        try {
            // Load MySQL JDBC driver
            Class.forName("com.mysql.cj.jdbc.Driver");
            // Get connection
            conn = DriverManager.getConnection(URL, USER, PASSWORD);
        } catch (ClassNotFoundException e) {
            System.out.println("MySQL JDBC Driver not found."+e.getMessage());
            e.printStackTrace();
        } catch (SQLException e) {
            System.out.println("Connection failed."+e.getMessage());
            e.printStackTrace();
        }
        return conn;
    }
}
