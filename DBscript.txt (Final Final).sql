DROP TABLE Customers CASCADE CONSTRAINTS;
DROP TABLE Bookings CASCADE CONSTRAINTS;
DROP TABLE Package CASCADE CONSTRAINTS;
DROP TABLE Destination CASCADE CONSTRAINTS;
DROP TABLE Payment CASCADE CONSTRAINTS;
DROP TABLE Employee CASCADE CONSTRAINTS;
DROP TABLE Batch CASCADE CONSTRAINTS;
DROP TABLE Review CASCADE CONSTRAINTS;
DROP TABLE Hotel CASCADE CONSTRAINTS;

-- Creating Customers table
CREATE TABLE Customers (
    CustomerID CHAR(4) PRIMARY KEY,
    CustName VARCHAR2(50) NOT NULL,
    CustGender CHAR(1) CONSTRAINT check_custgen CHECK (CustGender IN ('M','F')),
    CustContact VARCHAR2(19),
    CustEmail VARCHAR2(50),
    CustHAdd VARCHAR2(100),
    MaritalStatus VARCHAR2(22) CONSTRAINT check_marsta CHECK (MaritalStatus IN ('Married','Widowed','Separated','Divorced', 'Single', 'Prefer not to disclose')),
    UNIQUE (CustContact),
    UNIQUE (CustEmail)
);
  
-- Creating Package table
CREATE TABLE Package (
    PackageID CHAR(4) PRIMARY KEY,
    PackageName VARCHAR2(50) NOT NULL,
    Description VARCHAR2(100),
    Country VARCHAR2(20) NOT NULL,
    PackPrice NUMBER(10, 2) CONSTRAINT check_packprice CHECK (PackPrice > 0),
    Language VARCHAR2(20),
    TimeZone VARCHAR2(8),
    UNIQUE (PackageName),
    UNIQUE (Description)
);

-- Creating Package-Price Index
-- This index is for the travel agents to search for the appropriate package for the customers based on their budget
-- It also helps travel agents to show the customer different type of packages that are being offered at the same price
-- For example, travel agents can show the customers the package that it's price is 2999.99 only 
CREATE INDEX packageprice_index
ON Package(PackPrice);

-- Creating Package-Language Index
-- Travel agents can help the customers to avoid or give a heads up to them about the countries that may have language barrier to them
-- For example, when a customer wants to travel to country that speaks english only, the employees can search for english
CREATE INDEX packagelang_index
ON Package(Language);
  
-- Creating Employee table
CREATE TABLE Employee (
    EmpID CHAR(4) PRIMARY KEY,
    EmpName VARCHAR2(50) NOT NULL,
    EmpContact VARCHAR2(16) CONSTRAINT check_empcont CHECK (length(EmpContact)>=15),
    EmpEmail VARCHAR2(50),
    EmpHAdd VARCHAR2(100),
    EmpDOB DATE,
    EmpGender CHAR(1) CONSTRAINT check_empgen CHECK (EmpGender IN ('M','F')),
    EmpPos VARCHAR2(50) NOT NULL,
    EmpYrsWorked NUMBER(2,0) NOT NULL,
    EmpBSalary NUMBER(10,2) CONSTRAINT check_empbs CHECK (EmpBSalary > 0),
    EmpBAcc NUMBER(17),
    MgrID CHAR(4),
    UNIQUE (EmpContact),
    UNIQUE (EmpEmail),
    UNIQUE (EmpBAcc)
);

-- Creating Employee-Position Index
-- The HR department can retrieve data based on the employee’s position to make decision regarding manpower allocations
-- For example, the company can have a look at how many tour guides they have and make a decision whether to hire more or not
CREATE INDEX emppos_index
ON Employee(EmpPos);
 
-- Creating Hotel table
CREATE TABLE Hotel (
    HotelID CHAR(4) PRIMARY KEY,
    HotelName VARCHAR(50) NOT NULL,
    HotelAdd VARCHAR(100),
    HotelContact VARCHAR(19),
    HotelRating NUMBER(2,1) CONSTRAINT check_hrating CHECK (HotelRating BETWEEN 1 AND 5),
    UNIQUE (HotelName),
    UNIQUE (HotelAdd),
    UNIQUE (HotelContact)
);

-- Creating Batch table
CREATE TABLE Batch (
    BatchID CHAR(4) PRIMARY KEY,
    StartDate DATE NOT NULL,
    EndDate DATE NOT NULL,
    EmpID CHAR(4),
    PackageID CHAR(4),
    FOREIGN KEY (EmpID) REFERENCES Employee(EmpID),
    FOREIGN KEY (PackageID) REFERENCES Package(PackageID)
);
 
-- Creating Destination table
CREATE TABLE Destination (
    DestinationID CHAR(4) PRIMARY KEY,
    DestinationName VARCHAR2(20) NOT NULL,
    DestinationDesc VARCHAR2(100),
    PackageID CHAR(4),
    HotelID CHAR(4),
    FOREIGN KEY (PackageID) REFERENCES Package(PackageID),
    FOREIGN KEY (HotelID) REFERENCES Hotel(HotelID),
    UNIQUE (DestinationName),
    UNIQUE (HotelID)
);

-- Creating Bookings table
CREATE TABLE Bookings (
    BookingID CHAR(4) PRIMARY KEY,
    CustomerID CHAR(4),
    NumOfTravellers Number (2,0),
    BatchID CHAR(4),
    EmpID CHAR(4),
    BookingDate DATE,

    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),
    FOREIGN KEY (BatchID) REFERENCES Batch(BatchID),
    FOREIGN KEY (EmpID) REFERENCES Employee(EmpID)
);

-- Creating Payment table
CREATE TABLE Payment (
    PaymentID CHAR(4) PRIMARY KEY,
    BookingID CHAR(4),
    PaymentDate DATE NOT NULL,
    PayPrice NUMBER(10, 2) CONSTRAINT check_payprice CHECK (PayPrice > 0),
    PaymentMethod VARCHAR2(15) CONSTRAINT check_paymet CHECK (PaymentMethod IN ('Credit Card','Debit Card','Bank Transfer')),
    InvoiceNo CHAR(6) NOT NULL,
    FOREIGN KEY (BookingID) REFERENCES Bookings(BookingID),
    UNIQUE (InvoiceNo)
);

-- Creating Payment-Method Index
-- The accounting department can ensure that all payments are accounted for correctly as different payment methods may have different processing times and fees
-- For example, they can check at the correct file to cross check whether the amount has been issued by the issuer
CREATE INDEX paymet_index
ON Payment(PaymentMethod);

