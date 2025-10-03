package com.smart.rentalhub.dao;

import com.smart.rentalhub.model.PrivacySettings;
import com.smart.rentalhub.util.DBConnection;

import java.sql.*;

public class SettingsDAO {

    public PrivacySettings getPrivacy(int userId) {
        String sql = "SELECT profile_visible FROM user_settings WHERE user_id=?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new PrivacySettings(
                        userId,
                        rs.getInt("profile_visible") == 1
                    );
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        // Default if no record yet
        return new PrivacySettings(userId, true);
    }

    /** Insert if missing; otherwise update. */
    public boolean upsertPrivacy(PrivacySettings s) {
        String sql = "INSERT INTO user_settings (user_id, profile_visible) " +
                     "VALUES (?, ?) " +
                     "ON DUPLICATE KEY UPDATE " +
                     "profile_visible = VALUES(profile_visible)";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, s.getUserId());
            ps.setInt(2, s.isProfileVisible() ? 1 : 0);
            return ps.executeUpdate() >= 1;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}
