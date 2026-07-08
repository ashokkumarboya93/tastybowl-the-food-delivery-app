<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, java.util.Map, com.food.model.Restaurant, com.food.model.CartItem, com.food.model.User" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>TastyBowl - Delicious Food Delivered Fast</title>
  <meta name="description" content="Order from top restaurants near you. Fast delivery, great food, unbeatable prices.">
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

    /* SVG Icon base */
    .icon{display:inline-flex;align-items:center;justify-content:center;flex-shrink:0}
    .icon svg{width:100%;height:100%}

    /* ═══════════════════════════════════════
       NAVBAR - Modern glassmorphism
    ═══════════════════════════════════════ */
    .nav-wrap{
      position:sticky;top:0;z-index:200;
      background:rgba(255,255,255,.92);
      backdrop-filter:blur(20px) saturate(1.4);
      -webkit-backdrop-filter:blur(20px) saturate(1.4);
      border-bottom:1px solid rgba(108,45,224,.08);
    }
    .nav{display:flex;align-items:center;gap:0;height:72px}

    /* Logo */
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

    /* Location pill */
    .nav-loc{
      display:flex;align-items:center;gap:8px;
      height:40px;padding:0 14px 0 10px;
      border:1.5px solid var(--line);border-radius:var(--r99);
      font-size:13px;font-weight:700;color:var(--mid);
      cursor:pointer;transition:all .16s;margin-left:auto;
    }
    .nav-loc:hover{border-color:var(--p);background:var(--p-bg);color:var(--p)}
    .nav-loc .icon{width:16px;height:16px;color:var(--p)}
    .nav-loc .caret{width:10px;height:10px;color:var(--muted)}

    /* Nav actions */
    .nav-actions{display:flex;align-items:center;gap:6px;margin-left:12px}
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

    /* ═══════════════════════════════════════
       HERO
    ═══════════════════════════════════════ */
    .hero{
      position:relative;overflow:hidden;
      background:linear-gradient(130deg,#3b0fa0 0%,#6c2de0 38%,#9345f8 72%,#a855f7 100%);
      padding-bottom:80px;
    }
    .hero::before{
      content:'';position:absolute;inset:0;
      background:
        radial-gradient(ellipse 600px 400px at 15% 60%,rgba(255,255,255,.08),transparent),
        radial-gradient(ellipse 400px 300px at 80% 20%,rgba(255,214,0,.1),transparent);
      pointer-events:none;
    }
    .hero-inner{
      display:grid;grid-template-columns:1fr 400px;
      align-items:center;gap:32px;
      position:relative;z-index:2;
    }

    /* Offer strip */
    .offer-strip{
      grid-column:1/-1;
      display:inline-flex;align-items:center;gap:8px;
      background:rgba(255,255,255,.1);backdrop-filter:blur(8px);
      border:1px solid rgba(255,255,255,.18);
      border-radius:var(--r8);padding:10px 16px;
      margin:20px 0 8px;width:fit-content;
      font-size:13px;font-weight:600;color:rgba(255,255,255,.9);
    }
    .offer-badge{
      background:var(--yellow);color:#1a0933;
      border-radius:4px;padding:3px 10px;
      font-size:11px;font-weight:900;letter-spacing:.03em;
    }

    .hero-copy{padding:8px 0 0}
    .hero h1{
      font-size:clamp(32px,4vw,54px);font-weight:900;
      line-height:1.08;color:#fff;letter-spacing:-0.5px;
    }
    .hero h1 .accent{
      font-family:'Pacifico',cursive;
      background:linear-gradient(135deg,#ffd600 0%,#ffb300 50%,#ff9800 100%);
      -webkit-background-clip:text;-webkit-text-fill-color:transparent;
      background-clip:text;
      filter:drop-shadow(0 3px 8px rgba(255,183,0,.5));
      font-size:1.05em;
      display:inline;
    }
    .hero-sub{
      margin-top:16px;font-size:16px;font-weight:500;
      color:rgba(255,255,255,.78);line-height:1.6;max-width:420px;
    }

    /* Search */
    .hero-search{
      display:flex;align-items:center;gap:0;
      height:56px;background:#fff;border-radius:var(--r12);
      box-shadow:0 12px 40px rgba(0,0,0,.22);
      margin-top:26px;overflow:hidden;
      border:2px solid rgba(255,255,255,.7);
      width:min(580px,100%);
    }
    .hs-field{
      display:flex;align-items:center;gap:10px;
      flex:1;padding:0 16px;height:100%;min-width:0;
    }
    .hs-field+.hs-field{border-left:1.5px solid var(--line)}
    .hs-field .icon{width:18px;height:18px;color:var(--p)}
    .hs-field input{
      flex:1;background:transparent;
      font-size:14px;font-weight:600;color:var(--ink);min-width:0;
    }
    .hs-field input::placeholder{color:#a89cc0;font-weight:500}
    .hs-btn{
      height:100%;padding:0 26px;
      background:var(--p);color:#fff;cursor:pointer;
      font-size:14px;font-weight:800;
      display:flex;align-items:center;gap:8px;
      transition:background .18s;white-space:nowrap;flex-shrink:0;
    }
    .hs-btn:hover{background:var(--p2)}
    .hs-btn .icon{width:16px;height:16px}

    /* Hero image */
    .hero-img{
      display:flex;align-items:flex-end;justify-content:center;
      height:320px;
    }
    .hero-img img{
      max-height:100%;max-width:100%;object-fit:contain;
      filter:drop-shadow(0 16px 40px rgba(0,0,0,.3));
    }

    /* Stats bar */
    .hero-stats{
      position:absolute;bottom:0;left:0;right:0;z-index:4;
      background:rgba(255,255,255,.96);backdrop-filter:blur(14px);
      border-top:1px solid rgba(108,45,224,.08);
    }
    .stats-row{display:flex;align-items:center;height:72px;gap:0}
    .hstat{
      display:flex;align-items:center;gap:14px;
      flex:1;padding:0 28px;
      border-right:1px solid var(--line);
    }
    .hstat:last-child{border-right:none}
    .hstat-icon{
      width:44px;height:44px;border-radius:var(--r12);
      display:grid;place-items:center;flex-shrink:0;
    }
    .hstat-icon .icon{width:22px;height:22px}
    .hstat:nth-child(1) .hstat-icon{background:#ede5ff;color:var(--p)}
    .hstat:nth-child(2) .hstat-icon{background:#fff3d6;color:#e08a00}
    .hstat:nth-child(3) .hstat-icon{background:#d9f5e4;color:var(--green)}
    .hstat:nth-child(4) .hstat-icon{background:#fff3d6;color:#e08a00}
    .hstat-val{font-size:18px;font-weight:900;color:var(--ink)}
    .hstat-label{font-size:12px;font-weight:600;color:var(--muted);margin-top:1px}

    /* ═══════════════════════════════════════
       CATEGORIES
    ═══════════════════════════════════════ */
    .cat-section{background:#fff;border-bottom:1px solid var(--line);padding:24px 0}
    .cat-strip{
      display:flex;align-items:center;gap:14px;
      overflow-x:auto;scrollbar-width:none;padding:4px 0;
    }
    .cat-strip::-webkit-scrollbar{display:none}
    .cat-item{
      display:flex;flex-direction:column;align-items:center;gap:10px;
      min-width:80px;padding:14px 10px 12px;
      border-radius:var(--r16);cursor:pointer;
      transition:all .2s;flex-shrink:0;
      border:2px solid transparent;background:transparent;
    }
    .cat-item:hover{background:var(--p-bg);border-color:rgba(108,45,224,.2);transform:translateY(-3px)}
    .cat-item.active{background:var(--p-bg);border-color:var(--p)}
    .cat-icon{
      width:56px;height:56px;border-radius:50%;
      display:grid;place-items:center;
      transition:transform .2s;
    }
    .cat-item:hover .cat-icon{transform:scale(1.08)}
    .cat-icon .icon{width:28px;height:28px}
    /* Unique bg per category */
    .cat-item:nth-child(1) .cat-icon{background:#ede5ff;color:var(--p)}
    .cat-item:nth-child(2) .cat-icon{background:#fff3e0;color:#e65100}
    .cat-item:nth-child(3) .cat-icon{background:#fce4ec;color:#c62828}
    .cat-item:nth-child(4) .cat-icon{background:#fff9c4;color:#f57f17}
    .cat-item:nth-child(5) .cat-icon{background:#e1f5fe;color:#0277bd}
    .cat-item:nth-child(6) .cat-icon{background:#fce4ec;color:#ad1457}
    .cat-item:nth-child(7) .cat-icon{background:#e8f5e9;color:#2e7d32}
    .cat-item:nth-child(8) .cat-icon{background:#e0f2f1;color:#00695c}
    .cat-item:nth-child(9) .cat-icon{background:#fff8e1;color:#ff8f00}
    .cat-item:nth-child(10) .cat-icon{background:#f3e5f5;color:#7b1fa2}
    .cat-label{font-size:12px;font-weight:700;color:var(--mid);text-align:center;white-space:nowrap}
    .cat-item.active .cat-label{color:var(--p);font-weight:800}

    /* ═══════════════════════════════════════
       FILTER BAR
    ═══════════════════════════════════════ */
    .filter-bar{
      background:#fff;border-bottom:1px solid var(--line);
      position:sticky;top:72px;z-index:100;
      box-shadow:0 2px 8px rgba(108,45,224,.05);
    }
    .filter-row{
      display:flex;align-items:center;gap:10px;
      height:56px;overflow-x:auto;scrollbar-width:none;
    }
    .filter-row::-webkit-scrollbar{display:none}
    .sort-group{
      display:flex;align-items:center;gap:6px;
      font-size:13px;font-weight:700;color:var(--mid);flex-shrink:0;
    }
    .sort-sel{
      border:1.5px solid var(--line);border-radius:var(--r8);
      padding:7px 12px;background:#fff;color:var(--ink);
      font-size:13px;font-weight:700;cursor:pointer;
    }
    .filter-divider{width:1px;height:26px;background:var(--line);flex-shrink:0}
    .fchip{
      display:flex;align-items:center;gap:6px;
      height:36px;padding:0 16px;
      border:1.5px solid var(--line);border-radius:var(--r99);
      font-size:13px;font-weight:700;color:var(--mid);
      cursor:pointer;white-space:nowrap;flex-shrink:0;
      transition:all .16s;background:#fff;
    }
    .fchip:hover,.fchip.active{border-color:var(--p);color:var(--p);background:var(--p-bg)}
    .fchip .icon{width:14px;height:14px}
    .fchip .veg-dot{width:8px;height:8px;border-radius:50%;background:var(--green);flex-shrink:0}
    .view-toggle{
      display:flex;align-items:center;gap:0;
      margin-left:auto;border:1.5px solid var(--line);border-radius:var(--r8);
      overflow:hidden;flex-shrink:0;
    }
    .vtbtn{
      width:38px;height:36px;display:grid;place-items:center;
      color:var(--muted);cursor:pointer;background:#fff;
      transition:all .16s;
    }
    .vtbtn .icon{width:16px;height:16px}
    .vtbtn.active{background:var(--p);color:#fff}

    /* ═══════════════════════════════════════
       RESTAURANT GRID
    ═══════════════════════════════════════ */
    .main-section{padding:32px 0 48px}
    .section-header{
      display:flex;align-items:center;justify-content:space-between;
      margin-bottom:24px;
    }
    .section-title{font-size:24px;font-weight:900;color:var(--ink)}
    .section-title span{color:var(--p)}
    .see-all{
      font-size:13px;font-weight:700;color:var(--p);
      display:flex;align-items:center;gap:4px;
    }
    .see-all:hover{text-decoration:underline}

    .rest-grid{
      display:grid;
      grid-template-columns:repeat(4,minmax(0,1fr));
      gap:22px;
    }
    .rest-card{
      background:#fff;border-radius:var(--r16);
      border:1.5px solid var(--line);
      overflow:hidden;cursor:pointer;
      transition:transform .22s,box-shadow .22s,border-color .22s;
      box-shadow:var(--sh);
    }
    .rest-card:hover{
      transform:translateY(-6px);
      box-shadow:var(--sh2);
      border-color:rgba(108,45,224,.22);
    }
    .card-img{position:relative;height:170px;overflow:hidden;background:#ede5ff}
    .card-img img{width:100%;height:100%;object-fit:cover;transition:transform .3s ease}
    .rest-card:hover .card-img img{transform:scale(1.06)}
    .card-img::after{
      content:'';position:absolute;inset:auto 0 0;height:50%;
      background:linear-gradient(180deg,transparent,rgba(0,0,0,.4));
      pointer-events:none;
    }
    .card-discount{
      position:absolute;top:10px;left:10px;z-index:1;
      background:linear-gradient(135deg,#e53935,#ff5252);
      color:#fff;font-size:11px;font-weight:900;
      padding:5px 10px;border-radius:6px;letter-spacing:.02em;
    }
    .card-save{
      position:absolute;top:10px;right:10px;z-index:1;
      width:32px;height:32px;border-radius:50%;
      background:rgba(255,255,255,.92);backdrop-filter:blur(4px);
      display:grid;place-items:center;
      transition:all .16s;
    }
    .card-save .icon{width:16px;height:16px;color:var(--muted)}
    .rest-card:hover .card-save .icon{color:var(--red)}
    .card-rating{
      position:absolute;bottom:10px;left:10px;z-index:1;
      display:flex;align-items:center;gap:4px;
      background:var(--green);color:#fff;
      border-radius:6px;padding:5px 10px;
      font-size:12px;font-weight:800;
    }
    .card-rating .icon{width:12px;height:12px}

    .card-body{padding:14px 15px 16px}
    .card-name{
      font-size:16px;font-weight:800;color:var(--ink);
      white-space:nowrap;overflow:hidden;text-overflow:ellipsis;margin-bottom:4px;
    }
    .card-cuisine{
      font-size:12px;font-weight:600;color:var(--muted);
      white-space:nowrap;overflow:hidden;text-overflow:ellipsis;margin-bottom:12px;
    }
    .card-meta{
      display:flex;align-items:center;gap:12px;
      font-size:12px;font-weight:700;color:var(--mid);
      border-top:1px solid var(--line);padding-top:12px;
    }
    .card-meta .meta-item{display:flex;align-items:center;gap:4px}
    .card-meta .meta-item .icon{width:14px;height:14px;color:var(--muted)}
    .card-meta .dot{width:3px;height:3px;border-radius:50%;background:var(--muted);flex-shrink:0}
    .card-free{
      display:inline-flex;align-items:center;gap:4px;
      margin-top:8px;font-size:11px;font-weight:800;color:var(--green);
    }
    .card-free .icon{width:14px;height:14px}

    .empty-state{
      grid-column:1/-1;padding:64px 24px;
      display:flex;flex-direction:column;align-items:center;gap:12px;
      background:#fff;border:1.5px dashed var(--line);border-radius:var(--r16);
      text-align:center;
    }
    .empty-state .icon{width:52px;height:52px;color:var(--muted)}
    .empty-state h3{font-size:20px;font-weight:800}
    .empty-state p{font-size:14px;color:var(--muted);font-weight:600}

    /* ═══════════════════════════════════════
       PROMO BANNER
    ═══════════════════════════════════════ */
    .promo-wrap{padding:0 0 48px}
    .promo-banner{
      border-radius:var(--r20);overflow:hidden;
      background:linear-gradient(110deg,#3b0fa0 0%,#6c2de0 45%,#9345f8 100%);
      display:grid;grid-template-columns:200px 1fr auto;
      align-items:center;position:relative;min-height:160px;
    }
    .promo-banner::before{
      content:'';position:absolute;inset:0;
      background:radial-gradient(circle at 15% 60%,rgba(255,255,255,.1),transparent 40%),
                 radial-gradient(circle at 85% 30%,rgba(255,214,0,.1),transparent 40%);
      pointer-events:none;
    }
    .promo-char{
      display:flex;align-items:flex-end;justify-content:center;
      height:100%;padding:0 0 0 16px;z-index:1;
    }
    .promo-char img{max-height:150px;object-fit:contain;filter:drop-shadow(0 8px 20px rgba(0,0,0,.2))}
    .promo-text{padding:28px 24px;z-index:1}
    .promo-tag{
      display:inline-flex;align-items:center;gap:6px;
      background:rgba(255,255,255,.15);border:1px solid rgba(255,255,255,.25);
      border-radius:4px;padding:4px 10px;
      font-size:11px;font-weight:800;color:rgba(255,255,255,.9);
      letter-spacing:.06em;text-transform:uppercase;margin-bottom:12px;
    }
    .promo-tag .icon{width:14px;height:14px}
    .promo-heading{
      font-size:clamp(22px,2.8vw,34px);font-weight:900;
      color:#fff;line-height:1.1;margin-bottom:6px;
    }
    .promo-heading .py{color:var(--yellow)}
    .promo-sub{font-size:14px;color:rgba(255,255,255,.78);font-weight:600}
    .promo-cta-wrap{
      display:flex;align-items:center;gap:14px;
      padding:28px 32px 28px 0;z-index:1;flex-shrink:0;
    }
    .promo-code{
      display:flex;align-items:center;gap:10px;
      background:rgba(255,255,255,.12);border:1.5px dashed rgba(255,255,255,.45);
      border-radius:var(--r8);padding:12px 18px;
    }
    .promo-code .code{font-size:20px;font-weight:900;color:var(--yellow);letter-spacing:.04em}
    .promo-code .icon{width:18px;height:18px;color:rgba(255,255,255,.7)}
    .promo-order{
      display:flex;align-items:center;gap:6px;
      height:48px;padding:0 24px;
      background:#fff;border-radius:var(--r8);
      color:var(--p2);font-size:14px;font-weight:900;
      white-space:nowrap;box-shadow:0 6px 20px rgba(0,0,0,.18);
      transition:transform .18s,box-shadow .18s;
    }
    .promo-order:hover{transform:scale(1.04);box-shadow:0 10px 28px rgba(0,0,0,.22)}

    /* ═══════════════════════════════════════
       FEATURES
    ═══════════════════════════════════════ */
    .features{padding:0 0 48px}
    .feat-grid{display:grid;grid-template-columns:repeat(4,1fr);gap:16px}
    .feat-card{
      background:#fff;border:1.5px solid var(--line);
      border-radius:var(--r16);padding:24px 18px;
      display:flex;align-items:center;gap:16px;
      transition:box-shadow .2s,border-color .2s;
    }
    .feat-card:hover{border-color:var(--p);box-shadow:var(--sh2)}
    .feat-icon{
      width:54px;height:54px;border-radius:var(--r12);
      display:grid;place-items:center;flex-shrink:0;
    }
    .feat-icon .icon{width:26px;height:26px}
    .feat-card:nth-child(1) .feat-icon{background:#ede5ff;color:var(--p)}
    .feat-card:nth-child(2) .feat-icon{background:#d9f5e4;color:var(--green)}
    .feat-card:nth-child(3) .feat-icon{background:#fff3d6;color:#e08a00}
    .feat-card:nth-child(4) .feat-icon{background:#ffe0e0;color:var(--red)}
    .feat-title{font-size:14px;font-weight:800;color:var(--ink);margin-bottom:3px}
    .feat-sub{font-size:12px;font-weight:600;color:var(--muted);line-height:1.45}

    /* ═══════════════════════════════════════
       FOOTER
    ═══════════════════════════════════════ */
    .footer{background:var(--ink);color:rgba(255,255,255,.6)}
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

    .scroll-top{
      position:fixed;bottom:24px;right:24px;z-index:999;
      width:44px;height:44px;border-radius:50%;
      background:var(--p);color:#fff;display:grid;place-items:center;
      box-shadow:0 6px 20px rgba(108,45,224,.4);cursor:pointer;
      transition:transform .18s;
    }
    .scroll-top:hover{transform:scale(1.08)}
    .scroll-top .icon{width:20px;height:20px}

    /* Animations */
    @keyframes fadeUp{from{opacity:0;transform:translateY(18px)}to{opacity:1;transform:translateY(0)}}
    .hero-copy>*{opacity:0;animation:fadeUp .55s ease forwards}
    .offer-strip{animation-delay:.05s}
    .hero h1{animation-delay:.15s}
    .hero-sub{animation-delay:.25s}
    .hero-search{animation-delay:.35s}
    @keyframes cardIn{from{opacity:0;transform:translateY(12px)}to{opacity:1;transform:translateY(0)}}
    .rest-card{animation:cardIn .4s ease both}
    .rest-card:nth-child(1){animation-delay:.06s}
    .rest-card:nth-child(2){animation-delay:.12s}
    .rest-card:nth-child(3){animation-delay:.18s}
    .rest-card:nth-child(4){animation-delay:.24s}
    .rest-card:nth-child(5){animation-delay:.30s}
    .rest-card:nth-child(6){animation-delay:.36s}
    .rest-card:nth-child(7){animation-delay:.42s}
    .rest-card:nth-child(8){animation-delay:.48s}

    /* Responsive */
    @media(max-width:1100px){
      .rest-grid{grid-template-columns:repeat(3,1fr)}
      .footer-top{grid-template-columns:1fr 1fr 1fr}
      .ft-app{grid-column:1/-1}
    }
    @media(max-width:880px){
      .hero-inner{grid-template-columns:1fr}
      .hero-img{display:none}
      .rest-grid{grid-template-columns:repeat(2,1fr)}
      .feat-grid{grid-template-columns:repeat(2,1fr)}
      .promo-banner{grid-template-columns:1fr auto}
      .promo-char{display:none}
      .footer-top{grid-template-columns:1fr 1fr}
    }
    @media(max-width:600px){
      .nav-links{display:none}
      .rest-grid{grid-template-columns:1fr}
      .feat-grid{grid-template-columns:1fr}
      .promo-banner{grid-template-columns:1fr}
      .promo-cta-wrap{padding:0 16px 20px;flex-wrap:wrap}
      .hstat-label{display:none}
      .footer-top{grid-template-columns:1fr}
      .hero-search{flex-wrap:wrap;height:auto;padding:4px;border-radius:var(--r12)}
      .hs-field{height:48px}
      .hs-field+.hs-field{border-left:none;border-top:1.5px solid var(--line)}
      .hs-btn{height:44px;width:100%;justify-content:center;border-radius:var(--r8);margin:4px}
    }
  </style>
</head>
<%
  User loggedInUser = (User) session.getAttribute("loggedInUser");
  @SuppressWarnings("unchecked")
  Map<Integer, CartItem> sessionCart = (Map<Integer, CartItem>) session.getAttribute("cart");
  int cartItemCount = 0;
  if (sessionCart != null) { for (CartItem ci : sessionCart.values()) cartItemCount += ci.getQuantity(); }
%>
<body>

<!-- ══════ SVG SPRITE (hidden) ══════ -->
<svg xmlns="http://www.w3.org/2000/svg" style="display:none">
  <symbol id="i-bowl" viewBox="0 0 24 24"><path fill="currentColor" d="M1 10a1 1 0 0 1 1-1h20a1 1 0 0 1 .92 1.39C21.55 14.4 17.83 17 14.28 17H9.72c-3.55 0-7.27-2.6-8.64-6.61A1 1 0 0 1 1 10Zm4.5 9h13a.5.5 0 0 1 0 1h-13a.5.5 0 0 1 0-1Z"/><path fill="currentColor" d="M10 3c0-.55.45-1 1-1h2a1 1 0 1 1 0 2h-1v3h-1V4h-.5A.5.5 0 0 1 10 3Z" opacity=".5"/></symbol>
  <symbol id="i-search" viewBox="0 0 24 24"><path fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" d="M21 21l-4.35-4.35M11 19a8 8 0 1 0 0-16 8 8 0 0 0 0 16Z"/></symbol>
  <symbol id="i-pin" viewBox="0 0 24 24"><path fill="currentColor" d="M12 2C8.13 2 5 5.13 5 9c0 5.25 7 13 7 13s7-7.75 7-13c0-3.87-3.13-7-7-7Zm0 9.5a2.5 2.5 0 1 1 0-5 2.5 2.5 0 0 1 0 5Z"/></symbol>
  <symbol id="i-cart" viewBox="0 0 24 24"><path fill="currentColor" d="M7 18c-1.1 0-2 .9-2 2s.9 2 2 2 2-.9 2-2-.9-2-2-2Zm10 0c-1.1 0-2 .9-2 2s.9 2 2 2 2-.9 2-2-.9-2-2-2ZM7.16 14.26l-.02.12c0 .34.28.62.62.62h11.49c.67 0 1.24-.42 1.47-1.03L23.16 7H5.21l-.94-2H1v2h2l3.6 7.59-1.35 2.44C4.52 18.27 5.48 20 7 20h12v-2H7.42c-.14 0-.25-.11-.25-.25l.03-.12.9-1.63h7.45c.75 0 1.41-.41 1.75-1.03l3.58-6.49c.08-.14.12-.31.12-.48 0-.55-.45-1-1-1H5.21l-.94-2H1v2h2l3.6 7.59Z"/></symbol>
  <symbol id="i-star" viewBox="0 0 24 24"><path fill="currentColor" d="M12 17.27L18.18 21l-1.64-7.03L22 9.24l-7.19-.61L12 2 9.19 8.63 2 9.24l5.46 4.73L5.82 21z"/></symbol>
  <symbol id="i-clock" viewBox="0 0 24 24"><path fill="currentColor" d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2Zm0 18c-4.42 0-8-3.58-8-8s3.58-8 8-8 8 3.58 8 8-3.58 8-8 8Zm.5-13H11v6l5.25 3.15.75-1.23-4.5-2.67Z"/></symbol>
  <symbol id="i-truck" viewBox="0 0 24 24"><path fill="currentColor" d="M20 8h-3V4H1v13h2c0 1.66 1.34 3 3 3s3-1.34 3-3h6c0 1.66 1.34 3 3 3s3-1.34 3-3h2v-5l-3-4ZM6 18.5c-.83 0-1.5-.67-1.5-1.5s.67-1.5 1.5-1.5 1.5.67 1.5 1.5-.67 1.5-1.5 1.5ZM20 9.5l2.46 3.5H17V9.5h3Zm-2 9c-.83 0-1.5-.67-1.5-1.5s.67-1.5 1.5-1.5 1.5.67 1.5 1.5-.67 1.5-1.5 1.5Z"/></symbol>
  <symbol id="i-check" viewBox="0 0 24 24"><path fill="currentColor" d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2Zm-2 15-5-5 1.41-1.41L10 14.17l7.59-7.59L19 8l-9 9Z"/></symbol>
  <symbol id="i-zap" viewBox="0 0 24 24"><path fill="currentColor" d="M13 2L3 14h8l-1 8 10-12h-8l1-8Z"/></symbol>
  <symbol id="i-heart" viewBox="0 0 24 24"><path fill="currentColor" d="M12 21.35l-1.45-1.32C5.4 15.36 2 12.28 2 8.5 2 5.42 4.42 3 7.5 3c1.74 0 3.41.81 4.5 2.09C13.09 3.81 14.76 3 16.5 3 19.58 3 22 5.42 22 8.5c0 3.78-3.4 6.86-8.55 11.54L12 21.35Z"/></symbol>
  <symbol id="i-grid" viewBox="0 0 24 24"><path fill="currentColor" d="M3 3h7v7H3zm11 0h7v7h-7zM3 14h7v7H3zm11 0h7v7h-7z"/></symbol>
  <symbol id="i-list" viewBox="0 0 24 24"><path fill="currentColor" d="M3 13h2v-2H3v2Zm0 4h2v-2H3v2Zm0-8h2V7H3v2Zm4 4h14v-2H7v2Zm0 4h14v-2H7v2ZM7 7v2h14V7H7Z"/></symbol>
  <symbol id="i-shield" viewBox="0 0 24 24"><path fill="currentColor" d="M12 1L3 5v6c0 5.55 3.84 10.74 9 12 5.16-1.26 9-6.45 9-12V5l-9-4Zm-2 16-4-4 1.41-1.41L10 14.17l6.59-6.59L18 9l-8 8Z"/></symbol>
  <symbol id="i-tag" viewBox="0 0 24 24"><path fill="currentColor" d="M21.41 11.58l-9-9C12.05 2.22 11.55 2 11 2H4c-1.1 0-2 .9-2 2v7c0 .55.22 1.05.59 1.42l9 9c.36.36.86.58 1.41.58.55 0 1.05-.22 1.41-.59l7-7c.37-.36.59-.86.59-1.41 0-.55-.23-1.06-.59-1.42ZM5.5 7C4.67 7 4 6.33 4 5.5S4.67 4 5.5 4 7 4.67 7 5.5 6.33 7 5.5 7Z"/></symbol>
  <symbol id="i-headset" viewBox="0 0 24 24"><path fill="currentColor" d="M12 1c-4.97 0-9 4.03-9 9v7c0 1.66 1.34 3 3 3h3v-8H5v-2c0-3.87 3.13-7 7-7s7 3.13 7 7v2h-4v8h3c1.66 0 3-1.34 3-3v-7c0-4.97-4.03-9-9-9Z"/></symbol>
  <symbol id="i-gift" viewBox="0 0 24 24"><path fill="currentColor" d="M20 6h-2.18c.11-.31.18-.65.18-1a3 3 0 0 0-3-3c-1.05 0-1.95.54-2.48 1.35L12 4.02l-.52-.67A2.99 2.99 0 0 0 9 2a3 3 0 0 0-3 3c0 .35.07.69.18 1H4c-1.11 0-1.99.89-1.99 2L2 19c0 1.11.89 2 2 2h16c1.11 0 2-.89 2-2V8c0-1.11-.89-2-2-2Zm-5-2c.55 0 1 .45 1 1s-.45 1-1 1-1-.45-1-1 .45-1 1-1ZM9 4c.55 0 1 .45 1 1s-.45 1-1 1-1-.45-1-1 .45-1 1-1Zm11 15H4v-2h16v2Zm0-5H4V8h5.08L7 10.83 8.62 12 11 8.76l1-1.36 1 1.36L15.38 12 17 10.83 14.92 8H20v6Z"/></symbol>
  <symbol id="i-up" viewBox="0 0 24 24"><path fill="currentColor" d="M7.41 15.41 12 10.83l4.59 4.58L18 14l-6-6-6 6z"/></symbol>
  <symbol id="i-down" viewBox="0 0 24 24"><path fill="currentColor" d="M7.41 8.59 12 13.17l4.59-4.58L18 10l-6 6-6-6 1.41-1.41Z"/></symbol>
  <symbol id="i-restaurant" viewBox="0 0 24 24"><path fill="currentColor" d="M11 9H9V2H7v7H5V2H3v7c0 2.12 1.66 3.84 3.75 3.97V22h2.5v-9.03C11.34 12.84 13 11.12 13 9V2h-2v7Zm5-3v8h2.5v8H21V2c-2.76 0-5 2.24-5 4Z"/></symbol>
  <symbol id="i-scissors" viewBox="0 0 24 24"><path fill="currentColor" d="M9.64 7.64c.23-.5.36-1.05.36-1.64 0-2.21-1.79-4-4-4S2 3.79 2 6s1.79 4 4 4c.59 0 1.14-.13 1.64-.36L10 12l-2.36 2.36C7.14 14.13 6.59 14 6 14c-2.21 0-4 1.79-4 4s1.79 4 4 4 4-1.79 4-4c0-.59-.13-1.14-.36-1.64L12 14l7 7h3v-1L9.64 7.64ZM6 8c-1.1 0-2-.89-2-2s.9-2 2-2 2 .89 2 2-.9 2-2 2Zm0 12c-1.1 0-2-.89-2-2s.9-2 2-2 2 .89 2 2-.9 2-2 2Zm6-7.5c-.28 0-.5-.22-.5-.5s.22-.5.5-.5.5.22.5.5-.22.5-.5.5ZM19 3l-6 6 2 2 7-7V3h-3Z"/></symbol>
</svg>

<!-- ══════ NAVBAR ══════ -->
<header class="nav-wrap">
  <nav class="nav w">
    <a class="logo" href="callRestaurantServlet">
      <div class="logo-mark">
        <svg viewBox="0 0 24 24"><use href="#i-bowl"/></svg>
      </div>
      <span class="logo-text">TastyBowl</span>
    </a>

    <ul class="nav-links">
      <li><a class="active" href="callRestaurantServlet">Home</a></li>
      <li><a href="callRestaurantServlet">Restaurants</a></li>
      <li><a href="#">Offers</a></li>
      <li><a href="orders">My Orders</a></li>
      <li><a href="profile">Profile</a></li>
    </ul>

    <div class="nav-loc">
      <span class="icon"><svg><use href="#i-pin"/></svg></span>
      <span>Bangalore</span>
      <span class="icon caret"><svg><use href="#i-down"/></svg></span>
    </div>

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

<!-- ══════ HERO ══════ -->
<section class="hero">
  <div class="hero-inner w">
    <div class="offer-strip">
      <span class="offer-badge">FLAT 50% OFF</span>
      on your first order &mdash; Code: <strong style="color:var(--yellow);margin-left:4px">TASTY50</strong>
    </div>

    <div class="hero-copy">
      <h1>
        Delicious food,<br>
        delivered fast<br>
        to <span class="accent">your doorstep</span>
      </h1>
      <p class="hero-sub">Discover top restaurants near you with exciting offers and super fast delivery.</p>

      <form class="hero-search" id="heroForm">
        <div class="hs-field">
          <span class="icon"><svg><use href="#i-search"/></svg></span>
          <input id="searchInput" type="text" placeholder="Search for restaurants or cuisines..." autocomplete="off">
        </div>
        <div class="hs-field">
          <span class="icon"><svg><use href="#i-pin"/></svg></span>
          <input type="text" placeholder="Enter delivery location" autocomplete="off">
        </div>
        <button class="hs-btn" type="submit">
          Find Food
          <span class="icon" style="width:14px;height:14px"><svg viewBox="0 0 24 24"><path fill="currentColor" d="M12 4l-1.41 1.41L16.17 11H4v2h12.17l-5.58 5.59L12 20l8-8z"/></svg></span>
        </button>
      </form>
    </div>

    <div class="hero-img">
      <img src="images/delivery_hero.png" alt="TastyBowl delivery" onerror="this.onerror=null;this.style.maxHeight='200px';this.src='https://cdn-icons-png.flaticon.com/512/8512/8512332.png'">
    </div>
  </div>

  <div class="hero-stats">
    <div class="stats-row w">
      <div class="hstat">
        <div class="hstat-icon"><span class="icon"><svg><use href="#i-restaurant"/></svg></span></div>
        <div><div class="hstat-val">500+</div><div class="hstat-label">Restaurants</div></div>
      </div>
      <div class="hstat">
        <div class="hstat-icon"><span class="icon"><svg><use href="#i-clock"/></svg></span></div>
        <div><div class="hstat-val">25-35 min</div><div class="hstat-label">Delivery Time</div></div>
      </div>
      <div class="hstat">
        <div class="hstat-icon"><span class="icon"><svg><use href="#i-check"/></svg></span></div>
        <div><div class="hstat-val">99.2%</div><div class="hstat-label">On-time Delivery</div></div>
      </div>
      <div class="hstat">
        <div class="hstat-icon"><span class="icon"><svg><use href="#i-star"/></svg></span></div>
        <div><div class="hstat-val">4.8+</div><div class="hstat-label">Avg Rating</div></div>
      </div>
    </div>
  </div>
</section>

<!-- ══════ CATEGORIES ══════ -->
<div class="cat-section">
  <div class="cat-strip w">
    <div class="cat-item active" onclick="setCat(this)">
      <div class="cat-icon"><span class="icon"><svg><use href="#i-grid"/></svg></span></div>
      <span class="cat-label">All</span>
    </div>
    <div class="cat-item" onclick="setCat(this)">
      <div class="cat-icon"><span class="icon"><svg viewBox="0 0 24 24"><path fill="currentColor" d="M18.06 22.99h1.66c.84 0 1.53-.65 1.63-1.48L23 5.05h-5V1h-1.97v4.05h-4.97l.3 2.34c1.71.47 3.31 1.32 4.27 2.26 1.44 1.42 2.43 2.89 2.43 5.29v8.05ZM1 21.99V21h15.03v.99c0 .55-.45 1-1.01 1H2.01c-.56 0-1.01-.45-1.01-1Zm15.03-7c0-4-6.03-5-7.51-5s-7.52 1-7.52 5v5h15.03v-5Z"/></svg></span></div>
      <span class="cat-label">Burgers</span>
    </div>
    <div class="cat-item" onclick="setCat(this)">
      <div class="cat-icon"><span class="icon"><svg viewBox="0 0 24 24"><path fill="currentColor" d="M12 2C8.43 2 5.23 3.54 3.01 6L12 22l8.99-16C18.78 3.55 15.57 2 12 2ZM7 7c0-.55.45-1 1-1s1 .45 1 1-.45 1-1 1-1-.45-1-1Zm2 4c0-.55.45-1 1-1s1 .45 1 1-.45 1-1 1-1-.45-1-1Zm2-3c0-.55.45-1 1-1s1 .45 1 1-.45 1-1 1-1-.45-1-1Zm3 3c0-.55.45-1 1-1s1 .45 1 1-.45 1-1 1-1-.45-1-1Z"/></svg></span></div>
      <span class="cat-label">Pizza</span>
    </div>
    <div class="cat-item" onclick="setCat(this)">
      <div class="cat-icon"><span class="icon"><svg><use href="#i-restaurant"/></svg></span></div>
      <span class="cat-label">Biryani</span>
    </div>
    <div class="cat-item" onclick="setCat(this)">
      <div class="cat-icon"><span class="icon"><svg><use href="#i-bowl"/></svg></span></div>
      <span class="cat-label">Chinese</span>
    </div>
    <div class="cat-item" onclick="setCat(this)">
      <div class="cat-icon"><span class="icon"><svg viewBox="0 0 24 24"><path fill="currentColor" d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2Zm1 15h-2v-2h2v2Zm0-4h-2V7h2v6Z"/></svg></span></div>
      <span class="cat-label">Desserts</span>
    </div>
    <div class="cat-item" onclick="setCat(this)">
      <div class="cat-icon"><span class="icon"><svg viewBox="0 0 24 24"><path fill="currentColor" d="M7 18c-1.1 0-1.99.9-1.99 2S5.9 22 7 22s2-.9 2-2-.9-2-2-2ZM2 4h2l3.6 7.59-1.35 2.44C5.52 15.27 6.48 17 8 17h9v-2H8.42c-.14 0-.25-.11-.25-.25l.03-.12.9-1.63h5.45c.75 0 1.41-.41 1.75-1.03L19.9 6H6.21l-.94-2H2v2Zm16 14c-1.1 0-1.99.9-1.99 2s.89 2 1.99 2 2-.9 2-2-.9-2-2-2Z"/></svg></span></div>
      <span class="cat-label">Drinks</span>
    </div>
    <div class="cat-item" onclick="setCat(this)">
      <div class="cat-icon"><span class="icon"><svg viewBox="0 0 24 24"><circle cx="12" cy="12" r="3.5" fill="currentColor"/><path fill="currentColor" d="M12 2a10 10 0 1 0 0 20 10 10 0 0 0 0-20Zm0 18a8 8 0 1 1 0-16 8 8 0 0 1 0 16Z" opacity=".3"/></svg></span></div>
      <span class="cat-label">Healthy</span>
    </div>
    <div class="cat-item" onclick="setCat(this)">
      <div class="cat-icon"><span class="icon"><svg><use href="#i-restaurant"/></svg></span></div>
      <span class="cat-label">South Indian</span>
    </div>
    <div class="cat-item" onclick="setCat(this)">
      <div class="cat-icon"><span class="icon"><svg><use href="#i-tag"/></svg></span></div>
      <span class="cat-label">Offers</span>
    </div>
  </div>
</div>

<!-- ══════ FILTER BAR ══════ -->
<div class="filter-bar">
  <div class="filter-row w">
    <div class="sort-group">
      Sort By:
      <select class="sort-sel" aria-label="Sort options">
        <option>Popularity</option><option>Rating</option><option>Delivery Time</option><option>Price</option>
      </select>
    </div>
    <div class="filter-divider"></div>
    <button class="fchip" onclick="this.classList.toggle('active')">
      <span class="icon" style="width:14px;height:14px"><svg><use href="#i-zap"/></svg></span> Fast Delivery
    </button>
    <button class="fchip" onclick="this.classList.toggle('active')">
      <span class="veg-dot"></span> Pure Veg
    </button>
    <button class="fchip" onclick="this.classList.toggle('active')">
      <span class="icon" style="width:14px;height:14px"><svg><use href="#i-star"/></svg></span> Rating 4.0+
    </button>
    <button class="fchip" onclick="this.classList.toggle('active')">
      <span class="icon" style="width:14px;height:14px"><svg><use href="#i-clock"/></svg></span> Under 30 min
    </button>
    <div class="view-toggle">
      <button class="vtbtn active" id="gridBtn" onclick="setView('grid')"><span class="icon"><svg><use href="#i-grid"/></svg></span></button>
      <button class="vtbtn" id="listBtn" onclick="setView('list')"><span class="icon"><svg><use href="#i-list"/></svg></span></button>
    </div>
  </div>
</div>

<!-- ══════ RESTAURANTS ══════ -->
<main>
  <section class="main-section">
    <div class="w">
      <div class="section-header">
        <h2 class="section-title">Popular <span>Restaurants</span></h2>
        <a class="see-all" href="#">See all <span class="icon" style="width:14px;height:14px"><svg viewBox="0 0 24 24"><path fill="currentColor" d="M12 4l-1.41 1.41L16.17 11H4v2h12.17l-5.58 5.59L12 20l8-8z"/></svg></span></a>
      </div>

      <div class="rest-grid" id="restGrid">
        <%
          List<Restaurant> allRestaurant = (List<Restaurant>) request.getAttribute("allRestaurant");
          String[] discounts = {"50% OFF","30% OFF","20% OFF","40% OFF","50% OFF","30% OFF","20% OFF","30% OFF"};
          int di = 0;
          if (allRestaurant != null && !allRestaurant.isEmpty()) {
            for (Restaurant r : allRestaurant) {
              String disc = discounts[di % discounts.length]; di++;
        %>
        <article class="rest-card" data-name="<%=r.getName().toLowerCase()%>" data-cuisine="<%=r.getCuisineType().toLowerCase()%>">
          <a href="menu?restaurantID=<%=r.getRestaurantId()%>" style="display:block;color:inherit">
            <div class="card-img">
              <img src="<%=r.getImagePath()%>" alt="<%=r.getName()%>" loading="lazy">
              <span class="card-discount"><%=disc%></span>
              <span class="card-save"><span class="icon"><svg><use href="#i-heart"/></svg></span></span>
              <span class="card-rating"><span class="icon"><svg><use href="#i-star"/></svg></span> <%=r.getRating()%></span>
            </div>
            <div class="card-body">
              <div class="card-name"><%=r.getName()%></div>
              <div class="card-cuisine"><%=r.getCuisineType()%></div>
              <div class="card-meta">
                <span class="meta-item"><span class="icon"><svg><use href="#i-clock"/></svg></span> <%=r.getDeliveryTime()%> min</span>
                <span class="dot"></span>
                <span class="meta-item"><span class="icon"><svg><use href="#i-pin"/></svg></span> 1.2 km</span>
                <span class="dot"></span>
                <span class="meta-item">&#8377;&#8377;</span>
              </div>
              <div class="card-free"><span class="icon"><svg><use href="#i-truck"/></svg></span> Free Delivery</div>
            </div>
          </a>
        </article>
        <% } } else { %>
        <div class="empty-state">
          <span class="icon"><svg><use href="#i-restaurant"/></svg></span>
          <h3>No restaurants yet</h3>
          <p>Check back soon &mdash; delicious options are coming your way!</p>
        </div>
        <% } %>
      </div>
    </div>
  </section>

  <!-- ══════ PROMO ══════ -->
  <div class="promo-wrap">
    <div class="w">
      <div class="promo-banner">
        <div class="promo-char">
          <img src="images/promo_char.png" alt="Offer" onerror="this.onerror=null;this.src='https://cdn-icons-png.flaticon.com/512/8512/8512332.png';this.style.maxHeight='100px'">
        </div>
        <div class="promo-text">
          <div class="promo-tag"><span class="icon"><svg><use href="#i-gift"/></svg></span> LIMITED TIME OFFER</div>
          <div class="promo-heading">Get <span class="py">50% OFF</span><br>on your first order!</div>
          <div class="promo-sub">Use code TASTY50 and enjoy delicious food at half the price.</div>
        </div>
        <div class="promo-cta-wrap">
          <div class="promo-code">
            <span class="code">TASTY50</span>
            <span class="icon"><svg><use href="#i-scissors"/></svg></span>
          </div>
          <a href="callRestaurantServlet" class="promo-order">Order Now <span class="icon" style="width:14px;height:14px"><svg viewBox="0 0 24 24"><path fill="currentColor" d="M12 4l-1.41 1.41L16.17 11H4v2h12.17l-5.58 5.59L12 20l8-8z"/></svg></span></a>
        </div>
      </div>
    </div>
  </div>

  <!-- ══════ FEATURES ══════ -->
  <section class="features">
    <div class="w">
      <div class="feat-grid">
        <div class="feat-card">
          <div class="feat-icon"><span class="icon"><svg><use href="#i-truck"/></svg></span></div>
          <div><div class="feat-title">Super Fast Delivery</div><div class="feat-sub">Quick delivery at your doorstep</div></div>
        </div>
        <div class="feat-card">
          <div class="feat-icon"><span class="icon"><svg><use href="#i-shield"/></svg></span></div>
          <div><div class="feat-title">Safe Payments</div><div class="feat-sub">100% secure payment options</div></div>
        </div>
        <div class="feat-card">
          <div class="feat-icon"><span class="icon"><svg><use href="#i-tag"/></svg></span></div>
          <div><div class="feat-title">Best Offers</div><div class="feat-sub">Exciting offers everyday</div></div>
        </div>
        <div class="feat-card">
          <div class="feat-icon"><span class="icon"><svg><use href="#i-headset"/></svg></span></div>
          <div><div class="feat-title">24/7 Support</div><div class="feat-sub">We are here to help you</div></div>
        </div>
      </div>
    </div>
  </section>
</main>

<!-- ══════ FOOTER ══════ -->
<footer class="footer">
  <div class="w">
    <div class="footer-top">
      <div>
        <div class="ft-brand">
          <div class="ft-logo"><svg viewBox="0 0 24 24"><use href="#i-bowl"/></svg></div>
          <span class="ft-name">TastyBowl</span>
        </div>
        <p class="ft-desc">Your go-to platform for fast, fresh &amp; delicious food.</p>
        <div class="ft-socials">
          <a class="ft-social" href="#" aria-label="Facebook"><span class="icon"><svg viewBox="0 0 24 24"><path fill="currentColor" d="M22 12c0-5.52-4.48-10-10-10S2 6.48 2 12c0 4.84 3.44 8.87 8 9.8V15H8v-3h2V9.5C10 7.57 11.57 6 13.5 6H16v3h-2c-.55 0-1 .45-1 1v2h3v3h-3v6.95c5.05-.5 9-4.76 9-9.95Z"/></svg></span></a>
          <a class="ft-social" href="#" aria-label="Instagram"><span class="icon"><svg viewBox="0 0 24 24"><path fill="currentColor" d="M7.8 2h8.4C19.4 2 22 4.6 22 7.8v8.4a5.8 5.8 0 0 1-5.8 5.8H7.8C4.6 22 2 19.4 2 16.2V7.8A5.8 5.8 0 0 1 7.8 2Zm-.2 2A3.6 3.6 0 0 0 4 7.6v8.8C4 18.39 5.61 20 7.6 20h8.8a3.6 3.6 0 0 0 3.6-3.6V7.6C20 5.61 18.39 4 16.4 4H7.6Zm9.65 1.5a1.25 1.25 0 1 1 0 2.5 1.25 1.25 0 0 1 0-2.5ZM12 7a5 5 0 1 1 0 10 5 5 0 0 1 0-10Zm0 2a3 3 0 1 0 0 6 3 3 0 0 0 0-6Z"/></svg></span></a>
          <a class="ft-social" href="#" aria-label="Twitter"><span class="icon"><svg viewBox="0 0 24 24"><path fill="currentColor" d="M22.46 6c-.77.35-1.6.58-2.46.69.88-.53 1.56-1.37 1.88-2.38-.83.5-1.75.85-2.72 1.05C18.37 4.5 17.26 4 16 4c-2.35 0-4.27 1.92-4.27 4.29 0 .34.04.67.11.98C8.28 9.09 5.11 7.38 3 4.79c-.37.63-.58 1.37-.58 2.15 0 1.49.75 2.81 1.91 3.56-.71 0-1.37-.2-1.95-.5v.03c0 2.08 1.48 3.82 3.44 4.21a4.22 4.22 0 0 1-1.93.07 4.28 4.28 0 0 0 4 2.98 8.52 8.52 0 0 1-5.33 1.84c-.34 0-.68-.02-1.02-.06C3.44 20.29 5.7 21 8.12 21 16 21 20.33 14.46 20.33 8.79c0-.19 0-.37-.01-.56.84-.6 1.56-1.36 2.14-2.23Z"/></svg></span></a>
          <a class="ft-social" href="#" aria-label="YouTube"><span class="icon"><svg viewBox="0 0 24 24"><path fill="currentColor" d="M10 15l5.19-3L10 9v6Zm11.56-7.83c.13.47.22 1.1.28 1.9.07.8.1 1.49.1 2.09L22 12c0 2.19-.16 3.8-.44 4.83-.25.9-.83 1.48-1.73 1.73-.47.13-1.33.22-2.65.28-1.3.07-2.49.1-3.59.1L12 19c-4.19 0-6.8-.16-7.83-.44-.9-.25-1.48-.83-1.73-1.73-.13-.47-.22-1.1-.28-1.9-.07-.8-.1-1.49-.1-2.09L2 12c0-2.19.16-3.8.44-4.83.25-.9.83-1.48 1.73-1.73.47-.13 1.33-.22 2.65-.28 1.3-.07 2.49-.1 3.59-.1L12 5c4.19 0 6.8.16 7.83.44.9.25 1.48.83 1.73 1.73Z"/></svg></span></a>
        </div>
      </div>
      <div class="ft-col"><h5>Company</h5><ul><li><a href="#">About Us</a></li><li><a href="#">Careers</a></li><li><a href="#">Blog</a></li><li><a href="#">Press</a></li></ul></div>
      <div class="ft-col"><h5>Help</h5><ul><li><a href="#">FAQ</a></li><li><a href="#">Contact Us</a></li><li><a href="#">Track Order</a></li><li><a href="#">Refund Policy</a></li></ul></div>
      <div class="ft-col"><h5>Legal</h5><ul><li><a href="#">Privacy Policy</a></li><li><a href="#">Terms of Service</a></li><li><a href="#">Cookie Policy</a></li></ul></div>
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
  </div>
</footer>

<a class="scroll-top" href="#" onclick="window.scrollTo({top:0,behavior:'smooth'});return false" aria-label="Back to top">
  <span class="icon"><svg><use href="#i-up"/></svg></span>
</a>

<script>
function setCat(el){document.querySelectorAll('.cat-item').forEach(c=>c.classList.remove('active'));el.classList.add('active')}
function setView(v){
  const g=document.getElementById('restGrid'),gb=document.getElementById('gridBtn'),lb=document.getElementById('listBtn');
  if(v==='list'){g.style.gridTemplateColumns='1fr';lb.classList.add('active');gb.classList.remove('active')}
  else{g.style.gridTemplateColumns='';gb.classList.add('active');lb.classList.remove('active')}
}
document.getElementById('searchInput').addEventListener('input',function(){
  const q=this.value.trim().toLowerCase();
  document.querySelectorAll('.rest-card').forEach(c=>{
    const n=c.dataset.name||'',cu=c.dataset.cuisine||'';
    c.style.display=(!q||n.includes(q)||cu.includes(q))?'':'none';
  });
});
</script>
</body>
</html>
