package com.food.model;

import java.time.LocalDateTime;

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
 * Entity mapped to the 'ordertable' table.
 *
 * Each order belongs to one User and one Restaurant.
 */
@Entity
@Table(name = "ordertable")
public class Orders {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY) // AUTO_INCREMENT in MySQL
    @Column(name = "OrderID")
    private int orderID;

    /** The customer who placed this order. */
    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "UserID", nullable = false)
    private User user;

    /** The restaurant this order was placed at. */
    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "RestaurantID", nullable = false)
    private Restaurant restaurant;

    @Column(name = "OrderDate", nullable = false)
    private LocalDateTime orderDate;

    @Column(name = "TotalAmount", nullable = false)
    private double totalAmount;

    /**
     * Order lifecycle status.
     * Suggested values: PENDING, CONFIRMED, PREPARING, OUT_FOR_DELIVERY, DELIVERED, CANCELLED
     */
    @Column(name = "Status", length = 30)
    private String status;

    @Column(name = "PaymentMethod", length = 30)
    private String paymentMethod;

    // ─── Constructors ──────────────────────────────────────────────────────────

    public Orders() {
    }

    /** Convenience constructor — ID is auto-generated. */
    public Orders(User user, Restaurant restaurant, LocalDateTime orderDate,
                  double totalAmount, String status, String paymentMethod) {
        this.user = user;
        this.restaurant = restaurant;
        this.orderDate = orderDate;
        this.totalAmount = totalAmount;
        this.status = status;
        this.paymentMethod = paymentMethod;
    }

    // ─── Getters & Setters ─────────────────────────────────────────────────────

    public int getOrderID() {
        return orderID;
    }

    public void setOrderID(int orderID) {
        this.orderID = orderID;
    }

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }

    public Restaurant getRestaurant() {
        return restaurant;
    }

    public void setRestaurant(Restaurant restaurant) {
        this.restaurant = restaurant;
    }

    public LocalDateTime getOrderDate() {
        return orderDate;
    }

    /** 
     * Helper for JSTL formatting (since fmt:formatDate doesn't support LocalDateTime).
     * Usage in JSP: value="${o.orderDateAsDate}"
     */
    public java.util.Date getOrderDateAsDate() {
        if (orderDate == null) return null;
        return java.util.Date.from(orderDate.atZone(java.time.ZoneId.systemDefault()).toInstant());
    }

    public void setOrderDate(LocalDateTime orderDate) {
        this.orderDate = orderDate;
    }

    public double getTotalAmount() {
        return totalAmount;
    }

    public void setTotalAmount(double totalAmount) {
        this.totalAmount = totalAmount;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getPaymentMethod() {
        return paymentMethod;
    }

    public void setPaymentMethod(String paymentMethod) {
        this.paymentMethod = paymentMethod;
    }

    // ─── toString ──────────────────────────────────────────────────────────────

    @Override
    public String toString() {
        return "Orders [orderID=" + orderID
                + ", status=" + status
                + ", totalAmount=" + totalAmount
                + ", orderDate=" + orderDate + "]";
    }
}