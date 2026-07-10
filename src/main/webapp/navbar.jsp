<%@ page import="java.util.Map, com.food.model.CartItem, com.food.model.User" %>
<%
  int cartItemCount = 0;
  User loggedInUser = (User) session.getAttribute("loggedInUser");
  @SuppressWarnings("unchecked")
  Map<Integer, CartItem> cartMap = (Map<Integer, CartItem>) session.getAttribute("cart");
  if (cartMap != null) {
      for (CartItem item : cartMap.values()) {
          cartItemCount += item.getQuantity();
      }
  }
  String ctx = request.getContextPath();
%>
<style>
  /* ═══════════════════════════════════════
     NAVBAR - Modern glassmorphism
  ═══════════════════════════════════════ */
  .icon{display:inline-flex;align-items:center;justify-content:center;flex-shrink:0}
  .icon svg{width:100%;height:100%}
  
  .nav-wrap{
    position:sticky;top:0;z-index:200;
    background:rgba(255,255,255,.92);
    backdrop-filter:blur(20px) saturate(1.4);
    -webkit-backdrop-filter:blur(20px) saturate(1.4);
    border-bottom:1px solid rgba(108,45,224,.08);
  }
  .nav{display:flex;align-items:center;gap:0;height:72px}

  /* Logo */
  .logo{display:flex;align-items:center;gap:12px;flex-shrink:0;margin-right:32px;text-decoration:none;}
  .logo-mark{
    width:46px;height:46px;
    background:linear-gradient(145deg,#ffeea0,#f5a623);
    border-radius:14px;
    box-shadow:0 6px 18px rgba(245,166,35,.35),inset 0 -3px 6px rgba(180,100,0,.12);
    display:grid;place-items:center;padding:7px;
    position:relative;
    transition:transform .2s;
  }
  .logo:hover .logo-mark{transform:rotate(-6deg) scale(1.06)}
  .logo-mark svg{width:30px;height:30px;filter:drop-shadow(0 1px 2px rgba(0,0,0,.15))}

  .logo-text{
    font-family:'Pacifico',cursive;
    font-size:28px;
    background:linear-gradient(135deg,#f5a623 0%,#ff8f00 40%,#ffd600 100%);
    -webkit-background-clip:text;
    -webkit-text-fill-color:transparent;
    background-clip:text;
    filter:drop-shadow(0 2px 4px rgba(245,166,35,.35));
    letter-spacing:-0.5px;
    line-height:1;
  }

  /* Nav links */
  .nav-links{display:flex;align-items:center;gap:2px;list-style:none;margin:0;padding:0;}
  .nav-links a{
    display:flex;align-items:center;gap:6px;
    height:40px;padding:0 16px;
    border-radius:8px;font-size:14px;font-weight:600;color:#3d2860;
    transition:all .16s;position:relative;text-decoration:none;
  }
  .nav-links a:hover{background:#f3ebff;color:#6c2de0}
  .nav-links a.active{color:#6c2de0;font-weight:800}
  .nav-links a.active::after{
    content:'';position:absolute;bottom:-16px;left:50%;transform:translateX(-50%);
    width:24px;height:3px;border-radius:99px;background:#6c2de0;
  }

  /* Location pill */
  .nav-loc{
    display:flex;align-items:center;gap:8px;
    height:40px;padding:0 14px 0 10px;
    border:1.5px solid #ede5ff;border-radius:999px;
    font-size:13px;font-weight:700;color:#3d2860;
    cursor:pointer;transition:all .16s;margin-left:auto;
  }
  .nav-loc:hover{border-color:#6c2de0;background:#f3ebff;color:#6c2de0}
  .nav-loc .icon{width:16px;height:16px;color:#6c2de0}
  .nav-loc .caret{width:10px;height:10px;color:#7a6d93}

  /* Nav actions */
  .nav-actions{display:flex;align-items:center;gap:6px;margin-left:12px}
  .nav-btn{
    position:relative;width:42px;height:42px;
    border-radius:12px;display:grid;place-items:center;
    color:#3d2860;background:transparent;cursor:pointer;
    transition:all .16s;border:none;outline:none;text-decoration:none;
  }
  .nav-btn:hover{background:#f3ebff;color:#6c2de0}
  .nav-btn .icon{width:20px;height:20px}
  .cart-count{
    position:absolute;top:2px;right:2px;
    min-width:18px;height:18px;padding:0 4px;
    background:#6c2de0;color:#fff;
    border-radius:999px;font-size:10px;font-weight:800;
    display:grid;place-items:center;
    border:2px solid #fff;
  }
  .nav-avatar{
    display:flex;align-items:center;gap:8px;
    height:42px;padding:0 12px 0 4px;
    border:1.5px solid #ede5ff;border-radius:999px;
    cursor:pointer;font-size:14px;font-weight:700;color:#3d2860;
    transition:all .16s;text-decoration:none;
  }
  .nav-avatar:hover{border-color:#6c2de0;color:#6c2de0}
  .avatar-circle{
    width:34px;height:34px;border-radius:50%;
    background:linear-gradient(135deg,#8a44f5,#5720c8);
    color:#fff;font-weight:900;font-size:14px;
    display:grid;place-items:center;
  }
  .sign-in-btn{
    height:40px;padding:0 22px;background:#6c2de0;color:#fff;
    border-radius:8px;font-size:14px;font-weight:800;
    display:flex;align-items:center;gap:6px;cursor:pointer;
    transition:background .18s;text-decoration:none;
  }
  .sign-in-btn:hover{background:#5720c8}
</style>

<svg style="display:none;">
  <symbol id="i-bowl" viewBox="0 0 24 24"><path fill="currentColor" d="M1 10a1 1 0 0 1 1-1h20a1 1 0 0 1 .92 1.39C21.55 14.4 17.83 17 14.28 17H9.72c-3.55 0-7.27-2.6-8.64-6.61A1 1 0 0 1 1 10Zm4.5 9h13a.5.5 0 0 1 0 1h-13a.5.5 0 0 1 0-1Z"/><path fill="currentColor" d="M10 3c0-.55.45-1 1-1h2a1 1 0 1 1 0 2h-1v3h-1V4h-.5A.5.5 0 0 1 10 3Z" opacity=".5"/></symbol>
  <symbol id="i-search" viewBox="0 0 24 24"><path fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" d="M21 21l-4.35-4.35M11 19a8 8 0 1 0 0-16 8 8 0 0 0 0 16Z"/></symbol>
  <symbol id="i-pin" viewBox="0 0 24 24"><path fill="currentColor" d="M12 2C8.13 2 5 5.13 5 9c0 5.25 7 13 7 13s7-7.75 7-13c0-3.87-3.13-7-7-7Zm0 9.5a2.5 2.5 0 1 1 0-5 2.5 2.5 0 0 1 0 5Z"/></symbol>
  <symbol id="i-cart" viewBox="0 0 24 24"><path fill="currentColor" d="M7 18c-1.1 0-2 .9-2 2s.9 2 2 2 2-.9 2-2-.9-2-2-2Zm10 0c-1.1 0-2 .9-2 2s.9 2 2 2 2-.9 2-2-.9-2-2-2ZM7.16 14.26l-.02.12c0 .34.28.62.62.62h11.49c.67 0 1.24-.42 1.47-1.03L23.16 7H5.21l-.94-2H1v2h2l3.6 7.59-1.35 2.44C4.52 18.27 5.48 20 7 20h12v-2H7.42c-.14 0-.25-.11-.25-.25l.03-.12.9-1.63h7.45c.75 0 1.41-.41 1.75-1.03l3.58-6.49c.08-.14.12-.31.12-.48 0-.55-.45-1-1-1H5.21l-.94-2H1v2h2l3.6 7.59Z"/></symbol>
  <symbol id="i-down" viewBox="0 0 24 24"><path fill="currentColor" d="M7.41 8.59 12 13.17l4.59-4.58L18 10l-6 6-6-6 1.41-1.41Z"/></symbol>
</svg>

<header class="nav-wrap">
  <nav class="nav w">
    <a class="logo" href="<%= ctx %>/callRestaurantServlet">
      <div class="logo-mark">
        <svg viewBox="0 0 24 24"><use href="#i-bowl"/></svg>
      </div>
      <span class="logo-text">TastyBowl</span>
    </a>

    <ul class="nav-links">
      <li><a href="<%= ctx %>/callRestaurantServlet">Home</a></li>
      <li><a href="<%= ctx %>/callRestaurantServlet">Restaurants</a></li>
      <li><a href="<%= ctx %>/orders">My Orders</a></li>
      <li><a href="<%= ctx %>/profile">Profile</a></li>
    </ul>

    <div class="nav-loc">
      <span class="icon"><svg><use href="#i-pin"/></svg></span>
      <span>Bangalore</span>
      <span class="icon caret"><svg><use href="#i-down"/></svg></span>
    </div>

    <div class="nav-actions">
      <button class="nav-btn" aria-label="Search"><span class="icon"><svg><use href="#i-search"/></svg></span></button>
      <a class="nav-btn" href="<%= ctx %>/cart.jsp" aria-label="Cart">
        <span class="icon"><svg><use href="#i-cart"/></svg></span>
        <span class="cart-count"><%=cartItemCount%></span>
      </a>
      <% if (loggedInUser != null) { %>
        <a class="nav-avatar" href="<%= ctx %>/profile">
          <span class="avatar-circle"><%=loggedInUser.getUsername().substring(0,1).toUpperCase()%></span>
          <span><%=loggedInUser.getUsername()%></span>
          <span class="icon caret" style="width:10px;height:10px"><svg><use href="#i-down"/></svg></span>
        </a>
      <% } else { %>
        <a class="sign-in-btn" href="<%= ctx %>/login.jsp">Sign In</a>
      <% } %>
    </div>
  </nav>
</header>
