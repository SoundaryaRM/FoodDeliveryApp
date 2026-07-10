package com.food.servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

import com.food.dao.AdminDAO;
import com.food.daoimpl.AdminDAOImpl;
import com.food.model.User;

@WebServlet("/AdminOrderServlet")
public class AdminOrderServlet extends HttpServlet {

    private final AdminDAO adminDAO = new AdminDAOImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        if (!isAdmin(req, resp)) return;
        req.setAttribute("orders", adminDAO.getAllOrders());
        req.getRequestDispatcher("admin-orders.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        if (!isAdmin(req, resp)) return;

        String action = req.getParameter("action");

        if ("updateStatus".equals(action)) {
            int    id     = Integer.parseInt(req.getParameter("orderID"));
            String status = req.getParameter("status");
            adminDAO.updateOrderStatus(id, status);

        } else if ("delete".equals(action)) {
            int id = Integer.parseInt(req.getParameter("orderID"));
            adminDAO.deleteOrder(id);
        }

        resp.sendRedirect("AdminOrderServlet");
    }

    private boolean isAdmin(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        User admin = (User) req.getSession().getAttribute("loggedUser");
        if (admin == null || !"ADMIN".equalsIgnoreCase(admin.getRole())) {
            resp.sendRedirect("login.jsp");
            return false;
        }
        return true;
    }
}
