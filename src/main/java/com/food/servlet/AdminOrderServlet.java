package com.food.servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.food.model.User;
import com.food.utility.DBConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/admin/orders")
public class AdminOrderServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private boolean checkAccess(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        HttpSession session = req.getSession();
        User user = (User) session.getAttribute("loggedInUser");
        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp?errorMessage=Please log in first.");
            return false;
        }
        String role = user.getRole();
        if (!"admin".equalsIgnoreCase(role) && !"delivery_agent".equalsIgnoreCase(role)) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp?errorMessage=Access Denied. Admins and Delivery Agents only.");
            return false;
        }
        return true;
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) 
            throws ServletException, IOException {
        
        if (!checkAccess(req, resp)) return;

        List<Map<String, Object>> ordersList = new ArrayList<>();

        try (Connection con = DBConnection.getConnection()) {
            String query = "SELECT o.*, u.username, r.name as restaurantName " +
                           "FROM ordertable o " +
                           "JOIN user u ON o.userId = u.userid " +
                           "JOIN restaurant r ON o.restaurantId = r.restaurantId " +
                           "ORDER BY o.orderDate DESC";
            
            try (PreparedStatement ps = con.prepareStatement(query);
                 ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> orderMap = new HashMap<>();
                    orderMap.put("orderId", rs.getInt("orderId"));
                    orderMap.put("username", rs.getString("username"));
                    orderMap.put("restaurantName", rs.getString("restaurantName"));
                    orderMap.put("orderDate", rs.getTimestamp("orderDate"));
                    orderMap.put("totalAmount", rs.getDouble("totalAmount"));
                    orderMap.put("status", rs.getString("status"));
                    orderMap.put("paymentMethod", rs.getString("paymentMethod"));
                    ordersList.add(orderMap);
                }
            }

            req.setAttribute("adminOrderList", ordersList);
            req.getRequestDispatcher("/admin-orders.jsp").forward(req, resp);

        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect("orders?errorMessage=An error occurred while fetching orders.");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) 
            throws ServletException, IOException {
        
        if (!checkAccess(req, resp)) return;

        String action = req.getParameter("action");
        
        if ("updateStatus".equals(action)) {
            String orderIdStr = req.getParameter("orderId");
            String newStatus = req.getParameter("status");
            
            if (orderIdStr != null && newStatus != null) {
                try (Connection con = DBConnection.getConnection()) {
                    String updateQuery = "UPDATE ordertable SET status = ? WHERE orderId = ?";
                    try (PreparedStatement ps = con.prepareStatement(updateQuery)) {
                        ps.setString(1, newStatus);
                        ps.setInt(2, Integer.parseInt(orderIdStr));
                        ps.executeUpdate();
                    }
                    resp.sendRedirect("orders?successMessage=Order status updated successfully.");
                } catch (Exception e) {
                    e.printStackTrace();
                    resp.sendRedirect("orders?errorMessage=Failed to update order status.");
                }
            } else {
                resp.sendRedirect("orders?errorMessage=Invalid parameters for update.");
            }
        }
    }
}
