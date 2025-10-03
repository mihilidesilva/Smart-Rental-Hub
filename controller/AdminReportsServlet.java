package com.smart.rentalhub.controller;

import com.smart.rentalhub.model.User;
import com.smart.rentalhub.dao.AbuseReportDAO;
import com.smart.rentalhub.dao.AbuseReportDAO.PostReportRow;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import jakarta.servlet.ServletException;
import java.io.IOException;
import java.util.List;

@WebServlet("/admin/reports")
public class AdminReportsServlet extends HttpServlet {
  @Override
  protected void doGet(HttpServletRequest req, HttpServletResponse resp)
      throws ServletException, IOException {

    HttpSession s = req.getSession(false);
    User me = (s != null) ? (User) s.getAttribute("user") : null;
    if (me == null || me.getRole() == null || !"admin".equalsIgnoreCase(me.getRole())) {
      resp.sendRedirect(req.getContextPath() + "/login.jsp"); return;
    }

    List<PostReportRow> reports = new AbuseReportDAO().listPostReports();
    req.setAttribute("reports", reports);
    req.getRequestDispatcher("/adminReports.jsp").forward(req, resp);
  }
}