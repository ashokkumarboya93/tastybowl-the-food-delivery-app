package com.food.daoimp;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

import com.food.dao.UserDao;
import com.food.model.User;
import com.food.utility.DBConnection;

public class UserDaoImpl implements UserDao {

    private Connection con;
    private PreparedStatement pstmt;
    private ResultSet rs;

    private static final String INSERT =
            "INSERT INTO user(username,password,email,phone,address,city,state,pincode,createDate,lastLogin,role) VALUES(?,?,?,?,?,?,?,?,?,?,?)";

    private static final String UPDATE =
            "UPDATE user SET username=?, password=?, email=?, phone=?, address=?, city=?, state=?, pincode=?, lastLogin=?, role=? WHERE userid=?";

    private static final String DELETE =
            "DELETE FROM user WHERE userid=?";

    private static final String GET_ONE =
            "SELECT * FROM user WHERE userid=?";

    private static final String GET_ALL =
            "SELECT * FROM user";

    public UserDaoImpl() {
        con = DBConnection.getConnection();
    }

    @Override
    public void addUser(User user) {

        try {
            pstmt = con.prepareStatement(INSERT);

            pstmt.setString(1, user.getUsername());
            pstmt.setString(2, user.getPassword());
            pstmt.setString(3, user.getEmail());
            pstmt.setString(4, user.getPhone());
            pstmt.setString(5, user.getAddress());
            pstmt.setString(6, user.getCity());
            pstmt.setString(7, user.getState());
            pstmt.setString(8, user.getPincode());
            pstmt.setTimestamp(9, user.getCreateDate());
            pstmt.setTimestamp(10, user.getLastLogin());
            pstmt.setString(11, user.getRole());

            pstmt.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    public void updateUser(User user) {

        try {
            pstmt = con.prepareStatement(UPDATE);

            pstmt.setString(1, user.getUsername());
            pstmt.setString(2, user.getPassword());
            pstmt.setString(3, user.getEmail());
            pstmt.setString(4, user.getPhone());
            pstmt.setString(5, user.getAddress());
            pstmt.setString(6, user.getCity());
            pstmt.setString(7, user.getState());
            pstmt.setString(8, user.getPincode());
            pstmt.setTimestamp(9, user.getLastLogin());
            pstmt.setString(10, user.getRole());
            pstmt.setInt(11, user.getUserid());

            pstmt.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    public void deleteUser(int userid) {

        try {
            pstmt = con.prepareStatement(DELETE);

            pstmt.setInt(1, userid);

            pstmt.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    private int getIntFallback(ResultSet rs, String col1, String col2) throws SQLException {
        try {
            return rs.getInt(col1);
        } catch (SQLException e) {
            return rs.getInt(col2);
        }
    }

    private String getStringFallback(ResultSet rs, String col1, String col2) throws SQLException {
        try {
            return rs.getString(col1);
        } catch (SQLException e) {
            try {
                return rs.getString(col2);
            } catch (SQLException ex) {
                return null;
            }
        }
    }

    private Timestamp getTimestampFallback(ResultSet rs, String col1, String col2) throws SQLException {
        try {
            return rs.getTimestamp(col1);
        } catch (SQLException e) {
            try {
                return rs.getTimestamp(col2);
            } catch (SQLException ex) {
                return null;
            }
        }
    }

    @Override
    public User getUser(int userid) {

        User user = null;

        try {
            pstmt = con.prepareStatement(GET_ONE);

            pstmt.setInt(1, userid);

            rs = pstmt.executeQuery();

            if (rs.next()) {

                user = new User(
                        getIntFallback(rs, "userid", "UserID"),
                        getStringFallback(rs, "username", "Username"),
                        getStringFallback(rs, "password", "Password"),
                        getStringFallback(rs, "email", "Email"),
                        getStringFallback(rs, "phone", "phone"),
                        getStringFallback(rs, "address", "Address"),
                        getStringFallback(rs, "city", "city"),
                        getStringFallback(rs, "state", "state"),
                        getStringFallback(rs, "pincode", "pincode"),
                        getTimestampFallback(rs, "createDate", "CreatedDate"),
                        getTimestampFallback(rs, "lastLogin", "LastLoginDate"),
                        getStringFallback(rs, "role", "Role")
                );
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return user;
    }

    @Override
    public List<User> getAllUsers() {

        List<User> users = new ArrayList<>();

        try {
            pstmt = con.prepareStatement(GET_ALL);

            rs = pstmt.executeQuery();

            while (rs.next()) {

                users.add(
                        new User(
                                getIntFallback(rs, "userid", "UserID"),
                                getStringFallback(rs, "username", "Username"),
                                getStringFallback(rs, "password", "Password"),
                                getStringFallback(rs, "email", "Email"),
                                getStringFallback(rs, "phone", "phone"),
                                getStringFallback(rs, "address", "Address"),
                                getStringFallback(rs, "city", "city"),
                                getStringFallback(rs, "state", "state"),
                                getStringFallback(rs, "pincode", "pincode"),
                                getTimestampFallback(rs, "createDate", "CreatedDate"),
                                getTimestampFallback(rs, "lastLogin", "LastLoginDate"),
                                getStringFallback(rs, "role", "Role")
                        )
                );
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return users;
    }
}