<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" session="true" %>
<%@ page import="java.net.URLEncoder" %>
<%@ page import="java.util.*" %>
<%@ page import="com.smart.rentalhub.model.User" %>
<%@ page import="com.smart.rentalhub.model.PrivacySettings" %>
<%@ page import="com.smart.rentalhub.model.CommunityPost" %>
<%
  String ctx = request.getContextPath();

  User target = (User) request.getAttribute("target");
  PrivacySettings ps = (PrivacySettings) request.getAttribute("ps");
  Boolean canViewObj = (Boolean) request.getAttribute("canView");
  boolean canView = (canViewObj != null) ? canViewObj.booleanValue() : true;

  @SuppressWarnings("unchecked")
  List<CommunityPost> posts = (List<CommunityPost>) request.getAttribute("posts");
  if (posts == null) posts = java.util.Collections.emptyList();

  User viewer = (User) session.getAttribute("user");
  boolean self = viewer != null && target.getId() == viewer.getId();

  String fn  = target.getProfileImg();
  String avatar = (fn != null && !fn.isBlank())
      ? (ctx + "/uploads/" + URLEncoder.encode(fn, "UTF-8"))
      : (ctx + "/assets/default-avatar.png");
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title><%= target.getUsername() %> – Profile</title>
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <style>
    :root{--bg:#f6f7f8;--card:#fff;--text:#1f2937;--muted:#6b7280;--border:#e5e7eb;--brand:#ff4500;--radius:12px;}
    body{margin:0;font-family:system-ui,-apple-system,Segoe UI,Roboto,Arial,sans-serif;background:var(--bg);color:var(--text)}
    .top{background:#fff;border-bottom:1px solid var(--border)}
    .top .inner{max-width:1100px;margin:0 auto;padding:10px 16px;display:flex;justify-content:space-between;align-items:center}
    .brand{color:var(--brand);font-weight:900;text-decoration:none}
    .wrap{max-width:1100px;margin:16px auto;padding:0 12px;display:grid;grid-template-columns:280px 1fr;gap:16px}
    @media (max-width: 960px){ .wrap{grid-template-columns:1fr} }
    .side,.main{background:#fff;border:1px solid var(--border);border-radius:var(--radius);padding:14px}
    .avatar{width:120px;height:120px;border-radius:50%;object-fit:cover;border:2px solid #fff;box-shadow:0 2px 10px rgba(0,0,0,.06)}
    .name{font-weight:900;font-size:20px;margin:10px 0 4px}
    .muted{color:var(--muted)}
    .btn{display:inline-block;border:1px solid var(--border);padding:8px 12px;border-radius:10px;text-decoration:none;color:#111827;background:#fff}
    .btn.primary{background:#ff4500;color:#fff;border-color:#ff4500}
    .row{margin:8px 0}
    .section{margin-bottom:16px}

    /* Posts */
    .post{border:1px solid var(--border);border-radius:12px;padding:12px;margin-bottom:12px;background:#fff}
    .post-head{display:flex;justify-content:space-between;gap:10px;color:var(--muted);font-size:12px}
    .post-body{margin:8px 0;color:var(--text);line-height:1.5}
    .post-img{display:block;max-width:100%;border-radius:10px;border:1px solid var(--border);margin-top:8px}
    .empty{padding:12px;border:1px dashed var(--border);border-radius:12px;color:var(--muted);text-align:center}
    .lock{padding:14px;border:1px solid #f3c7cd;background:#fdecef;color:#7a1120;border-radius:12px}
    
    
      
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

  <div class="top">
    <div class="inner">
      <a class="brand" href="<%= ctx %>/dashboard.jsp">SmartRentalHub</a>
      <a class="btn" href="<%= ctx %>/search.jsp">Back to Search</a>
    </div>
  </div>

  <div class="wrap">
    <aside class="side">
      <img class="avatar" src="<%= avatar %>" alt="Avatar">
      <div class="name"><%= target.getFullName()!=null && !target.getFullName().isBlank() ? target.getFullName() : target.getUsername() %></div>
      <div class="muted">@<%= target.getUsername() %></div>

    
    </aside>

    <main class="main">
      <% if (!canView) { %>
        <div class="lock">🔒 This profile is private.</div>
      <% } else { %>
        <div class="section">
          <h3>About</h3>
          <p class="muted"><%= target.getBio()!=null && !target.getBio().isBlank() ? target.getBio() : "No bio yet." %></p>
        </div>

        <div class="section">
          <h3>Public posts</h3>
          <% if (posts.isEmpty()) { %>
            <div class="empty">No public posts yet.</div>
          <% } else { 
               java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm");
               for (CommunityPost p : posts) {
                 String when = (p.getCreatedAt()!=null) ? sdf.format(p.getCreatedAt()) : "";
                 String img = p.getImagePath();
                 String imgUrl = (img!=null && !img.isBlank())
                   ? (ctx + "/uploads/" + URLEncoder.encode(img,"UTF-8"))
                   : null;
          %>
              <article class="post">
                <div class="post-head">
                  <div><strong>@<%= p.getUsername() %></strong></div>
                  <div><%= when %></div>
                </div>
                <div class="post-body"><%= p.getMessage()==null ? "" : p.getMessage() %></div>
                <% if (imgUrl != null) { %>
                  <img class="post-img" src="<%= imgUrl %>" alt="post image">
                <% } %>
              </article>
          <% } } %>
        </div>
      <% } %>
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



</body>
</html>
