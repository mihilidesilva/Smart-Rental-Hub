package com.smart.rentalhub.controller;

import com.smart.rentalhub.dao.CommunityPostDAO;
import com.smart.rentalhub.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.StandardCopyOption;
import java.util.UUID;

@WebServlet("/community/post")
@MultipartConfig
public class CommunityPostServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        User u = (User) req.getSession().getAttribute("user");
        if (u == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        String message = req.getParameter("message");
        Part imagePart = null;
        try { imagePart = req.getPart("image"); } catch (Exception ignored) {}

      
        String uploadDirPath = getServletContext().getRealPath("/Web Pages/uploads/");
        File uploadDir = new File(uploadDirPath);
        if (!uploadDir.exists()) uploadDir.mkdirs();

        String storedName = null;
        if (imagePart != null && imagePart.getSize() > 0) {
            String submitted = imagePart.getSubmittedFileName();
            String ext = "";
            if (submitted != null && submitted.lastIndexOf('.') != -1) {
                ext = submitted.substring(submitted.lastIndexOf('.'));
            }
            storedName = "post_" + UUID.randomUUID() + ext;
            File dest = new File(uploadDir, storedName);
            Files.copy(imagePart.getInputStream(), dest.toPath(), StandardCopyOption.REPLACE_EXISTING);
        }

        new CommunityPostDAO().insert(u.getUsername(), message, storedName);

        // back to profile 
        resp.sendRedirect(req.getContextPath() + "/profile.jsp#gothami-section");
    }
}