-- Creating Review table
CREATE TABLE Review (
    ReviewID CHAR(4) PRIMARY KEY,
    BookingID CHAR(4),
    ReviewText VARCHAR2(100),
    ReviewRating NUMBER(1,0) CONSTRAINT check_rrating CHECK (ReviewRating BETWEEN 1 AND 5),
    ReviewDate DATE,
    FOREIGN KEY (BookingID) REFERENCES Bookings(BookingID),
    UNIQUE (BookingID)
);

-- Creating Review-Rating Index
-- Employees can check the ratings from 1 to 5 and see how they can improve their performances 
-- For example, they can search for ratings with 1 to see which aspect they should improve first
CREATE INDEX revrat_index
ON Review(ReviewRating);

-- Customers table
INSERT INTO Customers VALUES ('C001', 'Lee Mei Ling', 'F', '+60 17 123 4560', 'lee.meiling@gmail.com', '123 Jalan Tun Razak, Kuala Lumpur, 50400, Kuala Lumpur', 'Single');
INSERT INTO Customers VALUES ('C002', 'Sally Smith', 'F', '+60 17 123 4561', 'sally.smith@hotmail.com', '456 Jalan Raja Laut, Kuala Lumpur, 50350, Kuala Lumpur', 'Married');
INSERT INTO Customers VALUES ('C003', 'Tan Mei Wah', 'F', '+60 17 123 4562', 'tan.meiwah@yahoo.com', '789 Jalan Tun H.S. Lee, Kuala Lumpur, 50050, Kuala Lumpur', 'Single');
INSERT INTO Customers VALUES ('C004', 'Siti binti Yusof', 'F', '+60 17 123 4563', 'siti.yusof@gmail.com', '890 Jalan Sultan Azlan Shah, Kuala Lumpur, 51200, Kuala Lumpur', 'Married');
INSERT INTO Customers VALUES ('C005', 'Ganesh Kumar', 'M', '+60 17 123 4564', 'ganesh.kumar@hotmail.com', '901 Jalan Ampang Hilir, Kuala Lumpur, 50480, Kuala Lumpur', 'Single');
INSERT INTO Customers VALUES ('C006', 'Noraini bt Ahmad', 'F', '+60 17 123 4565', 'noraini.ahmad@yahoo.com', '123 Jalan Ipoh, Kuala Lumpur, 51200, Kuala Lumpur', 'Married');
INSERT INTO Customers VALUES ('C007', 'Lim Chee Keong', 'M', '+60 17 123 4566', 'lim.cheekeong@gmail.com', '234 Jalan Kuching, Kuala Lumpur, 51200, Kuala Lumpur', 'Single');
INSERT INTO Customers VALUES ('C008', 'Aishah bt Ismail', 'F', '+60 17 123 4567', 'aishah.ismail@hotmail.com', '345 Jalan Tun Ismail, Kuala Lumpur, 50480, Kuala Lumpur', 'Married');
INSERT INTO Customers VALUES ('C009', 'Chong Wei Liang', 'M', '+60 17 123 4568', 'chong.weiliang@yahoo.com', '456 Jalan Tun Razak, Kuala Lumpur, 50400, Kuala Lumpur', 'Single');
INSERT INTO Customers VALUES ('C010', 'Rajesh Singh', 'M', '+60 17 123 4569', 'rajesh.singh@gmail.com', '567 Jalan Raja Chulan, Kuala Lumpur, 50200, Kuala Lumpur', 'Married');
INSERT INTO Customers VALUES ('C011', 'Wong Siti Nurul', 'F', '+60 17 123 4570', 'wong.sitinurul@hotmail.com', '678 Jalan Tun Razak, Kuala Lumpur, 50400, Kuala Lumpur', 'Single');
INSERT INTO Customers VALUES ('C012', 'Hassan bin Mohamad', 'M', '+60 17 123 4571', 'hassan.mohamad@gmail.com', '789 Jalan Raja Laut, Kuala Lumpur, 50350, Kuala Lumpur', 'Married');
INSERT INTO Customers VALUES ('C013', 'Liew Mei Ling', 'F', '+60 17 123 4572', 'liew.meiling@yahoo.com', '890 Jalan Tun H.S. Lee, Kuala Lumpur, 50050, Kuala Lumpur', 'Single');
INSERT INTO Customers VALUES ('C014', 'Zulaikha bt Abdul Rahman', 'F', '+60 17 123 4573', 'zulaikha.abdulrahman@gmail.com', '901 Jalan Sultan Azlan Shah, Kuala Lumpur, 51200, Kuala Lumpur', 'Married');
INSERT INTO Customers VALUES ('C015', 'Ravi Kumar', 'M', '+60 17 123 4574', 'ravi.kumar@hotmail.com', '123 Jalan Ampang Hilir, Kuala Lumpur, 50480, Kuala Lumpur', 'Single');
INSERT INTO Customers VALUES ('C016', 'Nor Haslinda bt Zainal', 'F', '+60 17 123 4575', 'nor.haslinda.zainal@yahoo.com', '234 Jalan Ipoh, Kuala Lumpur, 51200, Kuala Lumpur', 'Married');
INSERT INTO Customers VALUES ('C017', 'Tan Ah Kow', 'M', '+60 17 123 4576', 'tan.ahkow@gmail.com', '345 Jalan Kuching, Kuala Lumpur, 51200, Kuala Lumpur', 'Single');
INSERT INTO Customers VALUES ('C018', 'Norazlina bt Hassan', 'F', '+60 17 123 4577', 'norazlina.hassan@hotmail.com', '456 Jalan Tun Ismail, Kuala Lumpur, 50480, Kuala Lumpur', 'Married');
INSERT INTO Customers VALUES ('C019', 'Vikneswaran Naidu', 'M', '+60 17 123 4578', 'vikneswaran.naidu@yahoo.com', '567 Jalan Tun Razak, Kuala Lumpur, 50400, Kuala Lumpur', 'Single');
INSERT INTO Customers VALUES ('C020', 'Nurul Ain bt Zulkifli', 'F', '+60 17 123 4579', 'nurulain.zulkifli@gmail.com', '678 Jalan Raja Chulan, Kuala Lumpur, 50200, Kuala Lumpur', 'Married');

 -- Package table
