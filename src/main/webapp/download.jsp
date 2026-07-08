<%@ page import="java.io.*,java.net.*,java.nio.file.*,java.util.*" %>
<%
    try {
        URL url = new URL("https://raw.githubusercontent.com/jeremyh/jBCrypt/master/src/main/java/org/mindrot/BCrypt.java");
        BufferedReader reader = new BufferedReader(new InputStreamReader(url.openStream()));
        StringBuilder sb = new StringBuilder();
        String line;
        while ((line = reader.readLine()) != null) {
            if (line.trim().startsWith("package ")) {
                sb.append("package com.food.utility;\n");
            } else {
                sb.append(line).append("\n");
            }
        }
        reader.close();
        
        File targetFile = new File("d:/JDBCSW/workspace_project/FoodApp/src/main/java/com/food/utility/BCrypt.java");
        FileWriter writer = new FileWriter(targetFile);
        writer.write(sb.toString());
        writer.close();
        
        out.println("SUCCESS_DOWNLOAD");
    } catch(Exception e) {
        out.println("ERROR_DOWNLOAD: " + e.getMessage());
    }
%>
