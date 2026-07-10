package com.food.servlet;

import java.io.IOException;

import com.food.dao.MenuDAO;
import com.food.daoimpl.MenuDAOImpl;
import com.food.model.Cart;
import com.food.model.Menu;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 * Handles all cart operations: add, remove (decrement), removeAll, clear.
 * All actions redirect back to cart.jsp so the user sees the updated cart.
 */
@WebServlet("/CartServlet")
public class CartServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private MenuDAO menuDAO = new MenuDAOImpl();

    @Override
    protected void doGet(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();

        // Always ensure a cart exists in session
        Cart cart = (Cart) session.getAttribute("cart");
        if (cart == null) {
            cart = new Cart();
            session.setAttribute("cart", cart);
        }

        String action = request.getParameter("action");
        String menuIDParam = request.getParameter("menuID");

        if ("add".equals(action) && menuIDParam != null) {
            // ── ADD ONE unit of this menu item ──────────────────────────────
            int menuID = Integer.parseInt(menuIDParam);
            Menu menu = menuDAO.getMenuById(menuID);
            if (menu != null && menu.isAvailable()) {
                cart.addItem(menu);          // adds 1, or increments if already present
            }

        } else if ("remove".equals(action) && menuIDParam != null) {
            // ── DECREMENT by 1 (Cart.removeItem decrements, fully removes at 0) ─
            int menuID = Integer.parseInt(menuIDParam);
            cart.removeItem(menuID);         // implemented below — decrements by 1

        } else if ("removeAll".equals(action) && menuIDParam != null) {
            // ── REMOVE entire line item regardless of quantity ───────────────
            int menuID = Integer.parseInt(menuIDParam);
            cart.removeItemCompletely(menuID);

        } else if ("clear".equals(action)) {
            // ── CLEAR the whole cart ─────────────────────────────────────────
            cart.clearCart();
        }

        response.sendRedirect("cart.jsp");
    }
}