INSERT INTO Package VALUES ('P001', 'Japan Highlights', 'Experience the blend of tradition and modernity in Japan.', 'Japan', 2999.99, 'Japanese', 'UTC+9');
INSERT INTO Package VALUES ('P002', 'Thailand Escape', 'Relax on the beautiful beaches and explore the vibrant cities of Thailand.', 'Thailand', 1999.99, 'Thai', 'UTC+7');
INSERT INTO Package VALUES ('P003', 'China Heritage', 'Discover the ancient history and modern marvels of China.', 'China', 2799.99, 'Chinese', 'UTC+8');
INSERT INTO Package VALUES ('P004', 'Indian Cultural Tour', 'Explore the rich cultural heritage and vibrant cities of India.', 'India', 2199.99, 'Hindi', 'UTC+5:30');
INSERT INTO Package VALUES ('P005', 'Vietnam Discovery', 'Uncover the history and natural beauty of Vietnam.', 'Vietnam', 1799.99, 'Vietnamese', 'UTC+7');
INSERT INTO Package VALUES ('P006', 'South Korea Adventure', 'Experience the vibrant culture and modern cities of South Korea.', 'South Korea', 2599.99, 'Korean', 'UTC+9');
INSERT INTO Package VALUES ('P007', 'Malaysian Wonders', 'Discover the diverse landscapes and cultures of Malaysia.', 'Malaysia', 1999.99, 'Malay', 'UTC+8');
INSERT INTO Package VALUES ('P008', 'Singapore Delight', 'Explore the modern marvels and multicultural heritage of Singapore.', 'Singapore', 2299.99, 'English', 'UTC+8');
INSERT INTO Package VALUES ('P009', 'Indonesia Paradise', 'Relax on the stunning beaches and explore the rich culture of Indonesia.', 'Indonesia', 1999.99, 'Indonesian', 'UTC+8');
INSERT INTO Package VALUES ('P010', 'Nepal Expedition', 'Experience the majestic Himalayas and rich culture of Nepal.', 'Nepal', 2499.99, 'Nepali', 'UTC+5:45');
INSERT INTO Package VALUES ('P011', 'Australia Outback Adventure', 'Explore the rugged beauty and wildlife of the Australian outback.', 'Australia', 3199.99, 'English', 'UTC+10');
INSERT INTO Package VALUES ('P012', 'New Zealand Discovery', 'Discover the stunning landscapes and Maori culture of New Zealand.', 'New Zealand', 2899.99, 'English', 'UTC+12');
INSERT INTO Package VALUES ('P013', 'Egyptian Treasures', 'Uncover the ancient wonders and history of Egypt.', 'Egypt', 2699.99, 'Arabic', 'UTC+2');
INSERT INTO Package VALUES ('P014', 'Greek Odyssey', 'Experience the mythology, history, and beauty of Greece.', 'Greece', 2799.99, 'Greek', 'UTC+2');
INSERT INTO Package VALUES ('P015', 'Italian Escape', 'Indulge in the art, cuisine, and history of Italy.', 'Italy', 2999.99, 'Italian', 'UTC+1');
INSERT INTO Package VALUES ('P016', 'Spanish Fiesta', 'Immerse yourself in the vibrant culture and lively atmosphere of Spain.', 'Spain', 2499.99, 'Spanish', 'UTC+1');
INSERT INTO Package VALUES ('P017', 'French Riviera Tour', 'Explore the glamorous coastline and cultural landmarks of the French Riviera.', 'France', 3099.99, 'French', 'UTC+1');
INSERT INTO Package VALUES ('P018', 'German Exploration', 'Discover the historic cities and scenic landscapes of Germany.', 'Germany', 2699.99, 'German', 'UTC+1');
INSERT INTO Package VALUES ('P019', 'Swiss Alpine Adventure', 'Experience the breathtaking beauty and outdoor activities in the Swiss Alps.', 'Switzerland', 3299.99, 'German', 'UTC+1');
INSERT INTO Package VALUES ('P020', 'African Safari Expedition', 'Embark on a thrilling safari adventure through the wilderness of Africa.', 'Kenya', 3599.99, 'English', 'UTC+2');

