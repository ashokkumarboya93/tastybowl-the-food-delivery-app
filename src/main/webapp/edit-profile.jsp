<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.food.model.User" %>
<%
  HttpSession sess = request.getSession();
  User user = (User) sess.getAttribute("loggedInUser");
  if (user == null) {
      response.sendRedirect("login.jsp?errorMessage=Please log in to edit profile.");
      return;
  }
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Edit Profile - TastyBowl</title>
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
      width: min(600px, calc(100% - 40px));
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

    .card {
      border: 1px solid var(--line);
      border-radius: 22px;
      background: var(--card);
      box-shadow: var(--shadow);
      padding: 35px;
      backdrop-filter: blur(10px);
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

    .btn-actions {
      display: flex;
      justify-content: flex-end;
      gap: 15px;
      margin-top: 30px;
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

    .btn-secondary {
      color: var(--ink);
      background: #fff;
      border: 1px solid var(--line);
    }

    .btn-secondary:hover {
      background: #faf8ff;
      border-color: var(--purple);
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
  <div class="topbar">
    <div class="nav">
      <a href="callRestaurantServlet" class="brand" style="text-decoration:none; color:inherit;">
        <div class="brand-mark"></div>
        TastyBowl
      </a>
    </div>
  </div>

  <div class="container">
    <h1>Edit <span>Profile</span></h1>

    <% if (request.getAttribute("errorMessage") != null) { %>
      <div class="alert alert-danger">
        <%= request.getAttribute("errorMessage") %>
      </div>
    <% } %>

    <div class="card">
      <form action="profile?action=updateProfile" method="POST">
        <div class="form-group">
          <label for="username">Username</label>
          <input type="text" id="username" name="username" value="<%= user.getUsername() %>" required>
        </div>

        <div class="form-group">
          <label for="phone">Phone Number</label>
          <input type="text" id="phone" name="phone" value="<%= user.getPhone() != null ? user.getPhone() : "" %>">
        </div>

        <div class="form-group">
          <label for="address">Street Address</label>
          <textarea id="address" name="address" placeholder="Flat No, Building Name, Street Address"><%= user.getAddress() != null ? user.getAddress() : "" %></textarea>
        </div>

        <div class="form-row">
          <div class="form-group">
            <label for="city">City</label>
            <input type="text" id="city" name="city" value="<%= user.getCity() != null ? user.getCity() : "" %>">
          </div>
          <div class="form-group">
            <label for="state">State</label>
            <input type="text" id="state" name="state" value="<%= user.getState() != null ? user.getState() : "" %>">
          </div>
        </div>

        <div class="form-group">
          <label for="pincode">Pincode</label>
          <input type="text" id="pincode" name="pincode" value="<%= user.getPincode() != null ? user.getPincode() : "" %>">
        </div>

        <div class="btn-actions">
          <a href="profile" class="btn btn-secondary">Cancel</a>
          <button type="submit" class="btn btn-primary">Save Changes</button>
        </div>
      </form>
    </div>
  </div>

  <footer class="footer">
    <p>&copy; 2026 TastyBowl Food Platforms Inc. All rights reserved.</p>
  </footer>
</body>
</html>
