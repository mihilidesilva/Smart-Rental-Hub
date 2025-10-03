package com.smart.rentalhub.controller;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.*;
import java.net.URLDecoder;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;

@WebServlet("/uploads/*")
public class ImageServlet extends HttpServlet {

    private static final String UPLOAD_DIR = "D:/smartrentalhub_uploads"; //  Our pc's path

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String pathInfo = req.getPathInfo(); // "/file.jpg"
        if (pathInfo == null || "/".equals(pathInfo)) {
            resp.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        String fileName = URLDecoder.decode(pathInfo.substring(1), StandardCharsets.UTF_8);
        File file = new File(UPLOAD_DIR, fileName);

        if (!file.exists() || file.isDirectory()) {
            resp.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        String mime = Files.probeContentType(file.toPath());
        if (mime == null) mime = "application/octet-stream";
        resp.setContentType(mime);
        resp.setHeader("Cache-Control", "public, max-age=86400");

        try (OutputStream out = resp.getOutputStream();
             InputStream in = new FileInputStream(file)) {
            in.transferTo(out);
        }
    }
}
