<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*" %>
<%@ page import="java.net.URLEncoder" %>
<%@ page import="com.smart.rentalhub.model.User" %>
<%
  String ctx = request.getContextPath();
  String q = (String) request.getAttribute("query");
  List<Map<String,Object>> results = (List<Map<String,Object>>) request.getAttribute("results");
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Search – SmartRentalHub</title>
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <style>
    :root{--bg:#f6f7f8;--card:#fff;--text:#1f2937;--muted:#6b7280;--border:#e5e7eb;--brand:#ff4500;--radius:12px;}
    body{margin:0;font-family:system-ui,-apple-system,Segoe UI,Roboto,Arial,sans-serif;background:var(--bg);color:var(--text)}
    .top{background:#fff;border-bottom:1px solid var(--border)}
    .top .inner{
      max-width:1100px;margin:0 auto;padding:10px 16px;
      display:flex;align-items:center;gap:12px;
    }
    .brand{color:var(--brand);font-weight:900;text-decoration:none;white-space:nowrap}
    .wrap{max-width:1100px;margin:16px auto;padding:0 12px}
    .panel{background:#fff;border:1px solid var(--border);border-radius:var(--radius);padding:14px}
    .head{display:flex;justify-content:space-between;align-items:center;margin-bottom:10px}
    .list{list-style:none;margin:0;padding:0;display:grid;gap:10px}
    .item{display:flex;justify-content:space-between;align-items:center;border:1px solid var(--border);border-radius:10px;background:#fff;padding:10px}
    .who{display:flex;gap:12px;align-items:center}
    .avatar{width:48px;height:48px;border-radius:50%;object-fit:cover;border:1px solid var(--border);background:#f3f4f6}
    .name{font-weight:800}
    .muted{color:var(--muted);font-size:14px}
    .btn{display:inline-block;border:1px solid var(--border);padding:8px 12px;border-radius:10px;text-decoration:none;color:#111827;background:#fff}
    .btn:hover{background:#f3f4f6}
    .lock{color:#b00020;font-weight:700}

  /* Topbar */
    .topbar{position:sticky;top:0;z-index:20;background:#fff;border-bottom:1px solid var(--border);}
    .toprow{max-width:1200px;margin:0 auto;display:flex;align-items:center;gap:16px;padding:10px 16px}
    .brand a{color:var(--brand);font-weight:800;font-size:20px;letter-spacing:.2px;text-decoration:none}
    .search{flex:1;display:flex;align-items:center;background:var(--hover);border:1px solid var(--border);border-radius:10px;padding:8px 12px}
    .search input{border:none;background:transparent;outline:none;width:100%;font-size:14px}
    .search .sbtn{border:none;background:transparent;cursor:pointer;font-size:16px;padding:4px 6px;border-radius:8px}
    .search .sbtn:hover{background:#eef2f7}

    /* right-side actions in top bar */
    .actions{display:flex;gap:8px;white-space:nowrap}
  </style>
</head>
<body>
  <div class="top">
    <div class="inner">
      <a class="brand" href="<%= ctx %>/dashboard.jsp">SmartRentalHub</a>
<!-- Search form submits to /search -->
    <form class="search" action="<%= ctx %>/search" method="get">
      <input type="search" name="q" placeholder="Search users…" aria-label="Search users" required>
      <button class="sbtn" type="submit" title="Search">🔎</button>
    </form>
      
      <!--  top bar buttons -->
      <div class="actions">
        <a class="btn" href="<%= ctx %>/dashboard.jsp">Dashboard</a>
        <a class="btn" href="<%= ctx %>/community.jsp">Community</a>
        <a class="btn" href="<%= ctx %>/profile.jsp">Profile</a>
        <a class="btn" href="<%= ctx %>/logout.jsp">Logout</a>
      </div>
    </div>
  </div>

  <div class="wrap">
    <div class="panel">
      <div class="head">
        <div><strong>Results</strong> for “<%= q %>”</div>
        <div class="muted"><%= (results!=null?results.size():0) %> users</div>
      </div>

      <ul class="list">
        <% if (results == null || results.isEmpty()) { %>
          <li class="muted">No users found.</li>
        <% } else {
             for (Map<String,Object> r : results) {
               User u = (User) r.get("user");
               boolean canView = (Boolean) r.get("canView");
               String fn = u.getProfileImg();
               String avatar = (fn != null && !fn.isBlank())
                   ? (ctx + "/uploads/" + URLEncoder.encode(fn, "UTF-8"))
                   : (ctx + "/assets/default-avatar.png");
        %>
          <li class="item">
            <div class="who">
              <img class="avatar" src="<%= avatar %>" alt="avatar">
              <div>
                <div class="name"><%= u.getFullName()!=null && !u.getFullName().isBlank()? u.getFullName(): u.getUsername() %></div>
                <div class="muted">@<%= u.getUsername() %></div>
              </div>
            </div>
            <div>
              <% if (canView) { %>
                <a class="btn" href="<%= ctx %>/user?username=<%= URLEncoder.encode(u.getUsername(),"UTF-8") %>">View profile</a>
              <% } else { %>
                <span class="lock">🔒 Private</span>
              <% } %>
            </div>
          </li>
        <% } } %>
      </ul>
    </div>
  </div>
</body>



