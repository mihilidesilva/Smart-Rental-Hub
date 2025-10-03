package com.smart.rentalhub.controller;

import com.smart.rentalhub.model.User;
import com.smart.rentalhub.dao.UserDAO;
import com.smart.rentalhub.dao.SettingsDAO;
import com.smart.rentalhub.model.PrivacySettings;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/search")
public class SearchServlet extends HttpServlet {

  @Override
  protected void doGet(HttpServletRequest request, HttpServletResponse response)
      throws ServletException, IOException {

    request.setCharacterEncoding("UTF-8");
    response.setCharacterEncoding("UTF-8");

    HttpSession session = request.getSession(false);
    User viewer = (session != null) ? (User) session.getAttribute("user") : null;
    if (viewer == null) {
      response.sendRedirect(request.getContextPath() + "/login.jsp");
      return;
    }

    String q = request.getParameter("q");
    if (q == null) q = "";
    q = q.trim();
    if (q.length() > 100) q = q.substring(0, 100); // keep inputs sane

    if (q.isEmpty()) {
      request.setAttribute("query", "");
      request.setAttribute("results", List.of());
      request.getRequestDispatcher("/WEB-INF/views/search.jsp").forward(request, response);
      return;
    }

    UserDAO userDao = new UserDAO();
    SettingsDAO settingsDao = new SettingsDAO();

    List<User> matches = new ArrayList<>();
    try {
      matches = userDao.searchUsersByNameOrUsername(q);
    } catch (Exception e) {
      e.printStackTrace();
    }

    boolean viewerIsAdmin = viewer.getRole() != null
        && "admin".equalsIgnoreCase(viewer.getRole());

    List<Map<String, Object>> results = new ArrayList<>();
    for (User u : matches) {
      try {
        PrivacySettings ps = settingsDao.getPrivacy(u.getId());
        boolean isSelf = u.getId() == viewer.getId();
        boolean canView = (ps == null) || ps.isProfileVisible() || isSelf || viewerIsAdmin;

        Map<String, Object> row = new HashMap<>();
        row.put("user", u);
        row.put("canView", Boolean.valueOf(canView));
        results.add(row);
      } catch (Exception e) {
        e.printStackTrace();
      }
    }

    request.setAttribute("query", q);
    request.setAttribute("results", results);
   request.getRequestDispatcher("/search.jsp").forward(request, response);


  }

  @Override
  protected void doPost(HttpServletRequest request, HttpServletResponse response)
      throws ServletException, IOException {
    doGet(request, response);
  }
}
