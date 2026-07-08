package com.food.dao;

import java.util.List;
import com.food.model.Cart;

public interface CartDao {

    void addCart(Cart cart);

    void updateCart(Cart cart);

    void deleteCart(int cartId);

    Cart getCart(int cartId);

    List<Cart> getAllCarts();
}