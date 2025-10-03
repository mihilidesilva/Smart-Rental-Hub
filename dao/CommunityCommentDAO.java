package com.smart.rentalhub.dao;

import com.smart.rentalhub.model.CommunityComment;
import com.smart.rentalhub.util.DBConnection; 

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CommunityCommentDAO {

    private Connection getConn() throws SQLException {
        return DBConnection.getConnection();
    }

    public void insert(int postId, String username, String text) {
        String sql = "INSERT INTO community_comments(post_id, username, comment) VALUES(?,?,?)";
        try (Connection c = getConn(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, postId);
            ps.setString(2, username);
            ps.setString(3, text);
            ps.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    public List<CommunityComment> listByPost(int postId, int limit) {
        String sql = "SELECT id, post_id, username, comment, created_at " +
                     "FROM community_comments WHERE post_id=? ORDER BY created_at ASC LIMIT ?";
        List<CommunityComment> list = new ArrayList<>();
        try (Connection c = getConn(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, postId);
            ps.setInt(2, limit);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    CommunityComment cc = new CommunityComment();
                    cc.setId(rs.getInt("id"));
                    cc.setPostId(rs.getInt("post_id"));
                    cc.setUsername(rs.getString("username"));
                    cc.setComment(rs.getString("comment"));
                    cc.setCreatedAt(rs.getTimestamp("created_at"));
                    list.add(cc);
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
        return list;
    }

    public int countByPost(int postId) {
        String sql = "SELECT COUNT(*) FROM community_comments WHERE post_id=?";
        try (Connection c = getConn(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, postId);
            try (ResultSet rs = ps.executeQuery()) {
                rs.next();
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }
}