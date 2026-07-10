package com.food.daoimpl;

import java.util.Collections;
import java.util.List;

import org.hibernate.Session;
import org.hibernate.Transaction;
import org.hibernate.query.MutationQuery;
import org.hibernate.query.Query;

import com.food.dao.AdminDAO;
import com.food.model.Menu;
import com.food.model.Orders;
import com.food.model.Restaurant;
import com.food.model.User;
import com.food.util.HibernateUtil;

/**
 * Hibernate implementation of {@link AdminDAO}.
 *
 * Pattern: every method opens its own Session via try-with-resources.
 * Write operations are wrapped in a Transaction with safe rollback.
 */
public class AdminDAOImpl implements AdminDAO {

    // ══════════════════════════════════════════════════════════════════════
    //  USER MANAGEMENT
    // ══════════════════════════════════════════════════════════════════════

    @Override
    public List<User> getAllUsers() {
        try (Session s = HibernateUtil.getSessionFactory().openSession()) {
            return s.createQuery("FROM User u ORDER BY u.userID DESC", User.class).list();
        } catch (Exception e) {
            System.err.println("[AdminDAO] getAllUsers error: " + e.getMessage());
            return Collections.emptyList();
        }
    }

    @Override
    public User getUserById(int userID) {
        try (Session s = HibernateUtil.getSessionFactory().openSession()) {
            return s.get(User.class, userID);
        } catch (Exception e) {
            System.err.println("[AdminDAO] getUserById error: " + e.getMessage());
            return null;
        }
    }

    @Override
    public void updateUser(User user) {
        Transaction tx = null;
        try (Session s = HibernateUtil.getSessionFactory().openSession()) {
            tx = s.beginTransaction();
            s.merge(user);
            tx.commit();
        } catch (Exception e) {
            if (tx != null && tx.isActive()) tx.rollback();
            throw new RuntimeException("updateUser failed", e);
        }
    }

    @Override
    public void deleteUser(int userID) {
        Transaction tx = null;
        try (Session s = HibernateUtil.getSessionFactory().openSession()) {
            tx = s.beginTransaction();
            User user = s.get(User.class, userID);
            if (user != null) s.remove(user);
            tx.commit();
        } catch (Exception e) {
            if (tx != null && tx.isActive()) tx.rollback();
            throw new RuntimeException("deleteUser failed", e);
        }
    }

    @Override
    public long countUsers() {
        try (Session s = HibernateUtil.getSessionFactory().openSession()) {
            return s.createQuery("SELECT COUNT(u) FROM User u", Long.class).uniqueResult();
        } catch (Exception e) {
            return 0L;
        }
    }

    // ══════════════════════════════════════════════════════════════════════
    //  RESTAURANT MANAGEMENT
    // ══════════════════════════════════════════════════════════════════════

    @Override
    public List<Restaurant> getAllRestaurants() {
        try (Session s = HibernateUtil.getSessionFactory().openSession()) {
            return s.createQuery("FROM Restaurant r ORDER BY r.restaurantID DESC", Restaurant.class).list();
        } catch (Exception e) {
            System.err.println("[AdminDAO] getAllRestaurants error: " + e.getMessage());
            return Collections.emptyList();
        }
    }

    @Override
    public Restaurant getRestaurantById(int restaurantID) {
        try (Session s = HibernateUtil.getSessionFactory().openSession()) {
            return s.get(Restaurant.class, restaurantID);
        } catch (Exception e) {
            return null;
        }
    }

    @Override
    public void addRestaurant(Restaurant restaurant) {
        Transaction tx = null;
        try (Session s = HibernateUtil.getSessionFactory().openSession()) {
            tx = s.beginTransaction();
            s.persist(restaurant);
            tx.commit();
        } catch (Exception e) {
            if (tx != null && tx.isActive()) tx.rollback();
            throw new RuntimeException("addRestaurant failed", e);
        }
    }

    @Override
    public void updateRestaurant(Restaurant restaurant) {
        Transaction tx = null;
        try (Session s = HibernateUtil.getSessionFactory().openSession()) {
            tx = s.beginTransaction();
            s.merge(restaurant);
            tx.commit();
        } catch (Exception e) {
            if (tx != null && tx.isActive()) tx.rollback();
            throw new RuntimeException("updateRestaurant failed", e);
        }
    }

    @Override
    public void deleteRestaurant(int restaurantID) {
        Transaction tx = null;
        try (Session s = HibernateUtil.getSessionFactory().openSession()) {
            tx = s.beginTransaction();
            // Delete menu items of this restaurant first (FK constraint)
            MutationQuery delMenu = s.createMutationQuery(
                    "DELETE FROM Menu m WHERE m.restaurant.restaurantID = :rid");
            delMenu.setParameter("rid", restaurantID);
            delMenu.executeUpdate();

            Restaurant r = s.get(Restaurant.class, restaurantID);
            if (r != null) s.remove(r);
            tx.commit();
        } catch (Exception e) {
            if (tx != null && tx.isActive()) tx.rollback();
            throw new RuntimeException("deleteRestaurant failed", e);
        }
    }

    @Override
    public long countRestaurants() {
        try (Session s = HibernateUtil.getSessionFactory().openSession()) {
            return s.createQuery("SELECT COUNT(r) FROM Restaurant r", Long.class).uniqueResult();
        } catch (Exception e) {
            return 0L;
        }
    }

