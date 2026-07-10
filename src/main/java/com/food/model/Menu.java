package com.food.model;

import jakarta.persistence.*;

/**
 * Entity mapped to the 'menu' table.
 * Actual DB column for availability is IsAvailable (not available).
 */
@Entity
@Table(name = "menu")
public class Menu {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "MenuID")
    private int menuID;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "RestaurantID")
    private Restaurant restaurant;

    @Column(name = "ItemName", length = 100)
    private String itemName;

    @Column(name = "Description", columnDefinition = "TEXT")
    private String description;

    /** Maps to the Category column added by our ALTER TABLE */
    @Column(name = "Category", length = 50)
    private String category;

    @Column(name = "Price", nullable = false)
    private double price;

    /** Maps to IsAvailable (the real DB column name) */
    @Column(name = "IsAvailable")
    private boolean available;

    @Column(name = "ImagePath", length = 255)
    private String imagePath;

    // ─── Constructors ──────────────────────────────────────────────────────────

    public Menu() {}

    public Menu(Restaurant restaurant, String itemName, String description,
                String category, double price, boolean available, String imagePath) {
        this.restaurant  = restaurant;
        this.itemName    = itemName;
        this.description = description;
        this.category    = category;
        this.price       = price;
        this.available   = available;
        this.imagePath   = imagePath;
    }

    // ─── Getters & Setters ─────────────────────────────────────────────────────

    public int getMenuID()                         { return menuID; }
    public void setMenuID(int menuID)              { this.menuID = menuID; }

    public Restaurant getRestaurant()              { return restaurant; }
    public void setRestaurant(Restaurant r)        { this.restaurant = r; }

    public String getItemName()                    { return itemName; }
    public void setItemName(String itemName)       { this.itemName = itemName; }

    public String getDescription()                 { return description; }
    public void setDescription(String d)           { this.description = d; }

    public String getCategory()                    { return category; }
    public void setCategory(String category)       { this.category = category; }

    public double getPrice()                       { return price; }
    public void setPrice(double price)             { this.price = price; }

    public boolean isAvailable()                   { return available; }
    public void setAvailable(boolean available)    { this.available = available; }

    public String getImagePath()                   { return imagePath; }
    public void setImagePath(String imagePath)     { this.imagePath = imagePath; }

    @Override
    public String toString() {
        return "Menu[id=" + menuID + ", name=" + itemName + ", price=" + price + "]";
    }
}