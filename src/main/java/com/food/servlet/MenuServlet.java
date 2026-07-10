package com.food.servlet;

import java.io.IOException;
import java.util.List;

import com.food.dao.MenuDAO;
import com.food.daoimpl.MenuDAOImpl;
import com.food.model.Menu;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/MenuServlet")
public class MenuServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    MenuDAO menuDAO = new MenuDAOImpl();

    @Override
    protected void doGet(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        int restaurantID =
                Integer.parseInt(request.getParameter("restaurantID"));

        List<Menu> menuList =
                menuDAO.getMenuByRestaurant(restaurantID);

        request.setAttribute("menuList", menuList);

        request.getRequestDispatcher("menu.jsp")
               .forward(request, response);
    }
}