    // ══════════════════════════════════════════════════════════════════════
    //  MENU MANAGEMENT
    // ══════════════════════════════════════════════════════════════════════

    @Override
    public List<Menu> getAllMenuItems() {
        try (Session s = HibernateUtil.getSessionFactory().openSession()) {
            return s.createQuery("FROM Menu m ORDER BY m.restaurant.restaurantID, m.menuID", Menu.class).list();
        } catch (Exception e) {
            System.err.println("[AdminDAO] getAllMenuItems error: " + e.getMessage());
            return Collections.emptyList();
        }
    }

    @Override
    public Menu getMenuItemById(int menuID) {
        try (Session s = HibernateUtil.getSessionFactory().openSession()) {
            return s.get(Menu.class, menuID);
        } catch (Exception e) {
            return null;
        }
    }

    @Override
    public void addMenuItem(Menu menu) {
        Transaction tx = null;
        try (Session s = HibernateUtil.getSessionFactory().openSession()) {
            tx = s.beginTransaction();
            s.persist(menu);
            tx.commit();
        } catch (Exception e) {
            if (tx != null && tx.isActive()) tx.rollback();
            throw new RuntimeException("addMenuItem failed", e);
        }
    }

    @Override
    public void updateMenuItem(Menu menu) {
        Transaction tx = null;
        try (Session s = HibernateUtil.getSessionFactory().openSession()) {
            tx = s.beginTransaction();
            s.merge(menu);
            tx.commit();
        } catch (Exception e) {
            if (tx != null && tx.isActive()) tx.rollback();
            throw new RuntimeException("updateMenuItem failed", e);
        }
    }

    @Override
    public void deleteMenuItem(int menuID) {
        Transaction tx = null;
        try (Session s = HibernateUtil.getSessionFactory().openSession()) {
            tx = s.beginTransaction();
            Menu m = s.get(Menu.class, menuID);
            if (m != null) s.remove(m);
            tx.commit();
        } catch (Exception e) {
            if (tx != null && tx.isActive()) tx.rollback();
            throw new RuntimeException("deleteMenuItem failed", e);
        }
    }

    @Override
    public long countMenuItems() {
        try (Session s = HibernateUtil.getSessionFactory().openSession()) {
            return s.createQuery("SELECT COUNT(m) FROM Menu m", Long.class).uniqueResult();
        } catch (Exception e) {
            return 0L;
        }
    }

    // ══════════════════════════════════════════════════════════════════════
    //  ORDER MANAGEMENT
    // ══════════════════════════════════════════════════════════════════════

    @Override
    public List<Orders> getAllOrders() {
        try (Session s = HibernateUtil.getSessionFactory().openSession()) {
            return s.createQuery("FROM Orders o ORDER BY o.orderDate DESC", Orders.class).list();
        } catch (Exception e) {
            System.err.println("[AdminDAO] getAllOrders error: " + e.getMessage());
            return Collections.emptyList();
        }
    }

    @Override
    public Orders getOrderById(int orderID) {
        try (Session s = HibernateUtil.getSessionFactory().openSession()) {
            return s.get(Orders.class, orderID);
        } catch (Exception e) {
            return null;
        }
    }

    @Override
    public void updateOrderStatus(int orderID, String status) {
        Transaction tx = null;
        try (Session s = HibernateUtil.getSessionFactory().openSession()) {
            tx = s.beginTransaction();
            MutationQuery q = s.createMutationQuery(
                    "UPDATE Orders o SET o.status = :status WHERE o.orderID = :id");
            q.setParameter("status", status);
            q.setParameter("id", orderID);
            q.executeUpdate();
            tx.commit();
        } catch (Exception e) {
            if (tx != null && tx.isActive()) tx.rollback();
            throw new RuntimeException("updateOrderStatus failed", e);
        }
    }

    @Override
    public void deleteOrder(int orderID) {
        Transaction tx = null;
        try (Session s = HibernateUtil.getSessionFactory().openSession()) {
            tx = s.beginTransaction();
            // Remove order items first (FK)
            MutationQuery delItems = s.createMutationQuery(
                    "DELETE FROM OrderItem oi WHERE oi.order.orderID = :id");
            delItems.setParameter("id", orderID);
            delItems.executeUpdate();

            Orders o = s.get(Orders.class, orderID);
            if (o != null) s.remove(o);
            tx.commit();
        } catch (Exception e) {
            if (tx != null && tx.isActive()) tx.rollback();
            throw new RuntimeException("deleteOrder failed", e);
        }
    }

    @Override
    public long countOrders() {
        try (Session s = HibernateUtil.getSessionFactory().openSession()) {
            return s.createQuery("SELECT COUNT(o) FROM Orders o", Long.class).uniqueResult();
        } catch (Exception e) {
            return 0L;
        }
    }

    @Override
    public double getTotalRevenue() {
        try (Session s = HibernateUtil.getSessionFactory().openSession()) {
            Double rev = s.createQuery(
                    "SELECT SUM(o.totalAmount) FROM Orders o WHERE o.status != 'CANCELLED'",
                    Double.class).uniqueResult();
            return rev != null ? rev : 0.0;
        } catch (Exception e) {
            return 0.0;
        }
    }
}
