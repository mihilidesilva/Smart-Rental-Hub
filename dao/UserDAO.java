/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.smart.rentalhub.dao;

import com.smart.rentalhub.model.User;
import com.smart.rentalhub.util.DBConnection;

import com.smart.rentalhub.util.PasswordEncryptor;
import java.sql.*;
import java.util.List;
import java.util.ArrayList;

import java.sql.SQLException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;


/**
 *
 * @author HI
 */
public class UserDAO {


    //  REGISTER USER
    public boolean registerUser(User user) {
        boolean success = false;
        try {
            Connection conn = DBConnection.getConnection();
            String sql = "INSERT INTO users (username, password, full_name, email, bio, profile_img, role) VALUES (?, ?, ?, ?, ?, ?, ?)";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, user.getUsername());
            ps.setString(2, user.getPassword()); // (Consider hashing)
            ps.setString(3, user.getFullName());
            ps.setString(4, user.getEmail());
            ps.setString(5, user.getBio());
            ps.setString(6, user.getProfileImg());
            ps.setString(7, user.getRole());
            success = ps.executeUpdate() > 0;
            conn.close();
        } catch (Exception e) {
            System.out.println("❌ Error in registerUser(): " + e.getMessage());
            e.printStackTrace();
        }
        return success;
    }

    //  LOGIN VALIDATION
   public User validateUserByUsername(String username, String password) {
    User user = null;
    try {
        Connection conn = DBConnection.getConnection();
        String sql = "SELECT * FROM users WHERE username = ? AND password = ?";
        PreparedStatement ps = conn.prepareStatement(sql);
        ps.setString(1, username);
        ps.setString(2, password);
        ResultSet rs = ps.executeQuery();
        if (rs.next()) {
            user = new User();
            user.setId(rs.getInt("id"));
            user.setUsername(rs.getString("username"));
            user.setFullName(rs.getString("full_name"));
            user.setEmail(rs.getString("email"));
            user.setBio(rs.getString("bio"));
            user.setProfileImg(rs.getString("profile_img"));
            user.setRole(rs.getString("role"));
        }
        conn.close();
    } catch (Exception e) {
        System.out.println("❌ Error in validateUserByUsername(): " + e.getMessage());
        e.printStackTrace();
    }
    
    
    return user;
}

   // In,, src/java/com/smart/rentalhub/dao/UserDAO.java
public boolean updateUserProfile(int userId, String fullName, String bio, String profileImgFileName) {
    String sql = "UPDATE users SET full_name = ?, bio = ?, profile_img = ? WHERE id = ?";
    try (java.sql.Connection conn = com.smart.rentalhub.util.DBConnection.getConnection();
         java.sql.PreparedStatement ps = conn.prepareStatement(sql)) {

        ps.setString(1, fullName);                      
        ps.setString(2, bio);                          
        ps.setString(3, profileImgFileName);         
        ps.setInt(4, userId);

        int rows = ps.executeUpdate();
        System.out.println("ℹ️ updateUserProfile rows=" + rows + " for userId=" + userId);
        return rows > 0;

    } catch (Exception e) {
        System.out.println("❌ updateUserProfile error: " + e.getMessage());
        e.printStackTrace();
        return false;
    }
}




public String getCoverImage(int userId) {
    String sql = "SELECT cover_img FROM user_covers WHERE user_id=?";
    try (var conn = DBConnection.getConnection();
         var ps = conn.prepareStatement(sql)) {
        ps.setInt(1, userId);
        try (var rs = ps.executeQuery()) {
            if (rs.next()) return rs.getString(1);
        }
    } catch (Exception e) { e.printStackTrace(); }
    return null;
}

public boolean upsertCoverImage(int userId, String fileName) {
    String sql = """
        INSERT INTO user_covers (user_id, cover_img)
        VALUES (?, ?)
        ON DUPLICATE KEY UPDATE cover_img=VALUES(cover_img)
    """;
    try (var conn = DBConnection.getConnection();
         var ps = conn.prepareStatement(sql)) {
        ps.setInt(1, userId);
        ps.setString(2, fileName);
        return ps.executeUpdate() > 0;
    } catch (Exception e) { e.printStackTrace(); }
    return false;
}


