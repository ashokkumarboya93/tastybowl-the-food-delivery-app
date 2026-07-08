<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.food.model.User" %>
<%
  HttpSession sess = request.getSession();
  User user = (User) sess.getAttribute("loggedInUser");
  if (user == null) {
      response.sendRedirect("login.jsp?errorMessage=Please log in to view profile.");
      return;
  }
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>My Profile - TastyBowl</title>
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

    .profile-layout {
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
      backdrop-filter: blur(10px);
    }

    .card h2 {
      margin: 0 0 24px;
      font-size: 22px;
      font-weight: 900;
      border-bottom: 2px solid var(--line);
      padding-bottom: 12px;
    }

    .info-grid {
      display: grid;
      grid-template-columns: 1fr 2fr;
      gap: 16px 20px;
    }

    .info-label {
      font-weight: 800;
      color: var(--muted);
      font-size: 14px;
    }

    .info-value {
      font-weight: 700;
      font-size: 15px;
      color: var(--ink);
    }

    .btn-edit {
      display: inline-flex;
      align-items: center;
      justify-content: center;
      height: 48px;
      padding: 0 24px;
      border-radius: 24px;
      color: #fff;
      background: var(--purple);
      font-weight: 900;
      box-shadow: 0 8px 16px rgba(111, 45, 226, 0.2);
      margin-top: 24px;
      cursor: pointer;
    }

    .btn-edit:hover {
      transform: translateY(-2px);
    }

    /* Change Password form */
    .form-group {
      margin-bottom: 20px;
    }

    label {
      display: block;
      font-size: 14px;
      font-weight: 800;
      margin-bottom: 8px;
      color: var(--ink);
    }

    input[type="password"] {
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

    input[type="password"]:focus {
      border-color: var(--purple);
      box-shadow: 0 0 0 4px rgba(111, 45, 226, 0.15);
    }

    .btn-submit {
      width: 100%;
      height: 48px;
      border: 0;
      border-radius: 24px;
      color: #fff;
      background: linear-gradient(135deg, #8844f5, #6422d8);
      box-shadow: 0 10px 18px rgba(111, 45, 226, 0.24);
      font-size: 15px;
      font-weight: 900;
      cursor: pointer;
      transition: transform 150ms ease;
    }

    .btn-submit:hover {
      transform: translateY(-2px);
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
      <a href="callRestaurantServlet" class="brand" style="text-decoration:none; color:inherit;">
        <div class="brand-mark"></div>
        TastyBowl
      </a>
      <ul class="nav-links">
        <li><a href="callRestaurantServlet">Home</a></li>
        <li><a href="orders">My Orders</a></li>
        <li><a href="profile" class="active">Profile</a></li>
      </ul>
      <div class="nav-actions">
        <a href="logout" class="btn-secondary" style="height: 38px; border-radius: 19px; padding: 0 14px;">Logout</a>
      </div>
    </div>
  </div>

  <div class="container">
    <h1>My <span>Profile</span></h1>

    <% if (request.getAttribute("errorMessage") != null) { %>
      <div class="alert alert-danger">
        <%= request.getAttribute("errorMessage") %>
      </div>
    <% } %>

    <% if (request.getParameter("successMessage") != null) { %>
      <div class="alert alert-success">
        <%= request.getParameter("successMessage") %>
      </div>
    <% } %>

    <div class="profile-layout">
      
      <!-- Left Column: User details -->
      <div>
        <div class="card">
          <h2>Personal Details</h2>
          <div class="info-grid">
            <div class="info-label">Username</div>
            <div class="info-value"><%= user.getUsername() %></div>

            <div class="info-label">Email Address</div>
            <div class="info-value"><%= user.getEmail() %></div>

            <div class="info-label">Phone Number</div>
            <div class="info-value"><%= user.getPhone() != null ? user.getPhone() : "Not provided" %></div>

            <div class="info-label">Role</div>
            <div class="info-value" style="text-transform: capitalize;"><%= user.getRole() %></div>

            <div class="info-label">Account Created</div>
            <div class="info-value"><%= user.getCreateDate() %></div>
          </div>
        </div>

        <div class="card">
          <h2>Delivery Information</h2>
          <div class="info-grid">
            <div class="info-label">Street Address</div>
            <div class="info-value"><%= user.getAddress() != null ? user.getAddress() : "Not provided" %></div>

            <div class="info-label">City</div>
            <div class="info-value"><%= user.getCity() != null ? user.getCity() : "Not provided" %></div>

            <div class="info-label">State</div>
            <div class="info-value"><%= user.getState() != null ? user.getState() : "Not provided" %></div>

            <div class="info-label">Pincode</div>
            <div class="info-value"><%= user.getPincode() != null ? user.getPincode() : "Not provided" %></div>
          </div>
          
          <a href="profile?action=edit" class="btn-edit">Edit Profile / Address</a>
          
          <% if ("admin".equalsIgnoreCase(user.getRole())) { %>
            <a href="admin-dashboard.jsp" class="btn-edit" style="background: var(--orange); box-shadow: 0 8px 16px rgba(255, 179, 33, 0.2); margin-left: 15px;">Admin Dashboard</a>
          <% } %>
        </div>
      </div>

      <!-- Right Column: Change Password -->
      <div class="card">
        <h2>Change Password</h2>
        <form action="profile?action=changePassword" method="POST">
          <div class="form-group">
            <label for="oldPassword">Current Password</label>
            <input type="password" id="oldPassword" name="oldPassword" required>
          </div>

          <div class="form-group">
            <label for="newPassword">New Password</label>
            <input type="password" id="newPassword" name="newPassword" required>
          </div>

          <div class="form-group">
            <label for="confirmPassword">Confirm New Password</label>
            <input type="password" id="confirmPassword" name="confirmPassword" required>
          </div>

          <button type="submit" class="btn-submit">Update Password</button>
        </form>
      </div>

    </div>
  </div>

  <footer class="footer">
    <p>&copy; 2026 TastyBowl Food Platforms Inc. All rights reserved.</p>
  </footer>
</body>
</html>
