package com.smart.rentalhub.controller;

import com.smart.rentalhub.dao.PropertyDAO;
import com.smart.rentalhub.model.Property;
import com.smart.rentalhub.model.User; 
import java.io.IOException;
import java.io.File;
import java.nio.file.Paths;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;


@MultipartConfig
public class PostPropertyServlet extends HttpServlet {

    //  Persistent upload folder outside the webapp
    private static final String UPLOAD_DIR = "D:/smartrentalhub_uploads/properties"; 

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        //  Get logged-in user
        User user = (User) request.getSession().getAttribute("user");
        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        int landlord_id = user.getId();
        String title = request.getParameter("title");
        String description = request.getParameter("description");
        String city = request.getParameter("city");
        double price = Double.parseDouble(request.getParameter("price"));
        String property_type = request.getParameter("property_type");

        //  Handle image upload
        Part filePart = request.getPart("image");
        String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();

        // Create directory if it doesn't exist
        File uploadDir = new File(UPLOAD_DIR);
        if (!uploadDir.exists()) {
            uploadDir.mkdirs();
        }

        //  Save file to external folder
        String filePath = UPLOAD_DIR + File.separator + fileName;
        filePart.write(filePath);

    
        Property property = new Property();
        property.setLandlord_id(landlord_id);
        property.setTitle(title);
        property.setDescription(description);
        property.setCity(city);
        property.setPrice(price);
        property.setProperty_type(property_type);
        property.setImage(fileName); 
        property.setAvailability(true);

        try {
            new PropertyDAO().addProperty(property);

            request.getSession().setAttribute("message", "✅ Property posted successfully!");
            response.sendRedirect("PostPoperty.jsp");

        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("message", "❌ Unable to add property. Please try again.");
            response.sendRedirect("PostPoperty.jsp");
        }
    }
}

