package com.smart.rentalhub.controller;

import com.smart.rentalhub.dao.PropertyDAO;
import com.smart.rentalhub.model.Property;
import com.smart.rentalhub.model.User;
import java.io.File;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;


public class PropertyDeleteServlet extends HttpServlet {

    private static final String UPLOAD_DIR = "D:/smartrentalhub_uploads/properties"; // same as PostPropertyServlet

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        //  Check if user is logged in
        User user = (User) request.getSession().getAttribute("user");
        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        int landlordId = user.getId();
        int propertyId = Integer.parseInt(request.getParameter("property_id"));

        PropertyDAO propertyDAO = new PropertyDAO();

        try {
            //  Fetch property to verify ownership & get image name
            Property property = propertyDAO.getPropertyById(propertyId);
            if (property == null) {
                request.getSession().setAttribute("message", "❌ Property not found.");
                response.sendRedirect("DeleteProperty.jsp");
                return;
            }

            if (property.getLandlord_id() != landlordId) {
                request.getSession().setAttribute("message", "❌ You are not authorized to delete this property.");
                response.sendRedirect("DeleteProperty.jsp");
                return;
            }

            // Delete property from DB
            boolean deleted = propertyDAO.deleteProperty(propertyId);

            if (deleted) {
                // Delete image from disk if exists
                if (property.getImage() != null && !property.getImage().trim().isEmpty()) {
                    File imageFile = new File(UPLOAD_DIR + File.separator + property.getImage());
                    if (imageFile.exists()) {
                        imageFile.delete();
                    }
                }

                request.getSession().setAttribute("message", "✅ Property deleted successfully!");
            } else {
                request.getSession().setAttribute("message", "❌ Failed to delete property.");
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("message", "❌ Error occurred while deleting property.");
        }

        response.sendRedirect("DeleteProperty.jsp");
    }
}
