package com.smart.rentalhub.controller;

import com.smart.rentalhub.dao.SettingsDAO;
import com.smart.rentalhub.dao.UserDAO;
import com.smart.rentalhub.dao.CommunityPostDAO;
import com.smart.rentalhub.model.PrivacySettings;
import com.smart.rentalhub.model.User;
import com.smart.rentalhub.model.CommunityPost;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;
import java.util.Collections;

@WebServlet("/user")
public class PublicProfileServlet extends HttpServlet {
  @Override
  protected void doGet(HttpServletRequest request, HttpServletResponse response)
      throws ServletException, IOException {

    HttpSession session = request.getSession(false);
    User viewer = (session != null) ? (User) session.getAttribute("user") : null;
    if (viewer == null) {
      response.sendRedirect(request.getContextPath() + "/login.jsp");
      return;
    }

    String username = request.getParameter("username");
    if (username == null || username.isBlank()) {
      response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing username");
      return;
    }

    UserDAO userDao = new UserDAO();
    User target = userDao.findByUsername(username);
    if (target == null) {
      response.sendError(HttpServletResponse.SC_NOT_FOUND, "User not found");
      return;
    }

    // Privacy gate
    SettingsDAO settingsDao = new SettingsDAO();
    PrivacySettings ps = settingsDao.getPrivacy(target.getId()); // may be null
    boolean isAdmin = viewer.getRole() != null && "admin".equalsIgnoreCase(viewer.getRole());
    boolean isSelf  = target.getId() == viewer.getId();
    boolean canView = (ps == null) || ps.isProfileVisible() || isSelf || isAdmin;

    // If visible,,,,, load that user's public posts 
    List<CommunityPost> posts;
    if (canView) {
      CommunityPostDAO cdao = new CommunityPostDAO();
      posts = cdao.findByUsername(target.getUsername());
    } else {
      posts = Collections.emptyList();
    }

    request.setAttribute("target", target);
    request.setAttribute("ps", ps);
    request.setAttribute("canView", Boolean.valueOf(canView));
    request.setAttribute("posts", posts);

    // Always forward to a  JSP that handles both public/private states
    request.getRequestDispatcher("/user.jsp").forward(request, response);
  }
}
