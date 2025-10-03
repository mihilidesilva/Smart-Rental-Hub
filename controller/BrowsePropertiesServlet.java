package com.smart.rentalhub.controller;

import com.smart.rentalhub.dao.PropertyDAO;
import com.smart.rentalhub.model.Property;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;


@WebServlet("/browseProperties") 
public class BrowsePropertiesServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        PropertyDAO dao = new PropertyDAO();
        List<Property> properties = dao.getAllProperties();
        
        request.setAttribute("properties", properties);
        request.getRequestDispatcher("browseProperties.jsp").forward(request, response);
    }
}
