<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%
  String ctx   = request.getContextPath();
  String error = request.getParameter("error");
  String prevUser = request.getParameter("username"); // if you want to preserve after redirect
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <title>Login – SmartRentalHub</title>
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <style>
    :root{
      --bg:#f6f7f8; --card:#ffffff; --text:#1f2937; --muted:#6b7280; --border:#e5e7eb;
      --brand:#ff4500; --danger:#b00020; --shadow:0 10px 30px rgba(0,0,0,.08); --radius:14px;
    }
    *{box-sizing:border-box}
    html,body{margin:0;padding:0}
    body{font-family:system-ui,-apple-system,Segoe UI,Roboto,Arial,sans-serif;background:var(--bg);color:var(--text)}

    .top{position:sticky;top:0;z-index:10;background:#fff;border-bottom:1px solid var(--border)}
    .top .inner{max-width:1100px;margin:0 auto;padding:10px 16px;display:flex;justify-content:space-between;align-items:center}
    .brand{color:var(--brand);font-weight:900;font-size:22px;text-decoration:none}
    .nav a{color:#374151;text-decoration:none;font-weight:600;margin-left:10px;padding:8px 10px;border-radius:10px}
    .nav a:hover{background:#f3f4f6}

    .wrap{min-height:calc(100vh - 52px);display:grid;grid-template-columns:1.1fr 1fr}
    @media (max-width: 980px){ .wrap{grid-template-columns:1fr} }

    .left{
      background:
        radial-gradient(900px 380px at 110% 0%, #e7f0ff 0, transparent 60%),
        radial-gradient(900px 380px at -10% 10%, #ffe7dc 0, transparent 60%),
        linear-gradient(180deg,#ffffff 0%,#fafafa 100%);
      display:flex;align-items:center;justify-content:center;padding:40px 24px;border-right:1px solid var(--border);
    }
    .pitch{max-width:560px}
    .pitch h1{font-size:40px;line-height:1.12;margin:0 0 10px;font-weight:900;letter-spacing:-.02em}
    .pitch p{color:var(--muted);margin:0 0 12px}

    .right{display:flex;align-items:center;justify-content:center;padding:40px 16px}
    .card{width:min(480px, 92vw);background:#fff;border:1px solid var(--border);border-radius:var(--radius);box-shadow:var(--shadow);padding:22px}
    .card h2{margin:0 0 6px}
    .muted{color:var(--muted)}
    .field{display:flex;flex-direction:column;gap:6px;margin-top:12px}
    .label{font-weight:700}
    .input{width:100%;padding:12px;border:1px solid var(--border);border-radius:10px;background:#fff;font-size:16px}
    .row{display:flex;gap:10px;align-items:center;justify-content:space-between;margin-top:8px}
    .actions{display:flex;gap:10px;align-items:center;margin-top:14px}
    .btn{display:inline-flex;align-items:center;gap:8px;border:1px solid var(--border);background:#fff;padding:10px 14px;border-radius:12px;font-weight:800;color:#111827;cursor:pointer;text-decoration:none}
    .btn.primary{background:var(--brand);border-color:var(--brand);color:#fff}
    .btn:disabled{opacity:.6;cursor:not-allowed}
    .link{color:#374151;text-decoration:none}
    .link:hover{text-decoration:underline}

    .alert{margin-top:12px;padding:10px 12px;border-radius:10px;border:1px solid #f3c7cd;background:#fdecef;color:#7a1120;font-weight:600}
    .foot{max-width:1100px;margin:20px auto 24px;text-align:center;color:#94a3b8;font-size:13px}
  </style>
</head>
<body>

  <div class="top">
    <div class="inner">
      <a href="<%= ctx %>/" class="brand">SmartRentalHub</a>
      <div class="nav">
        <a href="<%= ctx %>/index.jsp">Home</a>
       <a href="<%= ctx %>/browseProperties">Browse</a>
        <a href="<%= ctx %>/community.jsp">Community</a>
        <a href="<%= ctx %>/register.jsp">Create account</a>
      </div>
    </div>
  </div>

  <div class="wrap">
    <section class="left">
      <div class="pitch">
        <h1>Welcome back 👋</h1>
        <p>Sign in to find homes, manage listings, and chat safely with verified users.</p>
      </div>
    </section>

    <section class="right">
      <div class="card">
        <h2>Login</h2>
        <div class="muted">Use your username and password to continue.</div>

        <% if ("1".equals(error)) { %>
          <div class="alert">Invalid username or password.</div>
        <% } else if ("terms".equals(error)) { %>
          <div class="alert">Please agree to the Terms & Privacy to continue.</div>
        <% } %>

        <!-- Remove novalidate so HTML5 'required' works -->
        <form action="<%= ctx %>/login" method="post" id="loginForm" autocomplete="on">
          <div class="field">
            <label class="label" for="username">Username</label>
            <input class="input" type="text" id="username" name="username" required autofocus placeholder="yourname"
                   value="<%= prevUser != null ? prevUser : "" %>">
          </div>

          <div class="field">
            <label class="label" for="password">Password</label>
            <div style="position:relative">
              <input class="input" type="password" id="password" name="password" required placeholder="••••••••" />
              <button type="button" id="togglePw" aria-label="Show password"
                      style="position:absolute;right:8px;top:50%;transform:translateY(-50%);border:none;background:#f3f4f6;padding:6px 8px;border-radius:8px;cursor:pointer;">
                Show
              </button>
            </div>
          </div>

          <!--  Terms consent -->
          <div class="field" style="margin-top:10px">
            <label style="display:flex;align-items:center;gap:10px">
              <input type="checkbox" id="agree" name="agree" required>
              <span>I agree to the <a class="link" href="<%= ctx %>/terms.jsp" target="_blank">Terms</a> and <a class="link" href="<%= ctx %>/privacy.jsp" target="_blank">Privacy</a>.</span>
            </label>
          </div>

          <div class="actions">
            <button class="btn primary" type="submit" id="submitBtn" disabled>Sign in</button>
            <a class="btn" href="<%= ctx %>/register.jsp">Create account</a>
          </div>
        </form>
      </div>
    </section>
  </div>

  <div class="foot">© <%= java.time.Year.now() %> SmartRentalHub</div>

  <script>
    // show/hide password
    (function(){
      var t = document.getElementById('togglePw');
      var p = document.getElementById('password');
      t?.addEventListener('click', function(){
        var is = p.type === 'password';
        p.type = is ? 'text' : 'password';
        t.textContent = is ? 'Hide' : 'Show';
      });
    })();

    // Enable submit only when terms are checked
    (function(){
      var agree = document.getElementById('agree');
      var btn   = document.getElementById('submitBtn');
      function sync(){ btn.disabled = !agree.checked; }
      agree?.addEventListener('change', sync);
      sync();
    })();

  
    (function(){
      var form = document.getElementById('loginForm');
      var btn  = document.getElementById('submitBtn');
      form?.addEventListener('submit', function(){
        if (btn.disabled) return false;
        btn.disabled = true;
        btn.textContent = 'Signing in…';
      });
    })();
  </script>
  
  
  <%@ page import="java.util.List" %>
<%@ page import="com.smart.rentalhub.model.Property" %>
<%@ page import="com.smart.rentalhub.dao.PropertyDAO" %>


<%
    List<Property> properties = (List<Property>) request.getAttribute("properties");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Browse Properties</title>
    <style>

        :root {
            --bg: #f6f7f8;
            --card: #fff;
            --border: #e5e7eb;
            --text: #1f2937;
            --muted: #6b7280;
            --brand: #ff4500;
            --hover: #f9fafb;
            --shadow: 0 6px 20px rgba(0,0,0,.06);
        }

        * { box-sizing: border-box; }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: #f0f2f5;
            margin: 0;
            padding: 30px;
        }

        h2 {
            text-align: center;
            margin-bottom: 30px;
            font-size: 2rem;
            color: #333;
        }

        .property-container {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
            gap: 25px;
        }

        .property-card {
            background: #fff;
            border-radius: 15px;
            overflow: hidden;
            box-shadow: 0 6px 20px rgba(0, 0, 0, 0.1);
            transition: all 0.3s ease;
            display: flex;
            flex-direction: column;
        }

        .property-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 12px 25px rgba(0, 0, 0, 0.15);
        }

        .property-image img {
            width: 100%;
            height: 220px;
            object-fit: cover;
            transition: transform 0.3s ease;
        }

        .property-card:hover .property-image img {
            transform: scale(1.05);
        }

        .property-details {
            padding: 20px;
            flex-grow: 1;
            display: flex;
            flex-direction: column;
        }

        .property-title {
            font-size: 20px;
            font-weight: 700;
            color: #111;
            margin-bottom: 10px;
        }

        .property-city {
            font-size: 14px;
            color: #777;
            margin-bottom: 15px;
        }

        .property-description {
            font-size: 14px;
            color: #555;
            flex-grow: 1;
            margin-bottom: 15px;
        }

        .property-price {
            font-weight: bold;
            font-size: 16px;
            color: #fff;
            padding: 8px 12px;
            border-radius: 8px;
            background: linear-gradient(135deg, #f6a11f, #e94e1b);
            text-align: center;
            width: fit-content;
        }

        @media (max-width: 600px) {
            .property-container {
                grid-template-columns: 1fr;
            }
        }

        p {
            text-align: center;
            font-size: 1.2rem;
            color: #888;
        }
        
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            /* White base with soft orange gradient */
            background: linear-gradient(120deg, #ffffff, #fff8f0);
            margin: 0;
            padding: 30px;
        }

        /*  add a subtle orange overlay behind cards */
        .property-card {
            background: #fff;
            border-radius: 15px;
            overflow: hidden;
            box-shadow: 0 6px 20px rgba(230, 115, 50, 0.15); /* light orange shadow */
            transition: all 0.3s ease;
            display: flex;
            flex-direction: column;
        }

        .property-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 12px 25px rgba(230, 115, 50, 0.25); 
        }


        
  /* Footer */
    .footer{margin-top:34px;background:#0f172a;color:#cbd5e1}
    .footer .inner{max-width:1200px;margin:0 auto;padding:28px 18px;display:grid;grid-template-columns:2fr 1fr 1fr 1fr;gap:18px}
    @media (max-width: 980px){ .footer .inner{grid-template-columns:1fr 1fr;gap:12px} }
    @media (max-width: 640px){ .footer .inner{grid-template-columns:1fr} }
    .f-brand{font-weight:900;color:#fff;margin:0 0 8px}
    .f-col a{color:#cbd5e1;text-decoration:none;display:block;margin:6px 0}
    .f-col a:hover{color:#fff}
    .copy{border-top:1px solid rgba(255,255,255,.12);padding:10px 18px;font-size:13px;text-align:center;color:#94a3b8}
  
    
    </style>
</head>
<body>
    
    

    
    
        
        <!-- FOOTER -->
  <footer class="footer">
    <div class="inner">
      <div>
        <div class="f-brand">SmartRentalHub</div>
        <p class="meta" style="color:#cbd5e1">Find, list, and manage rentals with ease.</p>
      </div>
      <div class="f-col">
        <strong>Product</strong>
        <a href="<%= ctx %>/browseProperties.jsp">Browse</a>
        <a href="<%= ctx %>/addListing.jsp">List a property</a>
        
      </div>
      <div class="f-col">
        <strong>Company</strong>
        <a href="<%= ctx %>/about.jsp">About</a>
        <a href="<%= ctx %>/contact.jsp">Contact</a>
      </div>
      <div class="f-col">
        <strong>Legal</strong>
        <a href="<%= ctx %>/terms.jsp">Terms</a>
        <a href="<%= ctx %>/privacy.jsp">Privacy</a>
       
      </div>
    </div>
    <div class="copy">© <%= java.time.Year.now() %> SmartRentalHub. All rights reserved.</div>
  </footer>

    
</body>
</html>

</body>
</html>
