-- ============================================================
--  FoodDelivery App — Full Database Setup Script
--  Run this script once to fix ALL tables for the application.
--  Database: fooddeliverydb
-- ============================================================

USE fooddeliverydb;

-- ─────────────────────────────────────────────────────────────
-- 1. USER TABLE  (fix AUTO_INCREMENT + add missing columns)
-- ─────────────────────────────────────────────────────────────
ALTER TABLE user
    MODIFY COLUMN UserID      INT          NOT NULL AUTO_INCREMENT,
    MODIFY COLUMN Username    VARCHAR(50)  NOT NULL,
    MODIFY COLUMN Password    VARCHAR(100) NOT NULL,
    MODIFY COLUMN Email       VARCHAR(100) NOT NULL,
    MODIFY COLUMN Address     TEXT,
    MODIFY COLUMN Role        VARCHAR(20)  DEFAULT 'CUSTOMER',
    MODIFY COLUMN CreateDate  DATETIME(6),
    MODIFY COLUMN LastLoginDate DATETIME(6);

-- ─────────────────────────────────────────────────────────────
-- 2. RESTAURANT TABLE  (fix AUTO_INCREMENT)
-- ─────────────────────────────────────────────────────────────
ALTER TABLE restaurant
    MODIFY COLUMN RestaurantID  INT          NOT NULL AUTO_INCREMENT,
    MODIFY COLUMN Name          VARCHAR(100) NOT NULL,
    MODIFY COLUMN Address       TEXT,
    MODIFY COLUMN CuisineType   VARCHAR(50),
    MODIFY COLUMN Rating        FLOAT        DEFAULT 0.0,
    MODIFY COLUMN DeliveryTime  INT          DEFAULT 30,
    MODIFY COLUMN Active        TINYINT(1)   DEFAULT 1;

-- ─────────────────────────────────────────────────────────────
-- 3. MENU TABLE  (fix AUTO_INCREMENT)
-- ─────────────────────────────────────────────────────────────
ALTER TABLE menu
    MODIFY COLUMN MenuID       INT          NOT NULL AUTO_INCREMENT,
    MODIFY COLUMN ItemName     VARCHAR(100) NOT NULL,
    MODIFY COLUMN Description  TEXT,
    MODIFY COLUMN Price        DOUBLE       NOT NULL,
    MODIFY COLUMN Category     VARCHAR(50),
    MODIFY COLUMN Available    TINYINT(1)   DEFAULT 1,
    MODIFY COLUMN ImagePath    VARCHAR(255);

-- ─────────────────────────────────────────────────────────────
-- 4. ORDER TABLE  (fix AUTO_INCREMENT)
-- ─────────────────────────────────────────────────────────────
ALTER TABLE ordertable
    MODIFY COLUMN OrderID       INT          NOT NULL AUTO_INCREMENT,
    MODIFY COLUMN OrderDate     DATETIME(6)  NOT NULL,
    MODIFY COLUMN TotalAmount   DOUBLE       NOT NULL,
    MODIFY COLUMN Status        VARCHAR(30)  DEFAULT 'PLACED',
    MODIFY COLUMN PaymentMethod VARCHAR(30);

-- ─────────────────────────────────────────────────────────────
-- 5. ORDER ITEM TABLE  (fix AUTO_INCREMENT)
-- ─────────────────────────────────────────────────────────────
ALTER TABLE orderitem
    MODIFY COLUMN OrderItemID  INT    NOT NULL AUTO_INCREMENT,
    MODIFY COLUMN Quantity     INT    NOT NULL,
    MODIFY COLUMN ItemTotal    DOUBLE NOT NULL;

-- ─────────────────────────────────────────────────────────────
-- 6. VERIFY — show all tables with AUTO_INCREMENT confirmed
-- ─────────────────────────────────────────────────────────────
SELECT TABLE_NAME, COLUMN_NAME, COLUMN_TYPE, EXTRA
FROM information_schema.COLUMNS
WHERE TABLE_SCHEMA = 'fooddeliverydb'
  AND COLUMN_KEY = 'PRI'
ORDER BY TABLE_NAME;

-- ─────────────────────────────────────────────────────────────
-- 7. SAMPLE DATA (optional — safe to run multiple times)
-- ─────────────────────────────────────────────────────────────
INSERT IGNORE INTO restaurant (Name, Address, CuisineType, Rating, DeliveryTime, Active)
VALUES
    ('The Golden Tandoor', '12 Spice Lane, Delhi',      'Indian',    4.8, 35, 1),
    ('Bella Napoli',       '5 Olive Street, Mumbai',    'Italian',   4.6, 40, 1),
    ('Dragon Palace',      '88 Wok Avenue, Bangalore',  'Chinese',   4.5, 25, 1);

INSERT IGNORE INTO menu (RestaurantID, ItemName, Description, Price, Category, Available)
VALUES
    (1, 'Butter Chicken', 'Rich tomato gravy with tender chicken',    350, 'main',      1),
    (1, 'Paneer Tikka',   'Marinated paneer grilled to perfection',   280, 'starters',  1),
    (1, 'Garlic Naan',    'Soft flatbread with garlic butter',         60, 'breads',    1),
    (1, 'Gulab Jamun',    'Saffron soaked milk-solid dumplings',       120, 'desserts', 1),
    (1, 'Mango Lassi',    'Refreshing yogurt-mango drink',             90, 'beverages', 1),
    (2, 'Margherita Pizza','Classic tomato and mozzarella pizza',      350, 'main',     1),
    (3, 'Kung Pao Chicken','Spicy stir-fried chicken with peanuts',   320, 'main',     1);
