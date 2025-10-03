package com.smart.rentalhub.controller;

import com.smart.rentalhub.model.User;
import com.smart.rentalhub.util.DBConnection;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import jakarta.servlet.ServletException;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

@WebServlet("/admin/deleteUser")
public class DeleteUserServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        
        // Check admin privilege
        User me = (User) req.getSession().getAttribute("user");
        if (me == null || me.getRole() == null || !"admin".equalsIgnoreCase(me.getRole())) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        String id = req.getParameter("userId");
        if (id == null || id.isBlank()) {
            resp.sendRedirect(req.getContextPath() + "/manageUsers");
            return;
        }

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement("DELETE FROM users WHERE id = ?")) {

            ps.setInt(1, Integer.parseInt(id));
            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();  
        }

        resp.sendRedirect(req.getContextPath() + "/manageUsers");
    }
}