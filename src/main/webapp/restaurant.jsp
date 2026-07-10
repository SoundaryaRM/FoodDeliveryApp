<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core"      prefix="c" %>
<%@ page import="com.food.model.User" %>
<%
    // Auth guard — must be logged in to view restaurants
    User loggedUser = (User) session.getAttribute("loggedUser");
    if (loggedUser == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    // Cart count helper
    com.food.model.Cart cart = (com.food.model.Cart) session.getAttribute("cart");
    int cartCount = (cart != null) ? cart.getItems().size() : 0;
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>Instant Foods – Restaurants</title>
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
    .logo span{color:#e65100;} /* Orange like Swiggy */
    .search-nav{flex:1;max-width:500px;margin:0 2rem;position:relative;}
    .search-nav i{position:absolute;left:14px;top:50%;transform:translateY(-50%);color:#a0a0a0;font-size:.9rem;}
    .search-nav input{width:100%;padding:.6rem 1rem .6rem 2.5rem;border:none;border-radius:8px;background:#222;color:#fff;font-size:.9rem;font-family:'Inter',sans-serif;}
    .nav-links{display:flex;gap:1.5rem;font-size:.85rem;color:#dfdad5;align-items:center;}
    .nav-links a{color:#dfdad5;display:flex;align-items:center;gap:6px;transition:color .2s;}
    .nav-links a:hover{color:#fff;}
    .nav-actions{display:flex;align-items:center;gap:1rem;font-size:.85rem;}
    
    /* Grid */
    .grid{display:grid;grid-template-columns:repeat(auto-fill,minmax(260px,1fr));gap:24px;max-width:1300px;margin:100px auto 60px;padding:0 24px;}
    .card{background:#1c1c1c;border-radius:16px;overflow:hidden;display:flex;flex-direction:column;transition:transform .2s;cursor:pointer;}
    .card:hover{transform:scale(1.03);}
    .card img{height:180px;width:100%;object-fit:cover;border-radius:16px 16px 0 0;}
    .card .body{padding:16px;display:flex;flex-direction:column;gap:6px;}
    .card h3{font-family:'Inter',sans-serif;font-weight:600;font-size:1.15rem;color:#fff;}
    .card .cuisine{font-size:.8rem;color:#a0a0a0;}
    .card .location{font-size:.75rem;color:#888;display:flex;align-items:center;gap:4px;margin-top:2px;}
    .card .stats{display:flex;align-items:center;gap:12px;margin-top:6px;font-size:.8rem;color:#fff;font-weight:500;}
    .card .rating-badge{background:#1b5e20;color:#fff;padding:3px 6px;border-radius:6px;display:flex;align-items:center;gap:4px;font-size:.8rem;}
    .card .delivery-time{color:#a0a0a0;}
    .card .bottom-row{display:flex;justify-content:space-between;align-items:center;margin-top:12px;font-size:.75rem;}
    .card .min-order{color:#888;}
    .card .free-delivery{color:#4caf50;font-weight:600;letter-spacing:0.05em;}
    
    /* Empty state */
    .empty{text-align:center;padding:60px 24px;color:var(--muted);}
    .empty i{font-size:3rem;margin-bottom:1rem;display:block;}
    /* Footer */
    footer{background:var(--deep);color:#dfdad5;padding:2rem;}
    .footer-grid{display:grid;grid-template-columns:repeat(auto-fit,minmax(180px,1fr));gap:1.5rem;max-width:1200px;margin:0 auto;}
    .footer-grid h4{font-family:'Inter',sans-serif;font-size:1rem;margin-bottom:.6rem;color:#fff;}
    .footer-grid a{color:#b6ab9c;font-size:.78rem;display:block;margin-bottom:.3rem;}
    .bottom-bar{text-align:center;font-size:.65rem;margin-top:1.5rem;border-top:1px solid rgba(255,255,255,.08);padding-top:.7rem;color:#615b53;}
    @media(max-width:768px){.navbar{flex-wrap:wrap;gap:.5rem;}.search-nav{order:3;margin:10px 0;max-width:100%;}.nav-links{display:none;}}
  </style>
</head>
<body>

<!-- ═══ Navbar ═══ -->
<nav class="navbar">
  <div class="logo"><i class="fas fa-utensils" style="color:#e65100"></i> Instant <span>Food</span></div>
  
  <div class="search-nav">
    <i class="fas fa-search"></i>
    <input type="text" id="searchInput" placeholder="Search for restaurants, cuisines..."/>
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

<!-- ═══ Restaurant Grid — data from RestaurantServlet ═══ -->
<div class="grid" id="restaurantGrid">
  <c:choose>
    <c:when test="${not empty restaurants}">
      <c:forEach var="r" items="${restaurants}">
        <div class="card" onclick="window.location.href='MenuServlet?restaurantID=${r.restaurantID}'"
             data-name="${r.name}"
             data-cuisine="${r.cuisineType}"
             data-rating="${r.rating}">
          <img src="${not empty r.imagePath ? r.imagePath : 'https://images.unsplash.com/photo-1555396273-367ea4eb4db5?w=600&q=80'}"
               alt="${r.name}" loading="lazy"/>
          <div class="body">
            <h3>${r.name}</h3>
            <div class="cuisine">${r.cuisineType}</div>
            <div class="location"><i class="fas fa-map-marker-alt"></i> Bengaluru</div>
            
            <div class="stats">
              <span class="rating-badge"><i class="fas fa-star" style="font-size:10px;"></i> ${r.rating}</span>
              <span class="delivery-time">${r.deliveryTime} mins</span>
            </div>
            
            <div class="bottom-row">
              <span class="min-order">Min order: ₹99.00</span>
              <span class="free-delivery">FREE DELIVERY</span>
            </div>
          </div>
        </div>
      </c:forEach>
    </c:when>
    <c:otherwise>
      <div class="empty" style="grid-column:1/-1;">
        <i class="fas fa-store-slash"></i>
        <p>No restaurants available right now. Check back soon!</p>
      </div>
    </c:otherwise>
  </c:choose>
</div>

<!-- ═══ Footer ═══ -->
<footer>
  <div class="footer-grid">
    <div>
      <h4>Instant<span style="color:var(--accent)">Foods</span></h4>
      <p>Premium fine‑dining delivery, straight to your door.</p>
    </div>
    <div>
      <h4>Quick Links</h4>
      <a href="index.jsp">Home</a>
      <a href="RestaurantServlet">Restaurants</a>
      <a href="OrderServlet">My Orders</a>
    </div>
    <div>
      <h4>Contact</h4>
      <p>123 Food Street<br/>+91 98765 43210<br/>hello@instantfoods.com</p>
    </div>
  </div>
  <div class="bottom-bar">© 2026 Instant Foods. All rights reserved.</div>
</footer>

<!-- ═══ Client-side live filter ═══ -->
<script>
  const cards         = document.querySelectorAll('.card');
  const searchInput   = document.getElementById('searchInput');

  function applyFilters() {
    const search  = searchInput.value.toLowerCase();

    cards.forEach(card => {
      const name    = (card.dataset.name    || '').toLowerCase();
      const cuis    = (card.dataset.cuisine || '').toLowerCase();

      const matchesSearch  = name.includes(search) || cuis.includes(search);
      card.style.display = matchesSearch ? '' : 'none';
    });
  }

  searchInput.addEventListener('input', applyFilters);
</script>
</body>
</html>
