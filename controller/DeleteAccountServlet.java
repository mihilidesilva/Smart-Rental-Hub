package com.smart.rentalhub.controller;

import com.smart.rentalhub.dao.UserDAO;
import com.smart.rentalhub.model.User;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/account/delete")
public class DeleteAccountServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        HttpSession s = req.getSession(false);
        String ctx = req.getContextPath();

        User u = (s != null) ? (User) s.getAttribute("user") : null;
        if (u == null) { resp.sendRedirect(ctx + "/login.jsp"); return; }

        String pwd = req.getParameter("password");
        if (pwd == null || pwd.isBlank()) {
            resp.sendRedirect(ctx + "/editAccount.jsp?error=server");
            return;
        }

        UserDAO dao = new UserDAO();

        if (!dao.checkPassword(u.getId(), pwd)) {
            resp.sendRedirect(ctx + "/editAccount.jsp?error=wrongOld");
            return;
        }

        boolean ok = dao.deleteAccount(u.getId());
        if (!ok) {
            resp.sendRedirect(ctx + "/editAccount.jsp?error=server");
            return;
        }

        if (s != null) s.invalidate();
        String dest = ctx + "/login.jsp?deleted=1";
        resp.setContentType("text/html;charset=UTF-8");
        resp.getWriter().write(
            "<!doctype html><meta charset='utf-8'>" +
            "<script>if(window.top!==window.self){window.top.location.href='" + dest +
            "';}else{location.replace('" + dest + "');}</script>"
        );
    }
}
