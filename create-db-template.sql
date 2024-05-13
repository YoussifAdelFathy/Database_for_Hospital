-- Active: 1702508274872@@127.0.0.1@3306@hospitaldb

CREATE TABLE WardBoy
(
  WardBoyID INT NOT NULL,
  Fname VARCHAR(50) NOT NULL,
  Lname VARCHAR(50) NOT NULL,
  Salary DECIMAL(10, 2) NOT NULL,
  PhoneNumber VARCHAR(20) NOT NULL,
  DateOfBirth DATE NOT NULL,
  Gender CHAR(1) NOT NULL,
  ShiftTiming VARCHAR(50) NOT NULL,
  PRIMARY KEY (WardBoyID)
);

CREATE TABLE Nurse
(
  NurseID INT NOT NULL,
  Fname VARCHAR(50) NOT NULL,
  Lname VARCHAR(50) NOT NULL,
  DateOfBirth DATE NOT NULL,
  Salary DECIMAL(10, 2) NOT NULL,
  Gender CHAR(1) NOT NULL,
  ShiftTiming VARCHAR(50) NOT NULL,
  PRIMARY KEY (NurseID)
);

CREATE TABLE Doctor
(
  DoctorID INT NOT NULL,
  Fname VARCHAR(50) NOT NULL,
  Lname VARCHAR(50) NOT NULL,
  PhoneNumber VARCHAR(20) NOT NULL,
  DateOfBirth DATE NOT NULL,
  Gender CHAR(1) NOT NULL,
  Specialization VARCHAR(100) NOT NULL,
  Salary DECIMAL(10, 2) NOT NULL,
  PRIMARY KEY (DoctorID)
);

CREATE TABLE InsuranceCompany
(
  InsuranceID INT NOT NULL,
  DiscountPercentage DECIMAL(5, 2) NOT NULL,
  CompanyName VARCHAR(100) NOT NULL,
  PRIMARY KEY (InsuranceID)
);

CREATE TABLE LabTechnician
(
  TechnicianID INT NOT NULL,
  Fname VARCHAR(50) NOT NULL,
  Lname VARCHAR(50) NOT NULL,
  DateOfBirth DATE NOT NULL,
  Gender CHAR(1) NOT NULL,
  Salary DECIMAL(10, 2) NOT NULL,
  PRIMARY KEY (TechnicianID)
);

CREATE TABLE Hospital
(
  HospitalID INT NOT NULL,
  Name VARCHAR(100) NOT NULL,
  Address VARCHAR(255) NOT NULL,
  PRIMARY KEY (HospitalID)
);

CREATE TABLE AdministrativeStaff
(
  StaffID INT NOT NULL,
  Fname VARCHAR(50) NOT NULL,
  Lname VARCHAR(50) NOT NULL,
  PhoneNumber VARCHAR(20) NOT NULL,
  Age INT NOT NULL,
  DateOfBirth DATE NOT NULL,
  Gender CHAR(1) NOT NULL,
  Salary DECIMAL(10, 2) NOT NULL,
  Role VARCHAR(100) NOT NULL,
  HospitalID INT NOT NULL,
  PRIMARY KEY (StaffID),
  FOREIGN KEY (HospitalID) REFERENCES Hospital(HospitalID)
);
# select fname, lname from administrativeStaff where age > 30 and salary > 3000 and role = 'Administrator';
# index the hospital id in the administrative staff table


CREATE TABLE HospitalAssociateDoctor
(
  HospitalID INT NOT NULL,
  DoctorID INT NOT NULL,
  PRIMARY KEY (HospitalID, DoctorID),
  FOREIGN KEY (HospitalID) REFERENCES Hospital(HospitalID),
  FOREIGN KEY (DoctorID) REFERENCES Doctor(DoctorID)
);

CREATE TABLE Bill
(
  BillID INT NOT NULL,
  TreatmentReceived INT NOT NULL,
  DayPrice INT NOT NULL,
  NumberOfDays INT NOT NULL,
  InsuranceID INT,
  PRIMARY KEY (BillID),
  FOREIGN KEY (InsuranceID) REFERENCES InsuranceCompany(InsuranceID)
);

CREATE TABLE Room
(
  RoomID INT NOT NULL,
  Type_ VARCHAR(10) NOT NULL,
  NumberOfBeds INT NOT NULL,
  Availability BOOLEAN NOT NULL,
  Visitability BOOLEAN NOT NULL,
  HospitalID INT NOT NULL,
  PRIMARY KEY (RoomID),
  FOREIGN KEY (HospitalID) REFERENCES Hospital(HospitalID)
);

