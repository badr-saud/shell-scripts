#!/bin/bash

# Check if the project name is provided
if [ -z "$1" ]; then
    echo "Usage: $0 <project_name>"
    exit 1
fi

P_NAME=$1

echo "Do you want to enter additional packages? (y/n)"
read -r add_packages

# Create the project directory
mkdir "$P_NAME"
cd "$P_NAME" || exit

# Create a virtual environment
python3 -m venv .venv

# Activate the virtual environment
source .venv/bin/activate

# Write 'flask' to requirements.txt
echo "flask" >> requirements.txt

if [[ "$add_packages" == "y" || "$add_packages" == "Y" ]]; then
    echo "Enter the packages you want to install (space-separated):"
    read -a packages_arr

    # Loop through the array of packages and append each to requirements.txt
    for value in "${packages_arr[@]}"; do 
        echo "$value" >> requirements.txt
    done
else
    echo "No additional packages will be installed."
fi

pip install -r requirements.txt

echo "Flask project initialized in $P_NAME"

