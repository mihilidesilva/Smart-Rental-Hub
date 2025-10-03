<%@ page import="java.util.List" %>
<%@ page import="com.smart.rentalhub.model.Property" %>
<%@ page import="com.smart.rentalhub.model.User" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" session="true" %>
<%
    // session ,, user for top bar + sidebar
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

    List<Property> properties = (List<Property>) request.getAttribute("properties");
%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8" />
  <title>SmartRentalHub – My Properties</title>
  <meta name="viewport" content="width=device-width, initial-scale=1">

  <!-- FontAwesome for icons -->
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">

  <style>
    :root{
      --bg:#f6f7f8; --card:#fff; --border:#e5e7eb; --text:#1f2937; --muted:#6b7280; --brand:#ff4500;
      --hover:#f9fafb; --shadow:0 6px 20px rgba(0,0,0,.06);
    }
    *{box-sizing:border-box}
    body{margin:0;font-family:system-ui, -apple-system, Segoe UI, Roboto, Arial, sans-serif;background:linear-gradient(120deg,#ffffff,#fff8f0);color:var(--text)}

    /* Topbar  */
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

    /* Layout with sidebar */
    .shell{max-width:1200px;margin:18px auto;padding:0 16px;display:grid;grid-template-columns:260px 1fr;gap:20px}
    @media (max-width: 960px){ .shell{grid-template-columns:1fr} .sidebar{position:static} }
    .sidebar{position:sticky;top:70px;align-self:start;background:#fff;border:1px solid var(--border);border-radius:12px;padding:14px;box-shadow:var(--shadow)}
    .side-title{margin:4px 0 10px 6px;font-weight:800}
    .nav{display:flex;flex-direction:column;gap:4px}
    .nav a{display:flex;align-items:center;gap:10px;padding:10px 12px;border-radius:10px;text-decoration:none;color:var(--text)}
    .nav a:hover{background:var(--hover)}
    .nav .sep{height:1px;background:var(--border);margin:8px 6px}

    /* Property cards */
    .page-title { text-align:center; font-size:2rem; color:#333; margin: 0 0 20px; }
    .property-container { display:grid; grid-template-columns:repeat(auto-fill, minmax(300px,1fr)); gap:25px; }
    .property-card { background:#fff; border-radius:15px; overflow:hidden; box-shadow:0 6px 20px rgba(230,115,50,.15); transition:.3s; display:flex; flex-direction:column; }
    .property-card:hover { transform:translateY(-5px); box-shadow:0 12px 25px rgba(230,115,50,.25); }
    .property-image img { width:100%; height:220px; object-fit:cover; display:block; transition:transform .3s; }
    .property-card:hover .property-image img { transform:scale(1.05); }
    .property-details { padding:20px; flex-grow:1; display:flex; flex-direction:column; }
    .property-details h3 { font-size:1.2rem; color:#222; margin:0 0 5px; }
    .property-city { font-size:14px; color:#777; margin-bottom:15px; }
    .property-price { font-weight:bold; font-size:16px; color:#fff; padding:8px 12px; border-radius:8px;
                      background:linear-gradient(135deg,#f6a11f,#e94e1b); text-align:center; width:fit-content; }
    .property-desc { font-size:.9rem; color:#555; line-height:1.4; }
    .no-properties { text-align:center; color:#777; grid-column:1 / -1; font-size:1rem; }

    @media (max-width: 600px){ .property-container{ grid-template-columns:1fr } }

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

<header class="topbar">
  <div class="toprow">
    <div class="brand"><a href="<%=ctx%>/index.jsp">SmartRentalHub</a></div>

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

<div class="shell">
  <!-- Sidebar -->
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
        <a href="myProperties">🏘 My Properties</a>
        <a href="<%= ctx %>/PostPoperty.jsp">➕ Post Property</a>
        <a href="browseListings.jsp">🔍 Browse Listings</a>
      <% } %>

      <% if ("admin".equals(role)) { %>
        <div class="sep"></div>
        <a href="<%= ctx %>/admin.jsp">🛠 Admin Dashboard</a>
        <a href="<%= ctx %>/manageUsers.jsp">👥 Manage Users</a>
        <a href="<%= ctx %>/adminReports.jsp">📑 Reports</a>
      <% } %>
    </nav>
  </aside>

  <!-- Main column -->
  <div>
    <div class="property-container">
      <%
          if (properties != null && !properties.isEmpty()) {
              for (Property p : properties) {
      %>
        <div class="property-card">
          <div class="property-image">
            <img src="property-image?name=<%= p.getImage() %>" alt="Property Image">
          </div>
          <div class="property-details">
              <!-- Show Property ID -->
            <p class="property-id"><strong>Property ID:</strong> <%= p.getId() %></p>
              
              
            <h3><%= p.getTitle() %></h3>
            <p class="property-city"><i class="fas fa-map-marker-alt"></i> <%= p.getCity() %></p>
            <p class="property-price">Rs. <%= p.getPrice() %></p>
            <p class="property-desc"><%= p.getDescription() %></p>
            
            
            <!-- Buttons -->
          <div class="property-actions">
            <!-- Edit Button -->
            <form action="EditProperty.jsp" method="get" style="display:inline;">
              <input type="hidden" name="id" value="<%= p.getId() %>">
              <button type="submit" style="background: linear-gradient(135deg, #007BFF, #ffffff); color:#003366; border:none; padding:8px 14px;  border-radius:6px; font-size:14px; cursor:pointer; font-weight:bold; transition:0.3s;" >Edit</button>
            </form>

            <!-- Delete Button -->
            <form action="DeleteProperty.jsp" method="get" style="display:inline;">
              <input type="hidden" name="id" value="<%= p.getId() %>">
              <button type="submit"    style="background: linear-gradient(135deg, #f44336, #ffffff); color:#660000; border:none; padding:8px 14px; border-radius:6px; font-size:14px; cursor:pointer; font-weight:bold; transition:0.3s;"  onclick="return confirm('Are you sure you want to delete this property?');">Delete </button>
            </form>
          </div>
              
         </div>  
        </div>
      <%
              }
          } else {
      %>
        <p class="no-properties">No properties found.</p>
      <%
          }
      %>
    </div>
  </div>
</div> <!-- CLOSE .shell BEFORE FOOTER -->

<!-- FOOTER  -->
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