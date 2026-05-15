-- ============================================
-- Library Management System - Sample Data
-- ============================================

USE library_db;

-- Insert Categories
INSERT INTO categories (category_name, description) VALUES
('Fiction', 'Fictional novels and stories'),
('Non-Fiction', 'Real-world topics and factual content'),
('Science', 'Scientific books and research'),
('Technology', 'Computer science and technology books'),
('History', 'Historical events and biographies'),
('Biography', 'Life stories of notable people'),
('Self-Help', 'Personal development and motivation'),
('Business', 'Business and management books'),
('Children', 'Books for children and young readers'),
('Mystery', 'Mystery and thriller novels');

-- Insert Members
INSERT INTO members (name, email, phone, address, membership_date, membership_status) VALUES
('Rahul Sharma', 'rahul.sharma@email.com', '9876543210', '123 MG Road, Mumbai', '2024-01-15', 'Active'),
('Priya Patel', 'priya.patel@email.com', '9876543211', '456 Park Street, Delhi', '2024-02-20', 'Active'),
('Amit Kumar', 'amit.kumar@email.com', '9876543212', '789 Brigade Road, Bangalore', '2024-03-10', 'Active'),
('Sneha Reddy', 'sneha.reddy@email.com', '9876543213', '321 Anna Salai, Chennai', '2024-01-25', 'Active'),
('Vikram Singh', 'vikram.singh@email.com', '9876543214', '654 FC Road, Pune', '2024-04-05', 'Inactive'),
('Anjali Gupta', 'anjali.gupta@email.com', '9876543215', '987 Park Road, Kolkata', '2024-02-14', 'Active'),
('Rohan Mehta', 'rohan.mehta@email.com', '9876543216', '147 MG Road, Hyderabad', '2024-03-20', 'Active'),
('Kavita Joshi', 'kavita.joshi@email.com', '9876543217', '258 Civil Lines, Jaipur', '2024-01-30', 'Active'),
('Arjun Nair', 'arjun.nair@email.com', '9876543218', '369 Marine Drive, Kochi', '2024-04-12', 'Suspended'),
('Deepika Iyer', 'deepika.iyer@email.com', '9876543219', '741 Residency Road, Mysore', '2024-02-28', 'Active');

-- Insert Staff
INSERT INTO staff (name, email, phone, position, salary, hire_date) VALUES
('Suresh Kumar', 'suresh.kumar@library.com', '9123456780', 'Librarian', 45000.00, '2020-06-01'),
('Meena Desai', 'meena.desai@library.com', '9123456781', 'Assistant Librarian', 35000.00, '2021-03-15'),
('Rajesh Verma', 'rajesh.verma@library.com', '9123456782', 'Library Assistant', 28000.00, '2022-01-10'),
('Lakshmi Rao', 'lakshmi.rao@library.com', '9123456783', 'Senior Librarian', 55000.00, '2019-08-20'),
('Karthik Menon', 'karthik.menon@library.com', '9123456784', 'Library Clerk', 25000.00, '2023-02-01');

