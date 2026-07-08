package com.food.servlet;

import java.io.IOException;
import java.sql.Timestamp;
import com.food.daoimp.UserDaoImpl;
import com.food.model.User;
import com.food.utility.BCrypt;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) 
            throws ServletException, IOException {
        req.getRequestDispatcher("register.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) 
            throws ServletException, IOException {
        
        String username = req.getParameter("username");
        String email = req.getParameter("email");
        String password = req.getParameter("password");
        String phone = req.getParameter("phone");
        String address = req.getParameter("address");
        String city = req.getParameter("city");
        String state = req.getParameter("state");
        String pincode = req.getParameter("pincode");

        if (username == null || email == null || password == null || 
            username.trim().isEmpty() || email.trim().isEmpty() || password.trim().isEmpty()) {
            req.setAttribute("errorMessage", "Username, Email and Password are required fields.");
            req.getRequestDispatcher("register.jsp").forward(req, resp);
            return;
        }

        try {
            UserDaoImpl userDao = new UserDaoImpl();
            
            // Check if email already exists
            boolean emailExists = false;
            for (User u : userDao.getAllUsers()) {
                if (u.getEmail().equalsIgnoreCase(email.trim())) {
                    emailExists = true;
                    break;
                }
            }

            if (emailExists) {
                req.setAttribute("errorMessage", "Email is already registered. Please log in.");
                req.getRequestDispatcher("register.jsp").forward(req, resp);
                return;
            }

            // Hash the password using BCrypt
            String hashedPassword = BCrypt.hashpw(password, BCrypt.gensalt());

            User user = new User();
            user.setUsername(username.trim());
            user.setEmail(email.trim());
            user.setPassword(hashedPassword);
            user.setPhone(phone != null ? phone.trim() : null);
            user.setAddress(address != null ? address.trim() : null);
            user.setCity(city != null ? city.trim() : null);
            user.setState(state != null ? state.trim() : null);
            user.setPincode(pincode != null ? pincode.trim() : null);
            user.setCreateDate(new Timestamp(System.currentTimeMillis()));
            user.setLastLogin(null);
            user.setRole("customer"); // Default role

            userDao.addUser(user);

            resp.sendRedirect("login.jsp?successMessage=Registration successful! Please log in.");

        } catch (Exception e) {
            e.printStackTrace();
            String detail = e.getMessage() != null ? e.getMessage() : e.toString();
            req.setAttribute("errorMessage", "An error occurred during registration: " + detail);
            req.getRequestDispatcher("register.jsp").forward(req, resp);
        }
    }
}
