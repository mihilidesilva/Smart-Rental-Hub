/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.smart.rentalhub.controller;

import java.io.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/property-image")
public class ImageServletProperty extends HttpServlet {

    private static final String UPLOAD_DIR = "D:/smartrentalhub_uploads/properties";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String fileName = request.getParameter("name");
        if (fileName == null || fileName.isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Image name is missing");
            return;
        }

        File imageFile = new File(UPLOAD_DIR, fileName);
        if (!imageFile.exists()) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Image not found");
            return;
        }

        // Detect content type
        String mimeType = getServletContext().getMimeType(imageFile.getName());
        if (mimeType == null) {
            mimeType = "application/octet-stream";
        }
        response.setContentType(mimeType);
        response.setContentLengthLong(imageFile.length());

        try (FileInputStream in = new FileInputStream(imageFile);
             OutputStream out = response.getOutputStream()) {
            byte[] buffer = new byte[4096];
            int bytesRead;
            while ((bytesRead = in.read(buffer)) != -1) {
                out.write(buffer, 0, bytesRead);
            }
        }
    }
}
