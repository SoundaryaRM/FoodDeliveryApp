# Instant Foods - Food Delivery Application 🍔🍕

**Instant Foods** is a comprehensive, full-stack Java EE web application designed to provide a seamless food ordering experience. Users can browse restaurants, view menus, manage their carts, and securely place orders, while administrators have access to a powerful dashboard to manage the entire platform.

---

## 🌟 Key Features

### For Users:
- **Authentication & Authorization**: Secure User Login and Registration system.
- **Restaurant Discovery**: Browse a variety of restaurants with beautiful UI and categories.
- **Dynamic Menus**: View dish details, dynamic pricing, and rich food imagery.
- **Smart Cart System**: Add, update, or remove items from your cart in real-time.
- **Checkout & Ordering**: Streamlined checkout process with automated order ID generation and tracking.
- **Order History**: View past orders and detailed receipts.

### For Administrators:
- **Admin Dashboard**: Centralized dashboard with analytics (total users, total orders, active restaurants).
- **Restaurant Management**: Add, update, or remove restaurants from the platform.
- **Menu Management**: Control the menu items offered by each restaurant.
- **Order Management**: Monitor user orders and update statuses in real time.
- **User Management**: View and manage registered users.

---

## 🛠️ Technology Stack

- **Frontend**: HTML5, CSS3, JSP (JavaServer Pages), JSTL, Expression Language (EL).
- **Backend**: Java EE (Servlets, Filters, Listeners).
- **Database**: MySQL Server 8.0.
- **ORM / Database Connectivity**: Hibernate ORM & JDBC.
- **Server**: Apache Tomcat v10.x.

---

## 📸 Screenshots

*(Add screenshots of your Home Page, Restaurant Menu, and Cart here!)*

---

## 🚀 Setup & Installation

1. **Clone the repository:**
   ```bash
   git clone https://github.com/SoundaryaRM/FoodDeliveryApp.git
   ```
2. **Database Setup:**
   - Create a MySQL database named `fooddeliverydb`.
   - Run the provided `database_setup.sql` script to generate the tables.
3. **Configure Database Connection:**
   - Update your MySQL credentials in `hibernate.cfg.xml` and/or `DPConnection.java`.
4. **Deploy to Tomcat:**
   - Import the project into Eclipse IDE.
   - Add Apache Tomcat v10.x to your servers.
   - Run the project on the Tomcat server.

---

*Built with ❤️ by Soundarya R M.*
