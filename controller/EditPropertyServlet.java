/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.smart.rentalhub.controller;

import com.smart.rentalhub.dao.PropertyDAO;
import com.smart.rentalhub.model.Property;
import com.smart.rentalhub.model.User;
import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

@WebServlet("/editProperty")
@MultipartConfig
public class EditPropertyServlet extends HttpServlet {

    private static final String UPLOAD_DIR = "D:/smartrentalhub_uploads/properties";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        User user = (User) request.getSession().getAttribute("user");
        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        try {
            int id = Integer.parseInt(request.getParameter("id"));
            String title = request.getParameter("title");
            String description = request.getParameter("description");
            String city = request.getParameter("city");
            double price = Double.parseDouble(request.getParameter("price"));
            String propertyType = request.getParameter("property_type");
            boolean availability = Boolean.parseBoolean(request.getParameter("availability"));

            Part imagePart = request.getPart("image");

            PropertyDAO dao = new PropertyDAO();
            Property property = dao.getPropertyById(id);
            
            if (property == null) {
                request.setAttribute("error", "Property not found");
                request.getRequestDispatcher("EditProperty.jsp").forward(request, response);
                return;
            }

    

        
            property.setTitle(title);
            property.setDescription(description);
            property.setCity(city);
            property.setPrice(price);
            property.setProperty_type(propertyType);
            property.setAvailability(availability);


            // Pass imagePart and UPLOAD_DIR to DAO, it will handle saving image and updating image name
        boolean updated = dao.updateProperty(property, imagePart, UPLOAD_DIR);

        if (updated) {
            request.setAttribute("success", "✅ Property updated successfully!");
            // Reload updated property to show fresh data
            Property updatedProperty = dao.getPropertyById(id);
            request.setAttribute("property", updatedProperty);
            request.getRequestDispatcher("EditProperty.jsp").forward(request, response);
        } else {
            request.setAttribute("error", "Failed to update property");
            request.getRequestDispatcher("EditProperty.jsp").forward(request, response);
        }



              


        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error: " + e.getMessage());
            request.getRequestDispatcher("EditProperty.jsp").forward(request, response);
        }



        
    }
}
