package com.food.dao;

import java.util.List;
import com.food.model.User;
import com.food.model.Restaurant;
import com.food.model.Menu;
import com.food.model.Orders;

/**
 * Admin DAO — all operations available to the admin panel.
 * Covers: Users, Restaurants, Menu Items, Orders (full CRUD + stats).
 */
public interface AdminDAO {

    // ══════════════════════════════════════════════
    //  USER MANAGEMENT
    // ══════════════════════════════════════════════

    List<User>  getAllUsers();
    User        getUserById(int userID);
    void        updateUser(User user);
    void        deleteUser(int userID);
    long        countUsers();

    // ══════════════════════════════════════════════
    //  RESTAURANT MANAGEMENT
    // ══════════════════════════════════════════════

    List<Restaurant> getAllRestaurants();
    Restaurant       getRestaurantById(int restaurantID);
    void             addRestaurant(Restaurant restaurant);
    void             updateRestaurant(Restaurant restaurant);
    void             deleteRestaurant(int restaurantID);
    long             countRestaurants();

    // ══════════════════════════════════════════════
    //  MENU MANAGEMENT
    // ══════════════════════════════════════════════

    List<Menu>  getAllMenuItems();
    Menu        getMenuItemById(int menuID);
    void        addMenuItem(Menu menu);
    void        updateMenuItem(Menu menu);
    void        deleteMenuItem(int menuID);
    long        countMenuItems();

    // ══════════════════════════════════════════════
    //  ORDER MANAGEMENT
    // ══════════════════════════════════════════════

    List<Orders> getAllOrders();
    Orders       getOrderById(int orderID);
    void         updateOrderStatus(int orderID, String status);
    void         deleteOrder(int orderID);
    long         countOrders();
    double       getTotalRevenue();
}
