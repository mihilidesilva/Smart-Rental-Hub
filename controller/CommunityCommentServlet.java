package com.smart.rentalhub.servlet;

import com.smart.rentalhub.dao.CommunityCommentDAO;
import com.smart.rentalhub.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.io.PrintWriter;

@WebServlet("/community/comment")
public class CommunityCommentServlet extends HttpServlet {
    private final CommunityCommentDAO dao = new CommunityCommentDAO();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        User u = (User) req.getSession().getAttribute("user");
        if (u == null) { resp.sendError(HttpServletResponse.SC_UNAUTHORIZED); return; }

        String postIdStr = req.getParameter("postId");
        String text = req.getParameter("text");
        if (postIdStr == null || text == null || text.isBlank()) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }

        int postId;
        try { postId = Integer.parseInt(postIdStr); }
        catch (NumberFormatException e) { resp.sendError(HttpServletResponse.SC_BAD_REQUEST); return; }

        dao.insert(postId, u.getUsername(), text.trim());

        int count = dao.countByPost(postId);

        resp.setContentType("application/json");
        try (PrintWriter out = resp.getWriter()) {
            // Return only what the client needs to update the UI
            out.printf("{\"ok\":true,\"count\":%d,\"username\":\"%s\",\"text\":\"%s\"}",
                    count,
                    escapeJson(u.getUsername()),
                    escapeJson(text.trim()));
        }
    }

    private static String escapeJson(String s) {
        return s.replace("\\", "\\\\").replace("\"", "\\\"").replace("\n", "\\n");
    }
}