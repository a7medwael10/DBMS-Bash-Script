#!/bin/bash

read -p "Enter table name: " table
meta_file="${table}.meta"
data_file="${table}.txt"

if [[ ! -f "$meta_file" ]] || [[ ! -s "$data_file" ]]; then
    echo "Table is empty or does not exist."
    exit 1
fi

columns=()
col_names=()
while IFS=':' read -r name type extra; do
    col_names+=("$name")
    if [[ "$extra" == "pk" ]]; then
        columns+=("$name(PK)")
    else
        columns+=("$name")
    fi
done < "$meta_file"

col_widths=()
for i in "${!col_names[@]}"; do
    max_len=${#columns[i]}
    while IFS= read -r line; do
        val=$(echo "$line" | cut -d',' -f$((i+1)))
        (( ${#val} > max_len )) && max_len=${#val}
    done < "$data_file"
    col_widths[i]=$max_len
done


print_separator() {
    sep="+"
    for w in "${col_widths[@]}"; do
        sep+=$(printf '%*s' "$((w+2))" '' | tr ' ' '-')
        sep+="+"
    done
    echo "$sep"
}

print_separator


row="|"
for i in "${!columns[@]}"; do
    row+=" $(printf "%-${col_widths[i]}s" "${columns[i]}") |"
done
echo "$row"

print_separator

while IFS= read -r line; do
    row="|"
    for i in "${!col_names[@]}"; do
        val=$(echo "$line" | cut -d',' -f$((i+1)))
        row+=" $(printf "%-${col_widths[i]}s" "$val") |"
    done
    echo "$row"
done < "$data_file"

print_separator
