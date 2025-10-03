/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.smart.rentalhub.dao;

import com.smart.rentalhub.model.Property;
import com.smart.rentalhub.util.DBConnection;
import jakarta.servlet.http.Part;
import java.io.File;
import java.io.FileOutputStream;
import java.io.InputStream;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class PropertyDAO {

    // insert new property to the database
    public void addProperty(Property property) throws Exception {
        String sql = "INSERT INTO properties (landlord_id, title, description, city, price, property_type, image, availability) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, property.getLandlord_id());
            stmt.setString(2, property.getTitle());
            stmt.setString(3, property.getDescription());
            stmt.setString(4, property.getCity());
            stmt.setDouble(5, property.getPrice());
            stmt.setString(6, property.getProperty_type());
            stmt.setString(7, property.getImage());
            stmt.setBoolean(8, property.isAvailability());

            stmt.executeUpdate();
        }
    }


   
    // Search properties with filters 
    public List<Property> searchProperties(String keyword, String propertyType) throws Exception {
        List<Property> list = new ArrayList<>();

        StringBuilder sql = new StringBuilder("SELECT * FROM properties WHERE availability = TRUE");
        List<Object> params = new ArrayList<>();

        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append(" AND city LIKE ?");
            params.add("%" + keyword.trim() + "%");
        }
        if (propertyType != null && !propertyType.trim().isEmpty()) {
            sql.append(" AND property_type = ?");
            params.add(propertyType.trim());
        }

        sql.append(" ORDER BY created_at DESC");

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql.toString())) {

            for (int i = 0; i < params.size(); i++) {
                stmt.setObject(i + 1, params.get(i));
            }

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Property p = new Property();
                    p.setId(rs.getInt("id"));
                    p.setLandlord_id(rs.getInt("landlord_id"));
                    p.setTitle(rs.getString("title"));
                    p.setDescription(rs.getString("description"));
                    p.setCity(rs.getString("city"));
                    p.setPrice(rs.getDouble("price"));
                    p.setProperty_type(rs.getString("property_type"));
                    p.setImage(rs.getString("image"));
                    p.setAvailability(rs.getBoolean("availability"));
                    list.add(p);
                }
            }
        }

        return list;
    }
    
     // Fetch property by ID
    public Property getPropertyById(int id) throws Exception {
        Property property = null;
        String sql = "SELECT * FROM properties WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                property = new Property();
                property.setId(rs.getInt("id"));
                property.setLandlord_id(rs.getInt("landlord_id"));
                property.setTitle(rs.getString("title"));
                property.setDescription(rs.getString("description"));
                property.setCity(rs.getString("city"));
                property.setPrice(rs.getDouble("price"));
                property.setProperty_type(rs.getString("property_type"));
                property.setImage(rs.getString("image"));
                property.setAvailability(rs.getBoolean("availability"));
                
            }
        }
        return property;
    }

    // Update property with optional image upload
    public boolean updateProperty(Property property, Part imagePart, String uploadDir) throws Exception {
        
        // If new image uploaded, save file and update image name
        String newImageName = null;
        if (imagePart != null && imagePart.getSize() > 0) {
            String submittedFileName = getFileName(imagePart);
            if (submittedFileName != null && !submittedFileName.isEmpty()) {
                
                // Create unique filename
                newImageName = System.currentTimeMillis() + "_" + submittedFileName;
                File uploads = new File(uploadDir);
                if (!uploads.exists()) {
                    uploads.mkdirs();
                }
                File file = new File(uploads, newImageName);
                try (InputStream input = imagePart.getInputStream();
                     FileOutputStream fos = new FileOutputStream(file)) {
                    byte[] buffer = new byte[1024];
                    int bytesRead;
                    while ((bytesRead = input.read(buffer)) != -1) {
                        fos.write(buffer, 0, bytesRead);
                    }
                }
                property.setImage(newImageName); // update image field in property object
            }
        }

        String sql = "UPDATE properties SET title=?, description=?, city=?, price=?, property_type=?, availability=?, image=? WHERE id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, property.getTitle());
            stmt.setString(2, property.getDescription());
            stmt.setString(3, property.getCity());
            stmt.setDouble(4, property.getPrice());
            stmt.setString(5, property.getProperty_type());
            stmt.setBoolean(6, property.isAvailability());
            // If new image uploaded use it, else keep old image
            stmt.setString(7, property.getImage());
            stmt.setInt(8, property.getId());

            int updatedRows = stmt.executeUpdate();
            return updatedRows > 0;
        }
    }

    // Helper method to extract filename from Part header
    private String getFileName(Part part) {
        for (String cd : part.getHeader("content-disposition").split(";")) {
            if (cd.trim().startsWith("filename")) {
                String fileName = cd.substring(cd.indexOf('=') + 1).trim().replace("\"", "");
                return fileName.substring(fileName.lastIndexOf(File.separator) + 1);
            }
        }
        return null;
        
        
        
    }
    

    // Delete property by ID
    public boolean deleteProperty(int id) throws Exception {
        String sql = "DELETE FROM properties WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
        }
    }
    
    
    
    
     public List<Property> getPropertiesByLandlord(int landlord_id) {
        List<Property> properties = new ArrayList<>();
        String sql = "SELECT * FROM properties WHERE landlord_id=?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, landlord_id);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Property p = new Property();
                p.setId(rs.getInt("id"));
                p.setLandlord_id(rs.getInt("landlord_id"));
                p.setTitle(rs.getString("title"));
                p.setDescription(rs.getString("description"));
                p.setCity(rs.getString("city"));
                p.setPrice(rs.getDouble("price"));
                p.setProperty_type(rs.getString("property_type"));
                p.setImage(rs.getString("image"));
                p.setAvailability(rs.getBoolean("availability"));
                properties.add(p);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return properties;
    }
     
     
     
     public List<Property> getAllProperties() {
        List<Property> properties = new ArrayList<>();

        try (Connection conn = DBConnection.getConnection()) {
            String sql = "SELECT * FROM properties";
            PreparedStatement stmt = conn.prepareStatement(sql);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Property p = new Property();
                p.setId(rs.getInt("id"));
                p.setLandlord_id(rs.getInt("landlord_id"));
                p.setTitle(rs.getString("title"));
                p.setDescription(rs.getString("description"));
                p.setCity(rs.getString("city"));
                p.setPrice(rs.getDouble("price"));
                p.setProperty_type(rs.getString("property_type"));
                p.setImage(rs.getString("image"));
                p.setAvailability(rs.getBoolean("availability"));
                p.setCreatedAt(rs.getTimestamp("created_at"));
                properties.add(p);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return properties;
    }


    
    
    
}
