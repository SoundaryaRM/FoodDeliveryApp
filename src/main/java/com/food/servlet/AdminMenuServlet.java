package com.food.servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

import com.food.dao.AdminDAO;
import com.food.daoimpl.AdminDAOImpl;
import com.food.model.Menu;
import com.food.model.Restaurant;
import com.food.model.User;

@WebServlet("/AdminMenuServlet")
public class AdminMenuServlet extends HttpServlet {

    private final AdminDAO adminDAO = new AdminDAOImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        if (!isAdmin(req, resp)) return;
        req.setAttribute("menuItems",   adminDAO.getAllMenuItems());
        req.setAttribute("restaurants", adminDAO.getAllRestaurants());
        req.getRequestDispatcher("admin-menu.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        if (!isAdmin(req, resp)) return;

        String action = req.getParameter("action");

        if ("delete".equals(action)) {
            int id = Integer.parseInt(req.getParameter("menuID"));
            adminDAO.deleteMenuItem(id);

        } else if ("add".equals(action)) {
            Menu m = new Menu();
            int rid = Integer.parseInt(req.getParameter("restaurantID"));
            m.setRestaurant(adminDAO.getRestaurantById(rid));
            m.setItemName(req.getParameter("itemName"));
            m.setDescription(req.getParameter("description"));
            m.setCategory(req.getParameter("category"));
            m.setPrice(Double.parseDouble(req.getParameter("price")));
            m.setAvailable(true);
            m.setImagePath(req.getParameter("imagePath"));
            adminDAO.addMenuItem(m);

        } else if ("update".equals(action)) {
            int id = Integer.parseInt(req.getParameter("menuID"));
            Menu m = adminDAO.getMenuItemById(id);
            if (m != null) {
                int rid = Integer.parseInt(req.getParameter("restaurantID"));
                m.setRestaurant(adminDAO.getRestaurantById(rid));
                m.setItemName(req.getParameter("itemName"));
                m.setDescription(req.getParameter("description"));
                m.setCategory(req.getParameter("category"));
                m.setPrice(Double.parseDouble(req.getParameter("price")));
                m.setAvailable("true".equals(req.getParameter("available")));
                m.setImagePath(req.getParameter("imagePath"));
                adminDAO.updateMenuItem(m);
            }
        } else if ("toggle".equals(action)) {
            int id = Integer.parseInt(req.getParameter("menuID"));
            Menu m = adminDAO.getMenuItemById(id);
            if (m != null) {
                m.setAvailable(!m.isAvailable());
                adminDAO.updateMenuItem(m);
            }
        }

        resp.sendRedirect("AdminMenuServlet");
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
