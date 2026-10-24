package com.bloodbridge.dao;

import com.bloodbridge.model.Role;
import com.bloodbridge.model.User;
import com.bloodbridge.util.DBConnection;

import java.sql.*;
import java.util.Optional;

/**
 * DAO for {@link User}.
 */
public class UserDAO {

    /** Finds a user by e‑mail address. */
    public Optional<User> findByEmail(String email) throws SQLException {
        String sql = "SELECT user_id, username, email, password_hash, role FROM users WHERE email = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    User u = new User();
                    u.setUserId(rs.getLong("user_id"));
                    u.setUsername(rs.getString("username"));
                    u.setEmail(rs.getString("email"));
                    u.setPasswordHash(rs.getString("password_hash"));
                    u.setRole(Role.valueOf(rs.getString("role")));
                    return Optional.of(u);
                }
                return Optional.empty();
            }
        }
    }

    /** Inserts a new user – useful for creating demo accounts. */
    public void insert(User user) throws SQLException {
        String sql = "INSERT INTO users (username, email, password_hash, role) VALUES (?,?,?,?)";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, user.getUsername());
            ps.setString(2, user.getEmail());
            ps.setString(3, user.getPasswordHash());
            ps.setString(4, user.getRole().name());
            ps.executeUpdate();
            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) {
                    user.setUserId(rs.getLong(1));
                }
            }
        }
    }
}
