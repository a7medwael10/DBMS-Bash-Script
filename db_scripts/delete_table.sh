#!/bin/bash
clear_screen() {
    clear
}

pause() {
    echo
    read -n 1 -s -r -p "Press any key to return..."
    clear
}

read -p "Enter table name: " table
if [ ! -f "$table.txt" ]; then
    echo "Table does not exist!"
    exit
fi


pk_col=""
pk_index=0
while IFS=':' read -r name type extra; do
    if [[ "$extra" == "pk" ]]; then
        pk_col="$name"
        break
    fi
    pk_index=$((pk_index + 1))
done < "$table.meta"

if [[ -n "$pk_col" ]]; then

    read -p "Enter value of primary key ($pk_col) to delete: " pk_val
    pk_field=$((pk_index + 1))

    if awk -F, -v idx="$pk_field" -v val="$pk_val" '{if($idx==val){found=1}} END{exit !found}' "$table.txt"; then
        awk -F, -v idx="$pk_field" -v val="$pk_val" '{if($idx!=val){print}}' "$table.txt" > temp.txt && mv temp.txt "$table.txt"
        echo "Row deleted successfully."
    else
        echo "No row found with $pk_col = $pk_val."
    fi
else

    read -p "No PRIMARY KEY defined. Enter line number to delete: " line_num
    if ! [[ "$line_num" =~ ^[0-9]+$ ]] || [[ "$line_num" -le 0 ]]; then
        echo "Invalid line number."
        exit 1
    fi
    
    if [[ "$line_num" -gt $(wc -l < "$table.txt") ]]; then
        echo "Line number exceeds file size."
        exit 1
    fi
    
    awk -v ln="$line_num" 'NR!=ln' "$table.txt" > temp.txt && mv temp.txt "$table.txt"
    echo "Row deleted successfully."
fi
