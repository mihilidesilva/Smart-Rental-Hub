package com.smart.rentalhub.controller;

import com.smart.rentalhub.dao.UserDAO;
import com.smart.rentalhub.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;

@WebServlet("/updateProfile")
@MultipartConfig(
        fileSizeThreshold = 2 * 1024 * 1024,   // 2MB
        maxFileSize       = 10 * 1024 * 1024,  // 10MB
        maxRequestSize    = 50 * 1024 * 1024   // 50MB
)
public class UpdateProfileServlet extends HttpServlet {

    // Persistent folder OUTSIDE the web app
    private static final String UPLOAD_DIR = "D:/smartrentalhub_uploads";

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");

        HttpSession session = req.getSession(false);
        User current = (session != null) ? (User) session.getAttribute("user") : null;
        if (current == null) {
            System.out.println("❌ UpdateProfile: no session user");
            resp.sendRedirect("login.jsp");
            return;
        }

        // ----- Sanitize inputs -----
        String fullNameRaw = req.getParameter("fullname");
        String bioRaw      = req.getParameter("bio");

        String fullName = toTitleCase(stripTags(trimOrEmpty(fullNameRaw)));
        String bio      = stripTags(trimOrEmpty(bioRaw));
        if (bio.length() > 1000) bio = bio.substring(0, 1000); // optional max

        //  new profile image
        String newFileName = null; // only the filename stored in DB
        try {
            Part photo = req.getPart("profile_img"); // may be null if no file input on page
            if (photo != null && photo.getSize() > 0) {
                String ct = photo.getContentType();
                if (ct != null && ct.toLowerCase().startsWith("image/")) {
                    // Ensure folder exists
                    Files.createDirectories(Paths.get(UPLOAD_DIR));

                    // Create unique filename, preserving extension if present
                    String submitted = Paths.get(photo.getSubmittedFileName()).getFileName().toString();
                    String ext = "";
                    int dot = submitted.lastIndexOf('.');
                    if (dot >= 0) ext = submitted.substring(dot);

                    newFileName = java.util.UUID.randomUUID().toString().replace("-", "") + ext;

                    // Save to disk
                    File target = new File(UPLOAD_DIR, newFileName);
                    photo.write(target.getAbsolutePath());
                    System.out.println("✅ UpdateProfile: saved new avatar " + target.getAbsolutePath());
                } else {
                    System.out.println("❌ UpdateProfile: invalid image content-type = " + ct);
                }
            } else {
                System.out.println("ℹ️ UpdateProfile: no new image uploaded; keeping existing");
            }
        } catch (IllegalStateException ise) {
            System.out.println("❌ UpdateProfile: upload too large or request issue: " + ise.getMessage());
        } catch (Exception ex) {
            System.out.println("❌ UpdateProfile: error handling image: " + ex.getMessage());
            ex.printStackTrace();
        }

        // If no new image, keep the current one
        String finalFileName = (newFileName != null) ? newFileName : current.getProfileImg();

        // Persist to DB
        boolean ok = false;
        try {
            ok = new UserDAO().updateUserProfile(current.getId(), fullName, bio, finalFileName);
            System.out.println("ℹ️ UpdateProfile: DB update " + (ok ? "OK" : "FAILED")
                    + " for userId=" + current.getId());
        } catch (Exception e) {
            System.out.println("❌ UpdateProfile: DAO error: " + e.getMessage());
            e.printStackTrace();
        }

        if (ok) {
            // Refresh session user so UI reflects immediately
            current.setFullName(fullName);
            current.setBio(bio);
            current.setProfileImg(finalFileName);
            session.setAttribute("user", current);

            resp.sendRedirect("editProfile.jsp?updated=1");
        } else {
            resp.sendRedirect("editProfile.jsp?error=1");
        }
    }

    // ---------- helpers ----------
    private static String trimOrEmpty(String s) {
        return (s == null) ? "" : s.trim();
    }

    /** remove all HTML tags */
    private static String stripTags(String s) {
        if (s == null) return "";
        return s.replaceAll("<[^>]*>", "");
    }

    /**  "tHaMaSha samare" -> "Thamasha Samare" */
    private static String toTitleCase(String s) {
        if (s == null) return "";
        s = s.trim().replaceAll("\\s+", " ").toLowerCase();
        if (s.isEmpty()) return s;
        String[] parts = s.split(" ");
        StringBuilder out = new StringBuilder(s.length());
        for (String p : parts) {
            if (p.isEmpty()) continue;
            out.append(Character.toUpperCase(p.charAt(0)));
            if (p.length() > 1) out.append(p.substring(1));
            out.append(' ');
        }
        return out.toString().trim();
    }
}
