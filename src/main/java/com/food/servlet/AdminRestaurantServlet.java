package com.food.servlet;

import java.io.IOException;
import java.util.List;

import com.food.daoimp.RestaurantDaoImpl;
import com.food.model.Restaurant;
import com.food.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/admin/restaurants")
public class AdminRestaurantServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private boolean checkAdmin(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        HttpSession session = req.getSession();
        User user = (User) session.getAttribute("loggedInUser");
        if (user == null || !"admin".equalsIgnoreCase(user.getRole())) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp?errorMessage=Access Denied. Admins only.");
            return false;
        }
        return true;
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) 
            throws ServletException, IOException {
        
        if (!checkAdmin(req, resp)) return;

        String action = req.getParameter("action");
        String idStr = req.getParameter("id");
        RestaurantDaoImpl restaurantDao = new RestaurantDaoImpl();

        try {
            if ("delete".equals(action) && idStr != null) {
                int id = Integer.parseInt(idStr);
                restaurantDao.deleteRestaurant(id);
                resp.sendRedirect("restaurants?successMessage=Restaurant deleted successfully.");
                return;
            }

            if ("edit".equals(action) && idStr != null) {
                int id = Integer.parseInt(idStr);
                Restaurant restaurant = restaurantDao.getRestaurant(id);
                req.setAttribute("restaurantToEdit", restaurant);
            }

            List<Restaurant> list = restaurantDao.getAllRestaurants();
            req.setAttribute("adminRestaurantList", list);
            req.getRequestDispatcher("/admin-restaurants.jsp").forward(req, resp);

        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect("restaurants?errorMessage=An error occurred.");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) 
            throws ServletException, IOException {
        
        if (!checkAdmin(req, resp)) return;

        String action = req.getParameter("action");
        RestaurantDaoImpl restaurantDao = new RestaurantDaoImpl();

        try {
            String name = req.getParameter("name");
            String cuisineType = req.getParameter("cuisineType");
            String deliveryTimeStr = req.getParameter("deliveryTime");
            String address = req.getParameter("address");
            String imagePath = req.getParameter("imagePath");
            String isActiveStr = req.getParameter("isActive");

            if (name == null || cuisineType == null || deliveryTimeStr == null || address == null || imagePath == null ||
                name.trim().isEmpty() || cuisineType.trim().isEmpty() || address.trim().isEmpty()) {
                resp.sendRedirect("restaurants?errorMessage=Required fields are missing.");
                return;
            }

            int deliveryTime = Integer.parseInt(deliveryTimeStr);
            boolean isActive = "true".equalsIgnoreCase(isActiveStr) || "on".equalsIgnoreCase(isActiveStr);

            if ("add".equals(action)) {
                Restaurant r = new Restaurant();
                r.setName(name.trim());
                r.setCuisineType(cuisineType.trim());
                r.setDeliveryTime(deliveryTime);
                r.setAddress(address.trim());
                r.setImagePath(imagePath.trim());
                r.setRating(4.0); // Default rating for new restaurants
                r.setActive(isActive);
                r.setAdminUserId(((User) req.getSession().getAttribute("loggedInUser")).getUserid());

                restaurantDao.addRestaurant(r);
                resp.sendRedirect("restaurants?successMessage=Restaurant added successfully.");

            } else if ("update".equals(action)) {
                String idStr = req.getParameter("restaurantId");
                if (idStr == null) {
                    resp.sendRedirect("restaurants?errorMessage=Restaurant ID is required for update.");
                    return;
                }
                int restaurantId = Integer.parseInt(idStr);
                
                Restaurant r = restaurantDao.getRestaurant(restaurantId);
                if (r != null) {
                    r.setName(name.trim());
                    r.setCuisineType(cuisineType.trim());
                    r.setDeliveryTime(deliveryTime);
                    r.setAddress(address.trim());
                    r.setImagePath(imagePath.trim());
                    r.setActive(isActive);

                    restaurantDao.updateRestaurant(r);
                    resp.sendRedirect("restaurants?successMessage=Restaurant updated successfully.");
                } else {
                    resp.sendRedirect("restaurants?errorMessage=Restaurant not found.");
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect("restaurants?errorMessage=An error occurred while saving the restaurant.");
        }
    }
}