-- Employee table
INSERT INTO Employee VALUES ('E001', 'Lim Wei Jie', '+60 17 123 4590', 'lim.weijie@gmail.com', '567 Jalan Tun Razak, Kuala Lumpur, 50400, Kuala Lumpur', TO_DATE('1983-10-25', 'YYYY-MM-DD'), 'M', 'Travel Agent', 4, '4000', '2345678901','E017');
INSERT INTO Employee VALUES ('E002', 'Nurul Huda', '+60 17 123 4591', 'nurul.huda@hotmail.com', '678 Jalan Raja Laut, Kuala Lumpur, 50350, Kuala Lumpur', TO_DATE('1990-12-15', 'YYYY-MM-DD'), 'F', 'Tour Guide', 6, '5000', '3456789012', 'E007');
INSERT INTO Employee VALUES ('E003', 'Suresh Menon', '+60 17 123 4592', 'suresh.menon@yahoo.com', '789 Jalan Tun H.S. Lee, Kuala Lumpur, 50050, Kuala Lumpur', TO_DATE('1981-07-08', 'YYYY-MM-DD'), 'M', 'Customer Service Manager', 9, '6000','4567890123', NULL);
INSERT INTO Employee VALUES ('E004', 'Mageswari Nair', '+60 17 123 4593', 'mageswari.nair@gmail.com', '890 Jalan Sultan Azlan Shah, Kuala Lumpur, 51200, Kuala Lumpur', TO_DATE('1986-04-20', 'YYYY-MM-DD'), 'F', 'Travel Agent', 5, '4300', '5678901234','E017');
INSERT INTO Employee VALUES ('E005', 'Ahmad Zulkifli', '+60 17 123 4594', 'ahmad.zulkifli@hotmail.com', '901 Jalan Ampang Hilir, Kuala Lumpur, 50480, Kuala Lumpur', TO_DATE('1984-09-03', 'YYYY-MM-DD'), 'M', 'Tour Operator', 7, '5000', '6789012345', 'E007');
INSERT INTO Employee VALUES ('E006', 'Noraini Abdullah', '+60 17 123 4595', 'noraini.abdullah@yahoo.com', '123 Jalan Ipoh, Kuala Lumpur, 51200, Kuala Lumpur', TO_DATE('1991-03-28', 'YYYY-MM-DD'), 'F', 'Travel Agent', 4, '4100', '7890123456','E017');
INSERT INTO Employee VALUES ('E007', 'Tan Eng Huat', '+60 17 123 4596', 'tan.enghuat@gmail.com', '234 Jalan Kuching, Kuala Lumpur, 51200, Kuala Lumpur', TO_DATE('1982-11-12', 'YYYY-MM-DD'), 'M', 'Tour Manager', 11, '9000', '8901234567', NULL);
INSERT INTO Employee VALUES ('E008', 'Siti Aishah', '+60 17 123 4597', 'siti.aishah@hotmail.com', '345 Jalan Tun Ismail, Kuala Lumpur, 50480, Kuala Lumpur', TO_DATE('1987-06-17', 'YYYY-MM-DD'), 'F', 'Travel Advisor', 6, '7000', '9012345678','E017');
INSERT INTO Employee VALUES ('E009', 'Ganesh Naidu', '+60 17 123 4598', 'ganesh.naidu@yahoo.com', '456 Jalan Tun Razak, Kuala Lumpur, 50400, Kuala Lumpur', TO_DATE('1980-02-05', 'YYYY-MM-DD'), 'M', 'Tour Guide', 8, '5500', '1123457789','E007');
INSERT INTO Employee VALUES ('E010', 'Norliana Ismail', '+60 17 123 4599', 'norliana.ismail@gmail.com', '567 Jalan Raja Chulan, Kuala Lumpur, 50200, Kuala Lumpur', TO_DATE('1995-08-10', 'YYYY-MM-DD'), 'F', 'Travel Consultant', 5, '5400', '1234567890','E017');
INSERT INTO Employee VALUES ('E011', 'Vijaya Kumar', '+60 17 123 4600', 'vijaya.kumar@hotmail.com', '678 Jalan Tun Razak, Kuala Lumpur, 50400, Kuala Lumpur', TO_DATE('1989-05-15', 'YYYY-MM-DD'), 'M', 'Tour Coordinator', 6, '5600', '2345678902','E007');
INSERT INTO Employee VALUES ('E012', 'Siti Nurul Aini', '+60 17 123 4601', 'siti.nurulaini@yahoo.com', '789 Jalan Raja Laut, Kuala Lumpur, 50350, Kuala Lumpur', TO_DATE('1984-12-20', 'YYYY-MM-DD'), 'F', 'Travel Agent', 3, '4300', '3456789013','E017');
INSERT INTO Employee VALUES ('E013', 'Aruna Devi', '+60 17 123 4602', 'aruna.devi@gmail.com', '890 Jalan Tun H.S. Lee, Kuala Lumpur, 50050, Kuala Lumpur', TO_DATE('1987-08-03', 'YYYY-MM-DD'), 'F', 'Tour Guide', 5, '4000', '4567890124','E007');
INSERT INTO Employee VALUES ('E014', 'Muhammad bin Hassan', '+60 17 123 4603', 'muhammad.hassan@hotmail.com', '901 Jalan Sultan Azlan Shah, Kuala Lumpur, 51200, Kuala Lumpur', TO_DATE('1982-03-28', 'YYYY-MM-DD'), 'M', 'Travel Consultant', 7, '6500', '5678901235','E017');
INSERT INTO Employee VALUES ('E015', 'Wong Mei Ling', '+60 17 123 4604', 'wong.meiling@yahoo.com', '123 Jalan Ampang Hilir, Kuala Lumpur, 50480, Kuala Lumpur', TO_DATE('1985-09-01', 'YYYY-MM-DD'), 'F', 'Travel Coordinator', 4, '5000', '6789012395','E017');
INSERT INTO Employee VALUES ('E016', 'Rajesh Kumar', '+60 17 123 4605', 'rajesh.kumar@gmail.com', '234 Jalan Ipoh, Kuala Lumpur, 51200, Kuala Lumpur', TO_DATE('1990-03-28', 'YYYY-MM-DD'), 'M', 'Tour Operator', 6, '4900', '7890123496','E007');
INSERT INTO Employee VALUES ('E017', 'Siti Norazlina', '+60 17 123 4606', 'siti.norazlina@hotmail.com', '345 Jalan Kuching, Kuala Lumpur, 51200, Kuala Lumpur', TO_DATE('1983-11-12', 'YYYY-MM-DD'), 'F', 'Travel Manager', 10, '9800', '8901234067', NULL);
INSERT INTO Employee VALUES ('E018', 'Ganesan A/L Naidu', '+60 17 123 4607', 'ganesan.naidu@yahoo.com', '456 Jalan Tun Ismail, Kuala Lumpur, 50480, Kuala Lumpur', TO_DATE('1988-06-17', 'YYYY-MM-DD'), 'M', 'Tour Guide', 7, '5800', '9012345698','E007');
INSERT INTO Employee VALUES ('E019', 'Nurul Ain bt Zulkifli', '+60 17 123 4608', 'nurulain.zulkifli@gmail.com', '567 Jalan Raja Chulan, Kuala Lumpur, 50200, Kuala Lumpur', TO_DATE('1981-08-10', 'YYYY-MM-DD'), 'F', 'Travel Consultant', 4, '5700', '9123456789','E017');
INSERT INTO Employee VALUES ('E020', 'Chong Wei Jie', '+60 17 123 4609', 'chong.weijie@gmail.com', '678 Jalan Tun Razak, Kuala Lumpur, 50400, Kuala Lumpur', TO_DATE('1992-04-05', 'YYYY-MM-DD'), 'M', 'Travel Coordinator', 8, '6000', '1234567990','E017');

