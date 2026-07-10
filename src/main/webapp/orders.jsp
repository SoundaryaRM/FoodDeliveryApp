<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt"  prefix="fmt" %>
<%@ page import="com.food.model.User, com.food.model.Cart" %>
<%
    User loggedUser = (User) session.getAttribute("loggedUser");
    if (loggedUser == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    Cart cart = (Cart) session.getAttribute("cart");
    int cartCount = (cart != null) ? cart.getItems().size() : 0;
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>Instant Foods – My Orders</title>
  <link rel="preconnect" href="https://fonts.googleapis.com"/>
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin/>
  <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@300;400&family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet"/>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css"/>
  <style>
    :root{--canvas:#121212;--surface:#1e1e1e;--dark:#f0f0f0;--deep:#0a0a0a;--accent:#d49653;--border:#333333;--muted:#a0a0a0;--muted-dark:#cccccc;}
    *{box-sizing:border-box;margin:0;padding:0;}
    body{font-family:'Inter',sans-serif;background:var(--canvas);color:var(--dark);}
    a{text-decoration:none;color:inherit;}
    .navbar{position:fixed;top:0;width:100%;background:var(--deep);color:#dfdad5;display:flex;align-items:center;justify-content:space-between;padding:.8rem 2rem;z-index:1000;}
    .logo{font-family:'Playfair Display',serif;font-weight:300;font-size:1.4rem;}
    .logo span{color:var(--accent);}
    .nav-links{display:flex;gap:1.5rem;font-size:.72rem;letter-spacing:.12em;text-transform:uppercase;}
    .nav-links a{color:#dfdad5;padding:.2rem 0;border-bottom:1px solid transparent;transition:border-color .2s;}
    .nav-links a:hover,.nav-links a.active{border-color:var(--accent);color:var(--accent);}
    .nav-actions{display:flex;align-items:center;gap:1rem;font-size:.72rem;}
    .nav-actions a{color:#dfdad5;}
    .cart-btn{position:relative;background:var(--accent);width:34px;height:34px;display:flex;align-items:center;justify-content:center;border-radius:3px;color:#292622;}
    .cart-badge{position:absolute;top:-6px;right:-6px;background:var(--deep);color:#dfdad5;font-size:.55rem;width:16px;height:16px;border-radius:50%;display:flex;align-items:center;justify-content:center;border:1px solid var(--accent);}
    /* Main */
    .page-wrap{max-width:900px;margin:90px auto 60px;padding:0 24px;}
    .overline{font-size:11px;letter-spacing:3px;text-transform:uppercase;color:var(--accent);margin-bottom:.4rem;}
    h1{font-family:'Playfair Display',serif;font-weight:300;font-size:clamp(38px,6vw,62px);line-height:.9;margin-bottom:1.4rem;}
    /* Status filter tabs */
    .filter-tabs{display:flex;gap:8px;margin-bottom:24px;flex-wrap:wrap;}
    .ftab{background:none;border:1px solid var(--border);border-radius:3px;padding:5px 14px;font-size:.68rem;letter-spacing:.12em;text-transform:uppercase;color:var(--dark);cursor:pointer;font-family:'Inter',sans-serif;transition:all .2s;}
    .ftab.active,.ftab:hover{border-color:var(--dark);background:var(--dark);color:#dfdad5;}
    /* Order card */
    .order-card{background:var(--surface);border-radius:3px;padding:22px;margin-bottom:16px;transition:box-shadow .2s;}
    .order-card:hover{box-shadow:0 4px 16px rgba(0,0,0,.08);}
    .order-card[data-status="CANCELLED"]{opacity:.7;}
    .order-header{display:flex;justify-content:space-between;align-items:flex-start;margin-bottom:12px;flex-wrap:wrap;gap:8px;}
    .order-id{font-weight:700;font-size:.88rem;letter-spacing:.05em;}
    .order-meta{font-size:.75rem;color:var(--muted);}
    .status-badge{padding:3px 10px;border-radius:3px;font-size:.65rem;letter-spacing:.12em;text-transform:uppercase;font-weight:600;}
    .status-PLACED        {background:#fff8e1;color:#e65100;border:1px solid #ffcc80;}
    .status-CONFIRMED     {background:#e8f5e9;color:#2e7d32;border:1px solid #a5d6a7;}
    .status-PREPARING     {background:#e3f2fd;color:#1565c0;border:1px solid #90caf9;}
    .status-OUT_FOR_DELIVERY{background:#f3e5f5;color:#6a1b9a;border:1px solid #ce93d8;}
    .status-DELIVERED     {background:#e8f5e9;color:#1b5e20;border:1px solid #66bb6a;}
    .status-CANCELLED     {background:#fce4ec;color:#880e4f;border:1px solid #f48fb1;}
    .restaurant-name{font-family:'Playfair Display',serif;font-weight:300;font-size:1.15rem;margin-bottom:10px;}
    .item-list .item-row{display:flex;justify-content:space-between;font-size:.82rem;color:var(--muted-dark);padding:3px 0;border-bottom:1px dashed var(--border);}
    .item-list .item-row:last-child{border-bottom:none;}
    .order-footer{display:flex;justify-content:space-between;align-items:center;padding-top:12px;margin-top:10px;border-top:1px solid var(--border);flex-wrap:wrap;gap:8px;}
    .order-total{font-weight:700;font-size:1rem;}
    .pay-badge{font-size:.68rem;letter-spacing:.08em;text-transform:uppercase;color:var(--muted);background:var(--canvas);border:1px solid var(--border);padding:2px 8px;border-radius:3px;}
    /* Empty */
    .empty{text-align:center;padding:60px 24px;color:var(--muted);}
    .empty i{font-size:3rem;display:block;margin-bottom:1rem;}
    .empty a{color:var(--accent);margin-top:.8rem;display:inline-block;}
    /* Footer */
    footer{background:var(--deep);color:#dfdad5;padding:2rem;}
    .footer-grid{display:grid;grid-template-columns:repeat(auto-fit,minmax(180px,1fr));gap:1.5rem;max-width:1200px;margin:0 auto;}
    .footer-grid h4{font-family:'Playfair Display',serif;font-size:1rem;margin-bottom:.6rem;}
    .footer-grid a{color:#b6ab9c;font-size:.78rem;display:block;margin-bottom:.3rem;}
    .bottom-bar{text-align:center;font-size:.65rem;margin-top:1.5rem;border-top:1px solid rgba(255,255,255,.08);padding-top:.7rem;color:#615b53;}
    @media(max-width:768px){.navbar{flex-wrap:wrap;gap:.5rem;}.nav-links{display:none;}}
  </style>
</head>
<body>

<!-- ═══ Navbar ═══ -->
<nav class="navbar">
  <div class="logo">Instant<span>Foods</span></div>
  <div class="nav-links">
    <a href="RestaurantServlet">RESTAURANTS</a>
    <a href="OrderServlet" class="active">MY ORDERS</a>
  </div>
  <div class="nav-actions">
    <span style="color:var(--accent);font-size:.75rem;">
      <i class="fas fa-user"></i> &nbsp;<%= loggedUser.getUsername() %>
    </span>
    <a href="LogoutServlet" style="border:1px solid var(--border);padding:.3rem .7rem;border-radius:3px;font-size:.7rem;letter-spacing:.1em;">LOGOUT</a>
    <a href="cart.jsp" class="cart-btn">
      <i class="fas fa-shopping-bag"></i>
      <span class="cart-badge"><%= cartCount %></span>
    </a>
  </div>
</nav>

<main class="page-wrap">
  <div class="overline">TRACK</div>
  <h1>My Orders</h1>

  <!-- Status filter buttons (client-side) -->
  <div class="filter-tabs">
    <button class="ftab active" data-filter="ALL">ALL</button>
    <button class="ftab" data-filter="PLACED">PLACED</button>
    <button class="ftab" data-filter="CONFIRMED">CONFIRMED</button>
    <button class="ftab" data-filter="PREPARING">PREPARING</button>
    <button class="ftab" data-filter="DELIVERED">DELIVERED</button>
    <button class="ftab" data-filter="CANCELLED">CANCELLED</button>
  </div>

  <!-- ════ Order cards — looped from ${orders} set by OrderServlet ════ -->
  <c:choose>
    <c:when test="${not empty orders}">
      <c:forEach var="o" items="${orders}">
        <div class="order-card" data-status="${o.status}">
          <div class="order-header">
            <div>
              <div class="order-id">#ORD-<fmt:formatNumber value="${o.orderID}" minIntegerDigits="4" groupingUsed="false"/></div>
              <div class="order-meta">
                <fmt:formatDate value="${o.orderDateAsDate}" pattern="dd MMM yyyy, hh:mm a" type="both"/>
              </div>
            </div>
            <span class="status-badge status-${o.status}">${o.status}</span>
          </div>

          <div class="restaurant-name">
            <i class="fas fa-store" style="font-size:.8rem;color:var(--accent)"></i>
            &nbsp;${o.restaurant.name}
          </div>

          <%-- Order total & payment --%>
          <div class="order-footer">
            <div class="order-total">₹<fmt:formatNumber value="${o.totalAmount}" maxFractionDigits="0"/></div>
            <div style="display:flex;gap:8px;align-items:center;">
              <span class="pay-badge">${o.paymentMethod}</span>
              <a href="RestaurantServlet" style="font-size:.7rem;letter-spacing:.1em;text-transform:uppercase;color:var(--accent);">
                Order Again
              </a>
            </div>
          </div>
        </div>
      </c:forEach>
    </c:when>
    <c:otherwise>
      <div class="empty">
        <i class="fas fa-receipt"></i>
        <p>You haven't placed any orders yet.</p>
        <a href="RestaurantServlet">← Browse Restaurants</a>
      </div>
    </c:otherwise>
  </c:choose>
</main>

<!-- ═══ Footer ═══ -->
<footer>
  <div class="footer-grid">
    <div>
      <h4>Instant<span style="color:var(--accent)">Foods</span></h4>
      <p style="font-size:.78rem;color:#b6ab9c;">Premium fine‑dining delivery.</p>
    </div>
    <div>
      <h4>Quick Links</h4>
      <a href="RestaurantServlet">Restaurants</a>
      <a href="OrderServlet">My Orders</a>
      <a href="cart.jsp">Cart</a>
    </div>
    <div>
      <h4>Contact</h4>
      <p style="font-size:.78rem;color:#b6ab9c;">hello@instantfoods.com</p>
    </div>
  </div>
  <div class="bottom-bar">© 2026 Instant Foods. All rights reserved.</div>
</footer>

<!-- ═══ Client-side status filter ═══ -->
<script>
  const ftabs = document.querySelectorAll('.ftab');
  const orderCards = document.querySelectorAll('.order-card');

  ftabs.forEach(btn => {
    btn.addEventListener('click', () => {
      ftabs.forEach(b => b.classList.remove('active'));
      btn.classList.add('active');
      const filter = btn.dataset.filter;
      orderCards.forEach(card => {
        card.style.display = (filter === 'ALL' || card.dataset.status === filter) ? '' : 'none';
      });
    });
  });
</script>
</body>
</html>
