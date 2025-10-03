<%@ page import="com.smart.rentalhub.model.User" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" session="true" %>
<%
    User user = (User) session.getAttribute("user");
    String ctx = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <title>SmartRentalHub – Find, List, and Manage Rentals</title>
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <style>
    :root{
      --bg:#f6f7f8; --card:#ffffff; --text:#1f2937; --muted:#6b7280; --border:#e5e7eb;
      --brand:#ff4500; --primary:#1877f2; --ok:#0a7b34; --shadow:0 10px 30px rgba(0,0,0,.08);
      --radius:14px;
    }
    *{box-sizing:border-box}
    html,body{margin:0;padding:0}
    body{font-family:system-ui,-apple-system,Segoe UI,Roboto,Arial,sans-serif;background:var(--bg);color:var(--text);}

    /* Header */
    .header{position:sticky;top:0;z-index:40;background:#fff;border-bottom:1px solid var(--border);box-shadow:0 6px 20px rgba(0,0,0,.05)}
    .header .inner{max-width:1200px;margin:0 auto;padding:12px 18px;display:flex;align-items:center;justify-content:space-between}
    .brand{display:flex;align-items:center;gap:10px;color:var(--brand);font-weight:900;font-size:22px;text-decoration:none}
    .nav{display:flex;align-items:center;gap:14px}
    .nav a{color:#374151;text-decoration:none;font-weight:600;padding:8px 10px;border-radius:10px}
    .nav a:hover{background:#f3f4f6}
    .cta{background:var(--brand);color:#fff;border-radius:999px;padding:8px 14px}
    .cta:hover{opacity:.95}

    /* Carousel hero */
    .hero-wrap{background:#fff;border-bottom:1px solid var(--border)}
    .carousel{position:relative;max-width:1200px;margin:0 auto;aspect-ratio:16/6;overflow:hidden;border-radius:16px}
    @media (max-width: 980px){ .carousel{aspect-ratio:16/9;border-radius:0} }
    .slides{display:flex;width:100%;height:100%;transition:transform .6s ease}
    .slide{flex:0 0 100%;position:relative;background:#e5e7eb center/cover no-repeat}
    .slide::before{
      content:"";position:absolute;inset:0;background:
        linear-gradient(180deg,rgba(0,0,0,.35),rgba(0,0,0,.25) 40%,rgba(0,0,0,.15));
    }
    .hero-content{position:absolute;inset:0;display:flex;align-items:flex-end}
    .hero-pad{padding:24px;color:#fff;max-width:850px}
    .hero-title{margin:0 0 6px;font-size:40px;font-weight:900;letter-spacing:-.02em}
    .hero-sub{margin:0 0 12px;color:#e5e7eb}
    .h-actions{display:flex;gap:10px;flex-wrap:wrap}
    .btn{display:inline-flex;align-items:center;gap:8px;border:1px solid var(--border);background:#fff;padding:10px 14px;border-radius:12px;font-weight:700;color:#111827;text-decoration:none}
    .btn.primary{background:var(--brand);border-color:var(--brand);color:#fff}

    .ctrl{position:absolute;top:50%;transform:translateY(-50%);z-index:2;border:0;background:rgba(255,255,255,.9);width:40px;height:40px;border-radius:10px;cursor:pointer;display:flex;align-items:center;justify-content:center}
    .ctrl:hover{background:#fff}
    .prev{left:10px} .next{right:10px}

    .dots{position:absolute;left:0;right:0;bottom:10px;display:flex;gap:6px;justify-content:center;z-index:2}
    .dot{width:8px;height:8px;border-radius:50%;background:rgba(255,255,255,.6);cursor:pointer}
    .dot.active{background:#fff}

    /* Stripes / tiles */
    .stripe{max-width:1200px;margin:18px auto;padding:0 18px 8px}
    .tiles{display:grid;grid-template-columns:repeat(3,1fr);gap:14px}
    @media (max-width: 960px){ .tiles{grid-template-columns:1fr} }
    .tile{background:#fff;border:1px solid var(--border);border-radius:14px;padding:16px;display:flex;gap:12px;align-items:flex-start;box-shadow:var(--shadow)}
    .tile h3{margin:4px 0 6px}
    .tile p{margin:0;color:var(--muted)}
    .i{font-size:22px}

    /* Sections & grids */
    .section{max-width:1200px;margin:24px auto;padding:0 18px}
    .section h2{margin:0 0 8px;font-size:22px}
    .section .lead{margin:0 0 14px;color:var(--muted)}
    .grid{display:grid;grid-template-columns:repeat(3,1fr);gap:14px}
    @media (max-width: 960px){ .grid{grid-template-columns:1fr} }

    .card{background:#fff;border:1px solid var(--border);border-radius:14px;padding:12px;box-shadow:var(--shadow);display:flex;flex-direction:column;gap:10px}
    .thumb{border-radius:10px;background:#e5e7eb;height:180px;background-size:cover;background-position:center}
    .title{font-weight:800;margin:2px 0 0}
    .meta{color:var(--muted);font-size:14px}

    /* Cities row */
    .cities{display:grid;grid-template-columns:repeat(6,1fr);gap:12px}
    @media (max-width: 1100px){ .cities{grid-template-columns:repeat(3,1fr)} }
    @media (max-width: 640px){ .cities{grid-template-columns:repeat(2,1fr)} }
    .city{position:relative;border-radius:12px;overflow:hidden;border:1px solid var(--border);box-shadow:var(--shadow);background:#e5e7eb}
    .city img{display:block;width:100%;height:130px;object-fit:cover}
    .city span{position:absolute;left:10px;bottom:8px;background:rgba(0,0,0,.55);color:#fff;padding:4px 8px;border-radius:8px;font-weight:700}

    /* Gallery */
    .gallery{display:grid;grid-template-columns:repeat(3,1fr);gap:12px}
    @media (max-width: 960px){ .gallery{grid-template-columns:repeat(2,1fr)} }
    .gimg{border-radius:12px;overflow:hidden;border:1px solid var(--border);box-shadow:var(--shadow);background:#e5e7eb}
    .gimg img{display:block;width:100%;height:180px;object-fit:cover}

    /* Footer */
    .footer{margin-top:34px;background:#0f172a;color:#cbd5e1}
    .footer .inner{max-width:1200px;margin:0 auto;padding:28px 18px;display:grid;grid-template-columns:2fr 1fr 1fr 1fr;gap:18px}
    @media (max-width: 980px){ .footer .inner{grid-template-columns:1fr 1fr;gap:12px} }
    @media (max-width: 640px){ .footer .inner{grid-template-columns:1fr} }
    .f-brand{font-weight:900;color:#fff;margin:0 0 8px}
    .f-col a{color:#cbd5e1;text-decoration:none;display:block;margin:6px 0}
    .f-col a:hover{color:#fff}
    .copy{border-top:1px solid rgba(255,255,255,.12);padding:10px 18px;font-size:13px;text-align:center;color:#94a3b8}
  
  
 /* ——— Vision & Mission ——— */
.vm-wrap{max-width:1200px;margin:22px auto;padding:0 18px;}
.vm-intro{
  background:#fff;border:1px solid var(--border);border-radius:14px;
  box-shadow:var(--shadow);padding:18px 18px 14px;position:relative;text-align:center;
}
.vm-intro .mark{
  position:absolute;left:12px;top:-6px;font-size:88px;line-height:1;
  color:rgba(15,23,42,.06);user-select:none;pointer-events:none;
}
.vm-intro h2{margin:0 0 8px;font-size:22px}
.vm-intro p{margin:0;color:var(--text);font-size:18px;line-height:1.7}

.vm-grid{display:grid;grid-template-columns:1fr 1fr;gap:14px;margin-top:14px}
@media (max-width: 960px){ .vm-grid{grid-template-columns:1fr} }

.vm-card{
  border:1px solid var(--border);border-radius:14px;
  box-shadow:var(--shadow);padding:16px 18px;position:relative;
  background:#fff;
}
.vm-card.vision{ background:#eef5ff; border-color:#cfe2ff; }   /* soft blue */
.vm-card.mission{ background:#fff7ed; border-color:#ffd8b5; }  /* soft amber */

.vm-card .tag{
  display:inline-block;font-weight:800;letter-spacing:.2px;
  color:#0f172a;margin:0 0 6px;font-size:14px;
}
.vm-card h3{margin:0 0 8px;font-size:20px}
.vm-card p{margin:0;color:#374151;line-height:1.75}
.vm-bullets{margin-top:10px;display:flex;gap:8px;flex-wrap:wrap}
.vm-pill{
  border:1px solid var(--border);background:#ffffffb8;border-radius:999px;
  padding:6px 10px;font-weight:700;color:#111827
}


  </style>
</head>
<body>

<!--   HEADER 
  <header class="header">
    <div class="inner">
      <a href="<%= ctx %>/index.jsp" class="brand">SmartRentalHub</a>
      <nav class="nav">
        <a href="<%= ctx %>/browseProperties">Browse</a>
        <a href="<%= ctx %>/community.jsp">Community</a>
        <a href="<%= ctx %>/about.jsp">About</a>
        <% if (user == null) { %>
          <a href="<%= ctx %>/login.jsp" class="cta">Login</a>
          <a href="<%= ctx %>/register.jsp" class="cta" style="background:#111827">Sign up</a>
        <% } else { %>
          <a href="<%= ctx %>/profile.jsp">Profile</a>
          <a href="<%= ctx %>/dashboard.jsp">Dashboard</a>
          <a href="<%= ctx %>/logout.jsp" class="cta">Logout</a>
        <% } %>
      </nav>
    </div>
  </header>-->
        
        <!-- HEADER -->
<%
  boolean isAdminUser = false;
  if (user != null && user.getRole() != null) {
    isAdminUser = "admin".equalsIgnoreCase(user.getRole());
  }
%>
<header class="header">
  <div class="inner">
    <a href="<%= ctx %>/index.jsp" class="brand">SmartRentalHub</a>
    <nav class="nav">
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


  <!-- HERO CAROUSEL -->
  <section class="hero-wrap">
    <div class="carousel" id="hero">
      <div class="slides" id="slides">
        <!-- Slide 1 -->
        <div class="slide" style="background-image:url('<%= ctx %>/assets/home/banner-1.jpg'), linear-gradient(135deg,#ffede4,#e8f0ff) ">
          <div class="hero-content">
            <div class="hero-pad">
              <h2 class="hero-title">Find your next home.</h2>
              <p class="hero-sub">Browse verified rentals across Sri Lanka.</p>
              <div class="h-actions">
                <a class="btn primary" href="<%= ctx %>/browseProperties">Start browsing</a>
                <a class="btn" href="<%= ctx %>/community.jsp">Visit community</a>
              </div>
            </div>
          </div>
        </div>
        <!-- Slide 2 -->
        <div class="slide" style="background-image:url('<%= ctx %>/assets/home/banner-2.jpg'), linear-gradient(135deg,#ffe9d9,#e9f7ef)">
          <div class="hero-content">
            <div class="hero-pad">
              <h2 class="hero-title">List with confidence.</h2>
              <p class="hero-sub">Landlords get modern tools and trusted tenants.</p>
              <div class="h-actions">
                <a class="btn primary" href="<%= ctx %>/PostPoperty.jsp">List a property</a>
                <a class="btn" href="<%= ctx %>/about.jsp">Learn more</a>
              </div>
            </div>
          </div>
        </div>
        <!-- Slide 3 -->
        <div class="slide" style="background-image:url('<%= ctx %>/assets/home/banner-3.jpg'), linear-gradient(135deg,#e6f0ff,#fff7ed)">
          <div class="hero-content">
            <div class="hero-pad">
              <h2 class="hero-title">Trust & safety built-in.</h2>
              <p class="hero-sub">Verified profiles, reporting, and moderation.</p>
              <div class="h-actions">
                <a class="btn" href="<%= ctx %>/privacy.jsp">Privacy</a>
                <a class="btn primary" href="<%= ctx %>/register.jsp">Join now</a>
              </div>
            </div>
          </div>
        </div>
      </div>

      <!-- Controls -->
      <button class="ctrl prev" id="prev" aria-label="Previous">‹</button>
      <button class="ctrl next" id="next" aria-label="Next">›</button>
      <div class="dots" id="dots">
        <span class="dot"></span><span class="dot"></span><span class="dot"></span>
      </div>
    </div>
  </section>

  <!-- PROMO TILES -->
  <div class="stripe">
    <div class="tiles">
      <div class="tile">
        <div class="i">🔍</div>
        <div>
          <h3>For Renters</h3>
          <p>Filter, save, and apply securely. No spam, no surprises.</p>
        </div>
      </div>
      <div class="tile">
        <div class="i">🏠</div>
        <div>
          <h3>For Landlords</h3>
          <p>List in minutes, screen faster, and manage bookings with ease.</p>
        </div>
      </div>
      <div class="tile">
        <div class="i">🛡️</div>
        <div>
          <h3>Trust & Safety</h3>
          <p>Verified profiles, reporting tools, and responsive moderation.</p>
        </div>
      </div>
    </div>
  </div>

  
  
<!-- Vision & Mission -->
<section class="vm-wrap" aria-labelledby="vmTitle">
  <div class="vm-intro">
    <div class="mark">“</div>
    <h2 id="vmTitle">Why SmartRentalHub</h2>
    <p>
      We’re building a trusted rental marketplace for Sri Lanka—transparent listings,
      verified users, and simple, direct phone contact between renters and landlords.
    </p>
  </div>

  <div class="vm-grid">
    <article class="vm-card vision">
      <span class="tag">VISION</span>
      <h3>A fair, transparent rental ecosystem</h3>
      <p>
        A country where every tenant can confidently find a good home and every landlord
        can manage property with clarity and respect—powered by quality information and trust.
      </p>
      <div class="vm-bullets">
        <span class="vm-pill">Transparent listings</span>
        <span class="vm-pill">Verified landlords</span>
        <span class="vm-pill">Community trust</span>
      </div>
    </article>

    <article class="vm-card mission">
      <span class="tag">MISSION</span>
      <h3>Make renting simple & local-first</h3>
      <p>
        We streamline the journey: clear details, helpful tools, and phone-first contact
        so renters and landlords can connect quickly and safely.
      </p>
      <div class="vm-bullets">
        <span class="vm-pill">Direct phone contact</span>
        <span class="vm-pill">Clear pricing</span>
        <span class="vm-pill">Local support</span>
      </div>
    </article>
  </div>
</section>

  
  
  

  <!-- GALLERY  -->
  <section class="section">
    <h2>Gallery</h2>
    <p class="lead">A peek at homes shared by our community.</p>
    <div class="gallery">
      <div class="gimg"><img src="<%= ctx %>/assets/home/gallery-1.jpg" alt=""></div>
      <div class="gimg"><img src="<%= ctx %>/assets/home/gallery-2.jpg" alt=""></div>
      <div class="gimg"><img src="<%= ctx %>/assets/home/gallery-3.jpg" alt=""></div>
      <div class="gimg"><img src="<%= ctx %>/assets/home/gallery-4.jpg" alt=""></div>
      <div class="gimg"><img src="<%= ctx %>/assets/home/gallery-5.jpg" alt=""></div>
      <div class="gimg"><img src="<%= ctx %>/assets/home/gallery-6.jpg" alt=""></div>
    </div>
  </section>

<!--   COMMUNITY HIGHLIGHTS (can remain DB-driven later) 
  <section class="section">
    <h2>From the community</h2>
    <p class="lead">Recent conversations and tips.</p>

    <div class="grid">
      <div class="card">
        <div class="title">Best areas in Colombo for students?</div>
        <div class="meta">by chamodi • 2h ago</div>
      </div>
      <div class="card">
        <div class="title">How to screen a landlord politely</div>
        <div class="meta">by de silva • 5h ago</div>
      </div>
      <div class="card">
        <div class="title">Pet-friendly places near Kandy Lake</div>
        <div class="meta">by tharindu • yesterday</div>
      </div>
    </div>

    <div style="margin-top:12px">
      <a class="btn" href="<%= ctx %>/community.jsp">Go to Community</a>
    </div>
  </section>-->

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
   
    (function(){
      const slides = document.getElementById('slides');
      const dotsWrap = document.getElementById('dots');
      const dots = Array.from(dotsWrap.children);
      const prev = document.getElementById('prev');
      const next = document.getElementById('next');

      let i = 0, n = dots.length, timer = null;

      function set(idx){
        i = (idx+n)%n;
        slides.style.transform = 'translateX(' + (-100*i) + '%)';
        dots.forEach((d,k)=>d.classList.toggle('active', k===i));
      }
      function start(){ timer = setInterval(()=>set(i+1), 5000); }
      function stop(){ if (timer) clearInterval(timer); timer = null; }

      prev.addEventListener('click', ()=>{ stop(); set(i-1); start(); });
      next.addEventListener('click', ()=>{ stop(); set(i+1); start(); });
      dots.forEach((d,k)=>d.addEventListener('click', ()=>{ stop(); set(k); start(); }));

      set(0); start();
      // pause on hover 
      document.getElementById('hero').addEventListener('mouseenter', stop);
      document.getElementById('hero').addEventListener('mouseleave', start);
    })();
    
    
  
  </script>
</body>
</html>
