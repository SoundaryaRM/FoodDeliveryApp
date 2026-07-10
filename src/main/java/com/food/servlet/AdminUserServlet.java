package com.food.servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

import com.food.dao.AdminDAO;
import com.food.daoimpl.AdminDAOImpl;
import com.food.model.User;

@WebServlet("/AdminUserServlet")
public class AdminUserServlet extends HttpServlet {

    private final AdminDAO adminDAO = new AdminDAOImpl();

    /** GET → list all users */
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        if (!isAdmin(req, resp)) return;

        req.setAttribute("users", adminDAO.getAllUsers());
        req.getRequestDispatcher("admin-users.jsp").forward(req, resp);
    }

    /** POST → handle edit / delete actions */
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        if (!isAdmin(req, resp)) return;

        String action = req.getParameter("action");

        if ("delete".equals(action)) {
            int id = Integer.parseInt(req.getParameter("userID"));
            adminDAO.deleteUser(id);

        } else if ("update".equals(action)) {
            int    id       = Integer.parseInt(req.getParameter("userID"));
            String username = req.getParameter("username");
            String email    = req.getParameter("email");
            String role     = req.getParameter("role");
            String address  = req.getParameter("address");

            User u = adminDAO.getUserById(id);
            if (u != null) {
                u.setUsername(username);
                u.setEmail(email);
                u.setRole(role);
                u.setAddress(address);
                adminDAO.updateUser(u);
            }
        }

        resp.sendRedirect("AdminUserServlet");
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
