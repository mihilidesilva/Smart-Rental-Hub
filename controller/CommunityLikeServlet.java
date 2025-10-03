package com.smart.rentalhub.servlet;

import com.smart.rentalhub.dao.CommunityLikeDAO;
import com.smart.rentalhub.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.PrintWriter;


@WebServlet("/community/like")
public class CommunityLikeServlet extends HttpServlet {
    private final CommunityLikeDAO dao = new CommunityLikeDAO();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // must be logged in
        User u = (User) req.getSession().getAttribute("user");
        if (u == null) { resp.sendError(HttpServletResponse.SC_UNAUTHORIZED); return; }

        // parse postId safely
        String idStr = req.getParameter("postId");
        if (idStr == null || idStr.isBlank()) { resp.sendError(HttpServletResponse.SC_BAD_REQUEST); return; }

        int postId;
        try { postId = Integer.parseInt(idStr); }
        catch (NumberFormatException e) { resp.sendError(HttpServletResponse.SC_BAD_REQUEST); return; }

        // toggle like
        boolean likedBefore = dao.hasUserLiked(postId, u.getUsername());
        if (likedBefore) dao.unlike(postId, u.getUsername());
        else dao.like(postId, u.getUsername());

        boolean likedNow = dao.hasUserLiked(postId, u.getUsername());
        int count = dao.countLikes(postId);

        // respond JSON
        resp.setContentType("application/json");
        try (PrintWriter out = resp.getWriter()) {
            out.printf("{\"ok\":true,\"liked\":%s,\"count\":%d}",
                    likedNow ? "true" : "false", count);
        }
    }
}