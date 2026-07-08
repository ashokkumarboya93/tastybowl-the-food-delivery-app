<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isErrorPage="true" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Internal Server Error - TastyBowl</title>
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
      max-width: 550px;
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
      background: linear-gradient(135deg, #f05254, #b83232);
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

    .details {
      text-align: left;
      background: #faf8ff;
      border: 1px solid var(--line);
      border-radius: 12px;
      padding: 16px;
      font-family: monospace;
      font-size: 12px;
      overflow-x: auto;
      margin-bottom: 24px;
      max-height: 150px;
      display: none;
    }
  </style>
</head>
<body>
  <div class="error-card">
    <div class="error-num">500</div>
    <h2>Internal Server <span>Error</span></h2>
    <p>We apologize for the inconvenience. Something went wrong on our servers. Please try reloading the page or contact support.</p>
    
    <% if (exception != null) { %>
      <button onclick="toggleDetails()" class="btn btn-secondary" style="height:36px; padding: 0 14px; border-radius:18px; margin-bottom:15px; font-size:12px; border:1px solid var(--line); background:#fff; color:var(--ink); font-weight:800; cursor:pointer;">Show Stack Trace</button>
      <div id="stacktrace" class="details">
        <strong>Error message:</strong> <%= exception.getMessage() %><br><br>
        <%
          java.io.StringWriter sw = new java.io.StringWriter();
          java.io.PrintWriter pw = new java.io.PrintWriter(sw);
          exception.printStackTrace(pw);
          out.print(sw.toString().replace("\n", "<br>"));
        %>
      </div>
    <% } %>

    <div>
      <a href="callRestaurantServlet" class="btn">Go to Homepage</a>
    </div>
  </div>

  <script>
    function toggleDetails() {
      const details = document.getElementById('stacktrace');
      if (details.style.display === 'block') {
        details.style.display = 'none';
      } else {
        details.style.display = 'block';
      }
    }
  </script>
</body>
</html>
