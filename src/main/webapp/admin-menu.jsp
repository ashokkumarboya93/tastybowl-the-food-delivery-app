<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, com.food.model.Menu, com.food.model.Restaurant, com.food.model.User" %>
<%
  HttpSession sess = request.getSession();
  User user = (User) sess.getAttribute("loggedInUser");
  if (user == null || !"admin".equalsIgnoreCase(user.getRole())) {
      response.sendRedirect("login.jsp?errorMessage=Access Denied. Admins only.");
      return;
  }

  @SuppressWarnings("unchecked")
  List<Menu> list = (List<Menu>) request.getAttribute("adminMenuList");
  @SuppressWarnings("unchecked")
  List<Restaurant> restaurants = (List<Restaurant>) request.getAttribute("allRestaurants");
  Integer currentRestaurantId = (Integer) request.getAttribute("currentRestaurantId");
  
  Menu editMenu = (Menu) request.getAttribute("menuToEdit");
  boolean isEditMode = (editMenu != null);
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Manage Menus - TastyBowl Admin</title>
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

    /* Selector */
    .selector-box {
      margin-bottom: 24px;
      display: flex;
      align-items: center;
      gap: 15px;
    }

    .selector-box label {
      margin-bottom: 0;
      font-size: 16px;
      font-weight: 900;
    }

    select {
      height: 44px;
      padding: 0 14px;
      border: 1px solid var(--line);
      border-radius: 10px;
      outline: none;
      font-weight: 800;
      color: var(--ink);
      background: #fff;
      cursor: pointer;
    }

    /* Layout */
    .admin-layout {
      display: grid;
      grid-template-columns: 1.6fr 1fr;
      gap: 30px;
      align-items: start;
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

    /* Forms */
    .form-group {
      margin-bottom: 16px;
    }

    label {
      display: block;
      font-size: 14px;
      font-weight: 800;
      margin-bottom: 6px;
      color: var(--ink);
    }

    input[type="text"], input[type="number"], select.form-select, textarea {
      width: 100%;
      height: 44px;
      padding: 10px 14px;
      border: 1px solid var(--line);
      border-radius: 10px;
      outline: none;
      font-size: 14px;
      font-weight: 600;
      background: #fff;
      transition: border-color 150ms ease;
    }

    textarea {
      height: 70px;
      resize: none;
    }

    input[type="text"]:focus, input[type="number"]:focus, textarea:focus {
      border-color: var(--purple);
    }

    .checkbox-container {
      display: flex;
      align-items: center;
      gap: 8px;
      font-weight: 700;
      font-size: 14px;
      cursor: pointer;
    }

    .checkbox-container input {
      width: 18px;
      height: 18px;
      accent-color: var(--purple);
    }

    /* Buttons */
    .btn {
      display: inline-flex;
      align-items: center;
      justify-content: center;
      height: 44px;
      padding: 0 20px;
      border-radius: 22px;
      font-weight: 900;
      font-size: 14px;
      cursor: pointer;
      border: 0;
    }

    .btn-primary {
      color: #fff;
      background: linear-gradient(135deg, #8844f5, #6422d8);
      box-shadow: 0 8px 18px rgba(111, 45, 226, 0.2);
    }

    .btn-primary:hover {
      transform: translateY(-2px);
    }

    /* Table */
    .admin-table {
      width: 100%;
      border-collapse: collapse;
    }

    .admin-table th, .admin-table td {
      padding: 14px 10px;
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

    .admin-table img {
      width: 60px;
      height: 45px;
      border-radius: 6px;
      object-fit: cover;
    }

    /* Action Links */
    .action-links {
      display: flex;
      gap: 12px;
      font-size: 13px;
    }

    .action-edit {
      color: var(--purple);
      font-weight: 800;
    }

    .action-edit:hover {
      text-decoration: underline;
    }

    .action-delete {
      color: #b83232;
      font-weight: 800;
    }

    .action-delete:hover {
      text-decoration: underline;
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

    .alert-success {
      color: #155724;
      background-color: #d4edda;
      border: 1px solid #c3e6cb;
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
      <a href="admin-dashboard.jsp" class="brand" style="text-decoration:none; color:inherit;">
        <div class="brand-mark"></div>
        TastyBowl Admin
      </a>
      <ul class="nav-links">
        <% if ("admin".equalsIgnoreCase(user.getRole())) { %>
          <li><a href="<%= request.getContextPath() %>/admin-dashboard.jsp">Dashboard</a></li>
          <li><a href="<%= request.getContextPath() %>/admin/users">Users CRUD</a></li>
          <li><a href="<%= request.getContextPath() %>/admin/restaurants">Restaurants CRUD</a></li>
          <li><a href="<%= request.getContextPath() %>/admin/menu" class="active">Menu CRUD</a></li>
          <li><a href="<%= request.getContextPath() %>/admin/orders">Orders</a></li>
        <% } else if ("restaurant_admin".equalsIgnoreCase(user.getRole())) { %>
          <li><a href="<%= request.getContextPath() %>/admin/menu" class="active">Menu CRUD</a></li>
        <% } %>
      </ul>
      <div class="nav-actions">
        <span class="profile">
          <div class="avatar"><%= user.getUsername().substring(0, 1).toUpperCase() %></div>
          <%= user.getUsername() %>
        </span>
      </div>
    </div>
  </div>

  <div class="container">
    <h1>Manage <span>Menu Items</span></h1>

    <% if (request.getParameter("errorMessage") != null) { %>
      <div class="alert alert-danger">
        <%= request.getParameter("errorMessage") %>
      </div>
    <% } %>

    <% if (request.getParameter("successMessage") != null) { %>
      <div class="alert alert-success">
        <%= request.getParameter("successMessage") %>
      </div>
    <% } %>

    <!-- Selector Box -->
    <div class="selector-box">
      <label for="restaurantSelector">Select Restaurant:</label>
      <select id="restaurantSelector" onchange="changeRestaurant(this.value)">
        <%
          if (restaurants != null) {
              for (Restaurant r : restaurants) {
        %>
          <option value="<%= r.getRestaurantId() %>" <%= (currentRestaurantId != null && currentRestaurantId == r.getRestaurantId()) ? "selected" : "" %>><%= r.getName() %></option>
        <%
              }
          }
        %>
      </select>
    </div>

    <div class="admin-layout">
      
      <!-- Left Column: Table of Menu Items -->
      <div class="card">
        <h2>Menu List</h2>
        <table class="admin-table">
          <thead>
            <tr>
              <th>Image</th>
              <th>Name</th>
              <th>Category</th>
              <th>Price</th>
              <th>Rating</th>
              <th>Available</th>
              <th>Actions</th>
            </tr>
          </thead>
          <tbody>
            <%
              if (list == null || list.isEmpty()) {
            %>
              <tr>
                <td colspan="7" style="text-align: center; color: var(--muted);">No menu items found for this restaurant. Add one!</td>
              </tr>
            <%
              } else {
                  for (Menu m : list) {
            %>
              <tr>
                <td><img src="<%= m.getImagePath() %>" alt="<%= m.getItemName() %>"></td>
                <td><%= m.getItemName() %></td>
                <td><%= m.getCategory() %></td>
                <td>&#8377; <%= m.getPrice() %></td>
                <td>★ <%= m.getRating() %></td>
                <td style="color: <%= m.isAvailable() ? "var(--green)" : "#b83232" %>"><%= m.isAvailable() ? "Yes" : "No" %></td>
                <td>
                  <div class="action-links">
                    <a href="menu?action=edit&id=<%= m.getMenuId() %>" class="action-edit">Edit</a>
                    <a href="menu?action=delete&id=<%= m.getMenuId() %>" class="action-delete" onclick="return confirm('Are you sure you want to delete this menu item?');">Delete</a>
                  </div>
                </td>
              </tr>
            <%
                  }
              }
            %>
          </tbody>
        </table>
      </div>

      <!-- Right Column: Add/Edit Form -->
      <div class="card">
        <h2><%= isEditMode ? "Edit Menu Item" : "Add Menu Item" %></h2>
        <form action="menu?action=<%= isEditMode ? "update" : "add" %>" method="POST">
          <% if (isEditMode) { %>
            <input type="hidden" name="menuId" value="<%= editMenu.getMenuId() %>">
          <% } %>

          <div class="form-group">
            <label for="restaurantId">Restaurant</label>
            <select id="restaurantId" name="restaurantId" class="form-select" required>
              <%
                if (restaurants != null) {
                    for (Restaurant r : restaurants) {
              %>
                <option value="<%= r.getRestaurantId() %>" <%= ((isEditMode && editMenu.getRestaurantId() == r.getRestaurantId()) || (!isEditMode && currentRestaurantId != null && currentRestaurantId == r.getRestaurantId())) ? "selected" : "" %>><%= r.getName() %></option>
              <%
                    }
                }
              %>
            </select>
          </div>

          <div class="form-group">
            <label for="itemName">Item Name</label>
            <input type="text" id="itemName" name="itemName" value="<%= isEditMode ? editMenu.getItemName() : "" %>" required>
          </div>

          <div class="form-group">
            <label for="category">Category</label>
            <input type="text" id="category" name="category" value="<%= isEditMode ? editMenu.getCategory() : "" %>" placeholder="e.g. Starters, Main Course, Desserts" required>
          </div>

          <div class="form-group">
            <label for="price">Price (&#8377;)</label>
            <input type="number" step="0.01" id="price" name="price" value="<%= isEditMode ? editMenu.getPrice() : "" %>" required>
          </div>

          <div class="form-group">
            <label for="description">Description</label>
            <textarea id="description" name="description"><%= isEditMode ? editMenu.getDescription() : "" %></textarea>
          </div>

          <div class="form-group">
            <label for="imagePath">Image URL</label>
            <input type="text" id="imagePath" name="imagePath" value="<%= isEditMode ? editMenu.getImagePath() : "" %>" required>
          </div>

          <div class="form-group">
            <label class="checkbox-container">
              <input type="checkbox" name="isAvailable" value="true" <%= (!isEditMode || editMenu.isAvailable()) ? "checked" : "" %>>
              Item is Available
            </label>
          </div>

          <div style="display:flex; justify-content: flex-end; gap:10px; margin-top:20px;">
            <% if (isEditMode) { %>
              <a href="menu?restaurantId=<%= editMenu.getRestaurantId() %>" class="btn btn-secondary" style="height:44px; display:inline-flex; align-items:center;">Cancel</a>
            <% } %>
            <button type="submit" class="btn btn-primary"><%= isEditMode ? "Save Changes" : "Add Item" %></button>
          </div>
        </form>
      </div>

    </div>
  </div>

  <footer class="footer">
    <p>&copy; 2026 TastyBowl Food Platforms Inc. All rights reserved.</p>
  </footer>

  <script>
    function changeRestaurant(id) {
      window.location.href = 'menu?restaurantId=' + id;
    }
  </script>
</body>
</html>
