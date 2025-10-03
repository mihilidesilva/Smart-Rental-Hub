package com.smart.rentalhub.controller;

import com.smart.rentalhub.model.User;
import com.smart.rentalhub.dao.UserDAO;
import com.smart.rentalhub.util.PasswordEncryptor;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.net.URLEncoder;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;

@WebServlet("/register")
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 2,  // 2MB
        maxFileSize       = 1024 * 1024 * 10, // 10MB
        maxRequestSize    = 1024 * 1024 * 50  // 50MB
)
public class RegisterServlet extends HttpServlet {

    // ✅ Persistent upload folder (outside the webapp)
    private static final String UPLOAD_DIR = "D:/smartrentalhub_uploads";

    // 🔒 Hard-coded admin registration code (match your UI)
    private static final String ADMIN_REG_CODE = "SRH-ADMIN-2025";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        // ---------- Read + sanitize ----------
        String username = stripTags(trimOrEmpty(request.getParameter("username")));
        String password = trimOrEmpty(request.getParameter("password"));
        String fullName = toTitleCase(stripTags(trimOrEmpty(request.getParameter("fullname"))));
        String email    = stripTags(trimOrEmpty(request.getParameter("email")));
        String bio      = stripTags(trimOrEmpty(request.getParameter("bio")));
        if (bio.length() > 1000) bio = bio.substring(0, 1000);

        String role     = trimOrEmpty(request.getParameter("role"));
        if (role.isEmpty()) role = "tenant";
        role = role.toLowerCase();
        
        

        // ? Admin code enforcement
        if ("admin".equals(role)) {
            String code = trimOrEmpty(request.getParameter("admin_code"));
            if (!ADMIN_REG_CODE.equals(code)) {
                response.sendRedirect("register.jsp?error=Invalid+admin+access+code");
                return;
            }
        }

        // ---------- File upload ----------
        Part filePart = null;
        try {
            filePart = request.getPart("profile_img");
        } catch (IllegalStateException ise) {
            System.out.println("❌ File upload error: " + ise.getMessage());
        }

        Path uploadFolder = Paths.get(UPLOAD_DIR);
        if (!Files.exists(uploadFolder)) {
            Files.createDirectories(uploadFolder);
            System.out.println("ℹ️ Created upload folder: " + uploadFolder);
        }

        String storedFileName = null; // only filename goes to DB

        if (filePart != null && filePart.getSize() > 0) {
            String contentType = filePart.getContentType(); // image
            if (contentType != null && contentType.toLowerCase().startsWith("image/")) {
                String submitted = filePart.getSubmittedFileName();
                String originalName = submitted != null ? Paths.get(submitted).getFileName().toString() : null;

                String ext = "";
                if (originalName != null && originalName.contains(".")) {
                    ext = originalName.substring(originalName.lastIndexOf("."));
                }
                storedFileName = java.util.UUID.randomUUID().toString().replace("-", "") + ext;

                Path target = uploadFolder.resolve(storedFileName);
                filePart.write(target.toString());
                System.out.println("✅ Saved profile image to: " + target);
            } else {
                System.out.println("❌ Invalid file type for profile_img: " + contentType);
            }
        } else {
            System.out.println("ℹ️ No profile image uploaded.");
        }

        // ---------- Build user ----------
        User user = new User();
        user.setUsername(username);
        user.setPassword(PasswordEncryptor.hash(password)); // hashed
        user.setFullName(fullName);
        user.setEmail(email);
        user.setBio(bio);
        user.setProfileImg(storedFileName); // only file name
        user.setRole(role);

        // ---------- Persist ----------
       UserDAO dao = new UserDAO();
boolean registered = dao.registerUser(user);

  if (registered) {
    System.out.println("✅ User registered successfully");
    System.out.println("📷 profile_img saved as (DB): " + storedFileName);

    // redirect to login.jsp with success flag
    response.sendRedirect("login.jsp?ok=1");

  } else {
    System.out.println("❌ User registration failed (insert error)");

    // stay on register.jsp with error message
    String errorMsg = "Registration failed. Please try again.";
    response.sendRedirect("register.jsp?error=" + URLEncoder.encode(errorMsg, "UTF-8"));
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

    /** tHaMaSha SamRanayake -> "Thamasha Samaranayake" */
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
