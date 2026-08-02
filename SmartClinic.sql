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

-- 6. CREATE THE TREATMENT TABLE

CREATE TABLE Treatment (
    TreatmentID INT AUTO_INCREMENT,
    AppointmentID INT NOT NULL,
    Diagnosis VARCHAR(255) NOT NULL,
    TreatmentDescription TEXT NOT NULL,
    TreatmentDate DATE NOT NULL,
    Notes TEXT,

    CONSTRAINT PK_Treatment
        PRIMARY KEY (TreatmentID),

    CONSTRAINT UQ_Treatment_Appointment
        UNIQUE (AppointmentID),

    CONSTRAINT FK_Treatment_Appointment
        FOREIGN KEY (AppointmentID)
        REFERENCES Appointment(AppointmentID)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);


-- 7. CREATE THE MEDICINE TABLE

CREATE TABLE Medicine (
    MedicineID INT AUTO_INCREMENT,
    TreatmentID INT NOT NULL,
    MedicineName VARCHAR(100) NOT NULL,
    Dosage VARCHAR(100) NOT NULL,
    Frequency VARCHAR(100) NOT NULL,
    DurationDays INT NOT NULL,
    Instructions VARCHAR(255),

    CONSTRAINT PK_Medicine
        PRIMARY KEY (MedicineID),

    CONSTRAINT FK_Medicine_Treatment
        FOREIGN KEY (TreatmentID)
        REFERENCES Treatment(TreatmentID)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    CONSTRAINT CHK_Medicine_Duration
        CHECK (DurationDays > 0)
);

-- 8. CREATE THE PAYMENT TABLE

CREATE TABLE Payment (
    PaymentID INT AUTO_INCREMENT,
    AppointmentID INT NOT NULL,
    Amount DECIMAL(10,2) NOT NULL,
    PaymentDate DATE,
    PaymentMethod ENUM(
        'Cash',
        'Mada',
        'Credit Card',
        'Bank Transfer',
        'Insurance'
    ),
    PaymentStatus ENUM(
        'Pending',
        'Paid',
        'Partially Paid',
        'Refunded'
    ) NOT NULL DEFAULT 'Pending',
    TransactionReference VARCHAR(100),

    CONSTRAINT PK_Payment
        PRIMARY KEY (PaymentID),

    CONSTRAINT UQ_Payment_Appointment
        UNIQUE (AppointmentID),

    CONSTRAINT UQ_Payment_Reference
        UNIQUE (TransactionReference),

    CONSTRAINT FK_Payment_Appointment
        FOREIGN KEY (AppointmentID)
        REFERENCES Appointment(AppointmentID)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    CONSTRAINT CHK_Payment_Amount
        CHECK (Amount >= 0)
);


-- insert person records

INSERT INTO Person
    (PersonID, FirstName, LastName, Phone, Email, Address, PersonType)
VALUES
    (1, 'Fahad', 'Alqahtani', '+966501234501',
     'fahad.alqahtani@example.sa',
     'Al Malaz District, Riyadh', 'Patient'),

    (2, 'Noura', 'Alharbi', '+966501234502',
     'noura.alharbi@example.sa',
     'Al Rawdah District, Jeddah', 'Patient'),

    (3, 'Khalid', 'Aldosari', '+966501234503',
     'khalid.aldosari@example.sa',
     'Al Faisaliyah District, Dammam', 'Patient'),

    (4, 'Reem', 'Alotaibi', '+966501234504',
     'reem.alotaibi@example.sa',
     'Al Aziziyah District, Makkah', 'Patient'),

    (5, 'Abdullah', 'Alshammari', '+966501234505',
     'abdullah.alshammari@example.sa',
     'Al Naqrah District, Hail', 'Patient'),

    (6, 'Ahmed', 'Alzahrani', '+966551234601',
     'ahmed.alzahrani@smartclinic.sa',
     'Al Olaya District, Riyadh', 'Doctor'),

    (7, 'Sara', 'Alghamdi', '+966551234602',
     'sara.alghamdi@smartclinic.sa',
     'Al Zahra District, Jeddah', 'Doctor'),

    (8, 'Mohammed', 'Almutairi', '+966551234603',
     'mohammed.almutairi@smartclinic.sa',
     'Al Rakah District, Al Khobar', 'Doctor'),

    (9, 'Lama', 'Alsubaie', '+966551234604',
     'lama.alsubaie@smartclinic.sa',
     'Al Yasmin District, Riyadh', 'Doctor'),

    (10, 'Omar', 'Alenezi', '+966551234605',
     'omar.alenezi@smartclinic.sa',
     'Al Safa District, Jeddah', 'Doctor');



