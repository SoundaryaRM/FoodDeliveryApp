package com.food.dao;

import java.util.List;

import com.food.model.Restaurant;

/**
 * DAO contract for {@link Restaurant} persistence operations.
 */
public interface RestaurantDAO {

    /**
     * Persists a new Restaurant. ID is auto-generated.
     *
     * @param restaurant the transient Restaurant to save
     */
    void addRestaurant(Restaurant restaurant);

    /**
     * Merges (updates) an existing Restaurant.
     *
     * @param restaurant the detached Restaurant with updated fields
     */
    void updateRestaurant(Restaurant restaurant);

    /**
     * Deletes the Restaurant with the given ID. No-op if not found.
     *
     * @param restaurantID the primary key
     */
    void deleteRestaurant(int restaurantID);

    /**
     * Returns the Restaurant for a given primary key, or {@code null} if not found.
     *
     * @param restaurantID the primary key
     */
    Restaurant getRestaurantById(int restaurantID);

    /**
     * Returns all Restaurants (active and inactive).
     */
    List<Restaurant> getAllRestaurants();

    /**
     * Returns only Restaurants where {@code isActive = true}.
     */
    List<Restaurant> getActiveRestaurants();

    /**
     * Searches restaurants whose name contains the given keyword (case-insensitive).
     *
     * @param keyword partial name to search
     */
    List<Restaurant> searchByName(String keyword);
}