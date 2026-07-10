package com.food.daoimpl;

import java.util.Collections;
import java.util.List;

import org.hibernate.Session;
import org.hibernate.Transaction;
import org.hibernate.query.MutationQuery;    // ✅ correct type for createMutationQuery()
import org.hibernate.query.Query;

import com.food.dao.OrdersDAO;
import com.food.model.Orders;
import com.food.util.HibernateUtil;

/**
 * Hibernate implementation of {@link OrdersDAO}.
 *
 * Session management rules:
 *  - Every method opens its own Session via try-with-resources.
 *  - Write operations are wrapped in a Transaction.
 *  - On exception: rollback is called BEFORE the session closes (still inside the try block).
 *  - Re-throws as RuntimeException so the servlet layer can handle it.
 */
public class OrdersDAOImpl implements OrdersDAO {

    // ─── Write Operations ──────────────────────────────────────────────────────

    @Override
    public void placeOrder(Orders order) {
        Transaction tx = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            tx = session.beginTransaction();
            session.persist(order);
            tx.commit();
            System.out.println("Order placed successfully. ID=" + order.getOrderID());
        } catch (Exception e) {
            // ✅ rollback while session is still open (inside try-with-resources scope)
            if (tx != null && tx.isActive()) tx.rollback();
            System.err.println("Error placing order: " + e.getMessage());
            throw new RuntimeException("Failed to place order", e);
        }
    }

    @Override
    public void updateOrder(Orders order) {
        Transaction tx = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            tx = session.beginTransaction();
            session.merge(order);
            tx.commit();
            System.out.println("Order updated. ID=" + order.getOrderID());
        } catch (Exception e) {
            if (tx != null && tx.isActive()) tx.rollback();
            System.err.println("Error updating order: " + e.getMessage());
            throw new RuntimeException("Failed to update order", e);
        }
    }

    /**
     * Updates only the status column using a targeted HQL UPDATE statement.
     * More efficient than loading the full entity graph just to change one field.
     */
    @Override
    public void updateOrderStatus(int orderID, String newStatus) {
        Transaction tx = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            tx = session.beginTransaction();

            // ✅ createMutationQuery() returns MutationQuery, not Query<?>
            MutationQuery mutationQuery = session.createMutationQuery(
                    "UPDATE Orders o SET o.status = :status WHERE o.orderID = :id");
            mutationQuery.setParameter("status", newStatus);
            mutationQuery.setParameter("id", orderID);
            int rows = mutationQuery.executeUpdate();  // ✅ executeUpdate() on MutationQuery

            tx.commit();
            System.out.println("Order status updated: ID=" + orderID
                    + " -> " + newStatus + " (" + rows + " row(s) affected)");
        } catch (Exception e) {
            if (tx != null && tx.isActive()) tx.rollback();
            System.err.println("Error updating order status: " + e.getMessage());
            throw new RuntimeException("Failed to update order status", e);
        }
    }

    /**
     * Soft-cancels an order by setting status to CANCELLED.
     * Does NOT physically delete the row — preserves order history.
     */
    @Override
    public void cancelOrder(int orderID) {
        Transaction tx = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            tx = session.beginTransaction();

            Orders order = session.get(Orders.class, orderID);
            if (order != null) {
                order.setStatus("CANCELLED");
                session.merge(order);
                System.out.println("Order cancelled: ID=" + orderID);
            } else {
                System.out.println("cancelOrder: no order found for ID=" + orderID);
            }

            tx.commit();
        } catch (Exception e) {
            if (tx != null && tx.isActive()) tx.rollback();
            System.err.println("Error cancelling order: " + e.getMessage());
            throw new RuntimeException("Failed to cancel order", e);
        }
    }

    // ─── Read Operations ───────────────────────────────────────────────────────

    @Override
    public Orders getOrderById(int orderID) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            // session.get() returns null if not found — no exception
            return session.get(Orders.class, orderID);
        } catch (Exception e) {
            System.err.println("Error fetching order by ID=" + orderID + ": " + e.getMessage());
            throw new RuntimeException("Failed to get order by ID", e);
        }
    }

    @Override
    public List<Orders> getOrdersByUser(int userID) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            Query<Orders> query = session.createQuery(
                    "FROM Orders o WHERE o.user.userID = :uid ORDER BY o.orderDate DESC",
                    Orders.class);
            query.setParameter("uid", userID);
            return query.list();
        } catch (Exception e) {
            System.err.println("Error fetching orders for userID=" + userID + ": " + e.getMessage());
            return Collections.emptyList(); // safe fallback — prevents NPE in JSP loops
        }
    }

    @Override
    public List<Orders> getAllOrders() {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            return session.createQuery(
                    "FROM Orders o ORDER BY o.orderDate DESC",
                    Orders.class).list();
        } catch (Exception e) {
            System.err.println("Error fetching all orders: " + e.getMessage());
            return Collections.emptyList();
        }
    }

    @Override
    public List<Orders> getRecentOrders(int limit) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            Query<Orders> query = session.createQuery(
                    "FROM Orders o ORDER BY o.orderDate DESC",
                    Orders.class);
            query.setMaxResults(limit);
            return query.list();
        } catch (Exception e) {
            System.err.println("Error fetching recent orders (limit=" + limit + "): " + e.getMessage());
            return Collections.emptyList();
        }
    }
}