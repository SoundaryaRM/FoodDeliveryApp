package com.food.model;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

/**
 * Session-scoped cart. Stored in HttpSession as "cart".
 *
 * Operations:
 *   addItem()              — add 1 unit (or increment if already present)
 *   removeItem()           — decrement qty by 1; remove line if qty reaches 0
 *   removeItemCompletely() — remove the entire line regardless of qty
 *   clearCart()            — empty the whole cart
 */
public class Cart implements Serializable {

    private static final long serialVersionUID = 1L;

    private List<CartItem> items = new ArrayList<>();

    public Cart() {}

    // ── Getters ────────────────────────────────────────────────────────────────

    public List<CartItem> getItems() {
        return items;
    }

    public int getTotalItemCount() {
        return items.stream().mapToInt(CartItem::getQuantity).sum();
    }

    public double getGrandTotal() {
        return items.stream().mapToDouble(CartItem::getTotalPrice).sum();
    }

    // ── Mutation ───────────────────────────────────────────────────────────────

    /** Add one unit. If item already in cart, increments its quantity. */
    public void addItem(Menu menu) {
        // Enforce single restaurant per cart rule
        if (!items.isEmpty()) {
            int currentRestaurantId = items.get(0).getMenu().getRestaurant().getRestaurantID();
            int newRestaurantId = menu.getRestaurant().getRestaurantID();
            if (currentRestaurantId != newRestaurantId) {
                clearCart();
            }
        }

        for (CartItem item : items) {
            if (item.getMenu().getMenuID() == menu.getMenuID()) {
                item.setQuantity(item.getQuantity() + 1);
                return;
            }
        }
        items.add(new CartItem(menu, 1));
    }

    /**
     * Decrement quantity by 1. Removes the line completely when qty reaches 0.
     * Used by the "−" button in cart.jsp.
     */
    public void removeItem(int menuID) {
        for (CartItem item : items) {
            if (item.getMenu().getMenuID() == menuID) {
                if (item.getQuantity() > 1) {
                    item.setQuantity(item.getQuantity() - 1);
                } else {
                    items.remove(item);     // qty would become 0 → remove line
                }
                return;
            }
        }
    }

    /**
     * Remove the entire line item regardless of quantity.
     * Used by the "Remove" text link in cart.jsp.
     */
    public void removeItemCompletely(int menuID) {
        items.removeIf(item -> item.getMenu().getMenuID() == menuID);
    }

    /** Empty the cart completely. */
    public void clearCart() {
        items.clear();
    }
}