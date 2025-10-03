/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.smart.rentalhub.controller;

import com.smart.rentalhub.dao.PropertyDAO;
import com.smart.rentalhub.model.Property;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;
import java.io.IOException;
import java.util.List;


public class BrowseListingsServlet extends HttpServlet {

    private PropertyDAO propertyDAO;

    @Override
    public void init() throws ServletException {
        propertyDAO = new PropertyDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String keyword = request.getParameter("keyword");
        String type = request.getParameter("type");

        try {
            List<Property> properties = propertyDAO.searchProperties(keyword, type);
            request.setAttribute("properties", properties);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Error fetching properties.");
        }

        RequestDispatcher dispatcher = request.getRequestDispatcher("browseListings.jsp");
        dispatcher.forward(request, response);
    }
}
