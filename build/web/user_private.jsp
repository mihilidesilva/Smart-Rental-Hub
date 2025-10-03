<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.smart.rentalhub.model.User" %>
<%
  String ctx = request.getContextPath();
  User target = (User) request.getAttribute("target");
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Private Profile</title>
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <style>
    :root{--bg:#f6f7f8;--card:#fff;--text:#1f2937;--muted:#6b7280;--border:#e5e7eb;--brand:#ff4500;--radius:12px;}
    body{margin:0;font-family:system-ui,-apple-system,Segoe UI,Roboto,Arial,sans-serif;background:var(--bg);color:var(--text)}
    .top{background:#fff;border-bottom:1px solid var(--border)}
    .top .inner{max-width:1100px;margin:0 auto;padding:10px 16px;display:flex;justify-content:space-between;align-items:center}
    .brand{color:var(--brand);font-weight:900;text-decoration:none}
    .wrap{max-width:1100px;margin:16px auto;padding:0 12px}
    .panel{background:#fff;border:1px solid var(--border);border-radius:12px;padding:16px}
    .muted{color:#6b7280}
    
           
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
      <a class="btn" href="<%= ctx %>/search?q=">Back to Search</a>
    </div>
  </div>

  <div class="wrap">
    <div class="panel">
      <h2>🔒 This profile is private</h2>
      <p class="muted">You can’t view <strong>@<%= target.getUsername() %></strong>’s profile.</p>
    </div>
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
