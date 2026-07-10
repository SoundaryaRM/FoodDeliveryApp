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
  <title>Admin – Orders | Instant Foods</title>
  <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@300;400&family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet"/>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css"/>
  <style>
    :root{--canvas:#121212;--surface:#1e1e1e;--dark:#f0f0f0;--deep:#0a0a0a;--accent:#d49653;--border:#333333;--muted:#a0a0a0;--muted-dark:#cccccc;}
    *{box-sizing:border-box;margin:0;padding:0;}body{font-family:'Inter',sans-serif;background:var(--canvas);color:var(--dark);}a{text-decoration:none;color:inherit;}
    .layout{display:flex;min-height:100vh;}
    .sidebar{width:220px;background:var(--deep);position:fixed;top:0;left:0;height:100%;display:flex;flex-direction:column;padding:24px 0;}
    .sidebar .logo{font-family:'Playfair Display',serif;font-weight:300;font-size:1.3rem;padding:0 20px 24px;border-bottom:1px solid rgba(255,255,255,.08);color:#dfdad5;}
    .sidebar .logo span{color:var(--accent);}
    .sidebar nav{flex:1;padding:16px 0;}
    .sidebar nav a{display:flex;align-items:center;gap:10px;padding:10px 20px;font-size:.75rem;letter-spacing:.12em;text-transform:uppercase;color:#b6ab9c;transition:all .2s;}
    .sidebar nav a:hover,.sidebar nav a.active{color:#dfdad5;background:rgba(255,255,255,.06);border-left:2px solid var(--accent);}
    .sidebar nav a i{width:16px;text-align:center;color:var(--accent);}
    .sidebar .admin-info{padding:16px 20px;border-top:1px solid rgba(255,255,255,.08);font-size:.72rem;color:#615b53;}
    .main{margin-left:220px;padding:32px;flex:1;}
    .overline{font-size:11px;letter-spacing:3px;text-transform:uppercase;color:var(--accent);margin-bottom:.3rem;}
    h1{font-family:'Playfair Display',serif;font-weight:300;font-size:clamp(32px,4vw,52px);line-height:.9;margin-bottom:20px;}
    .toolbar{display:flex;gap:12px;margin-bottom:16px;align-items:center;flex-wrap:wrap;}
    .toolbar input,.toolbar select{padding:.45rem .8rem;border:1px solid var(--border);border-radius:3px;background:var(--surface);font-size:.85rem;}
    .toolbar input{width:200px;}
    .table-wrap{background:var(--surface);border-radius:3px;overflow-x:auto;}
    table{width:100%;border-collapse:collapse;}
    th,td{padding:10px 14px;text-align:left;font-size:.82rem;}
    th{background:var(--dark);color:#dfdad5;font-size:.68rem;letter-spacing:.12em;text-transform:uppercase;}
    tr:nth-child(even){background:rgba(0,0,0,.03);}
    .badge{padding:2px 9px;border-radius:3px;font-size:.65rem;letter-spacing:.08em;text-transform:uppercase;font-weight:600;}
    .badge-PLACED        {background:#fff8e1;color:#e65100;}
    .badge-CONFIRMED     {background:#e8f5e9;color:#2e7d32;}
    .badge-PREPARING     {background:#e3f2fd;color:#1565c0;}
    .badge-OUT_FOR_DELIVERY{background:#f3e5f5;color:#6a1b9a;}
    .badge-DELIVERED     {background:#e8f5e9;color:#1b5e20;}
    .badge-CANCELLED     {background:#fce4ec;color:#880e4f;}
    .btn{padding:.3rem .65rem;border:1px solid var(--border);border-radius:3px;background:none;font-size:.65rem;letter-spacing:.08em;text-transform:uppercase;cursor:pointer;font-family:'Inter',sans-serif;transition:all .2s;}
    .btn:hover{border-color:var(--dark);background:var(--dark);color:#dfdad5;}
    .btn-danger:hover{border-color:#c0392b;color:#c0392b;background:none;}
    .status-select{padding:.3rem .5rem;border:1px solid var(--border);border-radius:3px;font-size:.72rem;background:var(--canvas);font-family:'Inter',sans-serif;}
    @media(max-width:768px){.sidebar{display:none;}.main{margin-left:0;padding:16px;}}
  </style>
</head>
<body>
<div class="layout">
  <aside class="sidebar">
    <div class="logo">Instant<span>Foods</span></div>
    <nav>
      <a href="AdminDashboardServlet"><i class="fas fa-chart-line"></i> Dashboard</a>
      <a href="AdminUserServlet"><i class="fas fa-users"></i> Users</a>
      <a href="AdminRestaurantServlet"><i class="fas fa-store"></i> Restaurants</a>
      <a href="AdminMenuServlet"><i class="fas fa-utensils"></i> Menu Items</a>
      <a href="AdminOrderServlet" class="active"><i class="fas fa-receipt"></i> Orders</a>
    </nav>
    <div class="admin-info">
      <i class="fas fa-user-shield"></i> &nbsp;<%= admin.getUsername() %><br/>
      <a href="LogoutServlet" style="color:var(--accent);font-size:.68rem;margin-top:6px;display:inline-block;">Logout</a>
    </div>
  </aside>

  <main class="main">
    <div class="overline">MANAGEMENT</div>
    <h1>Orders</h1>

    <div class="toolbar">
      <input type="text" id="ordSearch" placeholder="Search by customer, restaurant…" oninput="filterTable()"/>
      <select id="statusFilter" onchange="filterTable()">
        <option value="">All Statuses</option>
        <option value="PLACED">Placed</option>
        <option value="CONFIRMED">Confirmed</option>
        <option value="PREPARING">Preparing</option>
        <option value="OUT_FOR_DELIVERY">Out for Delivery</option>
        <option value="DELIVERED">Delivered</option>
        <option value="CANCELLED">Cancelled</option>
      </select>
    </div>

    <div class="table-wrap">
      <table id="ordersTable">
        <thead>
          <tr><th>Order ID</th><th>Customer</th><th>Restaurant</th><th>Amount</th><th>Date</th><th>Status</th><th>Update Status</th><th>Delete</th></tr>
        </thead>
        <tbody>
          <c:choose>
            <c:when test="${not empty orders}">
              <c:forEach var="o" items="${orders}">
                <tr data-status="${o.status}">
                  <td>#<fmt:formatNumber value="${o.orderID}" minIntegerDigits="4" groupingUsed="false"/></td>
                  <td>${o.user.username}</td>
                  <td>${o.restaurant.name}</td>
                  <td>₹<fmt:formatNumber value="${o.totalAmount}" maxFractionDigits="0"/></td>
                  <td><fmt:formatDate value="${o.orderDateAsDate}" type="date" dateStyle="medium"/></td>
                  <td><span class="badge badge-${o.status}">${o.status}</span></td>
                  <td>
                    <%-- Inline form to update status --%>
                    <form action="AdminOrderServlet" method="post" style="display:flex;gap:6px;align-items:center;">
                      <input type="hidden" name="action" value="updateStatus"/>
                      <input type="hidden" name="orderID" value="${o.orderID}"/>
                      <select name="status" class="status-select">
                        <option value="PLACED"           ${o.status=='PLACED'?'selected':''}>Placed</option>
                        <option value="CONFIRMED"        ${o.status=='CONFIRMED'?'selected':''}>Confirmed</option>
                        <option value="PREPARING"        ${o.status=='PREPARING'?'selected':''}>Preparing</option>
                        <option value="OUT_FOR_DELIVERY" ${o.status=='OUT_FOR_DELIVERY'?'selected':''}>Out for Delivery</option>
                        <option value="DELIVERED"        ${o.status=='DELIVERED'?'selected':''}>Delivered</option>
                        <option value="CANCELLED"        ${o.status=='CANCELLED'?'selected':''}>Cancelled</option>
                      </select>
                      <button type="submit" class="btn"><i class="fas fa-check"></i></button>
                    </form>
                  </td>
                  <td>
                    <form action="AdminOrderServlet" method="post" onsubmit="return confirm('Permanently delete this order?')">
                      <input type="hidden" name="action" value="delete"/>
                      <input type="hidden" name="orderID" value="${o.orderID}"/>
                      <button type="submit" class="btn btn-danger"><i class="fas fa-trash"></i></button>
                    </form>
                  </td>
                </tr>
              </c:forEach>
            </c:when>
            <c:otherwise>
              <tr><td colspan="8" style="text-align:center;padding:32px;color:var(--muted);">No orders found.</td></tr>
            </c:otherwise>
          </c:choose>
        </tbody>
      </table>
    </div>
  </main>
</div>

<script>
  function filterTable(){
    const q  = document.getElementById('ordSearch').value.toLowerCase();
    const st = document.getElementById('statusFilter').value;
    document.querySelectorAll('#ordersTable tbody tr').forEach(tr=>{
      const matchQ  = tr.textContent.toLowerCase().includes(q);
      const matchSt = !st || tr.dataset.status === st;
      tr.style.display = (matchQ && matchSt) ? '' : 'none';
    });
  }
</script>
</body>
</html>
