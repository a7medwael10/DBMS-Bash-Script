# Bash DBMS Project

## Project Overview
This project is a simple **Database Management System (DBMS)** built using **Bash scripting** on Linux.  
It simulates basic database operations through shell scripts without using any external database engine.

The system allows users to manage databases and tables directly from the terminal.

---

## Features

### Database Operations
- Create a new database
- List all existing databases
- Connect to a specific database
- Drop (delete) a database

### Table Operations
- Create a table
- List tables
- Insert data into a table
- Select data from a table
- Update table records
- Delete table records

---

## Project Structure

db_scripts/
│
├── connect_db.sh # Connect to a database
├── create_db.sh # Create a new database
├── drop_db.sh # Delete a database
├── list_db.sh # List all databases
│
├── create_table.sh # Create a new table
├── delete_table.sh # Delete a table
├── insert_table.sh # Insert records
├── select_table.sh # Retrieve records
├── update_table.sh # Update records
├── list_tables.sh # List tables in database
│
└── utils.sh # Helper functions

---

## How It Works

- Each database is represented as a directory.
- Each table is stored as a file inside its database directory.
- Data is stored in text format.
- Metadata such as column names and data types are managed within the table files.

---

## How to Run

1. Clone the repository:
```bash
git clone <your-repo-link>
cd db_scripts
chmod +x *.sh
./create_db.sh
