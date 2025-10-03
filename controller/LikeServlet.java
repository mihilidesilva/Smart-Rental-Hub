/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.smart.rentalhub.controller;

import com.smart.rentalhub.dao.LikeDAO;
import com.smart.rentalhub.model.User;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import jakarta.servlet.*;

import java.io.IOException;

@WebServlet("/likeProperty")
public class LikeServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        
        User user = (User) req.getSession().getAttribute("user");
        if (user == null) {
            resp.sendRedirect("login.jsp");
            return;
        }

        int propertyId = Integer.parseInt(req.getParameter("propertyId"));

    
        try {
            boolean liked = new LikeDAO().toggleLike(propertyId, user.getId());
            System.out.println("Liked status: " + liked);
            
            
            // Redirect with a success message
            resp.sendRedirect("browseListings.jsp?liked=" + liked);
        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect("browseListings.jsp?error=like_failed");
        }
    }
}
