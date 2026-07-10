package com.food.daoimpl;

import java.util.Collections;
import java.util.List;

import org.hibernate.Session;
import org.hibernate.Transaction;
import org.hibernate.query.Query;

import com.food.dao.OrderItemDAO;
import com.food.model.OrderItem;
import com.food.util.HibernateUtil;

/**
 * Hibernate implementation of {@link OrderItemDAO}.
 *
 * Every method manages its own Session lifecycle via try-with-resources.
 * Write operations are transactional; read operations are not.
 */
public class OrderItemDAOImpl implements OrderItemDAO {

    // ─── Write Operations ──────────────────────────────────────────────────────

    @Override
    public void addOrderItem(OrderItem item) {
        Transaction tx = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            tx = session.beginTransaction();
            session.persist(item);
            tx.commit();
            System.out.println("OrderItem added: ID=" + item.getOrderItemID());
        } catch (Exception e) {
            if (tx != null) tx.rollback();
            System.err.println("Error adding order item: " + e.getMessage());
            throw new RuntimeException("Failed to add order item", e);
        }
    }

    @Override
    public void updateOrderItem(OrderItem item) {
        Transaction tx = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            tx = session.beginTransaction();
            session.merge(item);
            tx.commit();
            System.out.println("OrderItem updated: ID=" + item.getOrderItemID());
        } catch (Exception e) {
            if (tx != null) tx.rollback();
            System.err.println("Error updating order item: " + e.getMessage());
            throw new RuntimeException("Failed to update order item", e);
        }
    }

    @Override
    public void deleteOrderItem(int orderItemID) {
        Transaction tx = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            tx = session.beginTransaction();
            OrderItem item = session.get(OrderItem.class, orderItemID);
            if (item != null) {
                session.remove(item);
                System.out.println("OrderItem deleted: ID=" + orderItemID);
            } else {
                System.out.println("deleteOrderItem: not found for ID=" + orderItemID);
            }
            tx.commit();
        } catch (Exception e) {
            if (tx != null) tx.rollback();
            System.err.println("Error deleting order item: " + e.getMessage());
            throw new RuntimeException("Failed to delete order item", e);
        }
    }

    /**
     * Bulk-delete all line items for an order using a single HQL DELETE statement.
     * Much more efficient than loading each item individually.
     */
    @Override
    public void deleteItemsByOrder(int orderID) {
        Transaction tx = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            tx = session.beginTransaction();
            Query<?> query = (Query<?>) session.createMutationQuery(
                    "DELETE FROM OrderItem oi WHERE oi.order.orderID = :oid");
            query.setParameter("oid", orderID);
            int rows = query.executeUpdate();
            tx.commit();
            System.out.println("Deleted " + rows + " item(s) for orderID=" + orderID);
        } catch (Exception e) {
            if (tx != null) tx.rollback();
            System.err.println("Error deleting items by order: " + e.getMessage());
            throw new RuntimeException("Failed to delete order items", e);
        }
    }

    // ─── Read Operations ───────────────────────────────────────────────────────

    @Override
    public OrderItem getOrderItemById(int orderItemID) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            return session.get(OrderItem.class, orderItemID);
        } catch (Exception e) {
            System.err.println("Error fetching order item by ID: " + e.getMessage());
            throw new RuntimeException("Failed to get order item", e);
        }
    }

    @Override
    public List<OrderItem> getItemsByOrder(int orderID) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            Query<OrderItem> query = session.createQuery(
                    "FROM OrderItem oi WHERE oi.order.orderID = :oid",
                    OrderItem.class);
            query.setParameter("oid", orderID);
            return query.list();
        } catch (Exception e) {
            System.err.println("Error fetching items for order: " + e.getMessage());
            return Collections.emptyList();
        }
    }
}