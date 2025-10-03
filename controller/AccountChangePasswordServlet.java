package com.smart.rentalhub.controller;

import com.smart.rentalhub.dao.UserDAO;
import com.smart.rentalhub.model.User;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/account/changePassword")
public class AccountChangePasswordServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        HttpSession s = req.getSession(false);
        String ctx = req.getContextPath();

        User u = (s != null) ? (User) s.getAttribute("user") : null;
        if (u == null) { resp.sendRedirect(ctx + "/login.jsp"); return; }

        String oldPwd  = req.getParameter("old_password");
        String newPwd  = req.getParameter("new_password");
        String confirm = req.getParameter("confirm_password");

        if (oldPwd == null || newPwd == null || confirm == null || !newPwd.equals(confirm)) {
            resp.sendRedirect(ctx + "/editAccount.jsp?error=pwdMismatch");
            return;
        }
        if (newPwd.length() < 6) {
            resp.sendRedirect(ctx + "/editAccount.jsp?error=weakPwd");
            return;
        }

        UserDAO dao = new UserDAO();

        if (!dao.checkPassword(u.getId(), oldPwd)) {
            resp.sendRedirect(ctx + "/editAccount.jsp?error=wrongOld");
            return;
        }

        boolean ok = dao.changePassword(u.getId(), oldPwd, newPwd);
        if (!ok) {
            resp.sendRedirect(ctx + "/editAccount.jsp?error=server");
            return;
        }

        // Success,,,, sign out and hard-redirect TOP window to login
        if (s != null) s.invalidate();
        String dest = ctx + "/login.jsp?pwChanged=1";
        resp.setContentType("text/html;charset=UTF-8");
        resp.getWriter().write(
            "<!doctype html><meta charset='utf-8'>" +
            "<script>if(window.top!==window.self){window.top.location.href='" + dest +
            "';}else{location.replace('" + dest + "');}</script>"
        );
    }
}
