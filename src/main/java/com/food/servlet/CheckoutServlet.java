package com.food.servlet;

import java.io.IOException;
import java.sql.Timestamp;
import java.util.Map;

import com.food.daoimp.OrderDaoImpl;
import com.food.daoimp.OrderItemDaoImpl;
import com.food.daoimp.MenuDaoImpl;
import com.food.model.CartItem;
import com.food.model.Menu;
import com.food.model.OrderItem;
import com.food.model.OrderTable;
import com.food.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/checkout")
public class CheckoutServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) 
            throws ServletException, IOException {
        
        HttpSession session = req.getSession();
        User user = (User) session.getAttribute("loggedInUser");
        if (user == null) {
            resp.sendRedirect("login.jsp?errorMessage=Please log in to proceed to checkout.");
            return;
        }

        @SuppressWarnings("unchecked")
        Map<Integer, CartItem> cart = (Map<Integer, CartItem>) session.getAttribute("cart");
        if (cart == null || cart.isEmpty()) {
            resp.sendRedirect("cart.jsp?errorMessage=Your cart is empty. Add some items first!");
            return;
        }

        req.getRequestDispatcher("checkout.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) 
            throws ServletException, IOException {
        
        HttpSession session = req.getSession();
        User user = (User) session.getAttribute("loggedInUser");
        if (user == null) {
            resp.sendRedirect("login.jsp?errorMessage=Please log in to place an order.");
            return;
        }

        @SuppressWarnings("unchecked")
        Map<Integer, CartItem> cart = (Map<Integer, CartItem>) session.getAttribute("cart");
        if (cart == null || cart.isEmpty()) {
            resp.sendRedirect("cart.jsp?errorMessage=Your cart is empty.");
            return;
        }

        String address = req.getParameter("address");
        String city = req.getParameter("city");
        String state = req.getParameter("state");
        String pincode = req.getParameter("pincode");
        String paymentMethod = req.getParameter("paymentMethod");

        if (address == null || city == null || state == null || pincode == null || paymentMethod == null ||
            address.trim().isEmpty() || city.trim().isEmpty() || state.trim().isEmpty() || pincode.trim().isEmpty()) {
            req.setAttribute("errorMessage", "All shipping and payment details are required.");
            req.getRequestDispatcher("checkout.jsp").forward(req, resp);
            return;
        }

        try {
            Integer restaurantId = (Integer) session.getAttribute("cartRestaurantId");
            if (restaurantId == null) {
                resp.sendRedirect("cart.jsp?errorMessage=Restaurant ID not found in cart session.");
                return;
            }

            // Calculations
            double subtotal = 0;
            MenuDaoImpl menuDao = new MenuDaoImpl();
            for (CartItem item : cart.values()) {
                Menu menu = menuDao.getMenu(item.getMenuId());
                if (menu != null) {
                    subtotal += item.getQuantity() * menu.getPrice();
                }
            }

            double gst = subtotal * 0.05; // 5% GST
            double deliveryCharge = 40.0; // Flat Delivery Fee
            double platformFee = 5.0; // Platform Fee
            double discount = 0.0; // Optional coupon code implementation could go here
            
            // Check if user has discount coupon
            String couponCode = req.getParameter("couponCode");
            if ("WELCOME50".equalsIgnoreCase(couponCode)) {
                discount = 50.0;
            }

            double grandTotal = subtotal + gst + deliveryCharge + platformFee - discount;
            if (grandTotal < 0) grandTotal = 0;

            // Combine address details
            String fullAddress = address.trim() + ", " + city.trim() + ", " + state.trim() + " - " + pincode.trim();

            // Create Order Table
            OrderTable order = new OrderTable();
            order.setUserId(user.getUserid());
            order.setRestaurantId(restaurantId);
            order.setOrderDate(new Timestamp(System.currentTimeMillis()));
            order.setTotalAmount(grandTotal);
            order.setStatus("Pending");
            order.setPaymentMethod(paymentMethod);

            OrderDaoImpl orderDao = new OrderDaoImpl();
            int orderId = orderDao.addOrder(order);

            if (orderId > 0) {
                // Insert Order Items
                OrderItemDaoImpl orderItemDao = new OrderItemDaoImpl();
                for (CartItem item : cart.values()) {
                    OrderItem orderItem = new OrderItem();
                    orderItem.setOrderId(orderId);
                    orderItem.setMenuId(item.getMenuId());
                    orderItem.setQuantity(item.getQuantity());
                    orderItem.setItemTotal(item.getTotalPrice());
                    
                    orderItemDao.addOrderItem(orderItem);
                }

                // Clear Cart
                cart.clear();
                session.removeAttribute("cartRestaurantId");
                session.removeAttribute("cart");

                // Save Order ID to session or request attribute for success page
                resp.sendRedirect("order-success.jsp?orderId=" + orderId);

            } else {
                req.setAttribute("errorMessage", "Failed to place your order. Please try again.");
                req.getRequestDispatcher("checkout.jsp").forward(req, resp);
            }

        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("errorMessage", "An error occurred while processing checkout. Please try again.");
            req.getRequestDispatcher("checkout.jsp").forward(req, resp);
        }
    }
}
