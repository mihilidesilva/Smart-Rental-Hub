package com.smart.rentalhub.controller;

import com.smart.rentalhub.dao.UserDAO;
import com.smart.rentalhub.model.User;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;

@WebServlet("/updateCover")
@MultipartConfig(
    fileSizeThreshold = 2 * 1024 * 1024,
    maxFileSize       = 10 * 1024 * 1024,
    maxRequestSize    = 50 * 1024 * 1024
)
public class UpdateCoverServlet extends HttpServlet {
    private static final String UPLOAD_DIR = "D:/smartrentalhub_uploads";

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        req.setCharacterEncoding("UTF-8");
        HttpSession session = req.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;
        if (user == null) { resp.sendRedirect("login.jsp"); return; }

        String fileName = null;
        try {
            Part part = req.getPart("cover_img");
            if (part != null && part.getSize() > 0 && part.getContentType().startsWith("image/")) {
                Files.createDirectories(Paths.get(UPLOAD_DIR));
                String submitted = Paths.get(part.getSubmittedFileName()).getFileName().toString();
                String ext = submitted.contains(".") ? submitted.substring(submitted.lastIndexOf('.')) : "";
                fileName = java.util.UUID.randomUUID().toString().replace("-", "") + ext;
                part.write(new File(UPLOAD_DIR, fileName).getAbsolutePath());
            }
        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect("editProfile.jsp?error=1");
            return;
        }

        if (fileName == null) { resp.sendRedirect("editProfile.jsp?error=1"); return; }

        boolean ok = new UserDAO().upsertCoverImage(user.getId(), fileName);
        resp.sendRedirect("editProfile.jsp" + (ok ? "?updated=1" : "?error=1"));
    }
}
