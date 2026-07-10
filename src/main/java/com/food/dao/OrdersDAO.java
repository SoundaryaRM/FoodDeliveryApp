package com.food.dao;

import java.util.List;

import com.food.model.Orders;

/**
 * DAO contract for {@link Orders} persistence operations.
 */
public interface OrdersDAO {

    /**
     * Persists a new Order. ID is auto-generated.
     *
     * @param order the transient Orders object to save
     */
    void placeOrder(Orders order);

    /**
     * Merges (updates) an existing Order (e.g., to change status).
     *
     * @param order the detached Orders object with updated fields
     */
    void updateOrder(Orders order);

    /**
     * Convenience method to update only the status of an order.
     *
     * @param orderID   the primary key of the order
     * @param newStatus the new status value (e.g., "DELIVERED")
     */
    void updateOrderStatus(int orderID, String newStatus);

    /**
     * Removes the order from the database. In practice consider changing
     * the status to CANCELLED instead of physically deleting.
     *
     * @param orderID the primary key
     */
    void cancelOrder(int orderID);

    /**
     * Returns the Order for a given primary key, or {@code null} if not found.
     *
     * @param orderID the primary key
     */
    Orders getOrderById(int orderID);

    /**
     * Returns all Orders placed by a specific user, newest first.
     *
     * @param userID the user's primary key
     */
    List<Orders> getOrdersByUser(int userID);

    /**
     * Returns all Orders in the system (admin use), newest first.
     */
    List<Orders> getAllOrders();

    /**
     * Returns the most recent {@code limit} orders (admin dashboard widget).
     *
     * @param limit maximum number of orders to return
     */
    List<Orders> getRecentOrders(int limit);
}