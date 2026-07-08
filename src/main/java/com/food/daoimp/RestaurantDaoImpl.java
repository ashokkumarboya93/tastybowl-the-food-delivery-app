package com.food.daoimp;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.food.dao.RestaurantDao;
import com.food.model.Restaurant;
import com.food.utility.DBConnection;

public class RestaurantDaoImpl implements RestaurantDao {

    private Connection con;
    private PreparedStatement pstmt;
    private ResultSet rs;

    // INSERT
    private static final String INSERT =
            "INSERT INTO restaurant(name,cuisineType,deliveryTime,address,imagePath,adminUserId,rating,isActive) VALUES(?,?,?,?,?,?,?,?)";

    // UPDATE
    private static final String UPDATE =
            "UPDATE restaurant SET name=?, cuisineType=?, deliveryTime=?, address=?, imagePath=?, adminUserId=?, rating=?, isActive=? WHERE restaurantId=?";

    // DELETE
    private static final String DELETE =
            "DELETE FROM restaurant WHERE restaurantId=?";

    // GET ONE
    private static final String GET_ONE =
            "SELECT * FROM restaurant WHERE restaurantId=?";

    // GET ALL
    private static final String GET_ALL =
            "SELECT * FROM restaurant";

    public RestaurantDaoImpl() {
        con = DBConnection.getConnection();
    }

    @Override
    public void addRestaurant(Restaurant restaurant) {

        try {

            pstmt = con.prepareStatement(INSERT);

            pstmt.setString(1, restaurant.getName());
            pstmt.setString(2, restaurant.getCuisineType());
            pstmt.setInt(3, restaurant.getDeliveryTime());
            pstmt.setString(4, restaurant.getAddress());
            pstmt.setString(5, restaurant.getImagePath());
            pstmt.setInt(6, restaurant.getAdminUserId());
            pstmt.setDouble(7, restaurant.getRating());
            pstmt.setBoolean(8, restaurant.isActive());

            int rows = pstmt.executeUpdate();

            if (rows > 0) {
                System.out.println("Restaurant Added Successfully");
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    public void updateRestaurant(Restaurant restaurant) {

        try {

            pstmt = con.prepareStatement(UPDATE);

            pstmt.setString(1, restaurant.getName());
            pstmt.setString(2, restaurant.getCuisineType());
            pstmt.setInt(3, restaurant.getDeliveryTime());
            pstmt.setString(4, restaurant.getAddress());
            pstmt.setString(5, restaurant.getImagePath());
            pstmt.setInt(6, restaurant.getAdminUserId());
            pstmt.setDouble(7, restaurant.getRating());
            pstmt.setBoolean(8, restaurant.isActive());
            pstmt.setInt(9, restaurant.getRestaurantId());

            int rows = pstmt.executeUpdate();

            if (rows > 0) {
                System.out.println("Restaurant Updated Successfully");
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

    }

    @Override
    public void deleteRestaurant(int restaurantId) {

        try {

            pstmt = con.prepareStatement(DELETE);

            pstmt.setInt(1, restaurantId);

            int rows = pstmt.executeUpdate();

            if (rows > 0) {
                System.out.println("Restaurant Deleted Successfully");
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

    }

    @Override
    public Restaurant getRestaurant(int restaurantId) {

        Restaurant restaurant = null;

        try {

            pstmt = con.prepareStatement(GET_ONE);

            pstmt.setInt(1, restaurantId);

            rs = pstmt.executeQuery();

            if (rs.next()) {

                restaurant = new Restaurant(

                        rs.getInt("restaurantId"),
                        rs.getString("name"),
                        rs.getString("cuisineType"),
                        rs.getInt("deliveryTime"),
                        rs.getString("address"),
                        rs.getString("imagePath"),
                        rs.getInt("adminUserId"),
                        rs.getDouble("rating"),
                        rs.getBoolean("isActive")

                );
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return restaurant;
    }

    @Override
    public List<Restaurant> getAllRestaurants() {

        List<Restaurant> restaurants = new ArrayList<>();

        try {

            pstmt = con.prepareStatement(GET_ALL);

            rs = pstmt.executeQuery();

            while (rs.next()) {

                restaurants.add(

                        new Restaurant(

                                rs.getInt("restaurantId"),
                                rs.getString("name"),
                                rs.getString("cuisineType"),
                                rs.getInt("deliveryTime"),
                                rs.getString("address"),
                                rs.getString("imagePath"),
                                rs.getInt("adminUserId"),
                                rs.getDouble("rating"),
                                rs.getBoolean("isActive")

                        )

                );

            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return restaurants;
    }

}