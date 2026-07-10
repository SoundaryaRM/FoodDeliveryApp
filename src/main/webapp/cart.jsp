<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt"  prefix="fmt" %>
<%@ page import="com.food.model.User, com.food.model.Cart, com.food.model.CartItem" %>
<%
    User loggedUser = (User) session.getAttribute("loggedUser");
    if (loggedUser == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    Cart cart = (Cart) session.getAttribute("cart");
    if (cart == null) {
        cart = new Cart();
        session.setAttribute("cart", cart);
    }
    int cartCount = cart.getItems().size();
    double grandTotal = cart.getGrandTotal();
    double deliveryFee = cartCount > 0 ? 50.0 : 0.0;
    double tax = grandTotal * 0.05; // 5% GST
    double orderTotal = grandTotal + deliveryFee + tax;
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>Instant Foods – Cart</title>
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
    .nav-links a:hover{border-color:var(--accent);color:var(--accent);}
    .nav-actions{display:flex;align-items:center;gap:1rem;font-size:.72rem;}
    .nav-actions a{color:#dfdad5;}
    .cart-btn{position:relative;background:var(--accent);width:34px;height:34px;display:flex;align-items:center;justify-content:center;border-radius:3px;color:#292622;}
    .cart-badge{position:absolute;top:-6px;right:-6px;background:var(--deep);color:#dfdad5;font-size:.55rem;width:16px;height:16px;border-radius:50%;display:flex;align-items:center;justify-content:center;border:1px solid var(--accent);}
    /* Layout */
    .page-wrap{max-width:1200px;margin:90px auto 60px;padding:0 24px;}
    .overline{font-size:11px;letter-spacing:3px;text-transform:uppercase;color:var(--accent);margin-bottom:.4rem;}
    h1{font-family:'Playfair Display',serif;font-weight:300;font-size:clamp(38px,6vw,62px);line-height:.9;margin-bottom:1.5rem;}
    .layout{display:grid;grid-template-columns:1fr 360px;gap:28px;align-items:start;}
    /* Cart items panel */
    .cart-panel{background:var(--surface);border-radius:3px;padding:24px;}
    .cart-item{display:flex;gap:16px;padding:16px 0;border-bottom:1px solid var(--border);}
    .cart-item:last-child{border-bottom:none;}
    .cart-item img{width:90px;height:90px;object-fit:cover;border-radius:3px;flex-shrink:0;}
    .cart-item .info{flex:1;}
    .cart-item h3{font-family:'Playfair Display',serif;font-weight:300;font-size:1.05rem;margin-bottom:.2rem;}
    .cart-item .rest{font-size:.75rem;color:var(--muted-dark);margin-bottom:.5rem;}
    .cart-item .item-price{font-weight:600;font-size:.9rem;margin-top:.3rem;}
    .qty-row{display:flex;align-items:center;gap:10px;margin-top:.4rem;}
    .qty-row .qty{min-width:24px;text-align:center;font-weight:600;}
    .qty-btn{background:none;border:1px solid var(--border);border-radius:3px;width:26px;height:26px;display:flex;align-items:center;justify-content:center;cursor:pointer;font-size:.9rem;color:var(--dark);transition:all .2s;}
    .qty-btn:hover{border-color:var(--accent);color:var(--accent);}
    .remove-link{font-size:.72rem;color:var(--muted);cursor:pointer;letter-spacing:.05em;text-decoration:underline;text-underline-offset:3px;margin-left:.5rem;}
    .remove-link:hover{color:var(--accent);}
    /* Empty cart */
    .empty-cart{text-align:center;padding:60px 24px;color:var(--muted);}
    .empty-cart i{font-size:3rem;display:block;margin-bottom:1rem;}
    .empty-cart a{color:var(--accent);margin-top:.8rem;display:inline-block;font-size:.9rem;}
    /* Summary panel */
    .summary{background:var(--surface);border-radius:3px;padding:24px;position:sticky;top:78px;}
    .summary h2{font-family:'Playfair Display',serif;font-weight:300;font-size:1.5rem;margin-bottom:16px;}
    .sum-row{display:flex;justify-content:space-between;font-size:.88rem;margin-bottom:8px;}
    .sum-row.total{font-weight:700;font-size:1rem;margin-top:8px;padding-top:8px;border-top:1px solid var(--border);}
    .form-field{margin-top:14px;}
    .form-field label{display:block;font-size:.7rem;letter-spacing:.1em;text-transform:uppercase;color:var(--muted-dark);margin-bottom:.3rem;}
    .form-field select,.form-field textarea{width:100%;padding:.5rem .7rem;border:1px solid var(--border);border-radius:3px;background:var(--canvas);font-size:.85rem;font-family:'Inter',sans-serif;}
    .form-field select:focus,.form-field textarea:focus{outline:none;border-color:var(--accent);}
    .form-field textarea{resize:vertical;min-height:60px;}
    .checkout-btn{display:block;width:100%;margin-top:16px;padding:.75rem;background:var(--dark);border:1px solid var(--dark);border-radius:3px;font-size:11px;letter-spacing:3px;text-transform:uppercase;color:#dfdad5;cursor:pointer;font-family:'Inter',sans-serif;transition:all .2s;}
    .checkout-btn:hover{background:var(--deep);}
    .checkout-btn:disabled{opacity:.4;cursor:not-allowed;}
    .clear-btn{display:block;width:100%;margin-top:8px;padding:.5rem;background:none;border:1px solid var(--border);border-radius:3px;font-size:10px;letter-spacing:3px;text-transform:uppercase;color:var(--muted);cursor:pointer;font-family:'Inter',sans-serif;transition:all .2s;}
    .clear-btn:hover{border-color:var(--muted);color:var(--dark);}
    .terms{font-size:.72rem;color:var(--muted);margin-top:8px;text-align:center;}
    /* Footer */
    footer{background:var(--deep);color:#dfdad5;padding:2rem;}
    .footer-grid{display:grid;grid-template-columns:repeat(auto-fit,minmax(180px,1fr));gap:1.5rem;max-width:1200px;margin:0 auto;}
    .footer-grid h4{font-family:'Playfair Display',serif;font-size:1rem;margin-bottom:.6rem;}
    .footer-grid a{color:#b6ab9c;font-size:.78rem;display:block;margin-bottom:.3rem;}
    .bottom-bar{text-align:center;font-size:.65rem;margin-top:1.5rem;border-top:1px solid rgba(255,255,255,.08);padding-top:.7rem;color:#615b53;}
    @media(max-width:768px){.layout{grid-template-columns:1fr;}.navbar{flex-wrap:wrap;gap:.5rem;}.nav-links{display:none;}}
  </style>
</head>
<body>

<!-- ═══ Navbar ═══ -->
<nav class="navbar">
  <div class="logo">Instant<span>Foods</span></div>
  <div class="nav-links">
    <a href="RestaurantServlet">RESTAURANTS</a>
    <a href="OrderServlet">MY ORDERS</a>
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

<div class="page-wrap">
  <div class="overline">YOUR ORDER</div>
  <h1>Cart</h1>

  <div class="layout">

    <!-- LEFT: Cart Items -->
    <section class="cart-panel">
      <% if (cart.getItems().isEmpty()) { %>
        <div class="empty-cart">
          <i class="fas fa-shopping-bag"></i>
          <p>Your cart is empty.</p>
          <a href="RestaurantServlet">← Browse Restaurants</a>
        </div>
      <% } else { %>
        <% for (CartItem ci : cart.getItems()) { %>
          <div class="cart-item">
            <img src="<%= (ci.getMenu().getImagePath() != null && !ci.getMenu().getImagePath().isEmpty()) ? ci.getMenu().getImagePath() : "https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=300&q=60" %>"
                 alt="<%= ci.getMenu().getItemName() %>"/>
            <div class="info">
              <h3><%= ci.getMenu().getItemName() %></h3>
              <div class="rest">
                <%= ci.getMenu().getRestaurant() != null ? ci.getMenu().getRestaurant().getName() : "" %>
              </div>
              <div class="qty-row">
                <%-- Decrement — remove if qty becomes 0 --%>
                <a href="CartServlet?action=remove&menuID=<%= ci.getMenu().getMenuID() %>">
                  <button class="qty-btn"><i class="fas fa-minus"></i></button>
                </a>
                <span class="qty"><%= ci.getQuantity() %></span>
                <%-- Increment --%>
                <a href="CartServlet?action=add&menuID=<%= ci.getMenu().getMenuID() %>">
                  <button class="qty-btn"><i class="fas fa-plus"></i></button>
                </a>
                <a href="CartServlet?action=removeAll&amp;menuID=<%= ci.getMenu().getMenuID() %>"
                   class="remove-link">Remove</a>
              </div>
              <div class="item-price">
                ₹<%= String.format("%.0f", ci.getTotalPrice()) %>
              </div>
            </div>
          </div>
        <% } %>
      <% } %>
    </section>

    <!-- RIGHT: Order Summary + Checkout Form -->
    <aside class="summary">
      <h2>Order Summary</h2>

      <div class="sum-row"><span>Subtotal</span><span>₹<%= String.format("%.0f", grandTotal) %></span></div>
      <div class="sum-row"><span>Delivery Fee</span><span>₹<%= String.format("%.0f", deliveryFee) %></span></div>
      <div class="sum-row"><span>GST (5%)</span><span>₹<%= String.format("%.0f", tax) %></span></div>
      <div class="sum-row total"><span>Total</span><span>₹<%= String.format("%.0f", orderTotal) %></span></div>

      <%-- Checkout form → CheckoutServlet --%>
      <form action="CheckoutServlet" method="post" id="checkoutForm">
        <div class="form-field">
          <label for="paymentMethod">Payment Method</label>
          <select name="paymentMethod" id="paymentMethod" required>
            <option value="CARD">Credit / Debit Card</option>
            <option value="UPI">UPI</option>
            <option value="COD">Cash on Delivery</option>
          </select>
        </div>
        <div class="form-field">
          <label for="deliveryNote">Delivery Note (optional)</label>
          <textarea name="deliveryNote" id="deliveryNote"
                    placeholder="e.g. Ring the bell twice…"></textarea>
        </div>

        <button type="submit" class="checkout-btn"
                <%= cart.getItems().isEmpty() ? "disabled" : "" %>>
          <i class="fas fa-check"></i> &nbsp;PLACE ORDER
        </button>
      </form>

      <% if (!cart.getItems().isEmpty()) { %>
        <form action="CartServlet" method="get">
          <input type="hidden" name="action" value="clear"/>
          <button type="submit" class="clear-btn">CLEAR CART</button>
        </form>
      <% } %>

      <div class="terms">By placing this order you agree to our Terms of Service.</div>
    </aside>
  </div>
</div>

<!-- ═══ Footer ═══ -->
<footer>
  <div class="footer-grid">
    <div>
      <h4>Instant<span style="color:var(--accent)">Foods</span></h4>
      <p style="font-size:.78rem;color:#b6ab9c;">Premium fine‑dining delivery.</p>
    </div>
    <div>
      <h4>Links</h4>
      <a href="RestaurantServlet">Restaurants</a>
      <a href="OrderServlet">My Orders</a>
    </div>
    <div>
      <h4>Contact</h4>
      <p style="font-size:.78rem;color:#b6ab9c;">hello@instantfoods.com</p>
    </div>
  </div>
  <div class="bottom-bar">© 2026 Instant Foods. All rights reserved.</div>
</footer>
</body>
</html>
