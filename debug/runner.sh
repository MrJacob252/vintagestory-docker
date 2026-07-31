#!/bin/bash

# Loop continuously until the user types 'exit' or presses Ctrl+C
while true; do
    # Display prompt and wait for user input
    read -p "Enter a command to run (or 'exit' to quit): " user_cmd

    # Exit if the user types 'exit' or enters nothing/whitespace
    if [[ "$user_cmd" == "exit" ]]; then
        echo "Exiting."
        break
    fi

    # Skip empty inputs (if the user just hits Enter)
    if [[ -z "$user_cmd" ]]; then
        continue
    fi

    echo "----------------------------------------"
    # Execute the user's input directly
    eval "$user_cmd"
    echo "----------------------------------------"
    echo ""
done
