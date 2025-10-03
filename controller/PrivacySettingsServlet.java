package com.smart.rentalhub.controller;

import com.smart.rentalhub.dao.SettingsDAO;
import com.smart.rentalhub.model.PrivacySettings;
import com.smart.rentalhub.model.User;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/settings/privacy/update")
public class PrivacySettingsServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String ctx = req.getContextPath();
        HttpSession s = req.getSession(false);
        User u = (s != null) ? (User) s.getAttribute("user") : null;
        if (u == null) {
            resp.sendRedirect(ctx + "/login.jsp");
            return;
        }

        // Only handle the remaining setting
        boolean profileVisible = req.getParameter("profile_visible") != null;

        // Adjust PrivacySettings constructor to match new fields
        PrivacySettings ps = new PrivacySettings(u.getId(), profileVisible);

        boolean ok = new SettingsDAO().upsertPrivacy(ps);

        resp.sendRedirect(ctx + "/editPrivacy.jsp?" + (ok ? "updated=1" : "error=1"));
    }
}
