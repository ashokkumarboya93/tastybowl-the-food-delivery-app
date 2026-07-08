package com.food.servlet;

import java.io.IOException;
import java.util.List;

import com.food.daoimp.RestaurantDaoImpl;
import com.food.model.Restaurant;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/callRestaurantServlet")
public class RestaurantServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest req,
                         HttpServletResponse res)
            throws ServletException, IOException {

        try {

            RestaurantDaoImpl restaurantDAO = new RestaurantDaoImpl();

            List<Restaurant> allRestaurant = restaurantDAO.getAllRestaurants();

            req.setAttribute("allRestaurant", allRestaurant);

            RequestDispatcher rd =
                    req.getRequestDispatcher("restaurant.jsp");

            rd.forward(req, res);
            

        } catch (Exception e) {
            e.printStackTrace();
            throw new ServletException("Error Fetching Restaurants: " + e.getMessage(), e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        doGet(request, response);

    }

}