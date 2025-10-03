package com.smart.rentalhub.dao;

import com.smart.rentalhub.model.CommunityPost;
import com.smart.rentalhub.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CommunityPostDAO {

    public void insert(String username, String message, String imagePath) {
        String sql = "INSERT INTO community_posts(username, message, image_path) VALUES (?,?,?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, username);
            ps.setString(2, message);
            ps.setString(3, imagePath);
            ps.executeUpdate();

        } catch (SQLException e) {
            throw new RuntimeException("Error inserting community post", e);
        }
    }

    public List<CommunityPost> findByUsername(String username) {
        String sql =
            "SELECT id, username, message, image_path, created_at " +
            "FROM community_posts WHERE username=? ORDER BY created_at DESC";

        List<CommunityPost> list = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, username);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    CommunityPost p = new CommunityPost();
                    p.setId(rs.getInt("id"));
                    p.setUsername(rs.getString("username"));
                    p.setMessage(rs.getString("message"));
                    p.setImagePath(rs.getString("image_path"));
                    p.setCreatedAt(rs.getTimestamp("created_at"));
                    list.add(p);
                }
            }

        } catch (SQLException e) {
            throw new RuntimeException("Error fetching posts by username", e);
        }
        return list;
    }

 
    public List<CommunityPost> findAllTenantsPosts() {
        String sql =
            "SELECT p.id, p.username, p.message, p.created_at, p.image_path " +
            "FROM community_posts p " +
            "JOIN users u ON u.username = p.username " +
            "WHERE u.role = 'tenant' " +
            "ORDER BY p.created_at DESC";

        List<CommunityPost> list = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                CommunityPost p = new CommunityPost();
                p.setId(rs.getInt("id"));
                p.setUsername(rs.getString("username"));
                p.setMessage(rs.getString("message"));
                p.setCreatedAt(rs.getTimestamp("created_at"));
                p.setImagePath(rs.getString("image_path"));
                list.add(p);
            }

        } catch (SQLException e) {
            throw new RuntimeException("Error fetching tenant posts", e);
        }
        return list;
    }
}