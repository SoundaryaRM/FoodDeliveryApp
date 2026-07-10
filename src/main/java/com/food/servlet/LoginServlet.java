package com.food.servlet;

import java.io.IOException;
import java.time.LocalDateTime;
import java.util.Optional;

import com.food.dao.UserDAO;
import com.food.daoimpl.UserDAOImpl;
import com.food.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private UserDAO userDAO = new UserDAOImpl();

    @Override
    protected void doPost(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        String email    = request.getParameter("email");
        String password = request.getParameter("password");

        System.out.println("[LoginServlet] Attempting login: " + email);

        try {
            Optional<User> result = userDAO.login(email, password);

            if (result.isPresent()) {
                User user = result.get();
                System.out.println("[LoginServlet] Login SUCCESS: " + user.getUsername() + " role=" + user.getRole());

                // Update last login date
                user.setLastLoginDate(LocalDateTime.now());
                try { userDAO.updateUser(user); } catch (Exception ignored) {}

                HttpSession session = request.getSession(true);
                session.setAttribute("loggedUser", user);
                session.setAttribute("userId",     user.getUserID());
                session.setAttribute("userName",   user.getUsername());

                // Route by role
                String role = user.getRole();
                if ("ADMIN".equalsIgnoreCase(role)) {
                    response.sendRedirect("AdminDashboardServlet");
                } else {
                    response.sendRedirect("RestaurantServlet");
                }

            } else {
                System.out.println("[LoginServlet] Login FAILED — no user found for: " + email);
                request.setAttribute("error", "Invalid email or password. Please try again.");
                request.getRequestDispatcher("login.jsp").forward(request, response);
            }

        } catch (Exception e) {
            System.err.println("[LoginServlet] EXCEPTION: " + e.getMessage());
            e.printStackTrace();
            // Show the real error on the login page (dev mode)
            request.setAttribute("error", "Login error: " + e.getMessage() + " — Check Tomcat console log.");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }
}