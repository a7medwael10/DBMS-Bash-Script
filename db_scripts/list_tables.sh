#!/bin/bash
echo "Tables:"
ls *.txt 2>/dev/null | sed 's/.txt//'
