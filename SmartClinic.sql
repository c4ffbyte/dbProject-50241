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


-- 3. CREATE THE PATIENT SUBCLASS

CREATE TABLE Patient (
    PatientID INT,
    DateOfBirth DATE NOT NULL,
    Gender ENUM('Male', 'Female') NOT NULL,

    CONSTRAINT PK_Patient
        PRIMARY KEY (PatientID),

    CONSTRAINT FK_Patient_Person
        FOREIGN KEY (PatientID)
        REFERENCES Person(PersonID)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);

-- 4. CREATE THE DOCTOR SUBCLASS

CREATE TABLE Doctor (
    DoctorID INT,
    Specialization VARCHAR(100) NOT NULL,
    LicenseNumber VARCHAR(50) NOT NULL,

    CONSTRAINT PK_Doctor
        PRIMARY KEY (DoctorID),

    CONSTRAINT UQ_Doctor_License
        UNIQUE (LicenseNumber),

    CONSTRAINT FK_Doctor_Person
        FOREIGN KEY (DoctorID)
        REFERENCES Person(PersonID)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);



-- 5. CREATE THE APPOINTMENT TABLE

CREATE TABLE Appointment (
    AppointmentID INT AUTO_INCREMENT,
    PatientID INT NOT NULL,
    DoctorID INT NOT NULL,
    AppointmentDate DATE NOT NULL,
    AppointmentTime TIME NOT NULL,
    Reason VARCHAR(255) NOT NULL,
    Status ENUM(
        'Scheduled',
        'Completed',
        'Cancelled',
        'No Show'
    ) NOT NULL DEFAULT 'Scheduled',

    CONSTRAINT PK_Appointment
        PRIMARY KEY (AppointmentID),

    CONSTRAINT FK_Appointment_Patient
        FOREIGN KEY (PatientID)
        REFERENCES Patient(PatientID)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT FK_Appointment_Doctor
        FOREIGN KEY (DoctorID)
        REFERENCES Doctor(DoctorID)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT UQ_Doctor_Schedule
        UNIQUE (DoctorID, AppointmentDate, AppointmentTime)
);