-- INSERT FIVE PATIENT RECORDS

INSERT INTO Patient
    (PatientID, DateOfBirth, Gender)
VALUES
    (1, '1990-03-15', 'Male'),
    (2, '1995-07-22', 'Female'),
    (3, '1983-11-08', 'Male'),
    (4, '2001-01-30', 'Female'),
    (5, '1978-09-12', 'Male');



-- INSERT FIVE DOCTOR RECORDS


INSERT INTO Doctor
    (DoctorID, Specialization, LicenseNumber)
VALUES
    (6, 'General Medicine', 'SCFHS-GM-24001'),
    (7, 'Dermatology', 'SCFHS-DER-24002'),
    (8, 'Cardiology', 'SCFHS-CAR-24003'),
    (9, 'Pediatrics', 'SCFHS-PED-24004'),
    (10, 'Orthopedics', 'SCFHS-ORT-24005');


-- insert five appointment records

INSERT INTO Appointment
    (AppointmentID, PatientID, DoctorID, AppointmentDate,
     AppointmentTime, Reason, Status)
VALUES
    (1, 1, 6, '2026-07-15', '09:00:00',
     'Fever and sore throat', 'Completed'),

    (2, 2, 7, '2026-07-15', '10:30:00',
     'Skin irritation and itching', 'Completed'),

    (3, 3, 8, '2026-07-16', '11:00:00',
     'Chest discomfort and high blood pressure', 'Completed'),

    (4, 4, 9, '2026-07-17', '13:00:00',
     'Seasonal cough and breathing difficulty', 'Completed'),

    (5, 5, 10, '2026-07-18', '15:30:00',
     'Pain in the right knee', 'Completed');

-- insert five treatment records

INSERT INTO Treatment
    (TreatmentID, AppointmentID, Diagnosis,
     TreatmentDescription, TreatmentDate, Notes)
VALUES
    (1, 1,
     'Acute throat infection',
     'The patient was advised to rest, increase fluid intake, and follow the prescribed medication.',
     '2026-07-15',
     'Review after five days if symptoms continue.'),

    (2, 2,
     'Allergic dermatitis',
     'A topical treatment was prescribed, and the patient was advised to avoid possible skin irritants.',
     '2026-07-15',
     'Return if the rash spreads or becomes painful.'),

    (3, 3,
     'Hypertension',
     'Blood pressure medication was prescribed with dietary and lifestyle recommendations.',
     '2026-07-16',
     'Monitor blood pressure daily for two weeks.'),

    (4, 4,
     'Mild respiratory infection',
     'The patient received medication to reduce coughing and improve breathing.',
     '2026-07-17',
     'Avoid dust and strong perfumes during recovery.'),

    (5, 5,
     'Knee joint inflammation',
     'Pain relief medication and reduced physical activity were recommended.',
     '2026-07-18',
     'Follow-up appointment recommended after one week.');


-- INSERT FIVE MEDICINE RECORDS

INSERT INTO Medicine
    (MedicineID, TreatmentID, MedicineName, Dosage,
     Frequency, DurationDays, Instructions)
VALUES
    (1, 1, 'Amoxicillin', '500 mg',
     'Three times daily', 5,
     'Take after meals and complete the full course.'),

    (2, 2, 'Hydrocortisone Cream', '1%',
     'Twice daily', 7,
     'Apply a thin layer to the affected area.'),

    (3, 3, 'Amlodipine', '5 mg',
     'Once daily', 30,
     'Take at the same time every day.'),

    (4, 4, 'Salbutamol Inhaler', '100 mcg',
     'When required', 10,
     'Use according to the doctor’s instructions.'),

    (5, 5, 'Ibuprofen', '400 mg',
     'Twice daily', 5,
     'Take after meals and do not exceed the prescribed dose.');


-- INSERT FIVE PAYMENT RECORDS

INSERT INTO Payment
    (PaymentID, AppointmentID, Amount, PaymentDate,
     PaymentMethod, PaymentStatus, TransactionReference)
VALUES
    (1, 1, 250.00, '2026-07-15',
     'Mada', 'Paid', 'MADA-RYD-20260715-001'),

    (2, 2, 350.00, '2026-07-15',
     'Credit Card', 'Paid', 'CC-JED-20260715-002'),

    (3, 3, 500.00, '2026-07-16',
     'Insurance', 'Paid', 'INS-DMM-20260716-003'),

    (4, 4, 300.00, '2026-07-17',
     'Cash', 'Paid', 'CASH-MKH-20260717-004'),

    (5, 5, 450.00, '2026-07-18',
     'Bank Transfer', 'Paid', 'BANK-HIL-20260718-005');
