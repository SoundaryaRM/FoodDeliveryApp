package com.food.daoimpl;

import java.util.Collections;
import java.util.List;

import org.hibernate.Session;
import org.hibernate.Transaction;
import org.hibernate.query.Query;

import com.food.dao.MenuDAO;
import com.food.model.Menu;
import com.food.util.HibernateUtil;

/**
 * Hibernate implementation of {@link MenuDAO}.
 *
 * Every method manages its own Session lifecycle via try-with-resources.
 * Write operations are transactional; read operations are not.
 */
public class MenuDAOImpl implements MenuDAO {

    // ─── Write Operations ──────────────────────────────────────────────────────

    @Override
    public void addMenu(Menu menu) {
        Transaction tx = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            tx = session.beginTransaction();
            session.persist(menu);
            tx.commit();
            System.out.println("Menu item added: " + menu.getItemName());
        } catch (Exception e) {
            if (tx != null) tx.rollback();
            System.err.println("Error adding menu item: " + e.getMessage());
            throw new RuntimeException("Failed to add menu item", e);
        }
    }

    @Override
    public void updateMenu(Menu menu) {
        Transaction tx = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            tx = session.beginTransaction();
            session.merge(menu);
            tx.commit();
            System.out.println("Menu item updated: ID=" + menu.getMenuID());
        } catch (Exception e) {
            if (tx != null) tx.rollback();
            System.err.println("Error updating menu item: " + e.getMessage());
            throw new RuntimeException("Failed to update menu item", e);
        }
    }

    @Override
    public void deleteMenu(int menuID) {
        Transaction tx = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            tx = session.beginTransaction();
            Menu menu = session.get(Menu.class, menuID);
            if (menu != null) {
                session.remove(menu);
                System.out.println("Menu item deleted: ID=" + menuID);
            } else {
                System.out.println("deleteMenu: not found for ID=" + menuID);
            }
            tx.commit();
        } catch (Exception e) {
            if (tx != null) tx.rollback();
            System.err.println("Error deleting menu item: " + e.getMessage());
            throw new RuntimeException("Failed to delete menu item", e);
        }
    }

    // ─── Read Operations ───────────────────────────────────────────────────────

    @Override
    public Menu getMenuById(int menuID) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            return session.get(Menu.class, menuID);
        } catch (Exception e) {
            System.err.println("Error fetching menu item by ID: " + e.getMessage());
            throw new RuntimeException("Failed to get menu item", e);
        }
    }

    @Override
    public List<Menu> getMenuByRestaurant(int restaurantID) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            Query<Menu> query = session.createQuery(
                    "FROM Menu m WHERE m.restaurant.restaurantID = :rid ORDER BY m.itemName",
                    Menu.class);
            query.setParameter("rid", restaurantID);
            return query.list();
        } catch (Exception e) {
            System.err.println("Error fetching menu by restaurant: " + e.getMessage());
            return Collections.emptyList();
        }
    }

    @Override
    public List<Menu> getAvailableMenuByRestaurant(int restaurantID) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            Query<Menu> query = session.createQuery(
                    "FROM Menu m WHERE m.restaurant.restaurantID = :rid " +
                    "AND m.available = true ORDER BY m.itemName",
                    Menu.class);
            query.setParameter("rid", restaurantID);
            return query.list();
        } catch (Exception e) {
            System.err.println("Error fetching available menu: " + e.getMessage());
            return Collections.emptyList();
        }
    }

    @Override
    public List<Menu> getAllMenus() {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            return session.createQuery(
                    "FROM Menu m ORDER BY m.restaurant.restaurantID, m.itemName",
                    Menu.class).list();
        } catch (Exception e) {
            System.err.println("Error fetching all menus: " + e.getMessage());
            return Collections.emptyList();
        }
    }

    @Override
    public List<Menu> searchByName(String keyword) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            Query<Menu> query = session.createQuery(
                    "FROM Menu m WHERE lower(m.itemName) LIKE :kw ORDER BY m.itemName",
                    Menu.class);
            query.setParameter("kw", "%" + keyword.toLowerCase() + "%");
            return query.list();
        } catch (Exception e) {
            System.err.println("Error searching menu items: " + e.getMessage());
            return Collections.emptyList();
        }
    }
}