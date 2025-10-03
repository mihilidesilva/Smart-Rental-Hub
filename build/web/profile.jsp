<%@ page import="com.smart.rentalhub.model.User" %>
<%@ page import="com.smart.rentalhub.dao.UserDAO" %>
<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" session="true" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null) { response.sendRedirect("login.jsp"); return; }

    String ctx = request.getContextPath();
    String fileName = user.getProfileImg();
    String avatar = (fileName != null && !fileName.isBlank())
        ? (ctx + "/uploads/" + java.net.URLEncoder.encode(fileName, "UTF-8"))
        : (ctx + "/assets/default-avatar.png");

    String role = (user.getRole() != null) ? user.getRole().toLowerCase() : "tenant";
    String roleLabel =
        "admin".equals(role) ? "Admin" :
        "landlord".equals(role) ? "Landlord" : "Tenant";

    //  cover image (pulled from our DB; falls back to default)
    UserDAO dao = new UserDAO();
    String coverFile = dao.getCoverImage(user.getId());
    String coverUrl  = (coverFile != null && !coverFile.isBlank())
        ? (ctx + "/uploads/" + java.net.URLEncoder.encode(coverFile, "UTF-8"))
        : (ctx + "/assets/cover-default.jpg");
%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8" />
  <title><%= user.getUsername() %>'s Profile – SmartRentalHub</title>
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <style>
    :root{
      --bg:#f6f7f8; --card:#fff; --text:#1f2937; --muted:#6b7280; --border:#e5e7eb;
      --brand:#ff4500; --hover:#f9fafb; --shadow:0 6px 20px rgba(0,0,0,.06);
    }
    *{box-sizing:border-box}
    body{margin:0;font-family:system-ui,-apple-system,Segoe UI,Roboto,Arial,sans-serif;background:var(--bg);color:var(--text)}

    /* Top bar */
    .topbar {
      position: sticky; top: 0; left: 0; right: 0; z-index: 1000;
      background: #fff; border-bottom: 1px solid #e5e7eb;
      box-shadow: 0 6px 20px rgba(0,0,0,.06);
    }
    .topbar .inner { max-width: 1200px; margin: 0 auto; padding: 10px 20px; display: flex; justify-content: space-between; align-items: center; }
    .brand { color: #ff4500; font-weight: 800; font-size: 22px; text-decoration: none; }
    .avatar-mini { width: 36px; height: 36px; border-radius: 50%; object-fit: cover; border: 1px solid #e5e7eb; }
    .badge { font-size: 12px; padding: 2px 8px; border-radius: 999px; border: 1px solid #ddd; background: #fff; color: #444; }
    .badge.admin { color: #b00020; border-color: #f1b9bf; background: #fdecee; }
    .badge.landlord { color: #1a73e8; border-color: #cfe2ff; background: #eef5ff; }
    .badge.tenant { color: #0a7b34; border-color: #cfead9; background: #e9f7ef; }

    /* Layout grid */
    .shell{max-width:1200px;margin:20px auto;padding:0 16px;display:grid;grid-template-columns:260px 1fr;gap:20px}
    @media (max-width: 960px){ .shell{grid-template-columns:1fr} }

    /* Sidebar */
    .sidebar{position:sticky;top:80px;align-self:start;background:#fff;border:1px solid var(--border);border-radius:12px;padding:14px;box-shadow:var(--shadow)}
    .side-title{margin:4px 0 10px 6px;font-weight:800}
    .nav{display:flex;flex-direction:column;gap:6px}
    .nav a{display:flex;align-items:center;gap:10px;padding:10px 12px;border-radius:10px;text-decoration:none;color:var(--text)}
    .nav a:hover{background:var(--hover)}
    .nav .sep{height:1px;background:var(--border);margin:6px 6px}

    /* Header card */
    .header{background:#fff;border:1px solid var(--border);border-radius:14px;padding:0;box-shadow:var(--shadow);overflow:hidden;}
    .who{display:flex;align-items:center;gap:16px;padding:16px 18px}
    .avatar{width:88px;height:88px;border-radius:50%;object-fit:cover;border:3px solid #fff;box-shadow:0 2px 10px rgba(0,0,0,.08);cursor:pointer}
    .name{margin:0;font-size:22px}
    .meta{margin:4px 0 0;color:var(--muted)}

    /* Tabs */
    .tabs{margin:14px 0 8px;display:flex;gap:8px;flex-wrap:wrap}
    .tab{padding:8px 12px;border:1px solid var(--border);border-radius:999px;background:#fff;cursor:pointer}
    .tab:hover{background:var(--hover)}

    /* Sections */
    .card{background:#fff;border:1px solid var(--border);border-radius:12px;padding:16px;box-shadow:var(--shadow)}
    .card h3{margin:0 0 8px}
    .muted{color:var(--muted)}

    /* cover styles header top*/
    .cover { position: relative; height: 220px; background: #e5e7eb center/cover no-repeat; }
    .cover-actions { position: absolute; right: 12px; bottom: 12px; display: flex; gap: 8px; z-index: 10; }
    .btn { display: inline-flex; align-items: center; gap: 8px; background: #fff; border: 1px solid var(--border); padding: 8px 12px; border-radius: 10px; color: #111827; font-weight: 600; cursor: pointer; }
    .vh { position: absolute; left: -9999px; width: 1px; height: 1px; opacity: 0; }
    
    .btn {
      display: inline-block;
      padding: 8px 14px;
      background: #ffffff; /* white */
      color: #ff6600; /* mild orange text */
      border-radius: 8px;
      text-decoration: none;
      font-weight: bold;
      border: 2px solid #ff6600; /*  adds orange border */
      transition: 0.3s ease; /* smooth hover effect */
    }

    .btn:hover {
      background: #ff6600; /* mild orange background on hover */
      color: #ffffff; /* white text on hover */
    }
    
  </style>
</head>
<body>

<div class="topbar">
  <div class="inner">
    <!-- Brand -->
    <a href="<%= ctx %>/index.jsp" class="brand">SmartRentalHub</a>

    <!-- Right-side user info -->
    <div class="userbox" style="display:flex;align-items:center;gap:16px;">
      <span class="welcome" style="display:flex;align-items:center;gap:8px;">
        Welcome, <strong><%= user.getFullName() %></strong>
        <span class="badge <%= role %>"><%= roleLabel %></span> 👋
      </span>
      <a href="<%= ctx %>/profile.jsp" title="View profile">
        <img class="avatar-mini" src="<%= avatar %>" alt="Profile">
      </a>
      <a href="<%= ctx %>/logout.jsp" style="text-decoration:none;color:#1f2937">Logout</a>
    </div>
  </div>
</div>

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
      <% } %>

     <% if ("landlord".equals(role)) { %>
        <div class="sep"></div>
       <a href="<%= ctx %>/myProperties">🏘 My Properties</a>
        <a href="<%= ctx %>/PostPoperty.jsp">➕ Post Property</a>
        <a href="browseListings.jsp">🔍 Browse Listings</a>
      <% } %>

      <% if ("admin".equals(role)) { %>
        <div class="sep"></div>
       
        <a href="<%= ctx %>/admin.jsp">🛠 Control Center</a>
        <a href="<%= ctx %>/adminReports.jsp">📑 Reports</a>
        
      <% } %>

      
      <a href="<%= ctx %>/editProfile.jsp">⚙ Settings</a>
      <a href="<%= ctx %>/logout.jsp">🚪 Logout</a>
    </nav>
  </aside>

  <!-- Content -->
  <main>
    <!-- Header card -->
    <section class="header">
      <!-- NEW: Cover area with upload -->
      <div class="cover" id="coverArea" style="background-image:url('<%= coverUrl %>')">
        <div class="cover-actions">
            
          <!-- Posts to /updateCover; keeps your backend contract -->
          <form id="coverForm" action="<%= ctx %>/updateCover" method="post" enctype="multipart/form-data">
            <input class="vh" type="file" id="coverInput" name="cover_img" accept="image/*">
<!--            <label for="coverInput" class="btn">🖼️ Edit Cover</label>-->
          </form>
        </div>
      </div>

      <!-- Existing profile header info -->
      <div class="who">
        <a href="<%= ctx %>/editProfile.jsp" title="Edit Profile">
          <img src="<%= avatar %>" alt="Avatar" class="avatar">
        </a>
        <div>
          <h1 class="name">
            <%= user.getFullName() %> (@<%= user.getUsername() %>)
            <span class="badge <%= role %>"><%= roleLabel %></span>
          </h1>
          <div class="meta"><%= (user.getBio() != null ? user.getBio() : "") %></div>
        </div>
      </div>

      <!-- Role-aware tabs -->
      <div class="tabs" style="padding:0 18px 16px">
        <% if ("landlord".equals(role)) { %>
          <button class="tab" onclick="showSection('properties')">My Properties</button>
          
        <% } else { %> <!-- tenant + admin default to Posts first -->
          <button class="tab" onclick="showSection('posts')">My Posts</button>
        
        <% } %>
      </div>
    </section>

  
      
      
    <section id="posts" class="tab-section" style="display:none">
        
      <h3>Listing Posts</h3>
      
      <!-- tenant posts here -->
    </section>

    <section id="properties" class="tab-section" style="display:none">
      <h3>My Properties</h3>
      <!-- landlord properties here -->
      <a href="<%= ctx %>/myProperties"  class="btn">🏘 My Properties</a>
    </section>

    
    
    
       <!-- ====================== Gothami's section  ====================== -->
    <%@ page import="java.util.*" %>
    <%@ page import="com.smart.rentalhub.dao.CommunityPostDAO" %>
    <%@ page import="com.smart.rentalhub.model.CommunityPost" %>
    <%@ page import="com.smart.rentalhub.dao.CommunityLikeDAO" %>
    <%@ page import="com.smart.rentalhub.dao.CommunityCommentDAO" %>
    <%@ page import="com.smart.rentalhub.model.CommunityComment" %>

    <style>
      
      #gothami-section{
        --g-bg:#fff;
        --g-ink:#0f172a;           
        --g-muted:#475569;             
        --g-border:#e5e7eb;            
        --g-soft:#f8fafc;              
        --g-shadow:0 8px 30px rgba(15,23,42,.06);
        color:var(--g-ink);
      }
      #gothami-section h3{
        margin:0 0 14px;
        font-size:20px;
        font-weight:800;
        color:var(--g-ink);
        letter-spacing:.2px;
      }

     
      .g-composer{
        background:var(--g-bg);
        border:1px solid var(--g-border);
        border-radius:16px;
        padding:14px;
        box-shadow:var(--g-shadow);
      }
      .g-textarea{
        width:100%;
        min-height:96px;
        resize:vertical;
        border:1px solid var(--g-border);
        border-radius:12px;
        padding:12px 14px;
        font:inherit;
        color:var(--g-ink);
        background:#fff;
        transition:border-color .2s, box-shadow .2s;
      }
      .g-textarea:focus{
        outline:none;
        border-color:var(--g-ink);
        box-shadow:0 0 0 4px rgba(15,23,42,.08);
      }
      .g-actions{
        display:flex; gap:10px; justify-content:flex-end; align-items:center; margin-top:10px;
      }
      .g-btn{
        display:inline-flex; align-items:center; gap:8px;
        padding:9px 14px; border-radius:9999px;
        background:#fff; color:var(--g-ink);
        border:1px solid var(--g-border); cursor:pointer; font-weight:700;
        transition:transform .06s ease, box-shadow .2s, background .2s, color .2s, border-color .2s;
        box-shadow:0 1px 0 rgba(2,6,23,.04);
      }
      .g-btn:hover{ box-shadow:0 4px 16px rgba(15,23,42,.08); transform:translateY(-1px); }
      .g-btn:active{ transform:translateY(0); }
      .g-btn.primary{ background:var(--g-ink); color:#fff; border-color:var(--g-ink); }

      
      .g-post{
        border:1px solid var(--g-border);
        border-radius:16px;
        padding:14px;
        background:#fff;
        box-shadow:var(--g-shadow);
      }
      .g-head{
        display:flex; align-items:center; justify-content:space-between; gap:8px;
        color:var(--g-muted); font-size:12px;
      }
      .g-user{ color:var(--g-ink); font-weight:800; }
      .g-time{ color:var(--g-muted); }
      .g-body{ margin:10px 0; color:var(--g-ink); line-height:1.5; }
      .g-image{
        display:block; max-width:100%; border-radius:12px; border:1px solid var(--g-border);
        background:#fff; margin:8px 0;
      }

  
      .g-row{ display:flex; align-items:center; gap:10px; flex-wrap:wrap; margin-top:6px; }
      .g-count{ font-size:13px; color:var(--g-muted); }
      .g-like-btn.liked{ background:var(--g-ink); color:#fff; border-color:var(--g-ink); }
      .pop{ animation:pop .28s ease; }
      @keyframes pop{ 0%{transform:scale(.96)} 70%{transform:scale(1.06)} 100%{transform:scale(1)} }

  
      .g-comments{ display:none; flex-direction:column; gap:8px; margin-top:10px; }
      .g-comment{
        border:1px solid var(--g-border); border-radius:12px; padding:8px; background:#fff;
      }
      .g-comment .meta{ font-size:12px; color:var(--g-muted); }
      .g-comment .text{ margin-top:4px; color:var(--g-ink); }
      .g-comment-form{
        display:none; gap:8px; margin-top:10px;
      }
      .g-input{
        flex:1; border:1px solid var(--g-border); border-radius:12px; padding:10px 12px; font:inherit; color:var(--g-ink);
      }
      .g-input:focus{ outline:none; border-color:var(--g-ink); box-shadow:0 0 0 4px rgba(15,23,42,.08); }

     
      .g-empty{
        color:var(--g-muted); text-align:center; padding:14px; border:1px dashed var(--g-border); border-radius:14px; background:var(--g-soft);
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

    <section id="gothami-section" class="card" style="margin-top:16px; background:#fff; border-color:#e5e7eb;">
      <h3>My Posts</h3>

      <!-- composer  -->
      <form action="<%= ctx %>/community/post" method="post" class="g-composer">
        <textarea name="message" class="g-textarea" placeholder="Share something with your community…"></textarea>
        <div class="g-actions">
          <button type="submit" class="g-btn primary">Post</button>
        </div>
      </form>

      <!-- feed -->
      <div style="margin-top:16px; display:flex; flex-direction:column; gap:14px;">
        <%
          com.smart.rentalhub.dao.CommunityPostDAO cdao2 = new com.smart.rentalhub.dao.CommunityPostDAO();
          com.smart.rentalhub.dao.CommunityLikeDAO likeDao = new com.smart.rentalhub.dao.CommunityLikeDAO();
          com.smart.rentalhub.dao.CommunityCommentDAO commentDao = new com.smart.rentalhub.dao.CommunityCommentDAO();

          String uploadsBase2 = ctx + "/uploads/";
          java.util.List<com.smart.rentalhub.model.CommunityPost> posts2 = cdao2.findByUsername(user.getUsername());

          for (com.smart.rentalhub.model.CommunityPost p2 : posts2) {
            int pid = p2.getId();
            int likeCount = likeDao.countLikes(pid);
            boolean iLiked = likeDao.hasUserLiked(pid, user.getUsername());
            int commentCount = commentDao.countByPost(pid);
            java.util.List<com.smart.rentalhub.model.CommunityComment> comments = commentDao.listByPost(pid, 50);
        %>
          <article class="g-post">
            <div class="g-head">
              <div><span class="g-user">@<%= p2.getUsername() %></span></div>
              <div class="g-time"><%= new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm").format(p2.getCreatedAt()) %></div>
            </div>

            <div class="g-body"><%= p2.getMessage() == null ? "" : p2.getMessage() %></div>

            <%
              String img2 = p2.getImagePath();
              if (img2 != null && !img2.isBlank()) {
                String encoded = java.net.URLEncoder.encode(img2, "UTF-8").replace("+","%20");
            %>
              <img class="g-image" src="<%= uploadsBase2 + encoded %>" alt="post image">
            <% } %>

            <!-- Action row,, Like + Comment toggle -->
            <div class="g-row">
              <button type="button"
                      class="g-btn g-like-btn <%= iLiked ? "liked" : "" %>"
                      data-postid="<%= pid %>">
                <%= iLiked ? "❤ Liked" : "❤ Like" %>
              </button>
              <span class="g-count" id="like-count-<%= pid %>"><%= likeCount %></span>

              <button type="button"
                      class="g-btn g-toggle-comments"
                      data-postid="<%= pid %>">
                💬 Comment (<span id="comment-count-<%= pid %>"><%= commentCount %></span>)
              </button>
            </div>

            <!-- Comments list -->
            <div id="comments-<%= pid %>" class="g-comments">
              <% for (com.smart.rentalhub.model.CommunityComment cc : comments) { %>
                <div class="g-comment">
                  <div class="meta"><strong>@<%= cc.getUsername() %></strong> • <%= new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm").format(cc.getCreatedAt()) %></div>
                  <div class="text"><%= cc.getComment() %></div>
                </div>
              <% } %>
              <% if (comments.isEmpty()) { %>
                <div class="g-empty g-empty-<%= pid %>">No comments yet.</div>
              <% } %>
            </div>

            <!-- Add comment form -->
            <form class="g-comment-form" data-postid="<%= pid %>">
              <input type="text" name="text" class="g-input" placeholder="Write a comment…">
              <button type="submit" class="g-btn">Post</button>
            </form>
          </article>
        <% } %>

        <% if (posts2.isEmpty()) { %>
          <div class="g-empty">No posts yet. Be the first to share something!</div>
        <% } %>
      </div>
    </section>

      
      
      
    <script>
      (function(){
        const root = document.getElementById('gothami-section');
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
              if (countEl){
                countEl.textContent = data.count;
                countEl.classList.remove('pop'); void countEl.offsetWidth; countEl.classList.add('pop');
              }
              btn.classList.toggle('liked', data.liked);
              btn.textContent = data.liked ? '❤ Liked' : '❤ Like';
            }
          } catch (err) { console.error('like failed', err); }
        });

        // Comment section toggle 
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

        // Comment submit (AJAX)
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
                wrap.className = 'g-comment';
                wrap.innerHTML =
                  '<div class="meta"><strong>@' + data.username +
                  '</strong> • just now</div><div class="text"></div>';
                wrap.querySelector('.text').textContent = data.text;
                list.appendChild(wrap);
              }
              const countEl = document.getElementById('comment-count-' + postId);
              if (countEl){
                countEl.textContent = String(parseInt(countEl.textContent || '0', 10) + 1);
                countEl.classList.remove('pop'); void countEl.offsetWidth; countEl.classList.add('pop');
              }
              if (input) input.value = '';
            }
          } catch (err) { console.error('comment failed', err); }
        });
      })();
    </script>
    <!-- ==================== end Gothami's section ==================== -->
    
    
  </main>
      
      

  <script>
    function showSection(id) {
      document.querySelectorAll('.tab-section').forEach(s => s.style.display = 'none');
      var el = document.getElementById(id);
      if (el) el.style.display = 'block';
    }

    // Open the right default tab based on role
    window.addEventListener('DOMContentLoaded', function () {
      var role = '<%= role %>'; // tenant , landlord , admin
      if (role === 'landlord') {
        showSection('properties');
      } else {
        showSection('posts');
      }
    });

    // Cover preview + auto-submit on selection
const coverInput = document.getElementById('coverInput');
const coverForm  = document.getElementById('coverForm');
const coverArea  = document.getElementById('coverArea');
coverInput?.addEventListener('change', function (e) {
  const f = e.target.files && e.target.files[0];
  if (!f) return;
  coverArea.style.backgroundImage = `url('${URL.createObjectURL(f)}')`;
  coverForm.submit();
});

  </script>
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
