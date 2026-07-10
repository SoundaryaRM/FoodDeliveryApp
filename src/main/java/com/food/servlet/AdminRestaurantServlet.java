package com.food.servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

import com.food.dao.AdminDAO;
import com.food.daoimpl.AdminDAOImpl;
import com.food.model.Restaurant;
import com.food.model.User;

@WebServlet("/AdminRestaurantServlet")
public class AdminRestaurantServlet extends HttpServlet {

    private final AdminDAO adminDAO = new AdminDAOImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        if (!isAdmin(req, resp)) return;
        req.setAttribute("restaurants", adminDAO.getAllRestaurants());
        req.getRequestDispatcher("admin-restaurants.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        if (!isAdmin(req, resp)) return;

        String action = req.getParameter("action");

        if ("delete".equals(action)) {
            int id = Integer.parseInt(req.getParameter("restaurantID"));
            adminDAO.deleteRestaurant(id);

        } else if ("add".equals(action)) {
            Restaurant r = new Restaurant();
            r.setName(req.getParameter("name"));
            r.setCuisineType(req.getParameter("cuisineType"));
            r.setAddress(req.getParameter("address"));
            r.setRating(Double.parseDouble(req.getParameter("rating")));
            r.setDeliveryTime(Integer.parseInt(req.getParameter("deliveryTime")));
            r.setActive(true);
            r.setImagePath(req.getParameter("imagePath"));
            adminDAO.addRestaurant(r);

        } else if ("update".equals(action)) {
            int id = Integer.parseInt(req.getParameter("restaurantID"));
            Restaurant r = adminDAO.getRestaurantById(id);
            if (r != null) {
                r.setName(req.getParameter("name"));
                r.setCuisineType(req.getParameter("cuisineType"));
                r.setAddress(req.getParameter("address"));
                r.setRating(Double.parseDouble(req.getParameter("rating")));
                r.setDeliveryTime(Integer.parseInt(req.getParameter("deliveryTime")));
                r.setActive("true".equals(req.getParameter("active")));
                r.setImagePath(req.getParameter("imagePath"));
                adminDAO.updateRestaurant(r);
            }
        }

        resp.sendRedirect("AdminRestaurantServlet");
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
