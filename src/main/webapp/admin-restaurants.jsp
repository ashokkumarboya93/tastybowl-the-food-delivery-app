<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, com.food.model.Restaurant, com.food.model.User" %>
<%
  HttpSession sess = request.getSession();
  User user = (User) sess.getAttribute("loggedInUser");
  if (user == null || !"admin".equalsIgnoreCase(user.getRole())) {
      response.sendRedirect("login.jsp?errorMessage=Access Denied. Admins only.");
      return;
  }

  @SuppressWarnings("unchecked")
  List<Restaurant> list = (List<Restaurant>) request.getAttribute("adminRestaurantList");
  Restaurant editRestaurant = (Restaurant) request.getAttribute("restaurantToEdit");
  boolean isEditMode = (editRestaurant != null);
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Manage Restaurants - TastyBowl Admin</title>
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

    input[type="text"], input[type="number"], textarea {
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
          <li><a href="admin-dashboard.jsp">Dashboard</a></li>
          <li><a href="users">Users CRUD</a></li>
          <li><a href="restaurants" class="active">Restaurants CRUD</a></li>
          <li><a href="menu">Menu CRUD</a></li>
          <li><a href="orders">Orders</a></li>
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
    <h1>Manage <span>Restaurants</span></h1>

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

    <div class="admin-layout">
      
      <!-- Left Column: Table of Restaurants -->
      <div class="card">
        <h2>Restaurant List</h2>
        <table class="admin-table">
          <thead>
            <tr>
              <th>Image</th>
              <th>Name</th>
              <th>Cuisine</th>
              <th>Time</th>
              <th>Rating</th>
              <th>Status</th>
              <th>Actions</th>
            </tr>
          </thead>
          <tbody>
            <%
              if (list == null || list.isEmpty()) {
            %>
              <tr>
                <td colspan="7" style="text-align: center; color: var(--muted);">No restaurants registered yet.</td>
              </tr>
            <%
              } else {
                  for (Restaurant r : list) {
            %>
              <tr>
                <td><img src="<%= r.getImagePath() %>" alt="<%= r.getName() %>"></td>
                <td><%= r.getName() %></td>
                <td><%= r.getCuisineType() %></td>
                <td><%= r.getDeliveryTime() %> mins</td>
                <td>★ <%= r.getRating() %></td>
                <td style="color: <%= r.isActive() ? "var(--green)" : "#b83232" %>"><%= r.isActive() ? "Active" : "Inactive" %></td>
                <td>
                  <div class="action-links">
                    <a href="restaurants?action=edit&id=<%= r.getRestaurantId() %>" class="action-edit">Edit</a>
                    <a href="restaurants?action=delete&id=<%= r.getRestaurantId() %>" class="action-delete" onclick="return confirm('Are you sure you want to delete this restaurant?');">Delete</a>
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
        <h2><%= isEditMode ? "Edit Restaurant" : "Add New Restaurant" %></h2>
        <form action="restaurants?action=<%= isEditMode ? "update" : "add" %>" method="POST">
          <% if (isEditMode) { %>
            <input type="hidden" name="restaurantId" value="<%= editRestaurant.getRestaurantId() %>">
          <% } %>

          <div class="form-group">
            <label for="name">Restaurant Name</label>
            <input type="text" id="name" name="name" value="<%= isEditMode ? editRestaurant.getName() : "" %>" required>
          </div>

          <div class="form-group">
            <label for="cuisineType">Cuisine Type</label>
            <input type="text" id="cuisineType" name="cuisineType" value="<%= isEditMode ? editRestaurant.getCuisineType() : "" %>" placeholder="e.g. North Indian, Italian" required>
          </div>

          <div class="form-group">
            <label for="deliveryTime">Delivery Time (mins)</label>
            <input type="number" id="deliveryTime" name="deliveryTime" value="<%= isEditMode ? editRestaurant.getDeliveryTime() : "30" %>" required>
          </div>

          <div class="form-group">
            <label for="address">Address</label>
            <textarea id="address" name="address" required><%= isEditMode ? editRestaurant.getAddress() : "" %></textarea>
          </div>

          <div class="form-group">
            <label for="imagePath">Image URL</label>
            <input type="text" id="imagePath" name="imagePath" value="<%= isEditMode ? editRestaurant.getImagePath() : "" %>" required>
          </div>

          <div class="form-group">
            <label class="checkbox-container">
              <input type="checkbox" name="isActive" value="true" <%= (!isEditMode || editRestaurant.isActive()) ? "checked" : "" %>>
              Restaurant is Active
            </label>
          </div>

          <div style="display:flex; justify-content: flex-end; gap:10px; margin-top:20px;">
            <% if (isEditMode) { %>
              <a href="restaurants" class="btn btn-secondary" style="height:44px; display:inline-flex; align-items:center;">Cancel</a>
            <% } %>
            <button type="submit" class="btn btn-primary"><%= isEditMode ? "Save Changes" : "Add Restaurant" %></button>
          </div>
        </form>
      </div>

    </div>
  </div>

  <footer class="footer">
    <p>&copy; 2026 TastyBowl Food Platforms Inc. All rights reserved.</p>
  </footer>
</body>
</html>
