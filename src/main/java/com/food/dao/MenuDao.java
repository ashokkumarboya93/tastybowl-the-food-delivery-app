package com.food.dao;

import java.util.List;
import com.food.model.Menu;

public interface MenuDao {

    void addMenu(Menu menu);

    void updateMenu(Menu menu);

    void deleteMenu(int menuId);

    Menu getMenu(int menuId);

    List<Menu> getAllMenus();

    List<Menu> getMenusByRestaurantId(int restaurantId);

}