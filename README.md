# Database-Fundamentals

## ✨ Project Name: **T&J Travel Agency Database System**  

### 📝 Brief Description:  
This project is a **comprehensive database system** designed for **T&J Travel Agency**, a small and medium-sized enterprise specializing in **personalized travel experiences** ✈️. The database manages **customer information, bookings, packages, destinations, payments, employees, reviews, and hotels**, enabling the agency to **streamline operations, enhance customer satisfaction, and improve marketing strategies**.  

---  

## 🔑 **Key Features / What It Does:**  

1. **👥 Customer Management** – Tracks customer details, including contact information, marital status, and booking history.  
2. **📅 Booking System** – Manages travel bookings, including the number of travelers, booking dates, and associated batches.  
3. **🌍 Package & Destination Management** – Stores details of travel packages, destinations, and associated hotels.  
4. **💳 Payment Tracking** – Records payment details for bookings, including payment methods and invoice numbers.  
5. **👨‍💼 Employee Management** – Maintains employee records, including roles, salaries, and hierarchical relationships.  
6. **⭐ Review System** – Captures customer feedback and ratings to improve services.  
7. **⚖️ Business Rules Enforcement** – Implements constraints (e.g., marital status validation, payment method restrictions).  
8. **🔍 Query Capabilities** – Provides insights into customer behavior, high-value customers, and inactive customers for targeted marketing.  

---  

## 🛠 **Technologies Used:**  

- **🗃️ Database Management System**: Oracle SQL (for table creation, constraints, and queries).  
- **📊 Modeling Tool**: ERD (Entity-Relationship Diagram) for visualizing database structure.  
- **📜 SQL Scripting**: Used to implement the database schema, insert sample data, and perform complex queries.  
- **⚡ Indexing**: Optimizes query performance for frequently accessed fields (e.g., package price, review ratings).  

---  

## 🚀 **Setup/Installation Instructions:**  

### **Prerequisites:**  
- **Oracle Database** installed and running.  
- **SQL client** (e.g., SQL*Plus, Oracle SQL Developer) to execute scripts.  

### **Steps:**  

1. **📥 Clone or Download the Project** – Obtain the SQL script file (`Database Assignment Group 66 (Softcopy).docx`).  
2. **⚙️ Execute the Script**  
   - Open the SQL script in your SQL client.  
   - Run the script to create tables, constraints, indexes, and insert sample data.  
     ```sql
     -- Example: Execute the entire script in Oracle SQL Developer or SQL*Plus.
     ```  
3. **✅ Verify the Database**  
   - Check that all tables are created (e.g., `Customers`, `Bookings`, `Package`, etc.).  
   - Confirm sample data is inserted by running simple queries like:  
     ```sql
     SELECT * FROM Customers;
     SELECT * FROM Bookings;
     ```  
4. **🔎 Run Queries**  
   - Use the provided queries (Part 4 of the script) to analyze data, such as identifying high-value customers or inactive users.  
   - Example query to find high-value customers:  
     ```sql
     SELECT c.CustomerID, c.CustName, SUM(p.PayPrice) AS TotalSpent
     FROM Customers c
     JOIN Bookings b ON c.CustomerID = b.CustomerID
     JOIN Payment p ON b.BookingID = p.BookingID
     GROUP BY c.CustomerID, c.CustName
     HAVING SUM(p.PayPrice) > 2000;
     ```  

### **📌 Notes:**  
- Ensure all constraints (e.g., `CHECK` for gender or payment methods) are enforced during data insertion.  
- The **ERD diagram** (included in the document) provides a **visual guide** to the database schema.  

---  

This database system empowers **T&J Travel Agency** to efficiently manage operations, personalize customer experiences, and make **data-driven decisions** for business growth. 🚀 For further assistance, refer to the detailed documentation in the attached file.  

💡 **Happy Travels & Happy Querying!** ✈️📊
 
