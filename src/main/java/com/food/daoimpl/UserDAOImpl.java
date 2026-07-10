package com.food.daoimpl;

import java.util.Collections;
import java.util.List;
import java.util.Optional;

import org.hibernate.Session;
import org.hibernate.Transaction;
import org.hibernate.query.Query;

import com.food.dao.UserDAO;
import com.food.model.User;
import com.food.util.HibernateUtil;

/**
 * Hibernate implementation of {@link UserDAO}.
 *
 * Session management rules followed here:
 *  - Every method opens its own Session via try-with-resources.
 *  - Write operations (persist/merge/remove) are wrapped in a Transaction.
 *  - Exceptions roll back the transaction and are re-thrown as RuntimeException
 *    so the servlet layer can handle them cleanly.
 *  - Read-only operations do NOT need a transaction in Hibernate.
 */
public class UserDAOImpl implements UserDAO {

    // ─── Write Operations ──────────────────────────────────────────────────────

    @Override
    public void addUser(User user) {
        Transaction tx = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            tx = session.beginTransaction();
            session.persist(user); // Hibernate assigns the auto-generated ID
            tx.commit();
            System.out.println("User registered successfully: " + user.getEmail());
        } catch (Exception e) {
            if (tx != null) tx.rollback();
            System.err.println("Error adding user: " + e.getMessage());
            throw new RuntimeException("Failed to add user", e);
        }
    }

    @Override
    public void updateUser(User user) {
        Transaction tx = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            tx = session.beginTransaction();
            session.merge(user); // merge works for detached objects
            tx.commit();
            System.out.println("User updated successfully: ID=" + user.getUserID());
        } catch (Exception e) {
            if (tx != null) tx.rollback();
            System.err.println("Error updating user: " + e.getMessage());
            throw new RuntimeException("Failed to update user", e);
        }
    }

    @Override
    public void deleteUser(int userId) {
        Transaction tx = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            tx = session.beginTransaction();
            User user = session.get(User.class, userId);
            if (user != null) {
                session.remove(user);
                System.out.println("User deleted: ID=" + userId);
            } else {
                System.out.println("deleteUser: no user found for ID=" + userId);
            }
            tx.commit();
        } catch (Exception e) {
            if (tx != null) tx.rollback();
            System.err.println("Error deleting user: " + e.getMessage());
            throw new RuntimeException("Failed to delete user", e);
        }
    }

    // ─── Read Operations ───────────────────────────────────────────────────────

    @Override
    public User getUserById(int userId) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            return session.get(User.class, userId); // returns null if not found
        } catch (Exception e) {
            System.err.println("Error fetching user by ID: " + e.getMessage());
            throw new RuntimeException("Failed to get user by ID", e);
        }
    }

    @Override
    public List<User> getAllUsers() {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            return session.createQuery("FROM User ORDER BY username", User.class).list();
        } catch (Exception e) {
            System.err.println("Error fetching all users: " + e.getMessage());
            return Collections.emptyList(); // safe fallback for list operations
        }
    }

    @Override
    public Optional<User> login(String email, String password) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            // Use 'u.email' and 'u.password' with alias to avoid reserved word conflicts
            Query<User> query = session.createQuery(
                    "FROM User u WHERE u.email = :email AND u.password = :pwd",
                    User.class);
            query.setParameter("email", email);
            query.setParameter("pwd", password);
            System.out.println("[UserDAO] Running login HQL for: " + email);
            User found = query.uniqueResult();
            System.out.println("[UserDAO] Login result: " + (found != null ? found.getUsername() : "NOT FOUND"));
            return Optional.ofNullable(found);
        } catch (Exception e) {
            System.err.println("[UserDAO] Login error: " + e.getMessage());
            e.printStackTrace();
            throw new RuntimeException("Login failed", e);
        }
    }

    @Override
    public boolean emailExists(String email) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            Query<Long> query = session.createQuery(
                    "SELECT COUNT(u) FROM User u WHERE u.email = :email",
                    Long.class);
            query.setParameter("email", email);
            Long count = query.uniqueResult();
            return count != null && count > 0;
        } catch (Exception e) {
            System.err.println("Error checking email existence: " + e.getMessage());
            throw new RuntimeException("Failed to check email", e);
        }
    }
}