<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Register - FoodApp</title>
  <style>
    :root {
      --ink: #271044;
      --muted: #69627f;
      --purple: #6f2de2;
      --purple-dark: #4e18c3;
      --orange: #ffba2d;
      --green: #267e3e;
      --line: rgba(91, 49, 164, 0.12);
      --shadow: 0 18px 42px rgba(65, 26, 137, 0.16);
    }

    * {
      box-sizing: border-box;
    }

    body {
      margin: 0;
      color: var(--ink);
      font-family: Arial, Helvetica, sans-serif;
      background:
        radial-gradient(circle at 12% 6%, rgba(169, 106, 255, 0.18), transparent 28rem),
        linear-gradient(180deg, #fff 0%, #fbf8ff 54%, #f5efff 100%);
      min-height: 100vh;
      display: flex;
      flex-direction: column;
    }

    /* Topbar */
    .topbar {
      background: linear-gradient(90deg, #8442f2 0%, #5d1ed0 100%);
      box-shadow: 0 6px 20px rgba(60, 22, 144, 0.24);
      width: 100%;
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
      display: inline-flex;
      align-items: center;
      gap: 10px;
      font-size: 25px;
      font-weight: 900;
      text-decoration: none;
      color: inherit;
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
      border-radius: 0 0 16px 16px;
      border: 4px solid #5b1dcf;
      border-top: 0;
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
      flex: 1;
      display: flex;
      align-items: center;
      justify-content: center;
      padding: 40px 20px;
    }

    .card {
      width: min(520px, 100%);
      padding: 40px;
      border: 1px solid rgba(255, 255, 255, 0.75);
      border-radius: 28px;
      background: rgba(255, 255, 255, 0.9);
      box-shadow: var(--shadow);
      backdrop-filter: blur(10px);
    }

    h2 {
      margin: 0 0 20px;
      font-size: 32px;
      font-weight: 900;
      text-align: center;
    }

    h2 span {
      color: var(--purple);
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

    input, textarea {
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

    input:focus, textarea:focus {
      border-color: var(--purple);
      box-shadow: 0 0 0 4px rgba(111, 45, 226, 0.15);
    }

    .btn {
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
      margin-top: 10px;
      transition: transform 150ms ease, box-shadow 150ms ease;
    }

    .btn:hover {
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

    .alert-success {
      color: #155724;
      background-color: #d4edda;
      border: 1px solid #c3e6cb;
    }

    .link-text {
      text-align: center;
      margin-top: 24px;
      font-size: 14px;
      font-weight: 700;
      color: var(--muted);
    }

    .link-text a {
      color: var(--purple);
      text-decoration: none;
      font-weight: 900;
    }

    .link-text a:hover {
      text-decoration: underline;
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
    }
  </style>
</head>
<body>
  <div class="topbar">
    <div class="nav">
      <a href="callRestaurantServlet" class="brand">
        <div class="brand-mark"></div>
        TastyBowl
      </a>
    </div>
  </div>

  <div class="container">
    <div class="card">
      <h2>Create <span>Account</span></h2>

      <% if (request.getAttribute("errorMessage") != null) { %>
        <div class="alert alert-danger">
          <%= request.getAttribute("errorMessage") %>
        </div>
      <% } %>

      <form action="register" method="POST">
        <div class="form-group">
          <label for="username">Username</label>
          <input type="text" id="username" name="username" placeholder="e.g. John Doe" required>
        </div>

        <div class="form-row">
          <div class="form-group">
            <label for="email">Email</label>
            <input type="email" id="email" name="email" placeholder="e.g. john@example.com" required>
          </div>
          <div class="form-group">
            <label for="phone">Phone</label>
            <input type="tel" id="phone" name="phone" placeholder="e.g. 9876543210">
          </div>
        </div>

        <div class="form-group">
          <label for="password">Password</label>
          <input type="password" id="password" name="password" placeholder="••••••••" required>
        </div>

        <div class="form-group">
          <label for="address">Address</label>
          <textarea id="address" name="address" placeholder="Flat No, Building, Street Address"></textarea>
        </div>

        <div class="form-row">
          <div class="form-group">
            <label for="city">City</label>
            <input type="text" id="city" name="city" placeholder="e.g. Noida">
          </div>
          <div class="form-group">
            <label for="state">State</label>
            <input type="text" id="state" name="state" placeholder="e.g. Uttar Pradesh">
          </div>
        </div>

        <div class="form-group">
          <label for="pincode">Pincode</label>
          <input type="text" id="pincode" name="pincode" placeholder="e.g. 201301">
        </div>

        <button type="submit" class="btn">Register</button>
      </form>

      <p class="link-text">Already have an account? <a href="login.jsp">Log In</a></p>
    </div>
  </div>

  <footer class="footer">
    <p>&copy; 2026 TastyBowl Food Platforms Inc. All rights reserved.</p>
  </footer>
</body>
</html>
