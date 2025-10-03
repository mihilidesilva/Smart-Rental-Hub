<%@ page import="com.smart.rentalhub.model.User" %>
<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" session="true" %>
<%
  User user = (User) session.getAttribute("user");
  if (user == null) { response.sendRedirect("login.jsp"); return; }
  String ctx = request.getContextPath();
  String pageKey = "prefs";
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Preferences – SmartRentalHub</title>
<meta name="viewport" content="width=device-width, initial-scale=1">
<style>
  :root{--bg:#f0f2f5;--card:#fff;--text:#1c1e21;--muted:#65676b;--border:#dddfe2;--brand:#1877f2;}
  *{box-sizing:border-box}
  body{margin:0;font-family:Segoe UI,Roboto,Arial,sans-serif;background:var(--bg);color:var(--text)}
  a{text-decoration:none;color:var(--brand)}

  .topbar{position:sticky;top:0;z-index:5;background:#fff;border-bottom:1px solid var(--border);
          padding:10px 16px;display:flex;justify-content:space-between;align-items:center}
  .brand{font-weight:800;color:var(--brand);font-size:20px}

  .wrap{max-width:1100px;margin:16px auto;padding:0 12px;display:grid;
        grid-template-columns:260px 1fr;gap:16px}
  .sidebar{background:#fff;border:1px solid var(--border);border-radius:8px;overflow:hidden}
  .side-item{display:block;padding:14px 16px;color:#1c1e21;border-left:4px solid transparent}
  .side-item:hover{background:#f5f6f7}
  .active{background:#eef3ff;border-left-color:var(--brand);font-weight:700}

  .panel{background:#fff;border:1px solid var(--border);border-radius:8px}
  .panel h2{margin:0;padding:16px;border-bottom:1px solid var(--border)}
  .body{padding:16px}
  .section{margin-bottom:18px}
  .label{font-weight:700;margin-bottom:8px}
  .row{display:flex;align-items:center;gap:10px;margin:8px 0}
  select, input[type=checkbox]{padding:8px;border:1px solid var(--border);border-radius:6px}
  .actions{text-align:right;margin-top:12px}
  .btn{display:inline-block;padding:8px 12px;border:1px solid var(--border);border-radius:6px;background:#fff}
  .btn.primary{background:var(--brand);border-color:var(--brand);color:#fff}

  /* Embedded mode styling */
  html.embedded body { background: #fff; }
  html.embedded .topbar,
  html.embedded .wrap > aside.sidebar { display: none; }
  html.embedded .wrap { max-width:100%; margin:0; padding:0; grid-template-columns:1fr; }
  html.embedded .panel { border:none; border-radius:0; }
  html.embedded .panel h2 { display:none; }
  .embed-bar {
    display:none;
    position:sticky;top:0;z-index:10;
    background:#fff;border-bottom:1px solid var(--border);
    padding:10px 14px;display:flex;justify-content:space-between;align-items:center;
  }
  html.embedded .embed-bar { display:flex; }
  .embed-close { border:none;background:none;font-size:18px;cursor:pointer; }
</style>
</head>
<body>

<!-- Embedded header  -->
<div class="embed-bar">
  <div style="font-weight:700">Preferences</div>
  <button class="embed-close" id="embedCloseBtn" title="Close">✖</button>
</div>

<div class="topbar">
  <div class="brand">SmartRentalHub</div>
  <div>
    <a class="btn" href="<%=ctx%>/dashboard.jsp">Dashboard</a>
    <a class="btn" href="<%=ctx%>/profile.jsp">Back to Profile</a>
  </div>
</div>

<div class="wrap">
  <aside class="sidebar">
    <a class="side-item <%= "profile".equals(pageKey)?"active":"" %>" href="<%=ctx%>/editProfile.jsp">Profile</a>
    <a class="side-item <%= "account".equals(pageKey)?"active":"" %>" href="<%=ctx%>/editAccount.jsp">Account</a>
    <a class="side-item <%= "privacy".equals(pageKey)?"active":"" %>" href="<%=ctx%>/editPrivacy.jsp">Privacy</a>
    <a class="side-item <%= "prefs".equals(pageKey)?"active":"" %>" href="<%=ctx%>/editPreferences.jsp">Preferences</a>
  </aside>

  <section class="panel">
    <h2>Preferences</h2>
    <div class="body">
      <div class="section">
        <div class="label">Appearance</div>
        <div class="row">
          Theme:
          <select>
            <option>Light</option>
            <option>Dark</option>
            <option>Auto</option>
          </select>
        </div>
        <div class="row">
          <label><input type="checkbox" checked> Reduce motion</label>
        </div>
      </div>

      <div class="section">
        <div class="label">Notifications</div>
        <div class="row"><label><input type="checkbox" checked> Email notifications</label></div>
        <div class="row"><label><input type="checkbox"> In-app sound</label></div>
        <div class="row"><label><input type="checkbox" checked> Listing updates</label></div>
      </div>

      <div class="actions">
        <button class="btn">Cancel</button>
        <button class="btn primary">Save</button>
      </div>
    </div>
  </section>
</div>

<script>
  // Detect if embedded in iframe
  var isEmbedded = (function(){ try { return window.top !== window.self; } catch(e){ return true; }})();
  if (isEmbedded) {
    document.documentElement.classList.add('embedded');
  }

  // Close button in embedded mode
  document.getElementById('embedCloseBtn')?.addEventListener('click', function(){
    window.parent.postMessage({ type: 'SRH_CLOSE_SETTINGS_MODAL' }, '*');
  });
</script>



</body>
</html>
