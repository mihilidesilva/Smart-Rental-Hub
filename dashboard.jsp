<%@ page import="com.smart.rentalhub.model.User" %>
<%@ page session="true" contentType="text/html;charset=UTF-8" language="java" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null) { response.sendRedirect("login.jsp"); return; }

    String ctx = request.getContextPath();
    String fileName = user.getProfileImg();
    String avatar = (fileName != null && !fileName.trim().isEmpty())
        ? (ctx + "/uploads/" + java.net.URLEncoder.encode(fileName, "UTF-8"))
        : (ctx + "/assets/default-avatar.png");

    String role = (user.getRole() != null) ? user.getRole().toLowerCase() : "tenant";
    String roleLabel =
        "admin".equals(role) ? "Admin" :
        "landlord".equals(role) ? "Landlord" : "Tenant";
%>
<!DOCTYPE html>
<html>
<head>
  <title>SmartRentalHub – Dashboard</title>
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <style>
    :root{
      --bg:#f6f7f8; --card:#fff; --border:#e5e7eb; --text:#1f2937; --muted:#6b7280; --brand:#ff4500;
      --hover:#f9fafb; --shadow:0 6px 20px rgba(0,0,0,.06);
    }
    *{box-sizing:border-box}
    body{margin:0;font-family:system-ui, -apple-system, Segoe UI, Roboto, Arial, sans-serif;background:var(--bg);color:var(--text)}

    /* Topbar */
    .topbar{position:sticky;top:0;z-index:20;background:#fff;border-bottom:1px solid var(--border);}
    .toprow{max-width:1200px;margin:0 auto;display:flex;align-items:center;gap:16px;padding:10px 16px}
    .brand a{color:var(--brand);font-weight:800;font-size:20px;letter-spacing:.2px;text-decoration:none}
    .search{flex:1;display:flex;align-items:center;background:var(--hover);border:1px solid var(--border);border-radius:10px;padding:8px 12px}
    .search input{border:none;background:transparent;outline:none;width:100%;font-size:14px}
    .search .sbtn{border:none;background:transparent;cursor:pointer;font-size:16px;padding:4px 6px;border-radius:8px}
    .search .sbtn:hover{background:#eef2f7}

    .userbar{display:flex;align-items:center;gap:14px}
    .role{font-size:12px;padding:3px 8px;border-radius:999px;border:1px solid var(--border);background:#fff}
    .role.admin{background:#fdecee;border-color:#f6c7cf;color:#b00020}
    .role.landlord{background:#eef5ff;border-color:#cfe2ff;color:#1a73e8}
    .role.tenant{background:#e9f7ef;border-color:#cfead9;color:#0a7b34}
    .avatar{width:32px;height:32px;border-radius:50%;object-fit:cover;border:1px solid var(--border)}
    .pill{font-weight:600;text-decoration:none;color:var(--text)}
    .pill:hover{opacity:.85}

    /* Main layout */
    .shell{max-width:1200px;margin:18px auto;padding:0 16px;display:grid;grid-template-columns:260px 1fr;gap:20px}
    @media (max-width: 960px){ .shell{grid-template-columns:1fr} .sidebar{position:static} }

    /* Sidebar */
    .sidebar{position:sticky;top:70px;align-self:start;background:#fff;border:1px solid var(--border);border-radius:12px;padding:14px;box-shadow:var(--shadow)}
    .side-title{margin:4px 0 10px 6px;font-weight:800}
    .nav{display:flex;flex-direction:column;gap:4px}
    .nav a{display:flex;align-items:center;gap:10px;padding:10px 12px;border-radius:10px;text-decoration:none;color:var(--text)}
    .nav a:hover{background:var(--hover)}
    .nav .sep{height:1px;background:var(--border);margin:8px 6px}

    /* Feed grid */
    .feed{display:grid;grid-template-columns:repeat(12,1fr);gap:16px}

    .card{grid-column:span 6;background:#fff;border:1px solid var(--border);border-radius:12px;padding:14px 16px;box-shadow:var(--shadow)}
    .card h4{margin:0 0 6px 0}
    .card p{margin:0;color:var(--muted);line-height:1.5}
    @media (max-width: 960px){ .card{grid-column:span 12} }

    /* Footer */
    .footer{max-width:1200px;margin:28px auto;padding:20px 16px;color:#9ca3af;text-align:center}

    /*  Dashboard banners  */
    .ann { grid-column:span 12; position:relative; padding:12px 44px 12px 14px;
      border:1px solid var(--border); border-radius:12px;
      background:#fff7ed; color:#7a2e0e; box-shadow:var(--shadow);
    }
    .ann .close { position:absolute; right:10px; top:10px; border:0; background:transparent;
      font-size:18px; line-height:1; cursor:pointer; color:#7a2e0e; opacity:.6;
    }
    .ann .close:hover { opacity:1; }

    .hero { grid-column:span 12; display:flex; align-items:center; justify-content:space-between;
      gap:18px; padding:18px; border-radius:16px; box-shadow:var(--shadow);
      color:#fff; overflow:hidden;
      background:
        linear-gradient(135deg, rgba(255,69,0,.88), rgba(17,24,39,.85)),
        url('<%= ctx %>/assets/cover-default.jpg') center/cover no-repeat;
    }
    .hero h3{ margin:0 0 6px; font-size:28px; letter-spacing:.2px; }
    .hero p { margin:0; opacity:.95 }
    .hero .actions{ margin-top:12px; display:flex; gap:10px; flex-wrap:wrap }
    .hero .actions .pill{
      background:#fff; border:2px solid #fff; border-radius:10px; padding:8px 12px;
    }
    .hero .actions .pill:hover{ background:#ffefe6; border-color:#ffefe6 }
    
    
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

<!-- TOP BAR -->
<header class="topbar">
  <div class="toprow">
    <div class="brand"><a href="<%=ctx%>/index.jsp">SmartRentalHub</a></div>

    <!-- Search form submits to /search -->
    <form class="search" action="<%= ctx %>/search" method="get">
      <input type="search" name="q" placeholder="Search users…" aria-label="Search users" required>
      <button class="sbtn" type="submit" title="Search">🔎</button>
    </form>

    <div class="userbar">
      <span>Hello, <strong><%= user.getFullName() %></strong></span>
      <span class="role <%= role %>"><%= roleLabel %></span>
      <a class="pill" href="<%= ctx %>/profile.jsp" title="Profile">
        <img class="avatar" src="<%= avatar %>" alt="Profile"> 
      </a>
      <a class="pill" href="<%= ctx %>/logout.jsp">Logout</a>
    </div>
  </div>
</header>

<!-- MAIN -->
<div class="shell">
<!-- SIDEBAR -->
  <aside class="sidebar">
    <div class="side-title">Navigation</div>
    <nav class="nav">
      <a href="<%= ctx %>/index.jsp">🏡 Home</a>
      <a href="<%= ctx %>/dashboard.jsp">📊 Dashboard</a>

      <div class="sep"></div>

      <!-- Common -->
      <a href="<%= ctx %>/community.jsp">💬 Community Wall</a>
      <a href="<%= ctx %>/profile.jsp">👤 My Profile</a>

      <!-- Tenant-only -->
      <% if ("tenant".equals(role)) { %>
        <div class="sep"></div>
        <a href="<%= ctx %>/browseListings.jsp">🔍 Browse Listings</a>
        
      <% } %>

      <!-- Landlord-only -->
      <% if ("landlord".equals(role)) { %>
        <div class="sep"></div>
        <a href="myProperties">🏘 My Properties</a>
        <a href="<%= ctx %>/PostPoperty.jsp">➕ Post Property</a>
        <a href="browseListings.jsp">🔍 Browse Listings</a>
        <% } %>

      <!-- Admin-only -->
      <% if ("admin".equals(role)) { %>
        <div class="sep"></div>
        <a href="<%= ctx %>/admin.jsp">🛠 Control Center</a>
        <a href="<%= ctx %>/adminReports.jsp">📑 Reports</a>
        <div class="sep"></div>
      <% } %>
      
      <a href="<%= ctx %>/logout.jsp">🚪 Logout</a>

    </nav>
  </aside>

  <!-- RIGHT COLUMN,,,,,, FEED GRID -->
  <section class="feed">
    <!-- Dismissible announcement -->
    <div class="ann" id="dashAnn">
      <strong>New:</strong> Public profiles now show listings & improved search. Try it from the bar above!
      <button class="close" id="annClose" type="button" aria-label="Dismiss">✕</button>
    </div>

    <!-- Hero banner -->
    <div class="hero">
      <div>
        <h3>Find your next home. List with confidence.</h3>
        <p>Browse verified listings, secure messaging, and a friendly community.</p>
        <div class="actions">
          <a class="pill" href="<%= ctx %>/browseListings.jsp">Start browsing</a>
          <% if ("landlord".equals(role)) { %>
            <a class="pill" href="<%= ctx %>/PostPoperty.jsp">List a property</a>
          <% } else { %>
            <a class="pill" href="<%= ctx %>/community.jsp">Visit community</a>
          <% } %>
        </div>
      </div>
    </div>

<!--     (Optional) quick stats card — remove if you don’t want it 
    <div class="card" style="grid-column:span 12">
      <div style="display:grid;grid-template-columns:repeat(3,1fr);gap:10px">
        <div style="border:1px solid var(--border);border-radius:10px;padding:10px">
          <div class="muted">New listings today</div>
          <div style="font-weight:800;font-size:20px"><%= request.getAttribute("newToday")!=null?request.getAttribute("newToday"):12 %></div>
        </div>
        <div style="border:1px solid var(--border);border-radius:10px;padding:10px">
          <div class="muted">Active users</div>
          <div style="font-weight:800;font-size:20px"><%= request.getAttribute("activeUsers")!=null?request.getAttribute("activeUsers"):248 %></div>
        </div>
        <div style="border:1px solid var(--border);border-radius:10px;padding:10px">
          <div class="muted">Messages today</div>
          <div style="font-weight:800;font-size:20px"><%= request.getAttribute("msgsToday")!=null?request.getAttribute("msgsToday"):56 %></div>
        </div>
      </div>
    </div>-->

    <!-- You can drop more cards here if you like -->
  </section>
</div>

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
  
  

<script>
(function(){
  const ann = document.getElementById('dashAnn');
  const closeBtn = document.getElementById('annClose');
  const KEY = 'srh_dash_announcement_v1';
  try {
    if (localStorage.getItem(KEY) === 'hide' && ann) ann.style.display = 'none';
  } catch(e){}
  closeBtn?.addEventListener('click', () => {
    if (ann) ann.style.display = 'none';
    try { localStorage.setItem(KEY, 'hide'); } catch(e){}
  });
})();
</script>

</body>
</html>
