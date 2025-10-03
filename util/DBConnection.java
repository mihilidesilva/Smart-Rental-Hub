package com.smart.rentalhub.util;

import java.sql.Connection;
import java.sql.DriverManager;

public class DBConnection {
    public static Connection getConnection() {
        Connection conn = null;
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");  
            conn = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/smartrentalhub", "root", "Sama@123re"
            );
        } catch (Exception e) {
            System.out.println("❌ Error: " + e.getMessage());
        }
        return conn;
    }
}
