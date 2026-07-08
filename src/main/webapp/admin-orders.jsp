<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="com.food.model.User" %>
<%
  HttpSession sess = request.getSession();
  User user = (User) sess.getAttribute("loggedInUser");
  if (user == null || (!"admin".equalsIgnoreCase(user.getRole()) && !"delivery_agent".equalsIgnoreCase(user.getRole()))) {
      response.sendRedirect(request.getContextPath() + "/login.jsp?errorMessage=Access Denied.");
      return;
  }
  
  List<Map<String, Object>> ordersList = (List<Map<String, Object>>) request.getAttribute("adminOrderList");
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Admin - Manage Orders</title>
  <style>
    :root {
      --ink: #24123f;
      --muted: #716985;
      --purple: #6f2de2;
      --page: #fbf8ff;
      --card: #ffffff;
      --line: rgba(77, 45, 132, 0.14);
      --shadow: 0 16px 34px rgba(56, 29, 111, 0.12);
    }
    * { box-sizing: border-box; }
    body {
      margin: 0; color: var(--ink); font-family: Arial, Helvetica, sans-serif;
      background: radial-gradient(circle at 12% 12%, rgba(137, 75, 241, 0.14), transparent 24rem),
                  linear-gradient(180deg, #ffffff 0%, var(--page) 58%, #f3edff 100%);
      min-height: 100vh; display: flex; flex-direction: column;
    }
    a { color: inherit; text-decoration: none; }
    .topbar { position: sticky; top: 0; z-index: 20; background: linear-gradient(90deg, #8743f2 0%, #5a1bcc 100%); box-shadow: 0 7px 22px rgba(60, 22, 144, 0.26); }
    .nav { display: flex; align-items: center; justify-content: space-between; width: min(1200px, calc(100% - 40px)); min-height: 76px; margin: 0 auto; color: #fff; gap: 24px; }
    .brand { display: flex; align-items: center; gap: 10px; font-size: 25px; font-weight: 900; }
    .brand-mark { position: relative; display: grid; place-items: center; width: 42px; height: 42px; border-radius: 14px; background: linear-gradient(145deg, #fff2bd, #ffb629); }
    .nav-links { display: flex; justify-content: center; gap: 16px; padding: 0; margin: 0; list-style: none; }
    .nav-links a { display: inline-flex; align-items: center; min-height: 42px; padding: 0 17px; border-radius: 14px; font-size: 14px; font-weight: 800; white-space: nowrap; }
    .nav-links a.active, .nav-links a:hover { background: rgba(255, 255, 255, 0.15); }
    .container { width: min(1200px, calc(100% - 40px)); margin: 40px auto; flex: 1; }
    h1 { margin: 0 0 30px; font-size: 36px; font-weight: 900; }
    h1 span { color: var(--purple); }
    
    .card { border: 1px solid var(--line); border-radius: 22px; background: var(--card); box-shadow: var(--shadow); padding: 30px; }
    
    /* Tables */
    .admin-table { width: 100%; border-collapse: collapse; }
    .admin-table th, .admin-table td { padding: 14px 12px; text-align: left; vertical-align: middle; }
    .admin-table th { border-bottom: 2px solid var(--line); font-weight: 900; color: var(--muted); font-size: 13px; }
    .admin-table td { border-bottom: 1px solid var(--line); font-size: 14px; font-weight: 700; }
    
    .alert { padding: 12px 16px; border-radius: 10px; font-size: 14px; font-weight: 800; margin-bottom: 20px; }
    .alert-success { background: #d4edda; color: #155724; }
    .alert-danger { background: #f8d7da; color: #721c24; }
    
    .status-select { padding: 6px 12px; border: 1px solid var(--line); border-radius: 8px; font-weight: 700; font-family: inherit; font-size: 13px; background: #fff; cursor: pointer; }
    .btn-update { padding: 6px 12px; background: var(--purple); color: #fff; border: none; border-radius: 8px; font-weight: 700; cursor: pointer; margin-left: 6px; }
    .btn-update:hover { background: #5a1bcc; }
    
    .status-pill { display: inline-block; padding: 4px 10px; border-radius: 999px; font-size: 11px; font-weight: 900; text-transform: uppercase; margin-bottom: 8px; }
    .status-pending { background: #ffe0b2; color: #e65100; }
    .status-accepted { background: #e3f2fd; color: #0d47a1; }
    .status-preparing { background: #e1bee7; color: #4a148c; }
    .status-outfordelivery { background: #e8f5e9; color: #1b5e20; }
    .status-delivered { background: #c8e6c9; color: #2e7d32; }
    .status-cancelled { background: #ffcdd2; color: #c62828; }
  </style>
</head>
<body>
  <div class="topbar">
    <div class="nav">
      <a href="<%= request.getContextPath() %>/callRestaurantServlet" class="brand" style="text-decoration:none; color:inherit;">
        <div class="brand-mark"></div>
        TastyBowl Admin
      </a>
      <ul class="nav-links">
        <% if ("admin".equalsIgnoreCase(user.getRole())) { %>
          <li><a href="<%= request.getContextPath() %>/admin-dashboard.jsp">Dashboard</a></li>
          <li><a href="<%= request.getContextPath() %>/admin/users">Users CRUD</a></li>
          <li><a href="<%= request.getContextPath() %>/admin/restaurants">Restaurants CRUD</a></li>
          <li><a href="<%= request.getContextPath() %>/admin/menu">Menu CRUD</a></li>
          <li><a href="<%= request.getContextPath() %>/admin/orders" class="active">Orders</a></li>
        <% } else if ("delivery_agent".equalsIgnoreCase(user.getRole())) { %>
          <li><a href="<%= request.getContextPath() %>/admin/orders" class="active">Orders</a></li>
        <% } %>
      </ul>
      <div class="nav-actions">
        <span style="font-weight: 800; margin-right:15px"><%= user.getUsername() %></span>
        <a href="<%= request.getContextPath() %>/logout" style="padding: 8px 16px; border: 1px solid #fff; border-radius: 20px; font-weight: 800;">Logout</a>
      </div>
    </div>
  </div>

  <div class="container">
    <h1>Order <span>Management</span></h1>
    
    <% if (request.getParameter("successMessage") != null) { %>
      <div class="alert alert-success"><%= request.getParameter("successMessage") %></div>
    <% } %>
    <% if (request.getParameter("errorMessage") != null) { %>
      <div class="alert alert-danger"><%= request.getParameter("errorMessage") %></div>
    <% } %>

    <div class="card">
      <table class="admin-table">
        <thead>
          <tr>
            <th>Order ID</th>
            <th>Date</th>
            <th>Customer</th>
            <th>Restaurant</th>
            <th>Total Amount</th>
            <th>Payment</th>
            <th>Current Status</th>
            <th>Update Status</th>
          </tr>
        </thead>
        <tbody>
          <% 
            if (ordersList != null && !ordersList.isEmpty()) {
              for (Map<String, Object> order : ordersList) {
                  String status = (String) order.get("status");
                  String statusClass = status.toLowerCase().replace(" ", "");
          %>
          <tr>
            <td>#<%= order.get("orderId") %></td>
            <td><%= order.get("orderDate") %></td>
            <td><%= order.get("username") %></td>
            <td><%= order.get("restaurantName") %></td>
            <td>&#8377; <%= order.get("totalAmount") %></td>
            <td><%= order.get("paymentMethod") %></td>
            <td>
              <span class="status-pill status-<%= statusClass %>"><%= status %></span>
            </td>
            <td>
              <form action="orders" method="POST" style="display: flex; align-items: center;">
                <input type="hidden" name="action" value="updateStatus">
                <input type="hidden" name="orderId" value="<%= order.get("orderId") %>">
                <select name="status" class="status-select">
                  <option value="Pending" <%= "Pending".equals(status) ? "selected" : "" %>>Pending</option>
                  <option value="Accepted" <%= "Accepted".equals(status) ? "selected" : "" %>>Accepted</option>
                  <option value="Preparing" <%= "Preparing".equals(status) ? "selected" : "" %>>Preparing</option>
                  <option value="Out for Delivery" <%= "Out for Delivery".equals(status) ? "selected" : "" %>>Out for Delivery</option>
                  <option value="Delivered" <%= "Delivered".equals(status) ? "selected" : "" %>>Delivered</option>
                  <option value="Cancelled" <%= "Cancelled".equals(status) ? "selected" : "" %>>Cancelled</option>
                </select>
                <button type="submit" class="btn-update">Update</button>
              </form>
            </td>
          </tr>
          <% 
              }
            } else { 
          %>
          <tr>
            <td colspan="8" style="text-align:center;">No orders found.</td>
          </tr>
          <% } %>
        </tbody>
      </table>
    </div>
  </div>
</body>
</html>
