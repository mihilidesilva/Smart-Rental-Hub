/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.smart.rentalhub.dao;

import com.smart.rentalhub.util.DBConnection;
import java.sql.*;

public class LikeDAO {

    public boolean toggleLike(int propertyId, int userId) throws Exception {
        String checkSql = "SELECT id FROM property_likes WHERE property_id = ? AND user_id = ?";
        String insertSql = "INSERT INTO property_likes (property_id, user_id) VALUES (?, ?)";
        String deleteSql = "DELETE FROM property_likes WHERE property_id = ? AND user_id = ?";

        try (Connection conn = DBConnection.getConnection()) {
            PreparedStatement checkStmt = conn.prepareStatement(checkSql);
            checkStmt.setInt(1, propertyId);
            checkStmt.setInt(2, userId);
            ResultSet rs = checkStmt.executeQuery();

            if (rs.next()) {
                // Already liked , remove
                PreparedStatement delStmt = conn.prepareStatement(deleteSql);
                delStmt.setInt(1, propertyId);
                delStmt.setInt(2, userId);
                delStmt.executeUpdate();
                return false; 
            } else {
                // Not liked yet , add
                PreparedStatement insStmt = conn.prepareStatement(insertSql);
                insStmt.setInt(1, propertyId);
                insStmt.setInt(2, userId);
                insStmt.executeUpdate();
                return true; 
            }
        }
    }

    public int getLikeCount(int propertyId) throws Exception {
        String sql = "SELECT COUNT(*) FROM property_likes WHERE property_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, propertyId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        return 0;
    }
}
