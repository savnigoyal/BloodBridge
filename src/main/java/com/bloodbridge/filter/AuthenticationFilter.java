package com.bloodbridge.filter;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.*;

import java.io.IOException;

/**
 * Authentication filter that blocks unauthenticated access to protected URLs.
 */
@WebFilter("/*")
public class AuthenticationFilter implements Filter {
    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse resp = (HttpServletResponse) response;

        String path = req.getRequestURI().substring(req.getContextPath().length());
        // Publicly accessible resources
        boolean publicPath = path.startsWith("/login")
                || path.startsWith("/logout")
                || path.startsWith("/assets/")
                || path.endsWith(".css")
                || path.endsWith(".js")
                || path.endsWith(".png")
                || path.endsWith(".jpg")
                || path.equals("/");

        HttpSession session = req.getSession(false);
        boolean loggedIn = session != null && session.getAttribute("userId") != null;

        if (publicPath) {
            chain.doFilter(request, response);
            return;
        }

        if (!loggedIn) {
            // remember original URL for post‑login redirect
            if (session == null) session = req.getSession(true);
            session.setAttribute("originalUrl", req.getRequestURI());
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        chain.doFilter(request, response);
    }
}
