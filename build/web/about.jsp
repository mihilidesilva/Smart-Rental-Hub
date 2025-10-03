<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" session="true" %>
<%@ page import="com.smart.rentalhub.model.User" %>
<%
  String ctx  = request.getContextPath();
  User user   = (User) session.getAttribute("user"); // may be null
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <title>About – SmartRentalHub</title>
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <style>
 
    :root{
      --bg:#f6f7f8;
      --card:#ffffff;
      --text:#0f172a;
      --muted:#64748b;
      --border:#e5e7eb;
      --brand:#ff4500;
      --shadow:0 10px 30px rgba(0,0,0,.08);
      --radius:16px;
    }
    *{box-sizing:border-box}
    html,body{margin:0;padding:0;scroll-behavior:smooth}
    body{font-family:system-ui,-apple-system,Segoe UI,Roboto,Arial,sans-serif;background:var(--bg);color:var(--text)}
    a{color:inherit;text-decoration:none}

    /* ---------- Top bar ---------- */
    .header{position:sticky;top:0;z-index:50;background:#fff;border-bottom:1px solid var(--border);box-shadow:0 6px 20px rgba(0,0,0,.04)}
    .row{max-width:1200px;margin:0 auto;padding:14px 18px;display:flex;align-items:center;justify-content:space-between}
    .brand{color:var(--brand);font-weight:900;font-size:22px}

    .nav{display:flex;gap:10px;align-items:center;flex-wrap:wrap}
    .nav .pill{padding:8px 12px;border-radius:12px;font-weight:600;color:#374151}
    .nav .pill:hover{background:#f3f4f6}
    .nav .pill.active{background:#eef1f5}

    .btn{display:inline-flex;align-items:center;gap:8px;border:1px solid var(--border);
         background:#fff;padding:9px 14px;border-radius:12px;font-weight:800}
    .btn.brand{background:var(--brand);border-color:var(--brand);color:#fff}
    .btn.dark{background:#111827;border-color:#111827;color:#fff}
    .btn:hover{opacity:.95}

    /* ---------- Hero ---------- */
    .hero{isolation:isolate;background:
      radial-gradient(1200px 400px at 5% -10%, #ffe7dc 0, transparent 60%),
      radial-gradient(1000px 420px at 110% -20%, #e7f0ff 0, transparent 60%),
      linear-gradient(180deg,#ffffff 0%,#fafafa 100%)}
    .hero-in{max-width:1200px;margin:0 auto;padding:64px 18px 44px;display:grid;grid-template-columns:1.25fr 1fr;gap:28px}
    @media (max-width: 980px){ .hero-in{grid-template-columns:1fr} }
    .h1{margin:0 0 8px;font-weight:900;letter-spacing:-.02em;line-height:1.1;font-size:clamp(28px,5vw,44px)}
    .h-sub{margin:0 0 18px;color:var(--muted);font-size:clamp(14px,2.4vw,18px)}
    .h-actions{display:flex;gap:10px;flex-wrap:wrap}
    .feature-card{align-self:center;background:#fff;border:1px solid var(--border);border-radius:var(--radius);box-shadow:var(--shadow);padding:18px}
    .feat{display:grid;grid-template-columns:auto 1fr;gap:12px;margin:6px 0}
    .feat b{font-size:18px}
    .feat span{color:var(--muted)}

    /* ---------- Sections ---------- */
    .section{max-width:1200px;margin:28px auto;padding:0 18px}
    .section h2{margin:0 0 8px;font-size:26px}
    .lead{margin:0 0 16px;color:var(--muted)}
    .tiles{display:grid;grid-template-columns:repeat(3,1fr);gap:14px}
    @media (max-width: 980px){ .tiles{grid-template-columns:1fr} }
    .tile{background:#fff;border:1px solid var(--border);border-radius:14px;padding:16px;box-shadow:var(--shadow);display:flex;gap:12px}
    .i{display:grid;place-items:center;width:40px;height:40px;border-radius:12px;background:#fff0e6;border:1px solid #ffd3bf;font-size:20px}
    .tile h3{margin:2px 0 6px}
    .tile p{margin:0;color:var(--muted)}

    /* Steps */
    .steps{display:grid;grid-template-columns:repeat(3,1fr);gap:14px}
    @media (max-width: 980px){ .steps{grid-template-columns:1fr} }
    .step{background:#fff;border:1px solid var(--border);border-radius:14px;padding:16px;box-shadow:var(--shadow)}
    .badge{display:inline-grid;place-items:center;width:28px;height:28px;border-radius:50%;background:#111827;color:#fff;font-weight:900;margin-bottom:6px}

    /* Team  */
    .team{display:grid;grid-template-columns:repeat(3,1fr);gap:14px}
    @media (max-width: 980px){ .team{grid-template-columns:1fr} }
    .member{background:#fff;border:1px solid var(--border);border-radius:14px;padding:16px;box-shadow:var(--shadow);text-align:center}
    .avatar{width:74px;height:74px;border-radius:50%;display:inline-grid;place-items:center;background:#eef7ff;border:1px solid #cfe2ff;color:#1a73e8;font-weight:900;margin-bottom:8px}
    .role{color:var(--muted);font-size:14px}

    /* FAQ */
    .faq{display:grid;gap:10px}
    .qa{background:#fff;border:1px solid var(--border);border-radius:14px;box-shadow:var(--shadow);overflow:hidden}
    .qa button{all:unset;display:flex;justify-content:space-between;align-items:center;width:100%;padding:12px 14px;cursor:pointer;font-weight:700}
    .qa .a{display:none;padding:0 14px 14px;color:var(--muted);line-height:1.65}
    .qa.open .a{display:block}
    .chev{transition:transform .2s ease}
    .qa.open .chev{transform:rotate(180deg)}

    /* CTA band */
    .band{max-width:1200px;margin:28px auto;padding:0 18px}
    .cta-band{background:linear-gradient(135deg,#ffefe6 0,#eaf2ff 100%);border:1px solid var(--border);border-radius:18px;padding:18px 20px;display:flex;align-items:center;justify-content:space-between;gap:12px;flex-wrap:wrap;box-shadow:var(--shadow)}
    .cta-row{display:flex;gap:10px;flex-wrap:wrap}

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

  <!-- Top bar -->
  <header class="header">
    <div class="row">
      <a class="brand" href="<%= ctx %>/index.jsp">SmartRentalHub</a>

      <nav class="nav">
        <a class="pill" href="<%= ctx %>/index.jsp">Home</a>
        <a class="pill" href="<%= ctx %>/browseProperties">Browse</a>
        <a class="pill" href="<%= ctx %>/community.jsp">Community</a>
        <a class="pill active" href="<%= ctx %>/about.jsp">About</a>

        <% if (user != null) { %>
          <a class="pill" href="<%= ctx %>/profile.jsp">Profile</a>
          <a class="pill" href="<%= ctx %>/dashboard.jsp">Dashboard</a>
          <a class="btn brand" href="<%= ctx %>/logout.jsp">Logout</a>
        <% } else { %>
          <a class="pill" href="<%= ctx %>/login.jsp">Login</a>
          <a class="btn dark" href="<%= ctx %>/register.jsp">Sign up</a>
        <% } %>
      </nav>
    </div>
  </header>

  <!-- Hero -->
  <section class="hero">
    <div class="hero-in">
      <div>
        <h1 class="h1">About SmartRentalHub</h1>
        <p class="h-sub">A modern marketplace where tenants find great homes and landlords find great tenants—fast.</p>
        <div class="h-actions">
          <a class="btn brand" href="<%= ctx %>/browseProperties.jsp">Browse Listings</a>
          <% if (user == null) { %>
            <a class="btn" href="<%= ctx %>/register.jsp">Create Account</a>
          <% } else { %>
            <a class="btn" href="<%= ctx %>/PostPoperty.jsp">Post a Property</a>
          <% } %>
        </div>
      </div>

      <aside class="feature-card">
        <div class="feat">
          <div>🔎</div>
          <div><b>Seamless Search</b><br><span>Filter by city, price, and property type.</span></div>
        </div>
        <div class="feat">
          <div>🛡️</div>
          <div><b>Trust & Safety</b><br><span>Clear listings and responsive moderation.</span></div>
        </div>
        <div class="feat">
          <div>📞</div>
          <div><b>Direct Contact</b><br><span>Reach landlords via the phone number on each listing.</span></div>
        </div>
      </aside>
    </div>
  </section>

  <!-- Mission -->
  <section class="section">
    <h2>Our mission</h2>
    <p class="lead">Make renting transparent, fair, and pleasantly simple—for everyone.</p>

    <div class="tiles">
      <article class="tile">
        <div class="i">🏡</div>
        <div><h3>Quality Listings</h3><p>Clear details, clean photos, and upfront pricing—no surprises.</p></div>
      </article>
      <article class="tile">
        <div class="i">🔒</div>
        <div><h3>Privacy First</h3><p>We don’t display your phone/email publicly; landlords share their contact on listings.</p></div>
      </article>
      <article class="tile">
        <div class="i">⚡</div>
        <div><h3>Fast & Friendly</h3><p>Mobile-ready UI with performance in mind.</p></div>
      </article>
    </div>
  </section>

  <!-- How it works -->
  <section class="section">
    <h2>How it works</h2>
    <p class="lead">Three simple steps to get from search to signed.</p>

    <div class="steps">
      <div class="step"><div class="badge">1</div><h3>Explore</h3><p class="lead">Use filters to find listings that fit your budget and location.</p></div>
      <div class="step"><div class="badge">2</div><h3>Connect</h3><p class="lead">Call the landlord using the contact number shown on the listing.</p></div>
      <div class="step"><div class="badge">3</div><h3>Move Forward</h3><p class="lead">Arrange viewings, discuss terms, and get to “yes”.</p></div>
    </div>
  </section>

  <!-- Trust & Safety -->
  <section class="section">
    <h2>Trust & safety</h2>
    <p class="lead">Safety is built-in so you can focus on homes—not headaches.</p>

    <div class="tiles">
      <article class="tile">
        <div class="i">🧰</div>
        <div><h3>Reporting Tools</h3><p>Flag suspicious posts or behavior—admins review quickly.</p></div>
      </article>
      <article class="tile">
        <div class="i">🕵️</div>
        <div><h3>Privacy Controls</h3><p>We keep your personal contact details private by default.</p></div>
      </article>
      <article class="tile">
        <div class="i">📜</div>
        <div><h3>Clear Policies</h3><p>See our <a href="<%= ctx %>/terms.jsp">Terms</a> and <a href="<%= ctx %>/privacy.jsp">Privacy</a>.</p></div>
      </article>
    </div>
  </section>

  <!-- Team  -->
  <section class="section">
    <h2>Team</h2>
    <p class="lead">Small team, big on detail. We care about renting done right.</p>

    <div class="team">
      <div class="member"><div class="avatar">AM</div><strong>Alex Morgan</strong><div class="role">Product & Design</div></div>
      <div class="member"><div class="avatar" style="background:#e9f7ef;border-color:#cfead9;color:#0a7b34">RK</div><strong>Rayan Khan</strong><div class="role">Engineering</div></div>
      <div class="member"><div class="avatar" style="background:#fff0e6;border-color:#ffd3bf;color:#ff5a1f">SP</div><strong>Sara Patel</strong><div class="role">Community & Ops</div></div>
    </div>
  </section>

  <!-- FAQ -->
  <section class="section">
    <h2>FAQs</h2>
    <p class="lead">Quick answers to common questions.</p>

    <div class="faq" id="faq">
      <div class="qa">
        <button type="button" aria-expanded="false"><span>Is SmartRentalHub free?</span><span class="chev">▾</span></button>
        <div class="a">Creating an account and browsing are free. Premium features, if any, will be clearly priced.</div>
      </div>
      <div class="qa">
        <button type="button" aria-expanded="false"><span>How do I contact a landlord?</span><span class="chev">▾</span></button>
        <div class="a">There’s no in-app messaging yet. Each listing displays a contact number provided by the landlord.</div>
      </div>
      <div class="qa">
        <button type="button" aria-expanded="false"><span>Do you show my phone or email?</span><span class="chev">▾</span></button>
        <div class="a">No. Your personal contact details aren’t displayed publicly on the site.</div>
      </div>
    </div>
  </section>

  <!-- CTA band -->
  <div class="band">
    <div class="cta-band">
      <h3 style="margin:0">Ready to get started?</h3>
      <div class="cta-row">
        <a class="btn brand" href="<%= ctx %>/browseProperties.jsp">Find a place</a>
        <% if (user == null) { %>
          <a class="btn" href="<%= ctx %>/register.jsp">Create account</a>
        <% } else { %>
          <a class="btn" href="<%= ctx %>/PostPoperty.jsp">List your property</a>
        <% } %>
      </div>
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

  <script>
    // FAQ accordion
    (function(){
      document.querySelectorAll('#faq .qa').forEach(function(box){
        const btn = box.querySelector('button');
        btn.addEventListener('click', function(){
          const open = box.classList.toggle('open');
          btn.setAttribute('aria-expanded', open ? 'true' : 'false');
        });
      });
    })();
  </script>
</body>
</html>
