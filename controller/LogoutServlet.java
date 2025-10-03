package com.smart.rentalhub.controller;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;

@WebServlet("/logout")
public class LogoutServlet extends HttpServlet {
  @Override protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
    HttpSession s = req.getSession(false);
    if (s != null) s.invalidate();
    resp.sendRedirect(req.getContextPath() + "/login.jsp");
  }
  @Override protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException { doGet(req, resp); }
}


