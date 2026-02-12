#!/bin/bash


read -p "Enter database name: " dbname
if [ -d "databases/$dbname" ]; then
    echo "Database already exists!"
else
    mkdir "databases/$dbname"
    echo "Database '$dbname' created successfully."
fi
