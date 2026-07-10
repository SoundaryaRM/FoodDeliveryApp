package com.food.servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.*;

/**
 * DIAGNOSTIC ONLY — remove after fixing.
 * Directly tests DB connection and login query without Hibernate.
 * Access: /FoodDelivery/DiagServlet
 */
@WebServlet("/DiagServlet")
public class DiagServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        resp.setContentType("text/html;charset=UTF-8");
        PrintWriter out = resp.getWriter();

        out.println("<html><body style='font-family:monospace;padding:20px'>");
        out.println("<h2>🔍 Diagnostic Report</h2>");

        // 1. Test DB Connection
        out.println("<h3>1. MySQL Connection Test</h3>");
        String url  = "jdbc:mysql://localhost:3306/fooddeliverydb?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true";
        String user = "root";
        String pass = "Sound@87888";

        try (Connection conn = DriverManager.getConnection(url, user, pass)) {
            out.println("<p style='color:green'>✅ DB connected: " + conn.getCatalog() + "</p>");

            // 2. Test login query
            out.println("<h3>2. Login Query Test (soundarya@gmail.com / 12345)</h3>");
            String sql = "SELECT UserID, Username, Email, Role FROM user WHERE Email=? AND Password=?";
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setString(1, "soundarya@gmail.com");
                ps.setString(2, "12345");
                ResultSet rs = ps.executeQuery();
                if (rs.next()) {
                    out.println("<p style='color:green'>✅ Login works! UserID=" + rs.getInt("UserID")
                            + " Username=" + rs.getString("Username") + "</p>");
                } else {
                    out.println("<p style='color:red'>❌ No user found for those credentials</p>");
                }
            }

            // 3. List all users
            out.println("<h3>3. All Users</h3><table border='1'><tr><th>ID</th><th>Username</th><th>Email</th><th>Role</th></tr>");
            try (Statement st = conn.createStatement();
                 ResultSet rs = st.executeQuery("SELECT UserID,Username,Email,Role FROM user")) {
                while (rs.next()) {
                    out.println("<tr><td>" + rs.getInt(1) + "</td><td>" + rs.getString(2)
                            + "</td><td>" + rs.getString(3) + "</td><td>" + rs.getString(4) + "</td></tr>");
                }
            }
            out.println("</table>");

            // 4. List restaurants
            out.println("<h3>4. Restaurants</h3><table border='1'><tr><th>ID</th><th>Name</th><th>Cuisine</th><th>IsActive</th></tr>");
            try (Statement st = conn.createStatement();
                 ResultSet rs = st.executeQuery("SELECT RestaurantID,Name,CuisineType,IsActive FROM restaurant")) {
                while (rs.next()) {
                    out.println("<tr><td>" + rs.getInt(1) + "</td><td>" + rs.getString(2)
                            + "</td><td>" + rs.getString(3) + "</td><td>" + rs.getInt(4) + "</td></tr>");
                }
            }
            out.println("</table>");

            // 5. List menu
            out.println("<h3>5. Menu Items</h3><table border='1'><tr><th>ID</th><th>Name</th><th>RestID</th><th>Category</th><th>Price</th><th>IsAvailable</th></tr>");
            try (Statement st = conn.createStatement();
                 ResultSet rs = st.executeQuery("SELECT MenuID,ItemName,RestaurantID,Category,Price,IsAvailable FROM menu LIMIT 10")) {
                while (rs.next()) {
                    out.println("<tr><td>" + rs.getInt(1) + "</td><td>" + rs.getString(2)
                            + "</td><td>" + rs.getInt(3) + "</td><td>" + rs.getString(4)
                            + "</td><td>" + rs.getDouble(5) + "</td><td>" + rs.getInt(6) + "</td></tr>");
                }
            }
            out.println("</table>");

        } catch (Exception e) {
            out.println("<p style='color:red'>❌ DB Error: " + e.getMessage() + "</p>");
        }

        // 6. Test Hibernate SessionFactory
        out.println("<h3>6. Hibernate SessionFactory Test</h3>");
        try {
            org.hibernate.SessionFactory sf = com.food.util.HibernateUtil.getSessionFactory();
            if (sf != null && !sf.isClosed()) {
                out.println("<p style='color:green'>✅ Hibernate SessionFactory is alive</p>");

                // Try a simple query
                try (org.hibernate.Session s = sf.openSession()) {
                    Long count = s.createQuery("SELECT COUNT(u) FROM User u", Long.class).uniqueResult();
                    out.println("<p style='color:green'>✅ Hibernate query works: User count = " + count + "</p>");

                    Long rCount = s.createQuery("SELECT COUNT(r) FROM Restaurant r", Long.class).uniqueResult();
                    out.println("<p style='color:green'>✅ Restaurant count = " + rCount + "</p>");

                    Long mCount = s.createQuery("SELECT COUNT(m) FROM Menu m", Long.class).uniqueResult();
                    out.println("<p style='color:green'>✅ Menu item count = " + mCount + "</p>");
                }
            } else {
                out.println("<p style='color:red'>❌ SessionFactory is null or closed!</p>");
            }
        } catch (Throwable t) {
            out.println("<p style='color:red'>❌ Hibernate Error: " + t.getMessage() + "</p>");
            out.println("<pre style='color:red'>");
            t.printStackTrace(out);
            out.println("</pre>");
        }

        out.println("<hr><p><a href='login.jsp'>← Go to Login</a></p>");
        out.println("</body></html>");
    }
}