--Hotel table
INSERT INTO Hotel VALUES ('H001', 'Grand Hotel', '123 Orchard Road, Tokyo, Japan', '+81 1234 5678', 5);
INSERT INTO Hotel VALUES ('H002', 'Ocean View Resort', '456 Beach Road, Kyoto, Japan', '+81 2345 6789', 4.7);
INSERT INTO Hotel VALUES ('H003', 'Mountain Lodge', '789 Mountain View, Bangkok, Thailand', '+66 3456 7890', 4.4);
INSERT INTO Hotel VALUES ('H004', 'City Lights Inn', '321 Downtown Boulevard, Chiang Mai, Thailand', '+66 4567 8901', 4.3);
INSERT INTO Hotel VALUES ('H005', 'Riverside Retreat', '654 Riverbank Drive, Beijing, China', '+86 5678 9012', 4.5);
INSERT INTO Hotel VALUES ('H006', 'Sunset Plaza', '987 Hilltop Road, Shanghai, China', '+86 6789 0123', 4.9);
INSERT INTO Hotel VALUES ('H007', 'Valley View Hotel', '246 Valley Lane, Delhi, India', '+91 7890 1234', 4.6);
INSERT INTO Hotel VALUES ('H008', 'Beachfront Resort', '369 Seaside Avenue, Mumbai, India', '+91 8901 2345', 5);
INSERT INTO Hotel VALUES ('H009', 'Forest Haven', '147 Forest Road, Hanoi, Vietnam', '+84 9012 3456', 4.3);
INSERT INTO Hotel VALUES ('H010', 'Lakeside Lodge', '258 Lakeview Terrace, Ho Chi Minh City, Vietnam', '+84 1234 5678', 4.7);
INSERT INTO Hotel VALUES ('H011', 'Alpine Retreat', '369 Mountain Drive, Seoul, South Korea', '+82 2345 6789', 4.3);
INSERT INTO Hotel VALUES ('H012', 'Harbor View Hotel', '147 Harbor Street, Busan, South Korea', '+82 3456 7890', 5);
INSERT INTO Hotel VALUES ('H013', 'Desert Oasis', '258 Sand Dune Road, Kuala Lumpur, Malaysia', '+60 4567 8901', 4.8);
INSERT INTO Hotel VALUES ('H014', 'Garden Resort', '369 Garden Lane, Penang, Malaysia', '+60 5678 9012', 4.1);
INSERT INTO Hotel VALUES ('H015', 'Central Plaza Hotel', '147 Center Street, Marina Bay, Singapore', '+65 6789 0123', 5);
INSERT INTO Hotel VALUES ('H016', 'Skyline Hotel', '258 Skyway Avenue, Ubud, Indonesia', '+62 7890 1234', 4.1);
INSERT INTO Hotel VALUES ('H017', 'Hilltop Haven', '369 Hillcrest Road, Kathmandu, Nepal', '+977 8901 2345', 4.8);
INSERT INTO Hotel VALUES ('H018', 'Seaside Resort', '147 Seaview Boulevard, Pokhara, Nepal', '+977 9012 3456', 4.4);
INSERT INTO Hotel VALUES ('H019', 'Parkside Inn', '258 Park Avenue, Sydney, Australia', '+61 1234 5678', 4.8);
INSERT INTO Hotel VALUES ('H020', 'Urban Escape Hotel', '369 Urban Drive, Auckland, New Zealand', '+64 2345 6789', 5);
INSERT INTO Hotel VALUES ('H021', 'Pyramid View Hotel', '101 Pyramid Avenue, Cairo, Egypt', '+20 1234 5678', 4.7);
INSERT INTO Hotel VALUES ('H022', 'Acropolis Inn', '202 Parthenon Street, Athens, Greece', '+30 2345 6789', 4.6);
INSERT INTO Hotel VALUES ('H023', 'Rome Renaissance Hotel', '303 Colosseum Road, Rome, Italy', '+39 3456 7890', 4.8);
INSERT INTO Hotel VALUES ('H024', 'Catalonia Suites', '404 Gaudí Avenue, Barcelona, Spain', '+34 4567 8901', 4.9);
INSERT INTO Hotel VALUES ('H025', 'Riviera Elegance Hotel', '505 Promenade des Anglais, Nice, France', '+33 5678 9012', 5);
INSERT INTO Hotel VALUES ('H026', 'Berlin Modern Hotel', '606 Brandenburg Gate Boulevard, Berlin, Germany', '+49 6789 0123', 4.7);
INSERT INTO Hotel VALUES ('H027', 'Alpine Luxury Hotel', '707 Lake Zurich Street, Zurich, Switzerland', '+41 7890 1234', 5);
INSERT INTO Hotel VALUES ('H028', 'Safari Lodge', '808 Wildlife Drive, Nairobi, Kenya', '+254 8901 2345', 4.9);

-- batch table
INSERT INTO Batch VALUES ('B001', TO_DATE('2022-06-03', 'YYYY-MM-DD'), TO_DATE('2022-06-12', 'YYYY-MM-DD'), 'E002', 'P003');
INSERT INTO Batch VALUES ('B002', TO_DATE('2022-06-04', 'YYYY-MM-DD'), TO_DATE('2022-06-13', 'YYYY-MM-DD'), 'E009', 'P020');
INSERT INTO Batch VALUES ('B003', TO_DATE('2024-06-05', 'YYYY-MM-DD'), TO_DATE('2024-06-14', 'YYYY-MM-DD'), 'E013', 'P001');
INSERT INTO Batch VALUES ('B004', TO_DATE('2024-06-06', 'YYYY-MM-DD'), TO_DATE('2024-06-15', 'YYYY-MM-DD'), 'E018', 'P018');
INSERT INTO Batch VALUES ('B005', TO_DATE('2024-06-07', 'YYYY-MM-DD'), TO_DATE('2024-06-16', 'YYYY-MM-DD'), 'E009', 'P009');
INSERT INTO Batch VALUES ('B006', TO_DATE('2024-06-08', 'YYYY-MM-DD'), TO_DATE('2024-06-17', 'YYYY-MM-DD'), 'E009', 'P001');
INSERT INTO Batch VALUES ('B007', TO_DATE('2024-06-09', 'YYYY-MM-DD'), TO_DATE('2024-06-18', 'YYYY-MM-DD'), 'E013', 'P011');
INSERT INTO Batch VALUES ('B008', TO_DATE('2024-06-10', 'YYYY-MM-DD'), TO_DATE('2024-06-19', 'YYYY-MM-DD'), 'E018', 'P010');
INSERT INTO Batch VALUES ('B009', TO_DATE('2024-06-11', 'YYYY-MM-DD'), TO_DATE('2024-06-20', 'YYYY-MM-DD'), 'E002', 'P006');
INSERT INTO Batch VALUES ('B010', TO_DATE('2024-06-12', 'YYYY-MM-DD'), TO_DATE('2024-06-21', 'YYYY-MM-DD'), 'E013', 'P012');
INSERT INTO Batch VALUES ('B011', TO_DATE('2024-06-13', 'YYYY-MM-DD'), TO_DATE('2024-06-22', 'YYYY-MM-DD'), 'E002', 'P016');
INSERT INTO Batch VALUES ('B012', TO_DATE('2024-06-14', 'YYYY-MM-DD'), TO_DATE('2024-06-23', 'YYYY-MM-DD'), 'E018', 'P004');
INSERT INTO Batch VALUES ('B013', TO_DATE('2024-06-15', 'YYYY-MM-DD'), TO_DATE('2024-06-24', 'YYYY-MM-DD'), 'E009', 'P014');
INSERT INTO Batch VALUES ('B014', TO_DATE('2024-06-16', 'YYYY-MM-DD'), TO_DATE('2024-06-25', 'YYYY-MM-DD'), 'E002', 'P013');
INSERT INTO Batch VALUES ('B015', TO_DATE('2024-06-17', 'YYYY-MM-DD'), TO_DATE('2024-06-26', 'YYYY-MM-DD'), 'E013', 'P008');
INSERT INTO Batch VALUES ('B016', TO_DATE('2024-06-18', 'YYYY-MM-DD'), TO_DATE('2024-06-27', 'YYYY-MM-DD'), 'E002', 'P001');
INSERT INTO Batch VALUES ('B017', TO_DATE('2024-06-19', 'YYYY-MM-DD'), TO_DATE('2024-06-28', 'YYYY-MM-DD'), 'E009', 'P007');
INSERT INTO Batch VALUES ('B018', TO_DATE('2024-06-20', 'YYYY-MM-DD'), TO_DATE('2024-06-29', 'YYYY-MM-DD'), 'E018', 'P002');
INSERT INTO Batch VALUES ('B019', TO_DATE('2024-06-21', 'YYYY-MM-DD'), TO_DATE('2024-06-30', 'YYYY-MM-DD'), 'E002', 'P001');
INSERT INTO Batch VALUES ('B020', TO_DATE('2024-06-22', 'YYYY-MM-DD'), TO_DATE('2024-06-30', 'YYYY-MM-DD'), 'E013', 'P005');
INSERT INTO Batch VALUES ('B021', TO_DATE('2024-06-23', 'YYYY-MM-DD'), TO_DATE('2024-07-01', 'YYYY-MM-DD'), 'E013', 'P015');
INSERT INTO Batch VALUES ('B022', TO_DATE('2024-06-24', 'YYYY-MM-DD'), TO_DATE('2024-07-02', 'YYYY-MM-DD'), 'E013', 'P017');
INSERT INTO Batch VALUES ('B023', TO_DATE('2024-06-25', 'YYYY-MM-DD'), TO_DATE('2024-07-03', 'YYYY-MM-DD'), 'E013', 'P019');

