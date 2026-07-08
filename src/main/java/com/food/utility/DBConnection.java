package com.food.utility;

import java.sql.Connection;
import java.sql.DriverManager;

public class DBConnection {

    private static final String url = "jdbc:mysql://localhost:3306/fooddelivery";
    private static final String username = "root";
    private static final String password = "root";

    private static Connection con = null;

    public static Connection getConnection() {
        try {
            if (con == null || con.isClosed()) {
                Class.forName("com.mysql.cj.jdbc.Driver");
                con = DriverManager.getConnection(
                        url,
                        username,
                        password);
                System.out.println("Connection Success: " + con);
            }
        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException("Database Connection Error: " + e.getMessage(), e);
        }
        return con;
    }

}