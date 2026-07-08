package com.food.dao;

import java.util.List;
import com.food.model.User;

public interface UserDao {

    void addUser(User user);

    void updateUser(User user);

    void deleteUser(int userId);

    User getUser(int userId);

    List<User> getAllUsers();
}