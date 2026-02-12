#!/bin/bash

read -p "Enter table name: " table
meta_file="${table}.meta"
data_file="${table}.txt"


if [[ ! -f "$meta_file" ]]; then
    echo "Table does not exist!"
    exit 1
fi


columns=()
types=()
pk_col=""
while IFS=':' read -r name type extra; do
    columns+=("$name")
    types+=("$type")
    if [[ "$extra" == "pk" ]]; then
        pk_col="$name"
    fi
done < "$meta_file"


declare -A row

for i in "${!columns[@]}"; do
    col_name="${columns[$i]}"
    col_type="${types[$i]}"

    while true; do
        read -p "Enter value for $col_name ($col_type): " val
        val=$(echo "$val" | xargs) 
        


        if [[ "$col_type" == "int" && ! "$val" =~ ^[0-9]+$ ]]; then
            echo "Value must be integer."
            continue
        fi


        if [[ "$col_name" == "$pk_col" ]]; then
            if [[ -f "$data_file" ]]; then

                pk_index=0
                for j in "${!columns[@]}"; do
                    if [[ "${columns[$j]}" == "$pk_col" ]]; then
                        pk_index=$((j+1))
                        break
                    fi
                done

                exists=$(awk -F, -v idx="$pk_index" -v val="$val" '$idx==val {print $idx}' "$data_file")
                if [[ -n "$exists" ]]; then
                    echo "Primary key must be unique."
                    continue
                fi
            fi
        fi

        row[$col_name]="$val"
        break
    done
done


values=""
for col_name in "${columns[@]}"; do
    values+="${row[$col_name]},"
done
values=${values::-1} 

echo "$values" >> "$data_file"
echo "Row inserted successfully."
