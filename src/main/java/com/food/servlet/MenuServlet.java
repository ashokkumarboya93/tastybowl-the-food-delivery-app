package com.food.servlet;

import java.io.IOException;
import java.util.List;

import com.food.daoimp.MenuDaoImpl;
import com.food.model.Menu;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/menu")
public class MenuServlet extends HttpServlet{
	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		MenuDaoImpl menuDAOImpl = new MenuDaoImpl();

			int restaurantID = Integer.parseInt(req.getParameter("restaurantID"));
//			System.out.println("Menu Servlet Called");
			List<Menu> allMenusByRestaurant = menuDAOImpl.getMenusByRestaurantId(restaurantID);
			req.setAttribute("allMenusByRestaurant", allMenusByRestaurant);
			RequestDispatcher rd = req.getRequestDispatcher("menu.jsp");
			rd.forward(req, resp);
			
			
			
	}

}
