package com.bloodbridge.servlet;

import com.bloodbridge.model.User;
import com.bloodbridge.service.AuthService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.SQLException;
import java.util.Optional;

/**
 * Handles GET (show login page) and POST (process login) requests.
 */
@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    private final AuthService authService = new AuthService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.getRequestDispatcher("/WEB-INF/views/login.jsp")
                .forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String email = req.getParameter("email");
        String password = req.getParameter("password");

        if (email == null || password == null || email.isBlank() || password.isBlank()) {
            req.setAttribute("error", "Email and password are required.");
            req.getRequestDispatcher("/WEB-INF/views/login.jsp")
               .forward(req, resp);
            return;
        }

        try {
            Optional<User> optUser = authService.login(email, password);
            if (optUser.isPresent()) {
                // Session fixation protection
                HttpSession old = req.getSession(false);
                if (old != null) old.invalidate();
                HttpSession session = req.getSession(true);
                User user = optUser.get();
                session.setAttribute("userId", user.getUserId());
                session.setAttribute("role", user.getRole().name());
                session.setMaxInactiveInterval(30 * 60); // 30 minutes

                // Secure cookie flags if HTTPS
                if (req.isSecure()) {
                    Cookie cookie = new Cookie("JSESSIONID", session.getId());
                    cookie.setHttpOnly(true);
                    cookie.setSecure(true);
                    resp.addCookie(cookie);
                }

                // Redirect to originally requested page or dashboard
                String target = (String) session.getAttribute("originalUrl");
                if (target != null) {
                    session.removeAttribute("originalUrl");
                    resp.sendRedirect(target);
                } else {
                    resp.sendRedirect(req.getContextPath() + "/dashboard");
                }
            } else {
                req.setAttribute("error", "Invalid email or password.");
                req.getRequestDispatcher("/WEB-INF/views/login.jsp")
                   .forward(req, resp);
            }
        } catch (SQLException e) {
            log("Login error", e);
            req.setAttribute("error", "A system error occurred. Please try again later.");
            req.getRequestDispatcher("/WEB-INF/views/login.jsp")
               .forward(req, resp);
        }
    }
}
