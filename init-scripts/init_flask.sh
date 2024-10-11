#!/bin/bash

# Check if the project name is provided
if [ -z "$1" ]; then
    echo "Usage: $0 <project_name>"
    exit 1
fi

P_NAME=$1

# Create the project directory
mkdir "$P_NAME"
cd "$P_NAME" || exit

# Create a virtual environment
python3 -m venv .venv

# Activate the virtual environment
source .venv/bin/activate

# Ask for a specific version of Flask
echo "Do you want to use a specific version of Flask? (y/n)"
read -r is_version

# Write Flask version to requirements.txt if specified
if [[ "$is_version" == "y" || "$is_version" == "Y" ]]; then
    echo "Enter the version number:"
    read -r version_number
    echo "Flask==$version_number" > requirements.txt  # Use > instead of >> to overwrite
else
    echo "Flask" > requirements.txt  # Use > instead of >> to overwrite
    echo "No specific version number provided, using the latest version."
fi

echo "Do you want to enter additional packages? (y/n)"
read -r add_packages

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

# Directories and project structure
mkdir app
touch app/__init__.py

# Prompt for the name of the main file
echo "The name of the main file:"
echo "1. (y): same as project name"
echo "2. (write the name)"
read -r file_name_input

if [[ "$file_name_input" == "y" || "$file_name_input" == "Y" ]]; then
    touch "$P_NAME.py"
else
    touch "$file_name_input.py"
fi

# Corrected usage of echo to redirect into app/__init__.py
cat <<EOF > app/__init__.py
from flask import Flask

app = Flask(__name__)

from app import routes
EOF

touch app/routes.py

echo "Flask project initialized in $P_NAME"