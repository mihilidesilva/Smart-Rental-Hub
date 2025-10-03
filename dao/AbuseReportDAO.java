package com.smart.rentalhub.dao;

import com.smart.rentalhub.util.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class AbuseReportDAO {

    private Connection getConn() throws SQLException {
        return DBConnection.getConnection(); 
    }

    //  create table if missing
    private void ensureTable(Connection c) throws SQLException {
        try (Statement st = c.createStatement()) {
            st.executeUpdate(
              "CREATE TABLE IF NOT EXISTS abuse_reports (" +
              " id INT AUTO_INCREMENT PRIMARY KEY," +
              " target_type ENUM('user','property','post') NOT NULL," +
              " target_id INT NOT NULL," +
              " reporter VARCHAR(50) NOT NULL," +
              " notes TEXT NULL," +
              " created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP," +
              " UNIQUE KEY uq_once_per_post (target_type, target_id, reporter)" +
              ")"
            );
        }
    }

    /** Any user can report a post . */
    public void reportPost(int postId, String reporter, String notes) {
        String sql = "INSERT IGNORE INTO abuse_reports(target_type, target_id, reporter, notes) " +
                     "VALUES ('post', ?, ?, ?)";
        try (Connection c = getConn();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ensureTable(c);
            ps.setInt(1, postId);
            ps.setString(2, reporter);
            ps.setString(3, (notes == null ? null : notes.trim()));
            ps.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    // Row model for admin list
    public static class PostReportRow {
        public int reportId, postId;
        public String reporter, notes, username, message;
        public Timestamp reportedAt;
    }

    public List<PostReportRow> listPostReports() {
        String q = "SELECT r.id, r.target_id AS post_id, r.reporter, r.notes, r.created_at, " +
                   "       p.username, p.message " +
                   "FROM abuse_reports r JOIN community_posts p ON p.id=r.target_id " +
                   "WHERE r.target_type='post' ORDER BY r.created_at DESC";
        List<PostReportRow> out = new ArrayList<>();
        try (Connection c = getConn();
             PreparedStatement ps = c.prepareStatement(q);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                PostReportRow r = new PostReportRow();
                r.reportId   = rs.getInt("id");
                r.postId     = rs.getInt("post_id");
                r.reporter   = rs.getString("reporter");
                r.notes      = rs.getString("notes");
                r.username   = rs.getString("username");
                r.message    = rs.getString("message");
                r.reportedAt = rs.getTimestamp("created_at");
                out.add(r);
            }
        } catch (SQLException e) { throw new RuntimeException(e); }
        return out;
    }
}