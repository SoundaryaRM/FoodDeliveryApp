<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt"  prefix="fmt" %>
<%@ page import="com.food.model.User" %>
<%
    User admin = (User) session.getAttribute("loggedUser");
    if (admin == null || !"ADMIN".equalsIgnoreCase(admin.getRole())) {
        response.sendRedirect("login.jsp"); return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"/><meta name="viewport" content="width=device-width,initial-scale=1"/>
  <title>Admin Dashboard – Instant Foods</title>
  <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@300;400&family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet"/>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css"/>
  <style>
    :root{--canvas:#121212;--surface:#1e1e1e;--dark:#f0f0f0;--deep:#0a0a0a;--accent:#d49653;--border:#333333;--muted:#a0a0a0;--muted-dark:#cccccc;}
    *{box-sizing:border-box;margin:0;padding:0;}
    body{font-family:'Inter',sans-serif;background:var(--canvas);color:var(--dark);}
    a{text-decoration:none;color:inherit;}
    /* Sidebar */
    .layout{display:flex;min-height:100vh;}
    .sidebar{width:220px;background:var(--deep);color:#dfdad5;position:fixed;top:0;left:0;height:100%;display:flex;flex-direction:column;padding:24px 0;}
    .sidebar .logo{font-family:'Playfair Display',serif;font-weight:300;font-size:1.3rem;padding:0 20px 24px;border-bottom:1px solid rgba(255,255,255,.08);}
    .sidebar .logo span{color:var(--accent);}
    .sidebar nav{flex:1;padding:16px 0;}
    .sidebar nav a{display:flex;align-items:center;gap:10px;padding:10px 20px;font-size:.75rem;letter-spacing:.12em;text-transform:uppercase;color:#b6ab9c;transition:all .2s;}
    .sidebar nav a:hover,.sidebar nav a.active{color:#dfdad5;background:rgba(255,255,255,.06);border-left:2px solid var(--accent);}
    .sidebar nav a i{width:16px;text-align:center;color:var(--accent);}
    .sidebar .admin-info{padding:16px 20px;border-top:1px solid rgba(255,255,255,.08);font-size:.72rem;color:#615b53;}
    /* Main */
    .main{margin-left:220px;padding:32px;flex:1;}
    .page-header{margin-bottom:28px;}
    .overline{font-size:11px;letter-spacing:3px;text-transform:uppercase;color:var(--accent);margin-bottom:.3rem;}
    h1{font-family:'Playfair Display',serif;font-weight:300;font-size:clamp(32px,4vw,52px);line-height:.9;}
    /* Stat cards */
    .stats{display:grid;grid-template-columns:repeat(auto-fit,minmax(200px,1fr));gap:16px;margin-bottom:32px;}
    .stat-card{background:var(--surface);border-radius:3px;padding:20px;display:flex;align-items:center;gap:16px;transition:box-shadow .2s;}
    .stat-card:hover{box-shadow:0 4px 16px rgba(0,0,0,.1);}
    .stat-icon{width:48px;height:48px;background:rgba(212,150,83,.12);border-radius:3px;display:flex;align-items:center;justify-content:center;font-size:1.2rem;color:var(--accent);}
    .stat-label{font-size:.68rem;letter-spacing:.1em;text-transform:uppercase;color:var(--muted);margin-bottom:.2rem;}
    .stat-value{font-family:'Playfair Display',serif;font-size:1.8rem;font-weight:300;line-height:1;}
    /* Recent orders table */
    .section-title{font-family:'Playfair Display',serif;font-size:1.3rem;font-weight:300;margin-bottom:12px;}
    .table-wrap{background:var(--surface);border-radius:3px;overflow:hidden;}
    table{width:100%;border-collapse:collapse;}
    th,td{padding:11px 16px;text-align:left;font-size:.82rem;}
    th{background:var(--dark);color:#dfdad5;font-size:.68rem;letter-spacing:.12em;text-transform:uppercase;}
    tr:nth-child(even){background:rgba(0,0,0,.03);}
    .badge{padding:2px 8px;border-radius:3px;font-size:.65rem;letter-spacing:.1em;text-transform:uppercase;font-weight:600;}
    .badge-PLACED        {background:#fff8e1;color:#e65100;}
    .badge-CONFIRMED     {background:#e8f5e9;color:#2e7d32;}
    .badge-DELIVERED     {background:#e8f5e9;color:#1b5e20;}
    .badge-CANCELLED     {background:#fce4ec;color:#880e4f;}
    .badge-PREPARING     {background:#e3f2fd;color:#1565c0;}
    @media(max-width:768px){.sidebar{display:none;}.main{margin-left:0;padding:16px;}}
  </style>
</head>
<body>
<div class="layout">
  <!-- ═══ Sidebar ═══ -->
  <aside class="sidebar">
    <div class="logo">Instant<span>Foods</span></div>
    <nav>
      <a href="AdminDashboardServlet" class="active"><i class="fas fa-chart-line"></i> Dashboard</a>
      <a href="AdminUserServlet"><i class="fas fa-users"></i> Users</a>
      <a href="AdminRestaurantServlet"><i class="fas fa-store"></i> Restaurants</a>
      <a href="AdminMenuServlet"><i class="fas fa-utensils"></i> Menu Items</a>
      <a href="AdminOrderServlet"><i class="fas fa-receipt"></i> Orders</a>
    </nav>
    <div class="admin-info">
      <i class="fas fa-user-shield"></i> &nbsp;<%= admin.getUsername() %><br/>
      <a href="LogoutServlet" style="color:var(--accent);font-size:.68rem;margin-top:6px;display:inline-block;">Logout</a>
    </div>
  </aside>

  <!-- ═══ Main ═══ -->
  <main class="main">
    <div class="page-header">
      <div class="overline">ADMIN PANEL</div>
      <h1>Dashboard</h1>
    </div>

    <!-- ── Stat Cards ── -->
    <div class="stats">
      <div class="stat-card">
        <div class="stat-icon"><i class="fas fa-users"></i></div>
        <div>
          <div class="stat-label">Total Users</div>
          <div class="stat-value">${userCount}</div>
        </div>
      </div>
      <div class="stat-card">
        <div class="stat-icon"><i class="fas fa-store"></i></div>
        <div>
          <div class="stat-label">Restaurants</div>
          <div class="stat-value">${restaurantCount}</div>
        </div>
      </div>
      <div class="stat-card">
        <div class="stat-icon"><i class="fas fa-utensils"></i></div>
        <div>
          <div class="stat-label">Menu Items</div>
          <div class="stat-value">${menuCount}</div>
        </div>
      </div>
      <div class="stat-card">
        <div class="stat-icon"><i class="fas fa-receipt"></i></div>
        <div>
          <div class="stat-label">Total Orders</div>
          <div class="stat-value">${orderCount}</div>
        </div>
      </div>
      <div class="stat-card">
        <div class="stat-icon"><i class="fas fa-indian-rupee-sign"></i></div>
        <div>
          <div class="stat-label">Revenue</div>
          <div class="stat-value">₹<fmt:formatNumber value="${totalRevenue}" maxFractionDigits="0" groupingUsed="true"/></div>
        </div>
      </div>
    </div>

    <!-- ── Recent Orders ── -->
    <div class="section-title">Recent Orders</div>
    <div class="table-wrap">
      <table>
        <thead>
          <tr><th>Order ID</th><th>Customer</th><th>Restaurant</th><th>Amount</th><th>Status</th><th>Date</th></tr>
        </thead>
        <tbody>
          <c:choose>
            <c:when test="${not empty recentOrders}">
              <c:forEach var="o" items="${recentOrders}">
                <tr>
                  <td>#<fmt:formatNumber value="${o.orderID}" minIntegerDigits="4" groupingUsed="false"/></td>
                  <td>${o.user.username}</td>
                  <td>${o.restaurant.name}</td>
                  <td>₹<fmt:formatNumber value="${o.totalAmount}" maxFractionDigits="0"/></td>
                  <td><span class="badge badge-${o.status}">${o.status}</span></td>
                  <td><fmt:formatDate value="${o.orderDateAsDate}" type="date" dateStyle="medium"/></td>
                </tr>
              </c:forEach>
            </c:when>
            <c:otherwise>
              <tr><td colspan="6" style="text-align:center;color:var(--muted);padding:24px;">No orders yet.</td></tr>
            </c:otherwise>
          </c:choose>
        </tbody>
      </table>
    </div>
  </main>
</div>
</body>
</html>
