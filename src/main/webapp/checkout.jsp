<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.Map, com.food.model.CartItem, com.food.model.Menu, com.food.daoimp.MenuDaoImpl, com.food.model.User" %>
<%
  HttpSession sess = request.getSession();
  User user = (User) sess.getAttribute("loggedInUser");
  if (user == null) {
      response.sendRedirect("login.jsp?errorMessage=Please log in to proceed.");
      return;
  }
  @SuppressWarnings("unchecked")
  Map<Integer, CartItem> cart = (Map<Integer, CartItem>) sess.getAttribute("cart");
  if (cart == null || cart.isEmpty()) {
      response.sendRedirect("cart.jsp?errorMessage=Your cart is empty.");
      return;
  }

  double subtotal = 0;
  MenuDaoImpl menuDao = new MenuDaoImpl();
  for (CartItem item : cart.values()) {
      Menu menu = menuDao.getMenu(item.getMenuId());
      if (menu != null) {
          subtotal += item.getQuantity() * menu.getPrice();
      }
  }

  double gst = subtotal * 0.05;
  double deliveryFee = 40.0;
  double platformFee = 5.0;
  double discount = 0.0;

  String appliedCoupon = (String) sess.getAttribute("appliedCoupon");
  if ("WELCOME50".equalsIgnoreCase(appliedCoupon)) {
      discount = 50.0;
  }

  double grandTotal = subtotal + gst + deliveryFee + platformFee - discount;
  if (grandTotal < 0) grandTotal = 0;
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Checkout - TastyBowl</title>
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

    .checkout-layout {
      display: grid;
      grid-template-columns: 1.5fr 1fr;
      gap: 30px;
      align-items: start;
    }

    .card {
      border: 1px solid var(--line);
      border-radius: 22px;
      background: var(--card);
      box-shadow: var(--shadow);
      padding: 35px;
      margin-bottom: 30px;
    }

    .card h2 {
      margin: 0 0 24px;
      font-size: 22px;
      font-weight: 900;
      border-bottom: 2px solid var(--line);
      padding-bottom: 12px;
    }

    .form-group {
      margin-bottom: 20px;
    }

    .form-row {
      display: grid;
      grid-template-columns: 1fr 1fr;
      gap: 15px;
    }

    label {
      display: block;
      font-size: 14px;
      font-weight: 800;
      margin-bottom: 8px;
      color: var(--ink);
    }

    input[type="text"], textarea {
      width: 100%;
      height: 48px;
      padding: 10px 16px;
      border: 1px solid var(--line);
      border-radius: 12px;
      outline: none;
      font-size: 14px;
      font-weight: 600;
      background: #fff;
      transition: border-color 180ms ease, box-shadow 180ms ease;
    }

    textarea {
      height: 80px;
      resize: none;
    }

    input[type="text"]:focus, textarea:focus {
      border-color: var(--purple);
      box-shadow: 0 0 0 4px rgba(111, 45, 226, 0.15);
    }

    /* Payment Mode Radio Buttons */
    .payment-options {
      display: grid;
      gap: 15px;
    }

    .payment-option {
      display: flex;
      align-items: center;
      gap: 12px;
      border: 1px solid var(--line);
      border-radius: 12px;
      padding: 16px;
      cursor: pointer;
      font-weight: 800;
      font-size: 15px;
      transition: border-color 150ms ease, background 150ms ease;
    }

    .payment-option input {
      width: 18px;
      height: 18px;
      accent-color: var(--purple);
    }

    .payment-option:hover,
    .payment-option.active {
      border-color: var(--purple);
      background: #faf8ff;
    }

    /* Summary Section */
    .summary-card {
      border: 1px solid var(--line);
      border-radius: 22px;
      background: var(--card);
      box-shadow: var(--shadow);
      padding: 30px;
      position: sticky;
      top: 100px;
    }

    .summary-card h2 {
      margin: 0 0 20px;
      font-size: 22px;
      font-weight: 900;
    }

    .checkout-items {
      max-height: 200px;
      overflow-y: auto;
      margin-bottom: 20px;
      padding-right: 5px;
    }

    .checkout-item {
      display: flex;
      justify-content: space-between;
      align-items: center;
      margin-bottom: 12px;
      font-size: 14px;
      font-weight: 700;
    }

    .checkout-item span:first-child {
      color: var(--ink);
    }

    .checkout-item span:last-child {
      color: var(--muted);
      font-weight: 800;
    }

    .bill-row {
      display: flex;
      justify-content: space-between;
      margin-bottom: 12px;
      font-size: 14px;
      font-weight: 700;
      color: var(--muted);
    }

    .bill-row.total {
      margin-top: 15px;
      padding-top: 15px;
      border-top: 1px solid var(--line);
      font-size: 18px;
      font-weight: 900;
      color: var(--ink);
    }

    .bill-row.total span {
      color: var(--purple);
    }

    .btn-place-order {
      width: 100%;
      height: 52px;
      border: 0;
      border-radius: 26px;
      color: #fff;
      background: linear-gradient(135deg, #8844f5, #6422d8);
      box-shadow: 0 10px 18px rgba(111, 45, 226, 0.24);
      font-size: 16px;
      font-weight: 900;
      cursor: pointer;
      margin-top: 24px;
      transition: transform 150ms ease;
    }

    .btn-place-order:hover {
      transform: translateY(-2px);
      box-shadow: 0 14px 22px rgba(111, 45, 226, 0.32);
    }

    .alert {
      padding: 14px 20px;
      border-radius: 12px;
      font-size: 14px;
      font-weight: 800;
      margin-bottom: 24px;
      text-align: center;
    }

    .alert-danger {
      color: #721c24;
      background-color: #f8d7da;
      border: 1px solid #f5c6cb;
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
  <jsp:include page="navbar.jsp" />

  <div class="container">
    <h1>Confirm <span>Your Order</span></h1>

    <% if (request.getAttribute("errorMessage") != null) { %>
      <div class="alert alert-danger">
        <%= request.getAttribute("errorMessage") %>
      </div>
    <% } %>

    <form action="checkout" method="POST">
      <!-- Pass coupon code if applied to session -->
      <input type="hidden" name="couponCode" value="<%= appliedCoupon != null ? appliedCoupon : "" %>">

      <div class="checkout-layout">
        
        <!-- Left Column: Shipping & Payment Details -->
        <div>
          <div class="card">
            <h2>Delivery Address</h2>
            
            <div class="form-group">
              <label for="address">Street Address</label>
              <textarea id="address" name="address" placeholder="Flat No, Building Name, Street, Area" required><%= user.getAddress() != null ? user.getAddress() : "" %></textarea>
            </div>

            <div class="form-row">
              <div class="form-group">
                <label for="city">City</label>
                <input type="text" id="city" name="city" value="<%= user.getCity() != null ? user.getCity() : "" %>" required>
              </div>
              <div class="form-group">
                <label for="state">State</label>
                <input type="text" id="state" name="state" value="<%= user.getState() != null ? user.getState() : "" %>" required>
              </div>
            </div>

            <div class="form-group">
              <label for="pincode">Pincode</label>
              <input type="text" id="pincode" name="pincode" value="<%= user.getPincode() != null ? user.getPincode() : "" %>" required>
            </div>
          </div>

          <div class="card">
            <h2>Payment Method</h2>
            <div class="payment-options">
              <label class="payment-option active">
                <input type="radio" name="paymentMethod" value="Cash On Delivery" checked>
                💵 Cash On Delivery (COD)
              </label>
              <label class="payment-option">
                <input type="radio" name="paymentMethod" value="UPI">
                📱 UPI (Google Pay, PhonePe, Paytm)
              </label>
              <label class="payment-option">
                <input type="radio" name="paymentMethod" value="Card">
                💳 Credit / Debit Card
              </label>
            </div>
          </div>
        </div>

        <!-- Right Column: Final Summary -->
        <div class="summary-card">
          <h2>Order Summary</h2>
          
          <div class="checkout-items">
            <%
              for (CartItem item : cart.values()) {
                  Menu menu = menuDao.getMenu(item.getMenuId());
                  if (menu != null) {
            %>
              <div class="checkout-item">
                <span><%= menu.getItemName() %> &times; <%= item.getQuantity() %></span>
                <span>&#8377; <%= item.getTotalPrice() %></span>
              </div>
            <%
                  }
              }
            %>
          </div>

          <div class="bill-row">
            <span>Subtotal</span>
            <span>&#8377; <%= subtotal %></span>
          </div>
          
          <div class="bill-row">
            <span>GST & Restaurant Charges</span>
            <span>&#8377; <%= String.format("%.2f", gst) %></span>
          </div>

          <div class="bill-row">
            <span>Delivery Charges</span>
            <span>&#8377; <%= deliveryFee %></span>
          </div>

          <div class="bill-row">
            <span>Platform Fee</span>
            <span>&#8377; <%= platformFee %></span>
          </div>

          <% if (discount > 0) { %>
            <div class="bill-row" style="color: var(--green); font-weight:800;">
              <span>Discount</span>
              <span>- &#8377; <%= discount %></span>
            </div>
          <% } %>

          <div class="bill-row total">
            <span>Grand Total</span>
            <span>&#8377; <%= String.format("%.2f", grandTotal) %></span>
          </div>

          <button type="submit" class="btn-place-order">Place Order</button>
        </div>

      </div>
    </form>
  </div>

  <footer class="footer">
    <p>&copy; 2026 TastyBowl Food Platforms Inc. All rights reserved.</p>
  </footer>

  <script>
    // Add visual selection highlight to payment methods
    const paymentOptions = document.querySelectorAll('.payment-option');
    paymentOptions.forEach(option => {
      option.addEventListener('click', () => {
        paymentOptions.forEach(opt => opt.classList.remove('active'));
        option.classList.add('active');
      });
    });
  </script>
</body>
</html>
