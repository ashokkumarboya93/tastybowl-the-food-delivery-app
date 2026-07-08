package com.food.servlet;

import java.io.IOException;
import java.sql.Timestamp;
import java.util.List;

import com.food.daoimp.UserDaoImpl;
import com.food.model.User;
import com.food.utility.BCrypt;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/admin/users")
public class AdminUserServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private boolean checkAdmin(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        HttpSession session = req.getSession();
        User user = (User) session.getAttribute("loggedInUser");
        if (user == null || !"admin".equalsIgnoreCase(user.getRole())) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp?errorMessage=Access Denied. Admins only.");
            return false;
        }
        return true;
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) 
            throws ServletException, IOException {
        
        if (!checkAdmin(req, resp)) return;

        String action = req.getParameter("action");
        String idStr = req.getParameter("id");
        UserDaoImpl userDao = new UserDaoImpl();

        try {
            if ("delete".equals(action) && idStr != null) {
                int id = Integer.parseInt(idStr);
                User loggedIn = (User) req.getSession().getAttribute("loggedInUser");
                if (loggedIn.getUserid() == id) {
                    resp.sendRedirect("users?errorMessage=You cannot delete your own account.");
                    return;
                }
                userDao.deleteUser(id);
                resp.sendRedirect("users?successMessage=User deleted successfully.");
                return;
            }

            if ("edit".equals(action) && idStr != null) {
                int id = Integer.parseInt(idStr);
                User userToEdit = userDao.getUser(id);
                req.setAttribute("userToEdit", userToEdit);
            }

            List<User> list = userDao.getAllUsers();
            req.setAttribute("adminUserList", list);
            req.getRequestDispatcher("/admin-users.jsp").forward(req, resp);

        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect("users?errorMessage=An error occurred.");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) 
            throws ServletException, IOException {
        
        if (!checkAdmin(req, resp)) return;

        String action = req.getParameter("action");
        UserDaoImpl userDao = new UserDaoImpl();

        try {
            String username = req.getParameter("username");
            String email = req.getParameter("email");
            String phone = req.getParameter("phone");
            String role = req.getParameter("role");
            String password = req.getParameter("password");
            
            if (username == null || email == null || role == null ||
                username.trim().isEmpty() || email.trim().isEmpty() || role.trim().isEmpty()) {
                resp.sendRedirect("users?errorMessage=Required fields are missing.");
                return;
            }

            if ("add".equals(action)) {
                if (password == null || password.trim().isEmpty()) {
                    resp.sendRedirect("users?errorMessage=Password is required for new users.");
                    return;
                }
                
                // Check if email exists
                for (User u : userDao.getAllUsers()) {
                    if (u.getEmail().equalsIgnoreCase(email.trim())) {
                        resp.sendRedirect("users?errorMessage=Email already exists in the system.");
                        return;
                    }
                }

                User u = new User();
                u.setUsername(username.trim());
                u.setEmail(email.trim());
                u.setPhone(phone != null ? phone.trim() : "");
                u.setRole(role.trim());
                u.setPassword(BCrypt.hashpw(password.trim(), BCrypt.gensalt()));
                u.setAddress(""); u.setCity(""); u.setState(""); u.setPincode("");
                u.setCreateDate(new Timestamp(System.currentTimeMillis()));
                
                userDao.addUser(u);
                resp.sendRedirect("users?successMessage=User added successfully.");

            } else if ("update".equals(action)) {
                String idStr = req.getParameter("userId");
                if (idStr == null) {
                    resp.sendRedirect("users?errorMessage=User ID is required for update.");
                    return;
                }
                int userId = Integer.parseInt(idStr);
                
                User u = userDao.getUser(userId);
                if (u != null) {
                    u.setUsername(username.trim());
                    u.setEmail(email.trim());
                    u.setPhone(phone != null ? phone.trim() : "");
                    u.setRole(role.trim());
                    
                    if (password != null && !password.trim().isEmpty()) {
                        u.setPassword(BCrypt.hashpw(password.trim(), BCrypt.gensalt()));
                    }

                    userDao.updateUser(u);
                    resp.sendRedirect("users?successMessage=User updated successfully.");
                } else {
                    resp.sendRedirect("users?errorMessage=User not found.");
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect("users?errorMessage=An error occurred while saving the user.");
        }
    }
}
