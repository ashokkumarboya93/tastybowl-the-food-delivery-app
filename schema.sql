-- Create Database if not exists
CREATE DATABASE IF NOT EXISTS fooddelivery;
USE fooddelivery;

-- Drop tables if they exist to start fresh (in logical order of dependency)
DROP TABLE IF EXISTS orderitem;
DROP TABLE IF EXISTS ordertable;
DROP TABLE IF EXISTS cartitem;
DROP TABLE IF EXISTS cart;
DROP TABLE IF EXISTS menu;
DROP TABLE IF EXISTS restaurant;
DROP TABLE IF EXISTS user;

-- 1. Create User Table
CREATE TABLE user (
    userid INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(100) NOT NULL,
    password VARCHAR(255) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(15),
    address TEXT,
    city VARCHAR(50),
    state VARCHAR(50),
    pincode VARCHAR(10),
    createDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    lastLogin TIMESTAMP NULL,
    role VARCHAR(50) DEFAULT 'customer'
);

-- 2. Create Restaurant Table
CREATE TABLE restaurant (
    restaurantId INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    cuisineType VARCHAR(255) NOT NULL,
    deliveryTime INT NOT NULL,
    address VARCHAR(255) NOT NULL,
    imagePath VARCHAR(255) NOT NULL,
    adminUserId INT DEFAULT NULL,
    rating DOUBLE DEFAULT 0.0,
    isActive BOOLEAN DEFAULT TRUE
);

-- 3. Create Menu Table
CREATE TABLE menu (
    menuId INT AUTO_INCREMENT PRIMARY KEY,
    restaurantId INT NOT NULL,
    itemName VARCHAR(255) NOT NULL,
    description TEXT,
    price DOUBLE NOT NULL,
    rating DOUBLE DEFAULT 0.0,
    imagePath VARCHAR(255) NOT NULL,
    isAvailable BOOLEAN DEFAULT TRUE,
    category VARCHAR(255) NOT NULL,
    FOREIGN KEY (restaurantId) REFERENCES restaurant(restaurantId) ON DELETE CASCADE
);

-- 4. Create Cart Table
CREATE TABLE cart (
    cartId INT AUTO_INCREMENT PRIMARY KEY,
    userId INT NOT NULL,
    FOREIGN KEY (userId) REFERENCES user(userid) ON DELETE CASCADE
);

-- 5. Create CartItem Table
CREATE TABLE cartitem (
    cartItemId INT AUTO_INCREMENT PRIMARY KEY,
    cartId INT NOT NULL,
    menuId INT NOT NULL,
    quantity INT NOT NULL,
    totalPrice DOUBLE NOT NULL,
    FOREIGN KEY (cartId) REFERENCES cart(cartId) ON DELETE CASCADE,
    FOREIGN KEY (menuId) REFERENCES menu(menuId) ON DELETE CASCADE
);

-- 6. Create OrderTable Table
CREATE TABLE ordertable (
    orderId INT AUTO_INCREMENT PRIMARY KEY,
    userId INT NOT NULL,
    restaurantId INT NOT NULL,
    orderDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    totalAmount DOUBLE NOT NULL,
    status VARCHAR(50) DEFAULT 'Pending',
    paymentMethod VARCHAR(50) NOT NULL,
    FOREIGN KEY (userId) REFERENCES user(userid) ON DELETE CASCADE,
    FOREIGN KEY (restaurantId) REFERENCES restaurant(restaurantId) ON DELETE CASCADE
);

-- 7. Create OrderItem Table
CREATE TABLE orderitem (
    orderItemId INT AUTO_INCREMENT PRIMARY KEY,
    orderId INT NOT NULL,
    menuId INT NOT NULL,
    quantity INT NOT NULL,
    itemTotal DOUBLE NOT NULL,
    FOREIGN KEY (orderId) REFERENCES ordertable(orderId) ON DELETE CASCADE,
    FOREIGN KEY (menuId) REFERENCES menu(menuId) ON DELETE CASCADE
);

-- Seed Initial Data
-- Insert Admin User (Password is 'admin123' encrypted with BCrypt)
INSERT INTO user (username, password, email, address, role) 
VALUES ('System Admin', '$2a$10$tZ2cK6Qh/N6d00nK/HlX1O3Y1E1f22e.l6Wn/z1H0Q1uJvCjV11dK', 'admin@foodapp.com', 'Admin Office, Food Street', 'admin');

-- Insert Customer User (Password is 'cust123' encrypted with BCrypt)
INSERT INTO user (username, password, email, address, role) 
VALUES ('John Doe', '$2a$10$wN1Fv4n7N5fVwz6K.XUa6OrVf1Yc8G8k3Y4E5z2jG6q0XhD6w.aK2', 'john@gmail.com', '123, Purple Avenue, Silicon Valley', 'customer');

