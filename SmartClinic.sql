-- =========================================================
-- 1. CREATE THE DATABASE
-- =========================================================

DROP DATABASE IF EXISTS SmartClinicDB;

CREATE DATABASE SmartClinicDB
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

USE SmartClinicDB;


-- 2. CREATE THE PERSON SUPERCLASS

CREATE TABLE Person (
    PersonID INT AUTO_INCREMENT,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Phone VARCHAR(20) NOT NULL,
    Email VARCHAR(100),
    Address VARCHAR(200) NOT NULL,
    PersonType ENUM('Patient', 'Doctor') NOT NULL,

    CONSTRAINT PK_Person
        PRIMARY KEY (PersonID),

    CONSTRAINT UQ_Person_Phone
        UNIQUE (Phone),

    CONSTRAINT UQ_Person_Email
        UNIQUE (Email)
);

