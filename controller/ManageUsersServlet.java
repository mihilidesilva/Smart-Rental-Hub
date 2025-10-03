package com.smart.rentalhub.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

import com.smart.rentalhub.model.User;
import com.smart.rentalhub.util.DBConnection;

@WebServlet("/manageUsers")
public class ManageUsersServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        User me = (session != null) ? (User) session.getAttribute("user") : null;
        if (me == null || me.getRole() == null || !"admin".equalsIgnoreCase(me.getRole())) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        List<User> users = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(
                     "SELECT id, username, full_name, email, role FROM users ORDER BY id DESC");
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                User u = new User();
                u.setId(rs.getInt("id"));
                u.setUsername(rs.getString("username"));
                u.setFullName(rs.getString("full_name"));
                u.setEmail(rs.getString("email"));
                u.setRole(rs.getString("role"));
                users.add(u);
            }

        } catch (Exception e) {
            throw new ServletException("Error fetching users", e);
        }

        req.setAttribute("users", users);
        req.getRequestDispatcher("/manageUsers.jsp").forward(req, resp);
    }
}