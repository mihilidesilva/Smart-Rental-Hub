package com.smart.rentalhub.dao;

import com.smart.rentalhub.util.DBConnection; 
import java.sql.*;

public class CommunityLikeDAO {

    private Connection getConn() throws SQLException {
        return DBConnection.getConnection(); 
    }

    public boolean hasUserLiked(int postId, String username) {
        String sql = "SELECT 1 FROM community_post_likes WHERE post_id=? AND username=? LIMIT 1";
        try (Connection c = getConn();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, postId);
            ps.setString(2, username);
            try (ResultSet rs = ps.executeQuery()) { return rs.next(); }
        } catch (SQLException e) { throw new RuntimeException(e); }
    }

    public int countLikes(int postId) {
        String sql = "SELECT COUNT(*) FROM community_post_likes WHERE post_id=?";
        try (Connection c = getConn();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, postId);
            try (ResultSet rs = ps.executeQuery()) { rs.next(); return rs.getInt(1); }
        } catch (SQLException e) { throw new RuntimeException(e); }
    }

    public void like(int postId, String username) {
        String sql = "INSERT IGNORE INTO community_post_likes (post_id, username) VALUES(?,?)";
        try (Connection c = getConn();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, postId);
            ps.setString(2, username);
            ps.executeUpdate();
        } catch (SQLException e) { throw new RuntimeException(e); }
    }

    public void unlike(int postId, String username) {
        String sql = "DELETE FROM community_post_likes WHERE post_id=? AND username=?";
        try (Connection c = getConn();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, postId);
            ps.setString(2, username);
            ps.executeUpdate();
        } catch (SQLException e) { throw new RuntimeException(e); }
    }
}