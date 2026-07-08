<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, com.food.model.OrderTable, com.food.daoimp.RestaurantDaoImpl, com.food.model.Restaurant, com.food.model.User" %>
<%
  HttpSession sess = request.getSession();
  User user = (User) sess.getAttribute("loggedInUser");
  if (user == null) {
      response.sendRedirect("login.jsp?errorMessage=Please log in to view order history.");
      return;
  }
  @SuppressWarnings("unchecked")
  List<OrderTable> userOrders = (List<OrderTable>) request.getAttribute("userOrders");
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Order History - TastyBowl</title>
  <style>
    :root {
      --ink: #24123f;
      --muted: #716985;
      --purple: #6f2de2;
      --purple-dark: #4e18c3;
      --orange: #ffb321;
      --green: #218848;
      --line: rgba(77, 45, 132, 0.14);
      --card: #ffffff;
      --page: #fbf8ff;
      --shadow: 0 16px 34px rgba(56, 29, 111, 0.12);
    }

    * {
      box-sizing: border-box;
    }

    body {
      margin: 0;
      color: var(--ink);
      font-family: Arial, Helvetica, sans-serif;
      background:
        radial-gradient(circle at 12% 12%, rgba(137, 75, 241, 0.14), transparent 24rem),
        linear-gradient(180deg, #ffffff 0%, var(--page) 58%, #f3edff 100%);
      min-height: 100vh;
      display: flex;
      flex-direction: column;
    }

    a {
      color: inherit;
      text-decoration: none;
    }

    /* Topbar */
    .topbar {
      position: sticky;
      top: 0;
      z-index: 20;
      background: linear-gradient(90deg, #8743f2 0%, #5a1bcc 100%);
      box-shadow: 0 7px 22px rgba(60, 22, 144, 0.26);
    }

    .nav {
      display: flex;
      align-items: center;
      justify-content: space-between;
      width: min(1200px, calc(100% - 40px));
      min-height: 76px;
      margin: 0 auto;
      color: #fff;
      gap: 24px;
    }

    .brand, .nav-links, .nav-actions, .profile {
      display: flex;
      align-items: center;
    }

    .brand {
      gap: 10px;
      font-size: 25px;
      font-weight: 900;
    }

    .brand-mark {
      position: relative;
      display: grid;
      place-items: center;
      width: 42px;
      height: 42px;
      border-radius: 14px;
      background: linear-gradient(145deg, #fff2bd, #ffb629);
      box-shadow: inset 0 -5px 10px rgba(107, 47, 9, 0.18), 0 8px 18px rgba(52, 16, 129, 0.22);
    }

    .brand-mark::before {
      content: "";
      width: 25px;
      height: 12px;
      border: 4px solid #5b1dcf;
      border-top: 0;
      border-radius: 0 0 16px 16px;
      background: #fff;
      transform: translateY(3px);
    }

    .brand-mark::after {
      content: "";
      position: absolute;
      top: 10px;
      width: 22px;
      height: 7px;
      border-radius: 50%;
      background: #f05254;
      box-shadow: 7px 1px 0 #38b86f, -7px 2px 0 #fff;
    }

    .nav-links {
      justify-content: center;
      gap: 16px;
      padding: 0;
      margin: 0;
      list-style: none;
    }

    .nav-links a {
      display: inline-flex;
      align-items: center;
      min-height: 42px;
      padding: 0 17px;
      border-radius: 14px;
      font-size: 14px;
      font-weight: 800;
      white-space: nowrap;
    }

    .nav-links a.active,
    .nav-links a:hover {
      background: rgba(255, 255, 255, 0.15);
    }

    .nav-actions {
      gap: 12px;
    }

    .profile {
      gap: 9px;
      min-height: 46px;
      padding: 0 15px 0 6px;
      border-radius: 24px;
      background: rgba(255, 255, 255, 0.14);
      font-size: 14px;
      font-weight: 800;
    }

    .avatar {
      display: grid;
      place-items: center;
      width: 36px;
      height: 36px;
      border: 3px solid #fff;
      border-radius: 50%;
      background: #ffe0b2;
      font-size: 19px;
      color: var(--ink);
    }

    .btn-secondary {
      display: inline-flex;
      align-items: center;
      gap: 8px;
      padding: 0 20px;
      height: 44px;
      border: 1px solid var(--line);
      border-radius: 12px;
      font-weight: 900;
      font-size: 14px;
      color: var(--ink);
      background: #fff;
      cursor: pointer;
    }

    .btn-secondary:hover {
      background: #faf8ff;
      border-color: var(--purple);
    }

    /* Container */
    .container {
      width: min(1000px, calc(100% - 40px));
      margin: 40px auto;
      flex: 1;
    }

    h1 {
      margin: 0 0 30px;
      font-size: 36px;
      font-weight: 900;
    }

    h1 span {
      color: var(--purple);
    }

    /* Order Cards */
    .orders-list {
      display: grid;
      gap: 20px;
    }

    .order-card {
      border: 1px solid var(--line);
      border-radius: 22px;
      background: var(--card);
      box-shadow: var(--shadow);
      padding: 24px;
      display: flex;
      justify-content: space-between;
      align-items: center;
      transition: transform 180ms ease, border-color 180ms ease;
    }

    .order-card:hover {
      transform: translateY(-4px);
      border-color: rgba(111, 45, 226, 0.2);
    }

    .order-info {
      display: flex;
      align-items: center;
      gap: 20px;
    }

    .order-img {
      width: 64px;
      height: 64px;
      border-radius: 14px;
      background: linear-gradient(135deg, #eee3ff, #fff0cc);
      display: grid;
      place-items: center;
      font-size: 28px;
      box-shadow: inset 0 -4px 10px rgba(111, 45, 226, 0.08);
    }

    .order-details h3 {
      margin: 0 0 4px;
      font-size: 20px;
      font-weight: 900;
    }

    .order-details p {
      margin: 0 0 4px;
      font-size: 13px;
      color: var(--muted);
      font-weight: 700;
    }

    .order-details strong {
      color: var(--purple);
      font-size: 16px;
      font-weight: 900;
    }

    .order-meta {
      display: flex;
      flex-direction: column;
      align-items: flex-end;
      gap: 10px;
    }

    /* Status Pill */
    .status-pill {
      display: inline-block;
      padding: 6px 14px;
      border-radius: 999px;
      font-size: 12px;
      font-weight: 900;
      text-transform: uppercase;
    }

    .status-pending { background: #ffe0b2; color: #e65100; }
    .status-accepted { background: #e3f2fd; color: #0d47a1; }
    .status-preparing { background: #e1bee7; color: #4a148c; }
    .status-outfordelivery { background: #e8f5e9; color: #1b5e20; }
    .status-delivered { background: #c8e6c9; color: #2e7d32; }
    .status-cancelled { background: #ffcdd2; color: #c62828; }

    .btn-details {
      display: inline-flex;
      align-items: center;
      height: 38px;
      padding: 0 16px;
      border-radius: 19px;
      font-size: 13px;
      font-weight: 900;
      color: var(--purple);
      border: 1px solid var(--purple);
      background: #fff;
    }

    .btn-details:hover {
      background: var(--purple);
      color: #fff;
    }

    .empty-state {
      text-align: center;
      padding: 60px 40px;
      border: 2px dashed var(--line);
      border-radius: 28px;
      background: #fff;
      box-shadow: var(--shadow);
    }

    .empty-state span {
      display: block;
      font-size: 64px;
      margin-bottom: 20px;
    }

    .empty-state h2 {
      margin: 0 0 10px;
      font-size: 28px;
      font-weight: 900;
    }

    .empty-state p {
      color: var(--muted);
      font-weight: 700;
      margin-bottom: 24px;
    }

    .btn-primary {
      display: inline-flex;
      align-items: center;
      justify-content: center;
      height: 48px;
      padding: 0 24px;
      border: 0;
      border-radius: 24px;
      color: #fff;
      background: var(--purple);
      font-weight: 900;
      box-shadow: 0 8px 16px rgba(111, 45, 226, 0.2);
    }

    .btn-primary:hover {
      transform: translateY(-2px);
    }

    /* Footer */
    .footer {
      text-align: center;
      padding: 24px 12px;
      color: var(--muted);
      font-size: 13px;
      font-weight: 700;
      border-top: 1px solid var(--line);
      background: #fff;
      margin-top: auto;
    }
  </style>
</head>
<body>
  <div class="topbar">
    <div class="nav">
      <a href="callRestaurantServlet" class="brand" style="text-decoration:none; color:inherit;">
        <div class="brand-mark"></div>
        TastyBowl
      </a>
      <ul class="nav-links">
        <li><a href="callRestaurantServlet">Home</a></li>
        <li><a href="orders" class="active">My Orders</a></li>
        <li><a href="profile">Profile</a></li>
      </ul>
      <div class="nav-actions">
        <a href="profile" class="profile">
          <div class="avatar"><%= user.getUsername().substring(0, 1).toUpperCase() %></div>
          <%= user.getUsername() %>
        </a>
      </div>
    </div>
  </div>

  <div class="container">
    <h1>Your <span>Order History</span></h1>

    <% if (request.getParameter("errorMessage") != null) { %>
      <div class="alert alert-danger" style="padding: 14px 20px; border-radius: 12px; font-size:14px; font-weight:800; text-align:center; color:#721c24; background-color:#f8d7da; border:1px solid #f5c6cb; margin-bottom:24px;">
        <%= request.getParameter("errorMessage") %>
      </div>
    <% } %>

    <%
      if (userOrders == null || userOrders.isEmpty()) {
    %>
      <div class="empty-state">
        <span>🍔</span>
        <h2>No Orders <span>Found</span></h2>
        <p>You haven't placed any orders yet. Let's get you something tasty!</p>
        <a href="callRestaurantServlet" class="btn-primary">Order Now</a>
      </div>
    <%
      } else {
        RestaurantDaoImpl restaurantDao = new RestaurantDaoImpl();
    %>
      <div class="orders-list">
        <%
          for (OrderTable order : userOrders) {
              Restaurant r = restaurantDao.getRestaurant(order.getRestaurantId());
              String status = order.getStatus();
              String statusClass = status.toLowerCase().replace(" ", "");
        %>
          <div class="order-card">
            <div class="order-info">
              <div class="order-img">🥡</div>
              <div class="order-details">
                <h3><%= r != null ? r.getName() : "Restaurant" %></h3>
                <p>Date: <%= order.getOrderDate() %></p>
                <p>Payment: <%= order.getPaymentMethod() %></p>
                <strong>Total Amount: &#8377; <%= order.getTotalAmount() %></strong>
              </div>
            </div>
            
            <div class="order-meta">
              <span class="status-pill status-<%= statusClass %>"><%= status %></span>
              <a href="orders?action=details&orderId=<%= order.getOrderId() %>" class="btn-details">View Invoice</a>
            </div>
          </div>
        <%
          }
        %>
      </div>
    <%
      }
    %>
  </div>

  <footer class="footer">
    <p>&copy; 2026 TastyBowl Food Platforms Inc. All rights reserved.</p>
  </footer>
</body>
</html>
