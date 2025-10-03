package com.smart.rentalhub.controller;

import com.smart.rentalhub.dao.PropertyDAO;
import com.smart.rentalhub.model.Property;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.List;

@WebServlet("/myProperties")
public class MyPropertiesServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Get landlord ID from session
        HttpSession session = request.getSession(false);
        Integer landlordId = (session != null) ? (Integer) session.getAttribute("user_id") : null;

        if (landlordId == null) {
            // User not logged in
            response.sendRedirect("login.jsp");
            return;
        }

        // Fetch properties for this landlord
        PropertyDAO dao = new PropertyDAO();
        List<Property> properties = dao.getPropertiesByLandlord(landlordId);
        
        

        // Pass to JSP
        request.setAttribute("properties", properties);
        RequestDispatcher dispatcher = request.getRequestDispatcher("myProperties.jsp");
        dispatcher.forward(request, response);
    }
}
