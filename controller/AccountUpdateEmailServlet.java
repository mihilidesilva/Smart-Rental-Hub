package com.smart.rentalhub.controller;

import com.smart.rentalhub.dao.UserDAO;
import com.smart.rentalhub.model.User;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/account/updateEmail")
public class AccountUpdateEmailServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        HttpSession s = req.getSession(false);
        String ctx = req.getContextPath();

        User u = (s != null) ? (User) s.getAttribute("user") : null;
        if (u == null) { resp.sendRedirect(ctx + "/login.jsp"); return; }

        String email = req.getParameter("email");
        if (email == null || email.isBlank()) {
            resp.sendRedirect(ctx + "/editAccount.jsp?error=emptyEmail");
            return;
        }

        boolean ok = new UserDAO().updateEmail(u.getId(), email);
        if (ok) {
            // keep session user fresh
            u.setEmail(email);
            s.setAttribute("user", u);
            resp.sendRedirect(ctx + "/editAccount.jsp?updated=1");
        } else {
            resp.sendRedirect(ctx + "/editAccount.jsp?error=1");
        }
    }
}
