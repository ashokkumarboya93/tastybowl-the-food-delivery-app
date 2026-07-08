package com.food.daoimp;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.food.dao.OrderDao;
import com.food.model.OrderTable;
import com.food.utility.DBConnection;

public class OrderDaoImpl implements OrderDao {

    private Connection con;
    private PreparedStatement pstmt;
    private ResultSet rs;

    private static final String INSERT =
            "INSERT INTO ordertable(userId,restaurantId,orderDate,totalAmount,status,paymentMethod) VALUES(?,?,?,?,?,?)";

    private static final String UPDATE =
            "UPDATE ordertable SET userId=?, restaurantId=?, totalAmount=?, status=?, paymentMethod=? WHERE orderId=?";

    private static final String DELETE =
            "DELETE FROM ordertable WHERE orderId=?";

    private static final String GET_ONE =
            "SELECT * FROM ordertable WHERE orderId=?";

    private static final String GET_ALL =
            "SELECT * FROM ordertable";

    public OrderDaoImpl() {
        con = DBConnection.getConnection();
    }

    @Override
    public int addOrder(OrderTable order) {
        int generatedId = -1;
        try {
            pstmt = con.prepareStatement(INSERT, java.sql.Statement.RETURN_GENERATED_KEYS);

            pstmt.setInt(1, order.getUserId());
            pstmt.setInt(2, order.getRestaurantId());
            pstmt.setTimestamp(3, order.getOrderDate());
            pstmt.setDouble(4, order.getTotalAmount());
            pstmt.setString(5, order.getStatus());
            pstmt.setString(6, order.getPaymentMethod());

            int rows = pstmt.executeUpdate();

            if (rows > 0) {
                System.out.println("Order Added Successfully");
                try (ResultSet rsKeys = pstmt.getGeneratedKeys()) {
                    if (rsKeys.next()) {
                        generatedId = rsKeys.getInt(1);
                    }
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return generatedId;
    }

    @Override
    public void updateOrder(OrderTable order) {

        try {
            pstmt = con.prepareStatement(UPDATE);

            pstmt.setInt(1, order.getUserId());
            pstmt.setInt(2, order.getRestaurantId());
            pstmt.setDouble(3, order.getTotalAmount());
            pstmt.setString(4, order.getStatus());
            pstmt.setString(5, order.getPaymentMethod());
            pstmt.setInt(6, order.getOrderId());

            int rows = pstmt.executeUpdate();

            if (rows > 0) {
                System.out.println("Order Updated Successfully");
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    public void deleteOrder(int orderId) {

        try {
            pstmt = con.prepareStatement(DELETE);

            pstmt.setInt(1, orderId);

            int rows = pstmt.executeUpdate();

            if (rows > 0) {
                System.out.println("Order Deleted Successfully");
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    public OrderTable getOrder(int orderId) {

        OrderTable order = null;

        try {
            pstmt = con.prepareStatement(GET_ONE);

            pstmt.setInt(1, orderId);

            rs = pstmt.executeQuery();

            if (rs.next()) {

                order = new OrderTable(
                        rs.getInt("orderId"),
                        rs.getInt("userId"),
                        rs.getInt("restaurantId"),
                        rs.getTimestamp("orderDate"),
                        rs.getDouble("totalAmount"),
                        rs.getString("status"),
                        rs.getString("paymentMethod")
                );
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return order;
    }

    @Override
    public List<OrderTable> getAllOrders() {

        List<OrderTable> orders = new ArrayList<>();

        try {
            pstmt = con.prepareStatement(GET_ALL);

            rs = pstmt.executeQuery();

            while (rs.next()) {

                orders.add(
                        new OrderTable(
                                rs.getInt("orderId"),
                                rs.getInt("userId"),
                                rs.getInt("restaurantId"),
                                rs.getTimestamp("orderDate"),
                                rs.getDouble("totalAmount"),
                                rs.getString("status"),
                                rs.getString("paymentMethod")
                        )
                );
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return orders;
    }
}