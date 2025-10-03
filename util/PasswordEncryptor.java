/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.smart.rentalhub.util;

import java.security.MessageDigest;

/**
 *
 * @author HI
 */
public class PasswordEncryptor {
    
    public static String hash(String password) {
        try {
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            byte[] hash = md.digest(password.getBytes("UTF-8"));
            StringBuilder hexString = new StringBuilder();

            for (byte b : hash) {
                String hex = Integer.toHexString(0xff & b);
                if(hex.length() == 1) hexString.append('0');
                hexString.append(hex);
            }

            return hexString.toString();
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }
    
     //  checker,,, re-hash and compare.
    public static boolean check(String plain, String storedHash) {
        if (plain == null || storedHash == null) return false;
        String again = hash(plain);
        return storedHash.equals(again);
    }
    
}
