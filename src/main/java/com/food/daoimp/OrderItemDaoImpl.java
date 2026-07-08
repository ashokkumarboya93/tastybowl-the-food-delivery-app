package com.food.daoimp;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.food.dao.OrderItemDao;
import com.food.model.OrderItem;
import com.food.utility.DBConnection;

public class OrderItemDaoImpl implements OrderItemDao {

    private Connection con;
    private PreparedStatement pstmt;
    private ResultSet rs;

    private static final String INSERT =
            "INSERT INTO orderitem(orderId,menuId,quantity,itemTotal) VALUES(?,?,?,?)";

    private static final String UPDATE =
            "UPDATE orderitem SET orderId=?, menuId=?, quantity=?, itemTotal=? WHERE orderItemId=?";

    private static final String DELETE =
            "DELETE FROM orderitem WHERE orderItemId=?";

    private static final String GET_ONE =
            "SELECT * FROM orderitem WHERE orderItemId=?";

    private static final String GET_ALL =
            "SELECT * FROM orderitem";

    public OrderItemDaoImpl() {
        con = DBConnection.getConnection();
    }

    @Override
    public void addOrderItem(OrderItem orderItem) {

        try {
            pstmt = con.prepareStatement(INSERT);

            pstmt.setInt(1, orderItem.getOrderId());
            pstmt.setInt(2, orderItem.getMenuId());
            pstmt.setInt(3, orderItem.getQuantity());
            pstmt.setDouble(4, orderItem.getItemTotal());

            int rows = pstmt.executeUpdate();

            if (rows > 0) {
                System.out.println("Order Item Added Successfully");
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    public void updateOrderItem(OrderItem orderItem) {

        try {
            pstmt = con.prepareStatement(UPDATE);

            pstmt.setInt(1, orderItem.getOrderId());
            pstmt.setInt(2, orderItem.getMenuId());
            pstmt.setInt(3, orderItem.getQuantity());
            pstmt.setDouble(4, orderItem.getItemTotal());
            pstmt.setInt(5, orderItem.getOrderItemId());

            int rows = pstmt.executeUpdate();

            if (rows > 0) {
                System.out.println("Order Item Updated Successfully");
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    public void deleteOrderItem(int orderItemId) {

        try {
            pstmt = con.prepareStatement(DELETE);

            pstmt.setInt(1, orderItemId);

            int rows = pstmt.executeUpdate();

            if (rows > 0) {
                System.out.println("Order Item Deleted Successfully");
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    public OrderItem getOrderItem(int orderItemId) {

        OrderItem orderItem = null;

        try {
            pstmt = con.prepareStatement(GET_ONE);

            pstmt.setInt(1, orderItemId);

            rs = pstmt.executeQuery();

            if (rs.next()) {

                orderItem = new OrderItem(
                        rs.getInt("orderItemId"),
                        rs.getInt("orderId"),
                        rs.getInt("menuId"),
                        rs.getInt("quantity"),
                        rs.getDouble("itemTotal")
                );
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return orderItem;
    }

    @Override
    public List<OrderItem> getAllOrderItems() {

        List<OrderItem> orderItems = new ArrayList<>();

        try {
            pstmt = con.prepareStatement(GET_ALL);

            rs = pstmt.executeQuery();

            while (rs.next()) {

                orderItems.add(
                        new OrderItem(
                                rs.getInt("orderItemId"),
                                rs.getInt("orderId"),
                                rs.getInt("menuId"),
                                rs.getInt("quantity"),
                                rs.getDouble("itemTotal")
                        )
                );
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return orderItems;
    }
}