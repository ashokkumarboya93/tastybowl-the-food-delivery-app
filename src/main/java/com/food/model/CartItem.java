package com.food.model;

public class CartItem {

    private int cartItemId;
    private int cartId;
    private int menuId;
    private int quantity;
    private double totalPrice;

    public CartItem() {
    }

    public CartItem(int cartItemId, int cartId,
                    int menuId, int quantity, double totalPrice) {

        this.cartItemId = cartItemId;
        this.cartId = cartId;
        this.menuId = menuId;
        this.quantity = quantity;
        this.totalPrice = totalPrice;
    }

    public int getCartItemId() {
        return cartItemId;
    }

    public void setCartItemId(int cartItemId) {
        this.cartItemId = cartItemId;
    }

    public int getCartId() {
        return cartId;
    }

    public void setCartId(int cartId) {
        this.cartId = cartId;
    }

    public int getMenuId() {
        return menuId;
    }

    public void setMenuId(int menuId) {
        this.menuId = menuId;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public double getTotalPrice() {
        return totalPrice;
    }

    public void setTotalPrice(double totalPrice) {
        this.totalPrice = totalPrice;
    }

    @Override
    public String toString() {
        return "CartItem [cartItemId=" + cartItemId +
                ", cartId=" + cartId +
                ", menuId=" + menuId +
                ", quantity=" + quantity +
                ", totalPrice=" + totalPrice + "]";
    }
}