CREATE TABLE Pharmacy
(
  PharmacyID INT NOT NULL,
  StartTime TIME,
  EndTime TIME,
  PhoneNumber VARCHAR(20),
  Email VARCHAR(30),
  InventoryCapacity INT,
  StaffCount INT NOT NULL,
  HospitalID INT NOT NULL,
  PRIMARY KEY (PharmacyID),
  FOREIGN KEY (HospitalID) REFERENCES Hospital(HospitalID)
);

CREATE TABLE Medicine
(
  MedicineCode INT NOT NULL,
  Quantity INT,
  Price INT NOT NULL,
  PharmacyID INT NOT NULL,
  PRIMARY KEY (MedicineCode),
  FOREIGN KEY (PharmacyID) REFERENCES Pharmacy(PharmacyID)
);

CREATE TABLE Labs
(
  LabID INT NOT NULL,
  Name VARCHAR(30) NOT NULL,
  Location VARCHAR(30) NOT NULL,
  PhoneNumber VARCHAR(20),
  Supervisor VARCHAR(30),
  Email VARCHAR(30),
  HospitalID INT NOT NULL,
  PRIMARY KEY (LabID),
  FOREIGN KEY (HospitalID) REFERENCES Hospital(HospitalID)
);

CREATE TABLE manage_nurse
(
  NurseID INT NOT NULL,
  RoomID INT NOT NULL,
  PRIMARY KEY (NurseID, RoomID),
  FOREIGN KEY (NurseID) REFERENCES Nurse(NurseID),
  FOREIGN KEY (RoomID) REFERENCES Room(RoomID)
);

CREATE TABLE manage_wardBOY
(
  RoomID INT NOT NULL,
  WardBoyID INT NOT NULL,
  PRIMARY KEY (RoomID, WardBoyID),
  FOREIGN KEY (RoomID) REFERENCES Room(RoomID),
  FOREIGN KEY (WardBoyID) REFERENCES WardBoy(WardBoyID)
);

CREATE TABLE lab_associate_labTech
(
  TechnicianID INT NOT NULL,
  LabID INT NOT NULL,
  PRIMARY KEY (TechnicianID, LabID),
  FOREIGN KEY (TechnicianID) REFERENCES LabTechnician(TechnicianID),
  FOREIGN KEY (LabID) REFERENCES Labs(LabID)
);

CREATE TABLE Patient
(
  PatientID INT NOT NULL,
  Fname VARCHAR(20) NOT NULL,
  Lname VARCHAR(20) NOT NULL,
  PhoneNumber VARCHAR(20),
  Disease VARCHAR(30),
  Treatment VARCHAR(30),
  DateOfBirth DATE NOT NULL,
  Gender BOOLEAN,
  CheckInDate TIME NOT NULL,
  CheckOutDate TIME NOT NULL,
  Address VARCHAR(50),
  Email VARCHAR(30),
  BloodType VARCHAR(3),
  MedicalHistory VARCHAR(30),
  DoctorID INT NOT NULL,
  RoomID INT NOT NULL,
  BillID INT NOT NULL,
  PRIMARY KEY (PatientID),
  FOREIGN KEY (DoctorID) REFERENCES Doctor(DoctorID),
  FOREIGN KEY (RoomID) REFERENCES Room(RoomID),
  FOREIGN KEY (BillID) REFERENCES Bill(BillID)
);

CREATE TABLE admit
(
  PatientID INT NOT NULL,
  HospitalID INT NOT NULL,
  PRIMARY KEY (PatientID, HospitalID),
  FOREIGN KEY (PatientID) REFERENCES Patient(PatientID),
  FOREIGN KEY (HospitalID) REFERENCES Hospital(HospitalID)
);

CREATE TABLE undergo_tests
(
  LabID INT NOT NULL,
  PatientID INT NOT NULL,
  PRIMARY KEY (LabID, PatientID),
  FOREIGN KEY (LabID) REFERENCES Labs(LabID),
  FOREIGN KEY (PatientID) REFERENCES Patient(PatientID)
);

