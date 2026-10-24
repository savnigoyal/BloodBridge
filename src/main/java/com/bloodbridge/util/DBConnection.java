package com.bloodbridge.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;

/**
 * Utility class for obtaining a JDBC connection to the MySQL database.
 * The database connection properties are loaded from a class‑path resource
 * {@code db.properties}. The file should be placed under {@code src/main/resources}
 * and is intentionally NOT committed to version control – it contains
 * credentials for local development only.
 */
public class DBConnection {
    private static final String PROPERTIES_FILE = "/db.properties";
    private static String url;
    private static String user;
    private static String password;
    private static volatile boolean initialized = false;

    private static void init() throws SQLException {
        if (initialized) {
            return;
        }
        try (var stream = DBConnection.class.getResourceAsStream(PROPERTIES_FILE)) {
            if (stream == null) {
                throw new SQLException("Database properties file not found: " + PROPERTIES_FILE);
            }
            var props = new Properties();
            props.load(stream);
            url = props.getProperty("url");
            user = props.getProperty("user");
            password = props.getProperty("password");
            if (url == null || user == null) {
                throw new SQLException("Missing required DB properties (url, user)");
            }
            initialized = true;
        } catch (Exception e) {
            throw new SQLException("Failed to load DB properties", e);
        }
    }

    /**
     * Returns a new {@link Connection}. Caller is responsible for closing it.
     */
    public static Connection getConnection() throws SQLException {
        init();
        return DriverManager.getConnection(url, user, password);
    }
}