-- Destination table
INSERT INTO Destination VALUES ('D001', 'Tokyo', 'Experience the vibrant culture and modern attractions of Tokyo, Japan.', 'P001', 'H001');
INSERT INTO Destination VALUES ('D002', 'Kyoto', 'Explore the historical temples and traditional culture of Kyoto, Japan.', 'P001', 'H002');
INSERT INTO Destination VALUES ('D003', 'Bangkok', 'Discover the bustling streets and rich history of Bangkok, Thailand.', 'P002', 'H003');
INSERT INTO Destination VALUES ('D004', 'Chiang Mai', 'Enjoy the beautiful landscapes and ancient temples of Chiang Mai, Thailand.', 'P002', 'H004');
INSERT INTO Destination VALUES ('D005', 'Beijing', 'Explore the ancient landmarks and modern marvels of Beijing, China.', 'P003', 'H005');
INSERT INTO Destination VALUES ('D006', 'Shanghai', 'Experience the modern skyline and vibrant culture of Shanghai, China.', 'P003', 'H006');
INSERT INTO Destination VALUES ('D007', 'Delhi', 'Immerse yourself in the diverse culture and history of Delhi, India.', 'P004', 'H007');
INSERT INTO Destination VALUES ('D008', 'Mumbai', 'Discover the bustling streets and rich history of Mumbai, India.', 'P004', 'H008');
INSERT INTO Destination VALUES ('D009', 'Hanoi', 'Uncover the unique heritage and beauty of Hanoi, Vietnam.', 'P005', 'H009');
INSERT INTO Destination VALUES ('D010', 'Ho Chi Minh City', 'Experience the vibrant culture and modern attractions of Ho Chi Minh City, Vietnam.', 'P005', 'H010');
INSERT INTO Destination VALUES ('D011', 'Seoul', 'Experience the dynamic blend of tradition and modernity in Seoul, South Korea.', 'P006', 'H011');
INSERT INTO Destination VALUES ('D012', 'Busan', 'Explore the beautiful beaches and vibrant culture of Busan, South Korea.', 'P006', 'H012');
INSERT INTO Destination VALUES ('D013', 'Kuala Lumpur', 'Discover the diverse culture and modern skyline of Kuala Lumpur, Malaysia.', 'P007', 'H013');
INSERT INTO Destination VALUES ('D014', 'Penang', 'Experience the rich heritage and delicious food of Penang, Malaysia.', 'P007', 'H014');
INSERT INTO Destination VALUES ('D015', 'Marina Bay', 'Explore the iconic Marina Bay with its stunning skyline and attractions.', 'P008', 'H015');
INSERT INTO Destination VALUES ('D016', 'Ubud', 'Relax in the cultural heart of Bali, Ubud, Indonesia.', 'P009', 'H016');
INSERT INTO Destination VALUES ('D017', 'Kathmandu', 'Experience the vibrant culture and history of Kathmandu, Nepal.', 'P010', 'H017');
INSERT INTO Destination VALUES ('D018', 'Pokhara', 'Explore the beautiful lakes and mountain views of Pokhara, Nepal.', 'P010', 'H018');
INSERT INTO Destination VALUES ('D019', 'Sydney', 'Experience the iconic landmarks and vibrant culture of Sydney, Australia.', 'P011', 'H019');
INSERT INTO Destination VALUES ('D020', 'Auckland', 'Discover the stunning landscapes and Maori culture of Auckland, New Zealand.', 'P012', 'H020');
INSERT INTO Destination VALUES ('D021', 'Cairo', 'Explore the ancient pyramids and rich history of Cairo, Egypt.', 'P013', 'H021');
INSERT INTO Destination VALUES ('D022', 'Athens', 'Discover the ancient ruins and vibrant culture of Athens, Greece.', 'P014', 'H022');
INSERT INTO Destination VALUES ('D023', 'Rome', 'Immerse yourself in the art, history, and cuisine of Rome, Italy.', 'P015', 'H023');
INSERT INTO Destination VALUES ('D024', 'Barcelona', 'Experience the vibrant culture and unique architecture of Barcelona, Spain.', 'P016', 'H024');
INSERT INTO Destination VALUES ('D025', 'Nice', 'Enjoy the glamorous coastline and cultural landmarks of Nice, France.', 'P017', 'H025');
INSERT INTO Destination VALUES ('D026', 'Berlin', 'Explore the historic sites and modern attractions of Berlin, Germany.', 'P018', 'H026');
INSERT INTO Destination VALUES ('D027', 'Zurich', 'Experience the breathtaking beauty and outdoor activities in Zurich, Switzerland.', 'P019', 'H027');
INSERT INTO Destination VALUES ('D028', 'Nairobi', 'Embark on a thrilling safari adventure and explore Nairobi, Kenya.', 'P020', 'H028');

