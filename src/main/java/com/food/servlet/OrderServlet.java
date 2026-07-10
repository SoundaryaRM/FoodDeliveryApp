package com.food.servlet;

import java.io.IOException;
import java.util.List;

import com.food.dao.OrdersDAO;
import com.food.daoimpl.OrdersDAOImpl;
import com.food.model.Orders;
import com.food.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/OrderServlet")
public class OrderServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private OrdersDAO ordersDAO = new OrdersDAOImpl();

    @Override
    protected void doGet(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();

        User user = (User) session.getAttribute("loggedUser");

        if (user == null) {

            response.sendRedirect("login.jsp");
            return;
        }

        List<Orders> orders =
                ordersDAO.getOrdersByUser(user.getUserID());

        request.setAttribute("orders", orders);

        request.getRequestDispatcher("orders.jsp")
               .forward(request, response);
    }
}