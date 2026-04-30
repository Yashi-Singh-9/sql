# GRANT and REVOKE

`GRANT` and `REVOKE` are SQL commands used to **control user permissions** and manage access to database objects. They play a crucial role in maintaining database **security** and **access control**.

## GRANT

The `GRANT` command is used to **assign privileges** on database objects to users or roles.

### Common Privileges
- `SELECT`
- `INSERT`
- `UPDATE`
- `DELETE`
- `EXECUTE`
- `REFERENCES`

### Purpose of GRANT
- Allows users to perform specific actions
- Enables role-based access control
- Helps implement the **principle of least privilege**

## REVOKE

The `REVOKE` command is used to **remove previously granted privileges** from users or roles.

### Purpose of REVOKE
- Restricts access to sensitive data
- Prevents unauthorized operations
- Adjusts permissions as roles or responsibilities change

## Importance of GRANT and REVOKE

Using these commands allows database administrators to:
- Fine-tune access control
- Protect sensitive information
- Ensure compliance with security policies
- Manage permissions without modifying application code

## Summary

`GRANT` and `REVOKE` are essential SQL security tools for managing who can access and modify database objects. Proper use of these commands ensures controlled access, improved security, and adherence to best practices in database management.