INSERT INTO WardBoy (WardBoyID, Fname, Lname, Salary, PhoneNumber, DateOfBirth, Gender, ShiftTiming)
VALUES 
(1, 'Amr', 'Mahmoud', 2500.00, '01012345678', '1990-05-15', 1, 'Morning'),
(2, 'Yara', 'Ali', 2200.00, '01123456789', '1995-09-20', 0, 'Evening'),
(3, 'Tamer', 'Said', 2000.00, '01234567890', '1988-12-10', 1, 'Night'),
(4, 'Nour', 'Mohamed', 2400.00, '01098765432', '1992-03-25', 0, 'Morning'),
(5, 'Hassan', 'Amin', 2100.00, '01109876543', '1997-08-05', 1, 'Evening');

INSERT INTO Nurse (NurseID, Fname, Lname, DateOfBirth, Salary, Gender, ShiftTiming)
VALUES 
(1, 'Fatma', 'Ibrahim', '1993-07-12', 2800.00, 0, 'Day'),
(2, 'Ahmed', 'Hassan', '1990-10-28', 3000.00, 1, 'Night'),
(3, 'Nada', 'Osman', '1985-04-15', 3200.00, 0, 'Day'),
(4, 'Karim', 'Mahmoud', '1995-12-30', 2900.00, 1, 'Night'),
(5, 'Aya', 'Khaled', '1989-09-05', 2700.00, 0, 'Day');


INSERT INTO Doctor (DoctorID, Fname, Lname, PhoneNumber, DateOfBirth, Gender, Specialization, Salary)
VALUES 
(1, 'Dr. Hesham', 'Abdel-Rahman', '01011223344', '1980-03-10', 1, 'Cardiology', 8000.00),
(2, 'Dr. Amira', 'Fawzy', '01122334455', '1985-09-18', 0, 'Neurology', 8500.00),
(3, 'Dr. Mahmoud', 'Salah', '01233445566', '1975-11-25', 1, 'Oncology', 8200.00),
(4, 'Dr. Nour', 'Khalil', '01098765432', '1990-05-08', 0, 'Pediatrics', 7800.00),
(5, 'Dr. Youssef', 'Said', '01234567890', '1988-12-20', 1, 'Dermatology', 8300.00);

INSERT INTO InsuranceCompany (InsuranceID, DiscountPercentage, CompanyName)
VALUES 
(6, 14.0, 'PharaohCare'),
(7, 11.5, 'NileGuard'),
(8, 13.2, 'PyramidHealth'),
(9, 12.8, 'SphinxInsure'),
(10, 15.7, 'CairoWellness');

INSERT INTO LabTechnician (TechnicianID, Fname, Lname, DateOfBirth, Gender, Salary)
VALUES 
(6, 'Aisha', 'Gaber', '1993-05-10', 0, 3800.00),
(7, 'Youssef', 'Farouk', '1991-09-15', 1, 3600.00),
(8, 'Samira', 'Adel', '1987-07-22', 0, 4000.00),
(9, 'Karim', 'Maher', '1996-02-18', 1, 3500.00),
(10, 'Nadia', 'Ezzat', '1990-12-05', 0, 3700.00);


INSERT INTO Hospital (HospitalID, Name, Address)
VALUES 
(1, 'Cairo General Hospital', '123 Nile Street, Cairo'),
(2, 'Luxor Medical Center', '45 Pharaoh Avenue, Luxor'),
(3, 'Alexandria Healthcare Hub', '67 Mediterranean Road, Alexandria'),
(4, 'Aswan Community Hospital', '89 Nile Crescent, Aswan'),
(5, 'Giza Wellness Clinic', '76 Pyramid Road, Giza');

INSERT INTO AdministrativeStaff (StaffID, Fname, Lname, PhoneNumber, Age, DateOfBirth, Gender, Salary, Role, HospitalID)
VALUES 
(1, 'Ahmed', 'Hassan', '01012345678', 30, '1992-03-15', 1, 3000.00, 'Administrator', 1),
(2, 'Fatma', 'Ali', '01123456789', 28, '1994-07-20', 0, 2800.00, 'HR Manager', 2),
(3, 'Youssef', 'Khalil', '01234567890', 35, '1987-11-10', 1, 3200.00, 'Finance Officer', 3),
(4, 'Nada', 'Mohamed', '01098765432', 26, '1996-05-25', 0, 2600.00, 'IT Specialist', 4),
(5, 'Sara', 'Mahmoud', '01109876543', 33, '1989-09-08', 0, 2900.00, 'Quality Control', 5);

 

INSERT INTO HospitalAssociateDoctor (HospitalID, DoctorID)
VALUES 
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5);


