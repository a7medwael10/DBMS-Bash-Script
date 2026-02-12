#!/bin/bash
echo "Existing Databases:"
ls databases 2>/dev/null
if [ $? -ne 0 ] || [ -z "$(ls -A databases)" ]; then
    echo "No databases found."
fi