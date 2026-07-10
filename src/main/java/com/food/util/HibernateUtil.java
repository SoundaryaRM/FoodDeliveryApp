package com.food.util;

import org.hibernate.SessionFactory;
import org.hibernate.cfg.Configuration;

import com.food.model.Menu;
import com.food.model.OrderItem;
import com.food.model.Orders;
import com.food.model.Restaurant;
import com.food.model.User;

/**
 * Singleton helper that builds and provides the Hibernate SessionFactory.
 * All entity classes are registered here so hibernate.cfg.xml stays clean.
 */
public final class HibernateUtil {

    private static final SessionFactory SESSION_FACTORY = buildSessionFactory();

    private HibernateUtil() {
        // Utility class — prevent instantiation
    }

    private static SessionFactory buildSessionFactory() {
        try {
            Configuration configuration = new Configuration()
                    .configure("hibernate.cfg.xml")
                    // Register every JPA entity here
                    .addAnnotatedClass(User.class)
                    .addAnnotatedClass(Restaurant.class)
                    .addAnnotatedClass(Menu.class)
                    .addAnnotatedClass(Orders.class)
                    .addAnnotatedClass(OrderItem.class);

            SessionFactory sf = configuration.buildSessionFactory();

            System.out.println("==================================");
            System.out.println("Hibernate Initialized Successfully");
            System.out.println("==================================");

            return sf;

        } catch (Throwable ex) {
            System.err.println("Hibernate Initialization Failed: " + ex.getMessage());
            ex.printStackTrace();
            throw new ExceptionInInitializerError(ex);
        }
    }

    /**
     * Returns the singleton SessionFactory.
     * Never returns null — throws ExceptionInInitializerError if setup failed.
     */
    public static SessionFactory getSessionFactory() {
        return SESSION_FACTORY;
    }

    /** Call this once on application shutdown (e.g., in a ServletContextListener). */
    public static void shutdown() {
        if (SESSION_FACTORY != null && !SESSION_FACTORY.isClosed()) {
            SESSION_FACTORY.close();
            System.out.println("Hibernate SessionFactory closed.");
        }
    }
}