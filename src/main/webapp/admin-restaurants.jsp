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
  <title>Admin – Restaurants | Instant Foods</title>
  <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@300;400&family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet"/>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css"/>
  <style>
    :root{--canvas:#121212;--surface:#1e1e1e;--dark:#f0f0f0;--deep:#0a0a0a;--accent:#d49653;--border:#333333;--muted:#a0a0a0;--muted-dark:#cccccc;}
    *{box-sizing:border-box;margin:0;padding:0;}body{font-family:'Inter',sans-serif;background:var(--canvas);color:var(--dark);}a{text-decoration:none;color:inherit;}
    .layout{display:flex;min-height:100vh;}
    .sidebar{width:220px;background:var(--deep);color:#dfdad5;position:fixed;top:0;left:0;height:100%;display:flex;flex-direction:column;padding:24px 0;}
    .sidebar .logo{font-family:'Playfair Display',serif;font-weight:300;font-size:1.3rem;padding:0 20px 24px;border-bottom:1px solid rgba(255,255,255,.08);}
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
    .toolbar input{padding:.45rem .8rem;border:1px solid var(--border);border-radius:3px;background:var(--surface);font-size:.85rem;width:220px;}
    .btn{padding:.35rem .75rem;border:1px solid var(--border);border-radius:3px;background:none;font-size:.68rem;letter-spacing:.1em;text-transform:uppercase;cursor:pointer;font-family:'Inter',sans-serif;transition:all .2s;}
    .btn:hover{border-color:var(--dark);background:var(--dark);color:#dfdad5;}
    .btn-accent{border-color:var(--accent);color:var(--accent);}
    .btn-accent:hover{background:var(--accent);color:var(--deep);}
    .btn-danger:hover{border-color:#c0392b;color:#c0392b;background:none;}
    .table-wrap{background:var(--surface);border-radius:3px;overflow-x:auto;}
    table{width:100%;border-collapse:collapse;}
    th,td{padding:11px 14px;text-align:left;font-size:.82rem;}
    th{background:var(--dark);color:#dfdad5;font-size:.68rem;letter-spacing:.12em;text-transform:uppercase;}
    tr:nth-child(even){background:rgba(0,0,0,.03);}
    .badge-active{color:#2e7d32;font-size:.68rem;font-weight:600;}
    .badge-inactive{color:var(--muted);font-size:.68rem;}
    .modal{display:none;position:fixed;inset:0;background:rgba(41,38,34,.7);z-index:999;align-items:center;justify-content:center;}
    .modal.open{display:flex;}
    .modal-box{background:var(--surface);border-radius:3px;padding:28px;width:460px;max-width:95vw;max-height:90vh;overflow-y:auto;}
    .modal-box h2{font-family:'Playfair Display',serif;font-weight:300;font-size:1.4rem;margin-bottom:16px;}
    .form-field{margin-bottom:12px;}
    .form-field label{display:block;font-size:.7rem;letter-spacing:.1em;text-transform:uppercase;color:var(--muted-dark);margin-bottom:.3rem;}
    .form-field input,.form-field select,.form-field textarea{width:100%;padding:.45rem .7rem;border:1px solid var(--border);border-radius:3px;background:var(--canvas);font-size:.85rem;font-family:'Inter',sans-serif;}
    .modal-actions{display:flex;gap:8px;margin-top:16px;}
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
      <a href="AdminRestaurantServlet" class="active"><i class="fas fa-store"></i> Restaurants</a>
      <a href="AdminMenuServlet"><i class="fas fa-utensils"></i> Menu Items</a>
      <a href="AdminOrderServlet"><i class="fas fa-receipt"></i> Orders</a>
    </nav>
    <div class="admin-info">
      <i class="fas fa-user-shield"></i> &nbsp;<%= admin.getUsername() %><br/>
      <a href="LogoutServlet" style="color:var(--accent);font-size:.68rem;margin-top:6px;display:inline-block;">Logout</a>
    </div>
  </aside>

  <main class="main">
    <div class="overline">MANAGEMENT</div>
    <h1>Restaurants</h1>

    <div class="toolbar">
      <input type="text" id="restSearch" placeholder="Search restaurants…" oninput="filterTable()"/>
      <button class="btn btn-accent" onclick="document.getElementById('addModal').classList.add('open')">
        <i class="fas fa-plus"></i> Add Restaurant
      </button>
    </div>

    <div class="table-wrap">
      <table id="restTable">
        <thead>
          <tr><th>ID</th><th>Name</th><th>Cuisine</th><th>Rating</th><th>Delivery</th><th>Status</th><th>Actions</th></tr>
        </thead>
        <tbody>
          <c:choose>
            <c:when test="${not empty restaurants}">
              <c:forEach var="r" items="${restaurants}">
                <tr>
                  <td>${r.restaurantID}</td>
                  <td>${r.name}</td>
                  <td>${r.cuisineType}</td>
                  <td><i class="fas fa-star" style="color:var(--accent);font-size:.7rem"></i> ${r.rating}</td>
                  <td>${r.deliveryTime} min</td>
                  <td>
                    <c:choose>
                      <c:when test="${r.active}"><span class="badge-active">● Active</span></c:when>
                      <c:otherwise><span class="badge-inactive">○ Inactive</span></c:otherwise>
                    </c:choose>
                  </td>
                  <td>
                    <button class="btn" onclick="openEdit(${r.restaurantID},'${r.name}','${r.cuisineType}','${r.address}',${r.rating},${r.deliveryTime},${r.active},'${r.imagePath}')">
                      <i class="fas fa-pen"></i> Edit
                    </button>
                    <form action="AdminRestaurantServlet" method="post" style="display:inline;" onsubmit="return confirm('Delete restaurant and all its menu items?')">
                      <input type="hidden" name="action" value="delete"/>
                      <input type="hidden" name="restaurantID" value="${r.restaurantID}"/>
                      <button type="submit" class="btn btn-danger"><i class="fas fa-trash"></i></button>
                    </form>
                  </td>
                </tr>
              </c:forEach>
            </c:when>
            <c:otherwise>
              <tr><td colspan="7" style="text-align:center;padding:32px;color:var(--muted);">No restaurants yet.</td></tr>
            </c:otherwise>
          </c:choose>
        </tbody>
      </table>
    </div>
  </main>
</div>

<!-- Add Restaurant Modal -->
<div class="modal" id="addModal">
  <div class="modal-box">
    <h2>Add Restaurant</h2>
    <form action="AdminRestaurantServlet" method="post">
      <input type="hidden" name="action" value="add"/>
      <div class="form-field"><label>Name</label><input name="name" required/></div>
      <div class="form-field"><label>Cuisine Type</label><input name="cuisineType"/></div>
      <div class="form-field"><label>Address</label><textarea name="address" rows="2"></textarea></div>
      <div class="form-field"><label>Rating (0-5)</label><input name="rating" type="number" step="0.1" min="0" max="5" value="4.0"/></div>
      <div class="form-field"><label>Delivery Time (min)</label><input name="deliveryTime" type="number" value="30"/></div>
      <div class="form-field"><label>Image URL</label><input name="imagePath" placeholder="https://…"/></div>
      <div class="modal-actions">
        <button type="submit" class="btn btn-accent">Add</button>
        <button type="button" class="btn" onclick="document.getElementById('addModal').classList.remove('open')">Cancel</button>
      </div>
    </form>
  </div>
</div>

<!-- Edit Restaurant Modal -->
<div class="modal" id="editModal">
  <div class="modal-box">
    <h2>Edit Restaurant</h2>
    <form action="AdminRestaurantServlet" method="post">
      <input type="hidden" name="action" value="update"/>
      <input type="hidden" name="restaurantID" id="e_id"/>
      <div class="form-field"><label>Name</label><input name="name" id="e_name" required/></div>
      <div class="form-field"><label>Cuisine Type</label><input name="cuisineType" id="e_cuisine"/></div>
      <div class="form-field"><label>Address</label><textarea name="address" id="e_address" rows="2"></textarea></div>
      <div class="form-field"><label>Rating</label><input name="rating" id="e_rating" type="number" step="0.1" min="0" max="5"/></div>
      <div class="form-field"><label>Delivery Time (min)</label><input name="deliveryTime" id="e_delivery" type="number"/></div>
      <div class="form-field"><label>Active</label>
        <select name="active" id="e_active"><option value="true">Active</option><option value="false">Inactive</option></select>
      </div>
      <div class="form-field"><label>Image URL</label><input name="imagePath" id="e_image"/></div>
      <div class="modal-actions">
        <button type="submit" class="btn">Save</button>
        <button type="button" class="btn" onclick="document.getElementById('editModal').classList.remove('open')">Cancel</button>
      </div>
    </form>
  </div>
</div>

<script>
  function openEdit(id,name,cuisine,address,rating,delivery,active,image){
    document.getElementById('e_id').value       = id;
    document.getElementById('e_name').value     = name;
    document.getElementById('e_cuisine').value  = cuisine;
    document.getElementById('e_address').value  = address;
    document.getElementById('e_rating').value   = rating;
    document.getElementById('e_delivery').value = delivery;
    document.getElementById('e_active').value   = active;
    document.getElementById('e_image').value    = image;
    document.getElementById('editModal').classList.add('open');
  }
  function filterTable(){
    const q = document.getElementById('restSearch').value.toLowerCase();
    document.querySelectorAll('#restTable tbody tr').forEach(tr=>{
      tr.style.display = tr.textContent.toLowerCase().includes(q)?'':'none';
    });
  }
</script>
</body>
</html>
