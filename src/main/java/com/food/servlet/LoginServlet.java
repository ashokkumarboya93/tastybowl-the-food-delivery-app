package com.food.servlet;

import java.io.IOException;
import java.sql.Timestamp;
import com.food.daoimp.UserDaoImpl;
import com.food.model.User;
import com.food.utility.BCrypt;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) 
            throws ServletException, IOException {
        req.getRequestDispatcher("login.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) 
            throws ServletException, IOException {
        
        String email = req.getParameter("email");
        String password = req.getParameter("password");
        String rememberMe = req.getParameter("rememberMe");

        if (email == null || password == null || email.trim().isEmpty() || password.trim().isEmpty()) {
            req.setAttribute("errorMessage", "Email and Password are required.");
            req.getRequestDispatcher("login.jsp").forward(req, resp);
            return;
        }

        try {
            UserDaoImpl userDao = new UserDaoImpl();
            User user = null;

            // Find user by email
            for (User u : userDao.getAllUsers()) {
                if (u.getEmail().equalsIgnoreCase(email.trim())) {
                    user = u;
                    break;
                }
            }

            boolean passwordMatch = false;
            if (user != null) {
                if (user.getPassword() != null && user.getPassword().startsWith("$2a$")) {
                    passwordMatch = BCrypt.checkpw(password, user.getPassword());
                } else {
                    passwordMatch = password.equals(user.getPassword());
                }
            }

            if (passwordMatch) {
                // Update last login
                user.setLastLogin(new Timestamp(System.currentTimeMillis()));
                userDao.updateUser(user);

                // Set up session
                HttpSession session = req.getSession();
                session.setAttribute("loggedInUser", user);

                // Handle Remember Me Cookie
                if ("true".equals(rememberMe)) {
                    Cookie emailCookie = new Cookie("savedEmail", user.getEmail());
                    emailCookie.setMaxAge(30 * 24 * 60 * 60); // 30 days
                    resp.addCookie(emailCookie);
                } else {
                    // Clear cookie if not checked
                    Cookie emailCookie = new Cookie("savedEmail", "");
                    emailCookie.setMaxAge(0);
                    resp.addCookie(emailCookie);
                }

                // Redirect based on role
                String role = user.getRole();
                if ("admin".equalsIgnoreCase(role)) {
                    resp.sendRedirect("admin-dashboard.jsp");
                } else if ("restaurant_admin".equalsIgnoreCase(role)) {
                    resp.sendRedirect("admin/menu");
                } else if ("delivery_agent".equalsIgnoreCase(role)) {
                    resp.sendRedirect("admin/orders");
                } else {
                    resp.sendRedirect("callRestaurantServlet");
                }

            } else {
                req.setAttribute("errorMessage", "Invalid email or password.");
                req.getRequestDispatcher("login.jsp").forward(req, resp);
            }

        } catch (Exception e) {
            e.printStackTrace();
            String detail = e.getMessage() != null ? e.getMessage() : e.toString();
            req.setAttribute("errorMessage", "An error occurred during login: " + detail);
            req.getRequestDispatcher("login.jsp").forward(req, resp);
        }
    }
}
