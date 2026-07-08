package com.food.daoimp;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.food.dao.CartDao;
import com.food.model.Cart;
import com.food.utility.DBConnection;

public class CartDaoImpl implements CartDao {

    private Connection con;
    private PreparedStatement pstmt;
    private ResultSet rs;

    private static final String INSERT =
            "INSERT INTO cart(userId) VALUES(?)";

    private static final String UPDATE =
            "UPDATE cart SET userId=? WHERE cartId=?";

    private static final String DELETE =
            "DELETE FROM cart WHERE cartId=?";

    private static final String GET_ONE =
            "SELECT * FROM cart WHERE cartId=?";

    private static final String GET_ALL =
            "SELECT * FROM cart";

    public CartDaoImpl() {
        con = DBConnection.getConnection();
    }

    @Override
    public void addCart(Cart cart) {

        try {
            pstmt = con.prepareStatement(INSERT);

            pstmt.setInt(1, cart.getUserId());

            int rows = pstmt.executeUpdate();

            if (rows > 0) {
                System.out.println("Cart Added Successfully");
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    public void updateCart(Cart cart) {

        try {
            pstmt = con.prepareStatement(UPDATE);

            pstmt.setInt(1, cart.getUserId());
            pstmt.setInt(2, cart.getCartId());

            int rows = pstmt.executeUpdate();

            if (rows > 0) {
                System.out.println("Cart Updated Successfully");
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    public void deleteCart(int cartId) {

        try {
            pstmt = con.prepareStatement(DELETE);

            pstmt.setInt(1, cartId);

            int rows = pstmt.executeUpdate();

            if (rows > 0) {
                System.out.println("Cart Deleted Successfully");
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    public Cart getCart(int cartId) {

        Cart cart = null;

        try {
            pstmt = con.prepareStatement(GET_ONE);

            pstmt.setInt(1, cartId);

            rs = pstmt.executeQuery();

            if (rs.next()) {

                cart = new Cart(
                        rs.getInt("cartId"),
                        rs.getInt("userId")
                );
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return cart;
    }

    @Override
    public List<Cart> getAllCarts() {

        List<Cart> carts = new ArrayList<>();

        try {
            pstmt = con.prepareStatement(GET_ALL);

            rs = pstmt.executeQuery();

            while (rs.next()) {

                carts.add(
                        new Cart(
                                rs.getInt("cartId"),
                                rs.getInt("userId")
                        )
                );
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return carts;
    }
}