<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="com.food.model.User" %>
<%
  HttpSession sess = request.getSession();
  User user = (User) sess.getAttribute("loggedInUser");
  if (user == null || !"admin".equalsIgnoreCase(user.getRole())) {
      response.sendRedirect(request.getContextPath() + "/login.jsp?errorMessage=Access Denied.");
      return;
  }
  
  List<User> userList = (List<User>) request.getAttribute("adminUserList");
  User userToEdit = (User) request.getAttribute("userToEdit");
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Admin - Manage Users</title>
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
    
    .dashboard-layout { display: grid; grid-template-columns: 320px 1fr; gap: 30px; }
    .card { border: 1px solid var(--line); border-radius: 22px; background: var(--card); box-shadow: var(--shadow); padding: 30px; }
    .card h2 { margin: 0 0 20px; font-size: 20px; font-weight: 900; }
    
    /* Forms */
    .form-group { margin-bottom: 16px; }
    .form-group label { display: block; font-size: 13px; font-weight: 800; margin-bottom: 6px; }
    .form-group input, .form-group select { width: 100%; height: 42px; padding: 0 14px; border: 1px solid var(--line); border-radius: 10px; font-size: 14px; font-family: inherit; }
    .form-group input:focus, .form-group select:focus { outline: none; border-color: var(--purple); box-shadow: 0 0 0 3px rgba(111, 45, 226, 0.15); }
    .btn { width: 100%; height: 44px; border: 0; border-radius: 22px; color: #fff; background: var(--purple); font-weight: 800; font-size: 14px; cursor: pointer; transition: 0.2s; }
    .btn:hover { background: #5a1bcc; }
    
    /* Tables */
    .admin-table { width: 100%; border-collapse: collapse; }
    .admin-table th, .admin-table td { padding: 14px 12px; text-align: left; }
    .admin-table th { border-bottom: 2px solid var(--line); font-weight: 900; color: var(--muted); font-size: 13px; }
    .admin-table td { border-bottom: 1px solid var(--line); font-size: 14px; font-weight: 700; }
    .action-links a { color: var(--purple); font-weight: 800; font-size: 13px; margin-right: 12px; }
    .action-links a.del { color: #d32f2f; }
    
    .alert { padding: 12px 16px; border-radius: 10px; font-size: 14px; font-weight: 800; margin-bottom: 20px; }
    .alert-success { background: #d4edda; color: #155724; }
    .alert-danger { background: #f8d7da; color: #721c24; }
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
          <li><a href="<%= request.getContextPath() %>/admin/users" class="active">Users CRUD</a></li>
          <li><a href="<%= request.getContextPath() %>/admin/restaurants">Restaurants CRUD</a></li>
          <li><a href="<%= request.getContextPath() %>/admin/menu">Menu CRUD</a></li>
          <li><a href="<%= request.getContextPath() %>/admin/orders">Orders</a></li>
        <% } %>
      </ul>
      <div class="nav-actions">
        <span style="font-weight: 800; margin-right:15px"><%= user.getUsername() %></span>
        <a href="<%= request.getContextPath() %>/logout" style="padding: 8px 16px; border: 1px solid #fff; border-radius: 20px; font-weight: 800;">Logout</a>
      </div>
    </div>
  </div>

  <div class="container">
    <h1>Manage <span>Users</span></h1>
    
    <% if (request.getParameter("successMessage") != null) { %>
      <div class="alert alert-success"><%= request.getParameter("successMessage") %></div>
    <% } %>
    <% if (request.getParameter("errorMessage") != null) { %>
      <div class="alert alert-danger"><%= request.getParameter("errorMessage") %></div>
    <% } %>

    <div class="dashboard-layout">
      <!-- Add / Edit Form -->
      <div class="card">
        <h2><%= userToEdit != null ? "Edit User" : "Add New User" %></h2>
        <form action="users" method="POST">
          <input type="hidden" name="action" value="<%= userToEdit != null ? "update" : "add" %>">
          <% if (userToEdit != null) { %>
            <input type="hidden" name="userId" value="<%= userToEdit.getUserid() %>">
          <% } %>
          
          <div class="form-group">
            <label>Username</label>
            <input type="text" name="username" value="<%= userToEdit != null ? userToEdit.getUsername() : "" %>" required>
          </div>
          
          <div class="form-group">
            <label>Email</label>
            <input type="email" name="email" value="<%= userToEdit != null ? userToEdit.getEmail() : "" %>" required>
          </div>
          
          <div class="form-group">
            <label>Phone</label>
            <input type="text" name="phone" value="<%= userToEdit != null ? userToEdit.getPhone() : "" %>">
          </div>
          
          <div class="form-group">
            <label>Role</label>
            <select name="role" required>
              <option value="Customer" <%= (userToEdit != null && "Customer".equalsIgnoreCase(userToEdit.getRole())) ? "selected" : "" %>>Customer</option>
              <option value="admin" <%= (userToEdit != null && "admin".equalsIgnoreCase(userToEdit.getRole())) ? "selected" : "" %>>System Admin</option>
              <option value="restaurant_admin" <%= (userToEdit != null && "restaurant_admin".equalsIgnoreCase(userToEdit.getRole())) ? "selected" : "" %>>Restaurant Admin</option>
              <option value="delivery_agent" <%= (userToEdit != null && "delivery_agent".equalsIgnoreCase(userToEdit.getRole())) ? "selected" : "" %>>Delivery Agent</option>
            </select>
          </div>
          
          <div class="form-group">
            <label>Password <%= userToEdit != null ? "(Leave blank to keep unchanged)" : "" %></label>
            <input type="password" name="password" <%= userToEdit == null ? "required" : "" %>>
          </div>
          
          <button type="submit" class="btn"><%= userToEdit != null ? "Update User" : "Save User" %></button>
          
          <% if (userToEdit != null) { %>
            <div style="text-align:center; margin-top:10px;">
              <a href="users" style="font-size:13px; font-weight:700; color:var(--muted)">Cancel Edit</a>
            </div>
          <% } %>
        </form>
      </div>

      <!-- Users Table -->
      <div class="card">
        <h2>Registered Users</h2>
        <table class="admin-table">
          <thead>
            <tr>
              <th>ID</th>
              <th>Username</th>
              <th>Email</th>
              <th>Phone</th>
              <th>Role</th>
              <th>Actions</th>
            </tr>
          </thead>
          <tbody>
            <% 
              if (userList != null && !userList.isEmpty()) {
                for (User u : userList) {
            %>
            <tr>
              <td><%= u.getUserid() %></td>
              <td><%= u.getUsername() %></td>
              <td><%= u.getEmail() %></td>
              <td><%= u.getPhone() != null ? u.getPhone() : "-" %></td>
              <td><strong style="text-transform: capitalize;"><%= u.getRole() %></strong></td>
              <td class="action-links">
                <a href="users?action=edit&id=<%= u.getUserid() %>">Edit</a>
                <% if (u.getUserid() != user.getUserid()) { %>
                  <a href="users?action=delete&id=<%= u.getUserid() %>" class="del" onclick="return confirm('Are you sure you want to delete this user?');">Delete</a>
                <% } %>
              </td>
            </tr>
            <% 
                }
              } else { 
            %>
            <tr>
              <td colspan="6" style="text-align:center;">No users found.</td>
            </tr>
            <% } %>
          </tbody>
        </table>
      </div>
    </div>
  </div>
</body>
</html>
