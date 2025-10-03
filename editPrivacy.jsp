<%@ page import="com.smart.rentalhub.model.User" %>
<%@ page import="com.smart.rentalhub.dao.SettingsDAO" %>
<%@ page import="com.smart.rentalhub.model.PrivacySettings" %>
<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" session="true" %>
<%
  User user = (User) session.getAttribute("user");
  if (user == null) { response.sendRedirect("login.jsp"); return; }
  String ctx = request.getContextPath();
  String pageKey = "privacy";

  // Load current settings
  PrivacySettings ps = new SettingsDAO().getPrivacy(user.getId());
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Privacy Settings – SmartRentalHub</title>
<meta name="viewport" content="width=device-width, initial-scale=1">
<style>
  :root{--bg:#f0f2f5;--card:#fff;--text:#1c1e21;--muted:#65676b;--border:#dddfe2;--brand:#1877f2;}
  *{box-sizing:border-box}
  body{margin:0;font-family:Segoe UI,Roboto,Arial,sans-serif;background:var(--bg);color:var(--text)}
  a{text-decoration:none;color:var(--brand)}

  /* Top bar + basic layout */
  .topbar{position:sticky;top:0;z-index:5;background:#fff;border-bottom:1px solid var(--border);padding:10px 16px;display:flex;justify-content:space-between;align-items:center}
  .brand{font-weight:800;color:var(--brand);font-size:20px}
  .wrap{max-width:1100px;margin:16px auto;padding:0 12px;display:grid;grid-template-columns:260px 1fr;gap:16px}
  .sidebar{background:#fff;border:1px solid var(--border);border-radius:8px;overflow:hidden}
  .side-item{display:block;padding:14px 16px;color:#1c1e21;border-left:4px solid transparent}
  .side-item:hover{background:#f5f6f7}
  .active{background:#eef3ff;border-left-color:var(--brand);font-weight:700}

  .panel{background:#fff;border:1px solid var(--border);border-radius:8px}
  .panel h2{margin:0;padding:16px;border-bottom:1px solid var(--border)}
  .body{padding:16px}
  .row{display:flex;justify-content:space-between;align-items:center;border-bottom:1px solid #f0f0f0;padding:12px 0}
  .switch input{width:20px;height:20px}
  .actions{margin-top:16px;text-align:right}
  .btn{display:inline-block;padding:8px 12px;border:1px solid var(--border);border-radius:6px;background:#fff;cursor:pointer}
  .btn.primary{background:var(--brand);border-color:var(--brand);color:#fff}
  .alert{margin-top:8px}
  .ok{color:#187a1f}
  .err{color:#86181d}

  /* ========= Embedded mode ========= */
  :root.embedded{ --bg:#fff; }
  .embedded .topbar{ display:none; }
  .embedded .wrap{ grid-template-columns:1fr; }
  .embedded .sidebar{ display:none; }
  .embedded .panel{ border:none; border-radius:0; }
  .embedded .body{ padding:16px; }

  .embed-bar{
    display:none; align-items:center; justify-content:space-between;
    gap:8px; padding:10px 12px; border-bottom:1px solid var(--border);
    position:sticky; top:0; background:#fff; z-index:5;
  }
  .embedded .embed-bar{ display:flex; }
  .embed-title{ font-weight:700; }
  .embedded #embedCloseBtn{ display:none !important; }
</style>
</head>
<body>
<div class="topbar">
  <div class="brand">SmartRentalHub</div>
  <div>
    <a class="btn" href="<%=ctx%>/dashboard.jsp">Dashboard</a>
    <a class="btn" href="<%=ctx%>/profile.jsp">Back to Profile</a>
  </div>
</div>

<div class="wrap">
  <!-- Compact header only for iframe embed -->
  <div class="embed-bar">
    <span class="embed-title">Privacy Settings</span>
    <button type="button" class="btn" id="embedCloseBtn">✖ Close</button>
  </div>

  <aside class="sidebar">
    <a class="side-item <%= "profile".equals(pageKey)?"active":"" %>" href="<%=ctx%>/editProfile.jsp">Profile</a>
    <a class="side-item <%= "account".equals(pageKey)?"active":"" %>" href="<%=ctx%>/editAccount.jsp">Account</a>
    <a class="side-item <%= "privacy".equals(pageKey)?"active":"" %>" href="<%=ctx%>/editPrivacy.jsp">Privacy</a>
  </aside>

  <section class="panel">
    <form class="body" action="<%=ctx%>/settings/privacy/update" method="post">
      <div class="row">
        <div>Make my profile visible to everyone</div>
        <div class="switch">
          <input type="checkbox" name="profile_visible" <%= ps.isProfileVisible() ? "checked" : "" %> >
        </div>
      </div>

      <div class="actions">
        <a class="btn" href="<%=ctx%>/profile.jsp">Cancel</a>
        <button class="btn primary" type="submit">Save</button>
      </div>

      <% if ("1".equals(request.getParameter("updated"))) { %>
        <div class="alert ok">Saved.</div>
      <% } else if (request.getParameter("error") != null) { %>
        <div class="alert err">Couldn’t save changes.</div>
      <% } %>
    </form>
  </section>
</div>

<!-- Embed-mode script -->
<script>
  (function () {
    var isEmbedded = (function(){ try { return window.top !== window.self; } catch (e) { return true; }})();
    if (isEmbedded) document.documentElement.classList.add('embedded');

    var closeBtn = document.getElementById('embedCloseBtn');
    if (isEmbedded && closeBtn) {
      closeBtn.addEventListener('click', function(){
        window.parent.postMessage({ type: 'SRH_CLOSE_SETTINGS_MODAL' }, '*');
      });
    }

    if (isEmbedded) {
      var first = document.querySelector('input, select, textarea, button');
      if (first) first.focus({ preventScroll:true });
    }
  })();
</script>

</body>
</html>
