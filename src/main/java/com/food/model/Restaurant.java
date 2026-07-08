package com.food.model;

public class Restaurant {

    private int restaurantId;
    private String name;
    private String cuisineType;
    private int deliveryTime;
    private String address;
    private String imagePath;
    private int adminUserId;
    private double rating;
    private boolean isActive;

    // Default Constructor
    public Restaurant() {

    }

    // Insert Constructor
    public Restaurant(String name,
                      String cuisineType,
                      int deliveryTime,
                      String address,
                      String imagePath,
                      int adminUserId,
                      double rating,
                      boolean isActive) {

        this.name = name;
        this.cuisineType = cuisineType;
        this.deliveryTime = deliveryTime;
        this.address = address;
        this.imagePath = imagePath;
        this.adminUserId = adminUserId;
        this.rating = rating;
        this.isActive = isActive;
    }

    // Select Constructor
    public Restaurant(int restaurantId,
                      String name,
                      String cuisineType,
                      int deliveryTime,
                      String address,
                      String imagePath,
                      int adminUserId,
                      double rating,
                      boolean isActive) {

        this.restaurantId = restaurantId;
        this.name = name;
        this.cuisineType = cuisineType;
        this.deliveryTime = deliveryTime;
        this.address = address;
        this.imagePath = imagePath;
        this.adminUserId = adminUserId;
        this.rating = rating;
        this.isActive = isActive;
    }

    public int getRestaurantId() {
        return restaurantId;
    }

    public void setRestaurantId(int restaurantId) {
        this.restaurantId = restaurantId;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getCuisineType() {
        return cuisineType;
    }

    public void setCuisineType(String cuisineType) {
        this.cuisineType = cuisineType;
    }

    public int getDeliveryTime() {
        return deliveryTime;
    }

    public void setDeliveryTime(int deliveryTime) {
        this.deliveryTime = deliveryTime;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public String getImagePath() {
        return imagePath;
    }

    public void setImagePath(String imagePath) {
        this.imagePath = imagePath;
    }

    public int getAdminUserId() {
        return adminUserId;
    }

    public void setAdminUserId(int adminUserId) {
        this.adminUserId = adminUserId;
    }

    public double getRating() {
        return rating;
    }

    public void setRating(double rating) {
        this.rating = rating;
    }

    public boolean isActive() {
        return isActive;
    }

    public void setActive(boolean active) {
        isActive = active;
    }

    @Override
    public String toString() {
        return "Restaurant [restaurantId=" + restaurantId +
                ", name=" + name +
                ", cuisineType=" + cuisineType +
                ", deliveryTime=" + deliveryTime +
                ", address=" + address +
                ", imagePath=" + imagePath +
                ", adminUserId=" + adminUserId +
                ", rating=" + rating +
                ", isActive=" + isActive +
                "]";
    }
}