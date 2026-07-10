<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
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
  <title>Admin – Users | Instant Foods</title>
  <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@300;400&family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet"/>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css"/>
  <style>
    :root{--canvas:#121212;--surface:#1e1e1e;--dark:#f0f0f0;--deep:#0a0a0a;--accent:#d49653;--border:#333333;--muted:#a0a0a0;--muted-dark:#cccccc;}
    *{box-sizing:border-box;margin:0;padding:0;}
    body{font-family:'Inter',sans-serif;background:var(--canvas);color:var(--dark);}
    a{text-decoration:none;color:inherit;}
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
    /* Search bar */
    .toolbar{display:flex;gap:12px;margin-bottom:16px;align-items:center;}
    .toolbar input{padding:.45rem .8rem;border:1px solid var(--border);border-radius:3px;background:var(--surface);font-size:.85rem;width:260px;}
    /* Table */
    .table-wrap{background:var(--surface);border-radius:3px;overflow:hidden;}
    table{width:100%;border-collapse:collapse;}
    th,td{padding:11px 16px;text-align:left;font-size:.82rem;}
    th{background:var(--dark);color:#dfdad5;font-size:.68rem;letter-spacing:.12em;text-transform:uppercase;}
    tr:nth-child(even){background:rgba(0,0,0,.03);}
    .role-badge{padding:2px 8px;border-radius:3px;font-size:.65rem;letter-spacing:.08em;text-transform:uppercase;font-weight:600;border:1px solid var(--border);}
    .role-ADMIN{border-color:var(--accent);color:var(--accent);}
    .role-CUSTOMER{color:var(--muted-dark);}
    .btn{padding:.3rem .7rem;border:1px solid var(--border);border-radius:3px;background:none;font-size:.68rem;letter-spacing:.1em;text-transform:uppercase;cursor:pointer;font-family:'Inter',sans-serif;transition:all .2s;}
    .btn:hover{border-color:var(--dark);background:var(--dark);color:#dfdad5;}
    .btn-danger:hover{border-color:#c0392b;color:#c0392b;background:none;}
    /* Modal */
    .modal{display:none;position:fixed;inset:0;background:rgba(41,38,34,.7);z-index:999;align-items:center;justify-content:center;}
    .modal.open{display:flex;}
    .modal-box{background:var(--surface);border-radius:3px;padding:28px;width:400px;max-width:95vw;}
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
      <a href="AdminUserServlet" class="active"><i class="fas fa-users"></i> Users</a>
      <a href="AdminRestaurantServlet"><i class="fas fa-store"></i> Restaurants</a>
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
    <h1>Users</h1>

    <div class="toolbar">
      <input type="text" id="userSearch" placeholder="Search by name or email…" oninput="filterTable()"/>
      <span style="font-size:.8rem;color:var(--muted);">${fn:length(users)} total</span>
    </div>

    <div class="table-wrap">
      <table id="usersTable">
        <thead>
          <tr><th>#</th><th>Username</th><th>Email</th><th>Role</th><th>Address</th><th>Actions</th></tr>
        </thead>
        <tbody>
          <c:choose>
            <c:when test="${not empty users}">
              <c:forEach var="u" items="${users}" varStatus="s">
                <tr>
                  <td>${u.userID}</td>
                  <td>${u.username}</td>
                  <td>${u.email}</td>
                  <td><span class="role-badge role-${u.role}">${u.role}</span></td>
                  <td style="max-width:180px;overflow:hidden;text-overflow:ellipsis;white-space:nowrap;">${u.address}</td>
                  <td>
                    <button class="btn" onclick="openEditUser(${u.userID},'${u.username}','${u.email}','${u.role}','${u.address}')">
                      <i class="fas fa-pen"></i> Edit
                    </button>
                    <form action="AdminUserServlet" method="post" style="display:inline;" onsubmit="return confirm('Delete this user?')">
                      <input type="hidden" name="action" value="delete"/>
                      <input type="hidden" name="userID" value="${u.userID}"/>
                      <button type="submit" class="btn btn-danger"><i class="fas fa-trash"></i> Delete</button>
                    </form>
                  </td>
                </tr>
              </c:forEach>
            </c:when>
            <c:otherwise>
              <tr><td colspan="6" style="text-align:center;padding:32px;color:var(--muted);">No users found.</td></tr>
            </c:otherwise>
          </c:choose>
        </tbody>
      </table>
    </div>
  </main>
</div>

<!-- Edit User Modal -->
<div class="modal" id="editModal">
  <div class="modal-box">
    <h2>Edit User</h2>
    <form action="AdminUserServlet" method="post">
      <input type="hidden" name="action" value="update"/>
      <input type="hidden" name="userID" id="edit_userID"/>
      <div class="form-field"><label>Username</label><input name="username" id="edit_username"/></div>
      <div class="form-field"><label>Email</label><input name="email" id="edit_email" type="email"/></div>
      <div class="form-field">
        <label>Role</label>
        <select name="role" id="edit_role">
          <option value="CUSTOMER">CUSTOMER</option>
          <option value="ADMIN">ADMIN</option>
        </select>
      </div>
      <div class="form-field"><label>Address</label><textarea name="address" id="edit_address" rows="2"></textarea></div>
      <div class="modal-actions">
        <button type="submit" class="btn">Save Changes</button>
        <button type="button" class="btn" onclick="closeModal()">Cancel</button>
      </div>
    </form>
  </div>
</div>

<script>
  function openEditUser(id, name, email, role, address) {
    document.getElementById('edit_userID').value   = id;
    document.getElementById('edit_username').value = name;
    document.getElementById('edit_email').value    = email;
    document.getElementById('edit_role').value     = role;
    document.getElementById('edit_address').value  = address;
    document.getElementById('editModal').classList.add('open');
  }
  function closeModal() {
    document.getElementById('editModal').classList.remove('open');
  }
  function filterTable() {
    const q = document.getElementById('userSearch').value.toLowerCase();
    document.querySelectorAll('#usersTable tbody tr').forEach(tr => {
      tr.style.display = tr.textContent.toLowerCase().includes(q) ? '' : 'none';
    });
  }
</script>
</body>
</html>
