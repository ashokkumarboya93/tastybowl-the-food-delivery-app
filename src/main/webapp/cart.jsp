<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.Map, com.food.model.CartItem, com.food.model.Menu, com.food.daoimp.MenuDaoImpl, com.food.model.User" %>
<%
  HttpSession sess = request.getSession();
  User user = (User) sess.getAttribute("loggedInUser");
  @SuppressWarnings("unchecked")
  Map<Integer, CartItem> cart = (Map<Integer, CartItem>) sess.getAttribute("cart");
  
  double subtotal = 0;
  int totalQuantity = 0;
  MenuDaoImpl menuDao = new MenuDaoImpl();
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Shopping Cart - TastyBowl</title>
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

    button, input {
      font: inherit;
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

    .brand, .nav-links, .nav-actions, .profile, .cart-icon {
      display: flex;
      align-items: center;
    }

    .brand {
      gap: 10px;
      font-size: 25px;
      font-weight: 900;
      white-space: nowrap;
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

    .cart-icon {
      position: relative;
      justify-content: center;
      width: 44px;
      height: 44px;
      border-radius: 15px;
      background: rgba(255, 255, 255, 0.13);
      font-size: 21px;
    }

    .cart-icon strong {
      position: absolute;
      top: -5px;
      right: -2px;
      display: grid;
      place-items: center;
      width: 18px;
      height: 18px;
      border-radius: 50%;
      color: #fff;
      background: var(--orange);
      font-size: 10px;
      box-shadow: 0 4px 10px rgba(255, 186, 45, 0.45);
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

    /* Main Container */
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

    .cart-layout {
      display: grid;
      grid-template-columns: 1.6fr 1fr;
      gap: 30px;
      align-items: start;
    }

    /* Left Side: Cart Items */
    .cart-items {
      border: 1px solid var(--line);
      border-radius: 22px;
      background: var(--card);
      box-shadow: var(--shadow);
      overflow: hidden;
    }

    .cart-header {
      display: grid;
      grid-template-columns: 3fr 1fr 1.2fr 1fr;
      padding: 20px 24px;
      background: #f7f3ff;
      border-bottom: 1px solid var(--line);
      font-weight: 900;
      font-size: 14px;
      color: var(--muted);
    }

    .cart-item-row {
      display: grid;
      grid-template-columns: 3fr 1fr 1.2fr 1fr;
      align-items: center;
      padding: 24px;
      border-bottom: 1px solid var(--line);
      transition: background 150ms ease;
    }

    .cart-item-row:hover {
      background: #faf8ff;
    }

    .item-info {
      display: flex;
      align-items: center;
      gap: 16px;
    }

    .item-info img {
      width: 80px;
      height: 80px;
      border-radius: 12px;
      object-fit: cover;
      background: #eee;
    }

    .item-details h3 {
      margin: 0 0 4px;
      font-size: 18px;
      font-weight: 900;
    }

    .item-details p {
      margin: 0;
      font-size: 13px;
      color: var(--muted);
      font-weight: 700;
    }

    .item-price {
      font-size: 16px;
      font-weight: 800;
    }

    .item-qty {
      display: flex;
      align-items: center;
      gap: 8px;
    }

    .qty-btn {
      width: 28px;
      height: 28px;
      border: 1px solid var(--line);
      border-radius: 8px;
      background: #fff;
      color: var(--purple);
      font-weight: 900;
      cursor: pointer;
      display: grid;
      place-items: center;
    }

    .qty-btn:hover {
      background: var(--purple);
      color: #fff;
      border-color: var(--purple);
    }

    .qty-val {
      font-weight: 900;
      width: 24px;
      text-align: center;
    }

    .item-total {
      display: flex;
      align-items: center;
      justify-content: space-between;
      font-size: 16px;
      font-weight: 900;
      color: var(--purple);
    }

    .delete-btn {
      border: 0;
      background: transparent;
      color: #b83232;
      font-size: 18px;
      cursor: pointer;
      padding: 0;
    }

    .delete-btn:hover {
      color: red;
      transform: scale(1.1);
    }

    .cart-actions {
      display: flex;
      justify-content: space-between;
      padding: 20px 24px;
      background: #fdfdfd;
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

    /* Right Side: Summary Card */
    .summary-card {
      border: 1px solid var(--line);
      border-radius: 22px;
      background: var(--card);
      box-shadow: var(--shadow);
      padding: 30px;
      backdrop-filter: blur(10px);
    }

    .summary-card h2 {
      margin: 0 0 24px;
      font-size: 24px;
      font-weight: 900;
    }

    .summary-row {
      display: flex;
      justify-content: space-between;
      margin-bottom: 16px;
      font-size: 15px;
      font-weight: 700;
      color: var(--muted);
    }

    .summary-row.total {
      margin-top: 20px;
      padding-top: 20px;
      border-top: 1px solid var(--line);
      font-size: 20px;
      font-weight: 900;
      color: var(--ink);
    }

    .summary-row.total span {
      color: var(--purple);
    }

    /* Coupon section */
    .coupon-section {
      margin: 20px 0;
      padding: 16px 0;
      border-top: 1px solid var(--line);
      border-bottom: 1px solid var(--line);
    }

    .coupon-form {
      display: flex;
      gap: 10px;
    }

    .coupon-form input {
      flex: 1;
      height: 42px;
      border: 1px solid var(--line);
      border-radius: 10px;
      padding: 0 12px;
      outline: none;
      font-weight: 700;
      font-size: 13px;
    }

    .coupon-form input:focus {
      border-color: var(--purple);
    }

    .btn-apply {
      height: 42px;
      padding: 0 16px;
      border: 0;
      border-radius: 10px;
      background: var(--purple);
      color: #fff;
      font-weight: 900;
      font-size: 13px;
      cursor: pointer;
    }

    .coupon-msg {
      margin-top: 8px;
      font-size: 12px;
      font-weight: 800;
      color: var(--green);
    }

    .btn-checkout {
      display: flex;
      align-items: center;
      justify-content: center;
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
      transition: transform 150ms ease;
    }

    .btn-checkout:hover {
      transform: translateY(-2px);
      box-shadow: 0 14px 22px rgba(111, 45, 226, 0.32);
    }

    /* Alerts */
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

    .alert-info {
      color: #3b245f;
      background-color: #f2ebff;
      border: 1px solid #e3d3ff;
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
  <jsp:include page="navbar.jsp" />

  <div class="container">
    <% if (session.getAttribute("cartMessage") != null) { %>
      <div class="alert alert-info">
        <%= session.getAttribute("cartMessage") %>
        <% session.removeAttribute("cartMessage"); %>
      </div>
    <% } %>
    
    <% if (request.getParameter("errorMessage") != null) { %>
      <div class="alert alert-danger">
        <%= request.getParameter("errorMessage") %>
      </div>
    <% } %>

    <%
      if (cart == null || cart.isEmpty()) {
    %>
      <div class="empty-state">
        <span>🛒</span>
        <h2>Your Cart is <span>Empty</span></h2>
        <p>Looks like you haven't added anything to your cart yet. Let's find some delicious food!</p>
        <a href="callRestaurantServlet" class="btn-primary">Browse Restaurants</a>
      </div>
    <%
      } else {
        // Calculate totals
        for (CartItem item : cart.values()) {
            Menu menu = menuDao.getMenu(item.getMenuId());
            if (menu != null) {
                subtotal += item.getQuantity() * menu.getPrice();
                totalQuantity += item.getQuantity();
            }
        }
        
        double gst = subtotal * 0.05;
        double deliveryFee = 40.0;
        double platformFee = 5.0;
        double discount = 0.0;
        
        String appliedCoupon = (String) session.getAttribute("appliedCoupon");
        if ("WELCOME50".equalsIgnoreCase(appliedCoupon)) {
            discount = 50.0;
        }
        
        double grandTotal = subtotal + gst + deliveryFee + platformFee - discount;
        if (grandTotal < 0) grandTotal = 0;
    %>
      <h1>Your <span>Cart Summary</span></h1>
      <div class="cart-layout">
        
        <!-- Left Side: List of Items -->
        <div class="cart-items">
          <div class="cart-header">
            <div>Item Details</div>
            <div>Price</div>
            <div>Quantity</div>
            <div>Total</div>
          </div>
          
          <%
            for (CartItem item : cart.values()) {
                Menu menu = menuDao.getMenu(item.getMenuId());
                if (menu != null) {
          %>
            <div class="cart-item-row">
              <div class="item-info">
                <img src="<%= menu.getImagePath() %>" alt="<%= menu.getItemName() %>">
                <div class="item-details">
                  <h3><%= menu.getItemName() %></h3>
                  <p><%= menu.getCategory() %></p>
                </div>
              </div>
              
              <div class="item-price">&#8377; <%= menu.getPrice() %></div>
              
              <div class="item-qty">
                <form action="cart" method="POST" style="display:inline;">
                  <input type="hidden" name="action" value="update">
                  <input type="hidden" name="menuId" value="<%= menu.getMenuId() %>">
                  <input type="hidden" name="quantity" value="<%= item.getQuantity() - 1 %>">
                  <button type="submit" class="qty-btn">-</button>
                </form>
                
                <span class="qty-val"><%= item.getQuantity() %></span>
                
                <form action="cart" method="POST" style="display:inline;">
                  <input type="hidden" name="action" value="update">
                  <input type="hidden" name="menuId" value="<%= menu.getMenuId() %>">
                  <input type="hidden" name="quantity" value="<%= item.getQuantity() + 1 %>">
                  <button type="submit" class="qty-btn">+</button>
                </form>
              </div>
              
              <div class="item-total">
                &#8377; <%= item.getTotalPrice() %>
                <form action="cart" method="POST" style="display:inline;">
                  <input type="hidden" name="action" value="delete">
                  <input type="hidden" name="menuId" value="<%= menu.getMenuId() %>">
                  <button type="submit" class="delete-btn" title="Remove Item">&times;</button>
                </form>
              </div>
            </div>
          <%
                }
            }
          %>
          
          <div class="cart-actions">
            <a href="callRestaurantServlet" class="btn-secondary">← Add More Items</a>
            <form action="cart" method="POST">
              <input type="hidden" name="action" value="clear">
              <button type="submit" class="btn-secondary" style="color: #b83232;">Clear Cart</button>
            </form>
          </div>
        </div>

        <!-- Right Side: Bill Details -->
        <div class="summary-card">
          <h2>Bill Details</h2>
          
          <div class="summary-row">
            <span>Item Subtotal (<%= totalQuantity %> items)</span>
            <span>&#8377; <%= subtotal %></span>
          </div>
          
          <div class="summary-row">
            <span>GST & Restaurant Charges (5%)</span>
            <span>&#8377; <%= String.format("%.2f", gst) %></span>
          </div>
          
          <div class="summary-row">
            <span>Delivery Partner Fee</span>
            <span>&#8377; <%= deliveryFee %></span>
          </div>

          <div class="summary-row">
            <span>Platform Fee</span>
            <span>&#8377; <%= platformFee %></span>
          </div>

          <% if (discount > 0) { %>
            <div class="summary-row" style="color: var(--green); font-weight: 800;">
              <span>Coupon Discount (WELCOME50)</span>
              <span>- &#8377; <%= discount %></span>
            </div>
          <% } %>

          <!-- Apply Coupon Code -->
          <div class="coupon-section">
            <label style="display:block; margin-bottom:8px; font-size:12px; font-weight:900;">APPLY COUPON</label>
            <form action="" method="GET" class="coupon-form" onsubmit="event.preventDefault(); applyCoupon();">
              <input type="text" id="couponCode" placeholder="Enter coupon (e.g. WELCOME50)" value="<%= appliedCoupon != null ? appliedCoupon : "" %>">
              <button type="submit" class="btn-apply">Apply</button>
            </form>
            <div id="couponMsg" class="coupon-msg">
              <% if ("WELCOME50".equalsIgnoreCase(appliedCoupon)) { %>
                Coupon WELCOME50 applied! Saved ₹50.
              <% } %>
            </div>
          </div>

          <div class="summary-row total">
            <span>Grand Total</span>
            <span>&#8377; <span><%= String.format("%.2f", grandTotal) %></span></span>
          </div>
          
          <a href="checkout" class="btn-checkout" style="margin-top:24px; text-decoration:none;">Proceed to Checkout</a>
        </div>
      </div>
    <%
      }
    %>
  </div>

  <footer class="footer">
    <p>&copy; 2026 TastyBowl Food Platforms Inc. All rights reserved.</p>
  </footer>

  <script>
    function applyCoupon() {
      const code = document.getElementById('couponCode').value.trim().toUpperCase();
      const msg = document.getElementById('couponMsg');
      
      if (code === 'WELCOME50') {
        // Fetch to apply coupon to session
        // Simple way in JSP is to redirect or set via query param, since we don't want complex ajax
        // We will just redirect to cart page with coupon parameter
        window.location.href = 'cart.jsp?coupon=' + code;
      } else {
        msg.style.color = '#b83232';
        msg.textContent = 'Invalid Coupon Code. Try WELCOME50';
      }
    }
  </script>

  <%
    // Process coupon parameter from redirect
    String couponParam = request.getParameter("coupon");
    if (couponParam != null) {
        if ("WELCOME50".equalsIgnoreCase(couponParam)) {
            session.setAttribute("appliedCoupon", "WELCOME50");
            response.sendRedirect("cart.jsp");
        }
    }
  %>
</body>
</html>
