<%@ page import="com.smart.rentalhub.model.User" %>
<%@ page import="java.net.URLEncoder" %>
<%@ page session="true" contentType="text/html;charset=UTF-8" language="java" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    String ctx = request.getContextPath();

    // Avatar 
    String fileName = user.getProfileImg();
    String avatar = (fileName != null && !fileName.trim().isEmpty())
            ? (ctx + "/uploads/" + URLEncoder.encode(fileName, "UTF-8"))
            : (ctx + "/assets/default-avatar.png");

    // Role badge like dashboard
    String role = (user.getRole() != null) ? user.getRole().toLowerCase() : "tenant";
    String roleLabel =
        "admin".equals(role) ? "Admin" :
        "landlord".equals(role) ? "Landlord" : "Tenant";

    // Flash message 
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
    <title>SmartRentalHub – Post Property</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <style>
        :root{
          --bg:#f6f7f8; --card:#fff; --border:#e5e7eb; --text:#1f2937; --muted:#6b7280; --brand:#ff4500;
          --hover:#f9fafb;
        }
        body { font-family: Arial, sans-serif; margin:0; background:#f6f7f8; }

        /*  TOP BAR   */
        .topbar{position:sticky;top:0;z-index:100;background:#fff;border-bottom:1px solid var(--border)}
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
        .pill{font-weight:600;text-decoration:none;color:#1f2937}
        .pill:hover{opacity:.85}

        /* Page layout */
        .layout { display:flex; max-width:1200px; margin:auto; padding:20px; }
        .sidebar {
            width:250px; background:#fff; padding:15px; border-radius:8px;
            border:1px solid #ddd; margin-right:20px;
        }
        .sidebar h3 { margin-top:0; color:#333; }
        .sidebar ul { list-style:none; padding-left:0; }
        .sidebar li { margin:10px 0; }
        .sidebar a { text-decoration:none; color:#333; }

        .feed { flex-grow:1; }
        .card {
            background:#fff; border-radius:8px; padding:20px; margin-bottom:20px; border:1px solid #ddd;
        }
        .footer { text-align:center; padding:20px; font-size:14px; color:#aaa; }

        /* Form styling  */
        form input, form textarea, form select {
            width:100%;
            padding:10px;
            margin:8px 0;
            border:1px solid #ccc;
            border-radius:6px;
            font-size:14px;
        }
        form button {
            background:#ff4500;
            color:#fff;
            padding:10px 20px;
            border:none;
            border-radius:6px;
            cursor:pointer;
            font-size:15px;
        }
        form button:hover {
            background:#e03e00;
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

<!-- TOP BAR -->
<header class="topbar">
  <div class="toprow">
    <div class="brand"><a href="<%= ctx %>/index.jsp">SmartRentalHub</a></div>

    <!-- Search submits to /search -->
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

<div class="layout">
    <!-- Sidebar  -->
    <div class="sidebar">
        <h3>Navigation</h3>
        <ul>
            <li><a href="dashboard.jsp">🏠 Dashboard</a></li>
            <li><a href="PostPoperty.jsp">➕ Post Property</a></li>
            <li><a href="browseListings.jsp">🔍 Browse Listings</a></li>
            <li><a href="myProperties">🏘 My Properties</a></li>
            <li><a href="community.jsp">💬 Community Wall</a></li>
            <li><a href="profile.jsp">👤 My Profile</a></li>
        </ul>
    </div>

    <!-- Main content  -->
    <div class="feed">
        <div class="card">
            <h2>➕ Post a New Property</h2>
            <form action="PostPropertyServlet" method="post" enctype="multipart/form-data">
                <input type="text" name="title" placeholder="Property Title" required>
                <textarea name="description" placeholder="Description"></textarea>
                <input type="text" name="city" placeholder="City" required>
                <input type="number" name="price" placeholder="Price" required>
                <select name="property_type" placeholder="property_type" required>
                    <option>Apartment</option>
                    <option>House</option>
                    <option>Studio</option>
                    <option>Annex </option>
                    <option>Villa</option>
                    <option>Bungalow</option>
                    <option>Residential Land</option>
                    <option>Commercial Land</option>
                    <option>Beachfront Land</option>
                </select>
                <input type="file" name="image" accept="image/*" required>
                <button type="submit">Post Property</button>
            </form>
        </div>
    </div>
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