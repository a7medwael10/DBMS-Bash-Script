#!/bin/bash

echo -n "Enter table name: "
read table_name


data_file="${table_name}.txt"
meta_file="${table_name}.meta"


if [[ -f "$meta_file" ]] || [[ -f "$data_file" ]]; then
    echo "Table already exists!"
    exit 1
fi


touch "$data_file"
> "$meta_file"  

columns=()
types=()
pk_set=0

echo -n "Enter number of columns: "
read num_cols

for (( i=1; i<=num_cols; i++ ))
do
    while true; do
        echo -n "Enter name for column $i: "
        read col_name
        if [[ -z "$col_name" ]]; then
            echo "Column name cannot be empty. Try again."
        elif [[ " ${columns[*]} " == *" $col_name "* ]]; then
            echo "Column name already exists. Try again."
        else
            break
        fi
    done

    while true; do
        echo -n "Enter type for column '$col_name' (int, str): "
        read col_type
        if [[ "$col_type" == "int" || "$col_type" == "str" ]]; then
            break
        else
            echo "Invalid type. Only int or str allowed."
        fi
    done


    if [[ $pk_set -eq 0 ]]; then
        echo -n "Do you want '$col_name' to be PRIMARY KEY? (y/n): "
        read pk_choice
        if [[ "$pk_choice" == "y" || "$pk_choice" == "Y" ]]; then
            pk_set=1
            columns+=("$col_name:pk")
        else
            columns+=("$col_name")
        fi
    else
        columns+=("$col_name")
    fi
    types+=("$col_type")
done


if [[ $pk_set -eq 0 ]]; then
    echo "No PRIMARY KEY was set."
    echo "Columns available: ${columns[*]}"
    while true; do
        echo -n "Enter the column name to set as PRIMARY KEY (or leave blank for none): "
        read pk_col
        if [[ -z "$pk_col" ]]; then
            break
        elif [[ " ${columns[*]} " == *" $pk_col "* ]]; then
            for idx in "${!columns[@]}"; do
                if [[ "${columns[$idx]}" == "$pk_col" ]]; then
                    columns[$idx]="${columns[$idx]}:pk"
                fi
            done
            break
        else
            echo "Invalid column name. Try again."
        fi
    done
fi


for idx in "${!columns[@]}"; do
    col="${columns[$idx]}"
    type="${types[$idx]}"
    if [[ $col == *":pk"* ]]; then
        echo "${col%%:*}:$type:pk" >> "$meta_file"
    else
        echo "$col:$type" >> "$meta_file"
    fi
done

echo "Table Created Successfully!"
echo "Table Name: $table_name"
echo "Columns:"
for col in "${columns[@]}"; do
    if [[ $col == *":pk"* ]]; then
        echo " - ${col%%:*} (PRIMARY KEY)"
    else
        echo " - $col"
    fi
done
