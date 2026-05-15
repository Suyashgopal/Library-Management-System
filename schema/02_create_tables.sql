-- ============================================
-- Library Management System - Table Creation
-- ============================================

USE library_db;

-- ============================================
-- Table: categories
-- Purpose: Store book categories
-- ============================================
CREATE TABLE categories (
    category_id INT PRIMARY KEY AUTO_INCREMENT,
    category_name VARCHAR(50) NOT NULL UNIQUE,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ============================================
-- Table: members
-- Purpose: Store library member information
-- ============================================
CREATE TABLE members (
    member_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    phone VARCHAR(15) NOT NULL,
    address TEXT,
    membership_date DATE NOT NULL DEFAULT (CURRENT_DATE),
    membership_status ENUM('Active', 'Inactive', 'Suspended') DEFAULT 'Active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT chk_phone CHECK (phone REGEXP '^[0-9]{10,15}$')
);

-- ============================================
-- Table: staff
-- Purpose: Store library staff information
-- ============================================
CREATE TABLE staff (
    staff_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    phone VARCHAR(15) NOT NULL,
    position VARCHAR(50) NOT NULL,
    salary DECIMAL(10, 2) CHECK (salary > 0),
    hire_date DATE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ============================================
-- Table: books
-- Purpose: Store book inventory
-- ============================================
CREATE TABLE books (
    book_id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(200) NOT NULL,
    author VARCHAR(100) NOT NULL,
    isbn VARCHAR(13) UNIQUE,
    category_id INT NOT NULL,
    publisher VARCHAR(100),
    publication_year YEAR,
    total_copies INT NOT NULL DEFAULT 1 CHECK (total_copies > 0),
    available_copies INT NOT NULL DEFAULT 1 CHECK (available_copies >= 0),
    price DECIMAL(10, 2) CHECK (price >= 0),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (category_id) REFERENCES categories(category_id) ON DELETE RESTRICT,
    CONSTRAINT chk_available_copies CHECK (available_copies <= total_copies)
);

-- ============================================
-- Table: transactions
-- Purpose: Store book borrowing and return records
-- ============================================
CREATE TABLE transactions (
    transaction_id INT PRIMARY KEY AUTO_INCREMENT,
    book_id INT NOT NULL,
    member_id INT NOT NULL,
    staff_id INT NOT NULL,
    borrow_date DATE NOT NULL DEFAULT (CURRENT_DATE),
    due_date DATE NOT NULL,
    return_date DATE,
    status ENUM('Borrowed', 'Returned', 'Overdue') DEFAULT 'Borrowed',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (book_id) REFERENCES books(book_id) ON DELETE RESTRICT,
    FOREIGN KEY (member_id) REFERENCES members(member_id) ON DELETE RESTRICT,
    FOREIGN KEY (staff_id) REFERENCES staff(staff_id) ON DELETE RESTRICT,
    CONSTRAINT chk_dates CHECK (due_date > borrow_date),
    CONSTRAINT chk_return_date CHECK (return_date IS NULL OR return_date >= borrow_date)
);

-- ============================================
-- Table: fines
-- Purpose: Store fine information for overdue books
-- ============================================
CREATE TABLE fines (
    fine_id INT PRIMARY KEY AUTO_INCREMENT,
    transaction_id INT NOT NULL UNIQUE,
    fine_amount DECIMAL(10, 2) NOT NULL CHECK (fine_amount >= 0),
    payment_status ENUM('Pending', 'Paid', 'Waived') DEFAULT 'Pending',
    payment_date DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (transaction_id) REFERENCES transactions(transaction_id) ON DELETE CASCADE
);

-- ============================================
-- Table: reservations
-- Purpose: Store book reservation requests
-- ============================================
CREATE TABLE reservations (
    reservation_id INT PRIMARY KEY AUTO_INCREMENT,
    book_id INT NOT NULL,
    member_id INT NOT NULL,
    reservation_date DATE NOT NULL DEFAULT (CURRENT_DATE),
    status ENUM('Active', 'Fulfilled', 'Cancelled') DEFAULT 'Active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (book_id) REFERENCES books(book_id) ON DELETE CASCADE,
    FOREIGN KEY (member_id) REFERENCES members(member_id) ON DELETE CASCADE
);

-- ============================================
-- Table: audit_log
-- Purpose: Store audit trail of all transactions
-- ============================================
CREATE TABLE audit_log (
    log_id INT PRIMARY KEY AUTO_INCREMENT,
    transaction_id INT NOT NULL,
    action VARCHAR(50) NOT NULL,
    action_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    details TEXT,
    FOREIGN KEY (transaction_id) REFERENCES transactions(transaction_id) ON DELETE CASCADE
);

-- Display success message
SELECT 'All tables created successfully!' AS Status;
