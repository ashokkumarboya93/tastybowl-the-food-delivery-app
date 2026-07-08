package com.food.daoimp;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.food.dao.MenuDao;
import com.food.model.Menu;
import com.food.utility.DBConnection;

public class MenuDaoImpl implements MenuDao {

    private Connection con;
    private PreparedStatement pstmt;
    private ResultSet rs;

    private static final String INSERT =
            "INSERT INTO menu(restaurantId,itemName,description,price,rating,imagePath,isAvailable,category) VALUES(?,?,?,?,?,?,?,?)";

    private static final String UPDATE =
            "UPDATE menu SET restaurantId=?, itemName=?, description=?, price=?, rating=?, imagePath=?, isAvailable=?, category=? WHERE menuId=?";

    private static final String DELETE =
            "DELETE FROM menu WHERE menuId=?";

    private static final String GET_ONE =
            "SELECT * FROM menu WHERE menuId=?";

    private static final String GET_ALL =
            "SELECT * FROM menu";

    private static final String GET_BY_RESTAURANT =
            "SELECT * FROM menu WHERE restaurantId=?";

    public MenuDaoImpl() {
        con = DBConnection.getConnection();
    }

    @Override
    public void addMenu(Menu menu) {

        try {

            pstmt = con.prepareStatement(INSERT);

            pstmt.setInt(1, menu.getRestaurantId());
            pstmt.setString(2, menu.getItemName());
            pstmt.setString(3, menu.getDescription());
            pstmt.setDouble(4, menu.getPrice());
            pstmt.setDouble(5, menu.getRating());
            pstmt.setString(6, menu.getImagePath());
            pstmt.setBoolean(7, menu.isAvailable());
            pstmt.setString(8, menu.getCategory());

            int rows = pstmt.executeUpdate();

            if(rows > 0) {
                System.out.println("Menu Added Successfully");
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    public void updateMenu(Menu menu) {

        try {

            pstmt = con.prepareStatement(UPDATE);

            pstmt.setInt(1, menu.getRestaurantId());
            pstmt.setString(2, menu.getItemName());
            pstmt.setString(3, menu.getDescription());
            pstmt.setDouble(4, menu.getPrice());
            pstmt.setDouble(5, menu.getRating());
            pstmt.setString(6, menu.getImagePath());
            pstmt.setBoolean(7, menu.isAvailable());
            pstmt.setString(8, menu.getCategory());
            pstmt.setInt(9, menu.getMenuId());

            int rows = pstmt.executeUpdate();

            if(rows > 0) {
                System.out.println("Menu Updated Successfully");
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    public void deleteMenu(int menuId) {

        try {

            pstmt = con.prepareStatement(DELETE);
            pstmt.setInt(1, menuId);

            int rows = pstmt.executeUpdate();

            if(rows > 0) {
                System.out.println("Menu Deleted Successfully");
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    public Menu getMenu(int menuId) {

        Menu menu = null;

        try {

            pstmt = con.prepareStatement(GET_ONE);
            pstmt.setInt(1, menuId);

            rs = pstmt.executeQuery();

            if(rs.next()) {

                menu = new Menu(
                        rs.getInt("menuId"),
                        rs.getInt("restaurantId"),
                        rs.getString("itemName"),
                        rs.getString("description"),
                        rs.getDouble("price"),
                        rs.getDouble("rating"),
                        rs.getBoolean("isAvailable"),
                        rs.getString("category"),
                        rs.getString("imagePath")
                );
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return menu;
    }

    @Override
    public List<Menu> getAllMenus() {

        List<Menu> menuList = new ArrayList<>();

        try {

            pstmt = con.prepareStatement(GET_ALL);

            rs = pstmt.executeQuery();

            while(rs.next()) {

                menuList.add(
                        new Menu(
                                rs.getInt("menuId"),
                                rs.getInt("restaurantId"),
                                rs.getString("itemName"),
                                rs.getString("description"),
                                rs.getDouble("price"),
                                rs.getDouble("rating"),
                                rs.getBoolean("isAvailable"),
                                rs.getString("category"),
                                rs.getString("imagePath")
                        )
                );
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return menuList;
    }

    @Override
    public List<Menu> getMenusByRestaurantId(int restaurantId) {

        List<Menu> menuList = new ArrayList<>();

        try {

            pstmt = con.prepareStatement(GET_BY_RESTAURANT);
            pstmt.setInt(1, restaurantId);

            rs = pstmt.executeQuery();

            while(rs.next()) {

                menuList.add(
                        new Menu(
                                rs.getInt("menuId"),
                                rs.getInt("restaurantId"),
                                rs.getString("itemName"),
                                rs.getString("description"),
                                rs.getDouble("price"),
                                rs.getDouble("rating"),
                                rs.getBoolean("isAvailable"),
                                rs.getString("category"),
                                rs.getString("imagePath")
                        )
                );
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return menuList;
    }
}