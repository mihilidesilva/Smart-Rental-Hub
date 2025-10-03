<%@ page import="com.smart.rentalhub.model.User" %>
<%@ page import="com.smart.rentalhub.dao.UserDAO" %>
<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" session="true" %>
<%
    // Session & shared values
    User user = (User) session.getAttribute("user");
    if (user == null) { response.sendRedirect("login.jsp"); return; }

    String ctx = request.getContextPath();

    // Avatar (users.profile_img stores as a filename)
    String fn  = user.getProfileImg();
    String avatar = (fn != null && !fn.isBlank())
        ? (ctx + "/uploads/" + java.net.URLEncoder.encode(fn, "UTF-8"))
        : (ctx + "/assets/default-avatar.png");

    // Role (for badge in topbar)
    String role = (user.getRole() != null) ? user.getRole().toLowerCase() : "tenant";
    String roleLabel =
        "admin".equals(role)     ? "Admin" :
        "landlord".equals(role)  ? "Landlord" : "Tenant";

    // Cover (from user_covers)
    UserDAO dao = new UserDAO();
    String coverFile = dao.getCoverImage(user.getId());
    String coverUrl  = (coverFile != null && !coverFile.isBlank())
        ? (ctx + "/uploads/" + java.net.URLEncoder.encode(coverFile, "UTF-8"))
        : (ctx + "/assets/cover-default.jpg");

    String updated = request.getParameter("updated");
    String error   = request.getParameter("error");
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8" />
<title>Edit Profile – SmartRentalHub</title>
<meta name="viewport" content="width=device-width, initial-scale=1" />
<style>
  :root{
    --bg:#f6f7f8; --card:#fff; --text:#1f2937; --muted:#6b7280; --border:#e5e7eb;
    --brand:#ff4500; --primary:#1877f2; --shadow:0 6px 20px rgba(0,0,0,.06);
    --radius:12px;
  }
  *{box-sizing:border-box}
  body{margin:0;font-family:Segoe UI, Roboto, Arial, sans-serif;background:var(--bg);color:var(--text)}

  /* Topbar */
  .topbar{position:sticky;top:0;left:0;right:0;z-index:1000;background:#fff;border-bottom:1px solid var(--border);box-shadow:var(--shadow)}
  .topbar .inner{max-width:1200px;margin:0 auto;padding:10px 20px;display:flex;justify-content:space-between;align-items:center}
  .brand{color:var(--brand);font-weight:800;font-size:22px;text-decoration:none}
  .userbox{display:flex;align-items:center;gap:16px}
  .welcome{display:flex;align-items:center;gap:8px;color:#111827}
  .badge{font-size:12px;padding:2px 8px;border-radius:999px;border:1px solid #ddd;background:#fff;color:#444}
  .badge.admin    { color:#b00020; border-color:#f1b9bf; background:#fdecee; }
  .badge.landlord { color:#1a73e8; border-color:#cfe2ff; background:#eef5ff; }
  .badge.tenant   { color:#0a7b34; border-color:#cfead9; background:#e9f7ef; }
  .avatar-mini{width:36px;height:36px;border-radius:50%;object-fit:cover;border:1px solid var(--border)}

  .link{color:#1f2937;text-decoration:none}
  .link:hover{opacity:.8}

  /* sidebar + main */
  .shell{max-width:1200px;margin:16px auto;padding:0 12px;display:grid;grid-template-columns:260px 1fr;gap:16px}
  @media (max-width: 980px){ .shell{grid-template-columns:1fr} }

  /* Sidebar tabs */
  .sidebar{background:#fff;border:1px solid var(--border);border-radius:var(--radius);overflow:hidden;box-shadow:var(--shadow)}
  .side-item{display:block;padding:14px 16px;color:#111827;border-left:4px solid transparent;text-decoration:none}
  .side-item:hover{background:#f9fafb}
  .active{background:#eef2ff;border-left-color:var(--primary);font-weight:700}

  /* Header panel (cover + avatar) */
  .panel{background:#fff;border:1px solid var(--border);border-radius:var(--radius);overflow:hidden;box-shadow:var(--shadow)}
  .cover{position:relative;height:240px;background:#e5e7eb center/cover no-repeat}
  .cover-actions{position:absolute;right:12px;bottom:12px;display:flex;gap:8px;z-index:10}
  .btn{display:inline-flex;align-items:center;gap:8px;background:#fff;border:1px solid var(--border);padding:8px 12px;border-radius:8px;color:#111827;font-weight:600;cursor:pointer}
  .btn.primary{background:var(--primary);color:#fff;border-color:var(--primary)}
  .header-body{padding:0 16px 16px;background:#fff}
  .avatar-row{display:flex;align-items:flex-end;gap:16px;transform:translateY(-50%)}
  .avatar{width:168px;height:168px;border-radius:50%;border:4px solid #fff;object-fit:cover;box-shadow:0 2px 12px rgba(0,0,0,.15)}
  .cam{position:absolute;left:120px;bottom:10px}
  .cam label{background:#fff;border:1px solid var(--border);border-radius:20px;padding:6px 10px;cursor:pointer}
  .name h1{margin:0;font-size:28px;font-weight:800}
  .name p{margin:4px 0 0;color:var(--muted)}

  /* Cards + form */
  .card{background:#fff;border:1px solid var(--border);border-radius:var(--radius);margin-top:16px;box-shadow:var(--shadow)}
  .card h3{margin:0;padding:12px 16px;border-bottom:1px solid var(--border)}
  .card-body{padding:16px}
  .field{display:flex;flex-direction:column;gap:6px;margin-bottom:12px}
  .label{font-weight:600}
  .hint{font-size:12px;color:var(--muted)}
  .input,.area{width:100%;padding:10px 12px;border:1px solid var(--border);border-radius:8px;background:#fff}
  .area{min-height:120px;resize:vertical}
  .actions{display:flex;gap:8px;justify-content:flex-end;padding:12px 16px;border-top:1px solid var(--border)}
  .alert{margin:12px 0;padding:10px 12px;border-radius:8px;font-weight:600}
  .ok{background:#e7f3e8;color:#187a1f;border:1px solid #cde8d0}
  .err{background:#fde8ea;color:#86181d;border:1px solid #f5c2c7}

  /* File inputs kept in DOM  but visually hidden */
  .vh{position:absolute;left:-9999px;width:1px;height:1px;opacity:0}

  /* Reddit-like modal styles */
  .srh-modal::backdrop{ background:rgba(0,0,0,.45); backdrop-filter:saturate(120%) blur(2px); }
  .srh-modal{ padding:0;border:none;border-radius:16px;width:min(92vw,540px);height:auto;box-shadow:0 20px 60px rgba(0,0,0,.30) }
  .srh-head{ display:flex;align-items:center;justify-content:space-between;padding:14px 16px;border-bottom:1px solid #e9ecef;background:#fff;border-top-left-radius:16px;border-top-right-radius:16px }
  .srh-title{ font-weight:700;font-size:18px }
  .srh-x{ border:none;background:#f3f4f6;width:32px;height:32px;border-radius:999px;font-size:18px;cursor:pointer;display:grid;place-items:center }
  .srh-x:hover{ background:#e9ecef }
  .srh-body{ background:#fff;max-height:min(70vh,640px);overflow:auto }
  .srh-iframe{ display:block;border:0;width:100%;height:min(70vh,640px);background:#fff }


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

<!-- TOPBAR -->
<div class="topbar">
  <div class="inner">
    <a class="brand" href="<%= ctx %>/index.jsp">SmartRentalHub</a>
    <div class="userbox">
      <span class="welcome">
        Welcome, <strong><%= user.getFullName() %></strong>
        <span class="badge <%= role %>"><%= roleLabel %></span> 👋
      </span>
      <a class="link" href="<%= ctx %>/profile.jsp" title="View profile">
        <img class="avatar-mini" src="<%= avatar %>" alt="Profile">
      </a>
      <a class="link" href="<%= ctx %>/logout.jsp">Logout</a>
    </div>
  </div>
</div>

<div class="shell">
  <!-- LEFT: Settings tabs -->
  <aside class="sidebar">
    <a class="side-item active"  href="<%= ctx %>/editProfile.jsp">Profile</a>
    <a class="side-item"         href="<%= ctx %>/editAccount.jsp">Account</a>
    <a class="side-item"         href="<%= ctx %>/editPrivacy.jsp">Privacy</a>
<!--    <a class="side-item"         href="<%= ctx %>/editPreferences.jsp">Preferences</a>-->
  </aside>

  <!-- Main content -->
  <main>
    <!-- Header with COVER + AVATAR -->
    <div class="panel">
      <div class="cover" id="coverArea" style="background-image:url('<%= coverUrl %>')">
        <div class="cover-actions">
            
          <!--  posts to /updateCover with name="cover_img" -->
          <form id="coverForm" action="<%= ctx %>/updateCover" method="post" enctype="multipart/form-data">
            <input class="vh" type="file" id="coverInput" name="cover_img" accept="image/*">
            <label for="coverInput" class="btn">🖼️ Edit Cover</label>
          </form>
        </div>
      </div>

      <div class="header-body">
        <div style="position:relative">
          <div class="avatar-row">
            <img id="avatarPreview" src="<%= avatar %>" alt="Avatar" class="avatar">
            <!-- Do not change,, triggers real input inside the form below -->
            <div class="cam"><label for="profile_img">📷</label></div>
            <div class="name">
              <h1><%= (user.getFullName()!=null && !user.getFullName().isBlank()) ? user.getFullName() : user.getUsername() %></h1>
              <p>@<%= user.getUsername() %></p>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- ABOUT -->
    <div class="card">
      <h3>About</h3>
      <div class="card-body">
        <!-- Do not change,,posts to /updateProfile with name="profile_img" for avatar -->
        <form id="editForm" action="<%= ctx %>/updateProfile" method="post" enctype="multipart/form-data">
          <input class="vh" type="file" id="profile_img" name="profile_img" accept="image/*">

          <div class="field">
            <div class="label">Display Name</div>
            <input class="input" type="text" name="fullname"
                   value="<%= user.getFullName()!=null?user.getFullName():"" %>"
                   placeholder="Your display name">
            <div class="hint">Saved as <code>full_name</code> in the database.</div>
          </div>

          <div class="field">
            <div class="label">Bio</div>
            <textarea class="area" name="bio" placeholder="Tell people about you"><%= user.getBio()!=null?user.getBio():"" %></textarea>
            <div class="hint">Saved as <code>bio</code>.</div>
          </div>

          <div class="actions">
            <button class="btn" type="reset">Reset</button>
            <button class="btn primary" type="submit">Save Changes</button>
          </div>
        </form>

        <% if ("1".equals(updated)) { %>
          <div class="alert ok">Profile updated successfully.</div>
        <% } else if (error != null) { %>
          <div class="alert err">Could not update profile. Please try again.</div>
        <% } %>
      </div>
    </div>

    <!-- Account summry -->
    <div class="card">
      <h3>Account</h3>
      <div class="card-body">
        <div class="field">
          <div class="label">Username</div>
          <input class="input" type="text" value="<%= user.getUsername() %>" readonly>
        </div>
        <div class="field">
          <div class="label">Email</div>
          <input class="input" type="email" value="<%= user.getEmail()!=null?user.getEmail():"" %>" readonly>
        </div>
        <div class="field" style="margin-bottom:0">
          <div class="label">Role</div>
          <input class="input" type="text" value="<%= user.getRole() %>" readonly>
        </div>
      </div>
    </div>
  </main>
</div>

<!-- One shared modal -->
<dialog id="settingsModal" class="srh-modal" aria-label="Settings">
  <div class="srh-head">
    <div class="srh-title" id="modalTitle">Settings</div>
    <button type="button" id="modalClose" class="srh-x" aria-label="Close">✕</button>
  </div>
  <div class="srh-body">
    <iframe id="settingsFrame" class="srh-iframe" src="about:blank"></iframe>
  </div>
</dialog>

<script>
  // Cover preview + auto-submit
  const coverInput = document.getElementById('coverInput');
  const coverForm  = document.getElementById('coverForm');
  const coverArea  = document.getElementById('coverArea');
  coverInput?.addEventListener('change', e => {
    const f = e.target.files && e.target.files[0];
    if (!f) return;
    coverArea.style.backgroundImage = `url('${URL.createObjectURL(f)}')`;
    coverForm.submit();
  });

  //  upload handled by /updateProfile
  const realInput = document.getElementById('profile_img');
  const avatarImg = document.getElementById('avatarPreview');
  realInput?.addEventListener('change', e => {
    const f = e.target.files && e.target.files[0];
    if (!f) return;
    avatarImg.src = URL.createObjectURL(f);
  });

  // ---- Modal opener for Account / Privacy  ----
  const modal      = document.getElementById('settingsModal');
  const frame      = document.getElementById('settingsFrame');
  const modalClose = document.getElementById('modalClose');
  const titleEl    = document.getElementById('modalTitle');

  function openInModal(linkEl){
    const url = linkEl.getAttribute('href');
    const label = linkEl.textContent.trim();
    titleEl.textContent = label;
    frame.src = url;
    if (modal.showModal) modal.showModal(); else modal.setAttribute('open','');
  }
  function closeModal(){
    frame.src = 'about:blank';
    modal.close?.(); modal.removeAttribute('open');
  }
  modalClose?.addEventListener('click', closeModal);
  modal?.addEventListener('click', (e) => {
    const r = modal.getBoundingClientRect();
    const inside = e.clientX >= r.left && e.clientX <= r.right && e.clientY >= r.top && e.clientY <= r.bottom;
    if (!inside) closeModal();
  });
  window.addEventListener('keydown', (e)=>{ if (e.key==='Escape' && modal?.open) closeModal(); });

  // bind sidebar links
  document.querySelectorAll('.sidebar .side-item').forEach(a=>{
    if (/(editAccount\.jsp|editPrivacy\.jsp|editPreferences\.jsp)$/.test(a.getAttribute('href')||'')) {
      a.addEventListener('click', (e)=>{ e.preventDefault(); openInModal(a); });
    }
  });

  // messages from any embedded page to close
  window.addEventListener('message', (e) => {
    if (e.data && (e.data.type === 'SRH_CLOSE_SETTINGS_MODAL' || e.data.type === 'SRH_CLOSE_ACCOUNT_MODAL')) {
      closeModal();
    }
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


</body>
</html>
