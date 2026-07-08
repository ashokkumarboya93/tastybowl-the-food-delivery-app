<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.util.ArrayList, java.util.List" %>
<%@ page import="com.food.model.OrderTable, com.food.model.OrderItem, com.food.model.Menu, com.food.daoimp.OrderDaoImpl, com.food.daoimp.MenuDaoImpl, com.food.daoimp.RestaurantDaoImpl, com.food.model.Restaurant, com.food.model.User, com.food.utility.DBConnection" %>
<%
  HttpSession sess = request.getSession();
  User user = (User) sess.getAttribute("loggedInUser");
  if (user == null) {
      response.sendRedirect("login.jsp?errorMessage=Please log in to view this page.");
      return;
  }

  boolean viewOnly = "true".equalsIgnoreCase(request.getParameter("viewOnly"));
  OrderTable order = (OrderTable) request.getAttribute("order");
  @SuppressWarnings("unchecked")
  List<OrderItem> orderItems = (List<OrderItem>) request.getAttribute("orderItems");

  // Fallback: If attributes are null, try to load using orderId parameter
  String orderIdStr = request.getParameter("orderId");
  if (order == null && orderIdStr != null) {
      try {
          int orderId = Integer.parseInt(orderIdStr);
          OrderDaoImpl orderDao = new OrderDaoImpl();
          order = orderDao.getOrder(orderId);
          
          if (order != null) {
              // Security check: Order must belong to user or user must be admin
              if (order.getUserId() != user.getUserid() && !"admin".equals(user.getRole())) {
                  response.sendRedirect("orders?errorMessage=Unauthorized access to order details.");
                  return;
              }

              // Load items
              orderItems = new ArrayList<>();
              try (Connection con = DBConnection.getConnection();
                   PreparedStatement pstmt = con.prepareStatement("SELECT * FROM orderitem WHERE orderId = ?")) {
                  pstmt.setInt(1, orderId);
                  try (ResultSet rs = pstmt.executeQuery()) {
                      while (rs.next()) {
                          orderItems.add(new OrderItem(
                              rs.getInt("orderItemId"),
                              rs.getInt("orderId"),
                              rs.getInt("menuId"),
                              rs.getInt("quantity"),
                              rs.getDouble("itemTotal")
                          ));
                      }
                  }
              }
          }
      } catch (Exception e) {
          e.printStackTrace();
      }
  }

  if (order == null) {
      response.sendRedirect("orders?errorMessage=Order not found.");
      return;
  }

  RestaurantDaoImpl restaurantDao = new RestaurantDaoImpl();
  Restaurant restaurant = restaurantDao.getRestaurant(order.getRestaurantId());
  MenuDaoImpl menuDao = new MenuDaoImpl();
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title><%= viewOnly ? "Order Details" : "Order Placed Successfully" %> - TastyBowl</title>
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

    /* Container */
    .container {
      width: min(800px, calc(100% - 40px));
      margin: 40px auto;
      flex: 1;
    }

    .success-card {
      border: 1px solid var(--line);
      border-radius: 28px;
      background: var(--card);
      box-shadow: var(--shadow);
      padding: 40px;
      text-align: center;
      backdrop-filter: blur(10px);
      margin-bottom: 30px;
    }

    .success-icon {
      width: 80px;
      height: 80px;
      background: #e3f9eb;
      color: var(--green);
      border-radius: 50%;
      font-size: 40px;
      display: grid;
      place-items: center;
      margin: 0 auto 24px;
      box-shadow: 0 8px 20px rgba(33, 136, 72, 0.15);
    }

    .success-card h1 {
      margin: 0 0 10px;
      font-size: 32px;
      font-weight: 900;
    }

    .success-card h1 span {
      color: var(--purple);
    }

    .success-card p {
      color: var(--muted);
      font-size: 16px;
      font-weight: 700;
      margin: 0 0 24px;
    }

    /* Invoice Layout */
    .invoice {
      border: 1px solid var(--line);
      border-radius: 22px;
      background: var(--card);
      box-shadow: var(--shadow);
      padding: 35px;
      text-align: left;
    }

    .invoice-header {
      display: flex;
      justify-content: space-between;
      border-bottom: 2px solid var(--line);
      padding-bottom: 20px;
      margin-bottom: 24px;
    }

    .invoice-details h2 {
      margin: 0 0 6px;
      font-size: 20px;
      font-weight: 900;
    }

    .invoice-details p {
      margin: 0;
      font-size: 13px;
      color: var(--muted);
      font-weight: 700;
    }

    .invoice-meta {
      text-align: right;
    }

    .invoice-meta h3 {
      margin: 0 0 6px;
      font-size: 18px;
      font-weight: 900;
      color: var(--purple);
    }

    .invoice-meta p {
      margin: 0 0 4px;
      font-size: 13px;
      color: var(--muted);
      font-weight: 700;
    }

    /* Status Pill */
    .status-pill {
      display: inline-block;
      padding: 6px 14px;
      border-radius: 999px;
      font-size: 12px;
      font-weight: 900;
      text-transform: uppercase;
      margin-top: 10px;
    }

    .status-pending { background: #ffe0b2; color: #e65100; }
    .status-accepted { background: #e3f2fd; color: #0d47a1; }
    .status-preparing { background: #e1bee7; color: #4a148c; }
    .status-outfordelivery { background: #e8f5e9; color: #1b5e20; }
    .status-delivered { background: #c8e6c9; color: #2e7d32; }
    .status-cancelled { background: #ffcdd2; color: #c62828; }

    /* Invoice Items Table */
    .invoice-table {
      width: 100%;
      border-collapse: collapse;
      margin-bottom: 24px;
    }

    .invoice-table th, .invoice-table td {
      padding: 14px 10px;
      text-align: left;
    }

    .invoice-table th {
      border-bottom: 2px solid var(--line);
      font-weight: 900;
      color: var(--muted);
      font-size: 13px;
    }

    .invoice-table td {
      border-bottom: 1px solid var(--line);
      font-size: 14px;
      font-weight: 700;
    }

    .invoice-table td.price {
      text-align: right;
    }

    .invoice-table th.price {
      text-align: right;
    }

    .invoice-totals {
      width: min(340px, 100%);
      margin-left: auto;
      border-top: 2px solid var(--line);
      padding-top: 15px;
    }

    .total-row {
      display: flex;
      justify-content: space-between;
      margin-bottom: 10px;
      font-size: 14px;
      font-weight: 700;
      color: var(--muted);
    }

    .total-row.grand {
      font-size: 18px;
      font-weight: 900;
      color: var(--ink);
      margin-top: 15px;
      padding-top: 15px;
      border-top: 1px solid var(--line);
    }

    .total-row.grand span {
      color: var(--purple);
    }

    .btn-actions {
      display: flex;
      justify-content: center;
      gap: 15px;
      margin-top: 35px;
    }

    .btn {
      display: inline-flex;
      align-items: center;
      justify-content: center;
      height: 48px;
      padding: 0 24px;
      border-radius: 24px;
      font-weight: 900;
      font-size: 14px;
      cursor: pointer;
      box-shadow: 0 8px 16px rgba(0,0,0,0.06);
    }

    .btn-primary {
      color: #fff;
      background: linear-gradient(135deg, #8844f5, #6422d8);
      box-shadow: 0 8px 18px rgba(111, 45, 226, 0.2);
    }

    .btn-primary:hover {
      transform: translateY(-2px);
    }

    .btn-secondary {
      color: var(--ink);
      background: #fff;
      border: 1px solid var(--line);
    }

    .btn-secondary:hover {
      background: #faf8ff;
      border-color: var(--purple);
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
    </div>
  </div>

  <div class="container">
    <% if (!viewOnly) { %>
      <div class="success-card">
        <div class="success-icon">✓</div>
        <h1>Order <span>Placed Successfully!</span></h1>
        <p>Thank you for your order! Your delicious meal is being prepared and will be delivered shortly.</p>
        <div class="invoice-meta" style="text-align: center;">
          <p>Estimated Delivery Time: <strong><%= restaurant != null ? restaurant.getDeliveryTime() + 15 : 45 %> minutes</strong></p>
        </div>
      </div>
    <% } %>

    <div class="invoice">
      <div class="invoice-header">
        <div class="invoice-details">
          <h2><%= restaurant != null ? restaurant.getName() : "Restaurant" %></h2>
          <p><%= restaurant != null ? restaurant.getAddress() : "" %></p>
          <p>Cuisine: <%= restaurant != null ? restaurant.getCuisineType() : "" %></p>
        </div>
        <div class="invoice-meta">
          <h3>INVOICE</h3>
          <p>Order ID: <strong>#<%= order.getOrderId() %></strong></p>
          <p>Date: <%= order.getOrderDate() %></p>
          <p>Payment: <%= order.getPaymentMethod() %></p>
          <%
            String status = order.getStatus();
            String statusClass = status.toLowerCase().replace(" ", "");
          %>
          <span class="status-pill status-<%= statusClass %>"><%= status %></span>
        </div>
      </div>

      <table class="invoice-table">
        <thead>
          <tr>
            <th>Item Name</th>
            <th>Category</th>
            <th>Qty</th>
            <th class="price">Price</th>
            <th class="price">Total</th>
          </tr>
        </thead>
        <tbody>
          <%
            double subtotal = 0;
            if (orderItems != null) {
                for (OrderItem item : orderItems) {
                    Menu menu = menuDao.getMenu(item.getMenuId());
                    if (menu != null) {
                        subtotal += item.getQuantity() * menu.getPrice();
          %>
            <tr>
              <td><%= menu.getItemName() %></td>
              <td><%= menu.getCategory() %></td>
              <td><%= item.getQuantity() %></td>
              <td class="price">&#8377; <%= menu.getPrice() %></td>
              <td class="price">&#8377; <%= item.getItemTotal() %></td>
            </tr>
          <%
                    }
                }
            }
            double gst = subtotal * 0.05;
            double deliveryFee = 40.0;
            double platformFee = 5.0;
            // Reverse calculate discount if any
            double grandTotal = order.getTotalAmount();
            double discount = subtotal + gst + deliveryFee + platformFee - grandTotal;
            if (discount < 1) discount = 0; // handle rounding
          %>
        </tbody>
      </table>

      <div class="invoice-totals">
        <div class="total-row">
          <span>Subtotal</span>
          <span>&#8377; <%= String.format("%.2f", subtotal) %></span>
        </div>
        <div class="total-row">
          <span>GST (5%)</span>
          <span>&#8377; <%= String.format("%.2f", gst) %></span>
        </div>
        <div class="total-row">
          <span>Delivery Fee</span>
          <span>&#8377; <%= deliveryFee %></span>
        </div>
        <div class="total-row">
          <span>Platform Fee</span>
          <span>&#8377; <%= platformFee %></span>
        </div>
        <% if (discount > 0) { %>
          <div class="total-row" style="color: var(--green); font-weight:800;">
            <span>Discount Applied</span>
            <span>- &#8377; <%= String.format("%.2f", discount) %></span>
          </div>
        <% } %>
        <div class="total-row grand">
          <span>Grand Total</span>
          <span>&#8377; <%= String.format("%.2f", grandTotal) %></span>
        </div>
      </div>

      <div class="btn-actions">
        <a href="callRestaurantServlet" class="btn btn-primary">Go to Home</a>
        <a href="orders" class="btn btn-secondary">Order History</a>
      </div>
    </div>
  </div>

  <footer class="footer">
    <p>&copy; 2026 TastyBowl Food Platforms Inc. All rights reserved.</p>
  </footer>
</body>
</html>
