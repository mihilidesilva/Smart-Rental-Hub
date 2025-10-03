<%@ page import="com.smart.rentalhub.model.User" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" session="true" %>
<%
  User user = (User) session.getAttribute("user");
  String ctx  = request.getContextPath();

  
  String ok    = (String) request.getAttribute("success");
  String error = (String) request.getAttribute("error");
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <title>Contact – SmartRentalHub</title>
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <style>
    :root{
      --bg:#f6f7f8; --card:#ffffff; --text:#1f2937; --muted:#6b7280; --border:#e5e7eb;
      --brand:#ff4500; --shadow:0 10px 30px rgba(0,0,0,.08); --radius:14px;
    }
    *{box-sizing:border-box}
    html,body{margin:0;padding:0}
    body{font-family:system-ui,-apple-system,Segoe UI,Roboto,Arial,sans-serif;background:var(--bg);color:var(--text);}

    /* Header  */
    .header{position:sticky;top:0;z-index:40;background:#fff;border-bottom:1px solid var(--border);box-shadow:0 6px 20px rgba(0,0,0,.05)}
    .header .inner{max-width:1200px;margin:0 auto;padding:12px 18px;display:flex;align-items:center;justify-content:space-between}
    .brand{display:flex;align-items:center;gap:10px;color:var(--brand);font-weight:900;font-size:22px;text-decoration:none}
    .nav{display:flex;align-items:center;gap:14px}
    .nav a{color:#374151;text-decoration:none;font-weight:600;padding:8px 10px;border-radius:10px}
    .nav a:hover{background:#f3f4f6}
    .cta{background:var(--brand);color:#fff;border-radius:999px;padding:8px 14px}
    .cta:hover{opacity:.95}

    /* Hero */
    .hero{background:
      radial-gradient(900px 360px at 5% -10%, #ffe7dc 0, transparent 60%),
      radial-gradient(700px 300px at 110% 0%, #e7f0ff 0, transparent 60%),
      linear-gradient(180deg,#ffffff 0%,#fafafa 100%);
    }
    .hero .inner{max-width:1200px;margin:0 auto;padding:40px 18px}
    .h-title{font-size:36px;line-height:1.15;margin:0 0 8px;font-weight:900;letter-spacing:-.02em}
    .h-sub{margin:0;color:var(--muted)}

    /* Page layout */
    .wrap{max-width:1200px;margin:18px auto;padding:0 18px;display:grid;grid-template-columns:2fr 1fr;gap:16px}
    @media (max-width: 980px){ .wrap{grid-template-columns:1fr} }

    .card{background:#fff;border:1px solid var(--border);border-radius:var(--radius);box-shadow:var(--shadow);padding:16px}
    .card h3{margin:0 0 10px}
    .muted{color:var(--muted)}

    .grid{display:grid;grid-template-columns:repeat(3,1fr);gap:12px}
    @media (max-width: 980px){ .grid{grid-template-columns:1fr} }
    .info{display:flex;flex-direction:column;gap:6px}
    .info a{color:#111827;text-decoration:none;font-weight:700}
    .info a:hover{text-decoration:underline}

    /* Form */
    form .row{display:grid;grid-template-columns:1fr 1fr;gap:10px}
    @media (max-width: 720px){ form .row{grid-template-columns:1fr} }
    label{font-weight:700;font-size:14px}
    input, textarea{
      width:100%;padding:10px;border:1px solid var(--border);border-radius:10px;font:inherit;background:#fff
    }
    textarea{min-height:120px;resize:vertical}
    .btn{display:inline-flex;align-items:center;gap:8px;border:1px solid var(--brand);background:var(--brand);padding:10px 14px;border-radius:12px;font-weight:700;color:#fff;text-decoration:none;cursor:pointer}
    .btn:hover{opacity:.95}

    /* Map */
    .map iframe{width:100%;height:240px;border:0;border-radius:12px}

    /* Footer */
    .footer{margin-top:34px;background:#0f172a;color:#cbd5e1}
    .footer .inner{max-width:1200px;margin:0 auto;padding:28px 18px;display:grid;grid-template-columns:2fr 1fr 1fr 1fr;gap:18px}
    @media (max-width: 980px){ .footer .inner{grid-template-columns:1fr 1fr;gap:12px} }
    @media (max-width: 640px){ .footer .inner{grid-template-columns:1fr} }
    .f-brand{font-weight:900;color:#fff;margin:0 0 8px}
    .f-col a{color:#cbd5e1;text-decoration:none;display:block;margin:6px 0}
    .f-col a:hover{color:#fff}
    .copy{border-top:1px solid rgba(255,255,255,.12);padding:10px 18px;font-size:13px;text-align:center;color:#94a3b8}

    /* Alerts */
    .alert{padding:10px 12px;border-radius:10px;margin:0 0 12px;font-weight:700}
    .ok{background:#e8f5e9;color:#1b5e20;border:1px solid #c8e6c9}
    .err{background:#ffebee;color:#b71c1c;border:1px solid #ffcdd2}
  </style>
</head>
<body>

  <!-- HEADER -->
  <header class="header">
    <div class="inner">
      <a href="<%= ctx %>/index.jsp" class="brand">SmartRentalHub</a>
      <nav class="nav">
        <a href="<%= ctx %>/browseProperties">Browse</a>
        <a href="<%= ctx %>/community.jsp">Community</a>
        <a href="<%= ctx %>/about.jsp">About</a>
        <% if (user == null) { %>
          <a href="<%= ctx %>/login.jsp" class="cta">Login</a>
          <a href="<%= ctx %>/register.jsp" class="cta" style="background:#111827">Sign up</a>
        <% } else { %>
          <a href="<%= ctx %>/profile.jsp">Profile</a>
          <a href="<%= ctx %>/dashboard.jsp">Dashboard</a>
          <a href="<%= ctx %>/logout.jsp" class="cta">Logout</a>
        <% } %>
      </nav>
    </div>
  </header>

  <!-- HERO -->
  <section class="hero">
    <div class="inner">
      <h1 class="h-title">Contact SmartRentalHub</h1>
      <p class="h-sub">No in-app messaging yet — reach us directly by phone, WhatsApp, or email. We’re happy to help!</p>
    </div>
  </section>

  <main class="wrap">
    <section class="card">
      <% if (ok != null) { %><div class="alert ok"><%= ok %></div><% } %>
      <% if (error != null) { %><div class="alert err"><%= error %></div><% } %>

      <h3>Talk to us</h3>
      <p class="muted" style="margin-top:4px">Our team is available 9:00–18:00 IST, Monday–Friday.</p>

      <div class="grid" style="margin-top:12px">
        <div class="card" style="padding:12px">
          <div class="info">
            <div class="muted">Call</div>
          
            <a href="tel:+94771234567">+94 77 123 4567 (Sales)</a>
            <a href="tel:+94712345678">+94 71 234 5678 (Support)</a>
          </div>
        </div>
        <div class="card" style="padding:12px">
          <div class="info">
            <div class="muted">WhatsApp</div>
            <a href="https://wa.me/94763456789" target="_blank" rel="noopener">+94 76 345 6789</a>
          </div>
        </div>
        <div class="card" style="padding:12px">
          <div class="info">
            <div class="muted">Email</div>
            
            
            <a href="mailto:support@smartrentalhub.com">support@smartrentalhub.com</a>
          </div>
        </div>
      </div>

     

    <aside class="card">
      <h3>Office & hours</h3>
      <p class="muted" style="margin-top:4px">Mon–Fri 9:00–18:00 • Sat 9:00–13:00 • Sun closed</p>
      <div class="map" style="margin-top:10px">
        <!-- Update the map location if needed -->
        <iframe
          src="https://www.google.com/maps?q=Colombo%2C%20Sri%20Lanka&output=embed"
          loading="lazy" referrerpolicy="no-referrer-when-downgrade">
        </iframe>
      </div>
      <div style="margin-top:12px">
        <div><strong>SmartRentalHub (LK)</strong></div>
        <div class="muted">123 Union Place, Colombo</div>
      </div>
    </aside>
  </main>

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
