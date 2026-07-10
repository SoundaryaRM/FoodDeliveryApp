package com.food.dao;

import java.util.List;

import com.food.model.Menu;

/**
 * DAO contract for {@link Menu} item persistence operations.
 */
public interface MenuDAO {

    /**
     * Persists a new Menu item. ID is auto-generated.
     *
     * @param menu the transient Menu to save
     */
    void addMenu(Menu menu);

    /**
     * Merges (updates) an existing Menu item.
     *
     * @param menu the detached Menu with updated fields
     */
    void updateMenu(Menu menu);

    /**
     * Deletes the Menu item with the given ID. No-op if not found.
     *
     * @param menuID the primary key
     */
    void deleteMenu(int menuID);

    /**
     * Returns the Menu item for a given primary key, or {@code null} if not found.
     *
     * @param menuID the primary key
     */
    Menu getMenuById(int menuID);

    /**
     * Returns all Menu items belonging to a specific restaurant.
     *
     * @param restaurantID the restaurant's primary key
     */
    List<Menu> getMenuByRestaurant(int restaurantID);

    /**
     * Returns only available Menu items for a specific restaurant.
     *
     * @param restaurantID the restaurant's primary key
     */
    List<Menu> getAvailableMenuByRestaurant(int restaurantID);

    /**
     * Returns all Menu items across all restaurants.
     */
    List<Menu> getAllMenus();

    /**
     * Searches menu items whose name contains the given keyword (case-insensitive).
     *
     * @param keyword partial item name to search
     */
    List<Menu> searchByName(String keyword);
}