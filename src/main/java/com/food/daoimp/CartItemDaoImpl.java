package com.food.daoimp;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.food.dao.CartItemDao;
import com.food.model.CartItem;
import com.food.utility.DBConnection;

public class CartItemDaoImpl implements CartItemDao {

    private Connection con;
    private PreparedStatement pstmt;
    private ResultSet rs;

    private static final String INSERT =
            "INSERT INTO cartitem(cartId,menuId,quantity,totalPrice) VALUES(?,?,?,?)";

    private static final String UPDATE =
            "UPDATE cartitem SET cartId=?, menuId=?, quantity=?, totalPrice=? WHERE cartItemId=?";

    private static final String DELETE =
            "DELETE FROM cartitem WHERE cartItemId=?";

    private static final String GET_ONE =
            "SELECT * FROM cartitem WHERE cartItemId=?";

    private static final String GET_ALL =
            "SELECT * FROM cartitem";

    public CartItemDaoImpl() {
        con = DBConnection.getConnection();
    }

    @Override
    public void addCartItem(CartItem cartItem) {

        try {
            pstmt = con.prepareStatement(INSERT);

            pstmt.setInt(1, cartItem.getCartId());
            pstmt.setInt(2, cartItem.getMenuId());
            pstmt.setInt(3, cartItem.getQuantity());
            pstmt.setDouble(4, cartItem.getTotalPrice());

            int rows = pstmt.executeUpdate();

            if (rows > 0) {
                System.out.println("Cart Item Added Successfully");
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    public void updateCartItem(CartItem cartItem) {

        try {
            pstmt = con.prepareStatement(UPDATE);

            pstmt.setInt(1, cartItem.getCartId());
            pstmt.setInt(2, cartItem.getMenuId());
            pstmt.setInt(3, cartItem.getQuantity());
            pstmt.setDouble(4, cartItem.getTotalPrice());
            pstmt.setInt(5, cartItem.getCartItemId());

            int rows = pstmt.executeUpdate();

            if (rows > 0) {
                System.out.println("Cart Item Updated Successfully");
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    public void deleteCartItem(int cartItemId) {

        try {
            pstmt = con.prepareStatement(DELETE);

            pstmt.setInt(1, cartItemId);

            int rows = pstmt.executeUpdate();

            if (rows > 0) {
                System.out.println("Cart Item Deleted Successfully");
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    public CartItem getCartItem(int cartItemId) {

        CartItem cartItem = null;

        try {
            pstmt = con.prepareStatement(GET_ONE);

            pstmt.setInt(1, cartItemId);

            rs = pstmt.executeQuery();

            if (rs.next()) {

                cartItem = new CartItem(
                        rs.getInt("cartItemId"),
                        rs.getInt("cartId"),
                        rs.getInt("menuId"),
                        rs.getInt("quantity"),
                        rs.getDouble("totalPrice")
                );
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return cartItem;
    }

    @Override
    public List<CartItem> getAllCartItems() {

        List<CartItem> cartItems = new ArrayList<>();

        try {
            pstmt = con.prepareStatement(GET_ALL);

            rs = pstmt.executeQuery();

            while (rs.next()) {

                cartItems.add(
                        new CartItem(
                                rs.getInt("cartItemId"),
                                rs.getInt("cartId"),
                                rs.getInt("menuId"),
                                rs.getInt("quantity"),
                                rs.getDouble("totalPrice")
                        )
                );
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return cartItems;
    }
}