package com.bloodbridge.service;

import com.bloodbridge.util.DBConnection;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Service class responsible for retrieving dashboard statistics from the MySQL database.
 * The methods use simple aggregate queries; more complex logic can be added later.
 */
public class DashboardService {
    private static final Logger LOGGER = Logger.getLogger(DashboardService.class.getName());

    public Map<String, Integer> getStatistics() {
        Map<String, Integer> stats = new HashMap<>();
        try (Connection conn = DBConnection.getConnection()) {
            // Active requests: total requests that are not fulfilled or cancelled
            stats.put("activeRequests", getCount(conn, "SELECT COUNT(*) FROM blood_requests WHERE status IN ('PENDING','PARTIAL')"));
            // Urgent requests: requests with priority URGENT and still pending/partial
            stats.put("urgentRequests", getCount(conn, "SELECT COUNT(*) FROM blood_requests WHERE priority='URGENT' AND status IN ('PENDING','PARTIAL')"));
            // Verified banks: number of distinct blood bank organizations that have inventory entries
            stats.put("verifiedBanks", getCount(conn, "SELECT COUNT(DISTINCT org_id) FROM blood_inventory WHERE org_id IN (SELECT org_id FROM organizations WHERE type='BLOODBANK')"));
            // Fulfilled requests: total requests with status 'FULFILLED'
            stats.put("fulfilledRequests", getCount(conn, "SELECT COUNT(*) FROM blood_requests WHERE status='FULFILLED'"));
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error retrieving dashboard statistics", e);
            // In case of error, default to zeros so the UI can still render
            stats.put("activeRequests", 0);
            stats.put("urgentRequests", 0);
            stats.put("verifiedBanks", 0);
            stats.put("fulfilledRequests", 0);
        }
        return stats;
    }

    private int getCount(Connection conn, String sql) throws SQLException {
        try (PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
            return 0;
        }
    }
}
