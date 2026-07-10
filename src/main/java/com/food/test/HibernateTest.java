package com.food.test;

import org.hibernate.Session;
import org.hibernate.SessionFactory;

import com.food.util.HibernateUtil;

public class HibernateTest {

    public static void main(String[] args) {

        try {

            SessionFactory factory = HibernateUtil.getSessionFactory();

            Session session = factory.openSession();

            System.out.println("====================================");
            System.out.println("Connected Successfully to MySQL");
            System.out.println("Hibernate is Working");
            System.out.println("====================================");

            session.close();

            HibernateUtil.shutdown();

        } catch (Exception e) {

            System.out.println("Connection Failed");

            e.printStackTrace();
        }
    }
}