package com.food.daoimpl;

import java.util.Collections;
import java.util.List;

import org.hibernate.Session;
import org.hibernate.Transaction;
import org.hibernate.query.Query;

import com.food.dao.RestaurantDAO;
import com.food.model.Restaurant;
import com.food.util.HibernateUtil;

/**
 * Hibernate implementation of {@link RestaurantDAO}.
 *
 * Every method manages its own Session lifecycle via try-with-resources.
 * Write operations are transactional; read operations are not.
 */
public class RestaurantDAOImpl implements RestaurantDAO {

    // ─── Write Operations ──────────────────────────────────────────────────────

    @Override
    public void addRestaurant(Restaurant restaurant) {
        Transaction tx = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            tx = session.beginTransaction();
            session.persist(restaurant);
            tx.commit();
            System.out.println("Restaurant added: " + restaurant.getName());
        } catch (Exception e) {
            if (tx != null) tx.rollback();
            System.err.println("Error adding restaurant: " + e.getMessage());
            throw new RuntimeException("Failed to add restaurant", e);
        }
    }

    @Override
    public void updateRestaurant(Restaurant restaurant) {
        Transaction tx = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            tx = session.beginTransaction();
            session.merge(restaurant);
            tx.commit();
            System.out.println("Restaurant updated: ID=" + restaurant.getRestaurantID());
        } catch (Exception e) {
            if (tx != null) tx.rollback();
            System.err.println("Error updating restaurant: " + e.getMessage());
            throw new RuntimeException("Failed to update restaurant", e);
        }
    }

    @Override
    public void deleteRestaurant(int restaurantID) {
        Transaction tx = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            tx = session.beginTransaction();
            Restaurant restaurant = session.get(Restaurant.class, restaurantID);
            if (restaurant != null) {
                session.remove(restaurant);
                System.out.println("Restaurant deleted: ID=" + restaurantID);
            } else {
                System.out.println("deleteRestaurant: not found for ID=" + restaurantID);
            }
            tx.commit();
        } catch (Exception e) {
            if (tx != null) tx.rollback();
            System.err.println("Error deleting restaurant: " + e.getMessage());
            throw new RuntimeException("Failed to delete restaurant", e);
        }
    }

    // ─── Read Operations ───────────────────────────────────────────────────────

    @Override
    public Restaurant getRestaurantById(int restaurantID) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            return session.get(Restaurant.class, restaurantID);
        } catch (Exception e) {
            System.err.println("Error fetching restaurant by ID: " + e.getMessage());
            throw new RuntimeException("Failed to get restaurant", e);
        }
    }

    @Override
    public List<Restaurant> getAllRestaurants() {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            return session.createQuery(
                    "FROM Restaurant r ORDER BY r.name", Restaurant.class).list();
        } catch (Exception e) {
            System.err.println("Error fetching all restaurants: " + e.getMessage());
            return Collections.emptyList();
        }
    }

    @Override
    public List<Restaurant> getActiveRestaurants() {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            Query<Restaurant> query = session.createQuery(
                    "FROM Restaurant r WHERE r.active = true ORDER BY r.name",
                    Restaurant.class);
            return query.list();
        } catch (Exception e) {
            System.err.println("Error fetching active restaurants: " + e.getMessage());
            return Collections.emptyList();
        }
    }

    @Override
    public List<Restaurant> searchByName(String keyword) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            Query<Restaurant> query = session.createQuery(
                    "FROM Restaurant r WHERE lower(r.name) LIKE :kw ORDER BY r.name",
                    Restaurant.class);
            query.setParameter("kw", "%" + keyword.toLowerCase() + "%");
            return query.list();
        } catch (Exception e) {
            System.err.println("Error searching restaurants: " + e.getMessage());
            return Collections.emptyList();
        }
    }
}