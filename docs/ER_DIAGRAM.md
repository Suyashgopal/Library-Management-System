# Library Management System - Entity Relationship Diagram

## Database Schema Overview

### Tables and Relationships

```
┌─────────────────┐
│   categories    │
├─────────────────┤
│ PK category_id  │
│    category_name│
│    description  │
│    created_at   │
└────────┬────────┘
         │
         │ 1:N
         │
┌────────▼────────┐         ┌─────────────────┐
│     books       │         │  reservations   │
├─────────────────┤         ├─────────────────┤
│ PK book_id      │◄────────┤ PK reservation_id│
│ FK category_id  │    N:1  │ FK book_id      │
│    title        │         │ FK member_id    │
│    author       │         │    reservation_ │
│    isbn         │         │    date         │
│    publisher    │         │    status       │
│    publication_ │         │    created_at   │
│    year         │         └────────┬────────┘
│    total_copies │                  │
│    available_   │                  │ N:1
│    copies       │                  │
│    price        │         ┌────────▼────────┐
│    created_at   │         │    members      │
└────────┬────────┘         ├─────────────────┤
         │                  │ PK member_id    │
         │ 1:N              │    name         │
         │                  │    email        │
┌────────▼────────┐         │    phone        │
│  transactions   │◄────────┤    address      │
├─────────────────┤    N:1  │    membership_  │
│ PK transaction_ │         │    date         │
│    id           │         │    membership_  │
│ FK book_id      │         │    status       │
│ FK member_id    │         │    created_at   │
│ FK staff_id     │         └─────────────────┘
│    borrow_date  │
│    due_date     │         ┌─────────────────┐
│    return_date  │         │     staff       │
│    status       │◄────────┤─────────────────┤
│    created_at   │    N:1  │ PK staff_id     │
└────────┬────────┘         │    name         │
         │                  │    email        │
         │ 1:1              │    phone        │
         │                  │    position     │
┌────────▼────────┐         │    salary       │
│     fines       │         │    hire_date    │
├─────────────────┤         │    created_at   │
│ PK fine_id      │         └─────────────────┘
│ FK transaction_ │
│    id (UNIQUE)  │
│    fine_amount  │         ┌─────────────────┐
│    payment_     │         │   audit_log     │
│    status       │         ├─────────────────┤
│    payment_date │         │ PK log_id       │
│    created_at   │         │ FK transaction_ │
└─────────────────┘         │    id           │
                            │    action       │
                            │    action_date  │
                            │    details      │
                            └─────────────────┘
```

## Table Descriptions

### 1. categories
- **Purpose**: Store book categories/genres
- **Key Fields**: category_id (PK), category_name (UNIQUE)
- **Relationships**: One-to-Many with books

### 2. books
- **Purpose**: Store book inventory information
- **Key Fields**: book_id (PK), category_id (FK), isbn (UNIQUE)
- **Constraints**: 
  - available_copies <= total_copies
  - price >= 0
- **Relationships**: 
  - Many-to-One with categories
  - One-to-Many with transactions
  - One-to-Many with reservations

### 3. members
- **Purpose**: Store library member information
- **Key Fields**: member_id (PK), email (UNIQUE)
- **Constraints**: 
  - phone must be 10-15 digits
  - membership_status: Active/Inactive/Suspended
- **Relationships**: 
  - One-to-Many with transactions
  - One-to-Many with reservations

### 4. staff
- **Purpose**: Store library staff information
- **Key Fields**: staff_id (PK), email (UNIQUE)
- **Constraints**: salary > 0
- **Relationships**: One-to-Many with transactions

### 5. transactions
- **Purpose**: Store book borrowing and return records
- **Key Fields**: transaction_id (PK), book_id (FK), member_id (FK), staff_id (FK)
- **Constraints**: 
  - due_date > borrow_date
  - return_date >= borrow_date (if not NULL)
  - status: Borrowed/Returned/Overdue
- **Relationships**: 
  - Many-to-One with books
  - Many-to-One with members
  - Many-to-One with staff
  - One-to-One with fines
  - One-to-Many with audit_log

### 6. fines
- **Purpose**: Store fine information for overdue books
- **Key Fields**: fine_id (PK), transaction_id (FK, UNIQUE)
- **Constraints**: 
  - fine_amount >= 0
  - payment_status: Pending/Paid/Waived
- **Relationships**: One-to-One with transactions

### 7. reservations
- **Purpose**: Store book reservation requests
- **Key Fields**: reservation_id (PK), book_id (FK), member_id (FK)
- **Constraints**: status: Active/Fulfilled/Cancelled
- **Relationships**: 
  - Many-to-One with books
  - Many-to-One with members

### 8. audit_log
- **Purpose**: Store audit trail of all transactions (auto-populated via trigger)
- **Key Fields**: log_id (PK), transaction_id (FK)
- **Relationships**: Many-to-One with transactions

## Cardinality Summary

| Relationship | Type | Description |
|-------------|------|-------------|
| categories → books | 1:N | One category has many books |
| books → transactions | 1:N | One book can be borrowed multiple times |
| members → transactions | 1:N | One member can borrow multiple books |
| staff → transactions | 1:N | One staff member handles multiple transactions |
| transactions → fines | 1:1 | One transaction can have at most one fine |
| transactions → audit_log | 1:N | One transaction can have multiple audit entries |
| books → reservations | 1:N | One book can have multiple reservations |
| members → reservations | 1:N | One member can reserve multiple books |

## Normalization Level: 3NF (Third Normal Form)

### 1NF (First Normal Form)
✅ All tables have primary keys
✅ All columns contain atomic values
✅ No repeating groups

### 2NF (Second Normal Form)
✅ All non-key attributes are fully dependent on primary key
✅ No partial dependencies

### 3NF (Third Normal Form)
✅ No transitive dependencies
✅ All non-key attributes depend only on primary key

## Indexes

### Primary Indexes (Automatic)
- All primary keys are automatically indexed

### Foreign Key Indexes
- books.category_id
- transactions.book_id
- transactions.member_id
- transactions.staff_id
- fines.transaction_id
- reservations.book_id
- reservations.member_id

### Additional Indexes for Performance
- members.email
- books.title
- books.author
- transactions.status
- transactions.due_date
- fines.payment_status
- Composite: transactions(member_id, status)
- Composite: books(category_id, available_copies)

## Constraints Summary

### Primary Keys
All tables have auto-incrementing integer primary keys

### Foreign Keys
- All foreign keys have ON DELETE RESTRICT (except audit_log and reservations with CASCADE)
- Ensures referential integrity

### Unique Constraints
- categories.category_name
- members.email
- staff.email
- books.isbn

### Check Constraints
- books: available_copies <= total_copies
- books: price >= 0
- members: phone format validation
- transactions: date validations
- fines: fine_amount >= 0

### Default Values
- Timestamps: CURRENT_TIMESTAMP
- Dates: CURRENT_DATE
- Status fields: Appropriate default values
