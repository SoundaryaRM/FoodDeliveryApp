<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt"  prefix="fmt" %>
<%@ page import="com.food.model.User, com.food.model.Cart, com.food.model.Menu" %>
<%
    /* ── Auth guard ── */
    User loggedUser = (User) session.getAttribute("loggedUser");
    if (loggedUser == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    Cart cart      = (Cart) session.getAttribute("cart");
    int cartCount  = (cart != null) ? cart.getItems().size() : 0;

    /* ── Pull restaurant info from first menu item (if list exists) ──
       We read it here in Java so we avoid LAZY-loading issues inside EL on
       a closed Hibernate session.                                           */
    String restaurantName     = "Restaurant Menu";
    String restaurantCuisine  = "";
    String restaurantDelivery = "";
    double restaurantRating   = 0.0;
    String restaurantImage = "https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?w=1920&q=80"; // fallback

    java.util.List<com.food.model.Menu> menuList = (java.util.List<com.food.model.Menu>) request.getAttribute("menuList");
    if (menuList != null && !menuList.isEmpty()) {
        com.food.model.Restaurant r = menuList.get(0).getRestaurant();
        if (r != null) {
            restaurantName     = r.getName();
            restaurantCuisine  = r.getCuisineType();
            restaurantDelivery = String.valueOf(r.getDeliveryTime());
            restaurantRating   = r.getRating();
            if (r.getImagePath() != null && !r.getImagePath().isEmpty()) {
                restaurantImage = r.getImagePath();
            }
        }
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title><%= restaurantName %> Menu – Instant Foods</title>
  <link rel="preconnect" href="https://fonts.googleapis.com"/>
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin/>
  <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@300;400&family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet"/>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css"/>
  <style>
    :root{--canvas:#121212;--surface:#1e1e1e;--dark:#f0f0f0;--deep:#0a0a0a;--accent:#d49653;--border:#333333;--muted:#a0a0a0;--muted-dark:#cccccc;}
    *{box-sizing:border-box;margin:0;padding:0;}
    body{font-family:'Inter',sans-serif;background:var(--canvas);color:var(--dark);}
    a{text-decoration:none;color:inherit;}
    /* Navbar */
    .navbar{position:fixed;top:0;width:100%;background:#121212;color:#dfdad5;display:flex;align-items:center;justify-content:space-between;padding:.8rem 2rem;z-index:1000;border-bottom:1px solid #222;}
    .logo{font-family:'Inter',sans-serif;font-weight:700;font-size:1.4rem;color:#fff;}
    .logo span{color:#e65100;}
    .search-nav{flex:1;max-width:500px;margin:0 2rem;position:relative;}
    .search-nav i{position:absolute;left:14px;top:50%;transform:translateY(-50%);color:#a0a0a0;font-size:.9rem;}
    .search-nav input{width:100%;padding:.6rem 1rem .6rem 2.5rem;border:none;border-radius:8px;background:#222;color:#fff;font-size:.9rem;font-family:'Inter',sans-serif;}
    .nav-links{display:flex;gap:1.5rem;font-size:.85rem;color:#dfdad5;align-items:center;}
    .nav-links a{color:#dfdad5;display:flex;align-items:center;gap:6px;transition:color .2s;}
    .nav-links a:hover{color:#fff;}
    .nav-actions{display:flex;align-items:center;gap:1rem;font-size:.85rem;}
    
    /* Hero Card */
    .hero-card{background:#181818;border-radius:16px;border:1px solid #333;max-width:1000px;margin:100px auto 40px;display:flex;align-items:center;padding:24px;gap:32px;color:#fff;}
    .hero-card img{width:160px;height:160px;border-radius:50%;object-fit:cover;border:4px solid #222;}
    .hero-card .info{flex:1;}
    .hero-card h1{font-family:'Inter',sans-serif;font-weight:600;font-size:1.8rem;margin-bottom:8px;}
    .hero-card .subtitle{color:#a0a0a0;font-size:.9rem;margin-bottom:4px;}
    .hero-card .location{color:#888;font-size:.8rem;margin-bottom:16px;display:flex;align-items:center;gap:6px;}
    .hero-card .stats{display:flex;align-items:center;gap:16px;font-size:.85rem;}
    .hero-card .rating{color:#fff;font-weight:600;}
    .hero-card .rating i{color:#e65100;font-size:.8rem;margin-right:4px;}
    .hero-card .divider{color:#444;}
    .hero-card .perks{display:flex;gap:24px;margin-top:20px;border-top:1px solid #333;padding-top:16px;}
    .hero-card .perk{display:flex;align-items:center;gap:8px;font-size:.8rem;color:#ccc;}
    .hero-card .perk i{color:#e65100;}
    
    .menu-header{max-width:1200px;margin:0 auto 20px;padding:0 24px;}
    .menu-header h2{font-family:'Inter',sans-serif;font-weight:600;font-size:1.5rem;color:#fff;}

    /* Menu grid */
    .menu-grid{display:grid;grid-template-columns:repeat(auto-fill,minmax(280px,1fr));gap:20px;max-width:1200px;margin:0 auto 60px;padding:0 24px;}
    .menu-item{background:#1c1c1c;border-radius:16px;display:flex;flex-direction:column;overflow:hidden;transition:transform .2s;}
    .menu-item:hover{transform:scale(1.02);}
    .menu-item img{width:100%;height:200px;object-fit:cover;border-radius:16px 16px 0 0;}
    .menu-item .details{padding:16px;flex:1;display:flex;flex-direction:column;}
    .menu-item h3{font-family:'Inter',sans-serif;font-size:1.1rem;font-weight:600;color:#fff;margin-bottom:4px;}
    .menu-item p{font-size:.8rem;color:#888;line-height:1.4;margin-bottom:12px;flex:1;}
    .menu-item .price{font-weight:600;font-size:.95rem;color:#e65100;margin-bottom:16px;}
    .add-btn{width:100%;padding:10px;background:#e65100;color:#fff;border:none;border-radius:8px;font-size:.9rem;font-weight:600;cursor:pointer;font-family:'Inter',sans-serif;transition:background .2s;}
    .add-btn:hover:not(:disabled){background:#f57c00;}
    .add-btn:disabled{background:#444;color:#888;cursor:not-allowed;}
    
    /* Toast */
    .toast{position:fixed;bottom:24px;right:24px;background:#2c2c2c;color:#fff;padding:12px 20px;border-radius:8px;font-size:.9rem;z-index:9999;display:none;align-items:center;gap:12px;border:1px solid #444;}
    .toast.show{display:flex;animation:slideUp .3s ease;}
    @keyframes slideUp{from{opacity:0;transform:translateY(20px)}to{opacity:1;transform:translateY(0)}}
    /* Empty */
    .empty{text-align:center;padding:60px 24px;color:var(--muted);grid-column:1/-1;}
    /* Footer */
    footer{background:var(--deep);color:#dfdad5;padding:2rem;}
    .footer-grid{display:grid;grid-template-columns:repeat(auto-fit,minmax(180px,1fr));gap:1.5rem;max-width:1200px;margin:0 auto;}
    .footer-grid h4{font-family:'Playfair Display',serif;font-size:1rem;margin-bottom:.6rem;}
    .footer-grid a{color:#b6ab9c;font-size:.78rem;display:block;margin-bottom:.3rem;}
    .bottom-bar{text-align:center;font-size:.65rem;margin-top:1.5rem;border-top:1px solid rgba(255,255,255,.08);padding-top:.7rem;color:#615b53;}
    @media(max-width:768px){.navbar{flex-wrap:wrap;gap:.5rem;}.nav-links{display:none;}.menu-item img{width:90px;height:90px;}}
  </style>
</head>
<body>

<!-- ═══ Navbar ═══ -->
<nav class="navbar">
  <div class="logo"><i class="fas fa-utensils" style="color:#e65100"></i> Instant <span>Food</span></div>
  
  <div class="search-nav">
    <i class="fas fa-search"></i>
    <input type="text" id="menuSearch" placeholder="Search for restaurants, cuisines..."/>
  </div>

  <div class="nav-links">
    <a href="index.jsp"><i class="fas fa-home"></i> Home</a>
    <a href="CartServlet?action=view"><i class="fas fa-shopping-cart"></i> Cart</a>
    <a href="OrderServlet"><i class="fas fa-receipt"></i> Orders</a>
  </div>
  
  <div class="nav-actions">
    <span style="display:flex;align-items:center;gap:6px;background:#333;padding:4px 12px;border-radius:20px;font-size:.8rem;color:#e65100;">
      <i class="fas fa-user-circle"></i> <%= loggedUser.getUsername() %>
    </span>
    <a href="LogoutServlet" style="font-weight:600;font-size:.8rem;color:#a0a0a0;margin-left:8px;"><i class="fas fa-sign-out-alt"></i> LOGOUT</a>
  </div>
</nav>

<!-- ═══ Hero Card ═══ -->
<div class="hero-card">
  <img src="<%= restaurantImage %>" alt="<%= restaurantName %>"/>
  <div class="info">
    <h1><%= restaurantName %></h1>
    <div class="subtitle">Traditional <%= restaurantCuisine %> food</div>
    <div class="location"><i class="fas fa-map-marker-alt"></i> Bengaluru</div>
    <div class="stats">
      <span class="rating"><i class="fas fa-star"></i> <%= restaurantRating %></span>
      <span class="divider">|</span>
      <span><%= restaurantCuisine %></span>
      <span class="divider">|</span>
      <span><i class="fas fa-clock" style="color:#a0a0a0;margin-right:4px;"></i> <%= restaurantDelivery %> mins</span>
    </div>
    <div class="perks">
      <div class="perk"><i class="fas fa-motorcycle"></i> <div><strong>Free Delivery</strong><br/><span style="color:#888;font-size:.7rem;">On orders above ₹249</span></div></div>
      <div class="perk"><i class="fas fa-tag"></i> <div><strong>20% OFF</strong><br/><span style="color:#888;font-size:.7rem;">Up to ₹100</span></div></div>
      <div class="perk"><i class="fas fa-medal"></i> <div><strong>Top Rated</strong><br/><span style="color:#888;font-size:.7rem;">Among customers</span></div></div>
    </div>
  </div>
</div>

<div class="menu-header">
  <h2>Menu</h2>
</div>

<!-- ═══ Menu Items ═══ -->
<section class="menu-grid" id="menuGrid">
  <c:choose>
    <c:when test="${not empty menuList}">
      <c:forEach var="item" items="${menuList}">
        <%-- data-name in lowercase for JS filter — done via JS, not fn:toLowerCase --%>
        <article class="menu-item" data-name="${item.itemName}" data-available="${item.available}">

          <img src="${not empty item.imagePath ? item.imagePath : 'https://d1csarkz8obe9u.cloudfront.net/posterpreviews/restaurant-food-menu-flyer-template-design-4c8258ee9132745e936c916b64de85c3_screen.jpg?ts=1737409803'}"
               alt="<c:out value='${item.itemName}'/>" loading="lazy"/>

          <div class="details">
            <h3><c:out value="${item.itemName}"/></h3>
            <p><c:out value="${not empty item.description ? item.description : 'A delightful dish prepared fresh.'}"/></p>
            <div class="price">
              <%-- fmt:formatNumber safely formats the double price --%>
              &#8377;<fmt:formatNumber value="${item.price}" maxFractionDigits="0" groupingUsed="true"/>
            </div>

            <%-- Add to Cart button --%>
            <c:choose>
              <c:when test="${item.available}">
                <a href="CartServlet?action=add&amp;menuID=${item.menuID}" style="margin-top:auto;">
                  <button class="add-btn" onclick="showToast('<c:out value="${item.itemName}"/>')">
                    Add to Cart
                  </button>
                </a>
              </c:when>
              <c:otherwise>
                <button class="add-btn" disabled style="margin-top:auto;">UNAVAILABLE</button>
              </c:otherwise>
            </c:choose>

          </div>
        </article>
      </c:forEach>
    </c:when>
    <c:otherwise>
      <div class="empty">
        <i class="fas fa-utensils" style="font-size:3rem;display:block;margin-bottom:1rem;"></i>
        <p>No menu items found. Please choose a restaurant first.</p>
        <a href="RestaurantServlet" style="color:var(--accent);margin-top:1rem;display:inline-block;">
          ← Back to Restaurants
        </a>
      </div>
    </c:otherwise>
  </c:choose>
</section>

<!-- ═══ Toast notification ═══ -->
<div class="toast" id="toast">
  <i class="fas fa-check-circle" style="color:var(--accent)"></i>
  <span id="toastMsg">Added to cart!</span>
</div>



<script>

  /* ── Toast on Add to Cart ── */
  function showToast(itemName) {
    const toast = document.getElementById('toast');
    document.getElementById('toastMsg').textContent = '"' + itemName + '" added to cart!';
    toast.classList.add('show');
    setTimeout(() => toast.classList.remove('show'), 2500);
  }
</script>
</body>
</html>
