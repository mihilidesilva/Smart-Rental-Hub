<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%
  String ctx = request.getContextPath();
  String error = request.getParameter("error");   //  show server errors like ?error=exists
  String ok    = request.getParameter("ok");      //  show success like ?ok=1
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <title>Register – SmartRentalHub</title>
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <style>
    :root{
      --bg:#f6f7f8; --card:#ffffff; --text:#1f2937; --muted:#6b7280; --border:#e5e7eb;
      --brand:#ff4500; --shadow:0 10px 30px rgba(0,0,0,.08); --radius:14px;
    }
    *{box-sizing:border-box}
    html,body{margin:0;padding:0}
    body{font-family:system-ui,-apple-system,Segoe UI,Roboto,Arial,sans-serif;background:var(--bg);color:var(--text)}
    .top{position:sticky;top:0;z-index:10;background:#fff;border-bottom:1px solid var(--border)}
    .top .inner{max-width:1100px;margin:0 auto;padding:10px 16px;display:flex;justify-content:space-between;align-items:center}
    .brand{color:var(--brand);font-weight:900;font-size:22px;text-decoration:none}
    .nav a{color:#374151;text-decoration:none;font-weight:600;margin-left:10px;padding:8px 10px;border-radius:10px}
    .nav a:hover{background:#f3f4f6}
    .wrap{min-height:calc(100vh - 52px);display:grid;grid-template-columns:1.1fr 1fr}
    @media (max-width: 980px){ .wrap{grid-template-columns:1fr} }
    .left{
      background:
        radial-gradient(900px 380px at 110% 0%, #e7f0ff 0, transparent 60%),
        radial-gradient(900px 380px at -10% 10%, #ffe7dc 0, transparent 60%),
        linear-gradient(180deg,#ffffff 0%,#fafafa 100%);
      display:flex;align-items:center;justify-content:center;padding:40px 24px;border-right:1px solid var(--border);
    }
    .pitch{max-width:560px}
    .pitch h1{font-size:40px;line-height:1.12;margin:0 0 10px;font-weight:900;letter-spacing:-.02em}
    .pitch p{color:var(--muted);margin:0 0 12px}
    .bullets{display:grid;gap:8px;margin-top:10px}
    .bullet{display:flex;gap:10px;align-items:flex-start}
    .tick{font-size:18px}
    .right{display:flex;align-items:center;justify-content:center;padding:40px 16px}
    .card{width:min(540px, 94vw);background:#fff;border:1px solid var(--border);border-radius:var(--radius);box-shadow:var(--shadow);padding:22px}
    .card h2{margin:0 0 6px}
    .muted{color:var(--muted)}
    form{margin-top:10px}
    .grid{display:grid;grid-template-columns:1fr 1fr;gap:12px}
    @media (max-width:700px){ .grid{grid-template-columns:1fr} }
    .full{grid-column:1 / -1}
    .field{display:flex;flex-direction:column;gap:6px}
    .label{font-weight:700}
    .input,.area,.select{width:100%;padding:12px;border:1px solid var(--border);border-radius:10px;background:#fff;font-size:16px}
    .area{min-height:110px;resize:vertical}
    .help{color:var(--muted);font-size:12px}
    .actions{display:flex;gap:10px;align-items:center;margin-top:14px}
    .btn{display:inline-flex;align-items:center;gap:8px;border:1px solid var(--border);background:#fff;padding:10px 14px;border-radius:12px;font-weight:800;color:#111827;cursor:pointer;text-decoration:none}
    .btn.primary{background:var(--brand);border-color:var(--brand);color:#fff}
    .btn:disabled{opacity:.6;cursor:not-allowed}
    .avatar-wrap{display:flex;align-items:center;gap:12px}
    .avatar{width:64px;height:64px;border-radius:50%;object-fit:cover;border:2px solid #fff;box-shadow:0 2px 10px rgba(0,0,0,.08);background:#f3f4f6}
    .alert{margin:10px 0 0;padding:10px 12px;border-radius:10px;font-weight:600}
    .alert.err{border:1px solid #f3c7cd;background:#fdecef;color:#7a1120}
    .alert.ok{border:1px solid #cde8d0;background:#e7f3e8;color:#187a1f}
    .foot{max-width:1100px;margin:20px auto 24px;text-align:center;color:#94a3b8;font-size:13px}
    
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
      <a href="<%= ctx %>/" class="brand">SmartRentalHub</a>
      <div class="nav">
        <a href="<%= ctx %>/index.jsp">Home</a>
        <a href="<%= ctx %>/login.jsp">Login</a>
        <a href="<%= ctx %>/listings.jsp">Browse</a>
        <a href="<%= ctx %>/community.jsp">Community</a>
      </div>
    </div>
  </div>

  <div class="wrap">
    <section class="left">
      <div class="pitch">
        <h1>Create your account 🎉</h1>
        <p>Join a modern rental marketplace with verified users and clean tools.</p>
        <div class="bullets">
          <div class="bullet"><span class="tick">✅</span><span>Discover verified listings</span></div>
          <div class="bullet"><span class="tick">✅</span><span>Chat safely with landlords & tenants</span></div>
          <div class="bullet"><span class="tick">✅</span><span>Manage bookings and profiles with ease</span></div>
        </div>
      </div>
    </section>

    <section class="right">
      <div class="card">
        <h2>Register</h2>
        <div class="muted">Fill in your details to get started.</div>

        <% if ("1".equals(ok)) { %>
          <div class="alert ok">Account created successfully. You can now log in.</div>
        <% } else if (error != null) { %>
          <div class="alert err"><%= error %></div>
        <% } %>

        <form action="<%= ctx %>/register" method="post" enctype="multipart/form-data" id="registerForm" autocomplete="on">
          <div class="grid">
            <div class="field">
              <label class="label" for="username">Username</label>
              <input class="input" type="text" id="username" name="username" required minlength="3" placeholder="yourname">
              <div class="help">3+ characters, letters & numbers.</div>
            </div>

            <div class="field">
              <label class="label" for="password">Password</label>
              <div style="position:relative">
                <input class="input" type="password" id="password" name="password" required minlength="6" placeholder="••••••••">
                <button type="button" id="togglePw" aria-label="Show password"
                        style="position:absolute;right:8px;top:50%;transform:translateY(-50%);border:none;background:#f3f4f6;padding:6px 8px;border-radius:8px;cursor:pointer;">
                  Show
                </button>
              </div>
              <div class="help">At least 6 characters.</div>
            </div>

            <div class="field">
              <label class="label" for="fullname">Full Name</label>
              <input class="input" type="text" id="fullname" name="fullname" placeholder="Jane Doe">
            </div>

            <div class="field">
              <label class="label" for="email">Email</label>
              <input class="input" type="email" id="email" name="email" required placeholder="name@example.com">
            </div>

            <div class="field full">
              <label class="label" for="bio">Bio</label>
              <textarea class="area" id="bio" name="bio" placeholder="Tell others about you..."></textarea>
            </div>

            <div class="field full">
              <label class="label" for="profile_img">Profile Picture</label>
              <div class="avatar-wrap">
                <img id="avatarPreview" class="avatar" alt="Preview" src="" style="display:none;">
                <input class="input" type="file" id="profile_img" name="profile_img" accept="image/*">
              </div>
              <div class="help">JPG/PNG suggested. Max size per your server settings.</div>
            </div>

            <div class="field">
              <label class="label" for="role">Role</label>
              <select class="select" id="role" name="role">
                <option value="tenant">Tenant</option>
                <option value="landlord">Landlord</option>
                <option value="admin">Admin</option>
              </select>
            </div>

            <!-- Admin access code – visible only if "Admin" selected -->
            <div class="field" id="adminCodeWrap" style="display:none">
              <label class="label" for="admin_code">Admin Access Code</label>
              <input class="input" type="password" id="admin_code" name="admin_code" placeholder="Enter admin code">
              <div class="help">Required only when registering as Admin.</div>
            </div>
          </div>

          <div class="actions">
            <button class="btn primary" type="submit" id="submitBtn">Create account</button>
            <a class="btn" href="<%= ctx %>/login.jsp">Back to login</a>
          </div>

          <div class="help" style="margin-top:8px">
            By creating an account you agree to our
            <a class="link" href="<%= ctx %>/terms.jsp" target="_blank">Terms</a> &amp;
            <a class="link" href="<%= ctx %>/privacy.jsp" target="_blank">Privacy</a>.
          </div>
        </form>
      </div>
    </section>
  </div>

  <div class="foot">© <%= java.time.Year.now() %> SmartRentalHub</div>

  <script>
    // Show/hide password
    (function(){
      var t = document.getElementById('togglePw');
      var p = document.getElementById('password');
      t?.addEventListener('click', function(){
        var is = p.type === 'password';
        p.type = is ? 'text' : 'password';
        t.textContent = is ? 'Hide' : 'Show';
      });
    })();

    // Live preview for profile image
    (function(){
      var input = document.getElementById('profile_img');
      var img   = document.getElementById('avatarPreview');
      input?.addEventListener('change', function(e){
        var f = e.target.files && e.target.files[0];
        if(!f){ img.style.display='none'; img.src=''; return; }
        var url = URL.createObjectURL(f);
        img.src = url; img.style.display = 'block';
      });
    })();

    // Admin code field – show only when "Admin" is selected
    (function(){
      var roleSel = document.getElementById('role');
      var wrap    = document.getElementById('adminCodeWrap');
      function sync(){
        wrap.style.display = (roleSel.value === 'admin') ? 'block' : 'none';
      }
      roleSel.addEventListener('change', sync);
      sync();

      //  client-side guard
      document.getElementById('registerForm').addEventListener('submit', function(e){
        if (roleSel.value === 'admin') {
          var code = document.getElementById('admin_code').value.trim();
          if (!code) {
            e.preventDefault();
            alert('Admin Access Code is required to register as Admin.');
          }
        }
      });
    })();

    // Prevent double submit
    (function(){
      var form = document.getElementById('registerForm');
      var btn  = document.getElementById('submitBtn');
      form?.addEventListener('submit', function(){
        btn.disabled = true;
        btn.textContent = 'Creating…';
      });
    })();
  </script>
  




  
        
    </style>
</head>
<body>
    
    
    
    
        
        <!-- FOOTER -->
  <footer class="footer">
    <div class="inner">
      <div>
        <div class="f-brand">SmartRentalHub</div>
        <p class="meta" style="color:#cbd5e1">Find, list, and manage rentals with ease.</p>
      </div>
      <div class="f-col">
        <strong>Product</strong>
         <a href="<%= ctx %>/index.jsp">Home</a>
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
