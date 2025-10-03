<%@ page import="com.smart.rentalhub.model.User" %>
<%@ page import="com.smart.rentalhub.dao.AbuseReportDAO.PostReportRow" %>
<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" session="true" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null || user.getRole() == null || !"admin".equalsIgnoreCase(user.getRole())) {
        response.sendRedirect("login.jsp"); return;
    }

    // If opened directly, redirect through servlet so 'reports' is present
    java.util.List<PostReportRow> reportsAttr =
        (java.util.List<PostReportRow>) request.getAttribute("reports");
    if (reportsAttr == null) { response.sendRedirect(request.getContextPath() + "/admin/reports"); return; }

    String ctx = request.getContextPath();
    String fileName = user.getProfileImg();
    String avatar = (fileName != null && !fileName.isBlank())
        ? (ctx + "/uploads/" + java.net.URLEncoder.encode(fileName, "UTF-8").replace("+","%20"))
        : (ctx + "/assets/default-avatar.png");
%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8" />
  <title>Reports – SmartRentalHub</title>
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <style>
    :root{ --bg:#f6f7f8; --card:#fff; --text:#1f2937; --muted:#6b7280; --border:#e5e7eb; --brand:#ff4500; --hover:#f9fafb; --shadow:0 6px 20px rgba(0,0,0,.06); }
    *{box-sizing:border-box}
    body{margin:0;font-family:system-ui,-apple-system,Segoe UI,Roboto,Arial,sans-serif;background:var(--bg);color:var(--text)}
    .topbar{position:sticky;top:0;left:0;right:0;z-index:1000;background:#fff;border-bottom:1px solid var(--border);box-shadow:0 6px 20px rgba(0,0,0,.06)}
    .topbar .inner{max-width:1200px;margin:0 auto;padding:10px 20px;display:flex;justify-content:space-between;align-items:center}
    .brand{color:#ff4500;font-weight:800;font-size:22px;text-decoration:none}
    .avatar-mini{width:36px;height:36px;border-radius:50%;object-fit:cover;border:1px solid var(--border)}
    .badge{font-size:12px;padding:2px 8px;border-radius:999px;border:1px solid #ddd;background:#fff;color:#444}
    .badge.admin{color:#b00020;border-color:#f1b9bf;background:#fdecee}

    .shell{max-width:1200px;margin:20px auto;padding:0 16px;display:grid;grid-template-columns:260px 1fr;gap:20px}
    @media (max-width:960px){.shell{grid-template-columns:1fr}}

    .sidebar{position:sticky;top:80px;align-self:start;background:#fff;border:1px solid var(--border);border-radius:12px;padding:14px;box-shadow:var(--shadow)}
    .side-title{margin:4px 0 10px 6px;font-weight:800}
    .nav{display:flex;flex-direction:column;gap:6px}
    .nav a{display:flex;align-items:center;gap:10px;padding:10px 12px;border-radius:10px;text-decoration:none;color:var(--text)}
    .nav a:hover{background:var(--hover)}
    .nav .sep{height:1px;background:var(--border);margin:6px 6px}

    .card{background:#fff;border:1px solid var(--border);border-radius:12px;padding:16px;box-shadow:var(--shadow)}
    .muted{color:var(--muted)}
    table{width:100%;border-collapse:collapse}
    th,td{text-align:left;font-size:14px;padding:10px;border-bottom:1px solid var(--border)}
    th{background:#fafafa;font-weight:700}
    tr:hover td{background:#fafafa}
    .btn{display:inline-flex;align-items:center;gap:6px;background:#fff;border:1px solid var(--border);padding:6px 10px;border-radius:10px;color:#111827;font-weight:600;cursor:pointer}
    .btn.danger{border-color:#fca5a5;background:#fee2e2;color:#7f1d1d}
    .btn.warn{border-color:#fcd34d;background:#fef3c7;color:#78350f}
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
      <h2 style="margin:0 0 8px">Reported Posts</h2>
      <p class="muted" style="margin:0">Review user reports for community posts.</p>
    </section>

    <section class="card" style="margin-top:12px;">
      <table>
        <thead>
          <tr>
            <th style="width:70px;">Report #</th>
            <th style="width:80px;">Post ID</th>
            <th>Post Author</th>
            <th>Post Message</th>
            <th>Reporter</th>
            <th>Notes</th>
            <th style="width:180px;">Reported At</th>
            <th style="width:240px;">Actions</th>
          </tr>
        </thead>
        <tbody>
          <%
            java.util.List<PostReportRow> reports = reportsAttr;
            if (reports.isEmpty()) {
          %>
            <tr><td colspan="8" class="muted">No reports.</td></tr>
          <%
            } else {
              java.text.SimpleDateFormat fmt = new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm");
              for (PostReportRow r : reports) {
                String msg = (r.message == null) ? "" : r.message;
                String shortMsg = msg.length() > 120 ? msg.substring(0, 117) + "..." : msg;
          %>
            <tr id="r-<%= r.reportId %>">
              <td><%= r.reportId %></td>
              <td><%= r.postId %></td>
              <td>@<%= r.username %></td>
              <td title="<%= msg.replace("\"","'") %>"><%= shortMsg %></td>
              <td>@<%= r.reporter %></td>
              <td><%= (r.notes == null ? "" : r.notes) %></td>
              <td><%= fmt.format(r.reportedAt) %></td>
              <td style="display:flex;gap:8px;flex-wrap:wrap;">
                <a class="btn" href="<%= ctx %>/community.jsp">👁 View on Wall</a>
                <form action="<%= ctx %>/admin/dismissReport" method="post" onsubmit="return confirm('Dismiss this report?');" style="display:inline;">
                  <input type="hidden" name="reportId" value="<%= r.reportId %>">
                  <button class="btn warn" type="submit">✔ Dismiss</button>
                </form>
                <form action="<%= ctx %>/admin/deletePost" method="post" onsubmit="return confirm('Delete this post?');" style="display:inline;">
                  <input type="hidden" name="postId" value="<%= r.postId %>">
                  <button class="btn danger" type="submit">🗑 Delete Post</button>
                </form>
              </td>
            </tr>
          <%
              }
            }
          %>
        </tbody>
      </table>
    </section>
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