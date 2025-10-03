package com.smart.rentalhub.controller;

import com.smart.rentalhub.model.User;
import com.smart.rentalhub.util.DBConnection;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import jakarta.servlet.ServletException;
import java.io.IOException;
import java.sql.*;

@WebServlet("/admin/deletePost")
public class DeletePostServlet extends HttpServlet {
  @Override
  protected void doPost(HttpServletRequest req, HttpServletResponse resp)
      throws ServletException, IOException {

    User me = (User) req.getSession().getAttribute("user");
    if (me == null || me.getRole() == null || !"admin".equalsIgnoreCase(me.getRole())) {
      resp.sendRedirect(req.getContextPath() + "/login.jsp"); return;
    }

    String id = req.getParameter("postId");
    if (id == null || id.isBlank()) { resp.sendRedirect(req.getContextPath() + "/admin/reports"); return; }

    try (Connection c = DBConnection.getConnection();
         PreparedStatement ps = c.prepareStatement("DELETE FROM community_posts WHERE id=?")) {
      ps.setInt(1, Integer.parseInt(id));
      ps.executeUpdate();
    } catch (Exception e) { e.printStackTrace(); }

    // clear remaining reports for this post
    try (Connection c = DBConnection.getConnection();
         PreparedStatement ps = c.prepareStatement(
             "DELETE FROM abuse_reports WHERE target_type='post' AND target_id=?")) {
      ps.setInt(1, Integer.parseInt(id));
      ps.executeUpdate();
    } catch (Exception e) { e.printStackTrace(); }

    resp.sendRedirect(req.getContextPath() + "/admin/reports");
  }
}