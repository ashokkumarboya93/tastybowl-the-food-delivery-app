package com.food.dao;

import java.util.List;
import com.food.model.Restaurant;

public interface RestaurantDao {

    void addRestaurant(Restaurant restaurant);

    void updateRestaurant(Restaurant restaurant);

    void deleteRestaurant(int restaurantId);

    Restaurant getRestaurant(int restaurantId);

    List<Restaurant> getAllRestaurants();
}