# Data Integrity and Security

Data integrity and security in SQL involve the measures, rules, and mechanisms used to ensure that data remains **accurate, consistent, reliable, and protected** within a database system.

## Data Integrity

Data integrity ensures that information stored in the database is correct and remains valid over time.

### Integrity Mechanisms

- **Primary Keys** – Uniquely identify each record  
- **Foreign Keys** – Maintain referential integrity between tables  
- **Unique Constraints** – Prevent duplicate values  
- **NOT NULL Constraints** – Ensure required fields are populated  
- **CHECK Constraints** – Enforce specific value rules  
- **Transactions** – Maintain consistency through ACID properties  

These mechanisms help prevent invalid, inconsistent, or orphaned data.

## Data Security

Data security focuses on protecting data from unauthorized access, misuse, or corruption.

### Security Measures

- **User Authentication** – Verifies user identity  
- **Authorization & Roles** – Controls access permissions  
- **GRANT and REVOKE Commands** – Manage user privileges  
- **Encryption** – Protects sensitive data at rest and in transit  
- **Database Backups** – Safeguard against data loss  
- **Audit Logging** – Tracks database activity and changes  

## Why Data Integrity and Security Matter

They are essential for:
- Protecting sensitive and confidential information  
- Ensuring reliable business operations  
- Maintaining compliance with regulations  
- Preventing data corruption and unauthorized changes  

## Summary

Data integrity and security are foundational to database management. By combining constraints, transaction control, access management, encryption, and backups, SQL systems ensure that data remains accurate, consistent, and secure against threats and errors.