package com.food.model;

import jakarta.persistence.*;

/**
 * Entity mapped to the 'restaurant' table.
 * Actual DB column for active status is IsActive (not active).
 */
@Entity
@Table(name = "restaurant")
public class Restaurant {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "RestaurantID")
    private int restaurantID;

    @Column(name = "Name", length = 100)
    private String name;

    @Column(name = "CuisineType", length = 50)
    private String cuisineType;

    @Column(name = "Address", columnDefinition = "TEXT")
    private String address;

    @Column(name = "Rating")
    private double rating;

    @Column(name = "DeliveryTime")
    private int deliveryTime;

    /** Maps to IsActive (the real DB column name) */
    @Column(name = "IsActive")
    private boolean active;

    @Column(name = "ImagePath", length = 255)
    private String imagePath;

    // ─── Constructors ──────────────────────────────────────────────────────────

    public Restaurant() {}

    public Restaurant(String name, String cuisineType, String address,
                      double rating, int deliveryTime, boolean active, String imagePath) {
        this.name         = name;
        this.cuisineType  = cuisineType;
        this.address      = address;
        this.rating       = rating;
        this.deliveryTime = deliveryTime;
        this.active       = active;
        this.imagePath    = imagePath;
    }

    // ─── Getters & Setters ─────────────────────────────────────────────────────

    public int getRestaurantID()                        { return restaurantID; }
    public void setRestaurantID(int id)                 { this.restaurantID = id; }

    public String getName()                             { return name; }
    public void setName(String name)                    { this.name = name; }

    public String getCuisineType()                      { return cuisineType; }
    public void setCuisineType(String c)                { this.cuisineType = c; }

    public String getAddress()                          { return address; }
    public void setAddress(String address)              { this.address = address; }

    public double getRating()                           { return rating; }
    public void setRating(double rating)                { this.rating = rating; }

    public int getDeliveryTime()                        { return deliveryTime; }
    public void setDeliveryTime(int deliveryTime)       { this.deliveryTime = deliveryTime; }

    public boolean isActive()                           { return active; }
    public void setActive(boolean active)               { this.active = active; }

    public String getImagePath()                        { return imagePath; }
    public void setImagePath(String imagePath)          { this.imagePath = imagePath; }

    @Override
    public String toString() {
        return "Restaurant[id=" + restaurantID + ", name=" + name + "]";
    }
}