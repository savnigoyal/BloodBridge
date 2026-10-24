package com.bloodbridge.service;

import com.bloodbridge.dao.UserDAO;
import com.bloodbridge.model.User;
import com.bloodbridge.util.PasswordUtil;

import java.sql.SQLException;
import java.util.Optional;

/**
 * Service responsible for authenticating users.
 */
public class AuthService {
    private final UserDAO userDAO = new UserDAO();

    /**
     * Attempts to log a user in with the supplied credentials.
     *
     * @return Optional containing a {@link User} if authentication succeeds.
     */
    public Optional<User> login(String email, String plainPassword) throws SQLException {
        Optional<User> maybeUser = userDAO.findByEmail(email);
        if (maybeUser.isPresent()) {
            User user = maybeUser.get();
            if (PasswordUtil.verify(plainPassword, user.getPasswordHash())) {
                return Optional.of(user);
            }
        }
        return Optional.empty();
    }
}
