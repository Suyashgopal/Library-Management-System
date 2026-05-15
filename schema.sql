-- Simple Library Management System
-- Database Schema

-- Create Database
CREATE DATABASE IF NOT EXISTS library_db;
USE library_db;

-- Table 1: Categories
CREATE TABLE categories (
    category_id INT PRIMARY KEY AUTO_INCREMENT,
    category_name VARCHAR(50) NOT NULL UNIQUE
);

-- Table 2: Books
CREATE TABLE books (
    book_id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(100) NOT NULL,
    author VARCHAR(100) NOT NULL,
    category_id INT,
    price DECIMAL(10, 2),
    available BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (category_id) REFERENCES categories(category_id)
);

-- Table 3: Members
CREATE TABLE members (
    member_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(15),
    join_date DATE DEFAULT (CURRENT_DATE)
);

-- Table 4: Transactions
CREATE TABLE transactions (
    transaction_id INT PRIMARY KEY AUTO_INCREMENT,
    book_id INT NOT NULL,
    member_id INT NOT NULL,
    borrow_date DATE NOT NULL,
    return_date DATE,
    due_date DATE NOT NULL,
    fine DECIMAL(10, 2) DEFAULT 0,
    FOREIGN KEY (book_id) REFERENCES books(book_id),
    FOREIGN KEY (member_id) REFERENCES members(member_id)
);

-- Create Indexes for better performance
CREATE INDEX idx_book_title ON books(title);
CREATE INDEX idx_member_email ON members(email);
CREATE INDEX idx_transaction_dates ON transactions(borrow_date, return_date);
