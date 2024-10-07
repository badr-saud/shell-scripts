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

# Ask for a specific version of Django
echo "Do you want to use a specific version of Django? (y/n)"
read -r is_version

# Write Django version to requirements.txt if specified
if [[ "$is_version" == "y" || "$is_version" == "Y" ]]; then
  echo "Enter the version number:"
  read -r version_number
  echo "Django==$version_number" >>requirements.txt
else
  echo "Django" >>requirements.txt
  echo "No specific version number provided, using the latest version."
fi

echo "Do you want to enter additional packages? (y/n)"
read -r add_packages

# If additional packages are needed, add them to requirements.txt
if [[ "$add_packages" == "y" || "$add_packages" == "Y" ]]; then
  echo "Enter the packages you want to install (space-separated):"
  read -r -a packages_arr

  # Loop through the array of packages and append each to requirements.txt
  for value in "${packages_arr[@]}"; do
    echo "$value" >>requirements.txt
  done
else
  echo "No additional packages will be installed."
fi

# Install the packages listed in requirements.txt
pip install -r requirements.txt

echo "Django initialized in $P_NAME"
