package com.food.dao;

import java.util.List;
import com.food.model.OrderTable;

public interface OrderDao {

    int addOrder(OrderTable order);

    void updateOrder(OrderTable order);

    void deleteOrder(int orderId);

    OrderTable getOrder(int orderId);

    List<OrderTable> getAllOrders();
}