-- Insert Books
INSERT INTO books (title, author, isbn, category_id, publisher, publication_year, total_copies, available_copies, price) VALUES
('The Great Gatsby', 'F. Scott Fitzgerald', '9780743273565', 1, 'Scribner', 1925, 5, 3, 350.00),
('To Kill a Mockingbird', 'Harper Lee', '9780061120084', 1, 'Harper Perennial', 1960, 4, 2, 400.00),
('1984', 'George Orwell', '9780451524935', 1, 'Signet Classic', 1949, 6, 4, 300.00),
('Sapiens', 'Yuval Noah Harari', '9780062316097', 2, 'Harper', 2011, 5, 5, 550.00),
('A Brief History of Time', 'Stephen Hawking', '9780553380163', 3, 'Bantam', 1988, 3, 2, 450.00),
('Clean Code', 'Robert C. Martin', '9780132350884', 4, 'Prentice Hall', 2008, 7, 5, 650.00),
('The Pragmatic Programmer', 'Andrew Hunt', '9780135957059', 4, 'Addison-Wesley', 1999, 4, 3, 700.00),
('India After Gandhi', 'Ramachandra Guha', '9780330505543', 5, 'Picador', 2007, 3, 3, 800.00),
('Steve Jobs', 'Walter Isaacson', '9781451648539', 6, 'Simon & Schuster', 2011, 4, 2, 600.00),
('Atomic Habits', 'James Clear', '9780735211292', 7, 'Avery', 2018, 8, 6, 400.00),
('Think and Grow Rich', 'Napoleon Hill', '9781585424337', 7, 'Tarcher', 1937, 5, 4, 350.00),
('Good to Great', 'Jim Collins', '9780066620992', 8, 'HarperBusiness', 2001, 4, 4, 500.00),
('Harry Potter and the Sorcerer\'s Stone', 'J.K. Rowling', '9780439708180', 9, 'Scholastic', 1997, 10, 7, 450.00),
('The Hobbit', 'J.R.R. Tolkien', '9780547928227', 9, 'Houghton Mifflin', 1937, 6, 5, 500.00),
('Sherlock Holmes', 'Arthur Conan Doyle', '9780143122876', 10, 'Penguin', 1892, 5, 3, 400.00),
('The Da Vinci Code', 'Dan Brown', '9780307474278', 10, 'Doubleday', 2003, 7, 4, 450.00),
('Introduction to Algorithms', 'Thomas H. Cormen', '9780262033848', 4, 'MIT Press', 2009, 5, 4, 1200.00),
('The Alchemist', 'Paulo Coelho', '9780062315007', 1, 'HarperOne', 1988, 6, 4, 350.00),
('Educated', 'Tara Westover', '9780399590504', 6, 'Random House', 2018, 4, 3, 500.00),
('Becoming', 'Michelle Obama', '9781524763138', 6, 'Crown', 2018, 5, 3, 650.00);

-- Insert Transactions (some current, some returned, some overdue)
INSERT INTO transactions (book_id, member_id, staff_id, borrow_date, due_date, return_date, status) VALUES
(1, 1, 1, '2024-04-01', '2024-04-15', '2024-04-14', 'Returned'),
(2, 2, 2, '2024-04-05', '2024-04-19', '2024-04-18', 'Returned'),
(3, 3, 1, '2024-04-10', '2024-04-24', NULL, 'Borrowed'),
(5, 4, 3, '2024-04-12', '2024-04-26', NULL, 'Borrowed'),
(6, 1, 2, '2024-04-15', '2024-04-29', NULL, 'Borrowed'),
(7, 5, 1, '2024-03-20', '2024-04-03', NULL, 'Overdue'),
(9, 6, 4, '2024-04-08', '2024-04-22', '2024-04-21', 'Returned'),
(10, 7, 2, '2024-04-18', '2024-05-02', NULL, 'Borrowed'),
(13, 8, 3, '2024-04-20', '2024-05-04', NULL, 'Borrowed'),
(15, 2, 1, '2024-03-25', '2024-04-08', NULL, 'Overdue'),
(2, 9, 2, '2024-04-22', '2024-05-06', NULL, 'Borrowed'),
(9, 10, 4, '2024-04-16', '2024-04-30', NULL, 'Borrowed'),
(1, 3, 1, '2024-03-15', '2024-03-29', '2024-03-28', 'Returned'),
(6, 4, 2, '2024-03-18', '2024-04-01', '2024-04-05', 'Returned'),
(10, 5, 3, '2024-03-10', '2024-03-24', NULL, 'Overdue');

-- Insert Fines (for overdue books)
INSERT INTO fines (transaction_id, fine_amount, payment_status, payment_date) VALUES
(6, 215.00, 'Pending', NULL),
(10, 180.00, 'Paid', '2024-04-20'),
(14, 20.00, 'Paid', '2024-04-06'),
(15, 305.00, 'Pending', NULL);

-- Insert Reservations
INSERT INTO reservations (book_id, member_id, reservation_date, status) VALUES
(2, 4, '2024-04-23', 'Active'),
(7, 8, '2024-04-21', 'Active'),
(9, 1, '2024-04-19', 'Fulfilled'),
(15, 3, '2024-04-24', 'Active'),
(6, 10, '2024-04-22', 'Cancelled');

-- Display success message
SELECT 'Sample data inserted successfully!' AS Status;
SELECT 'Total Categories:', COUNT(*) FROM categories;
SELECT 'Total Members:', COUNT(*) FROM members;
SELECT 'Total Staff:', COUNT(*) FROM staff;
SELECT 'Total Books:', COUNT(*) FROM books;
SELECT 'Total Transactions:', COUNT(*) FROM transactions;
SELECT 'Total Fines:', COUNT(*) FROM fines;
SELECT 'Total Reservations:', COUNT(*) FROM reservations;
