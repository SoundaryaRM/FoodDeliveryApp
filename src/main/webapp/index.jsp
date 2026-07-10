<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.food.model.Restaurant" %>
<%@ page import="com.food.dao.RestaurantDAO" %>
<%@ page import="com.food.daoimpl.RestaurantDAOImpl" %>
<%
    RestaurantDAO rDao = new RestaurantDAOImpl();
    List<Restaurant> featuredRestaurants = rDao.getActiveRestaurants();
    request.setAttribute("featuredRestaurants", featuredRestaurants);
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>Instant Foods – Home</title>

  <!-- Google Fonts -->
  <link rel="preconnect" href="https://fonts.googleapis.com" />
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
  <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@300;400&family=Inter:wght@400;500;600;700&display=swap"
        rel="stylesheet" />
  <!-- Font Awesome -->
  <link rel="stylesheet"
        href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" />
  <style>
    :root {--canvas:#121212;--surface:#1e1e1e;--dark:#f0f0f0;--deep:#0a0a0a;--accent:#d49653;--border:#333333;--muted:#a0a0a0;--muted-dark:#cccccc;--secondary:#bfb4a3;}
    *{box-sizing:border-box;margin:0;padding:0;}
    body{font-family:'Inter',sans-serif;background:var(--canvas);color:var(--dark);line-height:1.5;}
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

    .hero{height:100vh;background:url('https://static.punjabkesari.in/multimedia/2018_2image_12_59_092365530rajasthani_thali.jpg') center/cover no-repeat;display:flex;align-items:center;justify-content:center;position:relative;}
    .hero::after{content:'';position:absolute;inset:0;background:rgba(0,0,0,0.6);}
    .hero .text{position:relative;color:#fff;text-align:center;}
    .hero h1{font-family:'Inter',sans-serif;font-weight:700;font-size:clamp(50px,10vw,90px);line-height:1;margin-bottom:1rem;}
    .hero .overline{font-size:14px;letter-spacing:0.15em;text-transform:uppercase;color:#e65100;margin-bottom:0.5rem;font-weight:600;}
    .ghost-btn{background:#e65100;border:none;border-radius:8px;padding:0.8rem 1.5rem;font-size:14px;font-weight:600;color:#fff;cursor:pointer;transition:background 0.2s;}
    .ghost-btn:hover{background:#f57c00;}
    
    .sections{padding:2rem 1rem;}
    .section-header{font-family:'Inter',sans-serif;font-weight:600;font-size:1.8rem;margin-bottom:1rem;color:#fff;text-align:center;margin-top:20px;}
    
    /* Grid */
    .grid{display:grid;grid-template-columns:repeat(auto-fill,minmax(260px,1fr));gap:24px;max-width:1300px;margin:0 auto 60px;padding:0 24px;}
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

    @media(max-width:768px){.navbar{flex-direction:column;align-items:flex-start;}}
  </style>
</head>
<body>

  <!-- Navbar -->
  <nav class="navbar">
    <div class="logo"><i class="fas fa-utensils" style="color:#e65100"></i> Instant <span>Food</span></div>
    
    <div class="search-nav">
      <i class="fas fa-search"></i>
      <input type="text" id="searchInput" placeholder="Search for restaurants, cuisines..."/>
    </div>

    <div class="nav-links">
      <a href="index.jsp"><i class="fas fa-home"></i> Home</a>
      <a href="RestaurantServlet"><i class="fas fa-store"></i> Restaurants</a>
      <a href="CartServlet?action=view"><i class="fas fa-shopping-cart"></i> Cart</a>
    </div>
    
    <div class="nav-actions">
      <% if(session.getAttribute("loggedUser") != null) { 
           com.food.model.User u = (com.food.model.User)session.getAttribute("loggedUser");
      %>
      <span style="display:flex;align-items:center;gap:6px;background:#333;padding:4px 12px;border-radius:20px;font-size:.8rem;color:#e65100;">
        <i class="fas fa-user-circle"></i> <%= u.getUsername() %>
      </span>
      <a href="LogoutServlet" style="font-weight:600;font-size:.8rem;color:#a0a0a0;margin-left:8px;"><i class="fas fa-sign-out-alt"></i> LOGOUT</a>
      <% } else { %>
      <a href="login.jsp" style="font-weight:600;background:#e65100;color:#fff;padding:6px 12px;border-radius:20px;">LOGIN</a>
      <a href="register.jsp" style="font-weight:600;background:#e65100;color:#fff;padding:6px 12px;border-radius:20px;">REGISTER</a>
      <% } %>
    </div>
  </nav>

  <!-- Hero -->
  <section class="hero">
    <div class="text">
      <div class="overline">AUTHENTIC CUISINE</div>
      <h1>Flavors That Stay</h1>
      <div class="overline">SINCE 2024</div>
      <button class="ghost-btn">EXPLORE MENU</button>
    </div>
  </section>

  <!-- Featured Restaurants -->
  <section class="sections">
    <h2 class="section-header">Our Featured Restaurants</h2>
    <div class="grid">
      <%
          List<Restaurant> restList = (List<Restaurant>) request.getAttribute("featuredRestaurants");
          if (restList != null && !restList.isEmpty()) {
              for (Restaurant r : restList) {
                  String imgPath = (r.getImagePath() != null && !r.getImagePath().isEmpty()) 
                                   ? r.getImagePath() 
                                   : "https://images.unsplash.com/photo-1552566626-52f8b828add9?w=600&q=80";
      %>
      <div class="card" onclick="window.location.href='MenuServlet?restaurantID=<%= r.getRestaurantID() %>'">
        <img src="<%= imgPath %>" alt="<%= r.getName() %>" />
        <div class="body">
          <h3><%= r.getName() %></h3>
          <div class="cuisine"><%= r.getCuisineType() %></div>
          <div class="location"><i class="fas fa-map-marker-alt"></i> Bengaluru</div>
          <div class="stats">
            <span class="rating-badge"><i class="fas fa-star" style="font-size:0.7rem;"></i> <%= (r.getRating() > 0 ? r.getRating() : "New") %></span>
            <span class="delivery-time"><i class="fas fa-clock"></i> <%= r.getDeliveryTime() %> mins</span>
          </div>
          <div class="bottom-row">
            <span class="min-order">Min order: ₹99.00</span>
            <span class="free-delivery">FREE DELIVERY</span>
          </div>
        </div>
      </div>
      <%
              }
          } else {
      %>
        <div class="empty">
          <i class="fas fa-store-slash"></i>
          <p>No featured restaurants at the moment. Please check back later!</p>
        </div>
      <%
          }
      %>
    </div>
  </section>

</body>
</html>
