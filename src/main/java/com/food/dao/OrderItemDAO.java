package com.food.dao;

import java.util.List;

import com.food.model.OrderItem;

/**
 * DAO contract for {@link OrderItem} persistence operations.
 */
public interface OrderItemDAO {

    /**
     * Persists a new OrderItem. ID is auto-generated.
     *
     * @param item the transient OrderItem to save
     */
    void addOrderItem(OrderItem item);

    /**
     * Merges (updates) an existing OrderItem.
     *
     * @param item the detached OrderItem with updated fields
     */
    void updateOrderItem(OrderItem item);

    /**
     * Deletes the OrderItem with the given ID. No-op if not found.
     *
     * @param orderItemID the primary key
     */
    void deleteOrderItem(int orderItemID);

    /**
     * Returns the OrderItem for a given primary key, or {@code null} if not found.
     *
     * @param orderItemID the primary key
     */
    OrderItem getOrderItemById(int orderItemID);

    /**
     * Returns all line items belonging to a specific order.
     *
     * @param orderID the order's primary key
     */
    List<OrderItem> getItemsByOrder(int orderID);

    /**
     * Deletes all line items for a given order (used when cancelling an order).
     *
     * @param orderID the order's primary key
     */
    void deleteItemsByOrder(int orderID);
}