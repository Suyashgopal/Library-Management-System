# Simple Library Management System

A beginner-friendly MySQL database project for managing books, members, and borrowing transactions.

## Project Overview

This is a simple library management system built using MySQL. It demonstrates basic database concepts including table creation, relationships, CRUD operations, joins, stored procedures, and triggers.

## Database Schema

The system uses 4 tables:
- **Books** - Store book information
- **Members** - Store library member details
- **Transactions** - Track book borrowing and returns
- **Categories** - Book categories

## Features

- Add and manage books
- Register library members
- Borrow and return books
- Track book availability
- Calculate late fees automatically
- View borrowing history

## Technologies Used

- MySQL 8.0+

## Setup Instructions

1. Create the database:
```sql
source schema.sql
```

2. Insert sample data:
```sql
source sample_data.sql
```

3. Run queries from `queries.sql` to test the system

## Key SQL Concepts Demonstrated

- Database and table creation
- Primary and foreign keys
- One-to-many relationships
- Basic normalization (3NF)
- INSERT, UPDATE, DELETE operations
- SELECT queries with WHERE, ORDER BY
- JOIN operations (INNER JOIN)
- Aggregate functions (COUNT, SUM, AVG)
- Stored procedures
- Triggers
- Date functions

## Resume Description

**Simple Library Management System**
- Designed and implemented a MySQL database for library operations with 4 normalized tables
- Created stored procedures for book borrowing with automatic availability updates
- Implemented triggers for calculating late fees on book returns
- Wrote 10+ SQL queries including JOINs and aggregate functions for reporting
- Demonstrated database normalization, indexing, and referential integrity

## Author

Final Year Student Project - Database Management Systems
