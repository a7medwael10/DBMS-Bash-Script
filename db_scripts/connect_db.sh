#!/bin/bash
source db_scripts/utils.sh

read -p "Enter database name to connect: " dbname
if [ ! -d "databases/$dbname" ]; then
    echo "Database does not exist!"
    pause
    exit
fi

cd "databases/$dbname" || exit

while true; do
    clear_screen
    echo "=================================="
    echo "        Database: $dbname"
    echo "=================================="
    echo "1. Create Table"
    echo "2. List Tables"
    echo "3. Insert Into Table"
    echo "4. Select From Table"
    echo "5. Delete From Table"
    echo "6. Update Table"
    echo "7. Back to Main Menu"
    read -p "Enter choice: " ch

      case $ch in
        1) ../../db_scripts/create_table.sh; pause ;;
        2) ../../db_scripts/list_tables.sh; pause ;;
        3) ../../db_scripts/insert_table.sh; pause ;;
        4) ../../db_scripts/select_table.sh; pause ;;
        5) ../../db_scripts/delete_table.sh; pause ;;
        6) ../../db_scripts/update_table.sh; pause ;;
        7) cd ../../; break ;;
        *) echo "Invalid choice!" ;;
    esac
done
