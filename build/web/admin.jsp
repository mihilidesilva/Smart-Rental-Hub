<%@ page import="com.smart.rentalhub.model.User" %>
<%@ page import="com.smart.rentalhub.dao.UserDAO" %>
<%@ page import="com.smart.rentalhub.util.DBConnection" %> <!-- ✅ added -->
<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" session="true" %>
<%
    //only admins can access
    User user = (User) session.getAttribute("user");
    if (user == null) { response.sendRedirect("login.jsp"); return; }
    String roleVal = (user.getRole() != null) ? user.getRole().toLowerCase() : "tenant";
    if (!"admin".equals(roleVal)) { response.sendRedirect("dashboard.jsp"); return; }

    String ctx = request.getContextPath();
    String fileName = user.getProfileImg();
    String avatar = (fileName != null && !fileName.isBlank())
        ? (ctx + "/uploads/" + java.net.URLEncoder.encode(fileName, "UTF-8").replace("+","%20"))
        : (ctx + "/assets/default-avatar.png");

    String roleLabel = "Admin";

    
%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8" />
  <title>Admin Dashboard – SmartRentalHub</title>
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <style>
    :root{
      --bg:#f6f7f8; --card:#fff; --text:#1f2937; --muted:#6b7280; --border:#e5e7eb;
      --brand:#ff4500; --hover:#f9fafb; --shadow:0 6px 20px rgba(0,0,0,.06);
    }
    *{box-sizing:border-box}
    body{margin:0;font-family:system-ui,-apple-system,Segoe UI,Roboto,Arial,sans-serif;background:var(--bg);color:var(--text)}
    .topbar { position: sticky; top: 0; left: 0; right: 0; z-index: 1000; background: #fff; border-bottom: 1px solid #e5e7eb; box-shadow: 0 6px 20px rgba(0,0,0,.06); }
    .topbar .inner { max-width: 1200px; margin: 0 auto; padding: 10px 20px; display: flex; justify-content: space-between; align-items: center; }
    .brand { color: #ff4500; font-weight: 800; font-size: 22px; text-decoration: none; }
    .avatar-mini { width: 36px; height: 36px; border-radius: 50%; object-fit: cover; border: 1px solid #e5e7eb; }
    .badge { font-size: 12px; padding: 2px 8px; border-radius: 999px; border: 1px solid #ddd; background: #fff; color: #444; }
    .badge.admin { color: #b00020; border-color: #f1b9bf; background: #fdecee; }
    .shell{max-width:1200px;margin:20px auto;padding:0 16px;display:grid;grid-template-columns:260px 1fr;gap:20px}
    @media (max-width: 960px){ .shell{grid-template-columns:1fr} }
    .sidebar{position:sticky;top:80px;align-self:start;background:#fff;border:1px solid var(--border);border-radius:12px;padding:14px;box-shadow:var(--shadow)}
    .side-title{margin:4px 0 10px 6px;font-weight:800}
    .nav{display:flex;flex-direction:column;gap:6px}
    .nav a{display:flex;align-items:center;gap:10px;padding:10px 12px;border-radius:10px;text-decoration:none;color:var(--text)}
    .nav a:hover{background:var(--hover)}
    .nav .sep{height:1px;background:var(--border);margin:6px 6px}
    .card{background:#fff;border:1px solid var(--border);border-radius:12px;padding:16px;box-shadow:var(--shadow)}
    .muted{color:var(--muted)}
    .btn { display:inline-flex;align-items:center;gap:8px;background:#fff;border:1px solid var(--border);padding:8px 12px;border-radius:10px;color:#111827;font-weight:600;cursor:pointer }
    .btn.danger { border-color:#fca5a5; background:#fee2e2; color:#7f1d1d }
    .btn.warn { border-color:#fcd34d; background:#fef3c7; color:#78350f }
    .tabs { display:flex; gap:8px; flex-wrap:wrap; margin:0 0 12px }
    .tab { padding:8px 12px; border:1px solid var(--border); border-radius:999px; background:#fff; cursor:pointer }
    .tab:hover { background:var(--hover) }
    .tab-section { display:none }
    table { width:100%; border-collapse:collapse }
    th, td { text-align:left; font-size:14px; padding:10px; border-bottom:1px solid var(--border) }
    th { background:#fafafa; font-weight:700 }
    tr:hover td { background: #fafafa }
    .actions { display:flex; gap:8px; flex-wrap:wrap }
    .img { max-height:80px; border:1px solid var(--border); border-radius:8px }
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
<div class="topbar">
  <div class="inner">
    <a href="<%= ctx %>/index.jsp" class="brand">SmartRentalHub</a>
    <div class="userbox" style="display:flex;align-items:center;gap:16px;">
      <span class="welcome" style="display:flex;align-items:center;gap:8px;">
        Hello, <strong><%= user.getFullName() %></strong>
        <span class="badge admin">Admin</span>
      </span>
      <a href="<%= ctx %>/profile.jsp" title="View profile"><img class="avatar-mini" src="<%= avatar %>" alt="Profile"></a>
      <a href="<%= ctx %>/logout.jsp" style="text-decoration:none;color:#1f2937">Logout</a>
    </div>
  </div>
</div>

<div class="shell">
  <aside class="sidebar">
    <div class="side-title">Navigation</div>
    <nav class="nav">
      <a href="<%= ctx %>/index.jsp">🏡 Home </a>
      <a href="<%= ctx %>/dashboard.jsp">📊 Dashboard</a>
      
      <div class="sep"></div>
      <a href="<%= ctx %>/community.jsp">💬 Community Wall</a>
      <a href="<%= ctx %>/profile.jsp">👤 My Profile</a>
      <div class="sep"></div>
      <a href="<%= ctx %>/admin.jsp">🛠 Control Center</a>
      <a href="<%= ctx %>/adminReports.jsp">📑 Reports</a>
      
      <div class="sep"></div>
      <a href="<%= ctx %>/editProfile.jsp">⚙ Settings</a>
      <a href="<%= ctx %>/logout.jsp">🚪 Logout</a>
    </nav>
  </aside>

  <main>
    <section class="card">
      <h2 style="margin:0 0 8px">Admin Dashboard</h2>
      <p class="muted" style="margin:0">View and manage users, properties, and posts. Use actions to delete or report content.</p>
      <div class="tabs" style="margin-top:12px">
        <button class="tab" onclick="showSection('users')">Users</button>
        <button class="tab" onclick="showSection('properties')">Properties</button>
        <button class="tab" onclick="showSection('posts')">Posts</button>
      </div>
    </section>

    <!-- USERS -->
    <section id="users" class="tab-section card" style="margin-top:12px;">
      <h3 style="margin:0 0 10px">All Users</h3>
      <table>
        <thead>
          <tr>
            <th style="width:60px;">ID</th>
            <th>Username</th>
            <th>Full Name</th>
            <th>Email</th>
            <th style="width:120px;">Role</th>
            <th style="width:220px;">Actions</th>
          </tr>
        </thead>
        <tbody>
        <%
          //  use shared DBConnection
          try (java.sql.Connection c = DBConnection.getConnection();
               java.sql.PreparedStatement ps = c.prepareStatement(
                  "SELECT id, username, full_name, email, role FROM users ORDER BY id DESC");
               java.sql.ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
        %>
          <tr>
            <td><%= rs.getInt("id") %></td>
            <td>@<%= rs.getString("username") %></td>
            <td><%= rs.getString("full_name") == null ? "" : rs.getString("full_name") %></td>
            <td><%= rs.getString("email") == null ? "" : rs.getString("email") %></td>
            <td><%= rs.getString("role") %></td>
            <td class="actions">
              <form action="<%= ctx %>/admin/deleteUser" method="post" onsubmit="return confirm('Delete this user? This cannot be undone.');">
                <input type="hidden" name="userId" value="<%= rs.getInt("id") %>">
                <button class="btn danger" type="submit">🗑 Delete</button>
              </form>
<!--              <form action="<%= ctx %>/admin/reportUser" method="post" onsubmit="return confirm('Report this user to the abuse queue?');">
                <input type="hidden" name="userId" value="<%= rs.getInt("id") %>">
                <button class="btn warn" type="submit">🚩 Report</button>
              </form>-->
            </td>
          </tr>
        <%
            }
          } catch (Exception ex) {
        %>
          <tr><td colspan="6" class="muted">Unable to load users: <%= ex.getMessage() %></td></tr>
        <% } %>
        </tbody>
      </table>
    </section>

    <!-- PROPERTIES -->
<section id="properties" class="tab-section card" style="margin-top:12px;">
  <h3 style="margin:0 0 10px">All Properties</h3>
  <p class="muted" style="margin:0 0 10px;">If this section is empty, ensure you have a <code>properties</code> table with basic fields.</p>
  <table>
    <thead>
      <tr>
        <th style="width:60px;">ID</th>
        <th>Title</th>
        <th>City</th> 
        <th style="width:120px;">Price</th>
        <th>Owner</th>
        <th style="width:220px;">Actions</th>
      </tr>
    </thead>
    <tbody>
    <%
      try (java.sql.Connection c = com.smart.rentalhub.util.DBConnection.getConnection();
           java.sql.PreparedStatement ps = c.prepareStatement(
             "SELECT p.id, p.title, p.city, p.price, u.username AS owner_username " +
             "FROM properties p " +
             "JOIN users u ON u.id = p.landlord_id " +
             "ORDER BY p.id DESC");
           java.sql.ResultSet rs = ps.executeQuery()) {
        boolean any = false;
        while (rs.next()) {
          any = true;
    %>
      <tr>
        <td><%= rs.getInt("id") %></td>
        <td><%= rs.getString("title") %></td>
        <td><%= rs.getString("city") %></td>
        <td><%= rs.getBigDecimal("price") == null ? "" : rs.getBigDecimal("price").toPlainString() %></td>
        <td>@<%= rs.getString("owner_username") %></td>
        <td class="actions">
          <form action="<%= ctx %>/admin/deleteProperty" method="post" onsubmit="return confirm('Delete this property?');">
            <input type="hidden" name="propertyId" value="<%= rs.getInt("id") %>">
            <button class="btn danger" type="submit">🗑 Delete</button>
          </form>
<!--          <form action="<%= ctx %>/admin/reportProperty" method="post" onsubmit="return confirm('Report this property?');">
            <input type="hidden" name="propertyId" value="<%= rs.getInt("id") %>">
            <button class="btn warn" type="submit">🚩 Report</button>
          </form>-->
        </td>
      </tr>
    <%
        }
        if (!any) {
    %>
      <tr><td colspan="6" class="muted">No properties found (or table empty).</td></tr>
    <%
        }
      } catch (Exception ex) {
    %>
      <tr><td colspan="6" class="muted">Properties disabled: <%= ex.getMessage() %></td></tr>
    <% } %>
    </tbody>
  </table>
</section>

    <!-- POSTS -->
    <section id="posts" class="tab-section card" style="margin-top:12px;">
      <h3 style="margin:0 0 10px">All Posts</h3>
      <table>
        <thead>
          <tr>
            <th style="width:60px;">ID</th>
            <th>User</th>
            <th>Message</th>
            <th style="width:140px;">Image</th>
            <th style="width:160px;">Created</th>
            <th style="width:240px;">Actions</th>
          </tr>
        </thead>
        <tbody>
        <%
          String uploadsBase = ctx + "/uploads/";
          try (java.sql.Connection c = DBConnection.getConnection();
               java.sql.PreparedStatement ps = c.prepareStatement(
                 "SELECT id, username, message, image_path, created_at FROM community_posts ORDER BY created_at DESC");
               java.sql.ResultSet rs = ps.executeQuery()) {
            boolean any = false;
            while (rs.next()) {
              any = true;
              String img = rs.getString("image_path");
              String imgUrl = null;
              if (img != null && !img.isBlank()) {
                imgUrl = uploadsBase + java.net.URLEncoder.encode(img, "UTF-8").replace("+","%20");
              }
        %>
          <tr>
            <td><%= rs.getInt("id") %></td>
            <td>@<%= rs.getString("username") %></td>
            <td><%= rs.getString("message") == null ? "" : rs.getString("message") %></td>
            <td>
              <% if (imgUrl != null) { %>
                <img class="img" src="<%= imgUrl %>" alt="post image">
              <% } else { %>
                <span class="muted">—</span>
              <% } %>
            </td>
            <td><%= new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm").format(rs.getTimestamp("created_at")) %></td>
            <td class="actions">
              <form action="<%= ctx %>/admin/deletePost" method="post" onsubmit="return confirm('Delete this post?');">
                <input type="hidden" name="postId" value="<%= rs.getInt("id") %>">
                <button class="btn danger" type="submit">🗑 Delete</button>
              </form>
<!--              <form action="<%= ctx %>/admin/reportPost" method="post" onsubmit="return confirm('Report this post to abuse queue?');">
                <input type="hidden" name="postId" value="<%= rs.getInt("id") %>">
                <button class="btn warn" type="submit">🚩 Report</button>
              </form>-->
            </td>
          </tr>
        <%
            }
            if (!any) {
        %>
          <tr><td colspan="6" class="muted">No posts yet.</td></tr>
        <%
            }
          } catch (Exception ex) {
        %>
          <tr><td colspan="6" class="muted">Unable to load posts: <%= ex.getMessage() %></td></tr>
        <% } %>
        </tbody>
      </table>
    </section>
  </main>
</div>

<script>
  function showSection(id) {
    document.querySelectorAll('.tab-section').forEach(s => s.style.display = 'none');
    var el = document.getElementById(id);
    if (el) el.style.display = 'block';
    location.hash = id;
  }
  window.addEventListener('DOMContentLoaded', function(){
    const hash = (location.hash || '').replace('#','');
    if (hash && document.getElementById(hash)) showSection(hash); else showSection('users');
  });
</script>

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