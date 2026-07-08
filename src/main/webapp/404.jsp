<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isErrorPage="true" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Page Not Found - TastyBowl</title>
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
      align-items: center;
      justify-content: center;
      padding: 20px;
    }

    .error-card {
      max-width: 500px;
      width: 100%;
      padding: 50px 40px;
      border: 1px solid rgba(255, 255, 255, 0.75);
      border-radius: 28px;
      background: rgba(255, 255, 255, 0.9);
      box-shadow: var(--shadow);
      backdrop-filter: blur(10px);
      text-align: center;
    }

    .error-num {
      font-size: 100px;
      font-weight: 900;
      line-height: 1;
      margin: 0 0 10px;
      background: linear-gradient(135deg, #8844f5, #6422d8);
      -webkit-background-clip: text;
      -webkit-text-fill-color: transparent;
    }

    h2 {
      margin: 0 0 12px;
      font-size: 24px;
      font-weight: 900;
    }

    p {
      color: var(--muted);
      font-weight: 700;
      line-height: 1.5;
      margin: 0 0 30px;
    }

    .btn {
      display: inline-flex;
      align-items: center;
      justify-content: center;
      height: 48px;
      padding: 0 28px;
      border-radius: 24px;
      color: #fff;
      background: var(--purple);
      font-weight: 900;
      text-decoration: none;
      box-shadow: 0 8px 16px rgba(111, 45, 226, 0.2);
      transition: transform 150ms ease;
    }

    .btn:hover {
      transform: translateY(-2px);
    }
  </style>
</head>
<body>
  <div class="error-card">
    <div class="error-num">404</div>
    <h2>Page Not <span>Found</span></h2>
    <p>Oops! The page you are looking for might have been removed, had its name changed, or is temporarily unavailable.</p>
    <a href="callRestaurantServlet" class="btn">Go to Homepage</a>
  </div>
</body>
</html>