-- booking table
INSERT INTO Bookings VALUES ('K001', 'C001', 2,'B001', 'E001', TO_DATE('2022-04-01', 'YYYY-MM-DD'));
INSERT INTO Bookings VALUES ('K002', 'C002', 1,'B002', 'E004', TO_DATE('2022-04-02', 'YYYY-MM-DD'));
INSERT INTO Bookings VALUES ('K003', 'C003', 4,'B003', 'E006', TO_DATE('2024-01-03', 'YYYY-MM-DD'));
INSERT INTO Bookings VALUES ('K004', 'C004', 1,'B020', 'E012', TO_DATE('2024-01-04', 'YYYY-MM-DD'));
INSERT INTO Bookings VALUES ('K005', 'C005', 5,'B009', 'E006', TO_DATE('2024-01-05', 'YYYY-MM-DD'));
INSERT INTO Bookings VALUES ('K006', 'C006', 2,'B006', 'E001', TO_DATE('2024-01-06', 'YYYY-MM-DD'));
INSERT INTO Bookings VALUES ('K007', 'C007', 4,'B011', 'E004', TO_DATE('2024-01-07', 'YYYY-MM-DD'));
INSERT INTO Bookings VALUES ('K008', 'C008', 3,'B010', 'E006', TO_DATE('2024-01-08', 'YYYY-MM-DD'));
INSERT INTO Bookings VALUES ('K009', 'C009', 1,'B016', 'E001', TO_DATE('2024-01-09', 'YYYY-MM-DD'));
INSERT INTO Bookings VALUES ('K010', 'C010', 1,'B012', 'E012', TO_DATE('2024-01-09', 'YYYY-MM-DD'));
INSERT INTO Bookings VALUES ('K011', 'C011', 1,'B003', 'E001', TO_DATE('2024-01-09', 'YYYY-MM-DD'));
INSERT INTO Bookings VALUES ('K012', 'C012', 2,'B014', 'E012', TO_DATE('2024-01-10', 'YYYY-MM-DD'));
INSERT INTO Bookings VALUES ('K013', 'C013', 2,'B013', 'E001', TO_DATE('2024-01-11', 'YYYY-MM-DD'));
INSERT INTO Bookings VALUES ('K014', 'C014', 4,'B008', 'E004', TO_DATE('2024-01-12', 'YYYY-MM-DD'));
INSERT INTO Bookings VALUES ('K015', 'C015', 3,'B005', 'E004', TO_DATE('2024-01-12', 'YYYY-MM-DD'));
INSERT INTO Bookings VALUES ('K016', 'C016', 2,'B004', 'E006', TO_DATE('2024-01-13', 'YYYY-MM-DD'));
INSERT INTO Bookings VALUES ('K017', 'C017', 3,'B007', 'E001', TO_DATE('2024-01-13', 'YYYY-MM-DD'));
INSERT INTO Bookings VALUES ('K018', 'C018', 1,'B017', 'E004', TO_DATE('2024-01-14', 'YYYY-MM-DD'));
INSERT INTO Bookings VALUES ('K019', 'C019', 1,'B015', 'E001', TO_DATE('2024-01-15', 'YYYY-MM-DD'));
INSERT INTO Bookings VALUES ('K020', 'C020', 1,'B019', 'E004', TO_DATE('2024-01-16', 'YYYY-MM-DD'));
INSERT INTO Bookings VALUES ('K021', 'C015', 1,'B021', 'E004', TO_DATE('2024-01-17', 'YYYY-MM-DD'));
INSERT INTO Bookings VALUES ('K022', 'C017', 1,'B022', 'E004', TO_DATE('2024-01-18', 'YYYY-MM-DD'));
INSERT INTO Bookings VALUES ('K023', 'C010', 1,'B023', 'E004', TO_DATE('2024-01-19', 'YYYY-MM-DD'));
INSERT INTO Bookings VALUES ('K024', 'C009', 1,'B009', 'E004', TO_DATE('2024-01-19', 'YYYY-MM-DD'));
INSERT INTO Bookings VALUES ('K025', 'C005', 1,'B009', 'E004', TO_DATE('2024-01-20', 'YYYY-MM-DD'));
INSERT INTO Bookings VALUES ('K026', 'C002', 1,'B019', 'E004', TO_DATE('2024-01-21', 'YYYY-MM-DD'));

