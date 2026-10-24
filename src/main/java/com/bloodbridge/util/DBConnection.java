package com.bloodbridge.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 * DBConnection provides a single method to obtain a JDBC Connection.
 * The connection parameters are loaded from environment variables:
 *   - DB_URL (e.g. jdbc:mysql://localhost:3306/bloodbridge?useSSL=false&serverTimezone=UTC)
 *   - DB_USER
 *   - DB_PASSWORD
 *
 * The class lazily loads the driver and rethrows any SQLException as a RuntimeException
 * so that calling code can handle it appropriately.
 */
public class DBConnection {
    private static final String URL = System.getenv("DB_URL");
    private static final String USER = System.getenv("DB_USER");
    private static final String PASSWORD = System.getenv("DB_PASSWORD");

    static {
        try {
            // Ensure MySQL driver is loaded
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            throw new RuntimeException("MySQL JDBC Driver not found", e);
        }
    }

    /**
     * Returns a new JDBC connection.
     * Caller is responsible for closing the connection.
     */
    public static Connection getConnection() throws SQLException {
        if (URL == null || USER == null || PASSWORD == null) {
            throw new IllegalStateException("Database connection environment variables (DB_URL, DB_USER, DB_PASSWORD) are not set.");
        }
        return DriverManager.getConnection(URL, USER, PASSWORD);
    }
}
