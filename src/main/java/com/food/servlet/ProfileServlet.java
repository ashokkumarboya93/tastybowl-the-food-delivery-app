package com.food.servlet;

import java.io.IOException;
import com.food.daoimp.UserDaoImpl;
import com.food.model.User;
import com.food.utility.BCrypt;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/profile")
public class ProfileServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) 
            throws ServletException, IOException {
        
        HttpSession session = req.getSession();
        User user = (User) session.getAttribute("loggedInUser");
        if (user == null) {
            resp.sendRedirect("login.jsp?errorMessage=Please log in to view your profile.");
            return;
        }

        String action = req.getParameter("action");
        if ("edit".equals(action)) {
            req.getRequestDispatcher("edit-profile.jsp").forward(req, resp);
        } else {
            req.getRequestDispatcher("profile.jsp").forward(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) 
            throws ServletException, IOException {
        
        HttpSession session = req.getSession();
        User user = (User) session.getAttribute("loggedInUser");
        if (user == null) {
            resp.sendRedirect("login.jsp");
            return;
        }

        String action = req.getParameter("action");
        UserDaoImpl userDao = new UserDaoImpl();

        try {
            if ("updateProfile".equals(action)) {
                String username = req.getParameter("username");
                String phone = req.getParameter("phone");
                String address = req.getParameter("address");
                String city = req.getParameter("city");
                String state = req.getParameter("state");
                String pincode = req.getParameter("pincode");

                if (username == null || username.trim().isEmpty()) {
                    req.setAttribute("errorMessage", "Username cannot be empty.");
                    req.getRequestDispatcher("edit-profile.jsp").forward(req, resp);
                    return;
                }

                user.setUsername(username.trim());
                user.setPhone(phone != null ? phone.trim() : null);
                user.setAddress(address != null ? address.trim() : null);
                user.setCity(city != null ? city.trim() : null);
                user.setState(state != null ? state.trim() : null);
                user.setPincode(pincode != null ? pincode.trim() : null);

                userDao.updateUser(user);
                session.setAttribute("loggedInUser", user);
                
                resp.sendRedirect("profile?successMessage=Profile updated successfully.");
                return;

            } else if ("changePassword".equals(action)) {
                String oldPassword = req.getParameter("oldPassword");
                String newPassword = req.getParameter("newPassword");
                String confirmPassword = req.getParameter("confirmPassword");

                if (oldPassword == null || newPassword == null || confirmPassword == null ||
                    oldPassword.isEmpty() || newPassword.isEmpty() || confirmPassword.isEmpty()) {
                    req.setAttribute("errorMessage", "All password fields are required.");
                    req.getRequestDispatcher("profile.jsp").forward(req, resp);
                    return;
                }

                if (!newPassword.equals(confirmPassword)) {
                    req.setAttribute("errorMessage", "New passwords do not match.");
                    req.getRequestDispatcher("profile.jsp").forward(req, resp);
                    return;
                }

                if (!BCrypt.checkpw(oldPassword, user.getPassword())) {
                    req.setAttribute("errorMessage", "Incorrect current password.");
                    req.getRequestDispatcher("profile.jsp").forward(req, resp);
                    return;
                }

                String hashedNewPassword = BCrypt.hashpw(newPassword, BCrypt.gensalt());
                user.setPassword(hashedNewPassword);
                
                userDao.updateUser(user);
                session.setAttribute("loggedInUser", user);
                
                resp.sendRedirect("profile?successMessage=Password changed successfully.");
                return;
            }

        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("errorMessage", "An error occurred while updating profile.");
            req.getRequestDispatcher("profile.jsp").forward(req, resp);
        }
    }
}