INSERT INTO Bill (BillID, TreatmentReceived, DayPrice, NumberOfDays, InsuranceID)
VALUES 
(1, 1001, 150, 5, 6),
(2, 1002, 200, 4, 7),
(3, 1003, 180, 3, 8),
(4, 1004, 220, 6, 9),
(5, 1005, 175, 2, 10);



INSERT INTO Room (RoomID, Type_, NumberOfBeds, Availability, Visitability, HospitalID)
VALUES 
(1, 'Standard', 2, true, true, 1),
(2, 'ICU', 1, false, true, 2),
(3, 'Maternity', 3, true, false, 3),
(4, 'Emergency', 4, true, true, 4),
(5, 'Private', 1, true, false, 5);


INSERT INTO Pharmacy (PharmacyID, StartTime, EndTime, PhoneNumber, Email, InventoryCapacity, StaffCount, HospitalID)VALUES 
(1, '08:00:00', '08:00:00', '0101234567', 'pharmacy1@example.com', 200, 8, 1),
(2, '09:30:00', '21:30:00', '0112345678', 'pharmacy2@example.com', 250, 6, 2),
(3, '07:45:00', '19:45:00', '0123456789', 'pharmacy3@example.com', 180, 5, 3),
(4, '10:00:00', '22:00:00', '0134567890', 'pharmacy4@example.com', 300, 10, 4),
(5, '08:30:00', '20:30:00', '0145678901', 'pharmacy5@example.com', 220, 7, 5);


INSERT INTO Medicine (MedicineCode, Quantity, Price, PharmacyID)
VALUES 
(1001, 50, 10, 1),
(1002, 40, 15, 2),
(1003, 30, 20, 3),
(1004, 60, 8, 4),
(1005, 35, 12, 5);


INSERT INTO Labs (LabID, Name, Location, PhoneNumber, Supervisor, Email, HospitalID)
VALUES 
(1, 'BioLab', 'Cairo', '01011112222', 'Dr. Ahmed', 'info@biolab.com', 1),
(2, 'MediLab', 'Luxor', '01122223333', 'Dr. Fatma', 'contact@medilab.com', 2),
(3, 'HealthLab', 'Alexandria', '01233334444', 'Dr. Youssef', 'support@healthlab.com', 3),
(4, 'GenoLab', 'Aswan', '01333445555', 'Dr. Nour', 'info@genolab.com', 4),
(5, 'WellnessLab', 'Giza', '01444556666', 'Dr. Ali', 'contact@wellnesslab.com', 5);


INSERT INTO manage_nurse (NurseID, RoomID)
VALUES 
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5);


INSERT INTO manage_wardBOY (RoomID, WardBoyID)
VALUES 
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5);

INSERT INTO lab_associate_labTech (TechnicianID, LabID)
VALUES 
(10, 1),
(6, 2),
(7, 3),
(8, 4),
(9, 5);

INSERT INTO Patient (PatientID, Fname, Lname, PhoneNumber, Disease, Treatment, DateOfBirth, Gender, CheckInDate, CheckOutDate, Address, Email, BloodType, MedicalHistory, DoctorID, RoomID, BillID)VALUES 
(1, 'Sarah', 'Johnson', '0123456789', 'Flu', 'Rest & Medication', '1990-05-15', 0, '08:00:00', '12:00:00', '123 Nile Street, Cairo', 'sarah@example.com', 'O+', 'Allergies', 1, 1, 1),(2, 'Ahmed', 'Ali', '0234567891', 'Fever', 'Antibiotics', '1995-09-20', 1, '09:30:00', '14:00:00', '45 Pharaoh Avenue, Luxor', 'ahmed@example.com', 'A-', 'None', 2, 2, 2),
(3, 'Fatma', 'Mohamed', '0345678912', 'Headache', 'Painkillers', '1988-12-10', 0, '07:45:00', '11:30:00', '67 Mediterranean Road, Alexandria', 'fatma@example.com', 'AB+', 'Asthma', 3, 3, 3),(4, 'Youssef', 'Hassan', '0456789123', 'Stomachache', 'Digestive Meds', '1992-03-25', 1, '10:00:00', '15:00:00', '89 Nile Crescent, Aswan', 'youssef@example.com', 'B+', 'Fracture', 4, 4, 4),
(5, 'Nada', 'Khaled', '0567891234', 'Injury', 'Physical Therapy', '1997-08-05', 0, '08:30:00', '13:30:00', '76 Pyramid Road, Giza', 'nada@example.com', 'O-', 'Diabetes', 5, 5, 5);


INSERT INTO admit (PatientID, HospitalID)
VALUES 
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5);

