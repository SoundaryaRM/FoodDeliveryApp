<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // Redirect if already logged in
    if (session.getAttribute("loggedUser") != null) {
        response.sendRedirect("RestaurantServlet");
        return;
    }
    String error = (String) request.getAttribute("error");
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>Instant Foods – Register</title>
  <link rel="preconnect" href="https://fonts.googleapis.com"/>
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin/>
  <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@300;400&family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet"/>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css"/>
  <style>
    :root{--canvas:#121212;--surface:#1e1e1e;--dark:#f0f0f0;--deep:#0a0a0a;--accent:#d49653;--border:#333333;--muted:#a0a0a0;--muted-dark:#cccccc;}
    *{box-sizing:border-box;margin:0;padding:0;}
    body{font-family:'Inter',sans-serif;background:var(--canvas);color:var(--dark);}
    a{text-decoration:none;color:var(--accent);}
    .split{display:flex;min-height:100vh;}
    .left{flex:1;background:url('https://ptcnews-wp.s3.ap-south-1.amazonaws.com/wp-content/uploads/2023/09/Layer-7-%2863%29_54d125acfe3b6e5b0eb35531ea26f402_720X1280.webp') center/cover no-repeat;position:relative;}
    .left::after{content:'';position:absolute;inset:0;background:rgba(41,38,34,.55);}
    .left .overlay{position:absolute;bottom:2.5rem;left:2.5rem;color:#dfdad5;z-index:1;}
    .left .overlay h1{font-family:'Playfair Display',serif;font-weight:300;font-size:clamp(38px,6vw,58px);line-height:.9;margin-bottom:.6rem;}
    .left .overlay p{font-size:.85rem;letter-spacing:.08em;opacity:.75;}
    .right{flex:1;background:var(--canvas);display:flex;align-items:center;justify-content:center;padding:2rem;overflow-y:auto;}
    .form-box{background:var(--surface);padding:2.2rem;border-radius:3px;max-width:420px;width:100%;}
    .overline{font-size:11px;letter-spacing:3px;text-transform:uppercase;color:var(--accent);margin-bottom:.5rem;}
    .form-box h2{font-family:'Playfair Display',serif;font-weight:300;font-size:clamp(30px,5vw,46px);line-height:.9;margin-bottom:1.2rem;}
    label{display:block;font-size:.72rem;letter-spacing:.08em;text-transform:uppercase;color:var(--muted-dark);margin-bottom:.25rem;margin-top:.9rem;}
    input,textarea,select{width:100%;padding:.52rem .8rem;border:1px solid var(--border);border-radius:3px;background:#dfdad5;font-size:.88rem;font-family:'Inter',sans-serif;transition:border-color .2s;}
    input:focus,textarea:focus,select:focus{outline:none;border-color:var(--accent);}
    textarea{resize:vertical;min-height:70px;}
    .ghost-btn{display:block;width:100%;margin-top:1.2rem;padding:.7rem 1.2rem;background:none;border:1px solid var(--dark);border-radius:3px;font-size:11px;letter-spacing:3px;text-transform:uppercase;color:var(--dark);cursor:pointer;font-family:'Inter',sans-serif;transition:all .2s;}
    .ghost-btn:hover{background:var(--dark);color:#dfdad5;}
    .alert{padding:.7rem 1rem;border-radius:3px;font-size:.83rem;margin-bottom:1rem;}
    .alert-error{background:#ffe4e4;border:1px solid #e9a8a8;color:#8b0000;}
    .links{text-align:center;font-size:.85rem;margin-top:.8rem;}
    .strength-bar{height:4px;border-radius:2px;margin-top:4px;background:#ddd;transition:background .3s,width .3s;}
    .strength-text{font-size:.7rem;color:var(--muted);margin-top:2px;}
    .page-footer{background:var(--deep);color:#dfdad5;text-align:center;padding:.6rem;font-size:.7rem;}
    @media(max-width:768px){.split{flex-direction:column;}.left{height:35vh;}.right{flex:none;}}
  </style>
</head>
<body>
<div class="split">
  <div class="left">
    <div class="overlay">
      <h1>Join Us</h1>
      <p>Create an account to start ordering.</p>
    </div>
  </div>
  <div class="right">
    <div class="form-box">
      <div class="overline">GET STARTED</div>
      <h2>Register</h2>

      <% if (error != null) { %>
        <div class="alert alert-error"><i class="fas fa-exclamation-circle"></i> <%= error %></div>
      <% } %>

      <!-- Posts to /register (RegisterServlet) -->
      <form action="register" method="post" id="regForm" novalidate>

        <label for="username">Username</label>
        <input type="text" id="username" name="username" placeholder="e.g. john_doe"
               required minlength="3" maxlength="50" autocomplete="username"/>

        <label for="email">Email Address</label>
        <input type="email" id="email" name="email" placeholder="you@example.com"
               required autocomplete="email"/>

        <label for="password">Password</label>
        <input type="password" id="password" name="password" placeholder="Min. 6 characters"
               required minlength="6" autocomplete="new-password"/>
        <div class="strength-bar" id="strengthBar" style="width:0;"></div>
        <div class="strength-text" id="strengthText"></div>

        <label for="confirmPassword">Confirm Password</label>
        <input type="password" id="confirmPassword" name="confirmPassword"
               placeholder="Repeat your password" required autocomplete="new-password"/>

        <label for="address">Delivery Address</label>
        <textarea id="address" name="address" rows="2"
                  placeholder="Street, City, PIN code" required></textarea>

        <!-- Client-side error -->
        <div id="formError" style="color:#8b0000;font-size:.8rem;margin-top:.4rem;display:none;"></div>

        <button type="submit" class="ghost-btn" id="submitBtn">
          <i class="fas fa-user-plus"></i> &nbsp;CREATE ACCOUNT
        </button>
      </form>

      <div class="links">
        <p>Already have an account? <a href="login.jsp">Sign In</a></p>
        <p style="margin-top:.4rem;"><a href="index.jsp">← Back to Home</a></p>
      </div>
    </div>
  </div>
</div>
<footer class="page-footer">© 2026 Instant Foods. All rights reserved.</footer>

<script>
  /* Password strength indicator */
  const pwdInput = document.getElementById('password');
  const bar      = document.getElementById('strengthBar');
  const txt      = document.getElementById('strengthText');
  pwdInput.addEventListener('input', () => {
    const v = pwdInput.value;
    let score = 0;
    if (v.length >= 6) score++;
    if (/[A-Z]/.test(v)) score++;
    if (/[0-9]/.test(v)) score++;
    if (/[^A-Za-z0-9]/.test(v)) score++;
    const colors = ['#e57373','#ff9800','#66bb6a','#388e3c'];
    const labels = ['Weak','Fair','Good','Strong'];
    bar.style.width  = (score * 25) + '%';
    bar.style.background = colors[score - 1] || '#ddd';
    txt.textContent  = score ? labels[score - 1] : '';
  });

  /* Client-side validation */
  document.getElementById('regForm').addEventListener('submit', function(e) {
    const errDiv  = document.getElementById('formError');
    const pwd     = document.getElementById('password').value;
    const confirm = document.getElementById('confirmPassword').value;
    if (pwd !== confirm) {
      e.preventDefault();
      errDiv.textContent = 'Passwords do not match.';
      errDiv.style.display = 'block';
      return;
    }
    errDiv.style.display = 'none';
    const btn = document.getElementById('submitBtn');
    btn.textContent = 'Creating account…';
    btn.disabled = true;
  });
</script>
</body>
</html>
