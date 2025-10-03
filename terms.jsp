<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" session="true" %>
<%@ page import="com.smart.rentalhub.model.User" %>
<%
  String ctx = request.getContextPath();
  User user = (User) session.getAttribute("user");
  boolean isAdminUser = (user != null && user.getRole() != null && "admin".equalsIgnoreCase(user.getRole()));
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <title>Terms of Service – SmartRentalHub</title>
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

    /* ===== Shared site header  ===== */
    .header{position:sticky;top:0;z-index:40;background:#fff;border-bottom:1px solid var(--border);box-shadow:0 6px 20px rgba(0,0,0,.05)}
    .header .inner{max-width:1200px;margin:0 auto;padding:12px 18px;display:flex;align-items:center;justify-content:space-between}
    .brand{display:flex;align-items:center;gap:10px;color:var(--brand);font-weight:900;font-size:22px;text-decoration:none}
    .nav{display:flex;align-items:center;gap:14px}
    .nav a{color:#374151;text-decoration:none;font-weight:600;padding:8px 10px;border-radius:10px}
    .nav a:hover{background:#f3f4f6}
    .cta{background:var(--brand);color:#fff;border-radius:999px;padding:8px 14px}
    .cta:hover{opacity:.95}

    /* ===== Page layout  ===== */
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

  <!-- ===== Shared Header ===== -->
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

  <!-- ===== Content  ===== -->
  <div class="wrap">
    <aside class="toc">
      <h3>On this page</h3>
      <ul>
        <li><a href="#intro">Introduction</a></li>
        <li><a href="#eligibility">Eligibility & Accounts</a></li>
        <li><a href="#use">Acceptable Use</a></li>
        <li><a href="#listings">Listings & Transactions</a></li>
        <li><a href="#fees">Fees & Payments</a></li>
        <li><a href="#messaging">Messaging</a></li>
        <li><a href="#reviews">Reviews</a></li>
        <li><a href="#content">Your Content & IP</a></li>
        <li><a href="#privacy">Privacy</a></li>
        <li><a href="#third">Third-Party Links</a></li>
        <li><a href="#termination">Termination</a></li>
        <li><a href="#disclaimers">Disclaimers & Liability</a></li>
        <li><a href="#law">Governing Law</a></li>
        <li><a href="#changes">Changes to these Terms</a></li>
        <li><a href="#contact">Contact</a></li>
      </ul>
    </aside>

    <main class="paper">
      <h1>Terms of Service</h1>
      <div class="meta">Last updated: <%= java.time.LocalDate.now() %></div>

      <div id="intro" class="section">
        <h2>1) Introduction</h2>
        <p>
          Welcome to <strong>SmartRentalHub</strong> (“we”, “us”, “our”). These Terms of Service (“Terms”)
          govern your access to and use of the SmartRentalHub website, applications, and services (the “Service”).
          By creating an account or using the Service, you agree to these Terms.
        </p>
        <p class="note">If you don’t agree to these Terms, please don’t use the Service.</p>
      </div>

      <div id="eligibility" class="section">
        <h2>2) Eligibility & Accounts</h2>
        <p>
          You must be at least the age of majority in your jurisdiction and capable of forming a binding contract.
          You’re responsible for your account credentials and all activity under your account. Keep your password secure and
          notify us immediately of any unauthorized use.
        </p>
      </div>

      <div id="use" class="section">
        <h2>3) Acceptable Use</h2>
        <p>You agree not to misuse the Service. For example, you must not:</p>
        <ul>
          <li>violate any applicable law or regulation;</li>
          <li>post false, misleading, or fraudulent listings or reviews;</li>
          <li>infringe intellectual property or privacy rights;</li>
          <li>attempt to interfere with the Service or access it using a method other than the interface provided;</li>
          <li>harass, abuse, or harm other users.</li>
        </ul>
      </div>

      <div id="listings" class="section">
        <h2>4) Listings & Transactions</h2>
        <p>
          Landlords are solely responsible for the accuracy, legality, and availability of their listings. Tenants are
          responsible for verifying a listing’s suitability. We are not a party to rental contracts between users.
        </p>
      </div>

      <div id="fees" class="section">
        <h2>5) Fees & Payments</h2>
        <p>
          We may charge platform or transaction fees for certain features. Any fees will be disclosed before you incur them.
          You authorize us and our payment processors to charge the payment method you provide.
        </p>
      </div>

      <div id="messaging" class="section">
        <h2>6) Messaging</h2>
        <p>
          Our messaging tools are for legitimate rental-related communications. We may use automated systems to moderate,
          filter, or flag content to maintain platform safety.
        </p>
      </div>

      <div id="reviews" class="section">
        <h2>7) Reviews</h2>
        <p>
          Reviews must be honest and based on real experiences. We may remove reviews that violate these Terms or our policies.
        </p>
      </div>

      <div id="content" class="section">
        <h2>8) Your Content & Intellectual Property</h2>
        <p>
          You retain ownership of content you submit. You grant us a worldwide, non-exclusive, royalty-free license to host,
          store, display, and distribute your content as needed to operate the Service. Do not upload content you don’t have
          rights to use.
        </p>
      </div>

      <div id="privacy" class="section">
        <h2>9) Privacy</h2>
        <p>
          Our <a href="<%= ctx %>/privacy.jsp">Privacy Policy</a> explains how we collect and use personal information.
          By using the Service, you consent to our data practices described there.
        </p>
      </div>

      <div id="third" class="section">
        <h2>10) Third-Party Links</h2>
        <p>
          The Service may link to third-party sites or services. We don’t control and aren’t responsible for their content or practices.
        </p>
      </div>

      <div id="termination" class="section">
        <h2>11) Suspension & Termination</h2>
        <p>
          We may suspend or terminate your access if you violate these Terms or create risk for others. You may stop using the Service at any time.
        </p>
      </div>

      <div id="disclaimers" class="section">
        <h2>12) Disclaimers & Limitation of Liability</h2>
        <p>
          The Service is provided “as is” without warranties of any kind. To the fullest extent permitted by law, we
          disclaim all implied warranties and will not be liable for indirect or consequential damages arising from your use
          of the Service.
        </p>
      </div>

      <div id="law" class="section">
        <h2>13) Governing Law</h2>
        <p>
          These Terms are governed by the laws of your deployment jurisdiction (unless your local law requires otherwise),
          without regard to conflict of law principles.
        </p>
      </div>

      <div id="changes" class="section">
        <h2>14) Changes to these Terms</h2>
        <p>
          We may update these Terms from time to time. Changes take effect when posted. If we make material changes, we’ll
          provide reasonable notice through the Service.
        </p>
      </div>

      <div id="contact" class="section">
        <h2>15) Contact</h2>
        <p>
          Questions? Reach us at <a href="mailto:support@smartrentalhub.example">support@smartrentalhub.example</a>.
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
