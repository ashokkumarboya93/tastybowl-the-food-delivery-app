<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.util.*" %>
<%@ page import="com.food.model.User, com.food.utility.DBConnection, com.food.daoimp.RestaurantDaoImpl, com.food.model.Restaurant" %>
<%
  HttpSession sess = request.getSession();
  User user = (User) sess.getAttribute("loggedInUser");
  if (user == null || !"admin".equalsIgnoreCase(user.getRole())) {
      response.sendRedirect("login.jsp?errorMessage=Access Denied. Admins only.");
      return;
  }

  double totalRevenue = 0;
  int totalOrders = 0;
  int totalRestaurants = 0;
  int totalCustomers = 0;
  
  List<Map<String, Object>> recentOrders = new ArrayList<>();
  RestaurantDaoImpl restaurantDao = new RestaurantDaoImpl();

  try (Connection con = DBConnection.getConnection()) {
      // 1. Revenue
      try (PreparedStatement ps = con.prepareStatement("SELECT SUM(totalAmount) FROM ordertable WHERE status != 'Cancelled'");
           ResultSet rs = ps.executeQuery()) {
          if (rs.next()) {
              totalRevenue = rs.getDouble(1);
          }
      }

      // 2. Total Orders
      try (PreparedStatement ps = con.prepareStatement("SELECT COUNT(*) FROM ordertable");
           ResultSet rs = ps.executeQuery()) {
          if (rs.next()) {
              totalOrders = rs.getInt(1);
          }
      }

      // 3. Total Restaurants
      try (PreparedStatement ps = con.prepareStatement("SELECT COUNT(*) FROM restaurant");
           ResultSet rs = ps.executeQuery()) {
          if (rs.next()) {
              totalRestaurants = rs.getInt(1);
          }
      }

      // 4. Total Customers
      try (PreparedStatement ps = con.prepareStatement("SELECT COUNT(*) FROM user WHERE role = 'customer'");
           ResultSet rs = ps.executeQuery()) {
          if (rs.next()) {
              totalCustomers = rs.getInt(1);
          }
      }

      // 5. Recent Orders
      String recentQuery = "SELECT o.*, u.username FROM ordertable o JOIN user u ON o.userId = u.userid ORDER BY o.orderDate DESC LIMIT 5";
      try (PreparedStatement ps = con.prepareStatement(recentQuery);
           ResultSet rs = ps.executeQuery()) {
          while (rs.next()) {
              Map<String, Object> orderMap = new HashMap<>();
              orderMap.put("orderId", rs.getInt("orderId"));
              orderMap.put("username", rs.getString("username"));
              orderMap.put("restaurantId", rs.getInt("restaurantId"));
              orderMap.put("orderDate", rs.getTimestamp("orderDate"));
              orderMap.put("totalAmount", rs.getDouble("totalAmount"));
              orderMap.put("status", rs.getString("status"));
              orderMap.put("paymentMethod", rs.getString("paymentMethod"));
              recentOrders.add(orderMap);
          }
      }

  } catch (Exception e) {
      e.printStackTrace();
  }
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Admin Dashboard - TastyBowl</title>
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

    .brand {
      display: flex;
      align-items: center;
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
      display: flex;
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

    /* Container */
    .container {
      width: min(1200px, calc(100% - 40px));
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

    /* Analytics Cards Grid */
    .metrics-grid {
      display: grid;
      grid-template-columns: repeat(4, 1fr);
      gap: 24px;
      margin-bottom: 40px;
    }

    .metric-card {
      border: 1px solid var(--line);
      border-radius: 22px;
      background: var(--card);
      box-shadow: var(--shadow);
      padding: 24px;
      display: flex;
      align-items: center;
      gap: 20px;
      transition: transform 180ms ease;
    }

    .metric-card:hover {
      transform: translateY(-5px);
    }

    .metric-icon {
      width: 60px;
      height: 60px;
      border-radius: 15px;
      background: #eee3ff;
      display: grid;
      place-items: center;
      font-size: 28px;
      color: var(--purple);
    }

    .metric-card:nth-child(2) .metric-icon { background: #ffe8e8; color: #b83232; }
    .metric-card:nth-child(3) .metric-icon { background: #e8f9ed; color: var(--green); }
    .metric-card:nth-child(4) .metric-icon { background: #fff8e5; color: var(--orange); }

    .metric-info h3 {
      margin: 0;
      font-size: 13px;
      font-weight: 900;
      color: var(--muted);
      text-transform: uppercase;
      letter-spacing: 0.5px;
    }

    .metric-info p {
      margin: 4px 0 0;
      font-size: 24px;
      font-weight: 900;
    }

    /* Main Content Layout */
    .dashboard-layout {
      display: grid;
      grid-template-columns: 1fr;
      gap: 30px;
    }

    .card {
      border: 1px solid var(--line);
      border-radius: 22px;
      background: var(--card);
      box-shadow: var(--shadow);
      padding: 30px;
    }

    .card h2 {
      margin: 0 0 20px;
      font-size: 22px;
      font-weight: 900;
    }

    /* Tables */
    .admin-table {
      width: 100%;
      border-collapse: collapse;
    }

    .admin-table th, .admin-table td {
      padding: 16px 12px;
      text-align: left;
    }

    .admin-table th {
      border-bottom: 2px solid var(--line);
      font-weight: 900;
      color: var(--muted);
      font-size: 13px;
    }

    .admin-table td {
      border-bottom: 1px solid var(--line);
      font-size: 14px;
      font-weight: 700;
    }

    /* Status Pill */
    .status-pill {
      display: inline-block;
      padding: 4px 10px;
      border-radius: 999px;
      font-size: 11px;
      font-weight: 900;
      text-transform: uppercase;
    }

    .status-pending { background: #ffe0b2; color: #e65100; }
    .status-accepted { background: #e3f2fd; color: #0d47a1; }
    .status-preparing { background: #e1bee7; color: #4a148c; }
    .status-outfordelivery { background: #e8f5e9; color: #1b5e20; }
    .status-delivered { background: #c8e6c9; color: #2e7d32; }
    .status-cancelled { background: #ffcdd2; color: #c62828; }

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
        TastyBowl Admin
      </a>
      <ul class="nav-links">
        <% if ("admin".equalsIgnoreCase(user.getRole())) { %>
          <li><a href="<%= request.getContextPath() %>/admin-dashboard.jsp" class="active">Dashboard</a></li>
          <li><a href="<%= request.getContextPath() %>/admin/users">Users CRUD</a></li>
          <li><a href="<%= request.getContextPath() %>/admin/restaurants">Restaurants CRUD</a></li>
          <li><a href="<%= request.getContextPath() %>/admin/menu">Menu CRUD</a></li>
          <li><a href="<%= request.getContextPath() %>/admin/orders">Orders</a></li>
        <% } else if ("restaurant_admin".equalsIgnoreCase(user.getRole())) { %>
          <li><a href="<%= request.getContextPath() %>/admin/menu" class="active">Menu CRUD</a></li>
        <% } else if ("delivery_agent".equalsIgnoreCase(user.getRole())) { %>
          <li><a href="<%= request.getContextPath() %>/admin/orders" class="active">Orders</a></li>
        <% } %>
      </ul>
      <div class="nav-actions">
        <span class="profile">
          <div class="avatar"><%= user.getUsername().substring(0, 1).toUpperCase() %></div>
          <%= user.getUsername() %>
        </span>
        <a href="<%= request.getContextPath() %>/logout" class="btn-secondary" style="height: 38px; border-radius: 19px; padding: 0 14px; display:inline-flex; align-items:center; font-weight:800; font-size:13px; border:1px solid var(--line);">Logout</a>
      </div>
    </div>
  </div>

  <div class="container">
    <h1>Platform <span>Analytics</span></h1>

    <!-- Metrics Cards Row -->
    <div class="metrics-grid">
      <div class="metric-card">
        <div class="metric-icon">💰</div>
        <div class="metric-info">
          <h3>Total Revenue</h3>
          <p>&#8377; <%= String.format("%.2f", totalRevenue) %></p>
        </div>
      </div>
      
      <div class="metric-card">
        <div class="metric-icon">📦</div>
        <div class="metric-info">
          <h3>Total Orders</h3>
          <p><%= totalOrders %></p>
        </div>
      </div>

      <div class="metric-card">
        <div class="metric-icon">🏪</div>
        <div class="metric-info">
          <h3>Restaurants</h3>
          <p><%= totalRestaurants %></p>
        </div>
      </div>

      <div class="metric-card">
        <div class="metric-icon">👥</div>
        <div class="metric-info">
          <h3>Customers</h3>
          <p><%= totalCustomers %></p>
        </div>
      </div>
    </div>

    <!-- Layout: Recent Orders -->
    <div class="dashboard-layout">
      <div class="card">
        <h2>Recent Orders</h2>
        <table class="admin-table">
          <thead>
            <tr>
              <th>Order ID</th>
              <th>Customer</th>
              <th>Restaurant</th>
              <th>Date</th>
              <th>Total Amount</th>
              <th>Payment</th>
              <th>Status</th>
            </tr>
          </thead>
          <tbody>
            <%
              if (recentOrders.isEmpty()) {
            %>
              <tr>
                <td colspan="7" style="text-align: center; color: var(--muted);">No orders found on the platform yet.</td>
              </tr>
            <%
              } else {
                  for (Map<String, Object> orderMap : recentOrders) {
                      int rId = (Integer) orderMap.get("restaurantId");
                      Restaurant rest = restaurantDao.getRestaurant(rId);
                      String status = (String) orderMap.get("status");
                      String statusClass = status.toLowerCase().replace(" ", "");
            %>
              <tr>
                <td>#<%= orderMap.get("orderId") %></td>
                <td><%= orderMap.get("username") %></td>
                <td><%= rest != null ? rest.getName() : "Unknown (" + rId + ")" %></td>
                <td><%= orderMap.get("orderDate") %></td>
                <td>&#8377; <%= orderMap.get("totalAmount") %></td>
                <td><%= orderMap.get("paymentMethod") %></td>
                <td>
                  <span class="status-pill status-<%= statusClass %>"><%= status %></span>
                </td>
              </tr>
            <%
                  }
              }
            %>
          </tbody>
        </table>
      </div>
    </div>
  </div>

  <footer class="footer">
    <p>&copy; 2026 TastyBowl Food Platforms Inc. All rights reserved.</p>
  </footer>
</body>
</html>
