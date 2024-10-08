#!/bin/bash
# Purpose: Push the development branch and avoid any interaction with the main branch
# Usage: ./push-development-branch.sh <version> <annotation>
# Description: This script pushes the development branch only and calls another script 'git.sh'
# with the version and annotation.

# Function to print messages with a timestamp
print_message() {
    echo ""
    echo "$(date +"%Y-%m-%d %H:%M:%S") - $1"
}

# Function to display help message
show_help() {
    echo "Usage: $0 <version> <annotation>"
    echo ""
    echo "Options:"
    echo "  -h, --help     Display this help message."
    echo ""
    echo "Description:"
    echo "This script pushes the development branch with the specified version,"
    echo "and calls another script 'git.sh' with the version and annotation."
    exit 0
}

# Function to handle errors
handle_error() {
    print_message "Error: $1"
    exit 1
}

# Parse options
while [[ "$#" -gt 0 ]]; do
    case $1 in
        -h|--help) show_help ;;
        *) break ;;
    esac
    shift
done

# Check if exactly two arguments are passed
if (( $# != 2 )); then
    handle_error "Incorrect number of arguments. Usage: $0 <version> <annotation>"
fi

# Assign arguments to variables
VERSION=$1
ANNOTATION=$2

# Verify 'git.sh' script exists and is executable
GIT_SCRIPT="./git.sh"
if [[ ! -x "$GIT_SCRIPT" ]]; then
    handle_error "'git.sh' script not found or not executable"
fi

# Call git.sh script for tagging or other operations
print_message "Calling git.sh with tag $VERSION with annotation \"$ANNOTATION\""
"$GIT_SCRIPT" "$VERSION" "$ANNOTATION" || handle_error "Failed to call git.sh"

# Check out the development branch
print_message "Checking out development branch"
git checkout development || handle_error "Failed to checkout development branch"

# Push the development branch
print_message "Pushing development branch to origin"
git push origin development || handle_error "Failed to push development branch"

# Show git status
print_message "Git status"
git status || handle_error "Failed to show git status"

print_message "Script completed successfully"
