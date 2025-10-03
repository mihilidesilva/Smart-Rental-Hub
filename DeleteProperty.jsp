<%@ page import="com.smart.rentalhub.model.User" %>
<%@ page session="true" contentType="text/html;charset=UTF-8" language="java" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    String ctx = request.getContextPath();

    // Resolve avatar 
    String fileName = user.getProfileImg();
    String avatarUrl = (fileName != null && !fileName.trim().isEmpty())
            ? (ctx + "/uploads/" + java.net.URLEncoder.encode(fileName, "UTF-8"))
            : (ctx + "/assets/default-avatar.png");

    // Role pill
    String role = (user.getRole() != null) ? user.getRole().toLowerCase() : "tenant";
    String roleLabel =
        "admin".equals(role) ? "Admin" :
        "landlord".equals(role) ? "Landlord" : "Tenant";

    // Optional flash message
    String message = (String) session.getAttribute("message");
    if (message != null) {
%>
    <script>alert('<%= message %>');</script>
<%
        session.removeAttribute("message");
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>SmartRentalHub – Delete Property</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <style>
        :root{
          --bg:#f6f7f8; --card:#fff; --border:#e5e7eb; --text:#1f2937; --muted:#6b7280; --brand:#ff4500;
          --hover:#f9fafb; --shadow:0 6px 20px rgba(0,0,0,.06);
        }
        *{box-sizing:border-box}
        body{margin:0;font-family:system-ui,-apple-system, Segoe UI, Roboto, Arial, sans-serif;background:#f6f7f8;color:var(--text)}

        /* Topbar   */
        .topbar{position:sticky;top:0;z-index:100;background:#fff;border-bottom:1px solid var(--border);}
        .toprow{max-width:1200px;margin:0 auto;display:flex;align-items:center;justify-content:space-between;gap:16px;padding:10px 16px}
        .brand a{color:var(--brand);font-weight:800;font-size:20px;letter-spacing:.2px;text-decoration:none}
        .userbar{display:flex;align-items:center;gap:14px}
        .role{font-size:12px;padding:3px 8px;border-radius:999px;border:1px solid var(--border);background:#fff}
        .role.admin{background:#fdecee;border-color:#f6c7cf;color:#b00020}
        .role.landlord{background:#eef5ff;border-color:#cfe2ff;color:#1a73e8}
        .role.tenant{background:#e9f7ef;border-color:#cfead9;color:#0a7b34}
        .avatar{width:32px;height:32px;border-radius:50%;object-fit:cover;border:1px solid var(--border)}
        .pill{font-weight:600;text-decoration:none;color:var(--text)}
        .pill:hover{opacity:.85}

        /*  Layout with sidebar  */
        .shell{max-width:1200px;margin:18px auto;padding:0 16px;display:grid;grid-template-columns:260px 1fr;gap:20px}
        @media (max-width: 960px){ .shell{grid-template-columns:1fr} .sidebar{position:static} }
        .sidebar{position:sticky;top:70px;align-self:start;background:#fff;border:1px solid var(--border);border-radius:12px;padding:14px;box-shadow:var(--shadow)}
        .side-title{margin:4px 0 10px 6px;font-weight:800}
        .nav{display:flex;flex-direction:column;gap:4px}
        .nav a{display:flex;align-items:center;gap:10px;padding:10px 12px;border-radius:10px;text-decoration:none;color:var(--text)}
        .nav a:hover{background:var(--hover)}
        .nav .sep{height:1px;background:var(--border);margin:8px 6px}

        
        
        .card{background:#fff; border-radius:8px; padding:20px; margin-bottom:20px; border:1px solid #ddd;}
        .footer { text-align:center; padding:20px; font-size:14px; color:#aaa; }
        form input{
            width:100%; padding:10px; margin:8px 0; border:1px solid #ccc; border-radius:6px; font-size:14px;
        }
        form button{
            background:#ff4500; color:#fff; padding:10px 20px; border:none; border-radius:6px; cursor:pointer; font-size:15px;
        }
        form button:hover{ background:#e03e00; }
        
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

<!--  TOP BAR  -->
<header class="topbar">
  <div class="toprow">
    <div class="brand"><a href="<%= ctx %>/index.jsp">SmartRentalHub</a></div>
    <div class="userbar">
      <span>Hello, <strong><%= user.getFullName() %></strong></span>
      <span class="role <%= role %>"><%= roleLabel %></span>
      <a class="pill" href="<%= ctx %>/profile.jsp" title="Profile">
        <img class="avatar" src="<%= avatarUrl %>" alt="Profile">
      </a>
      <a class="pill" href="<%= ctx %>/logout.jsp">Logout</a>
    </div>
  </div>
</header>

<!--  MAIN -->
<div class="shell">
  <!-- Sidebar  -->
  <aside class="sidebar">
    <div class="side-title">Navigation</div>
    <nav class="nav">
      <a href="<%= ctx %>/index.jsp">🏡 Home</a>
      <a href="<%= ctx %>/dashboard.jsp">📊 Dashboard</a>

      <div class="sep"></div>
      <a href="<%= ctx %>/community.jsp">💬 Community Wall</a>
      <a href="<%= ctx %>/profile.jsp">👤 My Profile</a>

      <% if ("tenant".equals(role)) { %>
        <div class="sep"></div>
        <a href="<%= ctx %>/browseListings.jsp">🔍 Browse Listings</a>
        <a href="<%= ctx %>/myBookings.jsp">🧾 My Bookings</a>
      <% } %>

      <% if ("landlord".equals(role)) { %>
        <div class="sep"></div>
        <a href="myProperties">🏘️ My Properties</a>
        <a href="<%= ctx %>/PostPoperty.jsp">➕ Post Property</a>
        <a href="<%= ctx %>/EditProperty.jsp">✏ Edit Property</a>
        <a href="<%= ctx %>/DeleteProperty.jsp">🗑 Delete Property</a>
      <% } %>

      <% if ("admin".equals(role)) { %>
        <div class="sep"></div>
        <a href="<%= ctx %>/admin.jsp">🛠️ Admin Dashboard</a>
        <a href="<%= ctx %>/manageUsers.jsp">👥 Manage Users</a>
        <a href="<%= ctx %>/adminReports.jsp">📑 Reports</a>
      <% } %>
    </nav>
  </aside>

  <!-- Main content  -->
  <main>
    <div class="card">
      <h2>🗑️ Delete a Property</h2>
      <p>Enter the Property ID below to delete it from the system.</p>
      <form action="PropertyDeleteServlet" method="post">
        <input type="number" name="property_id" placeholder="Enter Property ID" required>
        <button type="submit">Delete Property</button>
      </form>
    </div>
  </main>
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

</body>
</html>
