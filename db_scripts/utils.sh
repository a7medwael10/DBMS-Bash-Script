#!/bin/bash

clear_screen() {
    clear
}

pause() {
    echo
    read -n 1 -s -r -p "Press any key to return..."
    clear
}