// --- Update email ---
    public boolean updateEmail(int userId, String email) {
        String sql = "UPDATE users SET email = ? WHERE id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, email);
            ps.setInt(2, userId);
            return ps.executeUpdate() == 1;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // --- Change password (verify old, then store new hash) ---
    public boolean changePassword(int userId, String oldPlain, String newPlain) {
        String get = "SELECT password FROM users WHERE id = ?";
        String upd = "UPDATE users SET password = ? WHERE id = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement g = con.prepareStatement(get)) {

            g.setInt(1, userId);
            try (ResultSet rs = g.executeQuery()) {
                if (!rs.next()) return false;

                String currentHash = rs.getString(1);
                if (currentHash == null) return false;

                // verify old password
                boolean ok = PasswordEncryptor.check(oldPlain, currentHash);
                if (!ok) return false;
            }

            String newHash = PasswordEncryptor.hash(newPlain);

            try (PreparedStatement u = con.prepareStatement(upd)) {
                u.setString(1, newHash);
                u.setInt(2, userId);
                return u.executeUpdate() == 1;
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
   
    
    
    //SEARCH USER PROFIles
   
public User findByUsername(String username) {
    if (username == null) return null;
    String sql = "SELECT id, username, password, full_name, email, bio, profile_img, role " +
                 "FROM users WHERE username = TRIM(?)";
    try (Connection con = DBConnection.getConnection();
         PreparedStatement ps = con.prepareStatement(sql)) {
        ps.setString(1, username);
        try (ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                User u = new User();
                u.setId(rs.getInt("id"));
                u.setUsername(rs.getString("username"));
                u.setPassword(rs.getString("password"));
                u.setFullName(rs.getString("full_name"));
                u.setEmail(rs.getString("email"));
                u.setBio(rs.getString("bio"));
                u.setProfileImg(rs.getString("profile_img"));
                u.setRole(rs.getString("role"));
                return u;
            }
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
    return null;
}

public User findById(int id) {
    String sql = "SELECT id, username, password, full_name, email, bio, profile_img, role FROM users WHERE id=?";
    try (Connection con = DBConnection.getConnection();
         PreparedStatement ps = con.prepareStatement(sql)) {
        ps.setInt(1, id);
        try (ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                User u = new User();
                u.setId(rs.getInt("id"));
                u.setUsername(rs.getString("username"));
                u.setPassword(rs.getString("password"));
                u.setFullName(rs.getString("full_name"));
                u.setEmail(rs.getString("email"));
                u.setBio(rs.getString("bio"));
                u.setProfileImg(rs.getString("profile_img"));
                u.setRole(rs.getString("role"));
                return u;
            }
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
    return null;
}

public List<User> searchUsers(String query, int limit, int offset) {
    List<User> list = new ArrayList<>();

    
    String sql =
        "SELECT id, username, full_name, email, bio, profile_img, role " +
        "FROM users " +
        "WHERE username LIKE ? OR full_name LIKE ? " +
        "ORDER BY username " +
        "LIMIT ? OFFSET ?";

    // MySQL option B (older / universal): LIMIT offset, limit
    // String sql =
    //     "SELECT id, username, full_name, email, bio, profile_img, role " +
    //     "FROM users " +
    //     "WHERE username LIKE ? OR full_name LIKE ? " +
    //     "ORDER BY username " +
    //     "LIMIT ?, ?";

    try (Connection con = DBConnection.getConnection();
         PreparedStatement ps = con.prepareStatement(sql)) {

        String like = "%" + (query == null ? "" : query.trim()) + "%";

        ps.setString(1, like);
        ps.setString(2, like);

        ps.setInt(3, Math.max(1, limit));
        ps.setInt(4, Math.max(0, offset));

  

        try (ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                User u = new User();
                u.setId(rs.getInt("id"));
                u.setUsername(rs.getString("username"));
                u.setFullName(rs.getString("full_name"));
                u.setEmail(rs.getString("email"));
                u.setBio(rs.getString("bio"));
                u.setProfileImg(rs.getString("profile_img"));
                u.setRole(rs.getString("role"));
                list.add(u);
            }
        }
    } catch (SQLException e) {
        e.printStackTrace(); 
    }
    return list;
}

public List<User> searchUsersByNameOrUsername(String q) {
    List<User> out = new ArrayList<>();
    if (q == null || q.trim().isEmpty()) return out;

    String like = "%" + q.trim().toLowerCase() + "%";

    String sql =
        "SELECT id, username, full_name, email, bio, profile_img, role " +
        "FROM users " +
        "WHERE LOWER(username) LIKE ? OR LOWER(full_name) LIKE ? " +
        "ORDER BY username LIMIT 25";

    try (Connection con = DBConnection.getConnection();
         PreparedStatement ps = con.prepareStatement(sql)) {

        ps.setString(1, like);
        ps.setString(2, like);

        try (ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                User u = new User();
                u.setId(rs.getInt("id"));
                u.setUsername(rs.getString("username"));
                u.setFullName(rs.getString("full_name"));
                u.setEmail(rs.getString("email"));
                u.setBio(rs.getString("bio"));
                u.setProfileImg(rs.getString("profile_img"));
                u.setRole(rs.getString("role"));
                out.add(u);
            }
        }
    } catch (SQLException e) {
        e.printStackTrace();
    }
    return out;
}



// Verify a user's current password 
public boolean checkPassword(int userId, String plain) {
    String sql = "SELECT password FROM users WHERE id = ?";
    try (java.sql.Connection con = com.smart.rentalhub.util.DBConnection.getConnection();
         java.sql.PreparedStatement ps = con.prepareStatement(sql)) {
        ps.setInt(1, userId);
        try (java.sql.ResultSet rs = ps.executeQuery()) {
            if (!rs.next()) return false;
            String hash = rs.getString(1);
            return com.smart.rentalhub.util.PasswordEncryptor.check(plain, hash);
        }
    } catch (Exception e) {
        e.printStackTrace();
        return false;
    }
}


 // Permanently delete a user account.


public boolean deleteAccount(int userId) {
    String sql = "DELETE FROM users WHERE id = ?";
    try (java.sql.Connection con = com.smart.rentalhub.util.DBConnection.getConnection();
         java.sql.PreparedStatement ps = con.prepareStatement(sql)) {
        ps.setInt(1, userId);
        int rows = ps.executeUpdate();
        return rows == 1;
    } catch (Exception e) {
        e.printStackTrace();
        return false;
    }
}


}