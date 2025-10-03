<%@ page import="com.smart.rentalhub.model.User" %>
<%@ page import="com.smart.rentalhub.dao.UserDAO" %>
<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" session="true" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null) { response.sendRedirect("login.jsp"); return; }

    String ctx = request.getContextPath();
    String fileName = user.getProfileImg();
    String avatar = (fileName != null && !fileName.isBlank())
        ? (ctx + "/uploads/" + java.net.URLEncoder.encode(fileName, "UTF-8").replace("+","%20"))
        : (ctx + "/assets/default-avatar.png");

    String role = (user.getRole() != null) ? user.getRole().toLowerCase() : "tenant";
    String roleLabel =
        "admin".equals(role) ? "Admin" :
        "landlord".equals(role) ? "Landlord" : "Tenant";

    // Flash message 
    String flash = (String) session.getAttribute("flash");
    if (flash != null) session.removeAttribute("flash");
%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8" />
  <title>Community Wall – SmartRentalHub</title>
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  
  
<style>
 
  :root{
    --bg:#f8fafc;         
    --card:#ffffff;       
    --text:#0f172a;       
    --muted:#64748b;       
    --border:#e2e8f0;      
    --brand:#0f172a;      
    --hover:#f8fafc;       
    --shadow:0 10px 25px rgba(2,6,23,.06);
  }

  *{box-sizing:border-box}
  body{
    margin:0;
    font-family:system-ui,-apple-system,Segoe UI,Roboto,Arial,sans-serif;
    background:var(--bg);
    color:var(--text);
  }

  /* --- Top bar --- */
  .topbar{
    position:sticky; top:0; left:0; right:0; z-index:1000;
    background:#fff;
    border-bottom:1px solid var(--border);
    box-shadow:var(--shadow);
  }
  .topbar .inner{max-width:1200px;margin:0 auto;padding:10px 20px;display:flex;justify-content:space-between;align-items:center}
  .brand{color:var(--brand);font-weight:800;font-size:22px;text-decoration:none}
  .avatar-mini{width:36px;height:36px;border-radius:50%;object-fit:cover;border:1px solid var(--border)}
  .badge{font-size:12px;padding:2px 8px;border-radius:999px;border:1px solid #dfe3ea;background:#fff;color:#475569}
  .badge.admin{color:#b00020;border-color:#f1b9bf;background:#fdecee}
  .badge.landlord{color:#1a73e8;border-color:#cfe2ff;background:#eef5ff}
  .badge.tenant{color:#0a7b34;border-color:#cfead9;background:#e9f7ef}

  /* --- Layout & sidebar --- */
  .shell{max-width:1200px;margin:20px auto;padding:0 16px;display:grid;grid-template-columns:260px 1fr;gap:20px}
  @media (max-width:960px){.shell{grid-template-columns:1fr}}
  .sidebar{
    position:sticky; top:80px; align-self:start;
    background:#fff; border:1px solid var(--border); border-radius:14px; padding:14px; box-shadow:var(--shadow)
  }
  .side-title{margin:4px 0 10px 6px;font-weight:800;color:var(--text)}
  .nav{display:flex;flex-direction:column;gap:6px}
  .nav a{
    display:flex;align-items:center;gap:10px;padding:10px 12px;border-radius:10px;
    text-decoration:none;color:var(--text); transition:background .15s, transform .06s;
  }
  .nav a:hover{background:var(--hover); transform:translateX(2px)}
  .nav .sep{height:1px;background:var(--border);margin:6px 6px}

  /* --- Cards & headings --- */
  .card{
    background:var(--card);
    border:1px solid var(--border);
    border-radius:14px;
    padding:16px;
    box-shadow:var(--shadow);
  }
  .card h2{margin:0 0 8px; font-size:20px; font-weight:800; color:var(--text)}
  .muted{color:var(--muted)}

  /* --- Global buttons --- */
  .btn{
    display:inline-flex; align-items:center; gap:8px;
    background:#fff; color:var(--text);
    border:1px solid var(--border); padding:8px 12px; border-radius:999px;
    font-weight:600; cursor:pointer; transition:background .15s, transform .05s, border-color .15s, color .15s;
  }
  .btn:hover{background:#fafafa}
  .btn:active{transform:scale(.98)}
  .btn:focus-visible{outline:3px solid rgba(15,23,42,.15); outline-offset:2px; border-color:#cbd5e1}

  /* --- Composer  --- */
  section.card form[action$="/community/post"]{
    border:1px solid var(--border); border-radius:14px; padding:12px; background:#fff;
  }
  section.card form[action$="/community/post"] textarea{
    width:100%; min-height:96px;
    border:1px solid var(--border); border-radius:12px; padding:10px;
    color:var(--text); background:#fff; outline:none;
    transition:border .15s, box-shadow .15s;
  }
  section.card form[action$="/community/post"] textarea:focus{
    border-color:#cbd5e1; box-shadow:0 0 0 3px rgba(15,23,42,.08);
  }
  section.card form[action$="/community/post"] .btn{
    background:var(--brand); color:#fff; border-color:var(--brand);
  }
  section.card form[action$="/community/post"] .btn:hover{filter:brightness(.95)}

  /* --- Feed / Posts --- */
  #wall-feed{display:flex; flex-direction:column; gap:14px}
  #wall-feed article{
    border:1px solid var(--border); border-radius:14px; padding:12px; background:#fff;
    transition:transform .12s, box-shadow .15s, border-color .15s;
    animation:fadeInUp .22s ease both;
  }
  #wall-feed article:hover{ transform:translateY(-2px); box-shadow:var(--shadow); border-color:#dbe4ee }
  @keyframes fadeInUp{ from{opacity:0; transform:translateY(6px)} to{opacity:1; transform:translateY(0)} }

  /* Meta line  */
  #wall-feed .muted{color:var(--muted); font-size:12px}
  #wall-feed .muted strong{color:var(--text)}

  /* Post message body */
  #wall-feed p{ margin:8px 0; color:var(--text); line-height:1.6; }

  /* Post images (when present) */
  #wall-feed img[alt="post image"]{
    display:block; width:100%; height:auto;
    border-radius:12px; border:1px solid var(--border); margin:6px 0;
    box-shadow:0 6px 20px rgba(0,0,0,.05);
  }

  /* --- Action row  --- */
  #wall-feed .g-like-btn,
  #wall-feed .g-toggle-comments,
  #wall-feed form[action$="/community/report"] button{
    border:1px solid var(--border) !important;
    background:#fff !important;
    border-radius:999px !important;
    padding:6px 12px !important;
    cursor:pointer; font-weight:600;
    transition:background .15s, transform .05s, border-color .15s, color .15s;
  }
  #wall-feed .g-like-btn:hover,
  #wall-feed .g-toggle-comments:hover,
  #wall-feed form[action$="/community/report"] button:hover{ background:#fafafa !important }
  #wall-feed .g-like-btn:active,
  #wall-feed .g-toggle-comments:active,
  #wall-feed form[action$="/community/report"] button:active{ transform:scale(.98) }
  /* Liked state */
  #wall-feed .g-like-btn.liked{
    background:var(--brand) !important;
    color:#fff !important;
    border-color:var(--brand) !important;
  }
  /* Small counters beside buttons */
  #wall-feed span[id^="like-count-"],
  #wall-feed span[id^="comment-count-"]{
    font-size:12px; color:var(--muted);
    padding:2px 6px; border:1px solid var(--border); border-radius:999px; background:#fff;
  }

  /* --- Comments list & form --- */
  #wall-feed [id^="comments-"]{
    margin-top:10px; display:none; flex-direction:column; gap:8px;
  }
  #wall-feed [id^="comments-"] > div{
    border:1px solid var(--border); border-radius:10px; padding:8px; background:#fff;
  }
