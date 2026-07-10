package com.food.servlet;

import java.io.IOException;
import java.util.List;

import com.food.dao.RestaurantDAO;
import com.food.daoimpl.RestaurantDAOImpl;
import com.food.model.Restaurant;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/RestaurantServlet")
public class RestaurantServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    RestaurantDAO restaurantDAO = new RestaurantDAOImpl();

    @Override
    protected void doGet(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        List<Restaurant> restaurants =
                restaurantDAO.getActiveRestaurants();

        request.setAttribute("restaurants", restaurants);

        request.getRequestDispatcher("restaurant.jsp")
               .forward(request, response);
    }
}