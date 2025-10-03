<%@ page import="java.util.List" %>
<%@ page import="com.smart.rentalhub.model.Property" %>
<%@ page import="com.smart.rentalhub.dao.PropertyDAO" %>
<%@ page import="com.smart.rentalhub.model.User" %>

<%
    User user = (User) session.getAttribute("user");
    String ctx = request.getContextPath();
%>

<%
    List<Property> properties = (List<Property>) request.getAttribute("properties");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Browse Properties</title>
    <style>

          /* Header */
    .header{position:sticky;top:0;z-index:40;background:#fff;border-bottom:1px solid var(--border);box-shadow:0 6px 20px rgba(0,0,0,.05)}
    .header .inner{max-width:1200px;margin:0 auto;padding:12px 18px;display:flex;align-items:center;justify-content:space-between}
    .brand{display:flex;align-items:center;gap:10px;color:var(--brand);font-weight:900;font-size:22px;text-decoration:none}
    .nav{display:flex;align-items:center;gap:14px}
    .nav a{color:#374151;text-decoration:none;font-weight:600;padding:8px 10px;border-radius:10px}
    .nav a:hover{background:#f3f4f6}
    .cta{background:var(--brand);color:#fff;border-radius:999px;padding:8px 14px}
    .cta:hover{opacity:.95}
    
        :root {
            --bg: #f6f7f8;
            --card: #fff;
            --border: #e5e7eb;
            --text: #1f2937;
            --muted: #6b7280;
            --brand: #ff4500;
            --hover: #f9fafb;
            --shadow: 0 6px 20px rgba(0,0,0,.06);
        }

        * { box-sizing: border-box; }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: #f0f2f5;
            margin: 0;
            padding: 30px;
        }

        h2 {
            text-align: center;
            margin-bottom: 30px;
            font-size: 2rem;
            color: #333;
        }

        .property-container {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
            gap: 25px;
        }

        .property-card {
            background: #fff;
            border-radius: 15px;
            overflow: hidden;
            box-shadow: 0 6px 20px rgba(0, 0, 0, 0.1);
            transition: all 0.3s ease;
            display: flex;
            flex-direction: column;
        }

        .property-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 12px 25px rgba(0, 0, 0, 0.15);
        }

        .property-image img {
            width: 100%;
            height: 220px;
            object-fit: cover;
            transition: transform 0.3s ease;
        }

        .property-card:hover .property-image img {
            transform: scale(1.05);
        }

        .property-details {
            padding: 20px;
            flex-grow: 1;
            display: flex;
            flex-direction: column;
        }

        .property-title {
            font-size: 20px;
            font-weight: 700;
            color: #111;
            margin-bottom: 10px;
        }

        .property-city {
            font-size: 14px;
            color: #777;
            margin-bottom: 15px;
        }

        .property-description {
            font-size: 14px;
            color: #555;
            flex-grow: 1;
            margin-bottom: 15px;
        }

        .property-price {
            font-weight: bold;
            font-size: 16px;
            color: #fff;
            padding: 8px 12px;
            border-radius: 8px;
            background: linear-gradient(135deg, #f6a11f, #e94e1b);
            text-align: center;
            width: fit-content;
        }

        @media (max-width: 600px) {
            .property-container {
                grid-template-columns: 1fr;
            }
        }

        p {
            text-align: center;
            font-size: 1.2rem;
            color: #888;
        }
        
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            /* White base with soft orange gradient */
            background: linear-gradient(120deg, #ffffff, #fff8f0);
            margin: 0;
            padding: 30px;
        }

    
        .property-card {
            background: #fff;
            border-radius: 15px;
            overflow: hidden;
            box-shadow: 0 6px 20px rgba(230, 115, 50, 0.15); /* light orange shadow */
            transition: all 0.3s ease;
            display: flex;
            flex-direction: column;
        }

        .property-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 12px 25px rgba(230, 115, 50, 0.25); /* stronger orange shadow on hover */
        }


        
    </style>
</head>
<body>
    
    
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

    
    

        <h2 style="
        text-align: center;
        font-size: 2.5rem;
        font-weight: 700;
        color: #222;
        background: linear-gradient(90deg, #f6a11f, #e94e1b);
        -webkit-background-clip: text;
        -webkit-text-fill-color: transparent;
        margin-bottom: 30px;
        letter-spacing: 1px;
        text-transform: uppercase;
        ">
        Available Properties
    </h2>

    <div class="property-container">
        <%
            if (properties != null && !properties.isEmpty()) {
                for (Property p : properties) {
        %>
            <div class="property-card">
                <div class="property-image">
                    <img src="property-image?name=<%= p.getImage() != null ? p.getImage() : "no-image.jpg" %>" alt="Property Image">
                </div>
                <div class="property-details">
                    <div class="property-title"><%= p.getTitle() %></div>
                    <div class="property-city"><%= p.getCity() %></div>
                    <p class="property-description"><%= p.getDescription() %></p>
                    <div class="property-price">RS.<%= p.getPrice() %></div>
                </div>
            </div>
        <%
                }
            } else {
        %>
            <p>No properties found.</p>
        <%
            }
        %>
    </div>
    
    
    
    
</body>
</html>