/*  #wall-feed .g-empty-*{ color:var(--muted); }
  #wall-feed .g-comment-form{
    margin-top:10px; display:none; gap:8px; align-items:center;
  }*/
  #wall-feed .g-comment-form input{
    flex:1; border:1px solid var(--border); border-radius:10px; padding:8px; color:var(--text); background:#fff;
    transition:border .15s, box-shadow .15s;
  }
  #wall-feed .g-comment-form input:focus{
    border-color:#cbd5e1; box-shadow:0 0 0 3px rgba(15,23,42,.08);
  }
  #wall-feed .g-comment-form .btn{ background:#fff; }

  /* --- Info alert for flash message --- */
  .card > div[style*="background:#eef5ff"]{
    border-color:#cfe2ff !important;
    background:#eef5ff !important;
    color:#1e3a8a !important;
    border-radius:12px; 
  }


  ::-webkit-scrollbar{height:10px;width:10px}
  ::-webkit-scrollbar-thumb{background:#dfe7f1;border-radius:10px;border:2px solid #fff}
  ::-webkit-scrollbar-thumb:hover{background:#cad6e7}
  
  
  
         
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
        Hi, <strong><%= user.getFullName() %></strong>
        <span class="badge <%= role %>"><%= roleLabel %></span>
      </span>
      <a href="<%= ctx %>/profile.jsp" title="View profile"><img class="avatar-mini" src="<%= avatar %>" alt="Profile"></a>
      <a href="<%= ctx %>/logout.jsp" style="text-decoration:none;color:#1f2937">Logout</a>
    </div>
  </div>
</div>

<div class="shell">
  <!-- Sidebar-->
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
        
      <% } %>

      <% if ("landlord".equals(role)) { %>
        <div class="sep"></div>
        <a href="myProperties">🏘 My Properties</a>
        <a href="<%= ctx %>/PostPoperty.jsp">➕ Post Property</a>
        <a href="browseListings.jsp">🔍 Browse Listings</a>
        
      
      <% } %>

      <% if ("admin".equals(role)) { %>
        <div class="sep"></div>
        <a href="<%= ctx %>/admin.jsp">🛠 Control Center</a>
        <a href="<%= ctx %>/adminReports.jsp">📑 Reports</a>
        <div class="sep"></div>
      <% } %>
      
      <a href="<%= ctx %>/editProfile.jsp">⚙ Settings</a>
      <a href="<%= ctx %>/logout.jsp">🚪 Logout</a>

    </nav>
  </aside>

  <!-- Main content -->
  <main>
    <section class="card">
      <h2 style="margin:0 0 8px">Community Wall</h2>
      <p class="muted" style="margin:0">See what tenants are posting across SmartRentalHub.</p>

      <% if (flash != null) { %>
        <div style="margin-top:12px;padding:10px;border:1px solid #cfe2ff;background:#eef5ff;border-radius:10px;color:#1a73e8;">
          <%= flash %>
        </div>
      <% } %>
    </section>

    <!-- Composer -->
    <% if ("tenant".equals(role)) { %>
      <section class="card" style="margin-top:12px;">
        <form action="<%= ctx %>/community/post" method="post" style="display:flex;flex-direction:column;gap:10px;">
          <textarea name="message" rows="3" placeholder="Share something with everyone…"
                    style="width:100%; resize:vertical; border:1px solid var(--border); border-radius:10px; padding:10px;"></textarea>
          <div style="display:flex; justify-content:flex-end;">
            <button type="submit" class="btn" style="background:var(--brand); color:#fff; border-color:var(--brand)">Post</button>
          </div>
        </form>
      </section>
    <% } %>

    <!-- Feed: all posts from TENANTS -->
    <%@ page import="java.util.*" %>
    <%@ page import="com.smart.rentalhub.dao.CommunityPostDAO" %>
    <%@ page import="com.smart.rentalhub.model.CommunityPost" %>
    <%@ page import="com.smart.rentalhub.dao.CommunityLikeDAO" %>
    <%@ page import="com.smart.rentalhub.dao.CommunityCommentDAO" %>
    <%@ page import="com.smart.rentalhub.model.CommunityComment" %>

    <section class="card" style="margin-top:12px;">
      <div id="wall-feed" style="display:flex;flex-direction:column;gap:14px;">
        <%
          com.smart.rentalhub.dao.CommunityPostDAO pdao = new com.smart.rentalhub.dao.CommunityPostDAO();
          com.smart.rentalhub.dao.CommunityLikeDAO likeDao = new com.smart.rentalhub.dao.CommunityLikeDAO();
          com.smart.rentalhub.dao.CommunityCommentDAO commentDao = new com.smart.rentalhub.dao.CommunityCommentDAO();

          String uploadsBase = ctx + "/uploads/";
          java.util.List<com.smart.rentalhub.model.CommunityPost> posts = pdao.findAllTenantsPosts();

          for (com.smart.rentalhub.model.CommunityPost p : posts) {
            int pid = p.getId();
            int likeCount = likeDao.countLikes(pid);
            boolean iLiked = likeDao.hasUserLiked(pid, user.getUsername());
            int commentCount = commentDao.countByPost(pid);
            java.util.List<com.smart.rentalhub.model.CommunityComment> comments = commentDao.listByPost(pid, 50);
        %>
          <article style="border:1px solid var(--border); border-radius:12px; padding:12px;">
            <div class="muted" style="font-size:12px;">
              <strong>@<%= p.getUsername() %></strong>
              • <%= new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm").format(p.getCreatedAt()) %>
            </div>

            <p style="margin:8px 0;"><%= p.getMessage() == null ? "" : p.getMessage() %></p>

            <%
              String img = p.getImagePath();
              if (img != null && !img.isBlank()) {
                String encoded = java.net.URLEncoder.encode(img, "UTF-8").replace("+","%20");
            %>
              <img src="<%= uploadsBase + encoded %>" alt="post image"
                   style="max-width:100%; border-radius:10px; border:1px solid var(--border); margin:6px 0;">
            <% } %>

            <!-- Actions -->
            <div style="display:flex;align-items:center;gap:10px;margin-top:6px;flex-wrap:wrap;">
              <button type="button"
                      class="g-like-btn <%= iLiked ? "liked" : "" %>"
                      data-postid="<%= pid %>"
                      style="border:1px solid var(--border); background:#fff; border-radius:999px; padding:6px 10px; cursor:pointer;">
                <%= iLiked ? "❤ Liked" : "❤ Like" %>
              </button>
              <span id="like-count-<%= pid %>"><%= likeCount %></span>

              <button type="button"
                      class="g-toggle-comments"
                      data-postid="<%= pid %>"
                      style="border:1px solid var(--border); background:#fff; border-radius:999px; padding:6px 10px; cursor:pointer;">
                💬 Comment (<span id="comment-count-<%= pid %>"><%= commentCount %></span>)
              </button>

              <!--  Report Post -->
              <form action="<%= ctx %>/community/report" method="post"
                    onsubmit="return gAskReason(this);" style="display:inline;">
                <input type="hidden" name="postId" value="<%= pid %>">
                <input type="hidden" name="notes">
                <button type="submit"
                        style="border:1px solid var(--border); background:#fff; border-radius:999px; padding:6px 10px; cursor:pointer;">
                  🚩 Report
                </button>
              </form>
            </div>

            <!-- Comments  -->
            <div id="comments-<%= pid %>" style="margin-top:10px; display:none; flex-direction:column; gap:8px;">
              <% for (com.smart.rentalhub.model.CommunityComment cc : comments) { %>
                <div style="border:1px solid var(--border); border-radius:10px; padding:8px;">
                  <div class="muted" style="font-size:12px;">
                    <strong>@<%= cc.getUsername() %></strong>
                    • <%= new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm").format(cc.getCreatedAt()) %>
                  </div>
                  <div style="margin-top:4px;"><%= cc.getComment() %></div>
                </div>
              <% } %>
              <% if (comments.isEmpty()) { %>
                <div class="muted g-empty-<%= pid %>" style="font-size:12px;">No comments yet.</div>
              <% } %>
            </div>

            <!-- Add comment -->
            <form class="g-comment-form" data-postid="<%= pid %>" style="margin-top:10px; display:none; gap:8px;">
              <input type="text" name="text" placeholder="Write a comment…"
                     style="flex:1; border:1px solid var(--border); border-radius:10px; padding:8px;">
              <button type="submit" class="btn" style="border-color:var(--border);">Post</button>
            </form>
          </article>
        <% } %>

        <% if (posts.isEmpty()) { %>
          <div class="muted">No tenant posts yet.</div>
        <% } %>
      </div>
    </section>
  </main>
</div>


<script>
  (function(){
    const root = document.getElementById('wall-feed');
    if (!root) return;

    // Like toggle
    root.addEventListener('click', async function(e){
      const btn = e.target.closest('.g-like-btn');
      if (!btn) return;
      const postId = btn.getAttribute('data-postid');
      try {
        const res = await fetch('<%= ctx %>/community/like', {
          method: 'POST',
          headers: {'Content-Type': 'application/x-www-form-urlencoded'},
          body: 'postId=' + encodeURIComponent(postId)
        });
        if (!res.ok) return;
        const data = await res.json();
        if (data && data.ok) {
          const countEl = document.getElementById('like-count-' + postId);
          if (countEl) countEl.textContent = data.count;
          btn.classList.toggle('liked', data.liked);
          btn.textContent = data.liked ? '❤ Liked' : '❤ Like';
        }
      } catch (err) { console.error('like failed', err); }
    });

    // Show/hide comment section
    root.addEventListener('click', function(e){
      const tbtn = e.target.closest('.g-toggle-comments');
      if (!tbtn) return;
      const postId = tbtn.getAttribute('data-postid');
      const list  = document.getElementById('comments-' + postId);
      const form  = root.querySelector('.g-comment-form[data-postid="' + postId + '"]');
      if (list) list.style.display = (list.style.display === 'none' || !list.style.display) ? 'flex' : 'none';
      if (form) form.style.display = (form.style.display === 'none' || !form.style.display) ? 'flex' : 'none';
      if (form && form.style.display === 'flex') {
        const input = form.querySelector('input[name="text"]');
        input && input.focus();
      }
    });

    // Submit comment
    root.addEventListener('submit', async function(e){
      const form = e.target.closest('.g-comment-form');
      if (!form) return;
      e.preventDefault();

      const postId = form.getAttribute('data-postid');
      const input = form.querySelector('input[name="text"]');
      const text = (input?.value || '').trim();
      if (!text) return;

      try {
        const res = await fetch('<%= ctx %>/community/comment', {
          method: 'POST',
          headers: {'Content-Type': 'application/x-www-form-urlencoded'},
          body: 'postId=' + encodeURIComponent(postId) + '&text=' + encodeURIComponent(text)
        });
        if (!res.ok) return;
        const data = await res.json();
        if (data && data.ok) {
          const list = document.getElementById('comments-' + postId);
          if (list && (list.style.display === 'none' || !list.style.display)) {
            list.style.display = 'flex';
          }
          const empty = root.querySelector('.g-empty-' + postId);
          if (empty) empty.remove();
          if (list) {
            const wrap = document.createElement('div');
            wrap.style.border = '1px solid var(--border)';
            wrap.style.borderRadius = '10px';
            wrap.style.padding = '8px';
            wrap.innerHTML =
              '<div class="muted" style="font-size:12px;"><strong>@' + data.username +
              '</strong> • just now</div><div style="margin-top:4px;"></div>';
            wrap.querySelector('div:last-child').textContent = data.text;
            list.appendChild(wrap);
          }
          const countEl = document.getElementById('comment-count-' + postId);
          if (countEl) countEl.textContent = String(parseInt(countEl.textContent || '0', 10) + 1);
          if (input) input.value = '';
        }
      } catch (err) { console.error('comment failed', err); }
    });
  })();

  
  function gAskReason(form){
    const txt = prompt("Optional: add a short reason for the report");
    if (txt !== null) form.elements['notes'].value = txt.trim();
    return confirm("Send report to admins now?");
  }
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

</body>
</html>