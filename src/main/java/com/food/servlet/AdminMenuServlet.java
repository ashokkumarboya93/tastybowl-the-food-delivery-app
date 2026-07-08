package com.food.servlet;

import java.io.IOException;
import java.util.List;

import com.food.daoimp.MenuDaoImpl;
import com.food.daoimp.RestaurantDaoImpl;
import com.food.model.Menu;
import com.food.model.Restaurant;
import com.food.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/admin/menu")
public class AdminMenuServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private boolean checkAdmin(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        HttpSession session = req.getSession();
        User user = (User) session.getAttribute("loggedInUser");
        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp?errorMessage=Please log in first.");
            return false;
        }
        String role = user.getRole();
        if (!"admin".equalsIgnoreCase(role) && !"restaurant_admin".equalsIgnoreCase(role)) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp?errorMessage=Access Denied. Admins and Restaurant Admins only.");
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
        String restaurantIdStr = req.getParameter("restaurantId");
        
        MenuDaoImpl menuDao = new MenuDaoImpl();
        RestaurantDaoImpl restaurantDao = new RestaurantDaoImpl();

        try {
            if ("delete".equals(action) && idStr != null) {
                int id = Integer.parseInt(idStr);
                Menu item = menuDao.getMenu(id);
                int rId = item != null ? item.getRestaurantId() : 0;
                menuDao.deleteMenu(id);
                resp.sendRedirect("menu?restaurantId=" + rId + "&successMessage=Menu item deleted successfully.");
                return;
            }

            int currentRestaurantId = 0;
            if (restaurantIdStr != null && !restaurantIdStr.trim().isEmpty()) {
                currentRestaurantId = Integer.parseInt(restaurantIdStr);
            } else {
                List<Restaurant> restaurants = restaurantDao.getAllRestaurants();
                if (!restaurants.isEmpty()) {
                    currentRestaurantId = restaurants.get(0).getRestaurantId();
                }
            }

            if ("edit".equals(action) && idStr != null) {
                int id = Integer.parseInt(idStr);
                Menu item = menuDao.getMenu(id);
                req.setAttribute("menuToEdit", item);
                if (item != null) {
                    currentRestaurantId = item.getRestaurantId();
                }
            }

            List<Menu> list = menuDao.getMenusByRestaurantId(currentRestaurantId);
            List<Restaurant> allRestaurants = restaurantDao.getAllRestaurants();

            req.setAttribute("adminMenuList", list);
            req.setAttribute("allRestaurants", allRestaurants);
            req.setAttribute("currentRestaurantId", currentRestaurantId);

            req.getRequestDispatcher("/admin-menu.jsp").forward(req, resp);

        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect("menu?errorMessage=An error occurred.");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) 
            throws ServletException, IOException {
        
        if (!checkAdmin(req, resp)) return;

        String action = req.getParameter("action");
        MenuDaoImpl menuDao = new MenuDaoImpl();

        int restaurantId = 0;
        try {
            String restaurantIdStr = req.getParameter("restaurantId");
            String itemName = req.getParameter("itemName");
            String description = req.getParameter("description");
            String priceStr = req.getParameter("price");
            String imagePath = req.getParameter("imagePath");
            String isAvailableStr = req.getParameter("isAvailable");
            String category = req.getParameter("category");

            if (restaurantIdStr == null || itemName == null || priceStr == null || imagePath == null || category == null ||
                itemName.trim().isEmpty() || priceStr.trim().isEmpty() || category.trim().isEmpty()) {
                resp.sendRedirect("menu?errorMessage=Required fields are missing.");
                return;
            }

            restaurantId = Integer.parseInt(restaurantIdStr);
            double price = Double.parseDouble(priceStr);
            boolean isAvailable = "true".equalsIgnoreCase(isAvailableStr) || "on".equalsIgnoreCase(isAvailableStr);

            if ("add".equals(action)) {
                Menu m = new Menu();
                m.setRestaurantId(restaurantId);
                m.setItemName(itemName.trim());
                m.setDescription(description != null ? description.trim() : "");
                m.setPrice(price);
                m.setImagePath(imagePath.trim());
                m.setAvailable(isAvailable);
                m.setCategory(category.trim());
                m.setRating(4.0); // Default rating

                menuDao.addMenu(m);
                resp.sendRedirect("menu?restaurantId=" + restaurantId + "&successMessage=Menu item added successfully.");

            } else if ("update".equals(action)) {
                String idStr = req.getParameter("menuId");
                if (idStr == null) {
                    resp.sendRedirect("menu?errorMessage=Menu ID is required for update.");
                    return;
                }
                int menuId = Integer.parseInt(idStr);
                
                Menu m = menuDao.getMenu(menuId);
                if (m != null) {
                    m.setRestaurantId(restaurantId);
                    m.setItemName(itemName.trim());
                    m.setDescription(description != null ? description.trim() : "");
                    m.setPrice(price);
                    m.setImagePath(imagePath.trim());
                    m.setAvailable(isAvailable);
                    m.setCategory(category.trim());

                    menuDao.updateMenu(m);
                    resp.sendRedirect("menu?restaurantId=" + restaurantId + "&successMessage=Menu item updated successfully.");
                } else {
                    resp.sendRedirect("menu?restaurantId=" + restaurantId + "&errorMessage=Menu item not found.");
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect("menu?restaurantId=" + restaurantId + "&errorMessage=An error occurred while saving the menu item.");
        }
    }
}
