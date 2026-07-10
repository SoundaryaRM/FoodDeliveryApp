<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%
    // Redirect to restaurant list if already logged in
    if (session.getAttribute("loggedUser") != null) {
        response.sendRedirect("RestaurantServlet");
        return;
    }
    String error   = (String) request.getAttribute("error");
    String success = (String) request.getAttribute("success");
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>Instant Foods – Sign In</title>
  <link rel="preconnect" href="https://fonts.googleapis.com"/>
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin/>
  <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:ital,wght@0,300;0,400;1,300&family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet"/>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css"/>
  <style>
    :root{--canvas:#121212;--surface:#1e1e1e;--dark:#f0f0f0;--deep:#0a0a0a;--accent:#d49653;--border:#333333;--muted:#a0a0a0;--muted-dark:#cccccc;}
    *{box-sizing:border-box;margin:0;padding:0;}
    body{font-family:'Inter',sans-serif;background:var(--canvas);color:var(--dark);min-height:100vh;}
    a{text-decoration:none;color:var(--accent);}
    /* ── Split layout ── */
    .split{display:flex;min-height:100vh;}
    .left{flex:1;background:url('https://images.unsplash.com/photo-1504674900247-0877df9cc836?w=1920&q=80') center/cover no-repeat;position:relative;}
    .left::after{content:'';position:absolute;inset:0;background:rgba(41,38,34,.55);}
    .left .overlay{position:absolute;bottom:2.5rem;left:2.5rem;color:#dfdad5;z-index:1;}
    .left .overlay h1{font-family:'Playfair Display',serif;font-weight:300;font-size:clamp(38px,6vw,58px);line-height:.9;margin-bottom:.6rem;}
    .left .overlay p{font-size:.85rem;letter-spacing:.08em;opacity:.75;}
    .right{flex:1;background:var(--canvas);display:flex;align-items:center;justify-content:center;padding:2rem;}
    /* ── Form box ── */
    .form-box{background:var(--surface);padding:2.5rem;border-radius:3px;max-width:400px;width:100%;}
    .overline{font-size:11px;letter-spacing:3px;text-transform:uppercase;color:var(--accent);margin-bottom:.5rem;}
    .form-box h2{font-family:'Playfair Display',serif;font-weight:300;font-size:clamp(32px,5vw,52px);line-height:.9;margin-bottom:1.4rem;}
    label{display:block;font-size:.75rem;letter-spacing:.08em;text-transform:uppercase;color:var(--muted-dark);margin-bottom:.3rem;margin-top:1rem;}
    input[type=email],input[type=password]{width:100%;padding:.55rem .8rem;border:1px solid var(--border);border-radius:3px;background:#dfdad5;font-size:.9rem;font-family:'Inter',sans-serif;transition:border-color .2s;}
    input:focus{outline:none;border-color:var(--accent);}
    .remember{display:flex;justify-content:space-between;align-items:center;margin-top:.8rem;font-size:.8rem;}
    .remember label{margin:0;text-transform:none;font-size:.8rem;}
    .ghost-btn{display:block;width:100%;margin-top:1.4rem;padding:.7rem 1.2rem;background:none;border:1px solid var(--dark);border-radius:3px;font-size:11px;letter-spacing:3px;text-transform:uppercase;color:var(--dark);cursor:pointer;font-family:'Inter',sans-serif;transition:all .2s;}
    .ghost-btn:hover{background:var(--dark);color:#dfdad5;}
    .divider{text-align:center;margin:1.2rem 0;font-size:.75rem;letter-spacing:.1em;color:var(--muted);}
    .links{text-align:center;font-size:.85rem;margin-top:.5rem;}
    /* ── Alert messages ── */
    .alert{padding:.75rem 1rem;border-radius:3px;font-size:.85rem;margin-bottom:1rem;}
    .alert-error{background:#ffe4e4;border:1px solid #e9a8a8;color:#8b0000;}
    .alert-success{background:#e4f5e8;border:1px solid #a8d5b1;color:#1a5c2f;}
    /* ── Footer ── */
    .page-footer{background:var(--deep);color:#dfdad5;text-align:center;padding:.6rem;font-size:.7rem;letter-spacing:.05em;}
    @media(max-width:768px){.split{flex-direction:column;}.left{height:40vh;}.right{flex:none;}}
  </style>
</head>
<body>

<div class="split">
  <!-- Left panel -->
  <div class="left">
    <div class="overlay">
      <h1>Welcome<br/>Back</h1>
      <p>Your favourite meals, one click away.</p>
    </div>
  </div>

  <!-- Right panel -->
  <div class="right">
    <div class="form-box">
      <div class="overline">WELCOME BACK</div>
      <h2>Sign In</h2>

      <!-- Server-side messages -->
      <% if (error != null) { %>
        <div class="alert alert-error"><i class="fas fa-exclamation-circle"></i> <%= error %></div>
      <% } %>
      <% if (success != null) { %>
        <div class="alert alert-success"><i class="fas fa-check-circle"></i> <%= success %></div>
      <% } %>

      <!-- Login form — posts to LoginServlet -->
      <form action="LoginServlet" method="post" id="loginForm" novalidate>

        <label for="email">Email Address</label>
        <input type="email" id="email" name="email" placeholder="you@example.com"
               required autocomplete="email"/>

        <label for="password">Password</label>
        <input type="password" id="password" name="password" placeholder="••••••••"
               required autocomplete="current-password"/>

        <div class="remember">
          <label><input type="checkbox" name="remember" id="remember"/> &nbsp;Remember me</label>
          <a href="#">Forgot password?</a>
        </div>

        <!-- Client-side validation message -->
        <div id="formError" style="color:#8b0000;font-size:.8rem;margin-top:.5rem;display:none;"></div>

        <button type="submit" class="ghost-btn" id="submitBtn">
          <i class="fas fa-sign-in-alt"></i> &nbsp;SIGN IN
        </button>
      </form>

      <div class="divider">OR</div>
      <div class="links">
        <p>Don't have an account? <a href="register.jsp">Register</a></p>
        <p style="margin-top:.5rem;"><a href="index.jsp">← Back to Home</a></p>
      </div>
    </div>
  </div>
</div>

<footer class="page-footer">© 2026 Instant Foods. All rights reserved.</footer>

<script>
  // Client-side validation before submitting
  document.getElementById('loginForm').addEventListener('submit', function(e) {
    const email    = document.getElementById('email').value.trim();
    const password = document.getElementById('password').value.trim();
    const errDiv   = document.getElementById('formError');

    if (!email || !password) {
      e.preventDefault();
      errDiv.textContent = 'Please fill in both email and password.';
      errDiv.style.display = 'block';
      return;
    }
    errDiv.style.display = 'none';

    // Show loading state
    const btn = document.getElementById('submitBtn');
    btn.textContent = 'Signing in…';
    btn.disabled = true;
  });

  // Auto-dismiss alerts after 4 s
  setTimeout(() => {
    document.querySelectorAll('.alert').forEach(a => {
      a.style.transition = 'opacity .5s';
      a.style.opacity = '0';
      setTimeout(() => a.remove(), 500);
    });
  }, 4000);
</script>
</body>
</html>
