package com.food.servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import com.food.daoimp.OrderDaoImpl;
import com.food.model.OrderItem;
import com.food.model.OrderTable;
import com.food.model.User;
import com.food.utility.DBConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/orders")
public class OrderServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) 
            throws ServletException, IOException {
        
        HttpSession session = req.getSession();
        User user = (User) session.getAttribute("loggedInUser");
        if (user == null) {
            resp.sendRedirect("login.jsp?errorMessage=Please log in to view orders.");
            return;
        }

        String action = req.getParameter("action");
        String orderIdStr = req.getParameter("orderId");

        try {
            OrderDaoImpl orderDao = new OrderDaoImpl();

            if ("details".equals(action) && orderIdStr != null) {
                int orderId = Integer.parseInt(orderIdStr);
                OrderTable order = orderDao.getOrder(orderId);

                // Security check: Make sure this order belongs to the logged-in user (unless admin)
                if (order != null && (order.getUserId() == user.getUserid() || "admin".equals(user.getRole()))) {
                    List<OrderItem> orderItems = getOrderItems(orderId);
                    req.setAttribute("order", order);
                    req.setAttribute("orderItems", orderItems);
                    req.getRequestDispatcher("order-success.jsp?viewOnly=true").forward(req, resp);
                } else {
                    resp.sendRedirect("orders?errorMessage=Unauthorized access to order details.");
                }
                return;
            }

            // Default action: List all orders for the current user
            List<OrderTable> allOrders = orderDao.getAllOrders();
            List<OrderTable> userOrders = new ArrayList<>();

            for (OrderTable order : allOrders) {
                if (order.getUserId() == user.getUserid()) {
                    userOrders.add(order);
                }
            }

            // Sort orders by date descending (newest first)
            userOrders.sort((o1, o2) -> o2.getOrderDate().compareTo(o1.getOrderDate()));

            req.setAttribute("userOrders", userOrders);
            req.getRequestDispatcher("order-history.jsp").forward(req, resp);

        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect("callRestaurantServlet?errorMessage=An error occurred while loading orders.");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) 
            throws ServletException, IOException {
        doGet(req, resp);
    }

    // Helper method to fetch items for a specific order efficiently
    private List<OrderItem> getOrderItems(int orderId) {
        List<OrderItem> items = new ArrayList<>();
        String query = "SELECT * FROM orderitem WHERE orderId = ?";
        
        try (Connection con = DBConnection.getConnection();
             PreparedStatement pstmt = con.prepareStatement(query)) {
            
            pstmt.setInt(1, orderId);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    items.add(new OrderItem(
                        rs.getInt("orderItemId"),
                        rs.getInt("orderId"),
                        rs.getInt("menuId"),
                        rs.getInt("quantity"),
                        rs.getDouble("itemTotal")
                    ));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return items;
    }
}
