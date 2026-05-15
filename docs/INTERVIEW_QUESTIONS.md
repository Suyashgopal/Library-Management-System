# Library Management System - Interview Questions & Answers

## Database Design Questions

### Q1: Why did you choose a Library Management System for your project?
**Answer**: I chose a Library Management System because it demonstrates real-world database concepts with practical business logic. It involves multiple entities with complex relationships, requires transaction management, and showcases various SQL features like triggers, stored procedures, and constraints. It's also relatable and easy to explain to interviewers.

### Q2: Explain the database schema and table relationships.
**Answer**: The database has 8 tables:
- **categories** and **books** (1:N) - Each category has multiple books
- **books** and **transactions** (1:N) - Each book can be borrowed multiple times
- **members** and **transactions** (1:N) - Each member can borrow multiple books
- **staff** and **transactions** (1:N) - Each staff member handles multiple transactions
- **transactions** and **fines** (1:1) - Each transaction can have at most one fine
- **books** and **reservations** (1:N) - Books can be reserved by multiple members

### Q3: What normalization level does your database follow?
**Answer**: The database follows Third Normal Form (3NF):
- **1NF**: All tables have primary keys, atomic values, no repeating groups
- **2NF**: No partial dependencies - all non-key attributes fully depend on primary key
- **3NF**: No transitive dependencies - all attributes depend only on primary key

For example, instead of storing category_name in the books table, I created a separate categories table and use category_id as a foreign key.

### Q4: Why did you use separate tables for fines and transacti