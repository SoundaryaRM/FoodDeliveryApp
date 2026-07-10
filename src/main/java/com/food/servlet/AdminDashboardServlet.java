package com.food.servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

import com.food.dao.AdminDAO;
import com.food.daoimpl.AdminDAOImpl;
import com.food.model.User;

@WebServlet("/AdminDashboardServlet")
public class AdminDashboardServlet extends HttpServlet {

    private final AdminDAO adminDAO = new AdminDAOImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // Admin guard
        User admin = (User) req.getSession().getAttribute("loggedUser");
        if (admin == null || !"ADMIN".equalsIgnoreCase(admin.getRole())) {
            resp.sendRedirect("login.jsp");
            return;
        }

        // Load all stats for the dashboard
        req.setAttribute("userCount",       adminDAO.countUsers());
        req.setAttribute("restaurantCount", adminDAO.countRestaurants());
        req.setAttribute("menuCount",       adminDAO.countMenuItems());
        req.setAttribute("orderCount",      adminDAO.countOrders());
        req.setAttribute("totalRevenue",    adminDAO.getTotalRevenue());
        req.setAttribute("recentOrders",    adminDAO.getAllOrders()
                .stream().limit(5).toList());

        req.getRequestDispatcher("admin-dashboard.jsp").forward(req, resp);
    }
}
