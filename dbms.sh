#!/bin/bash

source db_scripts/utils.sh
mkdir -p databases

while true; do
    clear_screen
    echo "=================================="
    echo "      Bash DBMS Main Menu"
    echo "=================================="
    echo "1. Create Database"
    echo "2. List Databases"
    echo "3. Connect to Database"
    echo "4. Drop Database"
    echo "5. Exit"
    read -p "Enter choice: " choice

    case $choice in
        1) ./db_scripts/create_db.sh 
        pause ;;
        2) ./db_scripts/list_db.sh 
        pause ;;
        3) ./db_scripts/connect_db.sh ;;
        4) ./db_scripts/drop_db.sh
        pause ;;
        5) echo "Goodbye!"; exit ;;
        *) echo "Invalid choice!" ;;
    esac
done

