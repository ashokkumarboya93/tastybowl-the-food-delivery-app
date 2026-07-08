package com.food.dao;

import java.util.List;
import com.food.model.CartItem;

public interface CartItemDao {

    void addCartItem(CartItem cartItem);

    void updateCartItem(CartItem cartItem);

    void deleteCartItem(int cartItemId);

    CartItem getCartItem(int cartItemId);

    List<CartItem> getAllCartItems();
}