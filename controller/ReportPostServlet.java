package com.smart.rentalhub.controller;

import com.smart.rentalhub.dao.AbuseReportDAO;
import com.smart.rentalhub.model.User;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import jakarta.servlet.ServletException;
import java.io.IOException;

@WebServlet("/community/report")
public class ReportPostServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        User me = (session != null) ? (User) session.getAttribute("user") : null;
        if (me == null) { resp.sendRedirect(req.getContextPath() + "/login.jsp"); return; }

        String postIdStr = req.getParameter("postId");
        String notes     = req.getParameter("notes");

        if (postIdStr == null || postIdStr.isBlank()) {
            resp.sendRedirect(req.getContextPath() + "/community.jsp"); return;
        }

        try {
            int postId = Integer.parseInt(postIdStr);
            new AbuseReportDAO().reportPost(postId, me.getUsername(), notes);
            session.setAttribute("flash", "Thanks — your report was sent to the admins.");
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("flash", "Could not send report. Please try again.");
        }
        resp.sendRedirect(req.getContextPath() + "/community.jsp");
    }
}