<%@ page import="com.smart.rentalhub.model.User" %>
<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" session="true" %>
<%
  User user = (User) session.getAttribute("user");
  if (user == null) { response.sendRedirect("login.jsp"); return; }

  String ctx = request.getContextPath();
  String pageKey = "account";

  String fn  = user.getProfileImg();
  String avatar = (fn != null && !fn.isBlank())
      ? (ctx + "/uploads/" + java.net.URLEncoder.encode(fn, "UTF-8"))
      : (ctx + "/assets/default-avatar.png");

  String role = (user.getRole() != null) ? user.getRole().toLowerCase() : "tenant";
  String roleLabel =
      "admin".equals(role) ? "Admin" :
      "landlord".equals(role) ? "Landlord" : "Tenant";

  String updated = request.getParameter("updated");
  String error   = request.getParameter("error"); // weakPwd , pwdMismatch , wrongOld , server , emptyEmail
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Account Settings – SmartRentalHub</title>
<meta name="viewport" content="width=device-width, initial-scale=1">
<style>
  :root{--bg:#f0f2f5;--card:#fff;--text:#1c1e21;--muted:#65676b;--border:#dddfe2;--brand:#1877f2;}
  *{box-sizing:border-box}
  body{margin:0;font-family:Segoe UI,Roboto,Arial,sans-serif;background:var(--bg);color:var(--text)}
  a{text-decoration:none;color:var(--brand)}

  .btn{display:inline-flex;align-items:center;gap:8px;background:#fff;border:1px solid var(--border);padding:8px 12px;border-radius:6px;color:#050505;font-weight:600;cursor:pointer}
  .btn.primary{background:var(--brand);border-color:var(--brand);color:#fff}
  .btn.danger{background:#b00020;border-color:#b00020;color:#fff}
  .btn:disabled{opacity:.6;cursor:not-allowed}

  .topbar{position:sticky;top:0;z-index:10;background:#fff;border-bottom:1px solid var(--border);box-shadow:0 6px 20px rgba(0,0,0,.05)}
  .topbar .inner{max-width:1100px;margin:0 auto;padding:10px 16px;display:flex;justify-content:space-between;align-items:center}
  .brand{font-weight:800;color:var(--brand);font-size:20px;text-decoration:none}

  .userbox{display:flex;align-items:center;gap:14px}
  .avatar-mini{width:32px;height:32px;border-radius:50%;object-fit:cover;border:1px solid var(--border)}
  .welcome{display:flex;align-items:center;gap:8px;color:#1f2937}

  .badge{font-size:12px;padding:2px 8px;border-radius:999px;border:1px solid #ddd;background:#fff;color:#444}
  .badge.admin{color:#b00020;border-color:#f1b9bf;background:#fdecee}
  .badge.landlord{color:#1a73e8;border-color:#cfe2ff;background:#eef5ff}
  .badge.tenant{color:#0a7b34;border-color:#cfead9;background:#e9f7ef}

  .wrap{max-width:1100px;margin:16px auto;padding:0 12px;display:grid;grid-template-columns:260px 1fr;gap:16px}
  .sidebar{background:#fff;border:1px solid var(--border);border-radius:8px;overflow:hidden}
  .side-item{display:block;padding:14px 16px;color:#1c1e21;border-left:4px solid transparent}
  .side-item:hover{background:#f5f6f7}
  .active{background:#eef3ff;border-left-color:var(--brand);font-weight:700}

  .panel{background:#fff;border:1px solid var(--border);border-radius:8px}
  .panel h2{margin:0;padding:16px;border-bottom:1px solid var(--border)}
  .body{padding:16px}
  .row{margin-bottom:14px}
  .label{color:#65676b;font-size:13px;margin-bottom:6px}
  .input{width:100%;padding:10px 12px;border:1px solid var(--border);border-radius:6px;background:#f7f8fa}

  .alert{margin:8px 0;padding:10px 12px;border-radius:8px;font-weight:600}
  .ok{background:#e7f3e8;color:#187a1f;border:1px solid #cde8d0}
  .err{background:#fdecef;color:#7a1120;border:1px solid #f3c7cd}

  .danger-zone{margin-top:18px;border-top:1px dashed #f3c7cd;padding-top:14px}
  .note{font-size:12px;color:#7a1120}

  /* clean utility layouts  */
  .form-grid-3 { display:grid; grid-template-columns:1fr 1fr 1fr auto; gap:8px; width:100%; }
  .form-flex   { display:flex; gap:8px; align-items:flex-end; width:100%; }
  .form-del    { display:grid; grid-template-columns:1fr auto; gap:8px; align-items:end; max-width:680px; }

  /* Embedded mode */
  :root.embedded{ --bg:#fff; }
  .embedded .topbar{ display:none; }
  .embedded .wrap{ grid-template-columns:1fr; }
  .embedded .sidebar{ display:none; }
  .embedded .panel{ border-radius:0; border:none; }
  .embedded .body{ padding:16px; }
  .embed-bar{display:none; align-items:center; justify-content:space-between; gap:8px; padding:10px 12px; border-bottom:1px solid var(--border); position:sticky; top:0; background:#fff; z-index:5;}
  .embedded .embed-bar{ display:flex; }
  .embed-title{ font-weight:700; }


  .embedded #embedCloseBtn{ display:none !important; }


</style>
</head>
<body>

<!-- Topbar -->
<div class="topbar">
  <div class="inner">
    <a class="brand" href="<%=ctx%>/index.jsp">SmartRentalHub</a>
    <div class="userbox">
      <span class="welcome">
        Welcome, <strong><%= user.getFullName() %></strong>
        <span class="badge <%= role %>"><%= roleLabel %></span>
      </span>
      <a href="<%= ctx %>/profile.jsp" title="View profile">
        <img class="avatar-mini" src="<%= avatar %>" alt="Profile">
      </a>
      <a class="btn" href="<%=ctx%>/dashboard.jsp">Dashboard</a>
      <a class="btn" href="<%=ctx%>/profile.jsp">Back to Profile</a>
    </div>
  </div>
</div>

<div class="wrap">
  <!-- Compact header shown only in iframe -->
  <div class="embed-bar">
    <span class="embed-title">Account</span>
    <button type="button" class="btn" id="embedCloseBtn">✖ Close</button>
  </div>

  <aside class="sidebar">
    <a class="side-item <%= "profile".equals(pageKey)?"active":"" %>" href="<%=ctx%>/editProfile.jsp">Profile</a>
    <a class="side-item <%= "account".equals(pageKey)?"active":"" %>" href="<%=ctx%>/editAccount.jsp">Account</a>
    <a class="side-item <%= "privacy".equals(pageKey)?"active":"" %>" href="<%=ctx%>/editPrivacy.jsp">Privacy</a>
    <a class="side-item <%= "prefs".equals(pageKey)?"active":"" %>" href="<%=ctx%>/editPreferences.jsp">Preferences</a>
  </aside>

  <section class="panel">
    <h2>Account</h2>
    <div class="body">

      <% if ("1".equals(updated)) { %>
        <div class="alert ok">Updated successfully.</div>
      <% } else if (error != null) { %>
        <div class="alert err">
          <%= "weakPwd".equals(error) ? "Password must be at least 6 characters."
            : "pwdMismatch".equals(error) ? "New password and confirmation don’t match."
            : "wrongOld".equals(error) ? "Your current password is incorrect."
            : "emptyEmail".equals(error) ? "Email cannot be empty."
            : "server".equals(error) ? "Something went wrong. Please try again."
            : "Update failed." %>
        </div>
      <% } %>

      <!-- Update email -->
      <div class="row">
        <form action="<%=ctx%>/account/updateEmail" method="post" class="form-flex">
          <div style="flex:1">
            <div class="label">Email</div>
            <input class="input" type="email" name="email"
                   value="<%= user.getEmail()!=null?user.getEmail():"" %>" required>
          </div>
          <button class="btn" type="submit">Update</button>
        </form>
      </div>

      <!-- Change password -->
      <div class="row">
        <form action="<%=ctx%>/account/changePassword" method="post" class="form-grid-3">
          <div>
            <div class="label">Current password</div>
            <input class="input" type="password" name="old_password" required>
          </div>
          <div>
            <div class="label">New password</div>
            <input class="input" type="password" name="new_password" required minlength="6">
          </div>
          <div>
            <div class="label">Confirm new password</div>
            <input class="input" type="password" name="confirm_password" required minlength="6">
          </div>
          <div style="align-self:end">
            <button class="btn primary" type="submit" title="You’ll be logged out if this succeeds.">Change</button>
          </div>
        </form>
        <div class="note">Security note: after changing your password, you’ll be signed out automatically and must log in again.</div>
      </div>

      <!-- Danger zone -->
      <div class="danger-zone">
        <h3 style="margin:8px 0 6px;">Danger zone</h3>
        <p class="note">Deleting your account is permanent. This cannot be undone.</p>

        <form id="deleteForm" action="<%=ctx%>/account/delete" method="post" class="form-del">
          <div>
            <div class="label">Confirm with current password</div>
            <input class="input" type="password" name="password" id="delPwd" placeholder="Enter current password" required>
            <label style="display:flex;align-items:center;gap:8px;margin-top:8px">
              <input type="checkbox" id="delAgree" required> I understand this action is permanent.
            </label>
          </div>
          <button class="btn danger" id="delBtn" type="submit" disabled>Delete account</button>
        </form>
      </div>

    </div>
  </section>
</div>

<script>
  // Embedded-mode script
  (function () {
    var isEmbedded = (function(){ try { return window.top !== window.self; } catch (e) { return true; }})();
    if (isEmbedded) document.documentElement.classList.add('embedded');

    // (Button is hidden in embedded mode to avoid duplicate close; keep handler for completeness)
    var closeBtn = document.getElementById('embedCloseBtn');
    if (isEmbedded && closeBtn) {
      closeBtn.addEventListener('click', function(){
        window.parent.postMessage({ type: 'SRH_CLOSE_ACCOUNT_MODAL' }, '*');
      });
    }
  })();

  // Enable delete button only when both fields are ok + confirm dialog
  (function(){
    const pwd = document.getElementById('delPwd');
    const agree = document.getElementById('delAgree');
    const btn = document.getElementById('delBtn');
    const form = document.getElementById('deleteForm');
    function sync(){ btn.disabled = !(pwd.value && agree.checked); }
    pwd.addEventListener('input', sync); agree.addEventListener('change', sync); sync();

    form.addEventListener('submit', function(e){
      if (!confirm('This will permanently delete your account. Continue?')) {
        e.preventDefault();
      }
    });
  })();
</script>



</body>
</html>
