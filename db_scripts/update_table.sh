#!/bin/bash

read -p "Enter table name: " table
meta_file="${table}.meta"
data_file="${table}.txt"

if [[ ! -f "$meta_file" ]] || [[ ! -f "$data_file" ]]; then
    echo "Table or metadata does not exist!"
    exit 1
fi

declare -a columns
declare -A col_types
pk_col=""
pk_index=-1


while IFS= read -r line; do
    IFS=':' read -r name type extra <<< "$line"
    columns+=("$name")
    col_types[$name]=$type
    if [[ "$extra" == "pk" ]]; then
        pk_col=$name
        pk_index=$(( ${#columns[@]} - 1 ))
    fi
done < "$meta_file"


if [[ -n "$pk_col" ]]; then
    read -p "Enter value of primary key ($pk_col) to update: " pk_val

    pk_field=$((pk_index + 1))
    line_num=$(awk -F, -v idx="$pk_field" -v val="$pk_val" '{
        if($idx==val){print NR; exit}
    }' "$data_file")
    if [[ -z "$line_num" ]]; then
        echo "No row found with $pk_col = $pk_val."
        exit 1
    fi
else
    read -p "No PRIMARY KEY defined. Enter line number to update (1 for first row): " line_num
    if ! [[ "$line_num" =~ ^[0-9]+$ ]] || [[ "$line_num" -le 0 ]]; then
        echo "Invalid line number."
        exit 1
    fi
    
    if [[ "$line_num" -gt $(wc -l < "$data_file") ]]; then
        echo "Line number exceeds file size."
        exit 1
    fi
fi


old_row=$(sed -n "${line_num}p" "$data_file")
IFS=',' read -ra old_values <<< "$old_row"


new_values=()
for i in "${!columns[@]}"; do
    col_name=${columns[$i]}
    col_type=${col_types[$col_name]}
    old_val=${old_values[$i]}
    while true; do
        read -p "Enter new value for $col_name ($col_type) [current: $old_val]: " val
        val=${val:-$old_val}


        if [[ "$col_type" == "int" && ! "$val" =~ ^[0-9]+$ ]]; then
            echo "Invalid type, must be integer."
            continue
        fi


        if [[ "$col_name" == "$pk_col" && "$val" != "$old_val" ]]; then
            pk_field=$((pk_index + 1))
            if awk -F, -v idx="$pk_field" -v val="$val" '{if($idx==val){exit 1}}' "$data_file"; then
                break
            else
                echo "Primary key must be unique."
                continue
            fi
        fi

        break
    done

    new_values+=("$val")
done

new_row=$(IFS=,; echo "${new_values[*]}")


tmp_file="${data_file}.tmp.$$"
awk -v ln="$line_num" -v row="$new_row" 'NR==ln{$0=row} {print}' "$data_file" > "$tmp_file" && mv "$tmp_file" "$data_file"

echo "Row updated successfully."
