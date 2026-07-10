package com.food.model;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;

/**
 * Entity mapped to the 'orderitem' table.
 *
 * Represents one line item inside an order (which Menu item, how many, sub-total).
 */
@Entity
@Table(name = "orderitem")
public class OrderItem {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY) // AUTO_INCREMENT in MySQL
    @Column(name = "OrderItemID")
    private int orderItemID;

    /** The parent order this line item belongs to. */
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "OrderID", nullable = false)
    private Orders order;

    /** The menu item that was ordered. */
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "MenuID", nullable = false)
    private Menu menu;

    @Column(name = "Quantity", nullable = false)
    private int quantity;

    /** Price × quantity at the time of ordering (snapshot — may differ from current price). */
    @Column(name = "ItemTotal", nullable = false)
    private double itemTotal;

    // ─── Constructors ──────────────────────────────────────────────────────────

    public OrderItem() {
    }

    /** Convenience constructor — ID is auto-generated. */
    public OrderItem(Orders order, Menu menu, int quantity, double itemTotal) {
        this.order = order;
        this.menu = menu;
        this.quantity = quantity;
        this.itemTotal = itemTotal;
    }

    // ─── Getters & Setters ─────────────────────────────────────────────────────

    public int getOrderItemID() {
        return orderItemID;
    }

    public void setOrderItemID(int orderItemID) {
        this.orderItemID = orderItemID;
    }

    public Orders getOrder() {
        return order;
    }

    public void setOrder(Orders order) {
        this.order = order;
    }

    public Menu getMenu() {
        return menu;
    }

    public void setMenu(Menu menu) {
        this.menu = menu;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public double getItemTotal() {
        return itemTotal;
    }

    public void setItemTotal(double itemTotal) {
        this.itemTotal = itemTotal;
    }

    // ─── toString ──────────────────────────────────────────────────────────────

    @Override
    public String toString() {
        return "OrderItem [orderItemID=" + orderItemID
                + ", quantity=" + quantity
                + ", itemTotal=" + itemTotal + "]";
    }
}