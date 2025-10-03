package com.smart.rentalhub.controller;

import com.smart.rentalhub.model.User;
import com.smart.rentalhub.dao.UserDAO;
import com.smart.rentalhub.util.PasswordEncryptor;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {

        // Get form inputs
        String username = request.getParameter("username");
        String rawPassword = request.getParameter("password");

        
         //  Terms/Privacy agreement
        String agree = request.getParameter("agree");
        if (agree == null) {
            response.sendRedirect("login.jsp?error=terms&username=" + java.net.URLEncoder.encode(username != null ? username : "", "UTF-8"));
            return;
        }
        
        
        // Hash the password using our custom encryptor
        String hashedPassword = PasswordEncryptor.hash(rawPassword);

        System.out.println("🔐 Login attempt for username: " + username);

        // Validate user
        UserDAO dao = new UserDAO();
        User user = dao.validateUserByUsername(username, hashedPassword);

        if (user != null) {
            System.out.println("✅ Login successful for: " + user.getUsername() + " (Role: " + user.getRole() + ")");

            // Start session
            HttpSession session = request.getSession();
            session.setAttribute("user", user);
            
            // ✅ Store user_id so other servlets can use it 
              session.setAttribute("user_id", user.getId());
              
              

            // Redirect based on user role
            switch (user.getRole()) {
                case "admin":
                    response.sendRedirect("dashboard.jsp");
                    break;
                case "landlord":
                case "tenant":
                default:
                    response.sendRedirect("dashboard.jsp");
                    break;
            }
        } else {
            System.out.println("❌ Login failed for username: " + username);
            response.sendRedirect("login.jsp?error=1");
        }
    }
}
