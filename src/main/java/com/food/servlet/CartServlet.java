package com.food.servlet;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

import com.food.daoimp.MenuDaoImpl;
import com.food.model.CartItem;
import com.food.model.Menu;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/cart")
public class CartServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) 
            throws ServletException, IOException {
        // Forward to cart page
        req.getRequestDispatcher("cart.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) 
            throws ServletException, IOException {
        
        HttpSession session = req.getSession();
        
        // Get or create the session cart (Map of menuId -> CartItem)
        @SuppressWarnings("unchecked")
        Map<Integer, CartItem> cart = (Map<Integer, CartItem>) session.getAttribute("cart");
        if (cart == null) {
            cart = new HashMap<>();
            session.setAttribute("cart", cart);
        }

        String action = req.getParameter("action");
        String menuIdStr = req.getParameter("menuId");
        
        MenuDaoImpl menuDao = new MenuDaoImpl();

        try {
            if ("clear".equals(action)) {
                cart.clear();
                session.removeAttribute("cartRestaurantId");
                resp.sendRedirect("cart.jsp");
                return;
            }

            if (menuIdStr == null || menuIdStr.trim().isEmpty()) {
                resp.sendRedirect("cart.jsp");
                return;
            }

            int menuId = Integer.parseInt(menuIdStr);
            Menu menu = menuDao.getMenu(menuId);

            if (menu == null) {
                resp.sendRedirect("cart.jsp");
                return;
            }

            int itemRestaurantId = menu.getRestaurantId();
            Integer cartRestaurantId = (Integer) session.getAttribute("cartRestaurantId");

            boolean isAjax = "true".equals(req.getParameter("isAjax"));

            if ("add".equals(action)) {
                // Restaurant Validation
                boolean cartReset = false;
                if (cartRestaurantId != null && cartRestaurantId != itemRestaurantId) {
                    // Different restaurant! Reset the cart
                    cart.clear();
                    session.setAttribute("cartRestaurantId", itemRestaurantId);
                    session.setAttribute("cartMessage", "Your cart was reset because you added items from a different restaurant.");
                    cartReset = true;
                } else if (cartRestaurantId == null) {
                    session.setAttribute("cartRestaurantId", itemRestaurantId);
                }

                // Add item
                CartItem item = cart.get(menuId);
                if (item == null) {
                    item = new CartItem();
                    item.setMenuId(menuId);
                    item.setQuantity(1);
                    item.setTotalPrice(menu.getPrice());
                    cart.put(menuId, item);
                } else {
                    item.setQuantity(item.getQuantity() + 1);
                    item.setTotalPrice(item.getQuantity() * menu.getPrice());
                }

                if (isAjax) {
                    int totalItems = 0;
                    for (CartItem ci : cart.values()) {
                        totalItems += ci.getQuantity();
                    }
                    resp.setContentType("application/json");
                    resp.setCharacterEncoding("UTF-8");
                    String msg = cartReset ? "Cart reset for new restaurant. Item added!" : "Item added to cart!";
                    resp.getWriter().write("{\"success\": true, \"cartItemCount\": " + totalItems + ", \"message\": \"" + msg + "\"}");
                    return;
                }

                // Redirect back to menu of the restaurant
                resp.sendRedirect("menu?restaurantID=" + itemRestaurantId + "&successMessage=Item added to cart.");
                return;

            } else if ("update".equals(action)) {
                String quantityStr = req.getParameter("quantity");
                if (quantityStr != null) {
                    int quantity = Integer.parseInt(quantityStr);
                    CartItem item = cart.get(menuId);
                    if (item != null) {
                        if (quantity <= 0) {
                            cart.remove(menuId);
                        } else {
                            item.setQuantity(quantity);
                            item.setTotalPrice(quantity * menu.getPrice());
                        }
                    }
                }
                
                // If cart becomes empty, clear restaurant ID
                if (cart.isEmpty()) {
                    session.removeAttribute("cartRestaurantId");
                }
                
                resp.sendRedirect("cart.jsp");
                return;

            } else if ("delete".equals(action)) {
                cart.remove(menuId);
                
                // If cart becomes empty, clear restaurant ID
                if (cart.isEmpty()) {
                    session.removeAttribute("cartRestaurantId");
                }
                
                resp.sendRedirect("cart.jsp");
                return;
            }

        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect("cart.jsp?errorMessage=An error occurred while updating the cart.");
        }
    }
}
