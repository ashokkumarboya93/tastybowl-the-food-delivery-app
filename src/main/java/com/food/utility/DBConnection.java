package com.food.utility;

import java.sql.Connection;
import java.sql.DriverManager;

public class DBConnection {

    private static String getEnv(String name, String defaultValue) {
        String value = System.getenv(name);
        return (value != null && !value.trim().isEmpty()) ? value : defaultValue;
    }

    private static final String host = getEnv("MYSQLHOST", "localhost");
    private static final String port = getEnv("MYSQLPORT", "3306");
    private static final String db = getEnv("MYSQLDATABASE", "fooddelivery");

    private static final String url = getEnv("JDBC_URL", "jdbc:mysql://" + host + ":" + port + "/" + db);
    private static final String username = getEnv("MYSQLUSER", "root");
    private static final String password = getEnv("MYSQLPASSWORD", "root");

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