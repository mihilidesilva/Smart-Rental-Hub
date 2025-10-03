<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" session="true" %>
<%@ page import="com.smart.rentalhub.model.User" %>
<%
  String ctx = request.getContextPath();
  User user = (User) session.getAttribute("user"); // may be null
  boolean isAdminUser = (user != null && user.getRole() != null && "admin".equalsIgnoreCase(user.getRole()));
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <title>Privacy Policy – SmartRentalHub</title>
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <style>
    :root{
      --bg:#f6f7f8; --card:#ffffff; --text:#1f2937; --muted:#6b7280; --border:#e5e7eb;
      --brand:#ff4500; --shadow:0 8px 24px rgba(0,0,0,.06); --radius:14px;
    }
    *{box-sizing:border-box}
    body{margin:0;font-family:system-ui,-apple-system,Segoe UI,Roboto,Arial,sans-serif;background:var(--bg);color:var(--text)}
    a{color:#0f172a;text-decoration:none}
    a:hover{text-decoration:underline}

    /* ===== Shared site header (same as your homepage) ===== */
    .header{position:sticky;top:0;z-index:40;background:#fff;border-bottom:1px solid var(--border);box-shadow:0 6px 20px rgba(0,0,0,.05)}
    .header .inner{max-width:1200px;margin:0 auto;padding:12px 18px;display:flex;align-items:center;justify-content:space-between}
    .brand{display:flex;align-items:center;gap:10px;color:var(--brand);font-weight:900;font-size:22px;text-decoration:none}
    .nav{display:flex;align-items:center;gap:14px}
    .nav a{color:#374151;text-decoration:none;font-weight:600;padding:8px 10px;border-radius:10px}
    .nav a:hover{background:#f3f4f6}
    .cta{background:var(--brand);color:#fff;border-radius:999px;padding:8px 14px}
    .cta:hover{opacity:.95}

    /* ===== Page layout ===== */
    .wrap{max-width:1200px;margin:18px auto;padding:0 16px;display:grid;grid-template-columns:280px 1fr;gap:18px}
    @media (max-width: 980px){ .wrap{grid-template-columns:1fr} }
    .toc{position:sticky;top:78px;align-self:start;background:#fff;border:1px solid var(--border);border-radius:var(--radius);padding:14px;box-shadow:var(--shadow)}
    .toc h3{margin:0 0 8px}
    .toc ul{list-style:none;padding:0;margin:0;display:grid;gap:8px}
    .toc a{color:#374151;text-decoration:none}
    .toc a:hover{text-decoration:underline}

    .paper{background:#fff;border:1px solid var(--border);border-radius:var(--radius);box-shadow:var(--shadow);padding:24px}
    .paper h1{margin:0 0 6px;font-size:28px}
    .meta{color:var(--muted);margin-bottom:16px}
    .section{margin:18px 0}
    .section h2{font-size:20px;margin:0 0 8px}
    .section p{margin:8px 0;line-height:1.65}
    .bullets{margin:8px 0 0 0}
    .bullets li{margin:6px 0}
    .note{background:#f9fafb;border:1px solid var(--border);padding:10px 12px;border-radius:10px;color:#374151}

    .foot{max-width:1200px;margin:24px auto 28px;padding:0 16px;color:#94a3b8;font-size:13px;text-align:center}
  
  
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

  <!-- ===== Header ===== -->
  <header class="header">
    <div class="inner">
      <a class="brand" href="<%= ctx %>/index.jsp">SmartRentalHub</a>
      <nav class="nav">
          <a href="<%= ctx %>/index.jsp">Home</a>
        <a href="<%= ctx %>/browseProperties">Browse</a>
        <a href="<%= ctx %>/community.jsp">Community</a>
        <a href="<%= ctx %>/about.jsp">About</a>
        <% if (user == null) { %>
          <a href="<%= ctx %>/login.jsp" class="cta">Login</a>
          <a href="<%= ctx %>/register.jsp" class="cta" style="background:#111827">Sign up</a>
        <% } else { %>
          <a href="<%= ctx %>/profile.jsp">Profile</a>
          <a href="<%= ctx %>/<%= isAdminUser ? "admin.jsp" : "dashboard.jsp" %>">Dashboard</a>
          <a href="<%= ctx %>/logout.jsp" class="cta">Logout</a>
        <% } %>
      </nav>
    </div>
  </header>

  <!-- ===== Content ===== -->
  <div class="wrap">
    <!-- Table of contents -->
    <aside class="toc">
      <h3>On this page</h3>
      <ul>
        <li><a href="#overview">Overview</a></li>
        <li><a href="#collect">What We Collect</a></li>
        <li><a href="#use">How We Use Data</a></li>
        <li><a href="#cookies">Cookies & Tracking</a></li>
        <li><a href="#share">How We Share Data</a></li>
        <li><a href="#controls">Your Controls</a></li>
        <li><a href="#access">Access, Update & Deletion</a></li>
        <li><a href="#security">Security</a></li>
        <li><a href="#retention">Data Retention</a></li>
        <li><a href="#children">Children</a></li>
        <li><a href="#international">International Transfers</a></li>
        <li><a href="#changes">Changes to this Policy</a></li>
        <li><a href="#contact">Contact Us</a></li>
      </ul>
    </aside>

    <!-- Paper -->
    <main class="paper">
      <h1>Privacy Policy</h1>
      <div class="meta">Last updated: <%= java.time.LocalDate.now() %></div>

      <div id="overview" class="section">
        <h2>Overview</h2>
        <p>
          This Privacy Policy explains how <strong>SmartRentalHub</strong> (“we”, “us”, “our”) collects, uses,
          shares, and protects your information when you use our website and services (the “Service”).
          Your privacy matters—please read this carefully.
        </p>
      </div>

      <div id="collect" class="section">
        <h2>What We Collect</h2>
        <p>We collect the following categories of data when you use the Service:</p>
        <ul class="bullets">
          <li><strong>Account data:</strong> username, password (hashed), role, email, display name, bio, profile and cover images.</li>
          <li><strong>Usage data:</strong> pages viewed, interactions (likes/saves), searches, device/browser info, IP address, timestamps.</li>
          <li><strong>Content data:</strong> listings you create, messages you send, reviews you write, images you upload.</li>
          <li><strong>Transactional data:</strong> payments or fees processed via third-party providers (we don’t store full card details).</li>
          <li><strong>Log data:</strong> system logs for security, debugging, and abuse prevention.</li>
        </ul>
        <p class="note">Some information is optional and shown publicly only if you choose to share it (e.g., bio, profile photo).</p>
      </div>

      <div id="use" class="section">
        <h2>How We Use Data</h2>
        <ul class="bullets">
          <li>To provide core features: authentication, profiles, listings, messaging, and search.</li>
          <li>To personalize your experience and recommend relevant content.</li>
          <li>To keep the platform safe: security monitoring, fraud and abuse detection, and policy enforcement.</li>
          <li>To communicate with you: service notices, updates, and support.</li>
          <li>To analyze and improve product performance and reliability.</li>
          <li>To comply with legal obligations.</li>
        </ul>
      </div>

      <div id="cookies" class="section">
        <h2>Cookies & Tracking</h2>
        <p>
          We use cookies and similar technologies to keep you signed in, remember preferences, and measure usage.
          You can control cookies via your browser settings. Disabling essential cookies may limit functionality.
        </p>
      </div>

      <div id="share" class="section">
        <h2>How We Share Data</h2>
        <ul class="bullets">
          <li><strong>Service providers:</strong> hosting, analytics, logging, and payment vendors under contract.</li>
          <li><strong>With other users:</strong> content you make public (e.g., listings, profile information per your privacy settings).</li>
          <li><strong>Legal & safety:</strong> to comply with law or protect rights, property, users, or the public.</li>
          <li><strong>Business changes:</strong> in a merger, acquisition, or asset transfer, subject to this Policy.</li>
        </ul>
      </div>

      <div id="controls" class="section">
        <h2>Your Controls</h2>
        <p>
          You can manage visibility and communication settings in
          <a href="<%= ctx %>/editPrivacy.jsp">Privacy</a> and <a href="<%= ctx %>/editPreferences.jsp">Preferences</a>:
        </p>
        <ul class="bullets">
          <li>Make your profile visible to everyone or restrict it.</li>
          <li>Allow or block messages from non-followers.</li>
          <li>Show or hide your activity status.</li>
          <li>Choose notification and appearance preferences.</li>
        </ul>
      </div>

      <div id="access" class="section">
        <h2>Access, Update & Deletion</h2>
        <p>
          You can review and update your profile information at any time via
          <a href="<%= ctx %>/editProfile.jsp">Edit Profile</a> and <a href="<%= ctx %>/editAccount.jsp">Account</a>.
          To request account deletion or export, contact us at
          <a href="mailto:support@smartrentalhub.example">support@smartrentalhub.example</a>.
        </p>
      </div>

      <div id="security" class="section">
        <h2>Security</h2>
        <p>
          We use industry-standard protections (e.g., hashed passwords, access controls) to safeguard data.
          No system is 100% secure; please use a strong, unique password and keep your credentials confidential.
        </p>
      </div>

      <div id="retention" class="section">
        <h2>Data Retention</h2>
        <p>
          We retain data as long as needed to provide the Service and for legitimate business or legal purposes.
          Retention periods vary by data type and applicable laws.
        </p>
      </div>

      <div id="children" class="section">
        <h2>Children</h2>
        <p>
          SmartRentalHub is not directed to children under the age of 13 (or the age of digital consent in your region).
          We do not knowingly collect personal data from children.
        </p>
      </div>

      <div id="international" class="section">
        <h2>International Transfers</h2>
        <p>
          Your information may be processed in countries other than your own. We take steps to ensure appropriate protections
          consistent with this Policy and applicable law.
        </p>
      </div>

      <div id="changes" class="section">
        <h2>Changes to this Policy</h2>
        <p>
          We may update this Privacy Policy from time to time. Changes are effective when posted.
          If updates are material, we’ll provide reasonable notice through the Service.
        </p>
      </div>

      <div id="contact" class="section">
        <h2>Contact Us</h2>
        <p>
          Questions or requests? Email <a href="mailto:support@smartrentalhub.example">support@smartrentalhub.example</a>.
        </p>
      </div>
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
