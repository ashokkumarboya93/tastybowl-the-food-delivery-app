<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, java.util.Map, com.food.model.Menu, com.food.model.CartItem, com.food.model.User" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>TastyBowl - Restaurant Menu</title>
  <meta name="description" content="Explore delicious menus and order fast.">
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800;900&family=Pacifico&display=swap" rel="stylesheet">
  <style>
    :root {
      --p:#6c2de0; --p2:#5720c8; --p3:#8a44f5; --p-bg:#f3ebff;
      --orange:#f5a623; --yellow:#ffd600; --green:#1a7e3a; --red:#e53935;
      --ink:#1a0933; --mid:#3d2860; --muted:#7a6d93; --line:#ede5ff;
      --bg:#faf7ff; --white:#fff;
      --r8:8px; --r12:12px; --r16:16px; --r20:20px; --r99:999px;
      --sh:0 2px 12px rgba(30,10,80,.08);
      --sh2:0 12px 36px rgba(30,10,80,.16);
    }
    *,*::before,*::after{box-sizing:border-box;margin:0;padding:0}
    html{scroll-behavior:smooth}
    body{font-family:'Inter',sans-serif;background:var(--bg);color:var(--ink);-webkit-font-smoothing:antialiased}
    a{text-decoration:none;color:inherit}
    button,input,select{font:inherit;border:none;outline:none}
    img{display:block}
    .w{width:min(1260px,calc(100% - 40px));margin-inline:auto}

    .icon{display:inline-flex;align-items:center;justify-content:center;flex-shrink:0}
    .icon svg{width:100%;height:100%}

    /* NAVBAR - Modern glassmorphism */
    .nav-wrap{
      position:sticky;top:0;z-index:200;
      background:rgba(255,255,255,.92);
      backdrop-filter:blur(20px) saturate(1.4);
      -webkit-backdrop-filter:blur(20px) saturate(1.4);
      border-bottom:1px solid rgba(108,45,224,.08);
    }
    .nav{display:flex;align-items:center;gap:0;height:72px}
    .logo{display:flex;align-items:center;gap:12px;flex-shrink:0;margin-right:32px}
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
      font-family:'Pacifico',cursive;font-size:28px;
      background:linear-gradient(135deg,#f5a623 0%,#ff8f00 40%,#ffd600 100%);
      -webkit-background-clip:text;-webkit-text-fill-color:transparent;background-clip:text;
      filter:drop-shadow(0 2px 4px rgba(245,166,35,.35));letter-spacing:-0.5px;line-height:1;
    }
    .nav-links{display:flex;align-items:center;gap:2px;list-style:none}
    .nav-links a{
      display:flex;align-items:center;gap:6px;
      height:40px;padding:0 16px;
      border-radius:var(--r8);font-size:14px;font-weight:600;color:var(--mid);
      transition:all .16s;position:relative;
    }
    .nav-links a:hover{background:var(--p-bg);color:var(--p)}
    .nav-links a.active{color:var(--p);font-weight:800}
    .nav-links a.active::after{
      content:'';position:absolute;bottom:-16px;left:50%;transform:translateX(-50%);
      width:24px;height:3px;border-radius:99px;background:var(--p);
    }
    .nav-actions{display:flex;align-items:center;gap:6px;margin-left:auto}
    .nav-btn{
      position:relative;width:42px;height:42px;
      border-radius:var(--r12);display:grid;place-items:center;
      color:var(--mid);background:transparent;cursor:pointer;
      transition:all .16s;
    }
    .nav-btn:hover{background:var(--p-bg);color:var(--p)}
    .nav-btn .icon{width:20px;height:20px}
    .cart-count{
      position:absolute;top:2px;right:2px;
      min-width:18px;height:18px;padding:0 4px;
      background:var(--p);color:#fff;
      border-radius:var(--r99);font-size:10px;font-weight:800;
      display:grid;place-items:center;
      border:2px solid #fff;
    }
    .nav-avatar{
      display:flex;align-items:center;gap:8px;
      height:42px;padding:0 12px 0 4px;
      border:1.5px solid var(--line);border-radius:var(--r99);
      cursor:pointer;font-size:14px;font-weight:700;color:var(--mid);
      transition:all .16s;
    }
    .nav-avatar:hover{border-color:var(--p);color:var(--p)}
    .avatar-circle{
      width:34px;height:34px;border-radius:50%;
      background:linear-gradient(135deg,var(--p3),var(--p2));
      color:#fff;font-weight:900;font-size:14px;
      display:grid;place-items:center;
    }
    .sign-in-btn{
      height:40px;padding:0 22px;background:var(--p);color:#fff;
      border-radius:var(--r8);font-size:14px;font-weight:800;
      display:flex;align-items:center;gap:6px;cursor:pointer;
      transition:background .18s;
    }
    .sign-in-btn:hover{background:var(--p2)}

    /* HERO */
    .restaurant-hero {
      width: min(1260px, calc(100% - 40px));
      min-height: 280px;
      margin: 24px auto 0;
      border-radius: 24px;
      color: #fff;
      background:
        linear-gradient(90deg, rgba(26,9,51,0.95) 0%, rgba(61,40,96,0.85) 42%, rgba(26,9,51,0.2) 100%),
        url("https://images.unsplash.com/photo-1555396273-367ea4eb4db5?auto=format&fit=crop&w=1500&q=80");
      background-position: center;
      background-size: cover;
      box-shadow: var(--sh2);
      display: flex; align-items: center; padding: 40px;
    }
    .hero-content {
      max-width: 600px;
    }
    .restaurant-title h1 {
      font-size: clamp(32px, 4vw, 48px);
      line-height: 1.1;
      font-weight: 900;
      margin-bottom: 8px;
    }
    .restaurant-title p {
      color: rgba(255, 255, 255, 0.85);
      font-size: 16px;
      font-weight: 500;
      margin-bottom: 20px;
    }
    .quick-info {
      display: flex;
      flex-wrap: wrap;
      gap: 12px;
    }
    .quick-info span {
      display: inline-flex;
      align-items: center; gap: 6px;
      min-height: 38px;
      padding: 0 16px;
      border-radius: var(--r99);
      color: rgba(255, 255, 255, 0.95);
      background: rgba(255, 255, 255, 0.15);
      backdrop-filter: blur(8px);
      font-size: 14px;
      font-weight: 700;
    }
    .quick-info .icon { width: 16px; height: 16px; }

    /* MENU BAR */
    .tabs-bar {
      position: sticky;
      top: 72px;
      z-index: 10;
      border-bottom: 1px solid var(--line);
      background: rgba(255, 255, 255, 0.92);
      backdrop-filter: blur(12px);
      box-shadow: 0 4px 12px rgba(108,45,224,.03);
    }
    .tabs-inner {
      display: flex;
      align-items: center;
      justify-content: space-between;
      min-height: 72px;
      gap: 24px;
    }
    .tabs {
      display: flex;
      align-items: center;
      gap: 32px;
    }
    .tab {
      display: inline-flex;
      align-items: center;
      gap: 8px;
      min-height: 72px;
      border-bottom: 3px solid transparent;
      color: var(--mid);
      font-size: 15px;
      font-weight: 700;
      transition: all 0.2s;
    }
    .tab.active {
      color: var(--p);
      border-color: var(--p);
      font-weight: 800;
    }
    .tab .icon { width: 20px; height: 20px; }
    
    .menu-tools {
      display: flex;
      align-items: center;
      gap: 16px;
    }
    .menu-search {
      display: flex;
      align-items: center;
      width: 280px;
      height: 44px;
      padding: 0 16px;
      border: 1.5px solid var(--line);
      border-radius: var(--r99);
      background: #fff;
      transition: border-color 0.2s;
    }
    .menu-search:focus-within { border-color: var(--p); box-shadow: 0 0 0 3px var(--p-bg); }
    .menu-search .icon { color: var(--muted); width: 18px; height: 18px; margin-right: 8px; }
    .menu-search input {
      flex: 1; border: 0; outline: 0; color: var(--ink); background: transparent;
      font-size: 14px; font-weight: 600;
    }
    .veg-switch {
      display: inline-flex;
      align-items: center;
      gap: 8px;
      color: var(--mid);
      font-size: 14px;
      font-weight: 700;
      cursor: pointer;
    }
    .switch {
      position: relative;
      width: 40px;
      height: 24px;
      border-radius: var(--r99);
      background: #dcd6e8;
      transition: background 0.2s;
    }
    .switch::after {
      content: "";
      position: absolute;
      top: 3px; left: 3px;
      width: 18px; height: 18px;
      border-radius: 50%;
      background: #fff;
      box-shadow: 0 2px 5px rgba(0,0,0,0.15);
      transition: transform 0.2s;
    }
    .veg-switch:hover .switch { background: #cfc6df; }

    /* LAYOUT */
    .page-shell {
      display: grid;
      grid-template-columns: 240px minmax(0, 1fr);
      gap: 40px;
      margin: 40px auto 60px;
      align-items: start;
    }

    /* SIDEBAR */
    .sidebar {
      position: sticky;
      top: 176px;
      border: 1.5px solid var(--line);
      border-radius: var(--r16);
      background: rgba(255, 255, 255, 0.86);
      padding: 20px 16px;
    }
    .sidebar h2 {
      font-size: 18px;
      font-weight: 900;
      margin-bottom: 16px;
      padding-left: 8px;
      color: var(--ink);
    }
    .category-list {
      display: flex;
      flex-direction: column;
      gap: 4px;
    }
    .category-list a {
      display: flex;
      align-items: center; gap: 10px;
      min-height: 44px;
      padding: 0 12px;
      border-radius: var(--r8);
      color: var(--mid);
      font-size: 14px;
      font-weight: 700;
      transition: all 0.15s;
    }
    .category-list a .icon { width: 18px; height: 18px; color: var(--muted); transition: color 0.15s; }
    .category-list a:hover { background: var(--p-bg); color: var(--p); }
    .category-list a:hover .icon { color: var(--p); }
    .category-list a.active { background: var(--p); color: #fff; }
    .category-list a.active .icon { color: #fff; }

    .side-offer {
      margin-top: 24px;
      padding: 16px;
      border-radius: var(--r12);
      background: linear-gradient(135deg, #fff3e0, #ffe0b2);
      border: 1px solid #ffd54f;
    }
    .side-offer strong { display: block; color: #e65100; font-size: 15px; font-weight: 900; }
    .side-offer small { display: block; margin-top: 6px; color: #f57c00; font-size: 12px; font-weight: 700; line-height: 1.4; }

    /* MENU GRID */
    .menu-section h2 {
      display: flex;
      align-items: center; gap: 12px;
      margin-bottom: 24px;
      font-size: 24px;
      font-weight: 900;
      color: var(--ink);
    }
    .menu-section h2 .icon { color: var(--p); width: 24px; height: 24px; }
    
    .menu-grid {
      display: grid;
      grid-template-columns: repeat(3, minmax(0, 1fr));
      gap: 24px;
    }
    .menu-card {
      background: #fff; border-radius: var(--r16);
      border: 1.5px solid var(--line);
      overflow: hidden; cursor: pointer;
      transition: transform .22s, box-shadow .22s, border-color .22s;
      box-shadow: var(--sh);
      display: flex; flex-direction: column;
    }
    .menu-card:hover {
      transform: translateY(-6px);
      box-shadow: var(--sh2);
      border-color: rgba(108,45,224,.22);
    }
    .food-image {
      position: relative; height: 180px; background: #ede5ff; overflow: hidden;
    }
    .food-image img { width: 100%; height: 100%; object-fit: cover; transition: transform .3s ease; }
    .menu-card:hover .food-image img { transform: scale(1.06); }
    
    /* Veg / Non-veg marker using CSS drawn box, standard Indian food packaging format */
    .food-type {
      position: absolute; top: 12px; right: 12px;
      width: 20px; height: 20px;
      border: 2px solid var(--green); border-radius: 4px;
      background: #fff; display: grid; place-items: center; z-index: 2;
    }
    .food-type::after {
      content: ""; width: 8px; height: 8px; border-radius: 50%; background: var(--green);
    }
    .food-type.non-veg { border-color: var(--red); }
    .food-type.non-veg::after { background: var(--red); }
    
    .best-tag {
      position: absolute; left: 12px; bottom: 12px; z-index: 2;
      padding: 6px 12px; border-radius: 6px;
      color: #fff; background: rgba(0,0,0,0.7); backdrop-filter: blur(4px);
      font-size: 11px; font-weight: 800; letter-spacing: 0.05em; text-transform: uppercase;
    }
    .food-image::after {
      content:''; position:absolute; inset:auto 0 0; height:50%;
      background:linear-gradient(180deg,transparent,rgba(0,0,0,.4)); pointer-events:none; z-index: 1;
    }

    .food-body { padding: 16px; display: flex; flex-direction: column; flex: 1; }
    .food-body h3 { font-size: 17px; font-weight: 800; line-height: 1.3; color: var(--ink); margin-bottom: 8px; }
    .description { color: var(--muted); font-size: 13px; font-weight: 500; line-height: 1.5; margin-bottom: 16px; flex: 1; }
    
    .rating-row {
      display: flex; align-items: center; gap: 12px; margin-bottom: 16px;
    }
    .stars {
      display: flex; align-items: center; gap: 4px;
      background: #fff9e6; color: #e08a00; padding: 4px 8px; border-radius: 6px;
      font-size: 12px; font-weight: 800; border: 1px solid #ffecb3;
    }
    .stars .icon { width: 14px; height: 14px; }
    
    .price-row {
      display: flex; align-items: center; justify-content: space-between; gap: 12px;
      border-top: 1px solid var(--line); padding-top: 16px; margin-top: auto;
    }
    .price { font-size: 18px; font-weight: 900; color: var(--ink); white-space: nowrap; }
    .add-btn {
      display: inline-flex; align-items: center; justify-content: center; gap: 6px;
      height: 36px; padding: 0 16px; min-width: 80px;
      background: var(--p-bg); color: var(--p);
      border: none; border-radius: var(--r8);
      font-size: 13px; font-weight: 800; cursor: pointer;
      transition: all 0.2s; white-space: nowrap;
    }
    .add-btn .icon { width: 16px; height: 16px; }
    .add-btn:hover { background: var(--p); color: #fff; transform: translateY(-2px); box-shadow: 0 4px 12px rgba(108,45,224,.2); }

    /* FOOTER */
    .footer{background:var(--ink);color:rgba(255,255,255,.6); margin-top: 60px;}
    .footer-top{
      display:grid;grid-template-columns:1.6fr 1fr 1fr 1fr 1.4fr;
      gap:36px;padding:52px 0 38px;
      border-bottom:1px solid rgba(255,255,255,.1);
    }
    .ft-brand{display:flex;align-items:center;gap:10px;margin-bottom:14px}
    .ft-logo{
      width:38px;height:38px;border-radius:12px;
      background:linear-gradient(145deg,#ffeea0,#f5a623);
      display:grid;place-items:center;padding:5px;flex-shrink:0;
    }
    .ft-logo svg{width:26px;height:26px}
    .ft-name{font-family:'Pacifico',cursive;font-size:22px;color:var(--orange)}
    .ft-desc{font-size:13px;line-height:1.65;margin-bottom:18px}
    .ft-socials{display:flex;gap:10px}
    .ft-social{
      width:36px;height:36px;border-radius:var(--r8);
      background:rgba(255,255,255,.08);display:grid;place-items:center;
      transition:all .16s;
    }
    .ft-social:hover{background:var(--p3);color:#fff}
    .ft-social .icon{width:16px;height:16px;color:rgba(255,255,255,.7)}
    .ft-social:hover .icon{color:#fff}
    .ft-col h5{
      font-size:12px;font-weight:800;color:#fff;
      letter-spacing:.07em;text-transform:uppercase;margin-bottom:16px;
    }
    .ft-col ul{list-style:none;display:flex;flex-direction:column;gap:11px}
    .ft-col ul li a{font-size:13px;font-weight:600;color:rgba(255,255,255,.55);transition:color .16s}
    .ft-col ul li a:hover{color:#fff}
    .ft-app h5{font-size:12px;font-weight:800;color:#fff;letter-spacing:.07em;text-transform:uppercase;margin-bottom:16px}
    .app-btn{
      display:flex;align-items:center;gap:10px;
      background:rgba(255,255,255,.08);border-radius:var(--r8);
      padding:10px 14px;margin-bottom:10px;
      border:1px solid rgba(255,255,255,.15);transition:background .18s;
    }
    .app-btn:hover{background:rgba(255,255,255,.15)}
    .app-btn .icon{width:24px;height:24px;color:rgba(255,255,255,.8)}
    .app-btn small{font-size:10px;color:rgba(255,255,255,.5);font-weight:600;display:block}
    .app-btn strong{font-size:14px;font-weight:800;color:#fff}
    .footer-bottom{
      display:flex;align-items:center;justify-content:space-between;
      gap:16px;padding:18px 0;font-size:12px;color:rgba(255,255,255,.35);font-weight:600;flex-wrap:wrap;
    }

    /* Message Banners (Toast Notification) */
    .msg-banner { 
      position: fixed; top: 90px; right: 24px; z-index: 1000;
      padding: 14px 20px; border-radius: var(--r12); font-weight: 700; font-size:14px; 
      display:flex; align-items:center; gap:10px; box-shadow: var(--sh2);
      animation: slideIn 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275) forwards, fadeOut 0.4s 3s forwards;
      opacity: 0; pointer-events: none; max-width: 320px; width: max-content;
    }
    @keyframes slideIn { from { transform: translateX(120%); opacity: 0; } to { transform: translateX(0); opacity: 1; } }
    @keyframes fadeOut { from { transform: translateX(0); opacity: 1; } to { transform: translateX(120%); opacity: 0; } }
    .msg-success { color: #0f5132; background-color: #d1e7dd; border: 1px solid #badbcc; }
    .msg-error { color: #842029; background-color: #f8d7da; border: 1px solid #f5c2c7; }

    @media (max-width: 1080px) {
      .page-shell { grid-template-columns: 1fr; }
      .sidebar { position: static; display: flex; flex-direction: column; }
      .category-list { flex-direction: row; overflow-x: auto; padding-bottom: 8px; }
      .category-list a { white-space: nowrap; }
      .menu-grid { grid-template-columns: repeat(2, minmax(0, 1fr)); }
      .footer-top{grid-template-columns:1fr 1fr 1fr}
      .ft-app{grid-column:1/-1}
    }
    @media (max-width: 760px) {
      .nav-links { display: none; }
      .menu-grid { grid-template-columns: 1fr; }
      .tabs-inner { flex-direction: column; align-items: stretch; gap: 16px; padding: 16px 0; }
      .tabs { overflow-x: auto; padding-bottom: 8px; }
      .menu-search { width: 100%; }
      .footer-top{grid-template-columns:1fr 1fr}
    }
    @media (max-width: 480px) {
      .footer-top{grid-template-columns:1fr}
      .restaurant-hero { padding: 24px; border-radius: 16px; min-height: auto; }
      .restaurant-title h1 { font-size: 28px; }
    }
  </style>
</head>
<%
  User loggedInUser = (User) session.getAttribute("loggedInUser");
  @SuppressWarnings("unchecked")
  Map<Integer, CartItem> sessionCart = (Map<Integer, CartItem>) session.getAttribute("cart");
  int cartItemCount = 0;
  if (sessionCart != null) {
      for (CartItem ci : sessionCart.values()) {
          cartItemCount += ci.getQuantity();
      }
  }
%>
<body>

<!-- SVG SPRITE -->
<svg xmlns="http://www.w3.org/2000/svg" style="display:none">
  <symbol id="i-bowl" viewBox="0 0 24 24"><path fill="currentColor" d="M1 10a1 1 0 0 1 1-1h20a1 1 0 0 1 .92 1.39C21.55 14.4 17.83 17 14.28 17H9.72c-3.55 0-7.27-2.6-8.64-6.61A1 1 0 0 1 1 10Zm4.5 9h13a.5.5 0 0 1 0 1h-13a.5.5 0 0 1 0-1Z"/><path fill="currentColor" d="M10 3c0-.55.45-1 1-1h2a1 1 0 1 1 0 2h-1v3h-1V4h-.5A.5.5 0 0 1 10 3Z" opacity=".5"/></symbol>
  <symbol id="i-search" viewBox="0 0 24 24"><path fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" d="M21 21l-4.35-4.35M11 19a8 8 0 1 0 0-16 8 8 0 0 0 0 16Z"/></symbol>
  <symbol id="i-cart" viewBox="0 0 24 24"><path fill="currentColor" d="M7 18c-1.1 0-2 .9-2 2s.9 2 2 2 2-.9 2-2-.9-2-2-2Zm10 0c-1.1 0-2 .9-2 2s.9 2 2 2 2-.9 2-2-.9-2-2-2ZM7.16 14.26l-.02.12c0 .34.28.62.62.62h11.49c.67 0 1.24-.42 1.47-1.03L23.16 7H5.21l-.94-2H1v2h2l3.6 7.59-1.35 2.44C4.52 18.27 5.48 20 7 20h12v-2H7.42c-.14 0-.25-.11-.25-.25l.03-.12.9-1.63h7.45c.75 0 1.41-.41 1.75-1.03l3.58-6.49c.08-.14.12-.31.12-.48 0-.55-.45-1-1-1H5.21l-.94-2H1v2h2l3.6 7.59Z"/></symbol>
  <symbol id="i-down" viewBox="0 0 24 24"><path fill="currentColor" d="M7.41 8.59 12 13.17l4.59-4.58L18 10l-6 6-6-6 1.41-1.41Z"/></symbol>
  <symbol id="i-star" viewBox="0 0 24 24"><path fill="currentColor" d="M12 17.27L18.18 21l-1.64-7.03L22 9.24l-7.19-.61L12 2 9.19 8.63 2 9.24l5.46 4.73L5.82 21z"/></symbol>
  <symbol id="i-clock" viewBox="0 0 24 24"><path fill="currentColor" d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2Zm0 18c-4.42 0-8-3.58-8-8s3.58-8 8-8 8 3.58 8 8-3.58 8-8 8Zm.5-13H11v6l5.25 3.15.75-1.23-4.5-2.67Z"/></symbol>
  <symbol id="i-info" viewBox="0 0 24 24"><path fill="currentColor" d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2Zm1 15h-2v-6h2v6Zm0-8h-2V7h2v2Z"/></symbol>
  <symbol id="i-flame" viewBox="0 0 24 24"><path fill="currentColor" d="M11.71 1c-1.39 1.42-3.84 3.75-4.46 7.37-.2 1.15.01 2.36.56 3.42-1.34-1.27-1.74-3.19-1.25-4.99-.95 1.07-1.56 2.5-1.56 4.2 0 3.87 3.13 7 7 7s7-3.13 7-7c0-3.32-2.1-6.17-5.11-6.86.36 1.1.28 2.29-.3 3.32.72-2.31-.05-4.49-1.88-6.46z"/></symbol>
  <symbol id="i-plus" viewBox="0 0 24 24"><path fill="currentColor" d="M19 13h-6v6h-2v-6H5v-2h6V5h2v6h6v2z"/></symbol>
  <symbol id="i-heart" viewBox="0 0 24 24"><path fill="currentColor" d="M12 21.35l-1.45-1.32C5.4 15.36 2 12.28 2 8.5 2 5.42 4.42 3 7.5 3c1.74 0 3.41.81 4.5 2.09C13.09 3.81 14.76 3 16.5 3 19.58 3 22 5.42 22 8.5c0 3.78-3.4 6.86-8.55 11.54L12 21.35Z"/></symbol>
  <symbol id="i-restaurant" viewBox="0 0 24 24"><path fill="currentColor" d="M11 9H9V2H7v7H5V2H3v7c0 2.12 1.66 3.84 3.75 3.97V22h2.5v-9.03C11.34 12.84 13 11.12 13 9V2h-2v7Zm5-3v8h2.5v8H21V2c-2.76 0-5 2.24-5 4Z"/></symbol>
</svg>

<!-- NAVBAR -->
<header class="nav-wrap">
  <nav class="nav w">
    <a class="logo" href="callRestaurantServlet">
      <div class="logo-mark"><svg viewBox="0 0 24 24"><use href="#i-bowl"/></svg></div>
      <span class="logo-text">TastyBowl</span>
    </a>

    <ul class="nav-links">
      <li><a href="callRestaurantServlet">Home</a></li>
      <li><a class="active" href="#">Menu</a></li>
      <li><a href="orders">My Orders</a></li>
      <li><a href="profile">Profile</a></li>
    </ul>

    <div class="nav-actions">
      <button class="nav-btn" aria-label="Search"><span class="icon"><svg><use href="#i-search"/></svg></span></button>
      <a class="nav-btn" href="cart.jsp" aria-label="Cart">
        <span class="icon"><svg><use href="#i-cart"/></svg></span>
        <span class="cart-count"><%=cartItemCount%></span>
      </a>
      <% if (loggedInUser != null) { %>
        <a class="nav-avatar" href="profile">
          <span class="avatar-circle"><%=loggedInUser.getUsername().substring(0,1).toUpperCase()%></span>
          <span><%=loggedInUser.getUsername()%></span>
          <span class="icon caret" style="width:10px;height:10px"><svg><use href="#i-down"/></svg></span>
        </a>
      <% } else { %>
        <a class="sign-in-btn" href="login.jsp">Sign In</a>
      <% } %>
    </div>
  </nav>
</header>

<main>
  <% if (request.getParameter("successMessage") != null) { %>
    <div class="msg-banner msg-success">
      <span class="icon" style="width: 24px; height: 24px;"><svg viewBox="0 0 24 24"><path fill="currentColor" d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2Zm-2 15-5-5 1.41-1.41L10 14.17l7.59-7.59L19 8l-9 9Z"/></svg></span>
      <%= request.getParameter("successMessage") %>
    </div>
  <% } %>
  <% if (request.getParameter("errorMessage") != null) { %>
    <div class="msg-banner msg-error">
      <span class="icon" style="width: 24px; height: 24px;"><svg viewBox="0 0 24 24"><path fill="currentColor" d="M11 15h2v2h-2v-2Zm0-8h2v6h-2V7Zm1-5C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2Zm0 18c-4.42 0-8-3.58-8-8s3.58-8 8-8 8 3.58 8 8-3.58 8-8 8Z"/></svg></span>
      <%= request.getParameter("errorMessage") %>
    </div>
  <% } %>

  <div class="restaurant-hero">
    <div class="hero-content">
      <div class="restaurant-title">
        <h1>Delicious Menu</h1>
        <p>Explore our wide range of carefully crafted dishes prepared with the finest ingredients.</p>
      </div>
      <div class="quick-info">
        <span><span class="icon" style="color:var(--orange)"><svg><use href="#i-star"/></svg></span> 4.8 Rating</span>
        <span><span class="icon"><svg><use href="#i-clock"/></svg></span> 25-35 min delivery</span>
      </div>
    </div>
  </div>

  <section class="tabs-bar">
    <div class="tabs-inner w">
      <div class="tabs">
        <a class="tab active" href="#menu"><span class="icon"><svg><use href="#i-bowl"/></svg></span> Menu</a>
        <a class="tab" href="#"><span class="icon"><svg><use href="#i-star"/></svg></span> Reviews</a>
        <a class="tab" href="#"><span class="icon"><svg><use href="#i-info"/></svg></span> Info</a>
      </div>
      <div class="menu-tools">
        <label class="menu-search">
          <span class="icon"><svg><use href="#i-search"/></svg></span>
          <input type="search" placeholder="Search in menu...">
        </label>
        <span class="veg-switch">Veg Only <span class="switch"></span></span>
      </div>
    </div>
  </section>

  <div class="page-shell w" id="menu">
    <aside class="sidebar">
      <h2>Categories</h2>
      <nav class="category-list">
        <a class="active" href="#bestsellers"><span class="icon"><svg><use href="#i-flame"/></svg></span> Bestsellers</a>
        <a href="#biryani"><span class="icon"><svg><use href="#i-restaurant"/></svg></span> Biryani</a>
        <a href="#starters"><span class="icon"><svg viewBox="0 0 24 24"><path fill="currentColor" d="M12 3L4 9v12h16V9l-8-6zm0 2.5l5 3.75V20H7v-10.75l5-3.75z" opacity=".5"/></svg></span> Starters</a>
        <a href="#curries"><span class="icon"><svg><use href="#i-bowl"/></svg></span> Curries</a>
        <a href="#combos"><span class="icon"><svg viewBox="0 0 24 24"><path fill="currentColor" d="M22 4h-2V2h-2v2h-2v2h2v2h2V6h2V4z" opacity=".5"/></svg></span> Combos</a>
        <a href="#desserts"><span class="icon"><svg viewBox="0 0 24 24"><circle cx="12" cy="12" r="3.5" fill="currentColor"/></svg></span> Desserts</a>
        <a href="#beverages"><span class="icon"><svg viewBox="0 0 24 24"><path fill="currentColor" d="M7 18c-1.1 0-1.99.9-1.99 2S5.9 22 7 22s2-.9 2-2-.9-2-2-2ZM2 4h2l3.6 7.59-1.35 2.44C5.52 15.27 6.48 17 8 17h9v-2H8.42c-.14 0-.25-.11-.25-.25l.03-.12.9-1.63h5.45c.75 0 1.41-.41 1.75-1.03L19.9 6H6.21l-.94-2H2v2Z"/></svg></span> Beverages</a>
      </nav>
      <div class="side-offer">
        <strong>Flat 50% OFF</strong>
        <small>Use code TASTY50 and get 50% OFF on your first order.</small>
      </div>
    </aside>

    <section class="menu-section" id="bestsellers">
      <h2><span class="icon"><svg><use href="#i-flame"/></svg></span> Bestsellers</h2>
      <div class="menu-grid">
        <%
        List<Menu> allMenusByRestaurant = (List<Menu>)request.getAttribute("allMenusByRestaurant");
        if(allMenusByRestaurant != null && !allMenusByRestaurant.isEmpty()){
            for(Menu menu : allMenusByRestaurant){
        %>
        <article class="menu-card">
            <div class="food-image">
                <img src="<%= menu.getImagePath() %>" alt="<%= menu.getItemName() %>">
                <span class="food-type non-veg" aria-label="Non vegetarian"></span>
                <span class="best-tag"><%= menu.getCategory() %></span>
            </div>
            <div class="food-body">
                <h3><%= menu.getItemName() %></h3>
                <p class="description"><%= menu.getDescription() %></p>
                <div class="rating-row">
                    <span class="stars"><span class="icon"><svg><use href="#i-star"/></svg></span> <%= menu.getRating() %></span>
                </div>
                <div class="price-row">
                    <span class="price">&#8377; <%= menu.getPrice() %></span>
                    <form action="cart" method="POST" style="display:inline;">
                        <input type="hidden" name="action" value="add">
                        <input type="hidden" name="menuId" value="<%= menu.getMenuId() %>">
                        <button class="add-btn" type="submit">
                            <span class="icon"><svg><use href="#i-plus"/></svg></span> Add
                        </button>
                    </form>
                </div>
            </div>
        </article>
        <%
            }
        } else {
        %>
        <div class="empty-state">
            <span class="icon"><svg><use href="#i-bowl"/></svg></span>
            <h3>No Menu Available</h3>
            <p>We're updating our menu. Check back soon!</p>
        </div>
        <% } %>
      </div>
    </section>
  </div>

  <footer class="footer w">
    <div class="footer-top">
      <div>
        <div class="ft-brand">
          <div class="ft-logo"><svg viewBox="0 0 24 24"><use href="#i-bowl"/></svg></div>
          <span class="ft-name">TastyBowl</span>
        </div>
        <p class="ft-desc">Your go-to platform for fast, fresh &amp; delicious food.</p>
        <div class="ft-socials">
          <a class="ft-social" href="#"><span class="icon"><svg viewBox="0 0 24 24"><path fill="currentColor" d="M22 12c0-5.52-4.48-10-10-10S2 6.48 2 12c0 4.84 3.44 8.87 8 9.8V15H8v-3h2V9.5C10 7.57 11.57 6 13.5 6H16v3h-2c-.55 0-1 .45-1 1v2h3v3h-3v6.95c5.05-.5 9-4.76 9-9.95Z"/></svg></span></a>
          <a class="ft-social" href="#"><span class="icon"><svg viewBox="0 0 24 24"><path fill="currentColor" d="M7.8 2h8.4C19.4 2 22 4.6 22 7.8v8.4a5.8 5.8 0 0 1-5.8 5.8H7.8C4.6 22 2 19.4 2 16.2V7.8A5.8 5.8 0 0 1 7.8 2Zm-.2 2A3.6 3.6 0 0 0 4 7.6v8.8C4 18.39 5.61 20 7.6 20h8.8a3.6 3.6 0 0 0 3.6-3.6V7.6C20 5.61 18.39 4 16.4 4H7.6ZM12 7a5 5 0 1 1 0 10 5 5 0 0 1 0-10Zm0 2a3 3 0 1 0 0 6 3 3 0 0 0 0-6Z"/></svg></span></a>
          <a class="ft-social" href="#"><span class="icon"><svg viewBox="0 0 24 24"><path fill="currentColor" d="M22.46 6c-.77.35-1.6.58-2.46.69.88-.53 1.56-1.37 1.88-2.38-.83.5-1.75.85-2.72 1.05C18.37 4.5 17.26 4 16 4c-2.35 0-4.27 1.92-4.27 4.29 0 .34.04.67.11.98C8.28 9.09 5.11 7.38 3 4.79c-.37.63-.58 1.37-.58 2.15 0 1.49.75 2.81 1.91 3.56-.71 0-1.37-.2-1.95-.5v.03c0 2.08 1.48 3.82 3.44 4.21a4.22 4.22 0 0 1-1.93.07 4.28 4.28 0 0 0 4 2.98 8.52 8.52 0 0 1-5.33 1.84c-.34 0-.68-.02-1.02-.06C3.44 20.29 5.7 21 8.12 21 16 21 20.33 14.46 20.33 8.79c0-.19 0-.37-.01-.56.84-.6 1.56-1.36 2.14-2.23Z"/></svg></span></a>
        </div>
      </div>
      <div class="ft-col"><h5>Company</h5><ul><li><a href="#">About Us</a></li><li><a href="#">Careers</a></li><li><a href="#">Blog</a></li></ul></div>
      <div class="ft-col"><h5>Help</h5><ul><li><a href="#">FAQ</a></li><li><a href="#">Contact Us</a></li><li><a href="#">Track Order</a></li></ul></div>
      <div class="ft-col"><h5>Legal</h5><ul><li><a href="#">Privacy Policy</a></li><li><a href="#">Terms of Service</a></li></ul></div>
      <div class="ft-app">
        <h5>Download Our App</h5>
        <a class="app-btn" href="#"><span class="icon"><svg viewBox="0 0 24 24"><path fill="currentColor" d="M3 20.5v-17c0-.59.34-1.11.84-1.35L13.69 12l-9.85 9.85c-.5-.24-.84-.76-.84-1.35Zm13.81-5.38L6.05 21.34l8.49-8.49 2.27 2.27Zm3.35-1.72c.49.27.84.79.84 1.38s-.35 1.11-.84 1.38L17.3 12l2.86-1.28ZM6.05 2.66l10.76 6.22-2.27 2.27L6.05 2.66Z"/></svg></span><div><small>GET IT ON</small><strong>Google Play</strong></div></a>
        <a class="app-btn" href="#"><span class="icon"><svg viewBox="0 0 24 24"><path fill="currentColor" d="M18.71 19.5c-.83 1.24-1.71 2.45-3.05 2.47-1.34.03-1.77-.79-3.29-.79-1.53 0-2 .77-3.27.82-1.31.05-2.3-1.32-3.14-2.53C4.25 17 2.94 12.45 4.7 9.39c.87-1.52 2.43-2.48 4.12-2.51 1.28-.02 2.5.87 3.29.87.78 0 2.26-1.07 3.8-.91.65.03 2.47.26 3.64 1.98-.09.06-2.17 1.28-2.15 3.81.03 3.02 2.65 4.03 2.68 4.04-.03.07-.42 1.44-1.38 2.83ZM13 3.5c.73-.83 1.94-1.46 2.94-1.5.13 1.17-.34 2.35-1.04 3.19-.69.85-1.83 1.51-2.95 1.42-.15-1.15.41-2.35 1.05-3.11Z"/></svg></span><div><small>Download on the</small><strong>App Store</strong></div></a>
      </div>
    </div>
    <div class="footer-bottom">
      <p>&copy; 2024 TastyBowl. All rights reserved.</p>
      <div style="display:flex;align-items:center;gap:4px">Made with <span class="icon" style="width:14px;height:14px;color:#e53935"><svg><use href="#i-heart"/></svg></span> for food lovers</div>
    </div>
  </footer>

</body>
</html>
