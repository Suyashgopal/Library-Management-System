-- Sample Data for Library Management System
USE library_db;

-- Insert Categories
INSERT INTO categories (category_name) VALUES
('Fiction'),
('Science'),
('History'),
('Technology'),
('Biography');

-- Insert Books
INSERT INTO books (title, author, category_id, price, available) VALUES
('The Great Gatsby', 'F. Scott Fitzgerald', 1, 299.99, TRUE),
('1984', 'George Orwell', 1, 349.99, TRUE),
('A Brief History of Time', 'Stephen Hawking', 2, 499.99, TRUE),
('Sapiens', 'Yuval Noah Harari', 3, 599.99, TRUE),
('Clean Code', 'Robert Martin', 4, 799.99, TRUE),
('Steve Jobs', 'Walter Isaacson', 5, 699.99, TRUE),
('To Kill a Mockingbird', 'Harper Lee', 1, 399.99, TRUE),
('The Origin of Species', 'Charles Darwin', 2, 449.99, TRUE);

-- Insert Members
INSERT INTO members (name, email, phone, join_date) VALUES
('Rahul Sharma', 'rahul@email.com', '9876543210', '2024-01-15'),
('Priya Patel', 'priya@email.com', '9876543211', '2024-02-20'),
('Amit Kumar', 'amit@email.com', '9876543212', '2024-03-10'),
('Sneha Reddy', 'sneha@email.com', '9876543213', '2024-04-05'),
('Vikram Singh', 'vikram@email.com', '9876543214', '2024-05-12');

-- Insert Transactions (Some books borrowed, some returned)
INSERT INTO transactions (book_id, member_id, borrow_date, return_date, due_date, fine) VALUES
(1, 1, '2024-05-01', '2024-05-10', '2024-05-15', 0),
(2, 2, '2024-05-05', NULL, '2024-05-19', 0),
(3, 3, '2024-05-08', '2024-05-25', '2024-05-22', 30),
(4, 1, '2024-05-10', NULL, '2024-05-24', 0),
(5, 4, '2024-05-12', '2024-05-20', '2024-05-26', 0);
