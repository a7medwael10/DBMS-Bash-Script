#!/bin/bash
read -p "Enter database name to drop: " dbname
if [ -d "databases/$dbname" ]; then
    rm -r "databases/$dbname"
    echo "Database '$dbname' deleted."
else
    echo "Database does not exist!"
fi