-- Insert Restaurants
INSERT INTO restaurant (name, cuisineType, deliveryTime, address, imagePath, rating, isActive)
VALUES 
('TastyBowl', 'North Indian, Chinese', 30, 'Sector 62, Noida', 'https://images.unsplash.com/photo-1563379091339-03246963d4a9?auto=format&fit=crop&w=600&q=80', 4.2, 1),
('Pizza Haven', 'Italian, Fast Food', 25, 'Connaught Place, New Delhi', 'https://images.unsplash.com/photo-1513104890138-7c749659a591?auto=format&fit=crop&w=600&q=80', 4.5, 1),
('Burger Palace', 'Burgers, Beverages', 20, 'Indiranagar, Bangalore', 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?auto=format&fit=crop&w=600&q=80', 4.0, 1),
('Sichuan Express', 'Asian, Chinese', 35, 'Salt Lake, Kolkata', 'https://images.unsplash.com/photo-1552566626-52f8b828add9?auto=format&fit=crop&w=600&q=80', 4.1, 1),
('Sweet Truth', 'Desserts, Bakery', 15, 'Bandra West, Mumbai', 'https://images.unsplash.com/photo-1551024601-bec78aea704b?auto=format&fit=crop&w=600&q=80', 4.6, 1);

-- Insert Menu Items for TastyBowl (Restaurant 1)
INSERT INTO menu (restaurantId, itemName, description, price, rating, imagePath, isAvailable, category)
VALUES 
(1, 'Butter Chicken', 'Tender chicken cooked in rich buttery tomato gravy with fresh cream.', 320.00, 4.6, 'https://images.unsplash.com/photo-1603894584373-5ac82b2ae398?auto=format&fit=crop&w=400&q=80', 1, 'Main Course'),
(1, 'Paneer Tikka Masala', 'Spiced cottage cheese cubes grilled and cooked in tikka masala gravy.', 280.00, 4.4, 'https://images.unsplash.com/photo-1565557623262-b51c2513a641?auto=format&fit=crop&w=400&q=80', 1, 'Main Course'),
(1, 'Garlic Naan', 'Traditional Indian flatbread garnished with minced garlic and butter.', 60.00, 4.5, 'https://images.unsplash.com/photo-1601050690597-df056fb4ce78?auto=format&fit=crop&w=400&q=80', 1, 'Bread'),
(1, 'Veg Manchurian', 'Deep fried mixed vegetable balls tossed in a sweet, sour and spicy Manchurian sauce.', 220.00, 4.1, 'https://images.unsplash.com/photo-1534422298391-e4f8c172dddb?auto=format&fit=crop&w=400&q=80', 1, 'Starters');

-- Insert Menu Items for Pizza Haven (Restaurant 2)
INSERT INTO menu (restaurantId, itemName, description, price, rating, imagePath, isAvailable, category)
VALUES 
(2, 'Margherita Pizza', 'Classic cheese and tomato pizza with fresh basil leaves.', 250.00, 4.5, 'https://images.unsplash.com/photo-1574071318508-1cdbab80d002?auto=format&fit=crop&w=400&q=80', 1, 'Pizzas'),
(2, 'Pepperoni Feast', 'Double pepperoni with extra mozzarella cheese.', 399.00, 4.7, 'https://images.unsplash.com/photo-1628840042765-356cda07504e?auto=format&fit=crop&w=400&q=80', 1, 'Pizzas'),
(2, 'Garlic Breadsticks', 'Baked dough sticks brushed with garlic butter, served with cheese dip.', 120.00, 4.3, 'https://images.unsplash.com/photo-1544982503-9f984c14501a?auto=format&fit=crop&w=400&q=80', 1, 'Sides');

-- Insert Menu Items for Burger Palace (Restaurant 3)
INSERT INTO menu (restaurantId, itemName, description, price, rating, imagePath, isAvailable, category)
VALUES 
(3, 'Classic Cheese Burger', 'Flame-grilled beef/veg patty with cheddar cheese, lettuce, and secret sauce.', 150.00, 4.2, 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?auto=format&fit=crop&w=400&q=80', 1, 'Burgers'),
(3, 'Spicy Chicken Burger', 'Crispy spicy chicken breast patty with jalapeños and spicy mayo.', 180.00, 4.3, 'https://images.unsplash.com/photo-1550547660-d9450f859349?auto=format&fit=crop&w=400&q=80', 1, 'Burgers'),
(3, 'French Fries', 'Golden crispy salted potato fries.', 90.00, 4.1, 'https://images.unsplash.com/photo-1573080496219-bb080dd4f877?auto=format&fit=crop&w=400&q=80', 1, 'Sides');
