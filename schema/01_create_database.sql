-- ============================================
-- Library Management System - Database Creation
-- ============================================

-- Drop database if exists (use with caution in production)
DROP DATABASE IF EXISTS library_db;

-- Create database
CREATE DATABASE library_db;

-- Use the database
USE library_db;

-- Display success message
SELECT 'Database library_db created successfully!' AS Status;