INSERT INTO undergo_tests (LabID, PatientID)VALUES 
(1, 1),(2, 2),
(3, 3),(4, 4),
(5, 5);


# create a combined index for patient id and doctor id in the patient TABLE
CREATE INDEX patient_doctor_id ON Patient (DoctorID, PatientID);

# create a combined index for patient id and room id in the patient TABLE
CREATE INDEX patient_room_id ON Patient (RoomID, PatientID);

# create a combined index for patient id and bill id in the patient TABLE
CREATE INDEX patient_bill_id ON Patient (PatientID, BillID);

# create an index for patient id in the patient TABLE
CREATE INDEX patient_id ON Patient (PatientID);

# create an index for doctor id in the doctor TABLE
CREATE INDEX doctor_id ON Doctor (DoctorID);



# QUERY OPTIMIZATION
# FIRST EXAMPLE
CREATE INDEX idx_admin_staff_search ON AdministrativeStaff(hospitalID, role, age, salary);

select a.fname, a.lname, h.name from AdministrativeStaff a, Hospital h 
where a.hospitalID = h.hospitalID and a.role = 'Administrator' and a.age > 20 and a.salary > 2000;

# join is better than where
SELECT a.fname, a.lname, h.name
FROM AdministrativeStaff a
JOIN Hospital h ON a.hospitalID = h.hospitalID
WHERE a.role = 'Administrator' AND a.age > 20 AND a.salary > 2000;

SELECT a.fname, a.lname, h.name
FROM AdministrativeStaff a
JOIN Hospital h ON a.hospitalID = h.hospitalID
WHERE a.role = 'Administrator' AND a.salary > 2000 AND a.age > 20;

SHOW STATUS LIKE 'last_query_cost'

# create an example query that uses the keyword exists from this database table patient
# SECOND EXAMPLE 
SELECT CONCAT(p.fname, " ", p.lname) as full_name from Patient p 
where exists (select PatientID from undergo_tests);
SELECT CONCAT(p.fname, " ", p.lname) as full_name from Patient p 
where p.PatientID in (select PatientID from undergo_tests);

# THIRD EXAMPLE
# use inner join instead of where in the following query

SELECT AD.Fname, AD.Lname
FROM AdministrativeStaff AS AD
JOIN Hospital H ON AD.HospitalID = H.HospitalID
WHERE AD.Gender = 1
AND H.Name = 'Cairo General Hospital';

SELECT AD.Fname, AD.Lname
FROM AdministrativeStaff AS AD
JOIN Hospital H ON AD.HospitalID = H.HospitalID AND H.Name = 'Cairo General Hospital'
WHERE AD.Gender = 1;


SELECT IC.CompanyName
FROM Bill B, InsuranceCompany IC
WHERE B.InsuranceID = IC.InsuranceID
AND B.DayPrice > 20;

SELECT IC.CompanyName
FROM Bill B
INNER JOIN InsuranceCompany IC ON B.InsuranceID = IC.InsuranceID
WHERE B.DayPrice > 20;


SELECT H.Name AS HospitalName
FROM Hospital H, Room R
WHERE H.HospitalID = R.HospitalID
AND R.NumberOfBeds = 2;

SELECT H.Name AS HospitalName
FROM Hospital H
INNER JOIN Room R ON H.HospitalID = R.HospitalID AND R.NumberOfBeds = 2;


SELECT H.Name AS HospitalName
FROM Hospital H, Pharmacy P
WHERE H.HospitalID = P.HospitalID
AND P.InventoryCapacity > 40;

SELECT H.Name AS HospitalName
FROM Hospital H
INNER JOIN Pharmacy P ON H.HospitalID = P.HospitalID AND P.InventoryCapacity > 40;


SELECT DISTINCT D.Fname, D.Lname
FROM Doctor D, Patient P, Room R, Bill B
WHERE D.DoctorID = P.DoctorID
AND P.RoomID = R.RoomID
AND P.BillID = B.BillID
AND P.Gender = 0
AND R.NumberOfBeds >= 2
AND B.DayPrice > 20;

SELECT DISTINCT D.Fname, D.Lname
FROM Doctor D
INNER JOIN Patient P ON D.DoctorID = P.DoctorID
INNER JOIN Room R ON P.RoomID = R.RoomID
INNER JOIN Bill B ON P.BillID = B.BillID
WHERE P.Gender = 0
AND R.NumberOfBeds >= 2
AND B.DayPrice > 20;


Select * From WardBoy;
Select * From LabTechnician;