-- Payment table
INSERT INTO Payment VALUES ('Y001', 'K001', TO_DATE('2022-04-20', 'YYYY-MM-DD'), 5599.98, 'Credit Card', 'INV001');
INSERT INTO Payment VALUES ('Y002', 'K002', TO_DATE('2022-04-21', 'YYYY-MM-DD'), 599.99, 'Debit Card', 'INV002');
INSERT INTO Payment VALUES ('Y003', 'K002', TO_DATE('2022-04-25', 'YYYY-MM-DD'), 3000.00, 'Debit Card', 'INV003');
INSERT INTO Payment VALUES ('Y004', 'K003', TO_DATE('2024-01-13', 'YYYY-MM-DD'), 11999.96, 'Credit Card', 'INV004');
INSERT INTO Payment VALUES ('Y005', 'K004', TO_DATE('2024-01-14', 'YYYY-MM-DD'), 1799.99, 'Bank Transfer', 'INV005');
INSERT INTO Payment VALUES ('Y006', 'K005', TO_DATE('2024-01-15', 'YYYY-MM-DD'), 12999.95, 'Credit Card', 'INV006');
INSERT INTO Payment VALUES ('Y007', 'K006', TO_DATE('2022-01-16', 'YYYY-MM-DD'), 5999.98, 'Credit Card', 'INV007');
INSERT INTO Payment VALUES ('Y008', 'K007', TO_DATE('2024-01-17', 'YYYY-MM-DD'), 9999.96, 'Debit Card', 'INV008');
INSERT INTO Payment VALUES ('Y009', 'K008', TO_DATE('2024-01-18', 'YYYY-MM-DD'), 8699.97, 'Credit Card', 'INV009');
INSERT INTO Payment VALUES ('Y010', 'K009', TO_DATE('2024-01-19', 'YYYY-MM-DD'), 2999.99, 'Bank Transfer', 'INV010');
INSERT INTO Payment VALUES ('Y011', 'K010', TO_DATE('2024-01-20', 'YYYY-MM-DD'), 2199.99, 'Credit Card', 'INV011');
INSERT INTO Payment VALUES ('Y012', 'K011', TO_DATE('2024-01-21', 'YYYY-MM-DD'), 2999.99, 'Credit Card', 'INV012');
INSERT INTO Payment VALUES ('Y013', 'K012', TO_DATE('2024-01-22', 'YYYY-MM-DD'), 5399.98, 'Debit Card', 'INV013');
INSERT INTO Payment VALUES ('Y014', 'K013', TO_DATE('2024-01-23', 'YYYY-MM-DD'), 5599.98, 'Credit Card', 'INV014');
INSERT INTO Payment VALUES ('Y015', 'K014', TO_DATE('2022-01-24', 'YYYY-MM-DD'), 9999.96, 'Bank Transfer', 'INV015');
INSERT INTO Payment VALUES ('Y016', 'K015', TO_DATE('2024-01-25', 'YYYY-MM-DD'), 5999.97, 'Credit Card', 'INV016');
INSERT INTO Payment VALUES ('Y017', 'K016', TO_DATE('2024-01-25', 'YYYY-MM-DD'), 5399.98, 'Credit Card', 'INV017');
INSERT INTO Payment VALUES ('Y018', 'K017', TO_DATE('2024-01-26', 'YYYY-MM-DD'), 5000.00, 'Debit Card', 'INV018');
INSERT INTO Payment VALUES ('Y019', 'K017', TO_DATE('2024-01-27', 'YYYY-MM-DD'), 4599.97, 'Debit Card', 'INV019');
INSERT INTO Payment VALUES ('Y020', 'K018', TO_DATE('2024-01-27', 'YYYY-MM-DD'), 1999.99, 'Credit Card', 'INV020');
INSERT INTO Payment VALUES ('Y021', 'K019', TO_DATE('2024-01-27', 'YYYY-MM-DD'), 2299.99, 'Bank Transfer', 'INV021');
INSERT INTO Payment VALUES ('Y022', 'K020', TO_DATE('2024-01-27', 'YYYY-MM-DD'), 2599.99, 'Credit Card', 'INV022');
INSERT INTO Payment VALUES ('Y023', 'K021', TO_DATE('2024-01-28', 'YYYY-MM-DD'), 2999.99, 'Credit Card', 'INV023');
INSERT INTO Payment VALUES ('Y024', 'K022', TO_DATE('2024-01-29', 'YYYY-MM-DD'), 3099.99, 'Credit Card', 'INV024');
INSERT INTO Payment VALUES ('Y025', 'K023', TO_DATE('2024-01-30', 'YYYY-MM-DD'), 3299.99, 'Credit Card', 'INV025');
INSERT INTO Payment VALUES ('Y026', 'K024', TO_DATE('2024-01-30', 'YYYY-MM-DD'), 2599.99, 'Credit Card', 'INV026');
INSERT INTO Payment VALUES ('Y027', 'K025', TO_DATE('2024-01-31', 'YYYY-MM-DD'), 2599.99, 'Credit Card', 'INV027');
INSERT INTO Payment VALUES ('Y028', 'K026', TO_DATE('2024-01-31', 'YYYY-MM-DD'), 999.99, 'Credit Card', 'INV028');
INSERT INTO Payment VALUES ('Y029', 'K026', TO_DATE('2024-01-31', 'YYYY-MM-DD'), 2000.00, 'Credit Card', 'INV029');

-- Review table
INSERT INTO Review VALUES ('R001', 'K001', 'Great experience!', 5, TO_DATE('2022-06-14', 'YYYY-MM-DD'));
INSERT INTO Review VALUES ('R002', 'K002', 'Could have been better.', 3, TO_DATE('2022-06-15', 'YYYY-MM-DD'));
INSERT INTO Review VALUES ('R003', 'K004', 'Very satisfied with the trip.', 5, TO_DATE('2024-07-01', 'YYYY-MM-DD'));
INSERT INTO Review VALUES ('R004', 'K005', 'Average experience.', 3, TO_DATE('2024-07-02', 'YYYY-MM-DD'));
INSERT INTO Review VALUES ('R005', 'K006', 'Excellent tour guide!', 5, TO_DATE('2024-07-03', 'YYYY-MM-DD'));
INSERT INTO Review VALUES ('R006', 'K007', 'Loved the accommodations.', 4, TO_DATE('2024-07-04', 'YYYY-MM-DD'));
INSERT INTO Review VALUES ('R007', 'K008', 'Disappointed with the service.', 2, TO_DATE('2024-07-08', 'YYYY-MM-DD'));
INSERT INTO Review VALUES ('R008', 'K009', 'Could be more organized.', 3, TO_DATE('2024-07-09', 'YYYY-MM-DD'));
INSERT INTO Review VALUES ('R009', 'K010', 'Highly recommend!', 5, TO_DATE('2024-07-10', 'YYYY-MM-DD'));
INSERT INTO Review VALUES ('R010', 'K011', 'Not what I expected.', 2, TO_DATE('2024-07-11', 'YYYY-MM-DD'));
INSERT INTO Review VALUES ('R011', 'K012', 'Best vacation ever!', 5, TO_DATE('2024-07-12', 'YYYY-MM-DD'));
INSERT INTO Review VALUES ('R012', 'K013', 'Pleasant experience.', 4, TO_DATE('2024-07-13', 'YYYY-MM-DD'));
INSERT INTO Review VALUES ('R013', 'K014', 'Needs improvement.', 2, TO_DATE('2024-07-14', 'YYYY-MM-DD'));
INSERT INTO Review VALUES ('R014', 'K015', 'Great customer service.', 4, TO_DATE('2024-07-15', 'YYYY-MM-DD'));
INSERT INTO Review VALUES ('R015', 'K016', 'Wonderful trip!', 5, TO_DATE('2024-07-16', 'YYYY-MM-DD'));
INSERT INTO Review VALUES ('R016', 'K017', 'Could be more affordable.', 3, TO_DATE('2024-07-17', 'YYYY-MM-DD'));
INSERT INTO Review VALUES ('R017', 'K018', 'Amazing destination!', 5, TO_DATE('2024-07-18', 'YYYY-MM-DD'));
INSERT INTO Review VALUES ('R018', 'K019', 'Disappointed with the hotel.', 2, TO_DATE('2024-07-19', 'YYYY-MM-DD'));
INSERT INTO Review VALUES ('R019', 'K020', 'Perfect getaway!', 5, TO_DATE('2024-07-20', 'YYYY-MM-DD')); 
INSERT INTO Review VALUES ('R020', 'K021', 'Had a great trip!', 5, TO_DATE('2024-07-21', 'YYYY-MM-DD')); 